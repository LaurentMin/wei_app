const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');
const multer = require('multer');
const fs = require('fs'); // Pour gérer les fichiers localement si nécessaire

const app = express();
const port = 3000;
const upload = multer({dest: 'uploads/' }); // Dossier temporaire pour stocker les fichiers

const path = require('path');

// Middleware pour parser les requêtes JSON
app.use(bodyParser.json());

// Configuration de la connexion MySQL
const db = mysql.createConnection({
  host: 'localhost',
  user: 'utseus', // Remplace par ton utilisateur MySQL
  password: 'utseus', // Ajoute ton mot de passe si nécessaire
  database: 'testdb', // Nom de la base de données
});

// Connecter à la base de données
db.connect((err) => {
  if (err) {
    console.error('Erreur de connexion à la base de données:', err);
    return;
  }
  console.log('Connecté à la base de données MySQL.');
});

// Routes CRUD

// 0. Eviter l'erreur
app.get('', (req, res) => {
  const query = 'SELECT * FROM items';
  db.query(query, (err, results) => {
    if (err) {
      console.error(err);
      res.status(500).send('Erreur lors de la récupération des items');
    } else {
      res.json(results);
    }
  });
});

// 1. Obtenir tous les items
app.get('/items', (req, res) => {
  const query = 'SELECT * FROM items';
  db.query(query, (err, results) => {
    if (err) {
      console.error(err);
      res.status(500).send('Erreur lors de la récupération des items');
    } else {
      res.json(results);
    }
  });
});
  
// 2. Ajouter un nouvel item
app.post('/items', (req, res) => {
  const { name } = req.body;
  const query = 'INSERT INTO items (id, name) VALUES (NULL, ?)';
  db.query(query, [name], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500).send('Erreur lors de l\'ajout de l\'item');
    } else {
      res.status(201).send({ id: result.insertId, name });
    }
  });
});
  
// 3. Mettre à jour un item
app.put('/items/:id', (req, res) => {
  const { id } = req.params;
  const { name } = req.body;
  const query = 'UPDATE items SET name = ? WHERE id = ?';
  db.query(query, [name, id], (err) => {
    if (err) {
      console.error(err);
      res.status(500).send('Erreur lors de la mise à jour de l\'item');
    } else {
      res.send('Item mis à jour avec succès');
    }
  });
});
  
// 4. Supprimer un item
app.delete('/items/:id', (req, res) => {
  const { id } = req.params;
  const query = 'DELETE FROM items WHERE id = ?';
  db.query(query, [id], (err, result) => {if (err) {
      console.error(err);
      res.status(500).send('Erreur lors de la suppression de l\'item');
    } else {
      res.send('Item supprimé avec succès');
    }
  });
});

// 5. Retrouver un item par reference
app.get('/items/:refToFind', (req, res) => {
  const { refToFind } = req.params;
  const query = 'SELECT * FROM items WHERE ref = ?';
  db.query(query, [refToFind], (err, result) => {
    if (err) {
    console.error(err);
    res.status(500).send('Erreur lors de la recherche de l\'élément');
    } else {
    res.json(result);
    }
  });
});

// 6. Retrouver une location
app.post('/locations/get', (req, res) => {
  const { allee } = req.body;
  const { rangee } = req.body;
  const { etage } = req.body;
  const query = 'SELECT id FROM locations WHERE allee = ? AND rangee = ? AND etage = ?';
  db.query(query, [allee, rangee, etage], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500).send('Erreur lors de la recherche de location');
    } else {
      res.json(result);
    }
  });
});
  
// 6. Ajout de location
app.post('/locations', (req, res) => {
  const { allee } = req.body;
  const { rangee } = req.body;
  const { etage } = req.body;
  const query = 'INSERT INTO locations (id, allee, rangee, etage) VALUES (NULL, ?, ?, ?)';
  db.query(query, [allee, rangee, etage], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500).send('Erreur lors de l\'ajout de l\'item');
    } else {
      res.status(201).send({ id: result.insertId });
    }
  });
});
  
// 7. Lier item et location
app.post('/item-location', (req, res) => {
  const { iditem } = req.body;
  const { idlocation } = req.body;
  const query = 'INSERT INTO locations (id, iditem, idlocation) VALUES (NULL, ?, ?)';
  db.query(query, [iditem, idproduit], (err, result) => {
    if (err) {
      console.error(err);
      res.status(500).send('Erreur lors de l\'ajout de l\'item');
    } else {
      res.status(201).send({ id: result.insertId });
    }
  });
});
  
// 8. Inserer un chemin d'image
app.post('/upload-image', upload.single('image'), (req, res) => {
    const { idProduit } = req.body;
    const filePath = req.file.path;

    // Déplacer l'image vers un dossier permanent
    const targetPath = `images/${req.file.originalname}`;
    fs.renameSync(filePath, targetPath);

    const sql = 'UPDATE items SET image = ? WHERE id = ?';
    db.query(sql, [filePath, idProduit], (err, result) => {
        if (err) {
            console.error(err);
            res.status(500).send('Erreur lors de l\'insertion du chemin de l\'image');
            return;
        }

        res.status(200).send({ message: 'Chemin de l\'image inséré avec succès', id: result.insertId });
    });
});
  
  
// Dossier contenant les images
const imageDirectory = path.join(__dirname, 'images');

// 9. Recuperer une image par chemin
app.get('/image/:imageName', (req, res) => {
  const imageName = req.params.imageName;
  const imagePath = path.join(imageDirectory, imageName);

  res.sendFile(imagePath, (err) => {
    if (err) {
      console.error(`Image ${imageName} introuvable : ${err.message}`);
      res.status(404).send({ error: 'Image introuvable' });
    }
  });
});
  
  
// Lancer le serveur
app.listen(port, () => {
  console.log(`API disponible sur https://api.skeuly.com (${port})`);
});