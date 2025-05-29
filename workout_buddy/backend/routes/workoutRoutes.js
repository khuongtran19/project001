const express = require('express');
const { protect, authorize } = require('../middleware/authMiddleware');
const router = express.Router();

router.post('/create', protect, authorize('createWorkouts'), (req, res) => {
    res.json({ message: "Workout created successfully!" });
});

router.get('/join', protect, authorize('joinWorkouts'), (req, res) => {
    res.json({ message: "Workout joined successfully!" });
});

module.exports = router;
