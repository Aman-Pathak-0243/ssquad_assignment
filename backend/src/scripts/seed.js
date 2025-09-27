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

    // Seed States for all countries
    const countryMap = {};
    savedCountries.forEach((c) => (countryMap[c.name] = c));

    const states = [
      // India
      {
        name: "Maharashtra",
        type: "state",
        parentId: countryMap["India"]._id,
        code: "MH",
      },
      {
        name: "Delhi",
        type: "state",
        parentId: countryMap["India"]._id,
        code: "DL",
      },
      {
        name: "Karnataka",
        type: "state",
        parentId: countryMap["India"]._id,
        code: "KA",
      },
      {
        name: "Tamil Nadu",
        type: "state",
        parentId: countryMap["India"]._id,
        code: "TN",
      },
      {
        name: "Gujarat",
        type: "state",
        parentId: countryMap["India"]._id,
        code: "GJ",
      },

      // China
      {
        name: "Beijing",
        type: "state",
        parentId: countryMap["China"]._id,
        code: "BJ",
      },
      {
        name: "Shanghai",
        type: "state",
        parentId: countryMap["China"]._id,
        code: "SH",
      },
      {
        name: "Guangdong",
        type: "state",
        parentId: countryMap["China"]._id,
        code: "GD",
      },

      // Japan
      {
        name: "Tokyo",
        type: "state",
        parentId: countryMap["Japan"]._id,
        code: "TK",
      },
      {
        name: "Osaka",
        type: "state",
        parentId: countryMap["Japan"]._id,
        code: "OS",
      },

      // Russia
      {
        name: "Moscow",
        type: "state",
        parentId: countryMap["Russia"]._id,
        code: "MS",
      },
      {
        name: "Saint Petersburg",
        type: "state",
        parentId: countryMap["Russia"]._id,
        code: "SP",
      },
    ];

    const savedStates = await Location.insertMany(states);
    console.log(`✅ Seeded ${savedStates.length} states`);

    // Map states by name for easy city seeding
    const stateMap = {};
    savedStates.forEach((s) => (stateMap[s.name] = s));

    // Seed Cities for all states
    const cities = [
      // India
      { name: "Mumbai", type: "city", parentId: stateMap["Maharashtra"]._id },
      { name: "Pune", type: "city", parentId: stateMap["Maharashtra"]._id },
      { name: "New Delhi", type: "city", parentId: stateMap["Delhi"]._id },
      { name: "Bangalore", type: "city", parentId: stateMap["Karnataka"]._id },
      { name: "Chennai", type: "city", parentId: stateMap["Tamil Nadu"]._id },
      { name: "Ahmedabad", type: "city", parentId: stateMap["Gujarat"]._id },

      // China
      { name: "Chaoyang", type: "city", parentId: stateMap["Beijing"]._id },
      { name: "Haidian", type: "city", parentId: stateMap["Beijing"]._id },
      { name: "Pudong", type: "city", parentId: stateMap["Shanghai"]._id },
      { name: "Guangzhou", type: "city", parentId: stateMap["Guangdong"]._id },

      // Japan
      { name: "Shinjuku", type: "city", parentId: stateMap["Tokyo"]._id },
      { name: "Nishi", type: "city", parentId: stateMap["Osaka"]._id },

      // Russia
      { name: "Moscow City", type: "city", parentId: stateMap["Moscow"]._id },
      {
        name: "Saint Petersburg City",
        type: "city",
        parentId: stateMap["Saint Petersburg"]._id,
      },
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
