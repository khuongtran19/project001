const User = require('../models/userModel');
const mongoose = require('mongoose');

const updateUserRole = async (req, res) => {
    try {
        console.log(`🔹 Processing role update for user ID: ${req.body.userId}`);

        const { userId, newRole } = req.body;
        if (!userId || !newRole) {
            console.error("❌ Missing userId or newRole");
            return res.status(400).json({ message: "User ID and new role are required" });
        }

        // ✅ Correct ObjectId usage
        const user = await User.findByIdAndUpdate(new mongoose.Types.ObjectId(userId), { role: newRole }, { new: true });

        if (!user) {
            console.error("❌ User not found in database");
            return res.status(404).json({ message: "User not found" });
        }

        console.log(`✅ Role updated successfully: New Role - ${newRole}`);
        res.json({ message: "User role updated successfully", user });
    } catch (error) {
        console.error(`❌ Error updating role: ${error.message}`);
        res.status(500).json({ message: "Server error", error: error.message });
    }
};

module.exports = { updateUserRole };
