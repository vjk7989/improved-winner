# User Authentication API

A Node.js backend application with user authentication and profile management.

## API Documentation

### Authentication Endpoints

#### Sign Up
```http
POST /api/auth/signup
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe",
  "mobileNumber": "1234567890"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

#### Forget Password
```http
POST /api/auth/forget-password
Content-Type: application/json

{
  "email": "user@example.com"
}
```

### Profile Endpoints

#### Get Profile
```http
GET /api/profile
Authorization: Bearer YOUR_JWT_TOKEN
```

#### Update Profile
```http
PUT /api/profile
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json

{
  "name": "Updated Name",
  "mobileNumber": "9876543210"
}
```

## Setup Instructions

1. Install dependencies:
   ```bash
   npm install
   ```

2. Set up environment variables:
   - Create a `.env` file with:
     ```
     MONGODB_URI=your_mongodb_uri
     JWT_SECRET=your_jwt_secret
     PORT=3000
     ```

3. Run the development server:
   ```bash
   npm run dev
   ```

## Deployment

The API is configured for deployment on Vercel using the provided `vercel.json` configuration.
https://asdw-5bf5m9e9a-vikiis-projects.vercel.app/api.