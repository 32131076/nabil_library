import React from 'react';
import './header.css';

const Header = ({ user }) => {
    return (
        <header className="app-header">
            <div className="header-left">
                <h1>Aziz Library</h1>
            </div>
            
            <div className="header-right">
                <div className="user-profile-summary">
                    <div className="user-text">
                        <span className="user-name">{user?.fullname}</span>
                        <span className="user-role">{user?.role || 'Student'}</span>
                    </div>
                    <div className="user-avatar">
                        {user?.fullname?.charAt(0).toUpperCase()}
                    </div>
                </div>
            </div>
        </header>
    );
};

export default Header;