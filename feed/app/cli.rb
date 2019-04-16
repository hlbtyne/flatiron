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

  # Search
  #   prompts user for search term
  #   returns top 3 recipes
  #   if no ingredient found, prompts again
  def search_recipes
    puts "Hi #{@user.name},"
    ing = @prompt.ask("Please enter ingredient name to search recipes: ")
    
    rec_ing = RecipeIngredient.all.select { |ri| ri.ingredient.name == ing }
    @rec = rec_ing.map { |ri| ri.recipe }
    @rec_titles = @rec.map { |r| r.title }
    # binding.pry
    # 'eof'
  end

  # select_recipe
  #   display full recipe
  def select_and_show_recipe
    selection = @prompt.select("Please select a recipe:", (@rec_titles))
    selected_rec = @rec.find { |recipe| recipe.title == selection }
    puts selected_rec.content
    # binding.pry
    # "eof"
  end

  def run
    find_or_create_user
    search_recipes
    select_and_show_recipe
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
