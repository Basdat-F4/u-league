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

-- Trigger function for Pelatih table
CREATE OR REPLACE FUNCTION pelatih_insert_trigger()
RETURNS TRIGGER AS $$
DECLARE
    pelatih_count INTEGER;
    spesialisasi_count INTEGER;
BEGIN
    -- Check the number of coaches for the team
    SELECT COUNT(*) INTO pelatih_count
    FROM Pelatih
    WHERE Nama_Tim = NEW.Nama_Tim;

    -- Check the number of specializations for the coach
    SELECT COUNT(*) INTO spesialisasi_count
    FROM Spesialisasi_Pelatih
    WHERE ID_Pelatih = NEW.ID_Pelatih;

    IF pelatih_count = 0 THEN
        -- No coach for the team, insert the new coach
        INSERT INTO Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat)
        VALUES (NEW.ID_Pelatih, NEW.Nama_Depan, NEW.Nama_Belakang, NEW.Nomor_HP, '', '');

        RETURN NEW;
    ELSIF pelatih_count = 1 THEN
        -- One coach already exists, check for different specialization
        IF spesialisasi_count > 0 THEN
            RAISE EXCEPTION 'Error: The coach already has a specialization.';
        ELSE
            INSERT INTO Non_Pemain (ID
