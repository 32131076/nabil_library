import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { apiService } from '../api/apiService';
import { Edit3, ArrowLeft, Save } from 'lucide-react';
import '../css/editBook.css';

const EditBook = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const [loading, setLoading] = useState(true);
    const [bookData, setBookData] = useState({
        title: '',
        author: '',
        category: '',
        description: '',
        isAvailable: true
    });

    useEffect(() => {
        const fetchBook = async () => {
            try {
                const res = await apiService.getBooks();
                const book = res.data.find(b => b._id === id);
                if (book) {
                    setBookData(book);
                }
                setLoading(false);
            } catch (err) {
                console.error("Error fetching book:", err);
                setLoading(false);
            }
        };
        fetchBook();
    }, [id]);

    const handleUpdate = async (e) => {
        e.preventDefault();
        try {
            await apiService.updateBook(id, bookData);
            alert("Book updated successfully!");
            navigate('/home');
        } catch (err) {
            alert("Update failed: " + (err.response?.data?.message || "Error"));
        }
    };

    if (loading) return <div className="loader">Loading Book Details...</div>;

    return (
        <div className="edit-book-container">
            <header className="edit-header">
                <button className="back-link" onClick={() => navigate(-1)}>
                    <ArrowLeft size={18} /> Back
                </button>
                <h2><Edit3 size={24} /> Edit Book Details</h2>
            </header>

            <div className="edit-card student-card">
                <form onSubmit={handleUpdate}>
                    <div className="input-grid">
                        <div className="field">
                            <label>Title</label>
                            <input 
                                type="text" 
                                value={bookData.title}
                                onChange={(e) => setBookData({...bookData, title: e.target.value})}
                                required 
                            />
                        </div>

                        <div className="field">
                            <label>Author</label>
                            <input 
                                type="text" 
                                value={bookData.author}
                                onChange={(e) => setBookData({...bookData, author: e.target.value})}
                                required 
                            />
                        </div>

                        <div className="field">
                            <label>Category</label>
                            <select 
                                value={bookData.category}
                                onChange={(e) => setBookData({...bookData, category: e.target.value})}
                            >
                                <option value="Science">Science</option>
                                <option value="History">History</option>
                                <option value="Technology">Technology</option>
                                <option value="Literature">Literature</option>
                            </select>
                        </div>

                        <div className="field">
                            <label>Availability</label>
                            <div className="toggle-container">
                                <input 
                                    type="checkbox" 
                                    id="available"
                                    checked={bookData.isAvailable}
                                    onChange={(e) => setBookData({...bookData, isAvailable: e.target.checked})}
                                />
                                <label htmlFor="available">In Stock / Available</label>
                            </div>
                        </div>
                    </div>

                    <div className="field full-width">
                        <label>Description</label>
                        <textarea 
                            value={bookData.description}
                            onChange={(e) => setBookData({...bookData, description: e.target.value})}
                            rows="4"
                        />
                    </div>

                    <div className="button-group">
                        <button type="submit" className="btn-save">
                            <Save size={18} /> Update Book
                        </button>
                    </div>
                </form>
            </div>
        </div>
    );
};

export default EditBook;