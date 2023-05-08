require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"

get "/" do
  @usernames = ["ssaunier", "Papillard"]
  erb :index
end

get "/about" do
  @usernames = ["ssaunier", "Papillard"]
  erb :about
end

get "/team/:username" do
  puts params[:username]
  "The username is #{params[:username]}"
end
