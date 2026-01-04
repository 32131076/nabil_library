import React, { useState } from 'react';
import { apiService } from '../api/apiService';
import { useNavigate } from 'react-router-dom';
import { BookPlus, ArrowLeft } from 'lucide-react';
import '../css/addBook.css';

const AddBook = () => {
    const navigate = useNavigate();
    const [bookData, setBookData] = useState({
        title: '',
        author: '',
        category: '',
        description: '',
        isAvailable: true
    });

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            await apiService.addBook(bookData);
            alert("Book added successfully!");
            navigate('/home');
        } catch (err) {
            alert(err.response?.data?.message || "Failed to add book");
        }
    };

    return (
        <div className="add-book-container">
            <button className="back-btn" onClick={() => navigate('/home')}>
                <ArrowLeft size={20} /> Back to Dashboard
            </button>
            
            <div className="form-card student-card">
                <div className="form-header">
                    <BookPlus size={32} color="#5D4037" />
                    <h2>Add New Book</h2>
                </div>

                <form onSubmit={handleSubmit}>
                    <div className="input-group">
                        <label>Book Title</label>
                        <input 
                            type="text" 
                            placeholder="Enter title"
                            onChange={(e) => setBookData({...bookData, title: e.target.value})}
                            required 
                        />
                    </div>

                    <div className="input-group">
                        <label>Author Name</label>
                        <input 
                            type="text" 
                            placeholder="Enter author"
                            onChange={(e) => setBookData({...bookData, author: e.target.value})}
                            required 
                        />
                    </div>

                    <div className="input-group">
                        <label>Category</label>
                        <select onChange={(e) => setBookData({...bookData, category: e.target.value})} required>
                            <option value="">Select Category</option>
                            <option value="Science">Science</option>
                            <option value="History">History</option>
                            <option value="Technology">Technology</option>
                            <option value="Literature">Literature</option>
                        </select>
                    </div>

                    <div className="input-group">
                        <label>Description</label>
                        <textarea 
                            placeholder="Short summary of the book"
                            onChange={(e) => setBookData({...bookData, description: e.target.value})}
                        />
                    </div>

                    <button type="submit" className="submit-btn">Save to Library</button>
                </form>
            </div>
        </div>
    );
};

export default AddBook;