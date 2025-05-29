const express = require('express');
const { registerUser, loginUser } = require('../controllers/authController');
const router = express.Router();

console.log("this is auth routes call")
router.post('/register', registerUser);
router.post('/login', loginUser);
router.post('/refresh-token', async (req, res) => {
  try {
    const { refreshToken } = req.body;
    
    // Verify refresh token
    const decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET);
    
    // Generate new access token
    const user = await User.findById(decoded.userId);
    const newAccessToken = jwt.sign(
      { userId: user._id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '15m' }
    );

    res.json({ accessToken: newAccessToken });
  } catch (error) {
    res.status(401).json({ message: "Invalid refresh token" });
  }
});

module.exports = router;
