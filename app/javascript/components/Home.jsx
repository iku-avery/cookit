import React from "react";
import { Link } from "react-router-dom";

export default () => (
  <div className="w-full h-screen flex items-center justify-center bg-primary">
    <div className="bg-transparent p-8 rounded shadow-md w-full max-w-3xl">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-secondary">recipes</h1>
        <p className="text-lg mt-4 mb-6 text-gray-700">
        a carefully chosen collection of recipes to help you create the perfect homemade dinner with the ingredients you already have
        </p>
        <hr className="my-4 border-gray-300" />
        <Link
          to="/recipes"
          className="inline-block px-6 py-3 bg-blue-500 text-white font-semibold rounded hover:bg-blue-600 transition duration-300"
          role="button"
        >
          view all recipes
        </Link>
      </div>
    </div>
  </div>
);
