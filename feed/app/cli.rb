class CLI

  def initialize
   @prompt = TTY::Prompt.new
 end

 #   Gets user's name
   def get_user_name
     name = @prompt.ask("What's your name? ")
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
      puts "Please enter a valid name."
      name = get_user_name
    end
    @user = User.find_or_create_by(name: name)
    @id = @user.id
  end

#   greets user
  def greet
    puts "Hi #{@user.name}!"
  end

#   asks user what they want to do
 def main_menu
   options = ["View recipe book", "Search by ingredient", "Quit app"]
   answer = @prompt.select("Choose an option:", (options))
   while answer != "Quit app"
     if answer == options[0]
       select_recipe_from_book(@user.view_recipe_book)
     else
       find_recipe
     end
     answer = @prompt.select("Choose an option:", (options))
   end
   puts "Thanks for using Feed. See you next time!"
  end


 #   prompts user for search term and gets search term
   def search_ingredient
     instruction = "Please enter ingredient name to search recipes: "
     search_term = @prompt.ask(instruction)
     while search_term == nil
       puts "Please enter a valid search term."
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
       puts "Sorry, that ingredient's not available."
       search_ingredient
       rec_ing = recipe_ingredients
     end
     select_recipe_from_search(recipe_titles)
   end

   #   prompts user to select a recipe from list of search results
   #   displays content of selected recipe
   def select_recipe_from_search(recipe_titles)
     selection = @prompt.select("Please select a recipe:", (recipe_titles))
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
   end

#   prompts user to select a recipe from recipe book
#   displays content of selected recipe
  def select_recipe_from_book(recipes)
    if recipes.length == 0
      puts "You haven't saved any recipes."
    else
      options = [recipes, "Delete a recipe", "Back"]
      selection = @prompt.select("Your recipe book", (options))
      if selection == "Delete a recipe"
        select_recipe_to_delete(recipes)
      elsif selection == "Back"
        main_menu
      else
        selected_user_rec = User.find(@id).recipes.find { |recipe| recipe.title == selection }
        # binding.pry
        puts selected_user_rec.content
      end
    end
  end

#   Prompts user to select a recipe to delete from their recipe book
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
    # find_recipe
  end

end
