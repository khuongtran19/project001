const jwt = require('jsonwebtoken');
const roles = require('../config/rolesConfig');

const protect = (req, res, next) => {
    console.log(`🔹 Request made to: ${req.originalUrl}`);  // Log request URL
    try {
        const token = req.headers.authorization?.split(' ')[1];
        if (!token) {
            console.error("No token provided");
            return res.status(401).json({ message: "Not authorized, no token" });
        }
        if (decoded.exp < Date.now() / 1000) {
            return res.status(401).json({ message: "Token expired" });
        }
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded;
        console.log(`Token Verified: User Role - ${req.user.role}`);  // Log user details
        next();
    } catch (error) {
        console.error(`Token verification failed: ${error.message}`);
        res.status(401).json({ message: "Not authorized, invalid token" });
    }
};

const authorize = (permission) => {
    return (req, res, next) => {
        if (req.user && roles[req.user.role]?.includes(permission)) {
            next();
        } else {
            res.status(403).json({ message: "Not authorized for this action" });
        }
    };
};

module.exports = { protect, authorize };
