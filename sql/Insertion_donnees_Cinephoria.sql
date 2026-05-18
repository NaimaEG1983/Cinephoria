-- ============================================================================
-- INSERTION COMPLETE DE DONNÉES DE TEST
-- Respect des clés étrangères et optimisation de la lisibilité
-- ============================================================================

USE cinephoria_dev;

-- ============================================================================
-- VILLES (7 villes officielles de l'énoncé)
-- ============================================================================
INSERT INTO VILLE (nom_Ville, code_postal) VALUES
('Nantes', '44000'), ('Bordeaux', '33000'), ('Paris', '75000'), ('Toulouse', '31000'), ('Lille', '59000'), ('Charleroi', '6000'), ('Liège', '4000');

-- ============================================================================
-- CINEMAS (Un cinéma unique dans chaque ville officielle de l'énoncé)
-- ============================================================================
INSERT INTO CINEMA (nom_cinema, adresse_cinema, mail, telephone, heure_ouverture, heure_fermeture, id_Ville) VALUES
('Cinephoria Nantes', '12 Rue Olivier de Clisson', 'nantes@cinephoria.fr', '0240000001', '10:00', '23:30', 1),
('Cinephoria Bordeaux', '45 Rue Sainte-Catherine', 'bordeaux@cinephoria.fr', '0550000002', '10:00', '23:30', 2),
('Cinephoria Paris', '12 Rue du Cinema', 'paris@cinephoria.fr', '0102030405', '09:00', '23:30', 3),
('Cinephoria Toulouse', '3 Place du Capitole', 'toulouse@cinephoria.fr', '0560000004', '10:00', '23:30', 4),
('Cinephoria Lille', '18 Rue Faidherbe', 'lille@cinephoria.fr', '0320000005', '10:00', '23:30', 5),
('Cinephoria Charleroi', '55 Boulevard Tirou', 'charleroi@cinephoria.be', '+3271000006', '13:00', '22:30', 6),
('Cinephoria Liège', '8 Place Saint-Lambert', 'liege@cinephoria.be', '+3242000007', '13:00', '23:00', 7);
-- ============================================================================
-- SALLES
-- ============================================================================
INSERT INTO SALLE (numero_salle, capacite, carto_salle, cinema_id) VALUES
(1, 120, 'salle1_plan.png', 1), (2, 90, 'salle2_plan.png', 1),
(1, 150, 'salle1_lyon.png', 2), (1, 100, 'salle1_bruxelles.png', 3);

-- ============================================================================
-- SIEGES
-- ============================================================================
INSERT INTO SIEGE (num_siege, handicap, disponible, id_salle) VALUES
(1, TRUE, TRUE, 1), (2, FALSE, TRUE, 1), (3, FALSE, TRUE, 1),
(1, TRUE, TRUE, 2), (2, FALSE, TRUE, 2),
(1, FALSE, TRUE, 3), (2, FALSE, TRUE, 3),
(1, TRUE, TRUE, 4), (2, FALSE, TRUE, 4);

-- ============================================================================
-- QUALITÉS
-- ============================================================================
INSERT INTO QUALITE (intitule_qualite, prix) VALUES
('Standard', 9.90), ('IMAX', 15.50), ('4DX', 18.00), ('VIP', 22.00);

-- ============================================================================
-- GENRES
-- ============================================================================
INSERT INTO GENRE (intitule_genre) VALUES
('Animation'), ('Comédie'), ('Science-Fiction'), ('Drame'), ('Action');

-- ============================================================================
-- FILMS
-- ============================================================================
INSERT INTO FILM (titre, description, duree, date_sortie, affiche_image, age_min, label_coeur, moyenne_note) VALUES
('Inception', 'Un voleur infiltre les rêves.', 148, '2010-07-16', 'inception.jpg', 12, TRUE, 4.8),
('Interstellar', 'Voyage spatial pour sauver l’humanité.', 169, '2014-11-07', 'interstellar.jpg', 10, TRUE, 4.9),
('Le Roi Lion', 'Simba devient roi.', 88, '1994-06-24', 'leroilion.jpg', 0, TRUE, 4.7),
('Toy Story', 'Les jouets prennent vie.', 81, '1995-11-22', 'toystory.jpg', 0, TRUE, 4.6),
('Intouchables', 'Amitié entre deux hommes opposés.', 112, '2011-11-02', 'intouchables.jpg', 7, TRUE, 4.9),
('The Dark Knight', 'Batman contre le Joker.', 152, '2008-07-18', 'darkknight.jpg', 12, TRUE, 4.9),
('Avengers Endgame', 'Combat final contre Thanos.', 181, '2019-04-24', 'endgame.jpg', 12, TRUE, 4.7),
('Forrest Gump', 'Une vie extraordinaire.', 142, '1994-07-06', 'forrestgump.jpg', 10, TRUE, 4.8),
('Jurassic Park', 'Des dinosaures s’échappent.', 127, '1993-06-11', 'jurassicpark.jpg', 10, TRUE, 4.5),
('Very Bad Trip', 'Une soirée incontrôlable.', 100, '2009-06-05', 'verybadtrip.jpg', 16, FALSE, 4.1);

-- ============================================================================
-- FILMS / GENRES
-- ============================================================================
INSERT INTO attribue_GenreFilm (genre_id, film_id) VALUES
(3,1),(5,1),(3,2),(4,2),(1,3),(4,3),(1,4),(2,4),(2,5),(4,5),(5,6),(4,6),(5,7),(3,7),(4,8),(2,8),(3,9),(5,9),(2,10);

-- ============================================================================
-- UTILISATEURS
-- ============================================================================
INSERT INTO UTILISATEUR (email, nom, prenom, pseudo, mdp, role, mail_confirme, mdp_a_changer, id_util_1, cinema_id) VALUES
('superadmin@cinephoria.fr', 'Root', 'System', 'superadmin', 'hashedpassword', 'U', TRUE, FALSE, NULL, NULL),
('admin.paris@cinephoria.fr', 'Martin', 'Lucas', 'adminparis', 'hashedpassword', 'A', TRUE, FALSE, 1, 1),
('employe.lyon@cinephoria.fr', 'Dupont', 'Sarah', 'sarahlyon', 'hashedpassword', 'E', TRUE, FALSE, 2, 2),
('client1@mail.com', 'Bernard', 'Julie', 'julie75', 'hashedpassword', 'V', TRUE, FALSE, 2, NULL),
('client2@mail.com', 'Petit', 'Thomas', 'thomasx', 'hashedpassword', 'V', TRUE, FALSE, 2, NULL);

-- ============================================================================
-- AVIS
-- ============================================================================
INSERT INTO AVIS (description, note, validation, date_avis, date_validation, film_id, id_util, id_moderateur) VALUES
('Excellent film', 5, 'V', NOW(), NOW(), 1, 4, 2),
('Tres émouvant', 5, 'V', NOW(), NOW(), 3, 5, 2),
('Très drôle', 4, 'V', NOW(), NOW(), 10, 4, 2);

-- ============================================================================
-- SEANCES
-- ============================================================================
INSERT INTO SEANCE (date_seance, h_deb, h_fin, nb_sieges_dispo, id_salle, film_id, id_qualite) VALUES
('2026-05-20', '14:00:00', '16:30:00', 120, 1, 1, 1),
('2026-05-20', '18:00:00', '21:00:00', 90, 2, 2, 2),
('2026-05-21', '20:00:00', '22:00:00', 150, 3, 6, 3),
('2026-05-21', '16:00:00', '18:00:00', 100, 4, 3, 1);

-- ============================================================================
-- RESERVATIONS (Adapté aux statuts raccourcis : 'V' pour Validée, 'E' pour En attente)
-- ============================================================================
INSERT INTO RESERVATION (date_reservation, statut, prix_total, qr_code, id_seance, id_util) VALUES
(NOW(), 'V', 19.80, 'QR001', 1, 4), (NOW(), 'E', 15.50, 'QR002', 2, 5);

-- ============================================================================
-- RESERVATION / SIEGES
-- ============================================================================
INSERT INTO choisit_ReservationSiege (reservation_id, siege_id) VALUES
(1,1), (1,2), (2,4);

-- ============================================================================
-- INCIDENTS
-- ============================================================================
INSERT INTO INCIDENT (type_installation, etat, incident_description, id_salle, id_util) VALUES
('Projecteur', 'C', 'Le projecteur clignote.', 1, 3),
('Siège', 'R', 'Siège cassé rangée B.', 2, 3);

-- ============================================================================
-- INCIDENT / SIEGES
-- ============================================================================
INSERT INTO impacte_SiegeIncident (id_incident, siege_id) VALUES
(2,4);

-- ============================================================================
-- CONTACTS
-- ============================================================================
INSERT INTO CONTACT (nom_utilisateur, id_utilisateur, email_utilisateur, description, titre_demande, date_envoi, id_util) VALUES
('Julie Bernard', 4, 'client1@mail.com', 'Je souhaite un remboursement.', 'Remboursement', NOW(), 4),
('Thomas Petit', 5, 'client2@mail.com', 'Le son était trop fort.', 'Plainte séance', NOW(), 5);

-- ============================================================================
-- AJOUTE UTILISATEUR FILM
-- ============================================================================
INSERT INTO ajoute_UtilisateurFilm (id_util, film_id, date_mercredi) VALUES
(4,1,'2026-05-14'), (4,3,'2026-05-14'), (5,6,'2026-05-14');