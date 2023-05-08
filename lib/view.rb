# Where information is displayed to the user.
# User does not directly call the methods, just uses interface provided here.
# Interface to call methods on controller to either prompt input
# These methods are called in controller dictate what service/api method to call.

class View
  def display_list(recipes)
    puts "\n---------Recipes-----------\n"
    recipes.each_with_index do |recipe, i|
      done = recipe.done? ? "[X]" : "[]"
      if !recipe.rating
        puts "#{done} #{i + 1} - #{recipe.name}: #{recipe.description}"
      else
        puts "#{done} #{i + 1} - #{recipe.name}: #{recipe.rating}"
      end
    end
    puts "\n---------------------------\n"
  end

  def suggest_recipe
    puts ''
    puts "Add a recipe name 👇\n ------------------ \n  "
    gets.chomp
  end

  def add_rating
    puts ''
    puts "Add a rating for this recipe 👇\n ------------------ \n  "
    gets.chomp
  end

  def ingredient_ask
    puts ''
    puts "What ingredient would you like a recipe for?\n ------------------ \n  "
    gets.chomp
  end

  def suggest_description
    puts ''
    puts "Add a description 👇\n ------------------ \n "
    gets.chomp
  end

  def select_index
    puts "What recipe number? \n ------------------ \n "
    gets.chomp.to_i - 1
  end

  def import_selected(recipe)
    puts "Importing '#{recipe.name}' ⏲️ ... press any key to continue... \n ------------------ \n "
    gets.chomp.to_i - 1
  end
end
