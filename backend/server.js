require('dotenv').config();
const express = require('express');
const cors = require('cors');
const oracledb = require('oracledb');
const bcrypt = require('bcrypt');

const app = express();
app.use(cors());
app.use(express.json());

let pool;

// ✅ Initialize Oracle DB Connection
async function init() {
  try {
    pool = await oracledb.createPool({
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      connectString: process.env.DB_CONNECT_STRING,
    });
    console.log('✅ Oracle DB connection pool created');
  } catch (err) {
    console.error('❌ Oracle DB connection failed:', err);
    process.exit(1);
  }
}

// ✅ Route: Root
app.get('/', (req, res) => {
  res.send('SkillMap API is running 🚀');
});

app.post('/test', (req, res) => {
  res.json({ message: 'Test route working', body: req.body });
});

// ✅ Route: Admin Login
app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  try {
    const connection = await pool.getConnection();
    const result = await connection.execute(
      `SELECT password_hash FROM admin WHERE username = :username`,
      [username]
    );
    await connection.close();

    if (result.rows.length === 0) {
      return res.status(401).json({ success: false, message: 'Invalid username' });
    }

    const hashedPassword = result.rows[0][0];
    const isMatch = await bcrypt.compare(password, hashedPassword);

    if (isMatch) {
      res.json({ success: true, message: 'Login successful' });
    } else {
      res.status(401).json({ success: false, message: 'Invalid password' });
    }
  } catch (err) {
    console.error('❌ Login error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// ✅ Route: Get Workers (with optional filters)
app.get('/workers', async (req, res) => {
  const { skill, village } = req.query;
  try {
    const connection = await pool.getConnection();

    let query = `SELECT id, name, skill, village, phone, languages FROM workers WHERE 1=1`;
    const params = [];

    if (skill) {
      query += ` AND LOWER(skill) = LOWER(:skill)`;
      params.push(skill);
    }
    if (village) {
      query += ` AND LOWER(village) = LOWER(:village)`;
      params.push(village);
    }

    const result = await connection.execute(query, params);
    await connection.close();

    res.json(result.rows.map(row => ({
      id: row[0],
      name: row[1],
      skill: row[2],
      village: row[3],
      phone: row[4],
      languages: row[5],
    })));
  } catch (err) {
    console.error('❌ Fetch workers error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// ✅ Route: Add Worker (admin only for now)
app.post('/workers', async (req, res) => {
  const { name, skill, village, phone, languages } = req.body;
  try {
    const connection = await pool.getConnection();
    await connection.execute(
      `INSERT INTO workers (name, skill, village, phone, languages) 
       VALUES (:name, :skill, :village, :phone, :languages)`,
      [name, skill, village, phone, languages || null],
      { autoCommit: true }
    );
    await connection.close();

    res.json({ success: true, message: 'Worker added successfully' });
  } catch (err) {
    console.error('❌ Add worker error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// ✅ Update Worker
app.put('/workers/:id', async (req, res) => {
  const { id } = req.params;
  const { name, skill, village, phone, languages } = req.body;
  try {
    const connection = await pool.getConnection();
    await connection.execute(
      `UPDATE workers 
       SET name = :name, skill = :skill, village = :village, phone = :phone, languages = :languages
       WHERE id = :id`,
      [name, skill, village, phone, languages, id],
      { autoCommit: true }
    );
    await connection.close();
    res.json({ success: true, message: 'Worker updated successfully' });
  } catch (err) {
    console.error('❌ Update worker error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

// ✅ Delete Worker
app.delete('/workers/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const connection = await pool.getConnection();
    await connection.execute(
      `DELETE FROM workers WHERE id = :id`,
      [id],
      { autoCommit: true }
    );
    await connection.close();
    res.json({ success: true, message: 'Worker deleted successfully' });
  } catch (err) {
    console.error('❌ Delete worker error:', err);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});


const port = process.env.PORT || 5000;
init().then(() => {
  app.listen(port, () => {
    console.log(`✅ Server running at http://localhost:${port}`);
  });
});
