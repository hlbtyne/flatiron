class User < ActiveRecord::Base
  has_many :user_recipes
  has_many :recipes, through: :user_recipes

  validates :name, presence: true

#   Saves a recipe to the user's recipe book by creating a user recipe instance
  def save_recipe(recipe)
    UserRecipe.find_or_create_by(user_id: self.id, recipe_id: recipe.id)
  end

  def view_recipe_book
    my_updated_userrecipes = UserRecipe.all.select{ |ur| ur.user == self}
    my_updated_recipes = my_updated_userrecipes.map{|ur| ur.recipe.title}
    my_updated_recipes
  end

  def delete_recipe_from_book(recipe)
    self.recipes.destroy(recipe)
  end
end
