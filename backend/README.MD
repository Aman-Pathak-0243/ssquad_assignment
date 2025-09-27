# Backend API - Banquet Booking App

Node.js/Express backend API for the Banquet Booking mobile application.

## 🚀 Quick Start

### Prerequisites

- Node.js v18+
- MongoDB running locally or MongoDB Atlas connection string

### Installation

```bash
cd backend
npm install
cp .env.example .env
# Edit .env if needed (default settings should work for local development)
npm run seed
npm start
```

Server runs at: **http://localhost:5000**

## 📡 API Endpoints

### Categories

- `GET /api/categories` - Get all service categories

### Locations

- `GET /api/locations/countries` - Get all countries
- `GET /api/locations/states/:countryId` - Get states by country
- `GET /api/locations/cities/:stateId` - Get cities by state

### Requests

- `GET /api/requests/event-types` - Get available event types
- `GET /api/requests/cuisines` - Get cuisine options with images
- `POST /api/requests` - Submit new booking request (with file uploads)

### Health Check

- `GET /api/health` - Server health status

## 📁 File Structure

```
src/
├── config/
│   └── database.js         # MongoDB connection
├── controllers/
│   ├── categoryController.js
│   ├── locationController.js
│   └── requestController.js
├── middlewares/
│   ├── errorHandler.js     # Global error handling
│   └── upload.js           # File upload configuration
├── models/
│   ├── Category.js         # Category schema
│   ├── Location.js         # Location schema
│   └── Request.js          # Booking request schema
├── routes/
│   ├── categories.js       # Category routes
│   ├── locations.js        # Location routes
│   └── requests.js         # Request routes
├── scripts/
│   └── seed.js             # Database seeding script
└── index.js                # App entry point
```

## 🗃️ Database Models

### Category

- Service categories (Travel & Stay, Banquets & Venues, etc.)
- Includes name, slug, description, image, order

### Location

- Hierarchical location data (Country → State → City)
- Supports dependent dropdown functionality

### Request

- Booking requests with all form data
- Auto-generated request ID
- File upload support
- Status tracking

## 🔧 Environment Variables

```bash
MONGODB_URI=mongodb://localhost:27017/banquet_booking
PORT=5000
NODE_ENV=development
UPLOAD_DIR=uploads
MAX_FILE_SIZE=5000000
```

## 🌱 Seeding Data

The seed script populates the database with:

- 3 service categories
- 4 countries (India, China, Japan, Russia)
- Multiple states for each country
- Cities for each state

## 📸 File Uploads

- Images stored in `uploads/` directory
- Supports JPEG, PNG, JPG, WebP
- Maximum file size: 5MB
- Maximum files per request: 10

## 🛠️ Development Commands

```bash
npm start          # Start server
npm run dev        # Start with nodemon (auto-reload)
npm run seed       # Seed database with sample data
```

## 🔍 Testing API

Use tools like Postman or curl to test endpoints:

```bash
# Get categories
curl http://localhost:5000/api/categories

# Get countries
curl http://localhost:5000/api/locations/countries

# Health check
curl http://localhost:5000/api/health
```
