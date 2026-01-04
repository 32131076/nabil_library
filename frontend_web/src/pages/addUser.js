import React, { useState } from 'react';
import { apiService } from '../api/apiService';
import { useNavigate } from 'react-router-dom';
import { UserPlus, ArrowLeft, Shield } from 'lucide-react';
import '../css/addUser.css';

const AddUser = () => {
    const navigate = useNavigate();
    const [formData, setFormData] = useState({
        username: '',
        password: '',
        fullname: '',
        email: '',
        phoneNumber: '',
        address: '',
        gender: '',
        role: 'user'
    });

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            await apiService.register(formData);
            alert("New account created successfully!");
            navigate('/home');
        } catch (err) {
            alert(err.response?.data?.message || "Registration failed. Username might already exist.");
        }
    };

    return (
        <div className="add-user-container">
            <button className="back-btn" onClick={() => navigate('/home')}>
                <ArrowLeft size={20} /> Back to Dashboard
            </button>
            
            <div className="form-card student-card">
                <div className="form-header">
                    <div className="icon-circle">
                        <UserPlus size={30} color="#5D4037" />
                    </div>
                    <h2>Create Account</h2>
                    <p>Register a new student or staff member</p>
                </div>

                <form onSubmit={handleSubmit}>
                    <div className="input-group">
                        <label>Full Name</label>
                        <input 
                            type="text" 
                            placeholder="e.g. John Doe"
                            onChange={(e) => setFormData({...formData, fullname: e.target.value})} 
                            required 
                        />
                    </div>

                    <div className="input-group">
                        <label>Email Address</label>
                        <input 
                            type="email" 
                            placeholder="john@example.com"
                            onChange={(e) => setFormData({...formData, email: e.target.value})} 
                        />
                    </div>

                    <div className="input-group">
                        <label>Phone Number</label>
                        <input 
                            type="text" 
                            placeholder="+1 234 567 890"
                            onChange={(e) => setFormData({...formData, phoneNumber: e.target.value})} 
                        />
                    </div>

                    <div className="input-group">
                        <label>Gender</label>
                        <select onChange={(e) => setFormData({...formData, gender: e.target.value})}>
                            <option value="">Select Gender</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <div className="input-group">
                        <label>Address</label>
                        <input 
                            type="text" 
                            placeholder="City, Country"
                            onChange={(e) => setFormData({...formData, address: e.target.value})} 
                        />
                    </div>

                    <div className="input-group">
                        <label>Username</label>
                        <input 
                            type="text" 
                            placeholder="johndoe123"
                            onChange={(e) => setFormData({...formData, username: e.target.value})} 
                            required 
                        />
                    </div>

                    <div className="input-group">
                        <label>Password</label>
                        <input 
                            type="password" 
                            placeholder="Minimum 6 characters"
                            onChange={(e) => setFormData({...formData, password: e.target.value})} 
                            required 
                        />
                    </div>

                    <div className="input-group">
                        <label>Access Level</label>
                        <div className="select-wrapper">
                            <Shield size={18} className="select-icon" />
                            <select 
                                value={formData.role}
                                onChange={(e) => setFormData({...formData, role: e.target.value})}
                            >
                                <option value="user">Student (User)</option>
                                <option value="employee">Librarian (Employee)</option>
                                <option value="admin">System Admin</option>
                            </select>
                        </div>
                    </div>

                    <button type="submit" className="submit-btn">Create User Profile</button>
                </form>
            </div>
        </div>
    );
};

export default AddUser;