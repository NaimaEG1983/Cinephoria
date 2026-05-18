-- ============================================================================
-- SCRIPT DE CRÉATION DE LA BASE DE DONNEES 
-- ============================================================================

-- Harmonisé avec le nom choisi dans le fichier docker-compose.yml
DROP DATABASE IF EXISTS cinephoria_dev;
CREATE DATABASE cinephoria_dev
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci; -- Version standard et robuste pour MariaDB
USE cinephoria_dev;

-- ============================================================================
-- 1. SUPPRESSION DES TABLES EXISTANTES (Ordre strict des contraintes)
-- ============================================================================
-- Ignorer temporairement les liens entre les tables pour le nettoyage
SET FOREIGN_KEY_CHECKS = 0;

-- Tables pivots / d'association
DROP TABLE IF EXISTS impacte_SiegeIncident;
DROP TABLE IF EXISTS attribue_GenreFilm;
DROP TABLE IF EXISTS choisit_ReservationSiege;
DROP TABLE IF EXISTS ajoute_UtilisateurFilm;

-- Tables enfants dépendantes
DROP TABLE IF EXISTS RESERVATION;
DROP TABLE IF EXISTS CONTACT;
DROP TABLE IF EXISTS INCIDENT;
DROP TABLE IF EXISTS AVIS;
DROP TABLE IF EXISTS SEANCE;
DROP TABLE IF EXISTS UTILISATEUR;
DROP TABLE IF EXISTS SIEGE;
DROP TABLE IF EXISTS SALLE;
DROP TABLE IF EXISTS CINEMA;

-- Tables parentes indépendantes
DROP TABLE IF EXISTS VILLE;
DROP TABLE IF EXISTS QUALITE;
DROP TABLE IF EXISTS FILM;
DROP TABLE IF EXISTS GENRE;

-- Réactiver la sécurité pour la suite du script
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- 2. CRÉATION DES TABLES
-- ============================================================================

CREATE TABLE GENRE(
   genre_id INT AUTO_INCREMENT,
   intitule_genre VARCHAR(50) NOT NULL,
   CONSTRAINT pk_genre PRIMARY KEY(genre_id)
) ENGINE=InnoDB;

CREATE TABLE FILM(
   film_id INT AUTO_INCREMENT,
   titre VARCHAR(150) NOT NULL,
   description TEXT,
   duree SMALLINT UNSIGNED,
   date_sortie DATE,
   affiche_image VARCHAR(255),
   age_min TINYINT UNSIGNED DEFAULT 0,
   label_coeur BOOLEAN DEFAULT FALSE,
   moyenne_note DECIMAL(3,2) DEFAULT 0.00,
   CONSTRAINT pk_film PRIMARY KEY(film_id)
) ENGINE=InnoDB;

CREATE TABLE QUALITE(
   id_qualite INT AUTO_INCREMENT,
   intitule_qualite VARCHAR(50) NOT NULL,
   prix DECIMAL(5,2) NOT NULL,
   CONSTRAINT pk_qualite PRIMARY KEY(id_qualite)
) ENGINE=InnoDB;

CREATE TABLE VILLE(
   id_Ville INT AUTO_INCREMENT,
   nom_Ville VARCHAR(100) NOT NULL,
   code_postal VARCHAR(10) NOT NULL,
   CONSTRAINT pk_ville PRIMARY KEY(id_Ville)
) ENGINE=InnoDB;

CREATE TABLE CINEMA(
   cinema_id INT AUTO_INCREMENT,
   nom_cinema VARCHAR(100) NOT NULL,
   adresse_cinema VARCHAR(255),
   mail VARCHAR(180) NOT NULL UNIQUE,
   telephone VARCHAR(20),
   heure_ouverture VARCHAR(50),
   heure_fermeture VARCHAR(50),
   id_Ville INT NOT NULL, -- Adapté en INT pour correspondre à la clé de VILLE
   CONSTRAINT pk_cinema PRIMARY KEY(cinema_id),
   CONSTRAINT fk_cinema_ville FOREIGN KEY(id_Ville) REFERENCES VILLE(id_Ville) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE SALLE(
   id_salle INT AUTO_INCREMENT,
   numero_salle TINYINT UNSIGNED NOT NULL,
   capacite SMALLINT UNSIGNED NOT NULL,
   carto_salle VARCHAR(400),
   cinema_id INT NOT NULL, -- Adapté en INT
   CONSTRAINT pk_salle PRIMARY KEY(id_salle),
   CONSTRAINT fk_salle_cinema FOREIGN KEY(cinema_id) REFERENCES CINEMA(cinema_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE SIEGE(
   siege_id INT AUTO_INCREMENT,
   num_siege SMALLINT UNSIGNED NOT NULL,
   handicap BOOLEAN DEFAULT FALSE,
   disponible BOOLEAN DEFAULT TRUE,
   id_salle INT NOT NULL, -- Déjà en INT
   CONSTRAINT pk_siege PRIMARY KEY(siege_id),
   CONSTRAINT fk_siege_salle FOREIGN KEY(id_salle) REFERENCES SALLE(id_salle) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE UTILISATEUR(
   id_util INT AUTO_INCREMENT,
   email VARCHAR(180) NOT NULL UNIQUE,
   nom VARCHAR(50) NOT NULL,
   prenom VARCHAR(50),
   pseudo VARCHAR(50) UNIQUE,
   mdp VARCHAR(255) NOT NULL,
   role CHAR(1) DEFAULT 'V' NOT NULL, 
   mail_confirme BOOLEAN DEFAULT FALSE,
   mdp_a_changer BOOLEAN DEFAULT FALSE,
   id_util_1 INT NULL, -- IMPÉRATIF : NULL pour le premier utilisateur créé
   cinema_id INT NULL, -- NULL car un client ou le SuperAdmin n'appartient pas à un cinéma précis
   PRIMARY KEY(id_util),
   FOREIGN KEY(id_util_1) REFERENCES UTILISATEUR(id_util) ON DELETE SET NULL ON UPDATE CASCADE,
   FOREIGN KEY(cinema_id) REFERENCES CINEMA(cinema_id) ON DELETE SET NULL ON UPDATE CASCADE,
   CONSTRAINT chk_utilisateur_role CHECK (role IN ('V', 'E', 'A', 'U'))
   ) ENGINE=InnoDB;


CREATE TABLE AVIS(
   id_avis INT AUTO_INCREMENT,
   description TEXT,
   note TINYINT UNSIGNED NOT NULL,
   validation CHAR(1) DEFAULT 'A' NOT NULL,
   date_avis DATETIME NOT NULL DEFAULT NOW(),
   date_validation DATETIME,
   film_id INT NOT NULL, -- Adapté en INT
   id_util INT NOT NULL,
   id_moderateur INT,
   CONSTRAINT pk_avis PRIMARY KEY(id_avis),
   CONSTRAINT fk_avis_film FOREIGN KEY(film_id) REFERENCES FILM(film_id) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT fk_avis_utilisateur FOREIGN KEY(id_util) REFERENCES Utilisateur(id_util) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT fk_avis_moderateur FOREIGN KEY(id_moderateur) REFERENCES Utilisateur(id_util) ON DELETE SET NULL ON UPDATE CASCADE,
   CONSTRAINT chk_avis_note CHECK (note BETWEEN 0 AND 5),
   CONSTRAINT chk_avis_validation CHECK (validation IN ('A', 'V', 'R'))
) ENGINE=InnoDB;

CREATE TABLE INCIDENT(
   id_incident INT AUTO_INCREMENT,
   type_installation VARCHAR(50),
   etat CHAR(1) DEFAULT 'C' NOT NULL,
   incident_description TEXT,
   id_salle INT NOT NULL,
   id_util INT NOT NULL,
   CONSTRAINT pk_incident PRIMARY KEY(id_incident),
   CONSTRAINT fk_incident_salle FOREIGN KEY(id_salle) REFERENCES SALLE(id_salle) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT fk_incident_utilisateur FOREIGN KEY(id_util) REFERENCES Utilisateur(id_util) ON DELETE RESTRICT ON UPDATE CASCADE,
   CONSTRAINT chk_incident_etat CHECK (etat IN ('C', 'R'))
) ENGINE=InnoDB;

CREATE TABLE SEANCE(
   id_seance INT AUTO_INCREMENT,
   date_seance DATE NOT NULL,
   h_deb TIME NOT NULL,
   h_fin TIME NOT NULL,
   nb_sieges_dispo SMALLINT UNSIGNED NOT NULL,
   id_salle INT NOT NULL,
   film_id INT NOT NULL, -- Adapté en INT
   id_qualite INT NOT NULL, -- Adapté en INT
   CONSTRAINT pk_seance PRIMARY KEY(id_seance),
   CONSTRAINT fk_seance_salle FOREIGN KEY(id_salle) REFERENCES SALLE(id_salle) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT fk_seance_film FOREIGN KEY(film_id) REFERENCES FILM(film_id) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT fk_seance_qualite FOREIGN KEY(id_qualite) REFERENCES QUALITE(id_qualite) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE CONTACT(
   id_contact INT AUTO_INCREMENT,
   nom_utilisateur VARCHAR(50),
   id_utilisateur INT,
   email_utilisateur VARCHAR(180),
   description TEXT NOT NULL,
   titre_demande VARCHAR(100),
   date_envoi DATETIME DEFAULT NOW(),
   id_util INT,
   CONSTRAINT pk_contact PRIMARY KEY(id_contact),
   CONSTRAINT fk_contact_utilisateur FOREIGN KEY(id_util) REFERENCES Utilisateur(id_util) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE RESERVATION(
   reservation_id INT AUTO_INCREMENT,
   date_reservation DATETIME NOT NULL DEFAULT NOW(),
   statut CHAR(1) DEFAULT 'A' NOT NULL, -- 'V' (Validée), 'A' (Annulée), 'E' (En attente)
   prix_total DECIMAL(6,2) NOT NULL,
   qr_code TEXT,
   id_seance INT NOT NULL, -- Adapté en INT
   id_util INT NOT NULL,
   CONSTRAINT pk_reservation PRIMARY KEY(reservation_id),
   CONSTRAINT fk_reservation_seance FOREIGN KEY(id_seance) REFERENCES SEANCE(id_seance) ON DELETE RESTRICT ON UPDATE CASCADE,
   CONSTRAINT fk_reservation_utilisateur FOREIGN KEY(id_util) REFERENCES Utilisateur(id_util) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT chk_reservation_statut CHECK (statut IN ('E', 'V', 'A'))
) ENGINE=InnoDB;

-- ============================================================================
-- 3. TABLES PIVOTS
-- ============================================================================

CREATE TABLE ajoute_UtilisateurFilm(
   id_util INT,
   film_id INT, -- Adapté en INT
   date_mercredi DATE NOT NULL,
   CONSTRAINT pk_ajoute_utilisateur_film PRIMARY KEY(id_util, film_id),
   CONSTRAINT fk_ajoute_util FOREIGN KEY(id_util) REFERENCES UTILISATEUR(id_util) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT fk_ajoute_film FOREIGN KEY(film_id) REFERENCES FILM(film_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE choisit_ReservationSiege(
   reservation_id INT, -- Adapté en INT
   siege_id INT, -- Adapté en INT
   CONSTRAINT pk_choisit_reservation_siege PRIMARY KEY(reservation_id, siege_id),
   CONSTRAINT fk_choisit_res FOREIGN KEY (reservation_id) REFERENCES RESERVATION(reservation_id) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT fk_choisit_siege FOREIGN KEY (siege_id) REFERENCES SIEGE(siege_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE attribue_GenreFilm(
   genre_id INT, -- Adapté en INT
   film_id INT, -- Adapté en INT
   CONSTRAINT pk_attribue_genre_film PRIMARY KEY(genre_id, film_id),
   CONSTRAINT fk_attribue_genre FOREIGN KEY(genre_id) REFERENCES GENRE(genre_id) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT fk_attribue_film FOREIGN KEY(film_id) REFERENCES FILM(film_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE impacte_SiegeIncident(
   id_incident INT, -- Adapté en INT
   siege_id INT, -- Adapté en INT
   CONSTRAINT pk_impacte_siege_incident PRIMARY KEY(id_incident, siege_id),
   CONSTRAINT fk_impacte_incident FOREIGN KEY(id_incident) REFERENCES INCIDENT(id_incident) ON DELETE CASCADE ON UPDATE CASCADE,
   CONSTRAINT fk_impacte_siege FOREIGN KEY(siege_id) REFERENCES SIEGE(siege_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;