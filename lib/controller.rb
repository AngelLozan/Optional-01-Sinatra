require "csv"
require "pry-byebug"
require "nokogiri"
require "open-uri"
require_relative 'view'
require_relative 'recipe'
require_relative 'cookbook'
# file = "strawberry.html"
# doc = Nokogiri::HTML.parse(File.open(file), nil, "utf-8")


# path = './lib/recipes.csv'
# cookbook = Cookbook.new(path)

# Get data from an instance of cookbook and sends to view.
# Either calls API methods (Cookbook class methods) or calls services from self to make/delete recipes.
class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new # Instance of what we can see (collection of methods)
  end

  def list
    # list all recipes in that cookbook instance
    # @cookbook.all.empty? ? @cookbook.load_existing_recipes && recipes = @cookbook.all : recipes = @cookbook.all
    recipes = @cookbook.all
    # display recipies to users
    @view.display_list(recipes)
  end

  def add
    # adds new recipe to cookbook instance through view with gets and puts
    requested_name = @view.suggest_recipe
    requested_desc = @view.suggest_description
    requested_rating = @view.add_rating
    recipe = Recipe.new({ name: requested_name, description: requested_desc, rating: "(#{requested_rating} / 5)" })
    @cookbook.create(recipe)
  end


  def remove
    # remove recipe from cookbook instance
    # FE display list to the user
    recipes = @cookbook.all
    @view.display_list(recipes)
    # FE ask which index to remove
    index = @view.select_index
    # BE Remove that recipe
    # recipe_to_remove = @cookbook.find(index)
    @cookbook.destroy(index)
    # FE re-display list
    recipes = @cookbook.all
    @view.display_list(recipes)
  end

  def search
    term = @view.ingredient_ask
    import(term)
  end

  def import(ingredient)
    # Scrapes page with search param (ex: https://www.allrecipes.com/search?q=strawberry)
    url = "https://www.allrecipes.com/search?q=#{ingredient}"
    doc = Nokogiri::HTML.parse(URI.open(url).read, nil, "utf-8")

    # doc.search('.card__title').each do |el|
    #   recipe = Recipe.new({ name: el.text.strip, description: "Delicious #{el.text.strip}" })
    #   @cookbook.create_lookup(recipe)
    # end

    doc.search('.card__content').each do |recipe|
      name = recipe.css('.card__title').text.strip
      stars = recipe.css('.mntl-recipe-star-rating .icon')
      halves = stars.count { |star| star['class'].include?('half') }
      rating = (5 - halves) + (0.5 * halves)
      recipe = Recipe.new({ name: name, rating: "(#{rating} / 5)", description: "Delicious #{name}" })
      @cookbook.create_lookup(recipe)
    end

    # binding.pry
    # Creates recipe instance for 5 results and pushes 5 results to array
    # Use display_list to display
    arr = @cookbook.lookup.slice(0,5)
    @view.display_list(arr)
    # Ask which recipe from lookup to add
    import_index = @view.select_index
    # Find recipe in lookup arr in cookbook and save it to recipes
    recipe_to_save = @cookbook.find(import_index)
    choice = @view.import_selected(recipe_to_save)
    @cookbook.create(recipe_to_save)
  end


  def make_done
    recipes = @cookbook.all
    @view.display_list(recipes)
    index = @view.select_index
    recipe = @cookbook.find_saved(index)
    recipe.mark_done!
    rating = @view.add_rating
    recipe.rate(rating)
  end
end

# controller = Controller.new(cookbook)
# controller.import("blueberry")
