create database MuseumDB
go
use MuseumDB
go

-- tabela cu muzeu 
CREATE TABLE Museums
(MuseumID INT PRIMARY KEY IDENTITY,
  Name varchar(100) NOT NULL,
  Location varchar(100) NOT NULL,
  FoundationDate date NOT NULL,
)

-- Managers table (one to one relationship cu museums)
CREATE TABLE Managers
(ManagerID INT PRIMARY KEY IDENTITY,
  Name varchar(50) NOT NULL,
  Experience INT NOT NULL,
  MuseumID INT UNIQUE FOREIGN KEY REFERENCES Museums(MuseumID) NOT NULL
);

-- Artists table one to many cu artworks
CREATE TABLE Artists
(ArtistID INT PRIMARY KEY IDENTITY,
  Name varchar(50) NOT NULL,
  Nationality varchar(50) NOT NULL,
  BirthDate date NOT NULL,
  DeathDate date
)

-- Artworks table many to many cu exhibitions
CREATE TABLE Artworks
(ArtworkID INT PRIMARY KEY IDENTITY,
  Title varchar(100) NOT NULL,
  CreationDate date NOT NULL,
  Medium varchar(50),
  ArtistID INT FOREIGN KEY REFERENCES Artists(ArtistID) NOT NULL
)

-- Exhibitions table many to many cu artworks
CREATE TABLE Exhibitions
(ExhibitionID INT PRIMARY KEY IDENTITY,
  Title varchar(100) NOT NULL,
  StartDate date NOT NULL,
  EndDate date NOT NULL,
  Type varchar(50) DEFAULT 'General',
  MuseumID INT FOREIGN KEY REFERENCES Museums(MuseumID) NOT NULL
)

-- ExhibitionArtworks table relatia de many to many de la artworks si exhibition
CREATE TABLE ExhibitionArtworks
(ExhibitionID INT FOREIGN KEY REFERENCES Exhibitions(ExhibitionID) NOT NULL,
  ArtworkID INT FOREIGN KEY REFERENCES Artworks(ArtworkID) NOT NULL,
  CONSTRAINT pk_ExhibitionArtworks PRIMARY KEY (ExhibitionID, ArtworkID)
)

-- Visitors table
CREATE TABLE Visitors
(VisitorID INT PRIMARY KEY IDENTITY,
  Name varchar(50) NOT NULL,
  Age int NOT NULL,
  MembershipStatus varchar(20) DEFAULT 'Regular',
  MuseumID INT FOREIGN KEY REFERENCES Museums(MuseumID) NOT NULL
)


-- Tickets table one to one cu visitors
CREATE TABLE Tickets
(VisitorID INT FOREIGN KEY REFERENCES Visitors(VisitorID) NOT NULL,
  TicketPrice int NOT NULL,
  CONSTRAINT pk_Tickets PRIMARY KEY (VisitorID)
);

