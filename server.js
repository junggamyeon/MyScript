const express = require('express');
const fs = require('fs');
const path = require('path');
const multer = require('multer');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 9857;
const UPLOAD_DIR = path.join(__dirname, 'uploads');

if (!fs.existsSync(UPLOAD_DIR)) {
  fs.mkdirSync(UPLOAD_DIR, { recursive: true });
}

app.use(cors());
app.use(express.json());
app.use(express.static('public'));
app.use('/files', express.static(UPLOAD_DIR));

const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, UPLOAD_DIR),
  filename: (req, file, cb) => cb(null, file.originalname)
});

const upload = multer({ storage });

app.post('/xinchaothegioi1', (req, res) => {
  if (!req.body.data || !req.body.name) {
    return res.status(400).json({ error: 'Thiếu dữ liệu' });
  }

  const filePath = path.join(UPLOAD_DIR, req.body.name);
  fs.writeFile(filePath, req.body.data, (err) => {
    if (err) {
      console.error('Lỗi lưu file:', err);
      return res.status(500).json({ error: 'Lỗi server' });
    }
    res.json({ 
      url: `https://${req.get('host')}/files/${req.body.name}`,
      message: 'Upload thành công'
    });
  });
});

app.get('/files', (req, res) => {
  fs.readdir(UPLOAD_DIR, (err, files) => {
    res.json(files.map(file => ({
      name: file,
      url: `https://${req.get('host')}/files/${file}`
    })));
  });
});

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Server đang chạy trên port ${PORT}`);
  
});