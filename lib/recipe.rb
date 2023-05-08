class Recipe
  attr_reader :name, :description, :rating

  def initialize(args={})
    @name = args[:name]
    @description = args[:description]
    @rating = args[:rating]
    @done = false
  end

  def mark_done!
    @done = true
  end

  def done?
    @done
  end

  def rate(rating)
    @rating = "(#{rating} / 5)"
  end

end
