import React from 'react';
import { Link, useNavigate, useLocation } from 'react-router-dom';
import { LogOut, UserCircle } from 'lucide-react';
import './navbar.css';

const Navbar = ({ user, setUser }) => {
    const navigate = useNavigate();
    const location = useLocation();

    const isActive = (path) => location.pathname === path ? 'active' : '';

    return (
        <header className="header">
            <div className="header-container">
                <div className="logo">
                    <h1>Nabil Library</h1>
                </div>

                <nav className="nav">
                    <Link to="/home" className={isActive('/home')}>Dashboard</Link>
                    <Link to="/my-borrow" className={isActive('/my-borrow')}>My Borrows</Link>
                    <Link to="/history" className={isActive('/history')}>History</Link>

                    {(user?.role === 'admin' || user?.role === 'employee') && (
                        <Link to="/add-book" className={isActive('/add-book')}>Add Book</Link>
                    )}
                    {user?.role === 'admin' && (
                        <Link to="/add-user" className={isActive('/add-user')}>Add User</Link>
                    )}
                </nav>

                <div className="action-group">
                    <button className="profile-btn" onClick={() => navigate('/profile')}>
                        <UserCircle size={20} />
                        <span>{user?.fullname || 'Profile'}</span>
                    </button>

                    <button className="logout-submit" onClick={() => setUser(null)}>
                        <LogOut size={18} />
                        <span>Logout</span>
                    </button>
                </div>
            </div>
        </header>
    );
};

export default Navbar;