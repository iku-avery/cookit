import React, { useState, useEffect } from 'react';
import RecipesSection from './RecipesSection';

const SearchBar = () => {
  const [queryInput, setQueryInput] = useState('');
  const [suggestions, setSuggestions] = useState([]);
  const [selectedIngredients, setSelectedIngredients] = useState([]);
  const [recipes, setRecipes] = useState([]);
  const [loadingRecipes, setLoadingRecipes] = useState(false);
  const [matchType, setMatchType] = useState('all');
  const [error, setError] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [searchTriggered, setSearchTriggered] = useState(false); // Track if search was clicked
  const perPage = 10;

  // Fetch suggestions based on query input
  const fetchSuggestions = async (query) => {
    try {
      const response = await fetch(`/api/v1/product_ingredients?query=${query}`);
      if (!response.ok) throw new Error('Failed to fetch ingredients.');
      const data = await response.json();
      setSuggestions(data);
      setError(null);
    } catch (err) {
      setError(err.message);
      setSuggestions([]);
    }
  };

  // Fetch recipes based on selected ingredients and match type
  const fetchRecipes = async (ingredientIds, matchType, page = 1, perPage = 10) => {
    if (ingredientIds.length === 0) {
      setRecipes([]); // If no ingredients are selected, clear recipes
      return;
    }

    setLoadingRecipes(true);
    try {
      const response = await fetch(
        `/api/v1/recipes?ingredient_ids=${encodeURIComponent(ingredientIds.join(','))}&match_type=${matchType}&page=${page}&per_page=${perPage}`
      );
      if (!response.ok) throw new Error('Failed to fetch recipes.');
      const data = await response.json();
      const totalCount = data.total_count;
      setRecipes(data.recipes);
      setTotalPages(Math.ceil(totalCount / perPage));
      setError(null);
    } catch (err) {
      setError(err.message);
      setRecipes([]);
    } finally {
      setLoadingRecipes(false);
    }
  };

  // Trigger fetching suggestions when typing in the input
  useEffect(() => {
    if (queryInput.length >= 2) {
      const debounceTimeout = setTimeout(() => fetchSuggestions(queryInput), 300);
      return () => clearTimeout(debounceTimeout);
    } else {
      setSuggestions([]);
    }
  }, [queryInput]);

  // Trigger fetching recipes when selected ingredients or match type changes
  useEffect(() => {
    if (selectedIngredients.length > 0) {
      fetchRecipes(selectedIngredients.map((ing) => ing.id), matchType, currentPage);
    }
  }, [selectedIngredients, matchType, currentPage]);

  // Handle ingredient selection
  const handleIngredientSelect = (ingredient) => {
    if (!selectedIngredients.some((ing) => ing.id === ingredient.id)) {
      setSelectedIngredients([...selectedIngredients, ingredient]);
    }
    setQueryInput('');
    setSuggestions([]);
    setSearchTriggered(true); // Trigger search when an ingredient is selected
  };

  // Handle ingredient removal
  const handleIngredientRemove = (ingredientId) => {
    const updatedIngredients = selectedIngredients.filter(
      (ingredient) => ingredient.id !== ingredientId
    );
    setSelectedIngredients(updatedIngredients);

    // If no ingredients are left, stop showing recipes and hide "No recipes found"
    if (updatedIngredients.length === 0) {
      setRecipes([]); // Clear recipes if all ingredients are removed
    } else {
      fetchRecipes(updatedIngredients.map((ing) => ing.id), matchType, currentPage); // Fetch new recipes
    }
  };

  // Handle match type change
  const handleMatchTypeChange = (type) => {
    setMatchType(type);
  };

  // Handle search button click to fetch recipes
  const handleSearchClick = () => {
    setSearchTriggered(true); // Set searchTriggered to true when the search button is clicked
    if (selectedIngredients.length > 0) {
      fetchRecipes(selectedIngredients.map((ing) => ing.id), matchType, currentPage);
    }
  };

  // Pagination handlers
  const handlePageChange = (newPage) => {
    if (newPage >= 1 && newPage <= totalPages) {
      setCurrentPage(newPage);
      fetchRecipes(selectedIngredients.map((ing) => ing.id), matchType, newPage);
    }
  };

  return (
    <div className="w-full bg-white p-8 rounded-lg shadow-md max-w-full mt-8 mx-auto">
      {/* Input Field */}
      <div className="relative mb-6">
        <input
          type="text"
          className="w-full p-4 pl-6 pr-6 bg-white border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400 shadow-sm text-lg transition-all duration-300 ease-in-out"
          placeholder="Search for ingredients..."
          value={queryInput}
          onChange={(e) => setQueryInput(e.target.value)}
        />
        {queryInput.length >= 3 && suggestions.length > 0 && (
          <ul className="absolute bg-white shadow-lg rounded-lg w-full mt-2 max-h-60 overflow-y-auto z-10 border border-gray-300">
            {suggestions.map((ingredient) => (
              <li
                key={ingredient.id}
                className="px-6 py-3 cursor-pointer hover:bg-blue-50 focus:bg-blue-100 transition-colors duration-200"
                onClick={() => handleIngredientSelect(ingredient)}
              >
                {ingredient.name}
              </li>
            ))}
          </ul>
        )}
      </div>

      {/* Selected Ingredients Section */}
      {selectedIngredients.length > 0 && (
        <div className="mb-6">
          <h5 className="font-semibold mb-2">Selected Ingredients:</h5>
          <div className="flex flex-wrap gap-2">
            {selectedIngredients.map((ingredient) => (
              <div
                key={ingredient.id}
                className="flex items-center p-2 bg-purple-100 rounded-lg text-sm"
              >
                {ingredient.name}
                <button
                  onClick={() => handleIngredientRemove(ingredient.id)}
                  className="ml-2 text-red-500 hover:text-red-700"
                >
                  &times;
                </button>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Match Type Selection */}
      <div className="mb-6">
        <div className="flex items-center gap-6">
          <label className="flex items-center">
            <input
              type="radio"
              name="match_type"
              value="all"
              checked={matchType === 'all'}
              onChange={() => handleMatchTypeChange('all')}
              className="mr-2"
            />
            Match all ingredients
          </label>
          <label className="flex items-center">
            <input
              type="radio"
              name="match_type"
              value="any"
              checked={matchType === 'any'}
              onChange={() => handleMatchTypeChange('any')}
              className="mr-2"
            />
            Match at least one ingredient
          </label>
        </div>
      </div>

      {/* Search Button */}
      <button
        onClick={handleSearchClick}
        className="w-auto px-6 py-3 bg-gradient-to-r from-pink-500 via-purple-500 to-indigo-500 text-white rounded-lg shadow-md hover:from-pink-600 hover:via-purple-600 hover:to-indigo-600 focus:outline-none text-sm flex items-center justify-center mx-auto space-x-2 transition duration-300 ease-in-out"
      >
        <span>Search Recipes</span>
      </button>

      {/* Recipes Section */}
      {selectedIngredients.length === 0 ? null : (
        <>
          {recipes.length === 0 && searchTriggered && !loadingRecipes ? (
            <div className="text-center mt-4 text-gray-600 text-lg">
              No recipes found with the selected ingredients.
            </div>
          ) : (
            <RecipesSection recipes={recipes} loading={loadingRecipes} error={error} />
          )}
        </>
      )}

      {/* Pagination UI */}
      {totalPages > 1 && selectedIngredients.length > 0 && (
        <div className="flex justify-center mt-6">
          <button
            onClick={() => handlePageChange(currentPage - 1)}
            disabled={currentPage === 1}
            className="px-4 py-2 border rounded-md mr-2"
          >
            Previous
          </button>
          <span className="px-4 py-2">{`Page ${currentPage} of ${totalPages}`}</span>
          <button
            onClick={() => handlePageChange(currentPage + 1)}
            disabled={currentPage === totalPages}
            className="px-4 py-2 border rounded-md ml-2"
          >
            Next
          </button>
        </div>
      )}
    </div>
  );
};

export default SearchBar;

