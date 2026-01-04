import React, { useState } from 'react';
import { apiService } from '../api/apiService';
import { User, Mail, Lock, Save, Camera, AlertCircle, CheckCircle } from 'lucide-react';
import '../css/editProfile.css';

const EditProfile = ({ user, setUser }) => {
    const [formData, setFormData] = useState({
        fullname: user?.fullname || '',
        username: user?.username || '',
        password: ''
    });

    const [status, setStatus] = useState({ type: '', msg: '' });
    const [isSubmitting, setIsSubmitting] = useState(false);

    const handleUpdate = async (e) => {
        e.preventDefault();
        setIsSubmitting(true);
        setStatus({ type: '', msg: '' });

        try {
            const userId = user._id || user.id;
            
            const payload = { ...formData };
            if (!payload.password) delete payload.password;

            const res = await apiService.updateUser(userId, payload);
            
            setUser(res.data); 
            setStatus({ type: 'success', msg: 'Profile updated successfully!' });
            
            setFormData(prev => ({ ...prev, password: '' }));
        } catch (err) {
            setStatus({ 
                type: 'error', 
                msg: err.response?.data?.message || 'Failed to update profile. Please try again.' 
            });
        } finally {
            setIsSubmitting(false);
        }
    };

    return (
        <div className="profile-container">
            <div className="profile-card student-card">
                <div className="profile-header">
                    <div className="avatar-wrapper">
                        <div className="large-avatar">
                            {user?.fullname?.charAt(0).toUpperCase()}
                        </div>
                        <button className="change-photo" title="Change Photo">
                            <Camera size={18} />
                        </button>
                    </div>
                    <h2>Account Settings</h2>
                    <p className="user-role-tag">{user?.role || 'Student'}</p>
                </div>

                {status.msg && (
                    <div className={`status-message ${status.type}`}>
                        {status.type === 'success' ? <CheckCircle size={18} /> : <AlertCircle size={18} />}
                        {status.msg}
                    </div>
                )}

                <form onSubmit={handleUpdate} className="profile-form">
                    <div className="form-grid">
                        <div className="input-box">
                            <label><User size={16}/> Full Name</label>
                            <input 
                                type="text" 
                                value={formData.fullname}
                                placeholder="Enter full name"
                                onChange={(e) => setFormData({...formData, fullname: e.target.value})}
                                required
                            />
                        </div>

                        <div className="input-box">
                            <label><Mail size={16}/> Username</label>
                            <input 
                                type="text" 
                                value={formData.username}
                                placeholder="Choose a username"
                                onChange={(e) => setFormData({...formData, username: e.target.value})}
                                required
                            />
                        </div>

                        <div className="input-box full-width">
                            <label><Lock size={16}/> New Password</label>
                            <input 
                                type="password" 
                                placeholder="Leave blank to keep current password"
                                value={formData.password}
                                onChange={(e) => setFormData({...formData, password: e.target.value})}
                            />
                        </div>
                    </div>

                    <button type="submit" className="save-profile-btn" disabled={isSubmitting}>
                        <Save size={18} /> {isSubmitting ? "Saving..." : "Save Changes"}
                    </button>
                </form>
            </div>
        </div>
    );
};

export default EditProfile;