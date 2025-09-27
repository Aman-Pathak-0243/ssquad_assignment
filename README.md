# Banquets & Venues Booking App

A complete mobile application for booking banquets and venues, built with Flutter (frontend) and Node.js (backend).

## 🚀 Quick Setup Guide

### Prerequisites

- Node.js v18+ installed
- Flutter SDK installed
- MongoDB installed and running
- Android Studio/VS Code with Flutter extensions

### 1. Clone Repository

```bash
git clone https://github.com/Aman-Pathak-0243/ssquad_assignment.git
cd ssquad_assignment
```

### 2. Backend Setup

```bash
cd backend
npm install
cp .env.example .env
# Edit .env file with your MongoDB connection string if needed
npm run seed
npm start
```

Backend will run at: http://localhost:5000

### 3. Frontend Setup

```bash
cd ../frontend
flutter pub get
cp .env.example .env
# The .env already points to localhost:5000
flutter run
```

### 4. Test the App

1. Open the Flutter app
2. Tap on "BANQUETS & VENUES" card
3. Fill out the form with various options
4. Submit and see the success message with request ID

## 📱 Features

- Home screen with service categories
- Complete banquet booking form
- Dependent location dropdowns
- Multiple date selection
- Cuisine selection with images
- Image upload functionality
- Form validation and submission

## 🛠️ Tech Stack

- **Frontend**: Flutter 3+, Provider, Dio
- **Backend**: Node.js, Express, MongoDB, Multer
- **Database**: MongoDB with Mongoose

## 📂 Project Structure

```
├── backend/          # Node.js API server
├── frontend/         # Flutter mobile app
└── README.md         # This file
```

## 🐛 Troubleshooting

- Make sure MongoDB is running before starting backend
- Backend must be running before starting Flutter app
- Check console logs for any errors
- Default backend URL: http://localhost:5000

## 📞 Support

If you encounter any issues, check the individual README files in backend/ and frontend/ folders for more detailed instructions.
