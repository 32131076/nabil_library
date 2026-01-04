const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcrypt');
const app = express();
app.use(cors());
app.use(express.json());

mongoose.connect("mongodb+srv://aziz_admin:BhewYg1Z6w7GwaEN@cluster0.dvfro1g.mongodb.net/LibraryDB?retryWrites=true&w=majority");

const User = mongoose.model('User', new mongoose.Schema({
    username: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    fullname: String, email: { type: String, default: "" },
    phoneNumber: { type: String, default: "" }, address: { type: String, default: "" },
    gender: { type: String, default: "" }, role: { type: String, default: 'user' },
    borrowedCount: { type: Number, default: 0 }
}));

const Book = mongoose.model('Book', new mongoose.Schema({
    title: String, author: String, description: String,
    category: { type: String, default: "General" },
    isAvailable: { type: Boolean, default: true },
    borrowerId: { type: String, default: null }
}));

const Borrow = mongoose.model('Borrow', new mongoose.Schema({
    userId: String, bookId: String, title: String,
    borrowDate: { type: Date, default: Date.now },
    returnDate: Date, status: { type: String, default: 'active' }
}));

app.post('/api/login', async (req, res) => {
    const user = await User.findOne({ username: req.body.username });
    if (user && await bcrypt.compare(req.body.password, user.password)) {
        res.json(user);
    } else {
        res.status(401).send("Invalid");
    }
});

app.post('/api/register', async (req, res) => {
    try {
        const hashedPassword = await bcrypt.hash(req.body.password, 10);
        const newUser = new User({ ...req.body, password: hashedPassword });
        await newUser.save();
        res.status(201).json({ ok: true });
    } catch (err) {
        res.status(400).send("User already exists");
    }
});

app.post('/api/borrow', async (req, res) => {
    const { bookId, userId } = req.body;
    try {
        const user = await User.findById(userId);
        if (user.borrowedCount >= 5) return res.status(400).send("Limit reached (Max 5)");

        const book = await Book.findById(bookId);
        if (!book || !book.isAvailable) return res.status(400).send("Not Available");

        await new Borrow({ userId, bookId, title: book.title, status: 'active' }).save();
        await Book.findByIdAndUpdate(bookId, { isAvailable: false, borrowerId: userId });
        await User.findByIdAndUpdate(userId, { $inc: { borrowedCount: 1 } });
        res.json({ ok: true });
    } catch (e) { res.status(500).send(e.message); }
});

app.post('/api/return', async (req, res) => {
    const { bookId, userId } = req.body;
    try {
        const updated = await Borrow.findOneAndUpdate(
            { bookId, userId, status: 'active' },
            { $set: { status: 'returned', returnDate: new Date() } }
        );
        if (!updated) return res.status(404).send("No active record");

        await Book.findByIdAndUpdate(bookId, { isAvailable: true, borrowerId: null });
        const count = await Borrow.countDocuments({ userId, status: 'active' });
        await User.findByIdAndUpdate(userId, { borrowedCount: count });
        res.json({ ok: true });
    } catch (e) { res.status(500).send(e.message); }
});

app.get('/api/history/:userId', async (req, res) => {
    const data = await Borrow.find({ userId: req.params.userId, status: 'returned' }).sort({ returnDate: -1 });
    res.json(data);
});

app.get('/api/books', async (req, res) => res.json(await Book.find()));
app.post('/api/books', async (req, res) => res.json(await new Book(req.body).save()));
app.put('/api/books/:id', async (req, res) => res.json(await Book.findByIdAndUpdate(req.params.id, req.body)));
app.delete('/api/books/:id', async (req, res) => res.json(await Book.findByIdAndDelete(req.params.id)));

app.get('/api/users/:id', async (req, res) => res.json(await User.findById(req.params.id)));
app.put('/api/users/:id', async (req, res) => res.json(await User.findByIdAndUpdate(req.params.id, req.body)));
app.get('/api/users', async (req, res) => res.json(await User.find()));
app.get('/api/my-books/:userId', async (req, res) => res.json(await Book.find({ borrowerId: req.params.userId })));

app.listen(5000, () => console.log("Server running on port 5000"));
