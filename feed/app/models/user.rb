class User < ActiveRecord::Base
  has_many :user_recipes
  has_many :recipes, through: :user_recipes

  def save_recipe(recipe)
    UserRecipe.find_or_create_by(user_id: self.id, recipe_id: recipe.id)
  end
end
