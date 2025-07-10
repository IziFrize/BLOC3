# insert_data.py
import psycopg2
import pandas as pd
import os
import uuid
from datetime import datetime
from dotenv import load_dotenv
from metrics import errors_total, last_insert_count, runs_total, processing_duration

load_dotenv()
DATA_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data")

DB_NAME = os.getenv("POSTGRES_DB")
DB_USER = os.getenv("POSTGRES_USER")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD")
DB_HOST = os.getenv("DB_HOST")
session_id = str(uuid.uuid4())

ID_COLUMNS = ["client_id", "carte_id", "transaction_id", "magasin_id", "produit_id", "camera_id", "capteur_id", "detail_id"]

def log_operation(table_name, operation, level, message, status="OK"):
    try:
        cursor.execute("""
            INSERT INTO "log" (table_name, operation, timestamp, level, session_id, status, message)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (table_name, operation, datetime.now(), level, session_id, status, message))
    except Exception as log_error:
        print(f"[CRITICAL] Impossible d’écrire dans la table de log : {log_error}")
        errors_total.inc()

def insert_csv_to_table(csv_file, table_name):
    try:
        df = pd.read_csv(os.path.join(DATA_DIR, csv_file), sep=",", engine="python")

        if df.empty:
            log_operation(table_name, "insert", "warning", "fichier vide")
            return

        df.columns = [col.strip() for col in df.columns]
        df = df.astype(str)

        insert_count = 0
        for _, row in df.iterrows():
            try:
                if table_name == "Details_Transactions":
                    cursor.execute("SELECT 1 FROM Transactions WHERE transaction_id = %s LIMIT 1", (row["transaction_id"],))
                    if not cursor.fetchone():
                        log_operation(table_name, "insert", "error", f"transaction_id {row['transaction_id']} inexistant")
                        errors_total.inc()
                        continue

                columns = ', '.join(row.index)
                placeholders = ', '.join(['%s'] * len(row))
                sql = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders}) ON CONFLICT DO NOTHING"
                cursor.execute(sql, tuple(row))
                insert_count += 1
            except Exception as row_err:
                log_operation(table_name, "insert", "error", str(row_err))
                errors_total.inc()

        log_operation(table_name, "insert", "info", f"import terminé : {insert_count} lignes insérées")
        last_insert_count.set(insert_count)

    except Exception as e:
        log_operation(table_name, "insert", "error", str(e))
        errors_total.inc()


try:
    import time
    runs_total.inc()
    with processing_duration.time():
        conn = psycopg2.connect(
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST,
            port=5432
        )
        conn.autocommit = True
        cursor = conn.cursor()
        print("Connexion PostgreSQL réussie — exécution du script Python")

        insert_csv_to_table("Clients.csv", "Clients")
        insert_csv_to_table("Cartes_de_Fid_lit_.csv", "Cartes_Fidelite")
        insert_csv_to_table("Magasins.csv", "Magasins")
        insert_csv_to_table("Produits.csv", "Produits")
        insert_csv_to_table("Transactions.csv", "Transactions")
        insert_csv_to_table("D_tails_des_Transactions.csv", "Details_Transactions")
        insert_csv_to_table("Cam_ras_Intelligentes.csv", "Cameras")
        insert_csv_to_table("Capteurs_IoT.csv", "Capteurs_IoT")

        print("Script terminé avec succès.")

except psycopg2.OperationalError as e:
    print(f"[CRITICAL] Échec de la connexion à la base de données : {e}")
    errors_total.inc()
    exit(1)
