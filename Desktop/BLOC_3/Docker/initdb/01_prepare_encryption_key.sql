CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 🔐 Fonction de chiffrement
CREATE OR REPLACE FUNCTION encrypt_column(value TEXT)
RETURNS BYTEA AS $$
DECLARE
  encrypted BYTEA;
BEGIN
  IF value IS NULL THEN
    RETURN NULL;
  END IF;
  encrypted := pgp_sym_encrypt(value, current_setting('app.encryption_key'));
  RETURN encrypted;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 🔓 Fonction de déchiffrement
CREATE OR REPLACE FUNCTION decrypt_column(data BYTEA)
RETURNS TEXT AS $$
DECLARE
  decrypted TEXT;
BEGIN
  IF data IS NULL THEN
    RETURN NULL;
  END IF;
  decrypted := pgp_sym_decrypt(data, current_setting('app.encryption_key'));
  RETURN decrypted;
END;
$$ LANGUAGE plpgsql STABLE;
