class CLI

  def initialize
   @prompt = TTY::Prompt.new
 end

 # ask_name
 #  prompts user for name
    # adds or creates user in db
  def find_or_create_user
    puts "Welcome to Feed!"
    name = @prompt.ask("Whats your name? ")
    @user = User.find_or_create_by(name: name)
  end

  def greet
      puts "Hi #{@user.name},"
  end

  #   prompt user for search term get search term
  def search_recipes
    @ing = @prompt.ask("Please enter ingredient name to search recipes: ")
  end

  # def another_search
  #   @ing = @prompt.ask("Please enter ingredient name to search recipes: ")
  # end


  #   return relevant recipes based on search term
  def display_search_results
    rec_ing = RecipeIngredient.all.select { |ri| ri.ingredient.name == @ing }
    # while !rec_ing
    #   puts "Ingredient not found, please try again."
    #   search_again
    # end
    @rec = rec_ing.map { |ri| ri.recipe }
    @rec_titles = @rec.map { |r| r.title }
  end

  #   if no ingredient found, prompts again

  # select a recipe and display content
  def select_and_show_recipe
    selection = @prompt.select("Please select a recipe:", (@rec_titles))
    selected_rec = @rec.find { |recipe| recipe.title == selection }
    puts selected_rec.content
    # binding.pry
    # "eof"
  end

  def search_again
    search_recipes
    display_search_results
    select_and_show_recipe
    search_again?
  end

  def search_again?
    answer = @prompt.yes?("Would you like to search another ingredient?")
    if answer
      search_again
    else
      puts "Thanks for using Feed. See you next time!"
    end
  end

  def run
    find_or_create_user
    greet
    search_recipes
    display_search_results
    select_and_show_recipe
    search_again?
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
