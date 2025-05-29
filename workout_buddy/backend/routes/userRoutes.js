const express = require('express');
const { protect, authorize } = require('../middleware/authMiddleware');
const { updateUserRole } = require('../controllers/userController');
const router = express.Router();

router.put('/update-role', (req, res, next) => {
    console.log("🔹 Request reached userRoutes.js");
    next();
}, protect, authorize('assignRoles'), updateUserRole);

module.exports = router;

