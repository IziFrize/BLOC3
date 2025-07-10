
CREATE OR REPLACE VIEW v_clients_decrypted AS
SELECT
  client_id,
  decrypt_column(nom::bytea)::text AS nom,
  decrypt_column(prenom::bytea)::text AS prenom,
  decrypt_column(email::bytea)::text AS email,
  decrypt_column(date_naissance::bytea)::date AS date_naissance,
  decrypt_column(sexe::bytea)::text AS sexe,
  decrypt_column(ville::bytea)::text AS ville,
  decrypt_column(date_inscription::bytea)::timestamp AS date_inscription
FROM clients;


CREATE OR REPLACE VIEW v_cartes_fidelite_decrypted AS
SELECT
  carte_id,
  client_id,
  decrypt_column(date_creation::bytea)::timestamp AS date_creation,
  decrypt_column(points::bytea)::int AS points
FROM cartes_fidelite;


CREATE OR REPLACE VIEW v_magasins_decrypted AS
SELECT
  magasin_id,
  decrypt_column(nom::bytea)::text AS nom,
  decrypt_column(adresse::bytea)::text AS adresse,
  decrypt_column(ville::bytea)::text AS ville,
  decrypt_column(code_postal::bytea)::text AS code_postal,
  decrypt_column(region::bytea)::text AS region
FROM magasins;


CREATE OR REPLACE VIEW v_produits_decrypted AS
SELECT
  produit_id,
  decrypt_column(nom::bytea)::text AS nom,
  decrypt_column(categorie::bytea)::text AS categorie,
  decrypt_column(prix::bytea)::numeric AS prix,
  decrypt_column(stock::bytea)::int AS stock
FROM produits;


CREATE OR REPLACE VIEW v_transactions_decrypted AS
SELECT
  transaction_id,
  client_id,
  magasin_id,
  decrypt_column(date_achat::bytea)::timestamp AS date_achat,
  decrypt_column(montant_total::bytea)::numeric AS montant_total,
  decrypt_column(mode_paiement::bytea)::text AS mode_paiement
FROM transactions;


CREATE OR REPLACE VIEW v_details_transactions_decrypted AS
SELECT
  detail_id,
  transaction_id,
  produit_id,
  decrypt_column(quantite::bytea)::int AS quantite,
  decrypt_column(prix_unitaire::bytea)::numeric AS prix_unitaire
FROM details_transactions;


CREATE OR REPLACE VIEW v_cameras_decrypted AS
SELECT
  camera_id,
  magasin_id,
  decrypt_column(date_heure::bytea)::timestamp AS date_heure,
  decrypt_column(nombre_clients::bytea)::int AS nombre_clients
FROM cameras;


CREATE OR REPLACE VIEW v_capteurs_iot_decrypted AS
SELECT
  capteur_id,
  produit_id,
  magasin_id,
  decrypt_column(niveau_stock::bytea)::int AS niveau_stock,
  decrypt_column(date_maj::bytea)::timestamp AS date_maj
FROM capteurs_iot;
