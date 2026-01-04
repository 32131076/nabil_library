import React, { useState, useEffect, useCallback } from 'react';
import { apiService } from '../api/apiService';
import Book from '../pages/book.js';
import { BookOpen, Search, RefreshCw } from 'lucide-react';
import '../css/home.css';

const Home = ({ user }) => {
    const [allBooks, setAllBooks] = useState([]);
    const [userData, setUserData] = useState(user);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');

    const loadData = useCallback(async () => {
        setLoading(true);
        try {
            const userId = user._id || user.id;
            const [booksRes, userRes] = await Promise.all([
                apiService.getBooks(),
                apiService.getUserData(userId)
            ]);
            setAllBooks(booksRes.data);
            setUserData(userRes.data);
        } catch (err) {
            console.error("Failed to sync with database:", err);
        } finally {
            setLoading(false);
        }
    }, [user]);

    useEffect(() => {
        loadData();
    }, [loadData]);

    const handleBorrow = async (bookId) => {
        try {
            await apiService.borrowBook(bookId, userData._id || userData.id);
            alert("Success! Book added to your borrows.");
            loadData();
        } catch (err) {
            alert(err.response?.data?.message || "Borrowing failed");
        }
    };

    const filteredBooks = allBooks.filter(book => 
        book.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
        book.author.toLowerCase().includes(searchTerm.toLowerCase())
    );

    return (
        <div className="home-dashboard">
            <section className="welcome-banner">
                <div className="banner-text">
                    <h1>Explore Our Collection</h1>
                    <p>Find your next read from over {allBooks.length} titles available today.</p>
                </div>
                <div className="stats-cards">
                    <div className="stat-item glass-card">
                        <BookOpen color="#5D4037" size={24} />
                        <div>
                            <span className="stat-value">{userData.borrowedCount || 0} / 5</span>
                            <span className="stat-label">Borrowed Books</span>
                        </div>
                    </div>
                </div>
            </section>

            <div className="action-bar">
                <div className="search-box">
                    <Search size={18} />
                    <input 
                        type="text" 
                        placeholder="Search by title or author..." 
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </div>
                <button className="refresh-btn" onClick={loadData}>
                    <RefreshCw size={18} /> Sync Library
                </button>
            </div>

            {loading ? (
                <div className="loading-spinner">Fetching Library Books...</div>
            ) : (
                <div className="books-container">
                    {filteredBooks.length > 0 ? (
                        filteredBooks.map(book => (
                            <Book 
                                key={book._id} 
                                book={book} 
                                variant="borrow" 
                                actionLabel="Borrow" 
                                onAction={handleBorrow} 
                            />
                        ))
                    ) : (
                        <div className="no-results">No books found matching your search.</div>
                    )}
                </div>
            )}
        </div>
    );
};

export default Home;