CREATE TABLE Clients (
    client_id TEXT PRIMARY KEY,
    nom TEXT,
    prenom TEXT,
    email TEXT,
    date_naissance TEXT,
    sexe TEXT,
    ville TEXT,
    date_inscription TEXT
);

CREATE TABLE Cartes_Fidelite (
    carte_id TEXT PRIMARY KEY,
    client_id TEXT REFERENCES Clients(client_id),
    date_creation TEXT,
    points TEXT
);

CREATE TABLE Magasins (
    magasin_id TEXT PRIMARY KEY,
    nom TEXT,
    adresse TEXT,
    ville TEXT,
    code_postal TEXT,
    region TEXT
);

CREATE TABLE Produits (
    produit_id TEXT PRIMARY KEY,
    nom TEXT,
    categorie TEXT,
    prix TEXT,
    stock TEXT
);

CREATE TABLE Transactions (
    transaction_id TEXT PRIMARY KEY,
    client_id TEXT REFERENCES Clients(client_id),
    magasin_id TEXT REFERENCES Magasins(magasin_id),
    date_achat TEXT,
    montant_total TEXT,
    mode_paiement TEXT
);

CREATE TABLE Details_Transactions (
    detail_id TEXT PRIMARY KEY,
    transaction_id TEXT REFERENCES Transactions(transaction_id),
    produit_id TEXT REFERENCES Produits(produit_id),
    quantite TEXT,
    prix_unitaire TEXT
);

CREATE TABLE Cameras (
    camera_id TEXT PRIMARY KEY,
    magasin_id TEXT REFERENCES Magasins(magasin_id),
    date_heure TEXT,
    nombre_clients TEXT
);

CREATE TABLE Capteurs_IoT (
    capteur_id TEXT PRIMARY KEY,
    produit_id TEXT REFERENCES Produits(produit_id),
    magasin_id TEXT REFERENCES Magasins(magasin_id),
    niveau_stock TEXT,
    date_maj TEXT
);

CREATE TABLE log (
    log_id SERIAL PRIMARY KEY,
    table_name TEXT,
    operation TEXT,
    timestamp TIMESTAMP,
    level TEXT,           -- ex: INFO, WARNING, ERROR
    session_id UUID,      -- identifiant unique d’exécution
    status TEXT,
    message TEXT
);