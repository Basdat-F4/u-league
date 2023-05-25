--
-- table structure for u-league
--
-- --------------------------------------------------------
CREATE SCHEMA "u-league";

SET SEARCH_PATH TO "u-league";


--
-- table structure for table user_system
--

CREATE TABLE User_System (
Username VARCHAR(50) PRIMARY KEY,
Password VARCHAR(20) NOT NULL
);

--
-- table structure for table Tim
--

CREATE TABLE Tim (
Nama_Tim VARCHAR(50),
Universitas VARCHAR(50) NOT NULL,
PRIMARY KEY(Nama_Tim)
);

--
-- table structure for table pemain
--

CREATE TABLE Pemain (
ID_Pemain UUID PRIMARY KEY,
Nama_Tim VARCHAR(50) REFERENCES Tim(Nama_Tim),
Nama_Depan VARCHAR(50) NOT NULL,
Nama_Belakang VARCHAR(50) NOT NULL,
Nomor_HP VARCHAR(15) NOT NULL,
Tgl_Lahir DATE NOT NULL,
Is_Captain BOOLEAN NOT NULL,
Posisi VARCHAR(50) NOT NULL,
NPM VARCHAR(20) NOT NULL,
Jenjang VARCHAR(20) NOT NULL
);

--
-- table structure for table non_pemain
--

CREATE TABLE Non_Pemain (
ID UUID PRIMARY KEY,
Nama_Depan VARCHAR(50) NOT NULL,
Nama_Belakang VARCHAR(50) NOT NULL,
Nomor_HP VARCHAR(15) NOT NULL,
Email VARCHAR(50) NOT NULL,
Alamat VARCHAR(255) NOT NULL 
);

--
-- table structure for table Wasit
--

CREATE TABLE Wasit (
ID_Wasit UUID PRIMARY KEY REFERENCES Non_Pemain(ID),
Lisensi VARCHAR(50) NOT NULL
);

--
-- table structure for table Status_Non_Pemain
--

CREATE TABLE Status_Non_Pemain (
ID_Non_Pemain UUID REFERENCES Non_Pemain(ID),
Status VARCHAR(50) NOT NULL,
PRIMARY KEY(ID_Non_Pemain, Status)
);

--
-- table structure for table Stadium
--

CREATE TABLE Stadium (
ID_Stadium UUID PRIMARY KEY,
Nama VARCHAR(50) NOT NULL,
Alamat VARCHAR(50) NOT NULL,
Kapasitas INT NOT NULL
);

--
-- table structure for table Perlengkapan Stadium
--

CREATE TABLE Perlengkapan_Stadium (
ID_Stadium UUID REFERENCES Stadium(ID_Stadium),
Item VARCHAR(255) NOT NULL,
Kapasitas INT NOT NULL,
PRIMARY KEY(ID_Stadium, Item, Kapasitas)
);

--
-- table structure for table Pertandingan
--

CREATE TABLE Pertandingan (
ID_Pertandingan UUID PRIMARY KEY,
Start_Datetime DATE NOT NULL,
End_Datetime DATE NOT NULL,
Stadium UUID REFERENCES Stadium(ID_Stadium)
);

--
-- table structure for table Peristiwa
--

CREATE TABLE Peristiwa (
ID_Pertandingan UUID REFERENCES Pertandingan(ID_Pertandingan),
Datetime TIMESTAMP NOT NULL,
Jenis VARCHAR(50) NOT NULL,
ID_Pemain UUID REFERENCES Pemain(ID_Pemain),
PRIMARY KEY(ID_Pertandingan, Datetime)
);

--
-- table structure for table Wasit_Bertugas
--

CREATE TABLE Wasit_Bertugas (
ID_Wasit UUID,
ID_Pertandingan UUID,
Posisi_Wasit VARCHAR(50) NOT NULL,
PRIMARY KEY (ID_Wasit, ID_Pertandingan),
FOREIGN KEY (ID_Wasit) REFERENCES Wasit(ID_Wasit),
FOREIGN KEY (ID_Pertandingan) REFERENCES Pertandingan(ID_Pertandingan)
);

--
-- table structure for table Penonton
--

CREATE TABLE Penonton (
ID_Penonton UUID,
Username VARCHAR(50),
PRIMARY KEY (ID_Penonton),
FOREIGN KEY (ID_Penonton) REFERENCES Non_Pemain(ID),
FOREIGN KEY (Username) REFERENCES User_System(Username)
);

--
-- table structure for table Pembelian_Tiket
--

CREATE TABLE Pembelian_Tiket (
Nomor_Receipt VARCHAR(50),
ID_Penonton UUID,
Jenis_Tiket VARCHAR(50) NOT NULL,
Jenis_Pembayaran VARCHAR(50) NOT NULL,
ID_Pertandingan UUID,
PRIMARY KEY(Nomor_Receipt),
FOREIGN KEY(ID_Penonton) REFERENCES Penonton(ID_Penonton),
FOREIGN KEY(ID_Pertandingan) REFERENCES Pertandingan(ID_Pertandingan)
);

--
-- table structure for table Panitia
--

CREATE TABLE Panitia (
ID_Panitia UUID,
Jabatan VARCHAR(50) NOT NULL,
Username VARCHAR(50),
PRIMARY KEY (ID_Panitia),
FOREIGN KEY (ID_Panitia) REFERENCES Non_Pemain(ID),
FOREIGN KEY (Username) REFERENCES User_System(Username)
);

--
-- table structure for table Pelatih
--

CREATE TABLE Pelatih (
ID_Pelatih UUID,
Nama_Tim VARCHAR(50),
PRIMARY KEY(ID_Pelatih),
FOREIGN KEY(ID_Pelatih) REFERENCES Non_Pemain(ID),
FOREIGN KEY(Nama_Tim) REFERENCES Tim(Nama_Tim)
);

--
-- table structure for Spesialisas_Pelatih
--

CREATE TABLE Spesialisasi_Pelatih (
ID_Pelatih UUID,
Spesialisasi VARCHAR(50),
PRIMARY KEY(ID_Pelatih,Spesialisasi),
FOREIGN KEY(ID_Pelatih) REFERENCES Pelatih(ID_Pelatih)
);

--
-- table structure for table Tim_Pertandingan
--

CREATE TABLE Tim_Pertandingan(
Nama_Tim VARCHAR(50),
ID_Pertandingan UUID,
Skor VARCHAR(50) NOT NULL,
PRIMARY KEY(Nama_Tim,ID_Pertandingan),
FOREIGN KEY(Nama_Tim) REFERENCES Tim(Nama_Tim),
FOREIGN KEY(ID_Pertandingan) REFERENCES Pertandingan(ID_Pertandingan)
);

--
-- table structure for table Manajer
--

CREATE TABLE Manajer (
ID_Manajer UUID PRIMARY KEY,
Username VARCHAR(50),
FOREIGN KEY (ID_Manajer) REFERENCES Non_Pemain (ID),
FOREIGN KEY (Username) REFERENCES User_System (Username)
);

--
-- table structure for table Tim_Manajer
--

CREATE TABLE Tim_Manajer (
ID_Manajer UUID,
Nama_Tim VARCHAR(50),
PRIMARY KEY (ID_Manajer, Nama_Tim),
FOREIGN KEY (ID_Manajer) REFERENCES Manajer (ID_Manajer),
FOREIGN KEY (Nama_Tim) REFERENCES Tim (Nama_Tim)
);

--
-- table structure for table Peminjaman
--

CREATE TABLE Peminjaman (
ID_Manajer UUID,
Start_Datetime TIMESTAMP NOT NULL,
End_Datetime TIMESTAMP NOT NULL,
ID_Stadium UUID,
PRIMARY KEY (ID_Manajer, Start_Datetime),
FOREIGN KEY (ID_Manajer) REFERENCES Manajer (ID_Manajer),
FOREIGN KEY (ID_Stadium) REFERENCES Stadium (ID_Stadium)
);

--
-- table structure for table Rapat
--

CREATE TABLE Rapat (
ID_Pertandingan UUID,
Datetime TIMESTAMP,
Perwakilan_Panitia UUID,
Manajer_Tim_A UUID,
Manajer_Tim_B UUID,
Isi_Rapat TEXT NOT NULL,
PRIMARY KEY (Datetime, Perwakilan_Panitia, Manajer_Tim_A, Manajer_Tim_B),
FOREIGN KEY (ID_Pertandingan) REFERENCES Pertandingan (ID_Pertandingan),
FOREIGN KEY (Perwakilan_Panitia) REFERENCES Panitia (ID_Panitia),
FOREIGN KEY (Manajer_Tim_A) REFERENCES Manajer (ID_Manajer),
FOREIGN KEY (Manajer_Tim_B) REFERENCES Manajer (ID_Manajer)
);


--
-- Dataset for u-league
--
--
-- Dumping data for table user_system
--
insert into User_System (Username, Password) values ('jharken0', 'pass123');
insert into User_System (Username, Password) values ('alythgoe1', 'pass123');
insert into User_System (Username, Password) values ('zwehnerr2', 'pass123');
insert into User_System (Username, Password) values ('pivoshin3', 'pass123');
insert into User_System (Username, Password) values ('pghest4', 'pass123');
insert into User_System (Username, Password) values ('marcher5', 'pass123');
insert into User_System (Username, Password) values ('cheindrick6', 'pass123');
insert into User_System (Username, Password) values ('mbarrowcliff7', 'pass123');
insert into User_System (Username, Password) values ('ifansy8', 'pass123');
insert into User_System (Username, Password) values ('bjordine9', 'pass123');
insert into User_System (Username, Password) values ('fmargareta', 'pass123');
insert into User_System (Username, Password) values ('mmuddb', 'pass123');
insert into User_System (Username, Password) values ('rbostockc', 'pass123');
insert into User_System (Username, Password) values ('bdallanderd', 'pass123');
insert into User_System (Username, Password) values ('plongeae', 'pass123');
insert into User_System (Username, Password) values ('rgentilef', 'pass123');
insert into User_System (Username, Password) values ('kvarnsg', 'pass123');
insert into User_System (Username, Password) values ('kabbatih', 'pass123');
insert into User_System (Username, Password) values ('gwillisoni', 'pass123');
insert into User_System (Username, Password) values ('bmaaszj', 'pass123');
insert into User_System (Username, Password) values ('mleithgoek', 'pass123');
insert into User_System (Username, Password) values ('lhordelll', 'pass123');
insert into User_System (Username, Password) values ('svanyukhinm', 'pass123');
insert into User_System (Username, Password) values ('fsanchezn', 'pass123');
insert into User_System (Username, Password) values ('cgermono', 'pass123');
insert into User_System (Username, Password) values ('icourtneyp', 'pass123');
insert into User_System (Username, Password) values ('epockeyq', 'pass123');
insert into User_System (Username, Password) values ('ccroyserr', 'pass123');
insert into User_System (Username, Password) values ('bwhellamss', 'pass123');
insert into User_System (Username, Password) values ('fteresiat', 'pass123');
insert into User_System (Username, Password) values ('gtuckeru', 'pass123');
insert into User_System (Username, Password) values ('sstirtlev', 'pass123');
insert into User_System (Username, Password) values ('avaulsw', 'pass123');
insert into User_System (Username, Password) values ('apirtx', 'pass123');
insert into User_System (Username, Password) values ('trosiniy', 'pass123');
insert into User_System (Username, Password) values ('clubertiz', 'pass123');
insert into User_System (Username, Password) values ('mhafner10', 'pass123');
insert into User_System (Username, Password) values ('gbrisker11', 'pass123');
insert into User_System (Username, Password) values ('jraddon12', 'pass123');
insert into User_System (Username, Password) values ('hfoyster13', 'pass123');
insert into User_System (Username, Password) values ('bbrayn14', 'pass123');
insert into User_System (Username, Password) values ('mseamon15', 'pass123');
insert into User_System (Username, Password) values ('rbernaert16', 'pass123');
insert into User_System (Username, Password) values ('mnoto17', 'pass123');
insert into User_System (Username, Password) values ('caggus18', 'pass123');
insert into User_System (Username, Password) values ('rtaynton19', 'pass123');
insert into User_System (Username, Password) values ('rbellee1a', 'pass123');
insert into User_System (Username, Password) values ('ebanat1b', 'pass123');
insert into User_System (Username, Password) values ('bbrezlaw1c', 'pass123');
insert into User_System (Username, Password) values ('hgatman1d', 'pass123');

--
-- 16. Dumping data for table Tim
--

INSERT INTO Tim VALUES ('AJ Auxerre','Central University of Technology, Free State'),
	('Cruzeiro Esporte Clube','International Bible College'),
	('Club Atletico Boca Juniors','James Cook University of North Queensland'),
	('Clube de Regatas do Flamengo','University of Hargeisa'),
	('Venezia','Hong Kong Baptist University'),
	('Borussia Monchengladbach','Basilicata University Potenza'),
	('AS Roma','Beijing University of Agriculture'),
	('Sampdoria','Mashhad University of Medical Sciences'),
	('Hertha Berliner Sport-Club','University of Neuchatel'),
	('RC Lens','Birsk State Pedagogical Institute');

--
-- Dumping data for table Pemain
--

INSERT INTO Pemain VALUES ('996ad860-2a9a-504f-8861-aeafd0b2ae29', 'Cruzeiro Esporte Clube', 'Liv', 'Murdie', '865-656-2953', '1987-02-07', 'true', 'penyerang', '7693943769', 'S3'),
	('59e06cf8-f390-5093-af2e-3685be593a25', 'Cruzeiro Esporte Clube', 'Norby', 'Brolechan', '838-736-9995', '1988-01-17', 'false', 'back sayap', '0469903570', 'S2'),
	('391ada15-580c-5baa-b16f-eeb35d9b1122', 'Cruzeiro Esporte Clube', 'Junina', 'Corteis', '308-336-5126', '2005-02-18', 'false', 'back sayap', '3942019250', 'S1'),
	('22fe83ae-a20f-54fc-b436-cec85c94c5e8', 'Cruzeiro Esporte Clube', 'Klemens', 'Trawin', '143-544-4040', '1998-05-27', 'false', 'gelandang serang', '4619069049', 'S2'),
	('b7d55bf4-7057-5113-85c8-141871bf7635', 'Cruzeiro Esporte Clube', 'Barn', 'McIan', '336-743-5734', '1995-03-07', 'false', 'back tengah', '1064334253', 'S2'),
	('1883fdfb-249b-58f5-b445-87dff6eabc06', 'Cruzeiro Esporte Clube', 'Bethina', 'Reisk', '394-426-8285', '1992-04-16', 'false', 'sayap', '3280581771', 'S1'),
	('d6ed313e-533a-55a6-aa06-4c00bc132812', 'Cruzeiro Esporte Clube', 'Kevan', 'Callan', '571-838-1422', '2004-01-16', 'false', 'gelandang bertahan', '2298486437', 'S1'),
	('9090025d-5d06-58f1-b79a-3690407024fc', 'Cruzeiro Esporte Clube', 'Elfrieda', 'Klimowicz', '285-362-2870', '1991-07-02', 'false', 'penyerang', '6841521182', 'S2'),
	('751af8b4-32a7-55bc-9fad-8bfbcbbf4237', 'Cruzeiro Esporte Clube', 'Devy', 'Cancelier', '975-658-5755', '2008-05-25', 'false', 'back sayap', '6521864236', 'S1'),
	('305f5e8d-e48d-5c3a-8ce3-446622dd8a8a', 'Cruzeiro Esporte Clube', 'Kamila', 'Bould', '587-666-1167', '2005-06-11', 'false', 'back sayap', '3631968448', 'S2'),
	('a4c08562-50fa-5599-939c-eb6f2a83a362', 'Cruzeiro Esporte Clube', 'Salomon', 'Feilden', '724-837-5659', '2000-11-29', 'false', 'back tengah', '0485555573', 'S2'),
	('d35aeaf3-5d1d-535a-a31a-22133ddf5f3d', 'Cruzeiro Esporte Clube', 'Jacobo', 'Barendtsen', '506-889-7198', '1980-01-26', 'false', 'penyerang', '3666254680', 'S2'),
	('61c97311-bb14-5679-99fc-98497a701292', 'Cruzeiro Esporte Clube', 'Mandie', 'Moncreiff', '249-797-7308', '2009-03-29', 'false', 'gelandang bertahan', '4436404604', 'S1'),
	('1bb138f7-5f19-587c-8a25-fb174eabf441', 'Cruzeiro Esporte Clube', 'Lilia', 'Kees', '551-331-4284', '2002-04-30', 'false', 'penyerang', '3718457350', 'S3'),
	('be6c2a5f-4160-5145-8695-c628496b208d', 'Club Atletico Boca Juniors', 'Korney', 'Arkley', '399-609-2973', '1997-06-03', 'true', 'kiper', '2836855214', 'S3'),
	('7dbed579-ec83-5f9b-8aa3-1c40e858acfc', 'Club Atletico Boca Juniors', 'Rosalynd', 'Dawtrey', '464-371-1485', '1998-04-19', 'false', 'kiper', '9738222594', 'S3'),
	('bcc896de-3c61-523e-973c-052f16456e28', 'Club Atletico Boca Juniors', 'Lissie', 'Aleswell', '307-650-9844', '1981-11-09', 'false', 'sayap', '0170123973', 'S2'),
	('77b34e74-5631-5a71-b8ce-97b9d6bab10a', 'Club Atletico Boca Juniors', 'Rachel', 'Bollom', '140-269-5860', '2002-08-11', 'false', 'sayap', '7957485123', 'S3'),
	('9d58db4d-28b7-56fc-9b12-db9a3e9d0769', 'Club Atletico Boca Juniors', 'Rudyard', 'Ruit', '892-642-6119', '1992-03-26', 'false', 'back tengah', '3495951508', 'S1'),
	('6fea451e-90db-5366-bbde-9a65b83f8f64', 'Club Atletico Boca Juniors', 'Staford', 'Farlow', '611-729-8651', '1995-05-01', 'false', 'penyerang', '3852538165', 'S3'),
	('0df2c324-4b3b-5e4b-8574-770c7c601dc4', 'Club Atletico Boca Juniors', 'Karly', 'Farnell', '687-338-9670', '1992-05-06', 'false', 'gelandang bertahan', '6304014773', 'S2'),
	('05596e20-ebb9-571a-9f7c-250cbacfb499', 'Club Atletico Boca Juniors', 'Ashien', 'McNamee', '893-906-8565', '1999-11-03', 'false', 'back sayap', '2604738316', 'S1'),
	('32b736a1-2bed-5f62-8131-c3dc9a2a33c7', 'Club Atletico Boca Juniors', 'Larissa', 'Ranklin', '800-310-9379', '2006-05-21', 'false', 'kiper', '3974960110', 'S2'),
	('29be4ef0-91eb-512b-8f83-360b6db38a83', 'Club Atletico Boca Juniors', 'Freemon', 'Lambis', '489-629-5140', '1990-06-11', 'false', 'back sayap', '7561460251', 'S1'),
	('46f64ca6-6094-51fc-bbbe-34e3333c5388', 'Club Atletico Boca Juniors', 'Adaline', 'Skelhorn', '238-845-4915', '1997-07-18', 'false', 'back sayap', '8865618163', 'S1'),
	('8df6e0fb-0d35-5fd6-831a-7e5b9ad2457a', 'Club Atletico Boca Juniors', 'Essy', 'Veltman', '122-245-3278', '1981-04-21', 'false', 'back sayap', '9985360411', 'S2'),
	('5151e75a-9d7d-5897-be85-aaa96757564b', 'Club Atletico Boca Juniors', 'Marabel', 'Dane', '244-118-5823', '2005-10-20', 'false', 'sayap', '3948567274', 'S1'),
	('21f6a510-8fff-5bed-9d0e-df7b2ca28db1', 'Club Atletico Boca Juniors', 'Dimitri', 'Bevar', '915-983-3299', '1992-12-24', 'false', 'sayap', '0811713865', 'S3'),
	('3eee96fe-b265-5e36-8d78-b2d50a9ac563', 'Clube de Regatas do Flamengo', 'Rollin', 'Milington', '646-900-5571', '1999-11-21', 'true', 'gelandang bertahan', '3598040537', 'S2'),
	('720073c2-6984-53fa-9546-b893e83e0f62', 'Clube de Regatas do Flamengo', 'Arlyn', 'Sarfas', '699-793-7090', '1989-11-06', 'false', 'gelandang serang', '7044606519', 'S1'),
	('b0526112-ddde-5dbf-b887-9b6f93557007', 'Clube de Regatas do Flamengo', 'Jena', 'Chable', '242-530-2580', '2000-10-23', 'false', 'back sayap', '3593845813', 'S1'),
	('b85b4ff7-2f5e-5d5d-bcda-728e00ad61de', 'Clube de Regatas do Flamengo', 'Dotti', 'Swann', '640-478-1264', '1994-06-21', 'false', 'back tengah', '6846420938', 'S3'),
	('7561fe4e-6ffd-5631-96d6-cf89fdadba83', 'Clube de Regatas do Flamengo', 'Sallyann', 'Khristoforov', '191-820-7906', '1992-03-31', 'false', 'sayap', '5790386615', 'S1'),
	('ae5a160a-ca64-5557-a0d8-1fdd610d83e1', 'Clube de Regatas do Flamengo', 'Zollie', 'Docwra', '282-807-0175', '2003-01-29', 'false', 'gelandang bertahan', '6932834813', 'S3'),
	('5429db33-2d2c-51e4-9b96-9918a6a67f07', 'Clube de Regatas do Flamengo', 'Austin', 'Alejandri', '268-569-1272', '1987-06-22', 'false', 'kiper', '2901279411', 'S2'),
	('214f116d-a5a3-5203-867d-28bcad2b6c1a', 'Clube de Regatas do Flamengo', 'Lettie', 'Haggith', '530-962-5031', '1990-10-09', 'false', 'kiper', '5900355630', 'S2'),
	('c18d0fc0-d829-5009-a349-094ea30c386b', 'Clube de Regatas do Flamengo', 'Donica', 'Eubank', '564-205-6542', '2002-07-25', 'false', 'penyerang', '6280285329', 'S1'),
	('c3205bf1-c929-5b45-af5a-42b59ab87391', 'Clube de Regatas do Flamengo', 'Alexina', 'Ganter', '546-255-3888', '1994-04-04', 'false', 'kiper', '1942042397', 'S2'),
	('6863109a-0444-5f87-b018-66483cb30f22', 'Clube de Regatas do Flamengo', 'Jilleen', 'Greenshields', '780-236-6940', '1993-08-07', 'false', 'gelandang serang', '2675331640', 'S1'),
	('b4ab3922-2b8d-5d9c-b20a-e34bbc64c01f', 'Clube de Regatas do Flamengo', 'Katharyn', 'Boor', '727-627-9680', '1991-03-13', 'false', 'back sayap', '3200421880', 'S3'),
	('08d2a401-c6d0-56d0-bfca-d8fe47a0ccde', 'Clube de Regatas do Flamengo', 'Mirella', 'Garz', '880-596-3507', '1987-03-31', 'false', 'back sayap', '9296552967', 'S1'),
	('ba293c61-ad33-57b9-9671-f3319f57d789', 'Clube de Regatas do Flamengo', 'Madlin', 'Duplan', '631-978-4381', '2001-03-06', 'false', 'back sayap', '0325916383', 'S3'),
	('45fae334-63fa-5064-9e45-024ff9e0095c', 'Venezia', 'Maryann', 'Monni', '922-723-8166', '1998-12-23', 'true', 'back tengah', '6029964367', 'S2'),
	('fce23375-fdd4-5b30-8e57-a401e5265ba1', 'Venezia', 'Vitoria', 'Tellesson', '852-408-7852', '2003-03-13', 'false', 'gelandang bertahan', '9916715318', 'S3'),
	('b5a095ae-2fa5-5416-a5c3-4b3e8a7d0f9c', 'Venezia', 'Reba', 'Yuryaev', '702-450-2932', '2006-03-18', 'false', 'back sayap', '1471961419', 'S2'),
	('8060dbbf-e5cc-5ed8-b6a8-9c463ae3f1ef', 'Venezia', 'Dee', 'Brugsma', '925-647-3464', '1987-06-15', 'false', 'gelandang bertahan', '4009213700', 'S3'),
	('36054888-8e10-578a-b964-a1e6efebf8bf', 'Venezia', 'Salem', 'Ivanuschka', '633-713-6037', '1989-11-30', 'false', 'kiper', '0090885635', 'S3'),
	('ae0f5d2b-52f8-5845-8572-d7c586982e02', 'Venezia', 'Dian', 'Tillot', '440-300-7920', '1981-07-14', 'false', 'gelandang serang', '9535552575', 'S3'),
	('651ee801-9621-5f6a-a42a-18c7cc80c352', 'Venezia', 'Audi', 'Goncalo', '918-646-5245', '1990-09-13', 'false', 'kiper', '3673286906', 'S1'),
	('5d9b0a1d-62ce-570c-ba61-24557b6f4e68', 'Venezia', 'Britte', 'O''Dougherty', '370-938-2019', '1991-09-22', 'false', 'back tengah', '7620635745', 'S2'),
	('0154a6f6-0e6c-52c4-b709-95aaead8423e', 'Venezia', 'Rene', 'Klainer', '234-763-4530', '1998-06-01', 'false', 'penyerang', '2055782319', 'S1'),
	('e0a97602-6480-588c-868f-bc044abf9cb5', 'Venezia', 'Eveline', 'Gillhespy', '608-559-0725', '1998-08-31', 'false', 'kiper', '9042095038', 'S2'),
	('f924209a-092e-58bb-b85e-4ceea176a660', 'Venezia', 'Rose', 'Durber', '255-941-7276', '1986-11-15', 'false', 'kiper', '1251250291', 'S2'),
	('e1d79fd9-d2be-5d43-9714-87cf2a8567e0', 'Venezia', 'Margo', 'Whewell', '905-128-7152', '1991-12-11', 'false', 'gelandang bertahan', '1346194480', 'S2'),
	('8a3edd46-2628-5d57-9865-13f273edf326', 'Venezia', 'Sim', 'McClancy', '105-639-4260', '1992-04-01', 'false', 'sayap', '3557033431', 'S2'),
	('6460a618-c69d-5751-9c53-2d03d46ade51', 'Venezia', 'Gilemette', 'Coorington', '495-547-3705', '1999-06-30', 'false', 'back tengah', '7068124569', 'S2'),
	('da992292-ffb1-5ab2-a6de-c19a9b0d0fd7', 'Borussia Monchengladbach', 'Kipp', 'Edlington', '377-186-7389', '1990-12-06', 'true', 'back tengah', '0488345147', 'S3'),
	('dcdd0263-6e8b-5cac-b79f-fe6a389a529a', 'Borussia Monchengladbach', 'Sibyl', 'Kuzemka', '747-956-0726', '1991-03-25', 'false', 'penyerang', '3707191774', 'S3'),
	('02df7727-e4b1-5359-b25a-27eb2ba414b0', 'Borussia Monchengladbach', 'Lola', 'Turneaux', '512-852-8433', '1999-11-14', 'false', 'gelandang bertahan', '0951361453', 'S2'),
	('7b2da8c5-bdc2-5d5a-b226-3e6746cf0d89', 'Borussia Monchengladbach', 'Aharon', 'Tomlins', '216-555-1348', '1984-10-16', 'false', 'gelandang serang', '0387069830', 'S1'),
	('397a09f8-fd35-5409-a27c-482947f05217', 'Borussia Monchengladbach', 'Hurlee', 'Sandy', '897-692-4894', '1983-07-12', 'false', 'gelandang bertahan', '6394283027', 'S1'),
	('c5ab2aae-6554-5bbe-bd14-997f20448114', 'Borussia Monchengladbach', 'Ranice', 'Mobberley', '927-856-9567', '2003-06-22', 'false', 'penyerang', '2379557395', 'S3'),
	('87c35800-783c-5bed-afab-7a6fab481c46', 'Borussia Monchengladbach', 'Suzy', 'Vigrass', '154-452-6149', '2007-03-12', 'false', 'back tengah', '8701146204', 'S3'),
	('ffd38492-0348-5b2d-8f08-3ff2ca0f4645', 'Borussia Monchengladbach', 'Garwood', 'Oulner', '311-463-9433', '1981-08-20', 'false', 'gelandang serang', '1406539535', 'S3'),
	('61361ec8-6dd5-59da-a79f-3509bad1a524', 'Borussia Monchengladbach', 'Lucy', 'Huge', '125-280-5013', '1993-07-17', 'false', 'back sayap', '0917454906', 'S1'),
	('8b691658-669a-56db-9e92-a20b2c99ec08', 'Borussia Monchengladbach', 'Vincenz', 'Pavlenko', '147-871-5459', '2004-08-06', 'false', 'gelandang bertahan', '1654353389', 'S1'),
	('e5bcfc44-a2bf-5e3e-8de7-7031b3ddff2e', 'Borussia Monchengladbach', 'Ulrich', 'Sill', '535-304-0890', '1992-12-31', 'false', 'sayap', '9422469901', 'S1'),
	('37a5ea60-8b87-58f5-9155-cfb6711b7e00', 'Borussia Monchengladbach', 'Calley', 'Shyres', '751-165-8633', '1981-01-21', 'false', 'kiper', '8870803252', 'S3'),
	('51a38ca6-6e81-549e-9790-41a1f4a96d3e', 'Borussia Monchengladbach', 'Andrej', 'Antognazzi', '272-980-2976', '2001-10-18', 'false', 'gelandang serang', '3156008487', 'S2'),
	('9e1fc8f8-d9e7-59ae-99a1-28465dcd0f6e', 'Borussia Monchengladbach', 'Celina', 'Crummy', '134-271-2514', '1995-01-09', 'false', 'back tengah', '3767617734', 'S3'),
	('e6c0ad59-a52e-5938-887a-8a411e97298a', 'AS Roma', 'Colman', 'Macellar', '571-187-4032', '1996-10-30', 'true', 'kiper', '9891399241', 'S1'),
	('ad407b82-5446-5ad6-8061-cf6bcd51b875', 'AS Roma', 'Dale', 'Elletson', '203-620-8751', '1992-02-25', 'false', 'kiper', '0971747576', 'S2'),
	('c25ac3f7-f861-51d9-991a-8db2fa1c4cb1', 'AS Roma', 'Flinn', 'Wainer', '386-469-8553', '1986-12-09', 'false', 'back tengah', '8821800904', 'S3'),
	('595487c4-7068-50fa-9768-19972d22e2cd', 'AS Roma', 'Edith', 'MacBrearty', '396-523-5725', '2001-12-16', 'false', 'penyerang', '6162391844', 'S2'),
	('ef8bdc6a-9d29-5791-9e94-d6678ba6b4de', 'AS Roma', 'Lilly', 'Girsch', '478-771-5172', '2004-02-24', 'false', 'penyerang', '2377953890', 'S1'),
	('f27890a1-f3b3-5142-a9b7-5297799d60dd', 'AS Roma', 'Rafa', 'Auld', '602-566-6984', '1985-05-18', 'false', 'gelandang bertahan', '6042798693', 'S3'),
	('d9ecf479-5e69-5001-b864-c71de51185a2', 'AS Roma', 'Colet', 'Dymoke', '506-208-4418', '1997-04-27', 'false', 'kiper', '5793337111', 'S2'),
	('5bdcce0f-16bb-56e0-ae00-36ef8437f653', 'AS Roma', 'Ardith', 'Stearley', '895-508-0167', '2002-02-04', 'false', 'gelandang bertahan', '0304786291', 'S3'),
	('734cdcf0-7107-550a-8e99-18ca5b1be1b7', 'AS Roma', 'Lilla', 'Grundy', '488-969-6706', '1987-03-11', 'false', 'penyerang', '7001180441', 'S1'),
	('9a6d4ea7-39e3-582e-bf94-fec1a5f9d685', 'AS Roma', 'Katha', 'Philippon', '468-630-1359', '1993-06-29', 'false', 'penyerang', '5396242838', 'S1'),
	('591315a4-dbca-5cc7-af08-cbeeac98178b', 'AS Roma', 'Marc', 'Wedlake', '202-289-2350', '2004-12-28', 'false', 'kiper', '3055713121', 'S3'),
	('1643c509-5bbe-5a87-bfa6-51b5ed07a83a', 'AS Roma', 'Tiffanie', 'Brounsell', '296-765-2969', '2003-06-18', 'false', 'penyerang', '5889679391', 'S2'),
	('312a6ee4-fdec-5229-86e2-e0df521cf306', 'AS Roma', 'Anthony', 'Gratten', '789-816-0619', '1984-10-31', 'false', 'back tengah', '7273881787', 'S2'),
	('f2b6f9a7-531d-5d97-9bf1-4177c33e5070', 'AS Roma', 'Jolene', 'Iliff', '711-689-0247', '1988-12-15', 'false', 'back tengah', '1672465886', 'S2'),
	('7bafb091-c361-5517-82a8-4d3d0809e9f9', 'Sampdoria', 'Arthur', 'Largen', '838-784-7809', '2003-10-10', 'true', 'penyerang', '0961787845', 'S1'),
	('f3cf4d43-6a2c-560d-9a2a-5c77331b913b', 'Sampdoria', 'Giuditta', 'Scudders', '681-658-3972', '1994-12-12', 'false', 'gelandang bertahan', '5568794413', 'S2'),
	('5981de99-b8e5-5048-a219-ab103e9cf914', 'Sampdoria', 'Selig', 'Gilhouley', '315-988-6326', '2002-11-21', 'false', 'back sayap', '6429277263', 'S2'),
	('4baeee02-b9b3-5ecd-9f1b-400dbac56b82', 'Sampdoria', 'Towney', 'O''Shea', '949-838-3187', '1984-08-16', 'false', 'back sayap', '8795223727', 'S3'),
	('21d1bd6c-49e3-5d81-a799-5af7da862936', 'Sampdoria', 'Mallissa', 'Enriquez', '854-870-8211', '2000-05-30', 'false', 'sayap', '9656585144', 'S1'),
	('2b173f18-8c74-5e19-a7d4-3212f74017a8', 'Sampdoria', 'Rockwell', 'Guittet', '213-973-2006', '1999-02-10', 'false', 'kiper', '7429859289', 'S3'),
	('0962b5eb-2409-5618-b05f-8569ea0dc35d', 'Sampdoria', 'Chandal', 'Pavitt', '474-561-1360', '2008-06-15', 'false', 'kiper', '8882989020', 'S2'),
	('28dbb2ff-741d-5333-b7e5-3f80aa14c1c6', 'Sampdoria', 'Ambrose', 'Deddum', '141-396-7338', '1983-02-13', 'false', 'gelandang serang', '0530374283', 'S3'),
	('4df2f065-ecff-52cf-bc07-6ff6b3ee09e3', 'Sampdoria', 'Helene', 'Goodbairn', '987-354-2879', '2003-06-23', 'false', 'gelandang serang', '9717585724', 'S3'),
	('9b99a42f-1ce6-52a0-90ea-5e234201500b', 'Sampdoria', 'Fransisco', 'Stratten', '734-851-8842', '1986-12-19', 'false', 'kiper', '6862033638', 'S2'),
	('7aae4a9a-e6b4-5a28-a978-e42b2ab8d101', 'Sampdoria', 'Aldrich', 'Koop', '609-994-3225', '1998-04-17', 'false', 'penyerang', '7060627850', 'S1'),
	('1a715879-7dba-5a42-b3c5-5a51b46e89e3', 'Sampdoria', 'Jayson', 'Maha', '823-735-5362', '2001-02-11', 'false', 'penyerang', '1510300907', 'S3'),
	('521fd768-7a4b-5e3e-89be-f7dd8886c93a', 'Sampdoria', 'Edgard', 'Goford', '740-713-1415', '1995-08-09', 'false', 'back tengah', '2899007119', 'S2'),
	('5c089632-6f1a-564f-b429-2955bdd874b9', 'Sampdoria', 'Errol', 'Feeley', '756-456-7639', '2000-12-13', 'false', 'back tengah', '8114741497', 'S2'),
	('429ae5d7-3799-5593-80e0-124f3d1d745c', 'Hertha Berliner Sport-Club', 'Sarene', 'Bradick', '234-589-3130', '1988-11-13', 'true', 'gelandang serang', '4910271345', 'S3'),
	('0e0d1ce5-d1bf-5fa3-ad2e-16ac0f4a09ce', 'Hertha Berliner Sport-Club', 'Cristobal', 'Hardwick', '568-597-0104', '1993-12-05', 'false', 'kiper', '1539719322', 'S1'),
	('f4dcc643-023d-5d78-8c15-6440a77bdaa5', 'Hertha Berliner Sport-Club', 'Zerk', 'Clayworth', '349-985-4189', '2006-06-17', 'false', 'gelandang bertahan', '9359958354', 'S1'),
	('1e87b2cb-937b-566a-9d91-b9346906a089', 'Hertha Berliner Sport-Club', 'Mikol', 'Papierz', '524-476-8321', '2002-05-05', 'false', 'penyerang', '0594184344', 'S2'),
	('a8d68fbf-bd6e-5461-a9d1-cf1bb3522e38', 'Hertha Berliner Sport-Club', 'Sheffie', 'Spoors', '354-241-1903', '1992-09-18', 'false', 'penyerang', '3197156497', 'S3'),
	('5ac9e002-7ee9-5996-85a8-81aee6245b2f', 'Hertha Berliner Sport-Club', 'Gunar', 'Foskett', '878-750-0983', '1995-12-02', 'false', 'kiper', '3436073710', 'S1'),
	('433627d8-25db-5910-bc62-a4a7c9bb46ee', 'Hertha Berliner Sport-Club', 'Reggis', 'Sarfatti', '829-555-3423', '2005-09-10', 'false', 'back tengah', '5339379033', 'S3'),
	('defc7e4d-5c10-5ae6-a39e-4c769dcddd16', 'Hertha Berliner Sport-Club', 'Burty', 'Karel', '871-414-1403', '1980-02-04', 'false', 'kiper', '8880642289', 'S2'),
	('4d208dbd-e748-55a8-b5a6-277519c28ba7', 'Hertha Berliner Sport-Club', 'Wynny', 'Mackerel', '893-689-9903', '1995-11-28', 'false', 'back sayap', '3684400066', 'S1'),
	('2bc68972-85bf-5649-b30e-882d49979a4f', 'Hertha Berliner Sport-Club', 'Rosamund', 'Zanettini', '612-822-5716', '1993-08-18', 'false', 'penyerang', '0627861712', 'S1'),
	('dc51ea82-01d5-516a-a436-2e67de02bef8', 'Hertha Berliner Sport-Club', 'Trixie', 'Benz', '126-244-1399', '2009-12-02', 'false', 'back sayap', '7360433954', 'S1'),
	('339d0599-3c01-51c8-8026-50e69c4c7175', 'Hertha Berliner Sport-Club', 'Corly', 'Piggins', '259-358-9646', '1992-03-09', 'false', 'back tengah', '6748802784', 'S3'),
	('fb4e21a3-5824-540f-88af-1de0a7a472a6', 'Hertha Berliner Sport-Club', 'Merle', 'Dray', '100-138-8571', '1980-12-27', 'false', 'kiper', '6061126769', 'S3'),
	('53859c4a-066f-5b06-89cf-dfa38ad94026', 'Hertha Berliner Sport-Club', 'Donna', 'Stent', '279-424-1741', '2007-02-03', 'false', 'gelandang bertahan', '6198047350', 'S3'),
	('2acbf600-dfa8-519a-bd54-5cbf6eb6f7d1', 'RC Lens', 'Waring', 'Darben', '454-116-5187', '1982-07-01', 'true', 'kiper', '9571570463', 'S2'),
	('21708e2e-2e2d-5fe1-a12a-f8e0cb4dbb7b', 'RC Lens', 'Page', 'Myrie', '594-193-5963', '2006-08-03', 'false', 'back sayap', '2789849016', 'S3'),
	('155270fb-fb4d-5086-bc16-1289ba541bf6', 'RC Lens', 'Olva', 'Pendell', '857-715-5526', '1988-03-07', 'false', 'gelandang serang', '3279606401', 'S1'),
	('ce048143-c17b-56b8-bd9f-99a93e682d5a', 'RC Lens', 'Tamar', 'Gudyer', '489-938-2011', '2000-10-30', 'false', 'gelandang bertahan', '0678285857', 'S1'),
	('8cf5bb1b-6aba-5479-9244-73f54450548f', 'RC Lens', 'Wilma', 'Le Borgne', '869-412-4245', '1982-09-28', 'false', 'gelandang serang', '5093024310', 'S1'),
	('510db773-9fb8-5084-a1c8-c465a40391e0', 'RC Lens', 'Horst', 'Lindeboom', '963-511-7561', '1989-10-18', 'false', 'gelandang bertahan', '4242405351', 'S2'),
	('33248502-684f-5935-8702-f8287a12e13b', 'RC Lens', 'Brynne', 'Ege', '744-457-3880', '1997-10-12', 'false', 'penyerang', '4720024585', 'S1'),
	('bea3a1d8-e7b4-5f6d-8e61-69c8a92e32ad', 'RC Lens', 'Hieronymus', 'MacTeague', '556-182-7007', '2002-06-20', 'false', 'back sayap', '6610025337', 'S3'),
	('5b63c113-5630-53fe-a769-39d5ba43be7e', 'RC Lens', 'Gamaliel', 'McKimmie', '130-396-9199', '1980-02-25', 'false', 'gelandang bertahan', '3583711139', 'S2'),
	('cc71e88d-47db-5010-b532-fbd62c9d058f', 'RC Lens', 'Price', 'Dunaway', '816-264-9316', '1992-07-06', 'false', 'back sayap', '0111951669', 'S3'),
	('3bce8de0-ab5d-5f8d-9b53-f3adce131b94', 'RC Lens', 'Trish', 'Hansman', '609-617-1354', '2005-11-11', 'false', 'penyerang', '5699062755', 'S1'),
	('fa391aea-3137-5bb9-845d-6db7d8fb041d', 'RC Lens', 'Daloris', 'Skace', '342-706-7355', '2004-07-20', 'false', 'gelandang serang', '4159430704', 'S3'),
	('21d4a6bf-edbb-58a1-af98-dd9dcaf77ed7', 'RC Lens', 'Daryle', 'Lydster', '627-992-6471', '2008-08-09', 'false', 'back sayap', '9265605733', 'S3'),
	('1ba78096-81f8-596d-a53a-8cdad00d0366', 'RC Lens', 'Giacobo', 'Skittle', '203-382-7720', '1985-02-04', 'false', 'back sayap', '3178794187', 'S2'),
	('2c9c0a40-acc8-53d3-8947-42782b8a90ef', 'AJ Auxerre', 'Madonna', 'Boyce', '113-165-3537', '2000-07-30', 'true', 'kiper', '8608951929', 'S2'),
	('238b0b9b-ac80-5515-86c7-932971f4c9e7', 'AJ Auxerre', 'Tedda', 'Gusticke', '525-250-0260', '2009-06-05', 'false', 'back tengah', '1380754553', 'S1'),
	('7a3a44b1-919a-514a-92aa-18715c5a2a7d', 'AJ Auxerre', 'Artur', 'Wrotchford', '518-557-0608', '1982-01-26', 'false', 'penyerang', '9968929708', 'S2'),
	('175ac5ff-49bf-543e-89d9-ad2b38be7f36', 'AJ Auxerre', 'Dianna', 'Sutheran', '620-711-9279', '1992-06-02', 'false', 'gelandang serang', '0200854546', 'S1'),
	('8ea32227-ba38-5c6f-8950-c1b7b73fab62', 'AJ Auxerre', 'Marketa', 'Crollman', '351-143-1481', '1992-11-18', 'false', 'sayap', '7075597152', 'S1'),
	('70cb5e24-ad38-5096-880c-02e1c54b7483', 'AJ Auxerre', 'Muffin', 'Fanton', '541-975-1114', '1990-09-18', 'false', 'gelandang serang', '3925976545', 'S2'),
	('bcd941ba-790d-51f9-a3a0-52abbc6b173d', 'AJ Auxerre', 'Irwinn', 'Bettinson', '991-177-7317', '1986-11-28', 'false', 'gelandang bertahan', '4309526378', 'S2'),
	('5c7ef325-af56-5cea-a65d-b2f1b48280ab', 'AJ Auxerre', 'Welbie', 'Slany', '623-973-3891', '2009-04-01', 'false', 'kiper', '7798986289', 'S2'),
	('cb43e6c2-3dd6-50de-a014-8207e36e3686', 'AJ Auxerre', 'Conny', 'Comelli', '705-207-5697', '1985-05-05', 'false', 'sayap', '0399991375', 'S3'),
	('9b74ff79-38e7-5ab7-b183-ada5f90ad920', 'AJ Auxerre', 'Casi', 'Odcroft', '493-132-6030', '1992-12-03', 'false', 'gelandang bertahan', '7377109151', 'S3'),
	('831f49b3-6d36-59e8-82a1-779cd3973e98', 'AJ Auxerre', 'Kimberlyn', 'Benedyktowicz', '778-550-6688', '1986-08-01', 'false', 'back tengah', '4583944269', 'S1'),
	('a8a16b8e-b782-524e-987a-85bb2cf14518', 'AJ Auxerre', 'Kristofer', 'Van der Beek', '695-798-9360', '1981-10-17', 'false', 'sayap', '0104134050', 'S2'),
	('fced75c1-7380-5ec2-81c1-cfd247fe1345', 'AJ Auxerre', 'Ailey', 'Antrag', '614-608-3874', '2009-10-28', 'false', 'gelandang serang', '8301796508', 'S2'),
	('2f9a8828-f896-5f46-8cbd-017b2bb6991d', 'AJ Auxerre', 'Sandie', 'Bellord', '975-281-1320', '1983-01-09', 'false', 'sayap', '1393919728', 'S1'),
	('91a9d607-7f46-5dd6-8151-32a103ba9448', NULL, 'Anthea', 'Whitehorne', '448-172-1106', '1989-10-09', 'false', 'gelandang bertahan', '9895666078', 'S1'),
	('4c158e2a-f9b2-51c1-822e-eb98f7c901fe', NULL, 'Maxi', 'Ead', '700-894-8968', '1993-07-30', 'false', 'gelandang serang', '9894034855', 'S1'),
	('ae605a61-3924-52ce-aa36-33b9feacbfba', NULL, 'Leif', 'Grinishin', '380-881-1034', '2008-08-17', 'false', 'back tengah', '1429306155', 'S2'),
	('d6cdc3b7-8250-58c3-953b-42dd98becf36', NULL, 'Egbert', 'Maffey', '947-243-9635', '1983-07-03', 'false', 'back sayap', '4183239937', 'S2'),
	('2bf0e5ff-b062-51f0-8586-c47a48a1877d', NULL, 'Daveen', 'Loweth', '466-621-8035', '1985-09-22', 'false', 'back sayap', '9771346295', 'S2'),
	('a52279ba-c057-5f5b-bc6e-f0b7cba94471', NULL, 'Corie', 'Trytsman', '540-975-6573', '2003-10-03', 'false', 'gelandang bertahan', '5346254293', 'S2'),
	('38d39b56-5d5c-5c8b-833b-80c6fbd77bff', NULL, 'Terri', 'Delacour', '767-996-1432', '1996-03-31', 'false', 'back tengah', '6523836357', 'S2'),
	('3ea53d36-e2d0-54f1-ad35-73f08dee342a', NULL, 'Frederik', 'Rippingall', '138-645-2087', '1985-06-22', 'false', 'gelandang bertahan', '4218026426', 'S3'),
	('c417838c-909c-52db-a034-dc004bca3022', NULL, 'Barbette', 'Bartozzi', '409-670-6630', '1984-02-07', 'false', 'penyerang', '4106918419', 'S2'),
	('0c241fa8-8bab-52a9-b1ea-f3fbcb38b4bb', NULL, 'Darrin', 'Batstone', '355-778-5328', '1992-03-13', 'false', 'gelandang bertahan', '2179515657', 'S3'),
	('f328f007-9637-5841-ac31-e62939e2da1c', NULL, 'Adair', 'Slavin', '292-188-4414', '2007-08-30', 'false', 'gelandang serang', '1492482694', 'S3'),
	('0abdf48e-8951-572c-9176-397f800b77c7', NULL, 'Maxie', 'Watkiss', '646-791-5061', '1997-07-21', 'false', 'back sayap', '8978749117', 'S3'),
	('4f26f492-b166-512f-b34c-70ece03262fd', NULL, 'Alfy', 'Hamlet', '965-634-9973', '1986-09-15', 'false', 'penyerang', '0793728489', 'S2'),
	('f8683b4a-3618-5c69-91d4-f15a593e0b5b', NULL, 'Janos', 'Delnevo', '900-685-3308', '1992-06-06', 'false', 'back sayap', '5634571356', 'S1'),
	('f6f2af51-3d03-59e1-ad8d-4e1a68070cb7', NULL, 'Torey', 'Aspell', '784-241-9031', '1983-09-20', 'false', 'gelandang serang', '6704281819', 'S1'),
	('2a7f4d3b-f4e2-507c-9109-9a3f6a3b23a2', NULL, 'Cesya', 'Blowne', '454-444-1410', '1988-01-08', 'false', 'penyerang', '5950419980', 'S2'),
	('9a9811de-5da0-54da-8959-2b51e41f9b35', NULL, 'Paolo', 'Buss', '104-895-9026', '1986-07-26', 'false', 'back sayap', '6852432100', 'S3'),
	('4b9ed7a9-452a-5bb7-9d0f-6b9009259026', NULL, 'Maryanna', 'Joysey', '356-603-5523', '1987-05-18', 'false', 'sayap', '6017172505', 'S3'),
	('c18b98ea-fe88-5685-a344-01ec18c2ee8f', NULL, 'Muhammad', 'Calladine', '402-113-4894', '1991-04-11', 'false', 'back tengah', '5003530984', 'S1'),
	('bf4fa790-f065-5c1a-97b6-7758a0513773', NULL, 'Leo', 'Pook', '305-919-8657', '1987-04-06', 'false', 'kiper', '9592880172', 'S1'),
	('f1b6cf62-2018-5aa7-b598-91206ee9550f', NULL, 'Georgeta', 'Cornbill', '843-381-3240', '1987-05-23', 'false', 'kiper', '4143783961', 'S3'),
	('c40152a4-754c-5e2e-8ab2-5436f593c137', NULL, 'Peg', 'Medcraft', '763-155-9400', '1996-04-29', 'false', 'penyerang', '4506108184', 'S1'),
	('180c09cf-1e6c-5f7f-9d0f-6a43b2611bd2', NULL, 'Ruperta', 'Willford', '456-982-8505', '2001-08-16', 'false', 'gelandang serang', '0435110946', 'S3'),
	('9b821f50-38e5-5185-8369-df7e7715cfbf', NULL, 'Evy', 'Sayers', '779-633-4681', '1993-10-28', 'false', 'back sayap', '8684601175', 'S1'),
	('123dadda-c237-5fc2-9910-589d1eae2914', NULL, 'Kalli', 'Chadbourne', '819-266-2935', '1982-12-06', 'false', 'back tengah', '3862209964', 'S3'),
	('da3cd667-0c18-5d0c-a36b-0f67a7fb69d3', NULL, 'Abdul', 'Matoshin', '187-260-2907', '1980-10-15', 'false', 'back tengah', '8984972710', 'S2'),
	('b30f0d98-7d97-5a10-85e3-d0d6c38b8931', NULL, 'Antonia', 'Kinahan', '738-517-9716', '2000-07-22', 'false', 'gelandang serang', '5275979624', 'S2'),
	('db53c937-8884-576d-a2b7-a1662e9e60ef', NULL, 'Grantley', 'Anlay', '478-381-0341', '1995-05-06', 'false', 'penyerang', '1813627214', 'S2'),
	('de111e20-084e-5600-96db-62a77cc94981', NULL, 'Gregorio', 'Nuttey', '307-862-1551', '1988-07-13', 'false', 'back sayap', '4446147550', 'S3'),
	('2109ea2e-9f7d-5d1a-a920-8ed8f0b43cc4', NULL, 'Prudi', 'Brelsford', '275-118-4148', '2005-08-20', 'false', 'back sayap', '1660210686', 'S2'),
	('940adfb7-ac93-5229-baea-a6728c4cb25c', NULL, 'Kenon', 'Maggiore', '474-318-0503', '1985-02-09', 'false', 'sayap', '8257789414', 'S3'),
	('eeb3a86d-28f4-5a77-920a-4008ecb9cb8a', NULL, 'Jase', 'Peaseman', '473-605-3444', '2001-01-21', 'false', 'back tengah', '3409291546', 'S3'),
	('116deb7e-a8bc-54b7-a206-b6f3cf8843ae', NULL, 'Berkie', 'Sparkwill', '142-760-8326', '1991-03-20', 'false', 'gelandang serang', '9579696786', 'S3'),
	('9f65f367-04d6-5e5e-9e49-6619d671f1b4', NULL, 'Martita', 'Verman', '720-688-7146', '1985-07-02', 'false', 'gelandang bertahan', '8114087710', 'S1'),
	('fec6e7d5-72eb-5228-a649-9edfe3dfb05a', NULL, 'Felicle', 'Noulton', '822-965-6762', '1999-04-11', 'false', 'back tengah', '0392450129', 'S2'),
	('e451294e-c32a-5303-9be0-d5a9685a57a5', NULL, 'Diane', 'Mateu', '885-311-2462', '2002-09-23', 'false', 'gelandang serang', '6882446433', 'S2'),
	('41fddd26-49fb-5e74-ab23-e8281457b32a', NULL, 'Isidora', 'Wiseman', '855-886-1163', '2007-02-28', 'false', 'sayap', '8089562855', 'S3'),
	('45647421-bd39-5675-8dd4-5b262a86b8eb', NULL, 'Lorenzo', 'Wyett', '513-563-2782', '1992-02-08', 'false', 'kiper', '2763269176', 'S2'),
	('f4e2bcda-48eb-5ada-88f7-82c2a2ae2b38', NULL, 'Mickie', 'Temperton', '715-442-9176', '1991-03-03', 'false', 'sayap', '8657888640', 'S1'),
	('3b921131-df01-54fb-89d7-1955dad70551', NULL, 'Terencio', 'Mival', '725-254-7374', '1999-11-24', 'false', 'back tengah', '0059695574', 'S3'),
	('93c7994d-cde6-58b1-ae3d-3faba338fded', NULL, 'Isabelle', 'Gilroy', '454-765-4796', '1995-05-28', 'false', 'penyerang', '7355326641', 'S2'),
	('89f4225e-8fb4-50cf-b356-53c291db4b95', NULL, 'Elmer', 'Dowding', '474-541-7199', '1987-05-01', 'false', 'gelandang serang', '4624847700', 'S1'),
	('93038481-de0a-5528-b282-cfd9826ef607', NULL, 'Huntlee', 'Folliott', '198-219-1818', '1993-12-13', 'false', 'back tengah', '7599926876', 'S3'),
	('4a4e4661-baa2-5646-be9b-7a4baa9762ee', NULL, 'Laverne', 'Doohan', '526-596-6224', '1991-11-06', 'false', 'penyerang', '6772574327', 'S2'),
	('9ef87c87-a2b9-586c-8e20-f967523472b6', NULL, 'Nester', 'Bendle', '855-627-5894', '1986-02-05', 'false', 'sayap', '4998898818', 'S2'),
	('98308bc0-733b-5b9f-976c-b5e6eb7d4d6f', NULL, 'Barbara', 'Nobes', '987-261-9109', '1998-02-28', 'false', 'back sayap', '7026168182', 'S2'),
	('bbc4ebc2-e52a-5041-977b-3f412ecedea0', NULL, 'Gwendolen', 'Pendlebery', '996-118-6201', '1987-10-06', 'false', 'penyerang', '9205462074', 'S3'),
	('2f8a61ec-824c-511b-abbf-68e3c9bbee6f', NULL, 'Tasha', 'Monksfield', '753-325-1176', '2001-02-05', 'false', 'penyerang', '9129217157', 'S3'),
	('3d260c0e-8610-5dc9-88b7-83bdc9d57d71', NULL, 'Hieronymus', 'Simenet', '698-505-9118', '2001-12-25', 'false', 'back tengah', '5997852417', 'S3'),
	('93d2586b-2d3f-5d37-952d-771a09316b29', NULL, 'Mickie', 'Pearcey', '323-152-1802', '2003-10-28', 'false', 'kiper', '0079437336', 'S2'),
	('f57881be-cd18-51c2-98df-2ed67a53f71c', NULL, 'Jere', 'Garrod', '811-857-0276', '1980-01-17', 'false', 'back tengah', '9233835958', 'S2'),
	('3ee7f4b1-8ab4-559d-89da-7081ce440b06', NULL, 'Alana', 'Plum', '350-998-3939', '2005-05-11', 'false', 'gelandang serang', '9817427944', 'S3'),
	('eb431e05-56c9-5451-bc2d-0ecee312d296', NULL, 'Ferguson', 'Rintoul', '808-745-6103', '1982-03-19', 'false', 'back tengah', '2581326610', 'S3'),
	('1a30dd17-3f72-5c9f-9626-980f6d7951ac', NULL, 'Vitoria', 'Jackman', '255-315-4564', '1989-07-09', 'false', 'gelandang serang', '3841163781', 'S2'),
	('21e535b0-a6ad-554e-8abc-93e1412873e3', NULL, 'Hamel', 'Scholfield', '326-360-3274', '1991-03-26', 'false', 'gelandang bertahan', '0048379455', 'S2'),
	('2cb1e714-c3fc-537c-81a2-3225865ccc77', NULL, 'Emeline', 'McCorry', '479-903-0763', '2009-06-21', 'false', 'gelandang serang', '6888308209', 'S3'),
	('068089f9-b387-560f-985f-6ee77e8a71e1', NULL, 'Berri', 'Jurczak', '753-762-0369', '1984-02-24', 'false', 'kiper', '2758375126', 'S1'),
	('f9b79ee6-fa07-5cdd-aa99-5689e7cdb6d3', NULL, 'Alfi', 'Petroulis', '932-629-6497', '1991-01-03', 'false', 'penyerang', '8379304720', 'S3'),
	('e968792d-daae-5667-ab2c-a577813d5932', NULL, 'Jerrilyn', 'Scholtis', '216-496-0045', '1993-02-22', 'false', 'gelandang serang', '3468696817', 'S1'),
	('b47add24-ca82-5bcf-90ba-3cfd8d096632', NULL, 'Karlis', 'St. Pierre', '267-457-8352', '2006-07-13', 'false', 'sayap', '6527405998', 'S3'),
	('75181ed0-b3c6-5e58-8a3b-2230e6ec25e9', NULL, 'Calypso', 'Lapthorne', '749-465-4259', '1994-06-07', 'false', 'gelandang bertahan', '9294716711', 'S2'),
	('e840d6a6-9586-5d0b-ab03-d5ce3e595d03', NULL, 'Cobbie', 'Saket', '614-744-6088', '2007-03-09', 'false', 'sayap', '2009138482', 'S1'),
	('2d23341e-1098-5dcd-9895-846a5e196f98', NULL, 'Kath', 'Merioth', '238-453-8847', '1994-01-29', 'false', 'gelandang serang', '1324855081', 'S2'),
	('91e455a3-504c-5746-baae-a09211722a6e', NULL, 'Ester', 'Barcke', '280-596-6109', '1999-05-09', 'false', 'gelandang serang', '2010563288', 'S2'),
	('667d73e9-3ea4-5a81-b354-8c7cc05d2c93', NULL, 'Ferdinande', 'Blampied', '174-641-2103', '2004-06-02', 'false', 'sayap', '5712436701', 'S3'),
	('b2a23445-6cb4-50b9-be49-6ed4c7d2cc30', NULL, 'Cleopatra', 'Denes', '297-162-1627', '1985-05-09', 'false', 'kiper', '9507867688', 'S1'),
	('58a2e6ac-3f18-5363-a03e-c10393fd4175', NULL, 'Mavis', 'Munkley', '783-808-8936', '1999-09-03', 'false', 'gelandang bertahan', '5013507221', 'S2'),
	('9cc05dc8-f15c-5937-aada-b286eadd89bf', NULL, 'Norah', 'Andryszczak', '376-675-5520', '2008-08-03', 'false', 'kiper', '8809241838', 'S3'),
	('10ac9f32-3ba4-5144-8f60-e5527f606a0f', NULL, 'Talya', 'Lacy', '476-359-0862', '1994-03-26', 'false', 'gelandang bertahan', '3609319020', 'S1'),
	('b552b6b5-80fa-50a4-b4a2-40836e188708', NULL, 'Elsbeth', 'Dicey', '321-240-4014', '2008-09-24', 'false', 'back sayap', '7186921220', 'S1'),
	('e49e19cd-94a0-5487-8284-ceafae3dbf81', NULL, 'Georgena', 'MacNess', '513-441-2689', '1982-01-17', 'false', 'gelandang bertahan', '0704400308', 'S3'),
	('9e40d01c-611b-500a-a301-bcb132f9cbbe', NULL, 'Sheree', 'Cordel', '677-519-8908', '1998-07-19', 'false', 'gelandang serang', '6968335661', 'S2'),
	('2ddb71b6-c8cd-5061-b9bf-2c9e5a44467a', NULL, 'Gabbi', 'Heninghem', '154-251-7229', '2005-07-20', 'false', 'penyerang', '3716385398', 'S1'),
	('b7ede31a-9bc0-5c68-825a-96e64390315c', NULL, 'Alyda', 'Lethem', '642-463-3218', '1998-03-10', 'false', 'gelandang serang', '8883559563', 'S1'),
	('56dbd73a-c5d5-5377-85ba-631076076fae', NULL, 'Hermine', 'Briton', '894-679-5855', '2010-01-13', 'false', 'sayap', '3831765973', 'S2'),
	('c56b08eb-2a26-5f56-9c62-d85fdfb87b22', NULL, 'Renee', 'Friese', '478-379-0945', '1995-04-07', 'false', 'kiper', '0132514285', 'S3'),
	('2dc3e975-a663-5713-bcc5-1fd377aaedcf', NULL, 'Jarad', 'Cowerd', '165-571-1049', '1995-10-11', 'false', 'kiper', '1592355633', 'S3'),
	('5ffcad63-cff6-59be-af6d-576f007ccc60', NULL, 'Tobie', 'Wurst', '629-631-1370', '1999-04-07', 'false', 'back tengah', '8334288405', 'S1'),
	('31725c46-2f61-56a4-9462-b588ffc1472c', NULL, 'Wash', 'Courtes', '218-716-7464', '2002-03-25', 'false', 'sayap', '6501659856', 'S2'),
	('bad769bb-5d38-5fb9-b358-72c3ad6587cc', NULL, 'Adaline', 'Bond', '862-668-8465', '2004-03-26', 'false', 'gelandang serang', '1442789691', 'S1'),
	('a6ab80df-9340-524f-95fe-83a9b586ca82', NULL, 'Bord', 'Corteney', '809-262-3674', '2005-03-29', 'false', 'back tengah', '2125651684', 'S1'),
	('341dda45-b3a2-567b-96f2-b680d59cb9ec', NULL, 'Betteanne', 'Conklin', '713-389-9086', '2000-04-16', 'false', 'penyerang', '5703019911', 'S2'),
	('2322a9da-7113-56a6-8efd-35e067166c05', NULL, 'Theresa', 'Carberry', '820-660-2891', '1985-12-19', 'false', 'kiper', '7329765974', 'S2'),
	('351fd878-a24f-5039-a057-10034bd34716', NULL, 'Mercie', 'Dunlea', '852-654-3921', '1997-02-06', 'false', 'kiper', '6649747367', 'S1'),
	('55a185c8-30ff-5db0-b673-4847ca3269ff', NULL, 'Madison', 'Tate', '140-358-4003', '1981-09-15', 'false', 'gelandang bertahan', '6850784386', 'S2'),
	('ae1542e4-b0dd-5739-a3c2-f166ec32c6f9', NULL, 'Dyanne', 'Mc Meekin', '604-391-7655', '1995-11-01', 'false', 'gelandang bertahan', '2756891044', 'S1'),
	('4e69f0a3-9493-5a65-9dde-ba9b407d3feb', NULL, 'Channa', 'Rubertelli', '101-879-2103', '1997-09-12', 'false', 'penyerang', '2006720221', 'S2'),
	('67a35beb-5f33-5ac0-9d5e-f6b6196ffe5d', NULL, 'Hans', 'Gilhool', '211-883-4030', '1999-07-06', 'false', 'kiper', '0079996334', 'S3'),
	('fd22f925-dfca-5e19-b750-7c3ad811ac19', NULL, 'Kingston', 'Bayne', '644-780-5168', '1994-09-17', 'false', 'back tengah', '4733818204', 'S3'),
	('d65b2430-d0ed-5ef3-aea0-94f0912bfec8', NULL, 'Sondra', 'Hoble', '481-923-7732', '1981-11-15', 'false', 'kiper', '1720392422', 'S3'),
	('0da387d6-c8f5-526a-bdee-5aba7069404d', NULL, 'Rosaline', 'Vanini', '505-769-8028', '2009-07-25', 'false', 'back sayap', '2675259820', 'S1'),
	('44651ae8-d695-55a9-9485-d86e9f911cf5', NULL, 'Glennie', 'Manley', '547-153-1525', '1991-03-04', 'false', 'penyerang', '6901935992', 'S1'),
	('82e8d28b-ad16-5f73-b3d7-a1e4b8e86de3', NULL, 'Leupold', 'Byrde', '653-493-9699', '1988-09-18', 'false', 'kiper', '6005567048', 'S3'),
	('74a45ed1-b8b7-50ba-aa80-646d296b6425', NULL, 'Luca', 'Easey', '754-159-0134', '1981-03-13', 'false', 'back tengah', '5475373967', 'S1'),
	('c6b9959a-2057-5e69-9e68-f1a4cc65bdd0', NULL, 'Gearard', 'Grut', '365-791-2513', '1986-02-25', 'false', 'sayap', '9574683435', 'S2'),
	('89663f84-7cdf-5336-a1de-c2e391020338', NULL, 'Lorianne', 'Dorton', '576-400-3253', '1989-07-31', 'false', 'penyerang', '4387804461', 'S1'),
	('29bfbb31-8e9c-59bf-ab3c-f172be63bcc4', NULL, 'Flint', 'Dolley', '200-624-2833', '1989-12-18', 'false', 'back sayap', '0280116351', 'S3'),
	('2ade4fc3-f19d-5b36-ab42-2308e0db2e66', NULL, 'Timotheus', 'Ewert', '461-684-4540', '2009-10-22', 'false', 'back tengah', '9183143073', 'S1'),
	('15d42c0c-40dd-50a1-be4a-e2d58b9cb5cd', NULL, 'Rudolfo', 'Scoates', '429-548-3678', '1992-09-10', 'false', 'sayap', '7129438891', 'S1'),
	('dc1c674e-dd41-515a-b9f2-4e04d8849746', NULL, 'Car', 'Hadenton', '377-794-9907', '1992-02-12', 'false', 'kiper', '2751356301', 'S1'),
	('90a742c9-fb20-582e-aa0b-ffedf384d047', NULL, 'Lulu', 'Filson', '849-474-4926', '1981-08-23', 'false', 'back tengah', '2368434731', 'S1'),
	('678f8724-cff4-51ce-97b1-f987390c60cf', NULL, 'Oona', 'Grinstead', '737-765-8143', '1990-09-23', 'false', 'back tengah', '8488215456', 'S3'),
	('c6470010-acd1-5899-b975-bf692b4e8978', NULL, 'Amelita', 'Aherne', '827-908-9905', '1985-09-06', 'false', 'sayap', '3182619121', 'S2'),
	('9a510577-102c-544a-bdce-963d08b96235', NULL, 'Esma', 'Kezar', '500-881-6534', '2004-02-06', 'false', 'gelandang serang', '3466006241', 'S1'),
	('083de5be-65cf-5299-8401-e86c043f6864', NULL, 'Zelig', 'Synnott', '724-647-5971', '1983-01-08', 'false', 'back tengah', '1238329827', 'S2'),
	('877051f3-8118-55a7-abcd-f03875881165', NULL, 'Mireielle', 'Rickert', '894-944-5468', '1995-11-04', 'false', 'gelandang bertahan', '9827075040', 'S1'),
	('a982a7c6-0d58-548f-a196-69524b858e20', NULL, 'Eleen', 'Jacke', '458-944-3673', '1985-12-25', 'false', 'back tengah', '6794253442', 'S1'),
	('3dcd809e-3ea4-5eb4-a5d2-7497fc74fff5', NULL, 'Philippa', 'Doudney', '808-890-2537', '1987-09-08', 'false', 'gelandang bertahan', '1587399123', 'S1'),
	('9aacbc8c-2fbb-5aa6-92a8-9b4fb4c40d10', NULL, 'Suzanna', 'Kuhn', '640-413-1195', '2009-05-05', 'false', 'gelandang bertahan', '3833304833', 'S3'),
	('43b679e9-da76-5219-909b-79a5846139a5', NULL, 'Franny', 'Crutchfield', '131-561-8151', '2000-05-03', 'false', 'sayap', '3364225870', 'S3'),
	('dfc73641-2249-5f9e-a7a6-9021fc03967a', NULL, 'Hazel', 'Payler', '556-426-6157', '2001-12-08', 'false', 'back sayap', '8149570537', 'S2'),
	('0cdb720c-cee4-5241-be7c-6b40e183b452', NULL, 'Enrika', 'Darwood', '305-635-9455', '2003-09-19', 'false', 'kiper', '8061683752', 'S1'),
	('e50ef09e-8f63-5362-9b66-5345480376f7', NULL, 'Eydie', 'Peppard', '237-465-5311', '1990-04-19', 'false', 'penyerang', '9353165192', 'S1'),
	('aea52033-c0bc-5274-aefd-bcbdf61e9283', NULL, 'Anet', 'Willets', '501-586-6188', '1997-09-29', 'false', 'kiper', '1281419307', 'S1'),
	('371fde3a-ed14-55ea-ad00-90c5c55ea982', NULL, 'Gae', 'O''Carrol', '616-366-8360', '1988-02-22', 'false', 'back sayap', '5369831049', 'S1'),
	('0477e464-c6c6-514d-a253-aa4aa5011a0f', NULL, 'Marijo', 'Immins', '476-191-3001', '1992-03-13', 'false', 'back tengah', '5269931724', 'S2'),
	('e634eab8-ce52-5ea0-aae9-89deddf916a0', NULL, 'Gris', 'Iceton', '523-253-8580', '1982-09-20', 'false', 'kiper', '0137342766', 'S2'),
	('1da1f0c2-d72d-5b61-ab1f-2147485f6ba0', NULL, 'Caressa', 'Plet', '512-857-5955', '1994-12-31', 'false', 'back sayap', '4176457105', 'S1'),
	('d6623d3d-1a46-541c-ac49-e8811b6187ea', NULL, 'Maxy', 'Carvilla', '667-523-0449', '1984-07-13', 'false', 'back tengah', '5921026667', 'S2'),
	('4d2c944d-e673-5e60-b281-41537a0514d2', NULL, 'Dickie', 'Bramsom', '284-739-2716', '1998-08-17', 'false', 'sayap', '3039193370', 'S1'),
	('6e33394c-71ce-5c98-978c-eab53783af02', NULL, 'Donn', 'Dunkersley', '699-704-8694', '1989-05-21', 'false', 'penyerang', '6052817789', 'S1'),
	('67173138-5de5-50c0-864f-27fa60325e0a', NULL, 'Mabel', 'Gue', '911-284-3823', '1989-02-16', 'false', 'penyerang', '4165039516', 'S2'),
	('b0089d77-91f3-512d-a835-798be8242bea', NULL, 'Nathalie', 'Cohalan', '409-597-8048', '1985-05-28', 'false', 'kiper', '4730774031', 'S2'),
	('70c7897b-8b9d-5d78-a42c-5d0079b891a9', NULL, 'Lidia', 'Bocock', '995-721-2978', '1999-02-08', 'false', 'sayap', '1716795296', 'S1'),
	('1c305d65-7372-57d8-8bc2-5f43c192fa8e', NULL, 'Granthem', 'Scud', '502-913-8605', '1991-08-22', 'false', 'gelandang serang', '7413335038', 'S3'),
	('529f6029-a3fd-5bfc-8b94-0f9f2dd08226', NULL, 'Ganny', 'Wharmby', '938-243-6034', '1997-01-29', 'false', 'penyerang', '4066789846', 'S1'),
	('aeab99d3-803b-5b84-a1fa-5814859bfeed', NULL, 'Alfreda', 'Burrass', '504-412-8500', '1987-01-25', 'false', 'penyerang', '9695716425', 'S3'),
	('87603789-e9b3-5afe-8252-79a9abcca98a', NULL, 'Daren', 'Elwill', '151-569-7468', '2005-05-11', 'false', 'back sayap', '2088945201', 'S2'),
	('4d132f96-cfbe-5d27-9b33-2deea4f01604', NULL, 'Dur', 'Izakson', '762-373-2566', '1987-01-31', 'false', 'sayap', '6267387945', 'S1'),
	('747942b9-506b-5c8d-a3fc-777c268897c6', NULL, 'Curr', 'Pickaver', '791-926-3675', '1996-04-25', 'false', 'back tengah', '5929245244', 'S3'),
	('d5f29228-4009-56ee-ba63-c14d59112b6b', NULL, 'Corie', 'Swendell', '369-876-1579', '1995-08-21', 'false', 'back tengah', '1642225293', 'S3'),
	('36fc5e64-71c0-585a-a112-17821eee5297', NULL, 'Jeana', 'Cristofanini', '792-808-3733', '1982-10-28', 'false', 'kiper', '6371667494', 'S1'),
	('e069617f-4098-5376-a686-33e5dbb9e4f9', NULL, 'Marion', 'Sonner', '424-478-3165', '2003-02-27', 'false', 'back sayap', '9806797153', 'S1'),
	('09c4701e-217d-5e5b-9fdf-90dd23951e2b', NULL, 'Pauline', 'Spearett', '923-477-5426', '1984-04-16', 'false', 'gelandang serang', '9547328184', 'S1'),
	('c07b0a2c-9d22-5cfd-a2ad-bae377e49061', NULL, 'Shana', 'Alner', '574-974-5834', '1990-06-27', 'false', 'back tengah', '6583079870', 'S2'),
	('92b3ce0b-38c4-5c35-9dc4-e35c92ea375e', NULL, 'Brett', 'Ciottoi', '784-473-0177', '2004-08-05', 'false', 'kiper', '6984841434', 'S1'),
	('f9a81431-4ef8-52ad-84ff-7517205c771d', NULL, 'Ilene', 'Nettleship', '675-462-9985', '1982-04-22', 'false', 'kiper', '2943480073', 'S1'),
	('a3adce10-0ad8-5dfa-a351-0724d6564bf8', NULL, 'Jeannette', 'Ferrar', '240-484-2078', '1985-04-19', 'false', 'back tengah', '7149895544', 'S1'),
	('45d23ec9-5af3-5f01-aca3-9004aa237d77', NULL, 'Elvira', 'Truckett', '218-788-6139', '1987-10-24', 'false', 'sayap', '4531346505', 'S2'),
	('65bfe7dd-8fd2-5264-b7a6-fd17d321d580', NULL, 'Granville', 'Lantoph', '621-345-7666', '1980-11-07', 'false', 'back sayap', '4840612677', 'S1'),
	('3e6e04d9-be8d-579f-861b-ceebb9dd22e0', NULL, 'Mattias', 'Southwell', '822-559-8192', '1986-07-18', 'false', 'gelandang bertahan', '1083152397', 'S2'),
	('60dfa68a-75dc-50be-956a-a7c1d109af71', NULL, 'Frederic', 'Scarrott', '399-669-6095', '1998-09-22', 'false', 'back tengah', '4716221372', 'S2'),
	('f07d7d96-a833-52e2-a652-3860b7f5ce27', NULL, 'Wilek', 'Crich', '605-630-6257', '1994-11-05', 'false', 'sayap', '5987547821', 'S1'),
	('542f34b6-b2c0-545c-be85-963338dae8a5', NULL, 'Jania', 'Thewys', '463-983-5746', '1985-02-27', 'false', 'back tengah', '0985893503', 'S2'),
	('9abf72bd-c8b6-5cbf-b6ae-9e7f40881d25', NULL, 'Liva', 'Saunderson', '971-588-5693', '2004-09-12', 'false', 'gelandang bertahan', '1432616280', 'S3'),
	('d6b29886-a59d-558a-8ce2-6a6470475716', NULL, 'Mil', 'Brixey', '841-378-3133', '2009-07-08', 'false', 'back tengah', '9534165045', 'S2'),
	('0daba586-1e3f-5bea-a743-8513792cc7eb', NULL, 'Dorita', 'Lyokhin', '946-659-4141', '1996-12-24', 'false', 'kiper', '7399725661', 'S2'),
	('e72b6399-2cc0-5dea-b870-461730651af6', NULL, 'Justus', 'Pipes', '516-111-9398', '1983-10-07', 'false', 'back sayap', '4905507869', 'S3'),
	('86323888-9173-5474-8d10-1abd6c007c4a', NULL, 'Corinne', 'Smorfit', '492-890-3287', '1982-03-31', 'false', 'gelandang serang', '7004431823', 'S3'),
	('129d9683-9b35-505b-9b35-015ec5fe49e6', NULL, 'Karel', 'Minihan', '739-850-8092', '2007-06-20', 'false', 'penyerang', '8133256572', 'S2'),
	('3011692b-b7f8-5e55-890a-48cd3dc06c7f', NULL, 'Kit', 'Thomazet', '201-559-4348', '1983-05-20', 'false', 'back tengah', '9706547652', 'S3'),
	('20179f93-e5f3-5a20-8ce1-9560eb07eaae', NULL, 'Dolorita', 'Smorfit', '404-201-4200', '2008-12-10', 'false', 'sayap', '7622189323', 'S3'),
	('4ebf72c4-cb71-5643-b7f8-e15ada2a5e9d', NULL, 'Cyb', 'Hosby', '703-590-4963', '1993-12-09', 'false', 'kiper', '5418574423', 'S2'),
	('9681b9e3-75b3-5dc6-9df9-1b69d6a5651a', NULL, 'Jodie', 'Cuseck', '501-356-3749', '2000-08-10', 'false', 'sayap', '5759350282', 'S2'),
	('d15314ee-0b35-5692-9037-2e10827a5bc1', NULL, 'Dareen', 'Hallibone', '937-565-1990', '2008-03-27', 'false', 'sayap', '7316004902', 'S2'),
	('0131c9b0-a652-51f0-820d-ea1a6ff1f92f', NULL, 'Ty', 'Farrington', '127-432-6561', '1999-09-23', 'false', 'sayap', '6121369284', 'S2'),
	('00fb5416-4e5f-54a1-a9bf-eb5fc167d0cd', NULL, 'Allix', 'Faivre', '299-119-6480', '1989-03-21', 'false', 'gelandang bertahan', '7935514389', 'S1'),
	('6f6e2908-441d-570e-ac2f-935722f6c9d3', NULL, 'Mariam', 'Menzies', '808-794-8047', '1983-01-06', 'false', 'gelandang serang', '4550078345', 'S1'),
	('cd294b63-4b59-592c-b0a2-646e455ff1c6', NULL, 'Orel', 'Suller', '970-395-4563', '1989-02-22', 'false', 'back sayap', '5056914295', 'S2'),
	('858a58f9-a983-5f98-a957-2166a6e2846c', NULL, 'Reeba', 'Garrity', '346-119-9605', '1982-02-18', 'false', 'sayap', '5665983233', 'S2'),
	('2534006a-2fa0-52dc-8579-779a5dcacb2a', NULL, 'Nancee', 'Shadfourth', '445-457-1880', '2005-03-27', 'false', 'gelandang serang', '9278719793', 'S3'),
	('ddafd942-4dce-5310-a993-04c764f388e9', NULL, 'Helaine', 'Koppens', '414-838-9543', '1984-01-07', 'false', 'back tengah', '1521575041', 'S1'),
	('fa0eb9a2-99a2-54ad-a699-65c93cc02de2', NULL, 'Andres', 'Goodson', '723-446-4830', '2007-06-29', 'false', 'gelandang bertahan', '7728743573', 'S2'),
	('66efc8a7-04de-5354-9a78-9f2dd19a4559', NULL, 'Brod', 'Pepis', '445-709-8654', '2002-02-03', 'false', 'back sayap', '6792823186', 'S2'),
	('b77f49da-426f-5423-b840-10591b2f8d83', NULL, 'Lindsey', 'Oxlade', '822-171-2887', '2003-04-23', 'false', 'gelandang bertahan', '9941188991', 'S2'),
	('6bcff586-4ed5-526f-ad55-3dd3a565d603', NULL, 'Aleen', 'Tomalin', '185-979-9995', '1986-01-04', 'false', 'back tengah', '1063745855', 'S3'),
	('7800af4d-0b0e-540d-94a2-dc8ef83dd0e0', NULL, 'Carmon', 'Raiker', '354-249-4050', '1992-03-10', 'false', 'sayap', '6094567032', 'S3'),
	('80df5067-4f0c-580d-918f-1290ffc39dfe', NULL, 'Maximilien', 'Jerrard', '287-631-7355', '2008-09-25', 'false', 'gelandang bertahan', '3378035326', 'S3'),
	('ab329f66-781a-516d-afad-3dd0e0d9c4d3', NULL, 'Nil', 'Trippack', '866-648-2734', '1995-09-07', 'false', 'back tengah', '1854053973', 'S1'),
	('5b8a2faf-8b7f-5dd9-9ea7-e7d1b5f1fb3b', NULL, 'Jareb', 'Posnette', '420-773-7988', '1980-05-13', 'false', 'gelandang bertahan', '5026082699', 'S2'),
	('b5e62d32-922e-538e-b1f7-845bd4478da5', NULL, 'Minda', 'Baldcock', '392-203-8294', '1999-04-02', 'false', 'kiper', '7008889386', 'S3'),
	('b9d28fa0-4eb8-50e5-acaf-90393b38d59b', NULL, 'Winifield', 'Ciccottini', '604-597-2061', '1993-04-03', 'false', 'penyerang', '5044216325', 'S1'),
	('493f56a2-96c7-5de0-a56e-cb870295a20a', NULL, 'Ariana', 'Riteley', '571-195-6287', '1988-01-20', 'false', 'sayap', '7991223676', 'S1'),
	('f92f34dd-f979-52d3-9a0b-cab46dec55ac', NULL, 'Cora', 'Lapping', '344-522-6202', '2001-12-11', 'false', 'back tengah', '0762668916', 'S2'),
	('b1c4ae42-8eb9-58ea-ad34-d780d36b6af1', NULL, 'Peri', 'Kann', '452-625-8144', '1992-01-22', 'false', 'back tengah', '6421085983', 'S2'),
	('b9c54fe0-d85a-5357-aa8b-007f70b38fd6', NULL, 'Christiano', 'Treslove', '571-823-6654', '1997-04-13', 'false', 'kiper', '2217185991', 'S2'),
	('38cf1066-23a9-59f0-b6ca-479b75bfdb09', NULL, 'Marge', 'Lowrance', '292-385-5727', '1987-04-21', 'false', 'back tengah', '4114033233', 'S3'),
	('d780266f-d0ae-5e40-a441-1280c95ce7b5', NULL, 'Jaime', 'Sealey', '918-588-5327', '1999-07-03', 'false', 'penyerang', '8231472766', 'S2'),
	('22aa372e-f571-541e-ac51-98b66ae5678b', NULL, 'Christophorus', 'Macieja', '964-609-3714', '2000-04-13', 'false', 'kiper', '1906991512', 'S3'),
	('591c56d0-cca7-5644-ba86-0f5486ad2575', NULL, 'Raviv', 'Fyldes', '192-307-6690', '1997-03-17', 'false', 'gelandang serang', '9336331134', 'S2'),
	('384648c5-a34a-5815-a6db-b91533cf1b66', NULL, 'Lovell', 'Habeshaw', '345-354-8204', '1996-08-29', 'false', 'back tengah', '3975404924', 'S2'),
	('9024917a-6f67-5d49-8b22-32757dcc526c', NULL, 'Niles', 'Dutson', '330-280-7977', '2001-04-28', 'false', 'gelandang bertahan', '1551718028', 'S2'),
	('b142f9b6-02b9-50eb-b6c2-e70f7ede4a90', NULL, 'Jarad', 'Clemas', '141-976-3284', '1981-10-06', 'false', 'sayap', '7571452742', 'S1'),
	('fb1da4bf-fb9a-5ea1-aa73-847acdc7754a', NULL, 'Caspar', 'Duchatel', '943-530-7683', '1989-01-16', 'false', 'gelandang serang', '9832959082', 'S3'),
	('387cf8f2-caa1-583b-8dba-8a338028af9b', NULL, 'Nanni', 'Descroix', '152-319-2319', '1985-05-02', 'false', 'kiper', '1163179456', 'S3'),
	('b840e0d8-014a-533f-99e4-d69745a68312', NULL, 'Gerick', 'Panther', '747-136-4586', '1992-11-15', 'false', 'back tengah', '5379585759', 'S3'),
	('19220970-87e8-5de0-a575-2b49a5b4b2c5', NULL, 'Wallace', 'Dafydd', '892-170-4475', '2006-01-20', 'false', 'gelandang serang', '3622349243', 'S1'),
	('4568336b-e7dd-5ff6-bddc-53a7e7f0b201', NULL, 'Bernadene', 'Albasiny', '233-452-1586', '2000-10-22', 'false', 'back sayap', '6780886766', 'S2'),
	('2700adbe-8659-51be-859d-a1493d21a4ae', NULL, 'Emylee', 'Heinl', '982-734-4249', '1996-02-11', 'false', 'kiper', '8217577468', 'S2'),
	('42b6c560-e1b3-5457-a6c2-7344161be67a', NULL, 'Ferrell', 'Howell', '683-720-4654', '2003-05-03', 'false', 'back sayap', '1318757188', 'S3'),
	('39c798c3-3bcc-514d-8a82-0bf87cfd0634', NULL, 'Forrester', 'Buzek', '928-271-2665', '1997-02-10', 'false', 'sayap', '2732739907', 'S2'),
	('30fe5835-9f91-53e4-8d47-dbbd7edf85fa', NULL, 'Gusella', 'Levene', '356-732-7322', '1988-04-26', 'false', 'kiper', '7792224203', 'S1'),
	('385f461c-e603-59e0-94b2-64c24952ff06', NULL, 'Moshe', 'Trimme', '670-226-8882', '1980-03-11', 'false', 'kiper', '8611663441', 'S3'),
	('9a4e8d7d-963e-5294-a8fb-fa726e01a1d2', NULL, 'Park', 'McClurg', '504-705-9256', '2003-05-06', 'false', 'gelandang bertahan', '7575566769', 'S1'),
	('3adc9948-41df-5094-932f-c6faef274b5d', NULL, 'Karolina', 'Ritmeyer', '759-427-4224', '1980-07-17', 'false', 'gelandang bertahan', '9286084918', 'S1'),
	('a2f5210b-eb24-5592-a81c-414a2788770b', NULL, 'Tabbi', 'Yanshonok', '779-856-5509', '1983-11-10', 'false', 'sayap', '7019613788', 'S2'),
	('aeb17979-236f-53d8-9c38-a39262ec154d', NULL, 'Darsie', 'Basler', '382-631-6026', '2005-05-27', 'false', 'back sayap', '6939249366', 'S2'),
	('e8bcaff7-b950-5a15-b239-13a4649a1d10', NULL, 'Chucho', 'Nijssen', '767-748-2102', '1987-11-26', 'false', 'kiper', '8083159010', 'S3'),
	('b5436381-3edd-51a2-a670-1e411c102769', NULL, 'Lissa', 'Carlesso', '368-287-2622', '2000-04-17', 'false', 'penyerang', '2772323624', 'S3'),
	('88d5afce-db90-51ef-9d03-51db2101080c', NULL, 'Gun', 'Figge', '496-252-0190', '2003-11-19', 'false', 'kiper', '1464190028', 'S3'),
	('611bb244-9e43-591e-a562-f2bc03f53507', NULL, 'Cirillo', 'Wiggett', '531-634-4849', '1993-04-08', 'false', 'kiper', '3454428521', 'S2'),
	('c0bc51e4-f36c-567c-89a7-c884bf0f0b04', NULL, 'Joleen', 'Worboys', '686-502-0308', '1992-01-15', 'false', 'back sayap', '2474748357', 'S1'),
	('4c3321b4-8470-5fa7-b9fa-70357e1664f5', NULL, 'Roberto', 'L''Episcopi', '998-972-0359', '1993-02-16', 'false', 'penyerang', '6390001097', 'S1'),
	('5690c54d-9c20-5f22-bd76-e361f78c403c', NULL, 'Auguste', 'Sprowson', '333-203-7471', '2006-02-05', 'false', 'kiper', '5774558270', 'S1'),
	('0875a51d-41de-5ddf-858d-0f7bf17d5d3f', NULL, 'Ivonne', 'Scourfield', '869-824-3581', '2008-11-08', 'false', 'kiper', '8925719199', 'S3'),
	('77d763e3-0d8d-5a36-a4d4-3c7f8a977534', NULL, 'Tamarah', 'Di Nisco', '701-471-2536', '1996-08-19', 'false', 'sayap', '0325369177', 'S3'),
	('6952d4fe-e25d-52e4-a706-2f230369648e', NULL, 'Elinore', 'Coopman', '660-324-1235', '1981-11-06', 'false', 'sayap', '6187452495', 'S3'),
	('8135b3c3-7adb-51bb-a577-2cb3b1ff727d', NULL, 'Reuben', 'Belliard', '191-694-9616', '1990-08-05', 'false', 'back tengah', '6534199925', 'S3'),
	('3f2e4987-7164-59ea-9200-67e41ff74a4b', NULL, 'Jeannine', 'Riggey', '649-406-7780', '1980-11-03', 'false', 'sayap', '9995467653', 'S3'),
	('7e0cd4f6-5a40-5b7f-bac4-1dc8bcadc735', NULL, 'Linell', 'Ziemens', '381-438-6767', '1984-05-19', 'false', 'sayap', '0873516521', 'S1'),
	('da36e846-f6d9-52c7-81b2-c925cbe738fc', NULL, 'Piper', 'Desorts', '490-755-3129', '1993-09-11', 'false', 'back sayap', '6724968780', 'S3'),
	('0d3e0e83-ebaa-5835-9b21-dbdebc82ce3b', NULL, 'Kenon', 'Brignell', '766-928-8320', '1999-06-04', 'false', 'kiper', '7536820371', 'S3'),
	('1ed16258-ae3d-5633-99b9-5b5433badf8f', NULL, 'Brittany', 'McQuilkin', '200-635-3361', '1987-02-28', 'false', 'sayap', '1620057967', 'S2'),
	('edefa7de-437e-5ea7-adf8-e7eeaafa661a', NULL, 'Reeba', 'Cranstoun', '192-995-2132', '1996-03-02', 'false', 'penyerang', '3355206622', 'S2'),
	('da6a2cfd-3bab-5ac9-9fa8-ea6ad2a70b8c', NULL, 'Rachelle', 'Kensley', '380-350-0773', '1983-02-12', 'false', 'back sayap', '5797663600', 'S2'),
	('bd7b2e36-8568-5094-b788-545fbee89a63', NULL, 'Burty', 'Plampeyn', '127-157-8679', '1985-08-31', 'false', 'back sayap', '7700693539', 'S3'),
	('239c773e-b102-5436-88cc-c5cb103f218f', NULL, 'Selene', 'Andre', '477-332-8634', '1982-05-14', 'false', 'gelandang serang', '2678367285', 'S3'),
	('01059b96-7ddc-5f18-a9a3-29c453c7d7c2', NULL, 'Rodrick', 'MacAlinden', '502-371-8099', '1995-02-02', 'false', 'penyerang', '7174510977', 'S2'),
	('1fec41ee-885f-58e8-9aad-8dbb3443273f', NULL, 'Rey', 'Loughnan', '136-468-5629', '2010-02-05', 'false', 'back sayap', '1750854030', 'S3'),
	('734ba4f9-212c-52b6-8258-e18a331cd6df', NULL, 'Alicia', 'Shaudfurth', '563-304-8341', '1983-08-04', 'false', 'back tengah', '6845968974', 'S2'),
	('79fb9565-9380-5b5d-832f-94fff53df91b', NULL, 'Jemmie', 'Tabbernor', '620-274-4786', '1991-10-21', 'false', 'penyerang', '8888217685', 'S2'),
	('08f56d43-366b-5be9-b5eb-ac25dc940274', NULL, 'Jobye', 'Dahill', '347-195-1964', '2002-05-31', 'false', 'sayap', '0872848360', 'S1'),
	('fb5d5a74-cc72-5ae5-99c4-8c1fcc3b493d', NULL, 'Lelia', 'Minshall', '107-643-4080', '2001-10-05', 'false', 'back sayap', '9115694317', 'S1'),
	('65dcfaf7-0096-5aee-9e06-94467387b823', NULL, 'Neely', 'Woodroof', '717-338-6471', '1988-10-06', 'false', 'sayap', '5637560277', 'S2'),
	('782a3c94-822a-5ce8-bdd0-3c2231d4a5f0', NULL, 'Orsola', 'Anthon', '204-734-3849', '2008-09-24', 'false', 'back sayap', '1022828310', 'S2'),
	('22773586-a000-5748-aa7b-7bf7ff718c32', NULL, 'Oates', 'Pimmocke', '535-101-8594', '1982-03-12', 'false', 'back tengah', '3528272900', 'S2'),
	('c4cf3d64-3055-5a74-80e2-1c8e35f50bbb', NULL, 'Chrysler', 'Menier', '847-290-4089', '2006-06-26', 'false', 'back sayap', '8061733676', 'S1'),
	('c8c6c656-3193-51bb-ad70-dcd9b9154c37', NULL, 'Dyanna', 'MacNally', '433-938-5527', '1985-07-05', 'false', 'kiper', '5703037526', 'S2'),
	('cdee2607-c4c0-518d-bcc0-1bfa69f9efca', NULL, 'Riccardo', 'Wrout', '428-891-3330', '1981-12-23', 'false', 'penyerang', '9714551096', 'S3'),
	('a5cc8cc4-fa96-5752-88be-e9a09f6ae2dd', NULL, 'Hyman', 'Hague', '440-294-1555', '2007-01-09', 'false', 'kiper', '4474855375', 'S2'),
	('a3248a56-fad2-5b4c-8417-4aae3925133d', NULL, 'Asa', 'Eagers', '959-673-3645', '1980-05-12', 'false', 'penyerang', '7480698275', 'S2'),
	('21dd5c10-d1ef-5871-895f-c22b69ea45b6', NULL, 'Horatius', 'Hutcheon', '663-519-9207', '2005-07-13', 'false', 'back sayap', '9145140337', 'S1'),
	('3154efb3-ffcb-5469-9912-289b91c87543', NULL, 'Nelia', 'Shirtliff', '123-931-0292', '1984-05-04', 'false', 'back sayap', '4913576999', 'S3'),
	('e46e37ac-374d-558a-bb79-211774c743f7', NULL, 'Roxane', 'Jarad', '865-485-5300', '1990-02-15', 'false', 'back sayap', '0978521948', 'S1'),
	('fc621720-cbf5-5cf5-bdaa-e1b70a355b19', NULL, 'Riccardo', 'Choules', '613-417-3804', '1994-03-22', 'false', 'gelandang serang', '2246697835', 'S1'),
	('41e5082b-b898-507f-b639-ee0ad5aaf227', NULL, 'Amble', 'Anmore', '776-211-9647', '1996-01-06', 'false', 'sayap', '7982522115', 'S2'),
	('ab6a086e-274e-57ae-8baf-e9c71f9280d4', NULL, 'Oberon', 'Farmar', '703-991-8745', '1983-02-27', 'false', 'back tengah', '2821247438', 'S3'),
	('9da09aef-8bf6-5d78-9f82-80cd2e85ba9a', NULL, 'Isadore', 'Evans', '127-794-2629', '1987-02-19', 'false', 'gelandang bertahan', '5060856170', 'S3'),
	('4a55dfef-ad00-5dc7-8b1e-385e68e2259d', NULL, 'Kizzie', 'Collingdon', '885-657-8192', '1988-10-26', 'false', 'kiper', '1252138666', 'S2'),
	('ea59a5d9-97b4-575e-b294-f203b4011734', NULL, 'Warde', 'Phibb', '545-382-8928', '1999-03-24', 'false', 'back tengah', '7288060120', 'S3'),
	('3badf0c2-be7f-539e-ac77-897724301564', NULL, 'Bran', 'Bickerstasse', '471-597-9528', '1988-01-08', 'false', 'sayap', '2799216405', 'S3'),
	('f4021909-b06a-51ec-b099-3a87855448be', NULL, 'Arlette', 'Cleare', '818-544-3407', '1996-11-07', 'false', 'gelandang serang', '6118425767', 'S1'),
	('aecc57cc-30e2-5b20-82a1-f3298453dbad', NULL, 'Lombard', 'Hernik', '405-790-1307', '1999-11-04', 'false', 'back tengah', '6386233821', 'S2'),
	('ab7ea2c4-2f7b-5729-95b1-4777bf94d604', NULL, 'Ninnetta', 'Vassar', '390-332-8165', '2004-08-01', 'false', 'penyerang', '1958398203', 'S1'),
	('efa66efc-61c7-5d3a-bfb7-7a68d705d26a', NULL, 'Celie', 'Girling', '732-419-5254', '2009-07-17', 'false', 'back sayap', '4819462337', 'S2'),
	('e829b1d7-3a4d-5f91-b83b-710597f962aa', NULL, 'Aldon', 'Cruddace', '362-488-3075', '1997-05-14', 'false', 'kiper', '6516311840', 'S2'),
	('d3eb06b1-9404-5f57-bada-338ec9829168', NULL, 'Sharyl', 'Wyper', '188-776-6885', '1998-10-12', 'false', 'kiper', '1572901469', 'S2'),
	('6a738a70-154a-5c8e-844a-a8ef70119c6b', NULL, 'Lolita', 'O''dell', '807-194-3477', '2008-02-04', 'false', 'back tengah', '1572630266', 'S2'),
	('20d12bb9-d756-56b1-9a6a-0508c63bf07e', NULL, 'Alysa', 'Black', '310-283-7533', '1983-06-03', 'false', 'gelandang bertahan', '5580426941', 'S2'),
	('b54dbc7e-0d8f-5345-b40a-6cd31a9c3577', NULL, 'Carlynne', 'Growcock', '911-293-1997', '2006-05-19', 'false', 'back tengah', '1787938911', 'S3'),
	('a9c36b5c-ae88-57d0-bed6-76a2c7b1aa9a', NULL, 'Sheffie', 'Letten', '358-319-2260', '1992-12-03', 'false', 'back tengah', '4449857996', 'S1'),
	('6aea8110-2109-5795-8b41-1f5456f2a421', NULL, 'Shannon', 'Chezelle', '299-375-8839', '2002-03-21', 'false', 'back tengah', '7077254312', 'S1'),
	('de484d86-1b8b-5e03-9e8e-0b07678d977a', NULL, 'Nadiya', 'Erb', '860-382-7822', '1984-11-04', 'false', 'sayap', '1608200225', 'S3'),
	('13ff6fef-47de-5313-b992-6b277e3287c6', NULL, 'Lutero', 'Locke', '271-252-1624', '2009-04-22', 'false', 'sayap', '7296446581', 'S1'),
	('f1af0a94-eb88-5be5-9428-bc52764311cc', NULL, 'Cheston', 'MacWhirter', '434-138-7721', '2006-10-29', 'false', 'back tengah', '7690108985', 'S2'),
	('3c87d3ee-de6a-5cb8-a634-7d6dc97c37cc', NULL, 'Ailee', 'Fidoe', '538-415-7295', '1986-12-14', 'false', 'back tengah', '8549622202', 'S3'),
	('b6855af5-9e3a-52f1-95ce-50771659610b', NULL, 'Eleni', 'Tessington', '733-908-0872', '1992-05-06', 'false', 'sayap', '7625661203', 'S3'),
	('8752c7a4-02d8-554f-ab8b-a0fac6f925ba', NULL, 'Charlton', 'Sitwell', '225-886-1248', '1996-04-07', 'false', 'gelandang serang', '4249479377', 'S2'),
	('216d8f60-4115-51c2-8e96-e262e4a0b2f7', NULL, 'Phylis', 'Rathbourne', '541-360-9968', '1988-02-28', 'false', 'sayap', '5025305112', 'S2'),
	('759816c8-dc48-52af-82fd-5efec494ede8', NULL, 'Calla', 'Boydell', '821-237-3275', '2005-02-17', 'false', 'sayap', '6100199666', 'S1'),
	('101c08f0-75ec-5fe5-8163-4016ae9febe8', NULL, 'Pieter', 'Kunc', '808-109-0238', '2006-05-25', 'false', 'kiper', '2834715273', 'S1'),
	('d8c4507a-881f-56c4-9208-591f8c7678e0', NULL, 'Carine', 'Musgrove', '411-864-7471', '1985-07-07', 'false', 'back tengah', '0964187982', 'S2'),
	('59c15b82-e9b2-5ae2-aa12-2b6e5cebb397', NULL, 'Simonette', 'Charley', '852-549-8761', '1981-05-30', 'false', 'gelandang bertahan', '0909184249', 'S3'),
	('421e8073-990f-5bc2-b87e-e5a4e8ae3f69', NULL, 'Bevon', 'Coult', '418-575-1364', '2007-09-30', 'false', 'kiper', '6177491136', 'S1'),
	('0725b160-2871-5649-8257-3ed024adaa2a', NULL, 'Ruy', 'Tranmer', '828-401-7137', '1995-10-26', 'false', 'kiper', '2294684529', 'S3'),
	('5167bf12-f45f-5b25-b2ae-f285c257123c', NULL, 'Robb', 'Eliet', '303-477-2223', '1996-03-19', 'false', 'penyerang', '9495471642', 'S2'),
	('98d394b5-8379-5b79-9d18-ed22416feb43', NULL, 'Dael', 'Treharne', '904-518-3664', '1992-11-23', 'false', 'kiper', '8966108525', 'S2'),
	('1c3c313d-5f5f-595c-8801-6e3058656c37', NULL, 'Alexa', 'Giacaponi', '193-774-2063', '1981-01-12', 'false', 'gelandang serang', '0296792900', 'S2'),
	('f4247297-8522-5805-b878-67fcbe3fad30', NULL, 'Bette', 'Benda', '291-334-8320', '1981-12-02', 'false', 'back sayap', '0658522958', 'S2'),
	('e28769a6-d2a4-5f9d-a10f-2a3110ea1fdc', NULL, 'Boy', 'McDonand', '486-973-7482', '1990-11-12', 'false', 'back sayap', '8213060034', 'S3'),
	('7590b547-ba95-5a87-9c3d-56724bfec0db', NULL, 'Nancy', 'Driver', '672-488-3941', '2004-11-25', 'false', 'penyerang', '7004268960', 'S3'),
	('6ebfe13b-24de-540c-8302-bd583752f153', NULL, 'Darn', 'Favill', '556-901-8885', '1982-01-19', 'false', 'gelandang bertahan', '5730400341', 'S2'),
	('c26650eb-324f-52d9-9260-ddaec76cf4f0', NULL, 'Samara', 'Alexsandrov', '252-594-2227', '2005-03-23', 'false', 'gelandang serang', '9125127544', 'S3'),
	('7c06b90f-4b84-54a4-9415-cdfb2fdeb12f', NULL, 'Krissie', 'Biggadike', '501-917-9880', '1997-12-02', 'false', 'back tengah', '8288591702', 'S3'),
	('15985745-ae7c-53a5-bd22-cad969e52122', NULL, 'Tab', 'Iiannone', '114-151-4785', '1986-05-14', 'false', 'gelandang serang', '3192007501', 'S2'),
	('58b02954-c5c9-53fe-8c77-980ee0427bb1', NULL, 'Madelon', 'Kinton', '772-112-6447', '2007-06-17', 'false', 'sayap', '0798738188', 'S1'),
	('15c8ca41-40e7-5446-8de7-8e822b1c0432', NULL, 'Kalila', 'Cappel', '598-699-8019', '2005-02-27', 'false', 'back tengah', '6207918419', 'S1'),
	('c87dc4e1-379b-53d7-bb7e-b5dc92d455bd', NULL, 'Maribeth', 'Bevir', '222-746-5352', '2000-12-01', 'false', 'gelandang serang', '8471983379', 'S2'),
	('6f1f6706-a392-502c-bdbe-682e084a06e9', NULL, 'Linnea', 'Giacomazzo', '858-250-0000', '1987-03-02', 'false', 'gelandang serang', '5573171438', 'S2'),
	('e9c62090-3e87-59ad-b2f0-afc821997594', NULL, 'Barris', 'Rushworth', '944-135-4173', '1987-11-23', 'false', 'back sayap', '9870716591', 'S1'),
	('cf2861fa-b8fa-5487-ad48-73cf6e153ba4', NULL, 'Hinda', 'Cottingham', '977-366-0805', '1991-05-01', 'false', 'gelandang bertahan', '1710787728', 'S3'),
	('36967f1c-2165-5009-9d5e-a983067702fb', NULL, 'Pet', 'Banker', '351-464-1097', '1995-03-13', 'false', 'gelandang bertahan', '3315504578', 'S2'),
	('9f31f4d5-2820-5334-8fb1-a889ce1c3ae3', NULL, 'Esmaria', 'Tchir', '367-876-5792', '1983-11-02', 'false', 'gelandang serang', '6686371924', 'S3'),
	('8ab8009f-33f1-592b-98a0-000afc8fb920', NULL, 'Johann', 'Gianni', '764-784-2715', '2005-01-13', 'false', 'penyerang', '2444305584', 'S3'),
	('1becdc62-f4a0-5c90-8bf8-d6f031bdc953', NULL, 'Jackelyn', 'Klosterman', '996-724-3930', '2007-09-14', 'false', 'back tengah', '5028433451', 'S3'),
	('6a41bfaa-f17e-51bc-a82a-c3d1b5de4969', NULL, 'Boyd', 'Shurrocks', '187-808-5625', '1996-01-10', 'false', 'sayap', '5479448500', 'S1'),
	('8ca4a8cb-9f13-51eb-b15c-6e67755310f0', NULL, 'Ron', 'MacAskill', '803-215-9696', '1994-09-11', 'false', 'sayap', '1692044669', 'S2'),
	('338f41fc-fb3e-58a6-b079-4ffa970586cf', NULL, 'Cleopatra', 'Penas', '314-346-6775', '1985-06-14', 'false', 'gelandang bertahan', '6467420159', 'S2'),
	('f2b0e242-5378-58eb-9ab4-256b40e568b1', NULL, 'Salomi', 'Aguirrezabal', '403-862-1798', '1996-07-25', 'false', 'penyerang', '6802438683', 'S1'),
	('3f4eb8db-ffab-5e55-aaf9-82f6bd928ea4', NULL, 'Burt', 'Cuolahan', '598-436-7444', '1983-05-06', 'false', 'kiper', '3429789551', 'S1'),
	('5eae19ac-8844-51df-9161-56f326a5d495', NULL, 'Iorgo', 'Hincham', '467-323-2755', '1995-11-03', 'false', 'sayap', '0669553206', 'S3'),
	('d7fe4e5c-b3dc-59ac-8ab2-b8af4c53bb3a', NULL, 'Blaine', 'Heenan', '865-706-7439', '1991-01-27', 'false', 'back sayap', '5957095410', 'S3'),
	('fe35543a-fa2b-5144-a285-eb7b85d692aa', NULL, 'Liana', 'Leather', '671-860-7335', '1988-03-31', 'false', 'sayap', '2303756852', 'S2'),
	('16d650db-5ad7-514b-8fc0-1c00c9a48991', NULL, 'Peggi', 'Giddings', '578-534-8687', '2003-05-23', 'false', 'back tengah', '3739664262', 'S1'),
	('b88da445-eeb3-54ae-a411-a439fac11ceb', NULL, 'Diannne', 'Coupland', '914-307-8823', '1994-01-20', 'false', 'back tengah', '5756254469', 'S3'),
	('febf1829-51c5-5e86-83ce-f54a754f3f93', NULL, 'Thaddeus', 'Varnham', '103-611-2828', '1997-01-30', 'false', 'back sayap', '2017610651', 'S1'),
	('59be2fd3-4d8a-5471-99ef-3da8f4ed78b6', NULL, 'Imojean', 'Butchard', '820-614-2016', '1982-01-14', 'false', 'gelandang bertahan', '8961957478', 'S2'),
	('0d96d333-42ed-5d26-8fb4-87fbd688ff82', NULL, 'Joya', 'Sawdy', '988-457-3390', '1987-11-29', 'false', 'sayap', '4086035831', 'S3'),
	('683d3afd-0fec-5b14-ac4c-5c1265f7674f', NULL, 'Svend', 'Mattedi', '966-657-0358', '1988-05-29', 'false', 'gelandang serang', '5535229157', 'S3'),
	('4bbcac5a-5c6e-5792-9075-03a490f4e61e', NULL, 'Marshall', 'Sevitt', '205-780-2412', '1993-06-29', 'false', 'gelandang serang', '2929738391', 'S1'),
	('011f889a-b3ec-5950-b083-4faa99eb942e', NULL, 'Anabel', 'Cordingly', '873-754-9310', '2003-06-25', 'false', 'kiper', '9908436695', 'S3'),
	('1e9ad8f6-1ae3-5c0d-9486-2a02984fded9', NULL, 'Lyndsay', 'Brandle', '536-149-7751', '1983-06-06', 'false', 'back tengah', '0698271552', 'S3'),
	('7c5d0b23-ea27-5155-94e2-4ace23f604a2', NULL, 'Shena', 'Luckman', '660-446-9160', '1987-12-24', 'false', 'penyerang', '2268433291', 'S2'),
	('ea9126cc-6b07-5614-a15b-4b59413982b0', NULL, 'Dehlia', 'Gilhouley', '386-297-4508', '1988-04-02', 'false', 'gelandang serang', '4771720416', 'S3'),
	('efff889c-340c-5929-8bea-11272668d2cc', NULL, 'Lanny', 'Cloonan', '639-474-1494', '2005-12-28', 'false', 'back sayap', '8583761648', 'S2'),
	('2822a83b-47c8-5c04-aa42-b13a9d7dfad4', NULL, 'Tani', 'McKie', '323-111-1407', '1998-04-11', 'false', 'back tengah', '7977067487', 'S3'),
	('d4ae56c8-29c0-546e-a9bf-8a45bc98ce18', NULL, 'Casper', 'Callister', '365-926-7684', '1986-07-28', 'false', 'gelandang serang', '7283439836', 'S3'),
	('1f199119-1ced-55f9-91ff-14af2f4b6828', NULL, 'Caz', 'Farmloe', '729-488-2548', '2003-06-09', 'false', 'sayap', '5595036706', 'S2');

--
-- Dumping data for table Non_Pemain
--

insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('996ad860-2a9a-504f-8861-aeafd0b2ae29', 'Bethany', 'Hackley', '4132553322', 'bhackley0@google.ru', '9 Melvin Drive');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('59e06cf8-f390-5093-af2e-3685be593a25', 'Clare', 'McMenamy', '7415705623', 'cmcmenamy1@pinterest.com', '67 Mandrake Trail');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('391ada15-580c-5baa-b16f-eeb35d9b1122', 'Madella', 'Richardin', '9424531854', 'mrichardin2@rediff.com', '618 Barnett Center');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('22fe83ae-a20f-54fc-b436-cec85c94c5e8', 'Galen', 'Gatfield', '6226591983', 'ggatfield3@ow.ly', '3997 Leroy Way');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('b7d55bf4-7057-5113-85c8-141871bf7635', 'Devin', 'Merrington', '3172129419', 'dmerrington4@oracle.com', '4 Marquette Drive');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('1883fdfb-249b-58f5-b445-87dff6eabc06', 'Loleta', 'Mazonowicz', '7622070123', 'lmazonowicz5@weibo.com', '937 Main Pass');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('d6ed313e-533a-55a6-aa06-4c00bc132812', 'Marni', 'Malley', '5144511959', 'mmalley6@earthlink.net', '9272 Michigan Park');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('9090025d-5d06-58f1-b79a-3690407024fc', 'Randee', 'Shillito', '6405853848', 'rshillito7@cornell.edu', '96 Ridgeview Junction');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('751af8b4-32a7-55bc-9fad-8bfbcbbf4237', 'Maryl', 'Geill', '3334775382', 'mgeill8@gizmodo.com', '49 Autumn Leaf Circle');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('305f5e8d-e48d-5c3a-8ce3-446622dd8a8a', 'Ambrose', 'Falck', '7516036987', 'afalck9@i2i.jp', '46 Prairie Rose Plaza');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('a4c08562-50fa-5599-939c-eb6f2a83a362', 'Zebedee', 'Bodega', '6536489989', 'zbodegaa@taobao.com', '63202 Sunnyside Center');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('d35aeaf3-5d1d-535a-a31a-22133ddf5f3d', 'Abner', 'Minguet', '1012161629', 'aminguetb@noaa.gov', '4 Mifflin Alley');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('61c97311-bb14-5679-99fc-98497a701292', 'Anissa', 'Weond', '9354544815', 'aweondc@diigo.com', '527 Doe Crossing Way');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('1bb138f7-5f19-587c-8a25-fb174eabf441', 'Ladonna', 'Boutton', '7973085454', 'lbouttond@angelfire.com', '1 Sherman Circle');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('be6c2a5f-4160-5145-8695-c628496b208d', 'Lewie', 'McMonies', '6433654511', 'lmcmoniese@bbc.co.uk', '16 Browning Alley');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('7dbed579-ec83-5f9b-8aa3-1c40e858acfc', 'Elnora', 'Duckering', '4663976004', 'educkeringf@google.nl', '983 Moland Crossing');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('bcc896de-3c61-523e-973c-052f16456e28', 'Stirling', 'Downing', '9936979425', 'sdowningg@apache.org', '72865 John Wall Avenue');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('77b34e74-5631-5a71-b8ce-97b9d6bab10a', 'Townie', 'Navan', '4783379663', 'tnavanh@sbwire.com', '60 Montana Parkway');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('9d58db4d-28b7-56fc-9b12-db9a3e9d0769', 'Pail', 'Jurgensen', '2976377509', 'pjurgenseni@de.vu', '6 Duke Pass');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('6fea451e-90db-5366-bbde-9a65b83f8f64', 'William', 'Hyndson', '8127696022', 'whyndsonj@mlb.com', '3 Manitowish Trail');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('0df2c324-4b3b-5e4b-8574-770c7c601dc4', 'Angelique', 'Draycott', '1548007619', 'adraycottk@cargocollective.com', '35 Larry Pass');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('05596e20-ebb9-571a-9f7c-250cbacfb499', 'Mattheus', 'Presslee', '9423475018', 'mpressleel@wikia.com', '66 Crest Line Center');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('32b736a1-2bed-5f62-8131-c3dc9a2a33c7', 'Thorstein', 'Albers', '8902726195', 'talbersm@furl.net', '635 Helena Plaza');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('29be4ef0-91eb-512b-8f83-360b6db38a83', 'Ban', 'Sieghart', '7597099023', 'bsieghartn@github.com', '33620 Buhler Place');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('46f64ca6-6094-51fc-bbbe-34e3333c5388', 'Georgia', 'Elsworth', '8047289224', 'gelswortho@odnoklassniki.ru', '43 6th Court');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('8df6e0fb-0d35-5fd6-831a-7e5b9ad2457a', 'Gussy', 'Fligg', '8768473617', 'gfliggp@weibo.com', '5489 Shoshone Alley');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('5151e75a-9d7d-5897-be85-aaa96757564b', 'Gilbertine', 'Gowling', '7461817904', 'ggowlingq@bloglines.com', '1480 Warbler Crossing');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('21f6a510-8fff-5bed-9d0e-df7b2ca28db1', 'Nessie', 'Klee', '2675973072', 'nkleer@flavors.me', '19 Burrows Street');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('3eee96fe-b265-5e36-8d78-b2d50a9ac563', 'Aguste', 'Reedshaw', '1955346891', 'areedshaws@bing.com', '37631 Dixon Road');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('720073c2-6984-53fa-9546-b893e83e0f62', 'Rachelle', 'Boykett', '8695457304', 'rboykettt@sakura.ne.jp', '45158 Anniversary Drive');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('b0526112-ddde-5dbf-b887-9b6f93557007', 'Heinrik', 'Stainton', '7175098780', 'hstaintonu@disqus.com', '909 Little Fleur Court');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('b85b4ff7-2f5e-5d5d-bcda-728e00ad61de', 'Ashli', 'Josifovic', '1861704022', 'ajosifovicv@home.pl', '415 Hazelcrest Lane');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('7561fe4e-6ffd-5631-96d6-cf89fdadba83', 'Tiffy', 'Bromont', '2727637745', 'tbromontw@blogtalkradio.com', '5 Westridge Plaza');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('ae5a160a-ca64-5557-a0d8-1fdd610d83e1', 'Rhianna', 'De Paoli', '8037580145', 'rdepaolix@scribd.com', '683 Toban Lane');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('5429db33-2d2c-51e4-9b96-9918a6a67f07', 'Godart', 'Pepperell', '7355662144', 'gpepperelly@photobucket.com', '3391 Ohio Place');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('214f116d-a5a3-5203-867d-28bcad2b6c1a', 'Lyon', 'Savile', '1239027421', 'lsavilez@diigo.com', '59 Homewood Center');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('c18d0fc0-d829-5009-a349-094ea30c386b', 'Amara', 'Zanioletti', '7598599135', 'azanioletti10@list-manage.com', '6 Mandrake Street');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('c3205bf1-c929-5b45-af5a-42b59ab87391', 'Cassie', 'Huggins', '7072527246', 'chuggins11@woothemes.com', '1927 Milwaukee Center');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('6863109a-0444-5f87-b018-66483cb30f22', 'Elmo', 'Gleasane', '8379896755', 'egleasane12@epa.gov', '069 Charing Cross Parkway');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('b4ab3922-2b8d-5d9c-b20a-e34bbc64c01f', 'Hinda', 'Catanheira', '1195438351', 'hcatanheira13@booking.com', '4 Claremont Avenue');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('08d2a401-c6d0-56d0-bfca-d8fe47a0ccde', 'Giffard', 'Housecroft', '2229759119', 'ghousecroft14@nhs.uk', '68 Algoma Way');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('ba293c61-ad33-57b9-9671-f3319f57d789', 'Lucienne', 'Miskelly', '5844952785', 'lmiskelly15@artisteer.com', '803 Merry Park');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('45fae334-63fa-5064-9e45-024ff9e0095c', 'Vernor', 'Pinson', '4068854016', 'vpinson16@typepad.com', '07 Hermina Park');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('fce23375-fdd4-5b30-8e57-a401e5265ba1', 'Anica', 'Milne', '1906556790', 'amilne17@unblog.fr', '3738 Carioca Terrace');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('b5a095ae-2fa5-5416-a5c3-4b3e8a7d0f9c', 'Liv', 'D''Acth', '4214696043', 'ldacth18@liveinternet.ru', '6 Corry Junction');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('8060dbbf-e5cc-5ed8-b6a8-9c463ae3f1ef', 'Wait', 'Josefson', '4804346473', 'wjosefson19@mtv.com', '4 Steensland Park');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('36054888-8e10-578a-b964-a1e6efebf8bf', 'Dyanna', 'Walduck', '1111263372', 'dwalduck1a@etsy.com', '66 Upham Avenue');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('ae0f5d2b-52f8-5845-8572-d7c586982e02', 'James', 'Glowacz', '6061393535', 'jglowacz1b@blogspot.com', '037 Graceland Plaza');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('651ee801-9621-5f6a-a42a-18c7cc80c352', 'Corinna', 'Mottershaw', '5516730168', 'cmottershaw1c@wunderground.com', '5277 Delaware Place');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('5d9b0a1d-62ce-570c-ba61-24557b6f4e68', 'Kirk', 'Huyge', '1689611298', 'khuyge1d@miitbeian.gov.cn', '3 Prairie Rose Place');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('0154a6f6-0e6c-52c4-b709-95aaead8423e', 'Luigi', 'McKeowon', '1408457570', 'lmckeowon1e@stumbleupon.com', '84037 Mcguire Road');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('e0a97602-6480-588c-868f-bc044abf9cb5', 'Gay', 'Cattlow', '9608217666', 'gcattlow1f@mozilla.com', '09 Jenifer Point');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('f924209a-092e-58bb-b85e-4ceea176a660', 'Ferd', 'Hehl', '3772824173', 'fhehl1g@sakura.ne.jp', '9 Harbort Place');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('e1d79fd9-d2be-5d43-9714-87cf2a8567e0', 'Rosella', 'Tingcomb', '2708404472', 'rtingcomb1h@newsvine.com', '1 Sage Place');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('8a3edd46-2628-5d57-9865-13f273edf326', 'Alasdair', 'Skoate', '4969446736', 'askoate1i@trellian.com', '37555 Atwood Parkway');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('6460a618-c69d-5751-9c53-2d03d46ade51', 'Merwin', 'Cadlock', '5617645196', 'mcadlock1j@stumbleupon.com', '440 Mosinee Parkway');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('da992292-ffb1-5ab2-a6de-c19a9b0d0fd7', 'Taddeusz', 'Truett', '8657513639', 'ttruett1k@cbc.ca', '3 Glacier Hill Terrace');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('dcdd0263-6e8b-5cac-b79f-fe6a389a529a', 'Zitella', 'Gogarty', '8584330488', 'zgogarty1l@archive.org', '83983 Browning Way');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('02df7727-e4b1-5359-b25a-27eb2ba414b0', 'Roderic', 'Tointon', '2418174234', 'rtointon1m@latimes.com', '389 Canary Junction');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('7b2da8c5-bdc2-5d5a-b226-3e6746cf0d89', 'Margaretta', 'Godon', '7838616713', 'mgodon1n@virginia.edu', '72 Vahlen Way');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('397a09f8-fd35-5409-a27c-482947f05217', 'Wileen', 'Gelling', '6099827362', 'wgelling1o@mozilla.com', '09646 Glacier Hill Junction');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('c5ab2aae-6554-5bbe-bd14-997f20448114', 'Loren', 'Landsborough', '8407603895', 'llandsborough1p@surveymonkey.com', '71 Lakewood Place');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('87c35800-783c-5bed-afab-7a6fab481c46', 'Hayward', 'Rockliffe', '8539809897', 'hrockliffe1q@cyberchimps.com', '46563 Jay Avenue');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('ffd38492-0348-5b2d-8f08-3ff2ca0f4645', 'Ajay', 'Caffin', '5951340445', 'acaffin1r@ucoz.ru', '9617 South Parkway');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('61361ec8-6dd5-59da-a79f-3509bad1a524', 'Sherman', 'Ciobotaru', '8607982846', 'sciobotaru1s@a8.net', '26224 Morning Way');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('8b691658-669a-56db-9e92-a20b2c99ec08', 'Reynold', 'Cottham', '8678325869', 'rcottham1t@goo.gl', '3 Atwood Street');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('e5bcfc44-a2bf-5e3e-8de7-7031b3ddff2e', 'Aharon', 'Durden', '3408655642', 'adurden1u@hhs.gov', '48 Eagle Crest Alley');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('37a5ea60-8b87-58f5-9155-cfb6711b7e00', 'Jimmy', 'Lukianov', '6456631316', 'jlukianov1v@arizona.edu', '6141 Mandrake Drive');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('51a38ca6-6e81-549e-9790-41a1f4a96d3e', 'Bentley', 'Gogin', '4134593374', 'bgogin1w@merriam-webster.com', '43513 Kings Terrace');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('9e1fc8f8-d9e7-59ae-99a1-28465dcd0f6e', 'Hewe', 'Bodley', '7779243304', 'hbodley1x@netlog.com', '432 Superior Street');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('e6c0ad59-a52e-5938-887a-8a411e97298a', 'Dana', 'Volett', '4847890584', 'dvolett1y@virginia.edu', '1485 Maple Wood Trail');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('ad407b82-5446-5ad6-8061-cf6bcd51b875', 'Lacey', 'Issard', '5715186347', 'lissard1z@printfriendly.com', '78708 Fuller Hill');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('c25ac3f7-f861-51d9-991a-8db2fa1c4cb1', 'Darda', 'Biagi', '7623667649', 'dbiagi20@shinystat.com', '076 Morningstar Terrace');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('595487c4-7068-50fa-9768-19972d22e2cd', 'Duncan', 'Brinkman', '8269253573', 'dbrinkman21@bloglines.com', '6165 Sunfield Terrace');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('ef8bdc6a-9d29-5791-9e94-d6678ba6b4de', 'Ladonna', 'Defraine', '5688677728', 'ldefraine22@skype.com', '49295 Susan Plaza');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('f27890a1-f3b3-5142-a9b7-5297799d60dd', 'Christian', 'Boerderman', '1353402210', 'cboerderman23@sogou.com', '69 Burning Wood Way');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('d9ecf479-5e69-5001-b864-c71de51185a2', 'Myrtle', 'Ferryman', '9272713161', 'mferryman24@pen.io', '2482 Dapin Road');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('5bdcce0f-16bb-56e0-ae00-36ef8437f653', 'Brockie', 'Jozefowicz', '6752050221', 'bjozefowicz25@huffingtonpost.com', '0 Mariners Cove Center');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('734cdcf0-7107-550a-8e99-18ca5b1be1b7', 'Elsie', 'Lathbury', '4221805143', 'elathbury26@typepad.com', '457 Knutson Pass');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('9a6d4ea7-39e3-582e-bf94-fec1a5f9d685', 'Poppy', 'Gerty', '3637102970', 'pgerty27@tmall.com', '2 Starling Lane');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('591315a4-dbca-5cc7-af08-cbeeac98178b', 'Cassandre', 'Ventham', '1348063597', 'cventham28@berkeley.edu', '177 Annamark Way');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('1643c509-5bbe-5a87-bfa6-51b5ed07a83a', 'Kele', 'MacCartney', '3138700693', 'kmaccartney29@slideshare.net', '3434 Lake View Crossing');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('312a6ee4-fdec-5229-86e2-e0df521cf306', 'Joella', 'Ketchaside', '9069265865', 'jketchaside2a@dyndns.org', '35 Shelley Place');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('f2b6f9a7-531d-5d97-9bf1-4177c33e5070', 'Ilse', 'Harriman', '2437035866', 'iharriman2b@google.com', '08 Scofield Lane');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('7bafb091-c361-5517-82a8-4d3d0809e9f9', 'Jaquenetta', 'Taffarello', '8934942953', 'jtaffarello2c@state.tx.us', '3023 Meadow Ridge Park');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('f3cf4d43-6a2c-560d-9a2a-5c77331b913b', 'Hermina', 'Billows', '5661763397', 'hbillows2d@wikia.com', '00410 Nancy Alley');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('5981de99-b8e5-5048-a219-ab103e9cf914', 'Arthur', 'Ablewhite', '9387197125', 'aablewhite2e@google.com.au', '070 Scofield Park');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('4baeee02-b9b3-5ecd-9f1b-400dbac56b82', 'Franklyn', 'Hamshar', '9694330727', 'fhamshar2f@jigsy.com', '25 Vermont Place');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('21d1bd6c-49e3-5d81-a799-5af7da862936', 'Corty', 'D''orsay', '1433645627', 'cdorsay2g@washingtonpost.com', '81098 Anderson Alley');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('2b173f18-8c74-5e19-a7d4-3212f74017a8', 'Aguste', 'Rubenchik', '4533885367', 'arubenchik2h@nature.com', '38 Gateway Lane');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('0962b5eb-2409-5618-b05f-8569ea0dc35d', 'Elinor', 'Stutte', '9956015662', 'estutte2i@jiathis.com', '7 Monument Parkway');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('28dbb2ff-741d-5333-b7e5-3f80aa14c1c6', 'Deirdre', 'Jakolevitch', '2296602072', 'djakolevitch2j@nbcnews.com', '0 Elgar Park');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('4df2f065-ecff-52cf-bc07-6ff6b3ee09e3', 'Kelley', 'Southorn', '4678492727', 'ksouthorn2k@wikispaces.com', '90738 Dapin Alley');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('9b99a42f-1ce6-52a0-90ea-5e234201500b', 'Whit', 'Antonat', '2451898746', 'wantonat2l@independent.co.uk', '600 Grim Plaza');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('7aae4a9a-e6b4-5a28-a978-e42b2ab8d101', 'Margaretta', 'Whorf', '5481632749', 'mwhorf2m@macromedia.com', '7 Roth Avenue');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('1a715879-7dba-5a42-b3c5-5a51b46e89e3', 'Romola', 'Giacopello', '9828109367', 'rgiacopello2n@drupal.org', '7878 Claremont Circle');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('521fd768-7a4b-5e3e-89be-f7dd8886c93a', 'Delbert', 'Tedder', '7152530828', 'dtedder2o@yahoo.co.jp', '73 Mifflin Park');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('5c089632-6f1a-564f-b429-2955bdd874b9', 'Eirena', 'Wilding', '1892769328', 'ewilding2p@domainmarket.com', '7 Anhalt Hill');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('429ae5d7-3799-5593-80e0-124f3d1d745c', 'Maisie', 'Blint', '3462605018', 'mblint2q@google.ru', '4008 Darwin Trail');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('0e0d1ce5-d1bf-5fa3-ad2e-16ac0f4a09ce', 'Krisha', 'Moreing', '9774951374', 'kmoreing2r@globo.com', '172 Mariners Cove Way');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('f4dcc643-023d-5d78-8c15-6440a77bdaa5', 'Myron', 'Draisey', '5636438394', 'mdraisey2s@desdev.cn', '33293 Sundown Crossing');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('1e87b2cb-937b-566a-9d91-b9346906a089', 'Keir', 'Brocket', '6987655319', 'kbrocket2t@booking.com', '2 Bowman Alley');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('a8d68fbf-bd6e-5461-a9d1-cf1bb3522e38', 'Rocky', 'Edgeler', '5988857610', 'redgeler2u@moonfruit.com', '5 Browning Crossing');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('5ac9e002-7ee9-5996-85a8-81aee6245b2f', 'Ario', 'Trittam', '4262256803', 'atrittam2v@ucsd.edu', '364 Eliot Hill');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('433627d8-25db-5910-bc62-a4a7c9bb46ee', 'Tobe', 'Haddington', '6659863501', 'thaddington2w@theglobeandmail.com', '269 Cardinal Road');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('defc7e4d-5c10-5ae6-a39e-4c769dcddd16', 'Sella', 'Lyddy', '2648498421', 'slyddy2x@sfgate.com', '170 Waywood Trail');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('4d208dbd-e748-55a8-b5a6-277519c28ba7', 'Cora', 'Lodo', '4945918932', 'clodo2y@shinystat.com', '932 Buell Hill');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('2bc68972-85bf-5649-b30e-882d49979a4f', 'Temp', 'Mallindine', '2441212974', 'tmallindine2z@apple.com', '7 Maywood Avenue');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('dc51ea82-01d5-516a-a436-2e67de02bef8', 'Eberhard', 'Rouge', '7845568205', 'erouge30@tmall.com', '85724 Village Green Court');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('339d0599-3c01-51c8-8026-50e69c4c7175', 'Oran', 'Chuter', '4018745035', 'ochuter31@fastcompany.com', '714 Larry Parkway');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('fb4e21a3-5824-540f-88af-1de0a7a472a6', 'Lenette', 'Bawle', '9499168466', 'lbawle32@yandex.ru', '14706 Lyons Point');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('53859c4a-066f-5b06-89cf-dfa38ad94026', 'Elijah', 'Molohan', '2856372075', 'emolohan33@cam.ac.uk', '2438 Mcbride Avenue');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('2acbf600-dfa8-519a-bd54-5cbf6eb6f7d1', 'Shara', 'Gain', '7549370728', 'sgain34@multiply.com', '34238 Forster Plaza');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('21708e2e-2e2d-5fe1-a12a-f8e0cb4dbb7b', 'Yard', 'Dalgarnocht', '5547824363', 'ydalgarnocht35@mapy.cz', '13 Loftsgordon Park');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('155270fb-fb4d-5086-bc16-1289ba541bf6', 'Felecia', 'Tomini', '1326723883', 'ftomini36@pen.io', '1 Ramsey Terrace');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('ce048143-c17b-56b8-bd9f-99a93e682d5a', 'Jordana', 'Amsberger', '6682178148', 'jamsberger37@phpbb.com', '9132 Golden Leaf Street');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('8cf5bb1b-6aba-5479-9244-73f54450548f', 'Cindi', 'Diprose', '1814117665', 'cdiprose38@nih.gov', '4 Farmco Trail');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('510db773-9fb8-5084-a1c8-c465a40391e0', 'Kitty', 'Gutcher', '2233718177', 'kgutcher39@un.org', '2 Starling Road');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('33248502-684f-5935-8702-f8287a12e13b', 'Caitlin', 'Ridsdole', '9565254162', 'cridsdole3a@barnesandnoble.com', '69432 Almo Point');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('bea3a1d8-e7b4-5f6d-8e61-69c8a92e32ad', 'See', 'Ellwell', '2441122575', 'sellwell3b@slideshare.net', '2 Karstens Court');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('5b63c113-5630-53fe-a769-39d5ba43be7e', 'Karon', 'Lorrimer', '3857622972', 'klorrimer3c@icq.com', '52 Macpherson Hill');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('cc71e88d-47db-5010-b532-fbd62c9d058f', 'Jo', 'Rioch', '6328585430', 'jrioch3d@hp.com', '67591 Corscot Trail');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('3bce8de0-ab5d-5f8d-9b53-f3adce131b94', 'Gustavus', 'Whiskin', '9304529210', 'gwhiskin3e@hao123.com', '476 Forster Plaza');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('fa391aea-3137-5bb9-845d-6db7d8fb041d', 'Camey', 'Gogan', '3118500049', 'cgogan3f@cbslocal.com', '25 Blackbird Alley');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('21d4a6bf-edbb-58a1-af98-dd9dcaf77ed7', 'Bren', 'Sambals', '2688342787', 'bsambals3g@apple.com', '4129 Dapin Center');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('1ba78096-81f8-596d-a53a-8cdad00d0366', 'Doralia', 'Clappison', '6751108296', 'dclappison3h@fema.gov', '3 Charing Cross Avenue');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('2c9c0a40-acc8-53d3-8947-42782b8a90ef', 'Brandais', 'Dobbins', '2303621329', 'bdobbins3i@economist.com', '8 Bluejay Junction');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('238b0b9b-ac80-5515-86c7-932971f4c9e7', 'Priscella', 'Astlet', '5236547210', 'pastlet3j@histats.com', '8926 Briar Crest Place');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('7a3a44b1-919a-514a-92aa-18715c5a2a7d', 'Reginauld', 'Vaar', '7207615870', 'rvaar3k@google.es', '1 Lunder Circle');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('175ac5ff-49bf-543e-89d9-ad2b38be7f36', 'Laurel', 'Gothard', '2249169744', 'lgothard3l@seattletimes.com', '6 Harper Center');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('8ea32227-ba38-5c6f-8950-c1b7b73fab62', 'Karie', 'Hindge', '9192966408', 'khindge3m@census.gov', '6 Heath Alley');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('70cb5e24-ad38-5096-880c-02e1c54b7483', 'Anabelle', 'Dinley', '1911060157', 'adinley3n@lycos.com', '21 Maple Crossing');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('bcd941ba-790d-51f9-a3a0-52abbc6b173d', 'Bridie', 'Stoves', '4484279277', 'bstoves3o@ustream.tv', '719 Rieder Alley');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('5c7ef325-af56-5cea-a65d-b2f1b48280ab', 'Tabbitha', 'Sandbrook', '6079206434', 'tsandbrook3p@tinypic.com', '373 American Ash Street');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('cb43e6c2-3dd6-50de-a014-8207e36e3686', 'Vanya', 'Wimes', '7852796370', 'vwimes3q@ning.com', '40994 Graedel Street');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('9b74ff79-38e7-5ab7-b183-ada5f90ad920', 'Elia', 'Legging', '9192564631', 'elegging3r@51.la', '4176 Del Sol Avenue');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('831f49b3-6d36-59e8-82a1-779cd3973e98', 'Orrin', 'Hopfer', '5896099530', 'ohopfer3s@jugem.jp', '2 Rockefeller Plaza');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('a8a16b8e-b782-524e-987a-85bb2cf14518', 'Torrey', 'Tebbe', '9892112673', 'ttebbe3t@techcrunch.com', '466 Mesta Place');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('fced75c1-7380-5ec2-81c1-cfd247fe1345', 'Garrot', 'Frangello', '2171661177', 'gfrangello3u@tripadvisor.com', '5350 Northland Road');
insert into Non_Pemain (ID, Nama_Depan, Nama_Belakang, Nomor_HP, Email, Alamat) values ('2f9a8828-f896-5f46-8cbd-017b2bb6991d', 'Joelle', 'Pembridge', '6552423311', 'jpembridge3v@huffingtonpost.com', '5311 Kinsman Pass');

--
-- Dumping data for table Wasit
--
insert into Wasit (ID_Wasit, Lisensi) values ('996ad860-2a9a-504f-8861-aeafd0b2ae29', 'VW4-Eoa');
insert into Wasit (ID_Wasit, Lisensi) values ('59e06cf8-f390-5093-af2e-3685be593a25', '48Z-xzE');
insert into Wasit (ID_Wasit, Lisensi) values ('391ada15-580c-5baa-b16f-eeb35d9b1122', 'ACc-MAX');
insert into Wasit (ID_Wasit, Lisensi) values ('22fe83ae-a20f-54fc-b436-cec85c94c5e8', 'l8p-ju5');
insert into Wasit (ID_Wasit, Lisensi) values ('b7d55bf4-7057-5113-85c8-141871bf7635', 'PwN-OcH');
insert into Wasit (ID_Wasit, Lisensi) values ('1883fdfb-249b-58f5-b445-87dff6eabc06', 'Pb6-dAe');
insert into Wasit (ID_Wasit, Lisensi) values ('d6ed313e-533a-55a6-aa06-4c00bc132812', '87o-ZQW');
insert into Wasit (ID_Wasit, Lisensi) values ('9090025d-5d06-58f1-b79a-3690407024fc', 'K7t-cHK');
insert into Wasit (ID_Wasit, Lisensi) values ('751af8b4-32a7-55bc-9fad-8bfbcbbf4237', 'aH4-IMK');
insert into Wasit (ID_Wasit, Lisensi) values ('305f5e8d-e48d-5c3a-8ce3-446622dd8a8a', 'bK4-UKc');
insert into Wasit (ID_Wasit, Lisensi) values ('a4c08562-50fa-5599-939c-eb6f2a83a362', 'g9w-ljm');
insert into Wasit (ID_Wasit, Lisensi) values ('d35aeaf3-5d1d-535a-a31a-22133ddf5f3d', 'lqZ-USh');
insert into Wasit (ID_Wasit, Lisensi) values ('61c97311-bb14-5679-99fc-98497a701292', 'p1F-msf');
insert into Wasit (ID_Wasit, Lisensi) values ('1bb138f7-5f19-587c-8a25-fb174eabf441', 'en1-Efh');
insert into Wasit (ID_Wasit, Lisensi) values ('be6c2a5f-4160-5145-8695-c628496b208d', 'dMx-xuH');
insert into Wasit (ID_Wasit, Lisensi) values ('7dbed579-ec83-5f9b-8aa3-1c40e858acfc', '6gX-HU8');
insert into Wasit (ID_Wasit, Lisensi) values ('bcc896de-3c61-523e-973c-052f16456e28', 'Fc2-7Oz');
insert into Wasit (ID_Wasit, Lisensi) values ('77b34e74-5631-5a71-b8ce-97b9d6bab10a', 'JRr-Mr7');
insert into Wasit (ID_Wasit, Lisensi) values ('9d58db4d-28b7-56fc-9b12-db9a3e9d0769', 'NuZ-E1Q');
insert into Wasit (ID_Wasit, Lisensi) values ('6fea451e-90db-5366-bbde-9a65b83f8f64', 'ZYR-Iqo');

--
-- Dumping data for table Status_Non_Pemain
--

insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('996ad860-2a9a-504f-8861-aeafd0b2ae29', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('59e06cf8-f390-5093-af2e-3685be593a25', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('391ada15-580c-5baa-b16f-eeb35d9b1122', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('22fe83ae-a20f-54fc-b436-cec85c94c5e8', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('b7d55bf4-7057-5113-85c8-141871bf7635', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('1883fdfb-249b-58f5-b445-87dff6eabc06', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('d6ed313e-533a-55a6-aa06-4c00bc132812', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('9090025d-5d06-58f1-b79a-3690407024fc', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('751af8b4-32a7-55bc-9fad-8bfbcbbf4237', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('305f5e8d-e48d-5c3a-8ce3-446622dd8a8a', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('a4c08562-50fa-5599-939c-eb6f2a83a362', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('d35aeaf3-5d1d-535a-a31a-22133ddf5f3d', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('61c97311-bb14-5679-99fc-98497a701292', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('1bb138f7-5f19-587c-8a25-fb174eabf441', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('be6c2a5f-4160-5145-8695-c628496b208d', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('7dbed579-ec83-5f9b-8aa3-1c40e858acfc', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('bcc896de-3c61-523e-973c-052f16456e28', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('77b34e74-5631-5a71-b8ce-97b9d6bab10a', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('9d58db4d-28b7-56fc-9b12-db9a3e9d0769', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('6fea451e-90db-5366-bbde-9a65b83f8f64', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('0df2c324-4b3b-5e4b-8574-770c7c601dc4', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('05596e20-ebb9-571a-9f7c-250cbacfb499', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('32b736a1-2bed-5f62-8131-c3dc9a2a33c7', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('29be4ef0-91eb-512b-8f83-360b6db38a83', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('46f64ca6-6094-51fc-bbbe-34e3333c5388', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('8df6e0fb-0d35-5fd6-831a-7e5b9ad2457a', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('5151e75a-9d7d-5897-be85-aaa96757564b', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('21f6a510-8fff-5bed-9d0e-df7b2ca28db1', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('3eee96fe-b265-5e36-8d78-b2d50a9ac563', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('720073c2-6984-53fa-9546-b893e83e0f62', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('b0526112-ddde-5dbf-b887-9b6f93557007', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('b85b4ff7-2f5e-5d5d-bcda-728e00ad61de', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('7561fe4e-6ffd-5631-96d6-cf89fdadba83', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('ae5a160a-ca64-5557-a0d8-1fdd610d83e1', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('5429db33-2d2c-51e4-9b96-9918a6a67f07', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('214f116d-a5a3-5203-867d-28bcad2b6c1a', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('c18d0fc0-d829-5009-a349-094ea30c386b', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('c3205bf1-c929-5b45-af5a-42b59ab87391', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('6863109a-0444-5f87-b018-66483cb30f22', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('b4ab3922-2b8d-5d9c-b20a-e34bbc64c01f', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('08d2a401-c6d0-56d0-bfca-d8fe47a0ccde', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('ba293c61-ad33-57b9-9671-f3319f57d789', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('45fae334-63fa-5064-9e45-024ff9e0095c', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('fce23375-fdd4-5b30-8e57-a401e5265ba1', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('b5a095ae-2fa5-5416-a5c3-4b3e8a7d0f9c', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('8060dbbf-e5cc-5ed8-b6a8-9c463ae3f1ef', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('36054888-8e10-578a-b964-a1e6efebf8bf', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('ae0f5d2b-52f8-5845-8572-d7c586982e02', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('651ee801-9621-5f6a-a42a-18c7cc80c352', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('5d9b0a1d-62ce-570c-ba61-24557b6f4e68', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('0154a6f6-0e6c-52c4-b709-95aaead8423e', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('e0a97602-6480-588c-868f-bc044abf9cb5', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('f924209a-092e-58bb-b85e-4ceea176a660', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('e1d79fd9-d2be-5d43-9714-87cf2a8567e0', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('8a3edd46-2628-5d57-9865-13f273edf326', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('6460a618-c69d-5751-9c53-2d03d46ade51', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('da992292-ffb1-5ab2-a6de-c19a9b0d0fd7', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('dcdd0263-6e8b-5cac-b79f-fe6a389a529a', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('02df7727-e4b1-5359-b25a-27eb2ba414b0', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('7b2da8c5-bdc2-5d5a-b226-3e6746cf0d89', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('397a09f8-fd35-5409-a27c-482947f05217', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('c5ab2aae-6554-5bbe-bd14-997f20448114', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('87c35800-783c-5bed-afab-7a6fab481c46', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('ffd38492-0348-5b2d-8f08-3ff2ca0f4645', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('61361ec8-6dd5-59da-a79f-3509bad1a524', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('8b691658-669a-56db-9e92-a20b2c99ec08', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('e5bcfc44-a2bf-5e3e-8de7-7031b3ddff2e', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('37a5ea60-8b87-58f5-9155-cfb6711b7e00', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('51a38ca6-6e81-549e-9790-41a1f4a96d3e', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('9e1fc8f8-d9e7-59ae-99a1-28465dcd0f6e', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('e6c0ad59-a52e-5938-887a-8a411e97298a', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('ad407b82-5446-5ad6-8061-cf6bcd51b875', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('c25ac3f7-f861-51d9-991a-8db2fa1c4cb1', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('595487c4-7068-50fa-9768-19972d22e2cd', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('ef8bdc6a-9d29-5791-9e94-d6678ba6b4de', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('f27890a1-f3b3-5142-a9b7-5297799d60dd', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('d9ecf479-5e69-5001-b864-c71de51185a2', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('5bdcce0f-16bb-56e0-ae00-36ef8437f653', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('734cdcf0-7107-550a-8e99-18ca5b1be1b7', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('9a6d4ea7-39e3-582e-bf94-fec1a5f9d685', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('591315a4-dbca-5cc7-af08-cbeeac98178b', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('1643c509-5bbe-5a87-bfa6-51b5ed07a83a', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('312a6ee4-fdec-5229-86e2-e0df521cf306', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('f2b6f9a7-531d-5d97-9bf1-4177c33e5070', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('7bafb091-c361-5517-82a8-4d3d0809e9f9', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('f3cf4d43-6a2c-560d-9a2a-5c77331b913b', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('5981de99-b8e5-5048-a219-ab103e9cf914', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('4baeee02-b9b3-5ecd-9f1b-400dbac56b82', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('21d1bd6c-49e3-5d81-a799-5af7da862936', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('2b173f18-8c74-5e19-a7d4-3212f74017a8', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('0962b5eb-2409-5618-b05f-8569ea0dc35d', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('28dbb2ff-741d-5333-b7e5-3f80aa14c1c6', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('4df2f065-ecff-52cf-bc07-6ff6b3ee09e3', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('9b99a42f-1ce6-52a0-90ea-5e234201500b', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('7aae4a9a-e6b4-5a28-a978-e42b2ab8d101', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('1a715879-7dba-5a42-b3c5-5a51b46e89e3', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('521fd768-7a4b-5e3e-89be-f7dd8886c93a', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('5c089632-6f1a-564f-b429-2955bdd874b9', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('429ae5d7-3799-5593-80e0-124f3d1d745c', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('0e0d1ce5-d1bf-5fa3-ad2e-16ac0f4a09ce', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('f4dcc643-023d-5d78-8c15-6440a77bdaa5', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('1e87b2cb-937b-566a-9d91-b9346906a089', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('a8d68fbf-bd6e-5461-a9d1-cf1bb3522e38', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('5ac9e002-7ee9-5996-85a8-81aee6245b2f', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('433627d8-25db-5910-bc62-a4a7c9bb46ee', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('defc7e4d-5c10-5ae6-a39e-4c769dcddd16', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('4d208dbd-e748-55a8-b5a6-277519c28ba7', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('2bc68972-85bf-5649-b30e-882d49979a4f', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('dc51ea82-01d5-516a-a436-2e67de02bef8', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('339d0599-3c01-51c8-8026-50e69c4c7175', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('fb4e21a3-5824-540f-88af-1de0a7a472a6', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('53859c4a-066f-5b06-89cf-dfa38ad94026', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('2acbf600-dfa8-519a-bd54-5cbf6eb6f7d1', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('21708e2e-2e2d-5fe1-a12a-f8e0cb4dbb7b', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('155270fb-fb4d-5086-bc16-1289ba541bf6', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('ce048143-c17b-56b8-bd9f-99a93e682d5a', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('8cf5bb1b-6aba-5479-9244-73f54450548f', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('510db773-9fb8-5084-a1c8-c465a40391e0', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('33248502-684f-5935-8702-f8287a12e13b', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('bea3a1d8-e7b4-5f6d-8e61-69c8a92e32ad', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('5b63c113-5630-53fe-a769-39d5ba43be7e', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('cc71e88d-47db-5010-b532-fbd62c9d058f', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('3bce8de0-ab5d-5f8d-9b53-f3adce131b94', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('fa391aea-3137-5bb9-845d-6db7d8fb041d', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('21d4a6bf-edbb-58a1-af98-dd9dcaf77ed7', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('1ba78096-81f8-596d-a53a-8cdad00d0366', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('2c9c0a40-acc8-53d3-8947-42782b8a90ef', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('238b0b9b-ac80-5515-86c7-932971f4c9e7', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('7a3a44b1-919a-514a-92aa-18715c5a2a7d', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('175ac5ff-49bf-543e-89d9-ad2b38be7f36', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('8ea32227-ba38-5c6f-8950-c1b7b73fab62', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('70cb5e24-ad38-5096-880c-02e1c54b7483', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('bcd941ba-790d-51f9-a3a0-52abbc6b173d', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('5c7ef325-af56-5cea-a65d-b2f1b48280ab', 'umum');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('cb43e6c2-3dd6-50de-a014-8207e36e3686', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('9b74ff79-38e7-5ab7-b183-ada5f90ad920', 'mahasiswa');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('831f49b3-6d36-59e8-82a1-779cd3973e98', 'tendik');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('a8a16b8e-b782-524e-987a-85bb2cf14518', 'alumni');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('fced75c1-7380-5ec2-81c1-cfd247fe1345', 'dosen');
insert into Status_Non_Pemain (ID_Non_Pemain, Status) values ('2f9a8828-f896-5f46-8cbd-017b2bb6991d', 'mahasiswa');

--
-- 6. Dumping data for table Stadium
--

INSERT INTO Stadium VALUES
('1eb5c363-afda-475c-bd23-8734e6de9079','The Green Field','98815 Melby Point',198200),
('1e0712f9-b591-4159-b32b-d004e420ba59','The Victory Ground','9049 Cordelia Terrace',1800),
('b82dff14-10be-4120-8ed8-42913d2822e2','The Blue Stadium','3 Barnett Place',493000),
('e3274b58-2c97-47d5-9715-3ee72b6b2940','The Orange Pitch','85206 Miller Way',82372),
('c86d2466-32c9-41ac-a4a3-e3d632270421','The Red Field','92 Jenna Plaza',812780),
('29e27c11-aeb2-4593-932b-cd5963c7dea9','The Soccer Palace','5 Sutteridge Crossing',823300),
('d286e09f-e818-4ce5-a8ba-b5b04244c985','The Black Pitch','419 Trailsway Crossing',92300),
('3f382ee5-aa43-42bd-b869-b79e0c86edef','The Yellow Field','62369 Morrow Drive',10000),
('3086f669-59c3-4ab4-abb3-554f421afb8d','The Grey Stadium','0642 Hudson Terrace',238400),
('de8cc15e-67ae-42f1-9cff-e75e638e2ea9','The White Pitch','5566 Rieder Plaza',912900);

--
-- 7. Dumping data for table Perlengkapan_Stadium
--
INSERT INTO Perlengkapan_Stadium VALUES
('1eb5c363-afda-475c-bd23-8734e6de9079','Corner Flags',22),
('1e0712f9-b591-4159-b32b-d004e420ba59','Goalkeeper Gloves',71),
('b82dff14-10be-4120-8ed8-42913d2822e2','Stadium Seats',94),
('e3274b58-2c97-47d5-9715-3ee72b6b2940','Cones',41),
('c86d2466-32c9-41ac-a4a3-e3d632270421','Training Bibs',79),
('29e27c11-aeb2-4593-932b-cd5963c7dea9','Whistles',84),
('d286e09f-e818-4ce5-a8ba-b5b04244c985','Referee Cards',2),
('3f382ee5-aa43-42bd-b869-b79e0c86edef','Match Balls',45),
('3086f669-59c3-4ab4-abb3-554f421afb8d','Corner Flags',68),
('de8cc15e-67ae-42f1-9cff-e75e638e2ea9','Goal Nets',58),
('1eb5c363-afda-475c-bd23-8734e6de9079','Stadium Lights',73),
('1e0712f9-b591-4159-b32b-d004e420ba59','Training Cones',92),
('b82dff14-10be-4120-8ed8-42913d2822e2','Portable Goals',64),
('e3274b58-2c97-47d5-9715-3ee72b6b2940','Bench',5),
('c86d2466-32c9-41ac-a4a3-e3d632270421','Water Bottles',98),
('29e27c11-aeb2-4593-932b-cd5963c7dea9','First Aid Kit',6),
('d286e09f-e818-4ce5-a8ba-b5b04244c985','Referee Whistle',16),
('3f382ee5-aa43-42bd-b869-b79e0c86edef','Cones',97),
('3086f669-59c3-4ab4-abb3-554f421afb8d','Stadium Seats',33),
('de8cc15e-67ae-42f1-9cff-e75e638e2ea9','Goalkeeper Jersey',80);

--
-- 8. Dumping data for table Pertandingan
--

INSERT INTO Pertandingan VALUES
('d7480883-2dbe-4881-9455-972277c66ff8','2022-06-30','2022-06-30','1eb5c363-afda-475c-bd23-8734e6de9079'),
('c23c1c0e-0ef4-41f2-b04d-b66f258aa06b','2022-02-14','2022-02-14','1e0712f9-b591-4159-b32b-d004e420ba59'),
('dfec7971-dd28-4ea9-abe1-df1110b9bfaf','2022-05-01','2022-05-01','b82dff14-10be-4120-8ed8-42913d2822e2'),
('f2738590-5358-4004-bc09-0fae91fe3c9b','2022-03-22','2022-03-22','e3274b58-2c97-47d5-9715-3ee72b6b2940'),
('431a92e6-608b-46b7-b753-da3e3c21e743','2022-01-01','2022-01-01','c86d2466-32c9-41ac-a4a3-e3d632270421');

--
-- 9. Dumping data for table Peristiwa
--

INSERT INTO Peristiwa VALUES
('431a92e6-608b-46b7-b753-da3e3c21e743','2022-01-01 17:27:00','Injured','996ad860-2a9a-504f-8861-aeafd0b2ae29'),
('dfec7971-dd28-4ea9-abe1-df1110b9bfaf','2022-05-01 15:10:00','Own Goal','59e06cf8-f390-5093-af2e-3685be593a25'),
('f2738590-5358-4004-bc09-0fae91fe3c9b','2022-03-22 19:26:00','Red Card','391ada15-580c-5baa-b16f-eeb35d9b1122'),
('431a92e6-608b-46b7-b753-da3e3c21e743','2022-01-01 16:11:00','Foul','996ad860-2a9a-504f-8861-aeafd0b2ae29'),
('d7480883-2dbe-4881-9455-972277c66ff8','2022-06-30 10:07:00','Red Card','59e06cf8-f390-5093-af2e-3685be593a25'),
('c23c1c0e-0ef4-41f2-b04d-b66f258aa06b','2022-02-14 20:46:01','Penalty Kick','391ada15-580c-5baa-b16f-eeb35d9b1122'),
('dfec7971-dd28-4ea9-abe1-df1110b9bfaf','2022-05-01 13:31:00','Penalty Kick','996ad860-2a9a-504f-8861-aeafd0b2ae29'),
('d7480883-2dbe-4881-9455-972277c66ff8','2022-06-30 14:25:00','Free Kick','391ada15-580c-5baa-b16f-eeb35d9b1122'),
('c23c1c0e-0ef4-41f2-b04d-b66f258aa06b','2022-02-14 23:51:00','Handsball','996ad860-2a9a-504f-8861-aeafd0b2ae29'),
('dfec7971-dd28-4ea9-abe1-df1110b9bfaf','2022-05-01 15:55:00','Own Goal','1883fdfb-249b-58f5-b445-87dff6eabc06');

--
-- 10. Dumping data for table Wasit_Bertugas
--

INSERT INTO Wasit_Bertugas (ID_Wasit, ID_Pertandingan, Posisi_Wasit) VALUES ('1883fdfb-249b-58f5-b445-87dff6eabc06', 'd7480883-2dbe-4881-9455-972277c66ff8', 'utama');
INSERT INTO Wasit_Bertugas (ID_Wasit, ID_Pertandingan, Posisi_Wasit) VALUES ('9090025d-5d06-58f1-b79a-3690407024fc', 'dfec7971-dd28-4ea9-abe1-df1110b9bfaf', 'pembantu');
INSERT INTO Wasit_Bertugas (ID_Wasit, ID_Pertandingan, Posisi_Wasit) VALUES ('305f5e8d-e48d-5c3a-8ce3-446622dd8a8a', 'd7480883-2dbe-4881-9455-972277c66ff8', 'cadangan');
INSERT INTO Wasit_Bertugas (ID_Wasit, ID_Pertandingan, Posisi_Wasit) VALUES ('61c97311-bb14-5679-99fc-98497a701292', 'dfec7971-dd28-4ea9-abe1-df1110b9bfaf', 'utama');
INSERT INTO Wasit_Bertugas (ID_Wasit, ID_Pertandingan, Posisi_Wasit) VALUES ('7dbed579-ec83-5f9b-8aa3-1c40e858acfc', 'dfec7971-dd28-4ea9-abe1-df1110b9bfaf', 'pembantu');
INSERT INTO Wasit_Bertugas (ID_Wasit, ID_Pertandingan, Posisi_Wasit) VALUES ('996ad860-2a9a-504f-8861-aeafd0b2ae29', 'f2738590-5358-4004-bc09-0fae91fe3c9b', 'cadangan');
INSERT INTO Wasit_Bertugas (ID_Wasit, ID_Pertandingan, Posisi_Wasit) VALUES ('22fe83ae-a20f-54fc-b436-cec85c94c5e8', 'd7480883-2dbe-4881-9455-972277c66ff8', 'pembantu');
INSERT INTO Wasit_Bertugas (ID_Wasit, ID_Pertandingan, Posisi_Wasit) VALUES ('b7d55bf4-7057-5113-85c8-141871bf7635', 'd7480883-2dbe-4881-9455-972277c66ff8', 'pembantu');
INSERT INTO Wasit_Bertugas (ID_Wasit, ID_Pertandingan, Posisi_Wasit) VALUES ('751af8b4-32a7-55bc-9fad-8bfbcbbf4237', 'dfec7971-dd28-4ea9-abe1-df1110b9bfaf', 'cadangan');
INSERT INTO Wasit_Bertugas (ID_Wasit, ID_Pertandingan, Posisi_Wasit) VALUES ('a4c08562-50fa-5599-939c-eb6f2a83a362', 'f2738590-5358-4004-bc09-0fae91fe3c9b', 'utama');

--
-- 11. Dumping data for table Penonton
--

INSERT INTO Penonton (ID_Penonton, Username) VALUES ('5b63c113-5630-53fe-a769-39d5ba43be7e', 'bbrayn14');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('cc71e88d-47db-5010-b532-fbd62c9d058f', 'mseamon15');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('3bce8de0-ab5d-5f8d-9b53-f3adce131b94', 'rbernaert16');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('fa391aea-3137-5bb9-845d-6db7d8fb041d', 'mnoto17');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('21d4a6bf-edbb-58a1-af98-dd9dcaf77ed7', 'caggus18');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('1ba78096-81f8-596d-a53a-8cdad00d0366', 'rtaynton19');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('2c9c0a40-acc8-53d3-8947-42782b8a90ef', 'rbellee1a');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('238b0b9b-ac80-5515-86c7-932971f4c9e7', 'ebanat1b');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('7a3a44b1-919a-514a-92aa-18715c5a2a7d', 'bbrezlaw1c');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('175ac5ff-49bf-543e-89d9-ad2b38be7f36', 'hgatman1d');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('8ea32227-ba38-5c6f-8950-c1b7b73fab62', 'fmargareta');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('70cb5e24-ad38-5096-880c-02e1c54b7483', 'mmuddb');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('bcd941ba-790d-51f9-a3a0-52abbc6b173d', 'rbostockc');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('5c7ef325-af56-5cea-a65d-b2f1b48280ab', 'bdallanderd');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('cb43e6c2-3dd6-50de-a014-8207e36e3686', 'plongeae');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('9b74ff79-38e7-5ab7-b183-ada5f90ad920', 'rgentilef');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('831f49b3-6d36-59e8-82a1-779cd3973e98', 'kvarnsg');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('a8a16b8e-b782-524e-987a-85bb2cf14518', 'kabbatih');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('fced75c1-7380-5ec2-81c1-cfd247fe1345', 'gwillisoni');
INSERT INTO Penonton (ID_Penonton, Username) VALUES ('2f9a8828-f896-5f46-8cbd-017b2bb6991d', 'bmaaszj');

--
-- 12. Dumping data for table Pembelian_Tiket
--

INSERT INTO Pembelian_Tiket (Nomor_Receipt, ID_Penonton, Jenis_Tiket, Jenis_Pembayaran, ID_Pertandingan) VALUES ('RCP00001', '1ba78096-81f8-596d-a53a-8cdad00d0366', 'VIP', 'Shopeepay', 'd7480883-2dbe-4881-9455-972277c66ff8');
INSERT INTO Pembelian_Tiket (Nomor_Receipt, ID_Penonton, Jenis_Tiket, Jenis_Pembayaran, ID_Pertandingan) VALUES ('RCP00002', '70cb5e24-ad38-5096-880c-02e1c54b7483', 'Kategori 1', 'Gopay', 'c23c1c0e-0ef4-41f2-b04d-b66f258aa06b');
INSERT INTO Pembelian_Tiket (Nomor_Receipt, ID_Penonton, Jenis_Tiket, Jenis_Pembayaran, ID_Pertandingan) VALUES ('RCP00003', '7a3a44b1-919a-514a-92aa-18715c5a2a7d', 'VIP', 'OVO', 'c23c1c0e-0ef4-41f2-b04d-b66f258aa06b');
INSERT INTO Pembelian_Tiket (Nomor_Receipt, ID_Penonton, Jenis_Tiket, Jenis_Pembayaran, ID_Pertandingan) VALUES ('RCP00004', '238b0b9b-ac80-5515-86c7-932971f4c9e7', 'Main east', 'Debit', '431a92e6-608b-46b7-b753-da3e3c21e743');
INSERT INTO Pembelian_Tiket (Nomor_Receipt, ID_Penonton, Jenis_Tiket, Jenis_Pembayaran, ID_Pertandingan) VALUES ('RCP00005', '2f9a8828-f896-5f46-8cbd-017b2bb6991d', 'Kategori 2', 'Gopay', 'dfec7971-dd28-4ea9-abe1-df1110b9bfaf');

--
-- 13. Dumping data for table Panitia
--

INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('0df2c324-4b3b-5e4b-8574-770c7c601dc4', 'Ketua Perlengkapan', 'mleithgoek');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('05596e20-ebb9-571a-9f7c-250cbacfb499', 'Ketua Konsumsi', 'lhordelll');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('32b736a1-2bed-5f62-8131-c3dc9a2a33c7', 'Staf Kebersihan', 'svanyukhinm');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('29be4ef0-91eb-512b-8f83-360b6db38a83', 'Ketua Acara', 'fsanchezn');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('46f64ca6-6094-51fc-bbbe-34e3333c5388', 'Staf Konsumsi', 'cgermono');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('8df6e0fb-0d35-5fd6-831a-7e5b9ad2457a', 'Staf Acara', 'icourtneyp');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('5151e75a-9d7d-5897-be85-aaa96757564b', 'Ketua Keamanan', 'epockeyq');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('21f6a510-8fff-5bed-9d0e-df7b2ca28db1', 'Staf Keamanan', 'ccroyserr');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('3eee96fe-b265-5e36-8d78-b2d50a9ac563', 'Staf Konsumsi', 'bwhellamss');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('720073c2-6984-53fa-9546-b893e83e0f62', 'Staf Konsumsi', 'fteresiat');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('b0526112-ddde-5dbf-b887-9b6f93557007', 'Staf Keamanan', 'gtuckeru');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('b85b4ff7-2f5e-5d5d-bcda-728e00ad61de', 'Koordinator Tiket', 'sstirtlev');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('7561fe4e-6ffd-5631-96d6-cf89fdadba83', 'Koordinator Tiket', 'avaulsw');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('ae5a160a-ca64-5557-a0d8-1fdd610d83e1', 'Staf Keamanan', 'apirtx');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('5429db33-2d2c-51e4-9b96-9918a6a67f07', 'Staf Perlengkapan', 'trosiniy');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('214f116d-a5a3-5203-867d-28bcad2b6c1a', 'Staf Acara', 'clubertiz');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('c18d0fc0-d829-5009-a349-094ea30c386b', 'Staf Logistik', 'mhafner10');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('c3205bf1-c929-5b45-af5a-42b59ab87391', 'Staf Logistik', 'gbrisker11');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('6863109a-0444-5f87-b018-66483cb30f22', 'Staf Kebersihan', 'jraddon12');
INSERT INTO Panitia (ID_Panitia, Jabatan, Username) VALUES ('b4ab3922-2b8d-5d9c-b20a-e34bbc64c01f', 'Staf Kebersihan', 'hfoyster13');

--
-- 14. Dumping data for table Pelatih
--

INSERT INTO Pelatih VALUES ('08d2a401-c6d0-56d0-bfca-d8fe47a0ccde', NULL),
	('ba293c61-ad33-57b9-9671-f3319f57d789','AJ Auxerre'),
	('45fae334-63fa-5064-9e45-024ff9e0095c','Borussia Monchengladbach'),
	('fce23375-fdd4-5b30-8e57-a401e5265ba1', NULL),
	('b5a095ae-2fa5-5416-a5c3-4b3e8a7d0f9c', NULL),
	('8060dbbf-e5cc-5ed8-b6a8-9c463ae3f1ef','Hertha Berliner Sport-Club'),
	('36054888-8e10-578a-b964-a1e6efebf8bf', NULL),
	('ae0f5d2b-52f8-5845-8572-d7c586982e02', NULL),
	('651ee801-9621-5f6a-a42a-18c7cc80c352', NULL),
	('5d9b0a1d-62ce-570c-ba61-24557b6f4e68', NULL),
	('0154a6f6-0e6c-52c4-b709-95aaead8423e', NULL),
	('e0a97602-6480-588c-868f-bc044abf9cb5', NULL),
	('f924209a-092e-58bb-b85e-4ceea176a660','Sampdoria'),
	('e1d79fd9-d2be-5d43-9714-87cf2a8567e0','RC Lens'),
	('8a3edd46-2628-5d57-9865-13f273edf326', NULL),
	('6460a618-c69d-5751-9c53-2d03d46ade51', NULL),
	('da992292-ffb1-5ab2-a6de-c19a9b0d0fd7', NULL),
	('dcdd0263-6e8b-5cac-b79f-fe6a389a529a', NULL),
	('02df7727-e4b1-5359-b25a-27eb2ba414b0', NULL),
	('7b2da8c5-bdc2-5d5a-b226-3e6746cf0d89', NULL),
	('397a09f8-fd35-5409-a27c-482947f05217', NULL),
	('c5ab2aae-6554-5bbe-bd14-997f20448114','Club Atletico Boca Juniors'),
	('87c35800-783c-5bed-afab-7a6fab481c46', NULL),
	('ffd38492-0348-5b2d-8f08-3ff2ca0f4645','Clube de Regatas do Flamengo'),
	('61361ec8-6dd5-59da-a79f-3509bad1a524', NULL),
	('8b691658-669a-56db-9e92-a20b2c99ec08', NULL),
	('e5bcfc44-a2bf-5e3e-8de7-7031b3ddff2e', NULL),
	('37a5ea60-8b87-58f5-9155-cfb6711b7e00', NULL),
	('51a38ca6-6e81-549e-9790-41a1f4a96d3e', NULL),
	('9e1fc8f8-d9e7-59ae-99a1-28465dcd0f6e','AS Roma'),
	('e6c0ad59-a52e-5938-887a-8a411e97298a', NULL),
	('ad407b82-5446-5ad6-8061-cf6bcd51b875', NULL),
	('c25ac3f7-f861-51d9-991a-8db2fa1c4cb1', NULL),
	('595487c4-7068-50fa-9768-19972d22e2cd', NULL),
	('ef8bdc6a-9d29-5791-9e94-d6678ba6b4de', NULL),
	('f27890a1-f3b3-5142-a9b7-5297799d60dd', NULL),
	('d9ecf479-5e69-5001-b864-c71de51185a2', NULL),
	('5bdcce0f-16bb-56e0-ae00-36ef8437f653', NULL),
	('734cdcf0-7107-550a-8e99-18ca5b1be1b7', NULL),
	('9a6d4ea7-39e3-582e-bf94-fec1a5f9d685', NULL),
	('591315a4-dbca-5cc7-af08-cbeeac98178b','Cruzeiro Esporte Clube'),
	('1643c509-5bbe-5a87-bfa6-51b5ed07a83a', NULL),
	('312a6ee4-fdec-5229-86e2-e0df521cf306', NULL),
	('f2b6f9a7-531d-5d97-9bf1-4177c33e5070', NULL),
	('7bafb091-c361-5517-82a8-4d3d0809e9f9','Venezia'),
	('f3cf4d43-6a2c-560d-9a2a-5c77331b913b', NULL),
	('5981de99-b8e5-5048-a219-ab103e9cf914', NULL),
	('4baeee02-b9b3-5ecd-9f1b-400dbac56b82', NULL),
	('21d1bd6c-49e3-5d81-a799-5af7da862936', NULL),
	('2b173f18-8c74-5e19-a7d4-3212f74017a8', NULL),
	('0962b5eb-2409-5618-b05f-8569ea0dc35d', NULL),
	('28dbb2ff-741d-5333-b7e5-3f80aa14c1c6', NULL),
	('4df2f065-ecff-52cf-bc07-6ff6b3ee09e3', NULL),
	('9b99a42f-1ce6-52a0-90ea-5e234201500b', NULL),
	('7aae4a9a-e6b4-5a28-a978-e42b2ab8d101', NULL),
	('1a715879-7dba-5a42-b3c5-5a51b46e89e3', NULL),
	('521fd768-7a4b-5e3e-89be-f7dd8886c93a', NULL),
	('5c089632-6f1a-564f-b429-2955bdd874b9', NULL),
	('429ae5d7-3799-5593-80e0-124f3d1d745c', NULL),
	('0e0d1ce5-d1bf-5fa3-ad2e-16ac0f4a09ce', NULL),
	('f4dcc643-023d-5d78-8c15-6440a77bdaa5', NULL),
	('1e87b2cb-937b-566a-9d91-b9346906a089', NULL),
	('a8d68fbf-bd6e-5461-a9d1-cf1bb3522e38', NULL),
	('5ac9e002-7ee9-5996-85a8-81aee6245b2f', NULL);

--
-- 15. Dumping data for table Spesialisasi_Pelatih
--

INSERT INTO Spesialisasi_Pelatih VALUES ('08d2a401-c6d0-56d0-bfca-d8fe47a0ccde','Teknik'),
	('ba293c61-ad33-57b9-9671-f3319f57d789','Taktik'),
	('45fae334-63fa-5064-9e45-024ff9e0095c','Rangkap'),
	('fce23375-fdd4-5b30-8e57-a401e5265ba1','Teknik'),
	('b5a095ae-2fa5-5416-a5c3-4b3e8a7d0f9c','Taktik'),
	('8060dbbf-e5cc-5ed8-b6a8-9c463ae3f1ef','Rangkap'),
	('36054888-8e10-578a-b964-a1e6efebf8bf','Teknik'),
	('ae0f5d2b-52f8-5845-8572-d7c586982e02','Taktik'),
	('651ee801-9621-5f6a-a42a-18c7cc80c352','Rangkap'),
	('5d9b0a1d-62ce-570c-ba61-24557b6f4e68','Teknik'),
	('0154a6f6-0e6c-52c4-b709-95aaead8423e','Taktik'),
	('e0a97602-6480-588c-868f-bc044abf9cb5','Rangkap'),
	('f924209a-092e-58bb-b85e-4ceea176a660','Teknik'),
	('e1d79fd9-d2be-5d43-9714-87cf2a8567e0','Taktik'),
	('8a3edd46-2628-5d57-9865-13f273edf326','Rangkap'),
	('6460a618-c69d-5751-9c53-2d03d46ade51','Teknik'),
	('da992292-ffb1-5ab2-a6de-c19a9b0d0fd7','Taktik'),
	('dcdd0263-6e8b-5cac-b79f-fe6a389a529a','Rangkap'),
	('02df7727-e4b1-5359-b25a-27eb2ba414b0','Teknik'),
	('7b2da8c5-bdc2-5d5a-b226-3e6746cf0d89','Taktik'),
	('397a09f8-fd35-5409-a27c-482947f05217','Rangkap'),
	('c5ab2aae-6554-5bbe-bd14-997f20448114','Teknik'),
	('87c35800-783c-5bed-afab-7a6fab481c46','Taktik'),
	('ffd38492-0348-5b2d-8f08-3ff2ca0f4645','Rangkap'),
	('61361ec8-6dd5-59da-a79f-3509bad1a524','Teknik'),
	('8b691658-669a-56db-9e92-a20b2c99ec08','Taktik'),
	('e5bcfc44-a2bf-5e3e-8de7-7031b3ddff2e','Rangkap'),
	('37a5ea60-8b87-58f5-9155-cfb6711b7e00','Teknik'),
	('51a38ca6-6e81-549e-9790-41a1f4a96d3e','Taktik'),
	('9e1fc8f8-d9e7-59ae-99a1-28465dcd0f6e','Rangkap'),
	('e6c0ad59-a52e-5938-887a-8a411e97298a','Teknik'),
	('ad407b82-5446-5ad6-8061-cf6bcd51b875','Taktik'),
	('c25ac3f7-f861-51d9-991a-8db2fa1c4cb1','Rangkap'),
	('595487c4-7068-50fa-9768-19972d22e2cd','Teknik'),
	('ef8bdc6a-9d29-5791-9e94-d6678ba6b4de','Taktik'),
	('f27890a1-f3b3-5142-a9b7-5297799d60dd','Rangkap'),
	('d9ecf479-5e69-5001-b864-c71de51185a2','Teknik'),
	('5bdcce0f-16bb-56e0-ae00-36ef8437f653','Taktik'),
	('734cdcf0-7107-550a-8e99-18ca5b1be1b7','Rangkap'),
	('9a6d4ea7-39e3-582e-bf94-fec1a5f9d685','Teknik'),
	('591315a4-dbca-5cc7-af08-cbeeac98178b','Taktik'),
	('1643c509-5bbe-5a87-bfa6-51b5ed07a83a','Rangkap'),
	('312a6ee4-fdec-5229-86e2-e0df521cf306','Teknik'),
	('f2b6f9a7-531d-5d97-9bf1-4177c33e5070','Taktik'),
	('7bafb091-c361-5517-82a8-4d3d0809e9f9','Rangkap'),
	('f3cf4d43-6a2c-560d-9a2a-5c77331b913b','Teknik'),
	('5981de99-b8e5-5048-a219-ab103e9cf914','Taktik'),
	('4baeee02-b9b3-5ecd-9f1b-400dbac56b82','Rangkap'),
	('21d1bd6c-49e3-5d81-a799-5af7da862936','Teknik'),
	('2b173f18-8c74-5e19-a7d4-3212f74017a8','Taktik'),
	('0962b5eb-2409-5618-b05f-8569ea0dc35d','Rangkap'),
	('28dbb2ff-741d-5333-b7e5-3f80aa14c1c6','Teknik'),
	('4df2f065-ecff-52cf-bc07-6ff6b3ee09e3','Taktik'),
	('9b99a42f-1ce6-52a0-90ea-5e234201500b','Rangkap'),
	('7aae4a9a-e6b4-5a28-a978-e42b2ab8d101','Teknik'),
	('1a715879-7dba-5a42-b3c5-5a51b46e89e3','Taktik'),
	('521fd768-7a4b-5e3e-89be-f7dd8886c93a','Rangkap'),
	('5c089632-6f1a-564f-b429-2955bdd874b9','Teknik'),
	('429ae5d7-3799-5593-80e0-124f3d1d745c','Taktik'),
	('0e0d1ce5-d1bf-5fa3-ad2e-16ac0f4a09ce','Rangkap'),
	('f4dcc643-023d-5d78-8c15-6440a77bdaa5','Teknik'),
	('1e87b2cb-937b-566a-9d91-b9346906a089','Taktik'),
	('a8d68fbf-bd6e-5461-a9d1-cf1bb3522e38','Rangkap'),
	('5ac9e002-7ee9-5996-85a8-81aee6245b2f','Teknik');

--
-- 17. Dumping data for table Tim_Pertandingan
--

INSERT INTO Tim_Pertandingan VALUES ('AJ Auxerre','431a92e6-608b-46b7-b753-da3e3c21e743',5.0),
	('Cruzeiro Esporte Clube','f2738590-5358-4004-bc09-0fae91fe3c9b',4.0),
	('Club Atletico Boca Juniors','f2738590-5358-4004-bc09-0fae91fe3c9b',6.0),
	('Clube de Regatas do Flamengo','431a92e6-608b-46b7-b753-da3e3c21e743',3.0),
	('Venezia','d7480883-2dbe-4881-9455-972277c66ff8',2.0),
	('Borussia Monchengladbach','c23c1c0e-0ef4-41f2-b04d-b66f258aa06b',3.0),
	('AS Roma','dfec7971-dd28-4ea9-abe1-df1110b9bfaf',6.0),
	('Sampdoria','d7480883-2dbe-4881-9455-972277c66ff8',7.0),
	('Hertha Berliner Sport-Club','c23c1c0e-0ef4-41f2-b04d-b66f258aa06b',4.0),
	('RC Lens','dfec7971-dd28-4ea9-abe1-df1110b9bfaf',3.0);

--
-- 18. Dumping data for table Manajer
--

INSERT INTO Manajer VALUES ('433627d8-25db-5910-bc62-a4a7c9bb46ee', 'jharken0'), 
 ('defc7e4d-5c10-5ae6-a39e-4c769dcddd16', 'alythgoe1'), 
 ('4d208dbd-e748-55a8-b5a6-277519c28ba7', 'zwehnerr2'), 
 ('2bc68972-85bf-5649-b30e-882d49979a4f', 'pivoshin3'), 
 ('dc51ea82-01d5-516a-a436-2e67de02bef8', 'pghest4'), 
 ('339d0599-3c01-51c8-8026-50e69c4c7175', 'marcher5'), 
 ('fb4e21a3-5824-540f-88af-1de0a7a472a6', 'cheindrick6'), 
 ('53859c4a-066f-5b06-89cf-dfa38ad94026', 'mbarrowcliff7'), 
 ('2acbf600-dfa8-519a-bd54-5cbf6eb6f7d1', 'ifansy8'), 
 ('21708e2e-2e2d-5fe1-a12a-f8e0cb4dbb7b', 'bjordine9');

--
-- 19. Dumping data for table Tim_Manajer
--

INSERT INTO Tim_Manajer VALUES ('433627d8-25db-5910-bc62-a4a7c9bb46ee', 'AJ Auxerre'), 
    ('defc7e4d-5c10-5ae6-a39e-4c769dcddd16', 'Cruzeiro Esporte Clube'), 
    ('4d208dbd-e748-55a8-b5a6-277519c28ba7', 'Club Atletico Boca Juniors'), 
    ('2bc68972-85bf-5649-b30e-882d49979a4f', 'Clube de Regatas do Flamengo'), 
    ('dc51ea82-01d5-516a-a436-2e67de02bef8', 'Venezia'), 
    ('339d0599-3c01-51c8-8026-50e69c4c7175', 'Borussia Monchengladbach'), 
    ('fb4e21a3-5824-540f-88af-1de0a7a472a6', 'AS Roma'), 
    ('53859c4a-066f-5b06-89cf-dfa38ad94026', 'Sampdoria'), 
    ('2acbf600-dfa8-519a-bd54-5cbf6eb6f7d1', 'Hertha Berliner Sport-Club'), 
    ('21708e2e-2e2d-5fe1-a12a-f8e0cb4dbb7b', 'RC Lens');

--
-- 20. Dumping data for table Peminjaman
--

INSERT INTO Peminjaman VALUES ('dc51ea82-01d5-516a-a436-2e67de02bef8', '2022-06-25 14:00:00','2022-06-25 16:00:00', '1eb5c363-afda-475c-bd23-8734e6de9079'),
('339d0599-3c01-51c8-8026-50e69c4c7175', '2022-02-09 13:00:00','2022-02-09 15:00:00', 'b82dff14-10be-4120-8ed8-42913d2822e2'),
('fb4e21a3-5824-540f-88af-1de0a7a472a6', '2022-04-25 14:30:00','2022-04-25 16:30:00', 'd286e09f-e818-4ce5-a8ba-b5b04244c985'),
('defc7e4d-5c10-5ae6-a39e-4c769dcddd16', '2022-03-17 13:00:00','2022-03-17 15:00:00', '29e27c11-aeb2-4593-932b-cd5963c7dea9'),
('433627d8-25db-5910-bc62-a4a7c9bb46ee', '2021-12-20 19:00:00','2021-12-20 21:00:00', 'de8cc15e-67ae-42f1-9cff-e75e638e2ea9');

--
-- 21. Dumping data for table Rapat
--

INSERT INTO Rapat VALUES ('d7480883-2dbe-4881-9455-972277c66ff8', '2022-06-28 16:40:00', '05596e20-ebb9-571a-9f7c-250cbacfb499', '53859c4a-066f-5b06-89cf-dfa38ad94026', 'dc51ea82-01d5-516a-a436-2e67de02bef8', 'Pada technical meeting hari ini, kami membahas tentang peraturan yang harus dipatuhi selama pertandingan, seperti aturan pergantian pemain, kartu kuning dan merah, dan tindakan wasit yang dianggap pelanggaran.'),
('c23c1c0e-0ef4-41f2-b04d-b66f258aa06b', '2022-02-13 12:20:00', 'ae5a160a-ca64-5557-a0d8-1fdd610d83e1', '339d0599-3c01-51c8-8026-50e69c4c7175', '2acbf600-dfa8-519a-bd54-5cbf6eb6f7d1', 'Pada technical meeting hari ini, Kami membahas tentang teknis pertandingan, seperti kondisi lapangan, cuaca, dan kebugaran pemain. Kami memutuskan untuk memeriksa kembali lapangan untuk memastikan tidak ada bagian yang licin atau rusak dan mempersiapkan pemain dengan latihan yang sesuai.'),
('dfec7971-dd28-4ea9-abe1-df1110b9bfaf', '2022-04-30 18:30:00', 'c18d0fc0-d829-5009-a349-094ea30c386b', 'fb4e21a3-5824-540f-88af-1de0a7a472a6', '21708e2e-2e2d-5fe1-a12a-f8e0cb4dbb7b', 'Pada technical meeting kali ini, kami membahas tentang cara menjaga kedisiplinan selama pertandingan, terutama dalam hal perilaku pemain dan staf pelatih. Kami memutuskan untuk menekankan pentingnya menjaga etika selama pertandingan.'),
('f2738590-5358-4004-bc09-0fae91fe3c9b', '2022-03-20 10:45:00', '5429db33-2d2c-51e4-9b96-9918a6a67f07', 'defc7e4d-5c10-5ae6-a39e-4c769dcddd16', '4d208dbd-e748-55a8-b5a6-277519c28ba7', 'Pada technical meeting kali ini, kami membahas tentang persiapan teknis sebelum pertandingan, seperti pengecekan kondisi alat dan perlengkapan pertandingan, seperti bola, tiang gawang, dan papan pengumuman. Kami memastikan bahwa semua alat dan perlengkapan pertandingan sudah siap dan dalam kondisi baik sebelum pertandingan dimulai.'),
('431a92e6-608b-46b7-b753-da3e3c21e743', '2021-12-29 20:30:00', '0df2c324-4b3b-5e4b-8574-770c7c601dc4', '433627d8-25db-5910-bc62-a4a7c9bb46ee', '2bc68972-85bf-5649-b30e-882d49979a4f', 'Pada meeting hari ini, Kami membahas tentang penggunaan VAR (Video Assistant Referee) selama pertandingan dan aturan penggunaannya. Kami memastikan bahwa semua staf pelatih dan pemain memahami cara penggunaan VAR dan aturan yang terkait dengannya.');