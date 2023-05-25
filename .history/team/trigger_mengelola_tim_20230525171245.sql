CREATE OR REPLACE FUNCTION captain_registration_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Is_Captain = true THEN
        -- Check if the team already has a captain
        IF EXISTS (
            SELECT *
            FROM Pemain
            WHERE Nama_Tim = NEW.Nama_Tim
                AND Is_Captain = true
        ) THEN
            -- Remove the existing captain
            UPDATE Pemain
            SET Is_Captain = false
            WHERE Nama_Tim = NEW.Nama_Tim
                AND Is_Captain = true;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER captain_registration_trigger
BEFORE INSERT OR UPDATE ON Pemain
FOR EACH ROW
EXECUTE FUNCTION captain_registration_trigger();