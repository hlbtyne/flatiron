class Recipe < ActiveRecord::Base
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  def create_recipe_ingredients(*ingredients)
    ingredients.each do |i|
      RecipeIngredient.create(recipe_id: self.id, ingredient_id: i.id)
    end
  end

  def list_ingredients
  end

end
