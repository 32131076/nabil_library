require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcrypt');
const path = require('path');
const app = express();

app.use(cors());
app.use(express.json());

// 1. Connection
mongoose.connect(process.env.MONGODB_URI)
    .then(() => console.log("Connected to MongoDB"))
    .catch(err => console.error("Connection error:", err));

// 2. Models
const User = mongoose.model('User', new mongoose.Schema({
    username: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    fullname: String,
    email: String,
    phoneNumber: String,
    address: String,
    gender: String,
    role: { type: String, default: 'user' }
}));

const Book = mongoose.model('Book', new mongoose.Schema({
    title: String,
    author: String,
    category: String,
    description: String,
    isAvailable: { type: Boolean, default: true },
    borrowerId: { type: String, default: null }
}));

const Borrow = mongoose.model('Borrow', new mongoose.Schema({
    userId: String,
    bookId: String,
    bookTitle: String,
    borrowDate: { type: Date, default: Date.now },
    returnDate: Date,
    status: { type: String, default: 'active' }
}));

// 3. API Routes
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
        res.json(user);
    } else res.status(401).send("Invalid credentials");
});

// User Management (For EditProfile.js)
app.get('/api/users/:id', async (req, res) => res.json(await User.findById(req.params.id)));
app.put('/api/users/:id', async (req, res) => {
    if (req.body.password) req.body.password = await bcrypt.hash(req.body.password, 10);
    const updated = await User.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(updated);
});

// Book Management
app.get('/api/books', async (req, res) => res.json(await Book.find()));
app.post('/api/books', async (req, res) => res.json(await new Book(req.body).save()));
app.put('/api/books/:id', async (req, res) => res.json(await Book.findByIdAndUpdate(req.params.id, req.body)));
app.delete('/api/books/:id', async (req, res) => res.json(await Book.findByIdAndDelete(req.params.id)));

// Transaction Logic (For MyBorrowBook.js and Home.js)
app.post('/api/borrow', async (req, res) => {
    const { bookId, userId } = req.body;
    const book = await Book.findById(bookId);
    if (!book.isAvailable) return res.status(400).send("Already borrowed");

    await Book.findByIdAndUpdate(bookId, { isAvailable: false, borrowerId: userId });
    await new Borrow({ userId, bookId, bookTitle: book.title }).save();
    res.json({ ok: true });
});

app.post('/api/return', async (req, res) => {
    const { bookId, userId } = req.body;
    await Book.findByIdAndUpdate(bookId, { isAvailable: true, borrowerId: null });
    await Borrow.findOneAndUpdate({ bookId, userId, status: 'active' }, { status: 'returned', returnDate: Date.now() });
    res.json({ ok: true });
});

app.get('/api/my-books/:userId', async (req, res) => {
    res.json(await Book.find({ borrowerId: req.params.userId }));
});

app.get('/api/history/:userId', async (req, res) => {
    res.json(await Borrow.find({ userId: req.params.userId }));
});

app.get('/api/users', async (req, res) => {
    try {
        // Find all users but don't send their passwords for security
        const users = await User.find({}, '-password');
        res.json(users);
    } catch (e) {
        res.status(500).send(e.message);
    }
});

// 4. Static Files & Crash Fix
app.use('/mobile', express.static(path.join(__dirname, '../frontend_mobile/build/web')));
app.use(express.static(path.join(__dirname, '../frontend_web/build')));

// FIX: Named wildcard to stop the PathError crash
app.get(/(.*)/, (req, res) => {
    if (!req.path.startsWith('/api')) {
        res.sendFile(path.join(__dirname, '../frontend_web/build', 'index.html'));
    }
});
// 5. Start Server 
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));