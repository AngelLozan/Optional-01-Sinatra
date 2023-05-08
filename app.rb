require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"

get "/" do
  erb :index
end

get "/about" do
  erb :about
end
