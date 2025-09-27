require("dotenv").config();
const mongoose = require("mongoose");
const connectDB = require("../config/database");
const Category = require("../models/category");
const Location = require("../models/Location");

const seedDatabase = async () => {
  try {
    console.log("🌱 Starting database seeding...");

    await connectDB();

    // Clear existing data
    await Category.deleteMany({});
    await Location.deleteMany({});

    console.log("🗑️  Cleared existing data");

    // Seed Categories
    const categories = [
      {
        name: "Travel & Stay",
        slug: "travel-stay",
        description: "Hotels, resorts, and travel packages",
        image:
          "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop",
        order: 1,
      },
      {
        name: "Banquets & Venues",
        slug: "banquets-venues",
        description: "Wedding halls, party venues, and event spaces",
        image:
          "https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=400&h=300&fit=crop",
        order: 2,
      },
      {
        name: "Retail stores & Shops",
        slug: "retail-shops",
        description: "Shopping centers, boutiques, and retail outlets",
        image:
          "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=300&fit=crop",
        order: 3,
      },
    ];

    const savedCategories = await Category.insertMany(categories);
    console.log(`✅ Seeded ${savedCategories.length} categories`);

    // Seed Countries
    const countries = [
      { name: "India", type: "country", code: "IN" },
      { name: "China", type: "country", code: "CN" },
      { name: "Japan", type: "country", code: "JP" },
      { name: "Russia", type: "country", code: "RU" },
    ];

    const savedCountries = await Location.insertMany(countries);
    console.log(`✅ Seeded ${savedCountries.length} countries`);

    // Find India for states
    const india = savedCountries.find((c) => c.name === "India");
    const china = savedCountries.find((c) => c.name === "China");

    // Seed Indian States
    const indianStates = [
      { name: "Maharashtra", type: "state", parentId: india._id, code: "MH" },
      { name: "Delhi", type: "state", parentId: india._id, code: "DL" },
      { name: "Karnataka", type: "state", parentId: india._id, code: "KA" },
      { name: "Tamil Nadu", type: "state", parentId: india._id, code: "TN" },
      { name: "Gujarat", type: "state", parentId: india._id, code: "GJ" },
    ];

    // Seed Chinese States/Provinces
    const chineseStates = [
      { name: "Beijing", type: "state", parentId: china._id, code: "BJ" },
      { name: "Shanghai", type: "state", parentId: china._id, code: "SH" },
      { name: "Guangdong", type: "state", parentId: china._id, code: "GD" },
    ];

    const savedStates = await Location.insertMany([
      ...indianStates,
      ...chineseStates,
    ]);
    console.log(`✅ Seeded ${savedStates.length} states`);

    // Find specific states for cities
    const maharashtra = savedStates.find((s) => s.name === "Maharashtra");
    const delhi = savedStates.find((s) => s.name === "Delhi");
    const karnataka = savedStates.find((s) => s.name === "Karnataka");
    const beijing = savedStates.find((s) => s.name === "Beijing");

    // Seed Cities
    const cities = [
      // Maharashtra cities
      { name: "Mumbai", type: "city", parentId: maharashtra._id },
      { name: "Pune", type: "city", parentId: maharashtra._id },
      { name: "Nagpur", type: "city", parentId: maharashtra._id },

      // Delhi cities
      { name: "New Delhi", type: "city", parentId: delhi._id },
      { name: "Dwarka", type: "city", parentId: delhi._id },

      // Karnataka cities
      { name: "Bangalore", type: "city", parentId: karnataka._id },
      { name: "Mysore", type: "city", parentId: karnataka._id },

      // Beijing cities
      { name: "Chaoyang", type: "city", parentId: beijing._id },
      { name: "Haidian", type: "city", parentId: beijing._id },
    ];

    const savedCities = await Location.insertMany(cities);
    console.log(`✅ Seeded ${savedCities.length} cities`);

    console.log("🎉 Database seeding completed successfully!");
    console.log("📊 Summary:");
    console.log(`   - ${savedCategories.length} categories`);
    console.log(`   - ${savedCountries.length} countries`);
    console.log(`   - ${savedStates.length} states`);
    console.log(`   - ${savedCities.length} cities`);

    process.exit(0);
  } catch (error) {
    console.error("❌ Seeding failed:", error);
    process.exit(1);
  }
};

seedDatabase();
