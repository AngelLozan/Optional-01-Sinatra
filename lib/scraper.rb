require 'nokogiri'
require 'open-uri'
require_relative 'cookbook'

class Scraper

  def initialize(cookbook)
    @cookbook = cookbook
  end

  def scrape(ingredient)
    url = "https://www.allrecipes.com/search?q=#{ingredient}"
    doc = Nokogiri::HTML.parse(URI.open(url).read, nil, "utf-8")

    # doc.search('.card__title').each do |el|
    #   recipe = Recipe.new({ name: el.text.strip, description: "Delicious #{el.text.strip}" })
    #   @cookbook.create_lookup(recipe)
    # end

    doc.search(".card__content").each do |recipe|
      name = recipe.css(".card__title").text.strip
      stars = recipe.css(".mntl-recipe-star-rating .icon")
      halves = stars.count { |star| star["class"].include?("half") }
      # prep_url = recipe.attribute("href").value
      # prep_doc = Nokogiri::HTML.parse(URI.open(prep_url).read, nil, "utf-8")
      # prep_time = prep_doc.search(".mntl-recipe-details__value").first.text.strip
      rating = (5 - halves) + (0.5 * halves)
      recipe = Recipe.new({ name: name, rating: "(#{rating} / 5)", description: "Delicious #{name}" }) # can add prep_time here
      @cookbook.create_lookup(recipe)
    end
  end
end
