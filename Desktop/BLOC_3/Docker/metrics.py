# metrics.py
from prometheus_client import Counter, Summary, Gauge


runs_total = Counter("smartretail_runs_total", "Nombre total d'exécutions de smartretail_app")


processing_duration = Summary("smartretail_processing_duration_seconds", "Temps de traitement des données")


errors_total = Counter("smartretail_errors_total", "Nombre total d’erreurs rencontrées dans smartretail_app")


last_insert_count = Gauge("smartretail_last_insert_count", "Dernier nombre de lignes insérées")
