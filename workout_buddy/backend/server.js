const express = require('express');
const http = require('http');
const socketIO = require('socket.io');
const cors = require('cors');
require('dotenv').config();
const connectDB = require('./config/db');

const app = express();
const server = http.createServer(app);
const io = socketIO(server);
const authRoutes = require('./routes/authRoutes');
const { protect, authorize } = require('./middleware/authMiddleware');
const admin = (req, res, next) => {
    if (req.user && req.user.role === 'admin') {
        next(); // Grant access
    } else {
        res.status(403).json({ message: "Not authorized as an admin" });
    }
};
const userRoutes = require('./routes/userRoutes');

// Connect to MongoDB
connectDB();

// Middleware
app.use((req, res, next) => {
    console.log(`🔹 Incoming Request: ${req.method} ${req.originalUrl}`);
    next();
});
app.use(cors());
app.use(express.json());
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.get('/api/private', protect, (req, res) => {
    res.json({ message: "Welcome to the private route!", user: req.user });
});
app.get('/api/admin', protect, admin, (req, res) => {
    res.json({ message: "Welcome Admin!", user: req.user });
});
app.post('/api/workouts/assign', protect, authorize('assignWorkouts'), (req, res) => {
    res.json({ message: "Workout assigned successfully!" });
});
app.get('/api/workouts/join', protect, authorize('joinWorkouts'), (req, res) => {
    res.json({ message: "Workout joined successfully!" });
});

// Socket.IO setup
io.on('connection', (socket) => {
    console.log('New client connected');
    socket.on('disconnect', () => {
        console.log('Client disconnected');
    });
});

// Start the backend server
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => console.log(`Server running on port ${PORT}`));