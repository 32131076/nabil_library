import React, { useState } from 'react';
import { apiService } from '../api/apiService';
import { useNavigate, Link } from 'react-router-dom';
import { LogIn, User, Lock, AlertCircle } from 'lucide-react';
import '../css/login.css';

const Login = ({ setUser }) => {
    const navigate = useNavigate();
    const [credentials, setCredentials] = useState({ username: '', password: '' });
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    const handleLogin = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError('');

        try {
            const res = await apiService.login(credentials.username, credentials.password);
            setUser(res.data); 
            navigate('/home');
        } catch (err) {
            setError(err.response?.data?.message || "Invalid credentials. Please try again.");
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="login-wrapper">
            <div className="login-card">
                <div className="login-brand">
                    <div className="brand-logo">
                        <LogIn size={32} color="#FDFBF9" />
                    </div>
                    <h1>Aziz Library</h1>
                </div>

                <form onSubmit={handleLogin} className="login-form">
                    {error && (
                        <div className="error-badge">
                            <AlertCircle size={16} /> {error}
                        </div>
                    )}

                    <div className="input-field">
                        <label><User size={16} /> Username</label>
                        <input 
                            type="text" 
                            placeholder="Enter your username"
                            value={credentials.username}
                            onChange={(e) => setCredentials({...credentials, username: e.target.value})}
                            required 
                        />
                    </div>

                    <div className="input-field">
                        <label><Lock size={16} /> Password</label>
                        <input 
                            type="password" 
                            placeholder="••••••••"
                            value={credentials.password}
                            onChange={(e) => setCredentials({...credentials, password: e.target.value})}
                            required 
                        />
                    </div>

                    <button type="submit" className="login-submit" disabled={loading}>
                        {loading ? "Verifying..." : "Sign In"}
                    </button>
                </form>

                <div className="login-footer">
                    <p>New user? <Link to="/register">Create an account</Link></p>
                </div>
            </div>
        </div>
    );
};

export default Login;