class CLI

  def initialize
   @prompt = TTY::Prompt.new
 end

 #   Gets user's name
   def get_user_name
     name = @prompt.ask("What's your name? ".colorize(:color => :blue))
     name
   end

  def print_title
        puts ''
        puts "*** -- WELCOME TO -- ***"
        puts ''
        sleep(2)
        app_title = Artii::Base.new :font => 'slant'
        puts '-------------------------------------------'
        puts app_title.asciify('Feed').colorize(:color => :green)
        puts '-------------------------------------------'

        app_title
        sleep(2)
  end

 #  asks user for name and finds or creates user in db
  def find_or_create_user
    name = get_user_name
    while name == nil
      puts ''
      puts "*** Please enter a valid name. ***".colorize(:color => :red)
      puts ''
      name = get_user_name
    end
    @user = User.find_or_create_by(name: name)
    @id = @user.id
  end

#   greets user
  def greet
    puts ''
    puts "Hi #{@user.name}!"
    puts ''
  end

#   asks user what they want to do
 def main_menu
   options = ["View recipe book", "Search by ingredient", "Quit app"]
   answer = @prompt.select("Choose an option:".colorize(:color => :blue), (options))
   if answer == options[0]
     select_recipe_from_book(@user.view_recipe_book)
   elsif answer == options[1]
     find_recipe
   elsif answer == options[2]
     puts ''
     puts "Thanks for using Feed. See you next time!".colorize(:color => :blue)
     system exit
   end
end

 #   prompts user for search term and gets search term
   def search_ingredient
     puts ''
     instruction = "Please enter ingredient name to search recipes: ".colorize(:color => :blue)
     search_term = @prompt.ask(instruction)
     while search_term == nil
       puts ''
       puts "*** Please enter a valid search term. ***".colorize(:color => :red)
       puts ''
       search_term = @prompt.ask(instruction)
     end
     @ing = search_term.downcase
   end

 #   selects all recipe ingredients matching search term
   def recipe_ingredients
     RecipeIngredient.all.select { |ri| ri.ingredient.name == @ing }
   end

 #   returns array of recipe instances matching search term
   def recipe_instances
     recipe_ingredients.map { |ri| ri.recipe }
   end

   def recipe_titles
     recipe_instances.map { |r| r.title }
   end

   #   returns relevant recipes based on search term
   #   gives error message if search term has no matches
   def display_search_results
     rec_ing = recipe_ingredients
     while rec_ing.length == 0
       puts ''
       puts "*** Sorry, that ingredient's not available. ***".colorize(:color => :red)
       puts ''
       search_ingredient
       rec_ing = recipe_ingredients
     end
     select_recipe_from_search(recipe_titles)
   end

   #   prompts user to select a recipe from list of search results
   #   displays content of selected recipe
   def select_recipe_from_search(recipe_titles)
     puts ''
     selection = @prompt.select("Please select a recipe:".colorize(:color => :blue), (recipe_titles))
     @selected_rec = recipe_instances.find { |recipe| recipe.title == selection }
     puts ''
     puts @selected_rec.content
   end

 #   Ask usr if they want to save
 #   Create new user recipe if yes
   def save?
     puts ''
     ans = @prompt.select("Would you like to save this #{@selected_rec.title} recipe to your recipe book?".colorize(:color => :blue), %w(Yes No))
     if ans == "Yes"
       @user.save_recipe(@selected_rec)
       puts ''
       main_menu
     end
     puts ''
     main_menu
   end

#   prompts user to select a recipe from recipe book
#   displays content of selected recipe
  def select_recipe_from_book(recipes)
    if recipes.length == 0
      puts ''
      puts "*** You don't have any saved recipes. ***".colorize(:color => :red)
      puts ''
      main_menu
    else
      puts ''
      options = [recipes, "Delete a recipe", "Back"]
      selection = @prompt.select("Your recipe book", (options))
      if selection == "Delete a recipe"
        select_recipe_to_delete(recipes)
      elsif selection == "Back"
        main_menu
      else
        puts ''
        selected_user_rec = User.find(@id).recipes.find { |recipe| recipe.title == selection }
        puts selected_user_rec.content
        puts ''
        main_menu
      end
    end
  end

#   Prompts user to select a recipe to delete from their recipe book
  def select_recipe_to_delete(recipes)
    puts ''
    delete_options = [recipes, "Back"]
    ans = @prompt.select("Select a recipe to delete".colorize(:color => :blue), (delete_options))
    if ans == "Back"
      puts ''
      select_recipe_from_book(@user.view_recipe_book)
    else
      delete_me = User.find(@id).recipes.find { |recipe| recipe.title == ans }
      @user.delete_recipe_from_book(delete_me)
      select_recipe_from_book(@user.view_recipe_book)
    end
  end


  def find_recipe
    search_ingredient
    display_search_results
    save?
  end

  def run
    print_title
    find_or_create_user
    greet
    main_menu
  end

end
