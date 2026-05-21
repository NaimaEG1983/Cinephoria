console.log("=== LE SCRIPT SERVER.JS VIENT DE SE LANCER ! ===");

const express = require('express'); // Import Express
const app = express();              // Création application Express 
const cors = require('cors');       // Import CORS pour autoriser Angular
const mysql = require('mysql2');    // Import MySQL/MARIADB
const path = require('path'); 
// Autoriser votre frontend Angular (localhost:4200) à appeler l'API
app.use(cors());
app.use(express.json());
//rendre le dossier des affiches accessible via Url API
console.log("Dossier cible recherché par Node :", path.join(__dirname, '../public/images/affiches'));
app.use('/images/affiches', express.static(path.join(__dirname, '../public/images/affiches')));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Serveur Node démarré sur http://localhost:${PORT}`);
});

// connexion à la base de données
const db = mysql.createConnection({
  host: process.env.DB_HOST || '127.0.0.1',
  user: process.env.DB_USER || 'root',          
  password: process.env.DB_PASSWORD || 'super_secret',  
  database: process.env.DB_NAME || 'cinephoria_dev',
  port: process.env.DB_PORT || 3307
});

// 
db.connect((err) => {
  if (err) {
    console.error('❌ Erreur de connexion à la base de données :', err);
    return;
  }
  console.log('✅ Connexion à la base de données MariaDB réussie !');
});

// route pour tous les films
app.get('/api/films', (req, res) => {
  //console.log('API : Lecture de TOUS les films');
  
  // requête pour tous les films
  const query = `
    SELECT f.film_id, f.titre, f.duree, f.affiche_image, 
           GROUP_CONCAT(distinct g.intitule_genre SEPARATOR ', ') AS genre
    FROM FILM f 
    LEFT JOIN attribue_GenreFilm agf ON f.film_id = agf.film_id
    LEFT JOIN GENRE g ON agf.genre_id = g.genre_id
    GROUP BY f.film_id;
  `;

  db.query(query, (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Erreur catalogue' });
    }
    res.json(results);
  });
});

// route pour les derniers films
app.get('/api/films/nouveautes', (req, res) => {
 // console.log('API : Lecture des nouveautés du mercredi');

  const query = `
    SELECT f.film_id, f.titre, f.duree, f.affiche_image, a.date_mercredi,
           GROUP_CONCAT(distinct g.intitule_genre SEPARATOR ', ') AS genre
    FROM FILM f 
    INNER JOIN ajoute_UtilisateurFilm a ON a.film_id = f.film_id
    LEFT JOIN attribue_GenreFilm agf ON f.film_id = agf.film_id
    LEFT JOIN GENRE g ON agf.genre_id = g.genre_id
    WHERE DATEDIFF(NOW(), a.date_mercredi) >= 0 AND DATEDIFF(NOW(), a.date_mercredi) < 8
    GROUP BY f.film_id
    ORDER BY a.date_mercredi DESC;
  `;

  db.query(query, (err, results) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ error: 'Erreur nouveautés' });
    }
    res.json(results);
  });
});