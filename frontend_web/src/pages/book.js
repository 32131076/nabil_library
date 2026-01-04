import React from 'react';
import { Book as BookIcon, User, Tag, CheckCircle, XCircle } from 'lucide-react';
import '../css/book.css';

const Book = ({ book, onAction, actionLabel, variant }) => {    
    return (
        <div className={`book-card student-card ${!book.isAvailable ? 'unavailable' : ''}`}>
            <div className="book-status-badge">
                {book.isAvailable ? (
                    <span className="status-available"><CheckCircle size={14}/> Available</span>
                ) : (
                    <span className="status-borrowed"><XCircle size={14}/> Borrowed</span>
                )}
            </div>

            <div className="book-icon-wrapper">
                <BookIcon size={40} color="#5D4037" />
            </div>

            <div className="book-details">
                <h4 className="book-title">{book.title}</h4>
                
                <div className="book-meta">
                    <span><User size={14} /> {book.author}</span>
                    <span><Tag size={14} /> {book.category}</span>
                </div>

                {book.description && (
                    <p className="book-description">{book.description.substring(0, 60)}...</p>
                )}
            </div>

            {onAction && (
                <button 
                    className={`book-action-btn ${variant}`}
                    onClick={() => onAction(book._id)}
                    disabled={variant === 'borrow' && !book.isAvailable}
                >
                    {actionLabel}
                </button>
            )}
        </div>
    );
};

export default Book;