class CLI

  def initialize
   @prompt = TTY::Prompt.new
 end

 #  asks user for name
 #  finds or creates user in db
  def find_or_create_user
    puts "Welcome to Feed!"
    name = @prompt.ask("Whats your name? ")
    @user = User.find_or_create_by(name: name)
  end

#   greets user
  def greet
    puts "Hi #{@user.name}!"
    options = ["View recipe book", "Search by ingredient"]
    ans = @prompt.select("Choose an option", (options))
    if ans == "View recipe book"
      user_recipes = @user.view_recipe_book
      select_recipe_from_book(user_recipes)
    end
  end

  def select_recipe_from_book(recipes)
    selection = @prompt.select("Please select a recipe:", (recipes))
    @selected_rec = @user.recipes.find { |recipe| recipe.title == selection }
    puts @selected_rec.content
  end

#   prompts user for search term and gets search term
  def search_ingredient
    @ing = @prompt.ask("Please enter ingredient name to search recipes: ")
  end

#   selects all recipe ingredients matching search term
  def recipe_ingredients
    RecipeIngredient.all.select { |ri| ri.ingredient.name == @ing }
  end

#   maps over recipe ingredients to create array of recipe instances
  def recipe_instances
    recipe_ingredients.map { |ri| ri.recipe }
  end

  #   returns relevant recipes based on search term
  #   gives error message if search term has no matches
  def display_search_results
    rec_ing = recipe_ingredients
    while rec_ing.length == 0
      puts "Sorry, that ingredient's not available."
      search_ingredient
      rec_ing = recipe_ingredients
    end
    rec_titles = recipe_instances.map { |r| r.title }
    select_recipe_from_search(rec_titles)
  end

  #   prompts user to select a recipe from list
  #   displays content of selected recipe
    def select_recipe_from_search(recipes)
      selection = @prompt.select("Please select a recipe:", (recipes))
      @selected_rec = recipe_instances.find { |recipe| recipe.title == selection }
      puts @selected_rec.content
    end

#   Ask usr if they want to save
#   Create new user recipe if yes
    def save?
    ans = @prompt.yes?("Would you like to save #{@selected_rec.title} recipe to your recipe book?")
    if ans
      @user.save_recipe(@selected_rec)
      search_again?
    else
      search_again?
    end
  end

#   asks user if they want to search again
  def search_again?
    answer = @prompt.yes?("Would you like to search another ingredient?")
    if answer
      find_recipe
    else
      puts "Thanks for using Feed. See you next time!"
    end
  end

  def find_recipe
    search_ingredient
    display_search_results
    save?
  end

  def run
    find_or_create_user
    greet
    find_recipe
  end

end



  #
  # save?
  #   asks user if they want to save recipe to recipe book
  #   if yes- create new user_recipe instance
  #   if no- ask user to search again
  #

  # search_again
  #   if yes back to search
  #   else Bye!
