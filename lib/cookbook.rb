require "csv"
require_relative 'recipe'

# A class that acts like an api. Writes/reads to a CSV "database"
class Cookbook
  attr_accessor :lookup_recipes, :recipes

  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = load_existing_recipes
    @lookup_recipes = []
  end

  def load_existing_recipes
    arr = []
    # Takes all created recipes, adds to the cookbook instance and you can load that instance again
    # store that into @recipes
    # row => ["Crumpets", "Crumpets description"]
    CSV.foreach(@csv_file_path) do |row|
      recipe = Recipe.new({ name: row[0], description: row[1], rating: row[2] })
      arr << recipe
    end
    return arr
  end

  def all
    @recipes
  end

  def lookup
    @lookup_recipes
  end

  def find(index)
    @lookup_recipes[index]
  end

  def find_saved(index)
    @recipes[index]
  end

  def create(recipe)
    # Creates recipe
    # adds to cookbook
    @recipes << recipe
    # Stores the recipes in a csv
    CSV.open(@csv_file_path, "wb") do |csv|
      @recipes.each { |r| csv << [r.name, r.description, r.rating] }
    end
  end

  def create_lookup(recipe)
    # Creates recipe
    # adds to cookbook
    @lookup_recipes << recipe
    # Stores the recipes in a csv
    # CSV.open(@csv_file_path, "wb") do |csv|
    #   @recipes.each { |r| csv << [r.name, r.description] }
    # end
  end

  def destroy(index)
    # Removes recipe from cookbook
    @recipes.delete_at(index)
    # re-stores the recipes to the csv minus the deleted one
    CSV.open(@csv_file_path, "wb") do |csv|
      @recipes.each { |r| csv << [r.name, r.description, r.rating] }
    end
  end
end
