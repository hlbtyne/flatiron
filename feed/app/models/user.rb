class User < ActiveRecord::Base
  has_many :user_recipes
  has_many :recipes, through: :user_recipes

  def save_recipe(recipe)
    UserRecipe.find_or_create_by(user_id: self.id, recipe_id: recipe.id)
  end

  def view_recipe_book
     user_rec = self.user_recipes
     recipes = user_rec.map { |r| r.recipe }
     my_rec_titles = recipes.map { |r| r.title }
  end
end
