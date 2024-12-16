import React from 'react';
import SearchBar from './SearchBar';

const Homepage = () => {
  return (
    <div className="min-h-screen flex flex-col bg-gradient-to-br from-primary to-blue-400 px-4 py-8">

      {/* Header */}
      <header className="bg-gradient-to-r from-teal-300 via-pink-300 to-yellow-300 text-center p-8 mb-8 w-full rounded-b-lg shadow-lg">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-4xl font-extrabold text-gray-800 mb-4">
            cook it!
          </h1>
          <p className="text-xl font-light text-gray-600">
            find delicious recipes based on the ingredients you have at home 🧁🥐🍓
          </p>
        </div>
      </header>

      {/* Main content (SearchBar and Recipes) */}
      <div className="flex-grow w-full overflow-auto">
        <SearchBar />
      </div>

      {/* Footer */}
      <footer className="bg-gradient-to-r from-purple-300 via-pink-300 to-yellow-200 text-center p-12 mt-8 w-full rounded-t-lg shadow-lg">
        <div className="max-w-4xl mx-auto">
          <p className="text-gray-700 text-sm font-medium">
            made with ❤️ by 🦝
          </p>
        </div>
      </footer>
    </div>
  );
};

export default Homepage;
