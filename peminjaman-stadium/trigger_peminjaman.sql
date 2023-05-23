CREATE OR REPLACE FUNCTION VALIDATE_PEMINJAMAN_STADIUM() RETURNS trigger AS
$$
DECLARE
    occupied_start_datetime TIMESTAMP;
    occupied_end_date_time TIMESTAMP;
BEGIN

SELECT start_datetime, end_datetime into occupied_start_datetime, occupied_end_date_time FROM peminjaman
WHERE
    id_stadium=NEW.id_stadium
    AND (start_datetime, end_datetime) OVERLAPS (NEW.start_datetime, NEW.end_datetime);
IF (FOUND) THEN RAISE EXCEPTION 'Jadwal sudah terisi oleh peminjaman lain dari % sampai %', occupied_start_datetime, occupied_end_date_time;
END IF;

SELECT start_datetime, end_datetime FROM pertandingan into occupied_start_datetime, occupied_end_date_time
WHERE
    id_stadium=NEW.id_stadium
    AND (start_datetime, end_datetime) OVERLAPS (NEW.start_datetime, NEW.end_datetime);
IF (FOUND) THEN RAISE EXCEPTION 'Jadwal sudah terisi oleh pertandingan lain dari % sampai %', occupied_start_datetime, occupied_end_date_time;
END IF;

END;
$$
LANGUAGE plpgsql;

--
-- TRIGGER for peminjaman
--

CREATE TRIGGER CHECK_PEMINJAMAN_STADIUM_VALIDITY
BEFORE INSERT OR UPDATE
ON peminjaman
FOR EACH ROW EXECUTE PROCEDURE VALIDATE_PEMINJAMAN_STADIUM();

CREATE TRIGGER CHECK_JADWAL_PERTANDINGAN_VALIDITY
BEFORE INSERT OR UPDATE
ON pertandingan
FOR EACH ROW EXECUTE PROCEDURE VALIDATE_PEMINJAMAN_STADIUM();