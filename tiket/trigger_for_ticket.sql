--
-- stored procedure for ticket
--

CREATE OR REPLACE FUNCTION VALIDATE_TICKET() RETURNS trigger AS
$$
DECLARE
	gameTicketNum INT;
	ticketCapacity INT;
	ticketSoldNum INT;

BEGIN

SELECT COUNT(*) into gameTicketNum
FROM PEMBELIAN_TIKET
WHERE id_penonton = NEW.id_penonton
AND id_pertandingan = NEW.id_pertandingan
GROUP BY id_penonton;

SELECT S.kapasitas into ticketCapacity
FROM PERTANDINGAN P JOIN STADIUM S
ON P.stadium = S.id_stadium
WHERE P.id_pertandingan = NEW.id_pertandingan;

SELECT COUNT(*) into ticketSoldNum
FROM PEMBELIAN_TIKET
WHERE id_pertandingan = NEW.id_pertandingan
GROUP BY id_pertandingan;

IF (ticketSoldNum >= ticketCapacity) THEN
	RAISE EXCEPTION 'Tiket untuk pertandingan sudah habis';
END IF;

IF (gameTicketNum >= 5) THEN 
	RAISE EXCEPTION 'Hanya dapat memesan 5 tiket untuk 1 pertandingan';
END IF;

RETURN NEW;

END
$$
LANGUAGE plpgsql;

--
-- TRIGGER for ticket
--

CREATE TRIGGER CHECK_TICKET_VALIDITY 
BEFORE INSERT ON PEMBELIAN_TIKET
FOR EACH ROW EXECUTE PROCEDURE VALIDATE_TICKET();