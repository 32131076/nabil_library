import React, { useState, useEffect, useCallback } from 'react';
import { apiService } from '../api/apiService';
import { History as HistoryIcon, Calendar, Book as BookIcon, User } from 'lucide-react';
import '../css/history.css';

const History = ({ user }) => {
    const [historyData, setHistoryData] = useState([]);
    const [loading, setLoading] = useState(true);

    const fetchHistory = useCallback(async () => {
        try {
            const userId = user._id || user.id;
            const res = await apiService.getHistory(userId);
            setHistoryData(res.data);
            setLoading(false);
        } catch (err) {
            console.error("Error fetching history:", err);
            setLoading(false);
        }
    }, [user]);

    useEffect(() => {
        fetchHistory();
    }, [fetchHistory]);

    if (loading) return <div className="loading-state">Loading your records...</div>;

    return (
        <div className="history-container">
            <header className="page-header">
                <div className="header-icon">
                    <HistoryIcon size={28} color="#5D4037" />
                </div>
                <div>
                    <h1>Library History</h1>
                    <p>View your past borrows and returns</p>
                </div>
            </header>

            <div className="history-list">
                {historyData.length > 0 ? (
                    historyData.map((record, index) => (
                        <div key={index} className="history-card student-card">
                            <div className="record-info">
                                <div className="record-book">
                                    <BookIcon size={20} className="brown-icon" />
                                    <strong>{record.bookTitle}</strong>
                                </div>
                                <div className="record-meta">
                                    <span><User size={14} /> {record.author}</span>
                                    <span><Calendar size={14} /> Borrowed: {new Date(record.borrowDate).toLocaleDateString()}</span>
                                    {record.returnDate && (
                                        <span className="return-date">
                                            <Calendar size={14} /> Returned: {new Date(record.returnDate).toLocaleDateString()}
                                        </span>
                                    )}
                                </div>
                            </div>
                            <div className={`status-pill ${record.status}`}>
                                {record.status}
                            </div>
                        </div>
                    ))
                ) : (
                    <div className="empty-history card-glass">
                        <p>No history records found.</p>
                    </div>
                )}
            </div>
        </div>
    );
};

export default History;