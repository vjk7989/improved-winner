import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import mongoose from 'mongoose';
import authRoutes from './routes/auth.js';
import profileRoutes from './routes/profile.js';
import { errorHandler } from './middleware/errorHandler.js';
import { connectDB } from './config/database.js';

const app = express();
const PORT = process.env.PORT || 3001; // Changed to 3001 to avoid conflicts

// Middleware
app.use(cors());
app.use(express.json());

// Root route
app.get('/', (req, res) => {
  res.json({
    message: 'User Authentication API',
    version: '1.0.0',
    endpoints: {
      auth: {
        signup: 'POST /api/auth/signup',
        login: 'POST /api/auth/login',
        forgetPassword: 'POST /api/auth/forget-password'
      },
      profile: {
        get: 'GET /api/profile',
        update: 'PUT /api/profile'
      }
    }
  });
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/profile', profileRoutes);

// Error handling
app.use(errorHandler);

// Connect to MongoDB and start server
connectDB().then(() => {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}).catch(err => {
  console.error('Failed to start server:', err);
  process.exit(1);
});