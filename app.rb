require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"

require_relative "./lib/cookbook"
require_relative "./lib/recipe"
require_relative "./lib/scraper"

csv_file = File.join(__dir__, "./lib/recipes.csv")
cookbook = Cookbook.new(csv_file)
scraper = Scraper.new(cookbook)

# Allows ngrok to give you external viewable url
set :bind, "0.0.0.0"

# Load all recipes
get "/" do
  cookbook.lookup_recipes.clear
  @recipes = cookbook.all
  erb :index
end

# How to use instance variables to display in the about view (not used here)
get "/about" do
  @usernames = ["ssaunier", "Papillard"]
  erb :about
end

# Need to instantiate the new view so you can link to it
get "/new" do
  erb :new
end

get "/find" do
  @lookup = cookbook.lookup.slice(0, 5)
  erb :find
end

# Good troubleshooting here. Also, how to get params from view
post "/destroy" do
  # puts "params: #{params.inspect}"
  # item_index = params['index'].to_i
  # puts "index: #{item_index.inspect}"
  # Output: params: {"index"=>"0"}
  # output: index: 0
  index = params[index].to_i - 1
  cookbook.destroy(index)
  # erb :destroy
  redirect to("/")
end

post "/scrape" do
  ingredient = params["ingredient"]
  scraper.scrape(ingredient)
  redirect to("/find")
end

# use Params to get information from form and pass to cookbook/ recipe methods.
post "/recipes" do
  # puts ">>>>>>>>>>>>>>>> #{cookbook.lookup_recipes}"
  if params['index']
    recipe = cookbook.find(params['index'].to_i)
  else
    name = params["name"]
    description = params["description"]
    rating = params["rating"]
    recipe = Recipe.new({ name: name, description: description, rating: "(#{rating} / 5)" })
  end
  cookbook.create(recipe)
  redirect to("/")
end

# There is no specific view for the below call.
get "/team/:username" do
  puts params[:username]
  "The username is #{params[:username]}"
end
