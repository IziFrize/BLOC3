-- 🧾 Déchiffrement des colonnes pour chaque table contenant des données sensibles

-- 📍 CLIENTS
CREATE OR REPLACE VIEW v_clients_decrypted AS
SELECT
  client_id,
  decrypt_column(nom::bytea) AS nom,
  decrypt_column(prenom::bytea) AS prenom,
  decrypt_column(email::bytea) AS email,
  decrypt_column(date_naissance::bytea) AS date_naissance,
  decrypt_column(sexe::bytea) AS sexe,
  decrypt_column(ville::bytea) AS ville,
  decrypt_column(date_inscription::bytea) AS date_inscription
FROM clients;

-- 🎫 CARTES FIDÉLITÉ
CREATE OR REPLACE VIEW v_cartes_fidelite_decrypted AS
SELECT
  carte_id,
  client_id,
  decrypt_column(date_creation::bytea) AS date_creation,
  decrypt_column(points::bytea) AS points
FROM cartes_fidelite;

-- 🏬 MAGASINS
CREATE OR REPLACE VIEW v_magasins_decrypted AS
SELECT
  magasin_id,
  decrypt_column(nom::bytea) AS nom,
  decrypt_column(adresse::bytea) AS adresse,
  decrypt_column(ville::bytea) AS ville,
  decrypt_column(code_postal::bytea) AS code_postal,
  decrypt_column(region::bytea) AS region
FROM magasins;

-- 📦 PRODUITS
CREATE OR REPLACE VIEW v_produits_decrypted AS
SELECT
  produit_id,
  decrypt_column(nom::bytea) AS nom,
  decrypt_column(categorie::bytea) AS categorie,
  decrypt_column(prix::bytea) AS prix,
  decrypt_column(stock::bytea) AS stock
FROM produits;

-- 💰 TRANSACTIONS
CREATE OR REPLACE VIEW v_transactions_decrypted AS
SELECT
  transaction_id,
  client_id,
  magasin_id,
  decrypt_column(date_achat::bytea) AS date_achat,
  decrypt_column(montant_total::bytea) AS montant_total,
  decrypt_column(mode_paiement::bytea) AS mode_paiement
FROM transactions;

-- 🧾 DÉTAILS DES TRANSACTIONS
CREATE OR REPLACE VIEW v_details_transactions_decrypted AS
SELECT
  detail_id,
  transaction_id,
  produit_id,
  decrypt_column(quantite::bytea) AS quantite,
  decrypt_column(prix_unitaire::bytea) AS prix_unitaire
FROM details_transactions;

-- 🎥 CAMÉRAS
CREATE OR REPLACE VIEW v_cameras_decrypted AS
SELECT
  camera_id,
  magasin_id,
  decrypt_column(date_heure::bytea) AS date_heure,
  decrypt_column(nombre_clients::bytea) AS nombre_clients
FROM cameras;

-- 📡 CAPTEURS IoT
CREATE OR REPLACE VIEW v_capteurs_iot_decrypted AS
SELECT
  capteur_id,
  produit_id,
  magasin_id,
  decrypt_column(niveau_stock::bytea) AS niveau_stock,
  decrypt_column(date_maj::bytea) AS date_maj
FROM capteurs_iot;
