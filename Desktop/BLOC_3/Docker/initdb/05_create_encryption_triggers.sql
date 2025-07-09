-- 🔐 Triggers pour chiffrement automatique des colonnes sensibles

-- CLIENTS
CREATE OR REPLACE FUNCTION encrypt_clients_trigger()
RETURNS TRIGGER AS $$
BEGIN
  NEW.nom := encrypt_column(NEW.nom);
  NEW.prenom := encrypt_column(NEW.prenom);
  NEW.email := encrypt_column(NEW.email);
  NEW.date_naissance := encrypt_column(NEW.date_naissance);
  NEW.sexe := encrypt_column(NEW.sexe);
  NEW.ville := encrypt_column(NEW.ville);
  NEW.date_inscription := encrypt_column(NEW.date_inscription);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_encrypt_clients
BEFORE INSERT OR UPDATE ON clients
FOR EACH ROW EXECUTE FUNCTION encrypt_clients_trigger();

-- CARTES FIDELITE
CREATE OR REPLACE FUNCTION encrypt_cartes_fidelite_trigger()
RETURNS TRIGGER AS $$
BEGIN
  NEW.date_creation := encrypt_column(NEW.date_creation);
  NEW.points := encrypt_column(NEW.points);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_encrypt_cartes_fidelite
BEFORE INSERT OR UPDATE ON cartes_fidelite
FOR EACH ROW EXECUTE FUNCTION encrypt_cartes_fidelite_trigger();

-- MAGASINS
CREATE OR REPLACE FUNCTION encrypt_magasins_trigger()
RETURNS TRIGGER AS $$
BEGIN
  NEW.nom := encrypt_column(NEW.nom);
  NEW.adresse := encrypt_column(NEW.adresse);
  NEW.ville := encrypt_column(NEW.ville);
  NEW.code_postal := encrypt_column(NEW.code_postal);
  NEW.region := encrypt_column(NEW.region);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_encrypt_magasins
BEFORE INSERT OR UPDATE ON magasins
FOR EACH ROW EXECUTE FUNCTION encrypt_magasins_trigger();

-- PRODUITS
CREATE OR REPLACE FUNCTION encrypt_produits_trigger()
RETURNS TRIGGER AS $$
BEGIN
  NEW.nom := encrypt_column(NEW.nom);
  NEW.categorie := encrypt_column(NEW.categorie);
  NEW.prix := encrypt_column(NEW.prix);
  NEW.stock := encrypt_column(NEW.stock);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_encrypt_produits
BEFORE INSERT OR UPDATE ON produits
FOR EACH ROW EXECUTE FUNCTION encrypt_produits_trigger();

-- TRANSACTIONS
CREATE OR REPLACE FUNCTION encrypt_transactions_trigger()
RETURNS TRIGGER AS $$
BEGIN
  NEW.date_achat := encrypt_column(NEW.date_achat);
  NEW.montant_total := encrypt_column(NEW.montant_total);
  NEW.mode_paiement := encrypt_column(NEW.mode_paiement);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_encrypt_transactions
BEFORE INSERT OR UPDATE ON transactions
FOR EACH ROW EXECUTE FUNCTION encrypt_transactions_trigger();

-- DETAILS TRANSACTIONS
CREATE OR REPLACE FUNCTION encrypt_details_transactions_trigger()
RETURNS TRIGGER AS $$
BEGIN
  NEW.quantite := encrypt_column(NEW.quantite);
  NEW.prix_unitaire := encrypt_column(NEW.prix_unitaire);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_encrypt_details_transactions
BEFORE INSERT OR UPDATE ON details_transactions
FOR EACH ROW EXECUTE FUNCTION encrypt_details_transactions_trigger();

-- CAMERAS
CREATE OR REPLACE FUNCTION encrypt_cameras_trigger()
RETURNS TRIGGER AS $$
BEGIN
  NEW.date_heure := encrypt_column(NEW.date_heure);
  NEW.nombre_clients := encrypt_column(NEW.nombre_clients);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_encrypt_cameras
BEFORE INSERT OR UPDATE ON cameras
FOR EACH ROW EXECUTE FUNCTION encrypt_cameras_trigger();

-- CAPTEURS IOT
CREATE OR REPLACE FUNCTION encrypt_capteurs_trigger()
RETURNS TRIGGER AS $$
BEGIN
  NEW.niveau_stock := encrypt_column(NEW.niveau_stock);
  NEW.date_maj := encrypt_column(NEW.date_maj);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_encrypt_capteurs
BEFORE INSERT OR UPDATE ON capteurs_iot
FOR EACH ROW EXECUTE FUNCTION encrypt_capteurs_trigger();
