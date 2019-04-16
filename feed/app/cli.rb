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
      puts "Hi #{@user.name},"
  end

#   prompts user for search term and gets search term
  def search_ingredient
    @ing = @prompt.ask("Please enter ingredient name to search recipes: ")
  end

#   selects all recipe ingredients matching search term
  def recipe_ingredients
    RecipeIngredient.all.select { |ri| ri.ingredient.name == @ing }
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
    @rec = rec_ing.map { |ri| ri.recipe }
    @rec_titles = @rec.map { |r| r.title }
    select_and_show_recipe
  end

  #   prompts user to select a recipe fo list
  #   displays content of selected recipe
    def select_and_show_recipe
      selection = @prompt.select("Please select a recipe:", (@rec_titles))
      selected_rec = @rec.find { |recipe| recipe.title == selection }
      puts selected_rec.content
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
    search_again?
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
