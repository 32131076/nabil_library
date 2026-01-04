import React, { useState } from 'react';
import { apiService } from '../api/apiService';
import { useNavigate, Link } from 'react-router-dom';
import { UserPlus, User, Lock, Mail, ArrowRight, Phone, MapPin } from 'lucide-react';
import '../css/register.css';

const Register = () => {
    const navigate = useNavigate();
    const [formData, setFormData] = useState({
        fullname: '',
        username: '',
        password: '',
        email: '',
        phoneNumber: '',
        address: '',
        gender: '',
        role: 'user'
    });
    const [error, setError] = useState('');

    const handleRegister = async (e) => {
        e.preventDefault();
        try {
            await apiService.register(formData);
            alert("Account created successfully! Please login.");
            navigate('/'); 
        } catch (err) {
            setError(err.response?.data?.message || "Registration failed. Try a different username.");
        }
    };

    return (
        <div className="register-wrapper">
            <div className="register-card">
                <div className="register-header">
                    <div className="icon-badge">
                        <UserPlus size={28} color="#5D4037" />
                    </div>
                    <h1>Join Aziz Library</h1>
                    <p>Create your student account to start borrowing.</p>
                </div>

                {error && <div className="error-message">{error}</div>}

                <form className="register-form" onSubmit={handleRegister}>
                    <div className="input-group">
                        <label><User size={16} /> Full Name</label>
                        <input 
                            type="text" 
                            placeholder="John Doe"
                            onChange={(e) => setFormData({...formData, fullname: e.target.value})}
                            required 
                        />
                    </div>

                    <div className="input-group">
                        <label><Mail size={16} /> Email Address</label>
                        <input 
                            type="email" 
                            placeholder="john@example.com"
                            onChange={(e) => setFormData({...formData, email: e.target.value})}
                        />
                    </div>

                    <div className="input-group">
                        <label><Phone size={16} /> Phone Number</label>
                        <input 
                            type="text" 
                            placeholder="+1 234 567"
                            onChange={(e) => setFormData({...formData, phoneNumber: e.target.value})}
                        />
                    </div>

                    <div className="input-group">
                        <label><User size={16} /> Gender</label>
                        <select onChange={(e) => setFormData({...formData, gender: e.target.value})}>
                            <option value="">Select Gender</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                        </select>
                    </div>

                    <div className="input-group">
                        <label><MapPin size={16} /> Address</label>
                        <input 
                            type="text" 
                            placeholder="City, Country"
                            onChange={(e) => setFormData({...formData, address: e.target.value})}
                        />
                    </div>

                    <div className="input-group">
                        <label><User size={16} /> Username</label>
                        <input 
                            type="text" 
                            placeholder="johndoe123"
                            onChange={(e) => setFormData({...formData, username: e.target.value})}
                            required 
                        />
                    </div>

                    <div className="input-group">
                        <label><Lock size={16} /> Password</label>
                        <input 
                            type="password" 
                            placeholder="Create a strong password"
                            onChange={(e) => setFormData({...formData, password: e.target.value})}
                            required 
                        />
                    </div>

                    <button type="submit" className="register-btn">
                        Create Account <ArrowRight size={18} />
                    </button>
                </form>

                <div className="register-footer">
                    <p>Already have an account? <Link to="/">Sign In</Link></p>
                </div>
            </div>
        </div>
    );
};

export default Register;