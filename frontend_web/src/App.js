import React, { useState } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import Navbar from './components/navbar';
import Footer from './components/footer';
import Login from './pages/login';
import Register from './pages/register';
import Home from './pages/home';
import MyBorrowBook from './pages/myBorrowBook';
import History from './pages/history';
import EditProfile from './pages/editProfile';
import AddBook from './pages/addBook';
import AddUser from './pages/addUser';
import EditBook from './pages/editBook';

function App() {
  const [user, setUser] = useState(null);

  return (
    <Router>
      <div className="app-wrapper">        
        <div className="app-body">
          {user && <Navbar user={user} setUser={setUser} />}
          
          <main className={user ? "content-with-nav" : "content-full"}>
            <Routes>
              <Route path="/" element={!user ? <Login setUser={setUser} /> : <Navigate to="/home" />} />
              <Route path="/register" element={<Register />} />
              <Route path="/home" element={user ? <Home user={user} /> : <Navigate to="/" />} />
              <Route path="/my-borrow" element={user ? <MyBorrowBook user={user} /> : <Navigate to="/" />} />
              <Route path="/history" element={user ? <History user={user} /> : <Navigate to="/" />} />
              <Route path="/profile" element={user ? <EditProfile user={user} setUser={setUser} /> : <Navigate to="/" />} />
              {(user?.role === 'admin' || user?.role === 'employee') && (
                <>
                  <Route path="/add-book" element={<AddBook />} />
                  <Route path="/edit-book/:id" element={<EditBook />} />
                </>
              )}
              
              {user?.role === 'admin' && (
                <Route path="/add-user" element={<AddUser />} />
              )}
              <Route path="*" element={<Navigate to={user ? "/home" : "/"} />} />
            </Routes>
          </main>
        </div>
        
        {user && <Footer />}
      </div>
    </Router>
  );
}

export default App;