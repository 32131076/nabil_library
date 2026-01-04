import React from 'react';
import './footer.css';

const Footer = () => {
    const currentYear = new Date().getFullYear();

    return (
        <footer className="footer-container">
            <div className="footer-content">
                <div className="footer-section">
                    <h3>Aziz Library</h3>
                    <p>Empowering students through knowledge and easy access to digital resources.</p>
                </div>
                
                <div className="footer-section">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="/home">Dashboard</a></li>
                        <li><a href="/my-borrow">My Books</a></li>
                        <li><a href="/history">Reading History</a></li>
                    </ul>
                </div>

                <div className="footer-section">
                    <h4>Contact Support</h4>
                    <p>Email: support@azizlibrary.edu</p>
                    <p>Hours: Mon - Fri, 8:00 AM - 5:00 PM</p>
                </div>
            </div>
            
            <div className="footer-bottom">
                <p>&copy; {currentYear} Aziz Library System. All Rights Reserved.</p>
            </div>
        </footer>
    );
};

export default Footer;