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

  // Function to fetch ingredient suggestions based on query
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

  // Function to fetch recipes based on selected ingredients and match type
  const fetchRecipes = async (ingredientIds, matchType) => {
    if (ingredientIds.length === 0) {
      setRecipes([]);
      return;
    }

    setLoadingRecipes(true);
    try {
      const response = await fetch(
        `/api/v1/recipes?ingredient_ids=${encodeURIComponent(ingredientIds.join(','))}&match_type=${matchType}`
      );
      if (!response.ok) throw new Error('Failed to fetch recipes.');
      const data = await response.json();
      setRecipes(data);
      setError(null);
    } catch (err) {
      setError(err.message);
      setRecipes([]);
    } finally {
      setLoadingRecipes(false);
    }
  };

  // Handle the search input and trigger suggestions fetching
  useEffect(() => {
    if (queryInput.length >= 2) {
      const debounceTimeout = setTimeout(() => fetchSuggestions(queryInput), 300);
      return () => clearTimeout(debounceTimeout);
    } else {
      setSuggestions([]);
    }
  }, [queryInput]);

  // Handle ingredient selection and fetch recipes accordingly
  const handleIngredientSelect = (ingredient) => {
    if (!selectedIngredients.some((ing) => ing.id === ingredient.id)) {
      const updatedIngredients = [...selectedIngredients, ingredient];
      setSelectedIngredients(updatedIngredients);
      fetchRecipes(updatedIngredients.map((ing) => ing.id), matchType);
    }
    setQueryInput('');
    setSuggestions([]);
  };

  // Handle ingredient removal from the selected list
  const handleIngredientRemove = (ingredientId) => {
    const updatedIngredients = selectedIngredients.filter(
      (ingredient) => ingredient.id !== ingredientId
    );
    setSelectedIngredients(updatedIngredients);
    fetchRecipes(updatedIngredients.map((ing) => ing.id), matchType);
  };

  // Handle match type change and re-fetch recipes
  const handleMatchTypeChange = (type) => {
    setMatchType(type);
    if (selectedIngredients.length > 0) {
      fetchRecipes(selectedIngredients.map((ing) => ing.id), type);
    }
  };

  return (
    <div className="w-full bg-white p-8 rounded-lg shadow-md max-w-full mt-8 mx-auto">
      {/* Input Field */}
      <div className="relative mb-6">
        <input
          type="text"
          className="w-full p-4 pl-6 pr-6 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 text-lg transition-all duration-300 ease-in-out"
          placeholder="Search for ingredients..."
          value={queryInput}
          onChange={(e) => setQueryInput(e.target.value)}
        />
        {queryInput.length >= 3 && suggestions.length > 0 && (
          <ul className="absolute bg-white shadow-lg rounded-lg w-full mt-2 max-h-60 overflow-y-auto z-10 border border-gray-300 rounded-lg">
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
                className="flex items-center p-2 bg-blue-100 rounded-lg text-sm"
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

      {/* Recipes Section */}
      <RecipesSection
        recipes={recipes}
        loading={loadingRecipes}
        error={error}
        showNoResults={selectedIngredients.length > 0 && recipes.length === 0}
      />
    </div>
  );
};

export default SearchBar;
