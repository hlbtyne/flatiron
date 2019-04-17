class CLI

  def initialize
   @prompt = TTY::Prompt.new
 end

 #  asks user for name
 #  finds or creates user in db
  def find_or_create_user
    puts "Welcome to Feed!"
    name = @prompt.ask("Whats your name? ")
    while name == nil
      puts "Please enter a valid name."
      name = @prompt.ask("Whats your name? ")
    end
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
    else
      find_recipe
    end
  end

  #   prompts user to select a recipe from recipe book
  #   displays content of selected recipe
  def select_recipe_from_book(recipes)
    if recipes.length == 0
      puts "You haven't saved any recipes."
      choose_option
    else
      options = [recipes, "Delete a recipe", "Back"]
      selection = @prompt.select("Your recipe book", (options))
      if selection == "Delete a recipe"
        select_recipe_to_delete(recipes)
      elsif selection == "Back"
        choose_option
      else
        @selected_rec = @user.recipes.find { |recipe| recipe.title == selection }
        puts @selected_rec.content
        choose_option
      end
    end
  end

  def select_recipe_to_delete(recipes)
    delete_options = [recipes, "Back"]
    ans = @prompt.select("Select a recipe to delete", (delete_options))
    if ans == "Back"
      select_recipe_from_book(@user.view_recipe_book)
    else
      delete_me = @user.recipes.find { |recipe| recipe.title == ans }
      @user.delete_recipe_from_book(delete_me)
      select_recipe_from_book(@user.view_recipe_book)
    end
  end

#   prompts user for search term and gets search term
  def search_ingredient
    search_term = @prompt.ask("Please enter ingredient name to search recipes: ")
    while search_term == nil
      puts "Please enter a valid search term."
      search_term = @prompt.ask("Please enter ingredient name to search recipes: ")
    end
    @ing = search_term.downcase
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

  #   prompts user to select a recipe from list of search results
  #   displays content of selected recipe
  def select_recipe_from_search(recipes)
    selection = @prompt.select("Please select a recipe:", (recipes))
    @selected_rec = recipe_instances.find { |recipe| recipe.title == selection }
    puts @selected_rec.content
  end

#   Ask usr if they want to save
#   Create new user recipe if yes
  def save?
    ans = @prompt.select("Would you like to save this #{@selected_rec.title} recipe to your recipe book?", %w(Yes No))
    if ans == "Yes"
      @user.save_recipe(@selected_rec)
    end
    choose_option
  end

#   asks user if they want to search again
  def choose_option
    options = ["View recipe book", "Search by ingredient", "Quit app"]
    answer = @prompt.select("Choose an option:", (options))
    if answer == "View recipe book"
      user_recipes = @user.view_recipe_book
      select_recipe_from_book(user_recipes)
    elsif answer == "Search by ingredient"
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
    # find_recipe
  end

end
