import axios from 'axios';

// 1. Set your Backend URL
// Use 'localhost' for web, but remember Flutter emulators often use 10.0.2.2
const API_BASE_URL = "http://localhost:5000/api"; 

const API = axios.create({
    baseURL: API_BASE_URL,
    headers: {
        'Content-Type': 'application/json'
    }
});

export const apiService = {
    // Auth
    login: (u, p) => API.post('/login', { username: u, password: p }),
    register: (data) => API.post('/register', data),
    
    // Users
    getUserData: (id) => API.get(`/users/${id}`),
    updateUser: (id, data) => API.put(`/users/${id}`, data),
    
    // Books
    getBooks: () => API.get('/books'),
    addBook: (data) => API.post('/books', data),
    updateBook: (id, data) => API.put(`/books/${id}`, data),
    
    // Transactions (Same logic as Flutter)
    borrowBook: (bookId, userId) => API.post('/borrow', { bookId, userId }),
    returnBook: (bookId, userId) => API.post('/return', { bookId, userId }),
    getMyBooks: (userId) => API.get(`/my-books/${userId}`),
    getHistory: (userId) => API.get(`/history/${userId}`),
};