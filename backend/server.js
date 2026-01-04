require('dotenv').config(); 
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcrypt');
const path = require('path'); 
const app = express();

app.use(cors());
app.use(express.json());

// Use Environment Variable for MongoDB
const mongoURI = process.env.MONGODB_URI;
mongoose.connect(mongoURI)
    .then(() => console.log("Connected to MongoDB successfully"))
    .catch(err => console.error("MongoDB connection error:", err));

// --- MODELS ---
const User = mongoose.model('User', new mongoose.Schema({
    username: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    fullname: String, 
    email: { type: String, default: "" },
    phoneNumber: { type: String, default: "" }, 
    address: { type: String, default: "" },
    gender: { type: String, default: "" }, 
    role: { type: String, default: 'user' },
    borrowedCount: { type: Number, default: 0 }
}));

const Book = mongoose.model('Book', new mongoose.Schema({
    title: String, 
    author: String, 
    description: String,
    category: { type: String, default: "General" },
    isAvailable: { type: Boolean, default: true },
    borrowerId: { type: String, default: null }
}));

const Borrow = mongoose.model('Borrow', new mongoose.Schema({
    userId: String, 
    bookId: String, 
    title: String,
    borrowDate: { type: Date, default: Date.now },
    returnDate: Date, 
    status: { type: String, default: 'active' }
}));

// --- API ROUTES ---
app.post('/api/register', async (req, res) => {
    try {
        const hashed = await bcrypt.hash(req.body.password, 10);
        const user = new User({ ...req.body, password: hashed });
        await user.save();
        res.json({ ok: true });
    } catch (e) { res.status(400).send(e.message); }
});

app.post('/api/login', async (req, res) => {
    const user = await User.findOne({ username: req.body.username });
    if (user && await bcrypt.compare(req.body.password, user.password)) {
        res.json({ ok: true, user });
    } else res.status(401).send("Invalid credentials");
});

app.get('/api/books', async (req, res) => res.json(await Book.find()));
app.post('/api/books', async (req, res) => res.json(await new Book(req.body).save()));
app.put('/api/books/:id', async (req, res) => res.json(await Book.findByIdAndUpdate(req.params.id, req.body)));
app.delete('/api/books/:id', async (req, res) => res.json(await Book.findByIdAndDelete(req.params.id)));

// --- STATIC HOSTING CONFIGURATION ---
app.use('/mobile', express.static(path.join(__dirname, '../frontend_mobile/build/web')));
app.use(express.static(path.join(__dirname, '../frontend_web/build')));

app.get('*', (req, res) => {
    if (!req.path.startsWith('/api')) {
        res.sendFile(path.join(__dirname, '../frontend_web/build', 'index.html'));
    }
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));