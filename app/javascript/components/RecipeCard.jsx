import React from 'react';

const RecipeCard = ({ recipe }) => {
  return (
    <div className="bg-white shadow-lg rounded-lg overflow-hidden flex flex-col mb-6">
      <img
        src={recipe.image_url}
        alt={recipe.title}
        className="h-48 w-full object-cover"
      />
      <div className="p-4">
        <h4 className="font-semibold text-lg">{recipe.title}</h4>
        <p className="text-gray-600 text-sm">
          By: {recipe.author} | Category: {recipe.category}
        </p>
        <p className="text-gray-600 text-sm">
          Cuisine: {recipe.cuisine} | Rating: {recipe.rating} ⭐
        </p>
        <h5 className="font-semibold mt-2">Ingredients:</h5>
        <ul className="text-sm text-gray-700">
          {recipe.ingredients.map((ingredient, index) => (
            <li key={index}>
              {ingredient.name} - {ingredient.amount} {ingredient.unit}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
};

export default RecipeCard;

