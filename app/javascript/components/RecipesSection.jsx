import React from 'react';
import RecipeCard from './RecipeCard';

const RecipesSection = ({ recipes, loading, error, showNoResults }) => {
  if (loading) {
    return <div>Loading recipes...</div>;
  }

  if (error) {
    return <div className="text-red-500 mt-4">{error}</div>;
  }

  if (showNoResults) {
    return <div className="text-gray-500 mt-4">No recipes found with the selected ingredients.</div>;
  }

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 mt-8">
      {recipes.map((recipe) => (
        <RecipeCard key={recipe.id} recipe={recipe} />
      ))}
    </div>
  );
};

export default RecipesSection;

