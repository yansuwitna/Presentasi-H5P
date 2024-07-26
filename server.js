const express = require('express');
const multer = require('multer');
const AdmZip = require('adm-zip');
const path = require('path');
const fs = require('fs');

const app = express();
const port = 3000;

// Setup multer untuk unggah file
const upload = multer({ dest: 'uploads/' });

app.use(express.static('public'));

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.get('/guru', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'upload.html'));
});

app.post('/upload', upload.single('file'), (req, res) => {
    const filePath = req.file.path;
    const outputDir = 'public/isi';

    // Pastikan direktori output ada
    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
    }

    try {
        const zip = new AdmZip(filePath);
        zip.extractAllTo(outputDir, true);
        res.redirect('/');
    } catch (err) {
        res.status(500).send(`Terjadi kesalahan: ${err.message}`);
    } finally {
        fs.unlinkSync(filePath); // Hapus file unggahan setelah diekstrak
    }
});

app.listen(port, () => {
    console.log(`Server berjalan di http://localhost:${port}`);
});
