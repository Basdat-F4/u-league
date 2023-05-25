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

SET SEARCH_PATH TO "u-league";

CREATE OR REPLACE FUNCTION coach_insert_trigger()
RETURNS TRIGGER AS $$
DECLARE
    coach_count INTEGER;
    existing_specializations INTEGER;
    new_specialization VARCHAR(50);
BEGIN
    -- Check the number of coaches for the team
    SELECT COUNT(*) INTO coach_count
    FROM Pelatih
    WHERE Nama_Tim = NEW.Nama_Tim;

    IF coach_count = 1 THEN
        -- Get the specialization of the existing coach
        SELECT COUNT(DISTINCT Spesialisasi) INTO existing_specializations
        FROM Spesialisasi_Pelatih
        WHERE ID_Pelatih = (
            SELECT ID_Pelatih
            FROM Pelatih
            WHERE Nama_Tim = NEW.Nama_Tim
        );

        -- Get the specialization of the new coach
        SELECT Spesialisasi INTO new_specialization
        FROM Spesialisasi_Pelatih
        WHERE ID_Pelatih = NEW.ID_Pelatih;

        -- Check if the new coach has the same specialization as the existing coach
        IF existing_specializations = 1 AND EXISTS (
            SELECT 1
            FROM Spesialisasi_Pelatih
            WHERE ID_Pelatih = (
                SELECT ID_Pelatih
                FROM Pelatih
                WHERE Nama_Tim = NEW.Nama_Tim
            )
            AND Spesialisasi = new_specialization
        ) THEN
            RAISE EXCEPTION 'Error: The coach already has the same specialization.';
        END IF;
    END IF;

    IF coach_count >= 2 THEN
        -- Two coaches already exist, raise an error
        RAISE EXCEPTION 'Error: The team already has two coaches.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER pelatih_insert
BEFORE INSERT OR UPDATE ON Pelatih
FOR EACH ROW
EXECUTE FUNCTION coach_insert_trigger();