require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"

require_relative './lib/cookbook'
require_relative './lib/recipe'

csv_file   = File.join(__dir__, './lib/recipes.csv')
cookbook   = Cookbook.new(csv_file)

# Allows ngrok to give you external viewable url
set :bind, "0.0.0.0"

# Load all recipes
get "/" do
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
  redirect to('/')
end

# use Params to get information from form and pass to cookbook/ recipe methods.
post "/recipes" do
  name = params['name']
  description = params['description']
  rating = params['rating']
  recipe = Recipe.new({name: name, description: description, rating: "(#{rating} / 5)"})
  cookbook.create(recipe)
  redirect to('/')
end

# There is no specific view for the below call.
get "/team/:username" do
  puts params[:username]
  "The username is #{params[:username]}"
end
