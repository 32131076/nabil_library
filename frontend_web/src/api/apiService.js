import axios from 'axios';

const API_BASE_URL = "https://nabil-library-2.onrender.com/api";

const API = axios.create({
    baseURL: API_BASE_URL,
    headers: {
        'Content-Type': 'application/json'
    }
});

export const apiService = {
    login: (u, p) => API.post('/login', { username: u, password: p }),
    register: (data) => API.post('/register', data),
    getUserData: (id) => API.get(`/users/${id}`),
    updateUser: (id, data) => API.put(`/users/${id}`, data),
    getBooks: () => API.get('/books'),
    addBook: (data) => API.post('/books', data),
    updateBook: (id, data) => API.put(`/books/${id}`, data),
    borrowBook: (bookId, userId) => API.post('/borrow', { bookId, userId }),
    returnBook: (bookId, userId) => API.post('/return', { bookId, userId }),
    getMyBooks: (userId) => API.get(`/my-books/${userId}`),
    getHistory: (userId) => API.get(`/history/${userId}`),
};