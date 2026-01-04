import React, { useState, useEffect, useCallback } from 'react';
import { apiService } from '../api/apiService';
import Book from '../pages/book';
import { BookOpen, Info } from 'lucide-react';
import '../css/myBorrowBook.css';

const MyBorrowBook = ({ user }) => {
    const [borrowedBooks, setBorrowedBooks] = useState([]);
    const [loading, setLoading] = useState(true);

    const fetchBorrowedBooks = useCallback(async () => {
        setLoading(true);
        try {
            const userId = user._id || user.id;
            const res = await apiService.getMyBooks(userId);
            setBorrowedBooks(res.data);
        } catch (err) {
            console.error("Error fetching borrowed books:", err);
        } finally {
            setLoading(false);
        }
    }, [user]);

    useEffect(() => {
        fetchBorrowedBooks();
    }, [fetchBorrowedBooks]);

    const handleReturn = async (bookId) => {
        try {
            const userId = user._id || user.id;
            await apiService.returnBook(bookId, userId);
            alert("Book returned successfully!");
            fetchBorrowedBooks();
        } catch (err) {
            alert(err.response?.data?.message || "Return failed");
        }
    };

    return (
        <div className="borrow-page">
            <header className="borrow-header">
                <div className="title-section">
                    <div className="icon-box">
                        <BookOpen size={24} color="#FDFBF9" />
                    </div>
                    <div>
                        <h1>My Borrowed Books</h1>
                        <p>You have {borrowedBooks.length} active loans</p>
                    </div>
                </div>
                
                {borrowedBooks.length > 0 && (
                    <div className="info-banner">
                        <Info size={16} />
                        <span>Please return books before the due date to avoid fines.</span>
                    </div>
                )}
            </header>

            {loading ? (
                <div className="loading-container">Updating your library bag...</div>
            ) : (
                <div className="borrow-grid">
                    {borrowedBooks.length > 0 ? (
                        borrowedBooks.map(book => (
                            <Book 
                                key={book._id} 
                                book={book} 
                                variant="return" 
                                actionLabel="Return Book" 
                                onAction={handleReturn} 
                            />
                        ))
                    ) : (
                        <div className="empty-state card-glass">
                            <h3>No Active Borrows</h3>
                            <p>Your library bag is empty. Explore the catalog to borrow your next favorite book!</p>
                        </div>
                    )}
                </div>
            )}
        </div>
    );
};

export default MyBorrowBook;