require "m/living_thing.rb"
class Herbivore < LivingThing

  def width
    UNIT_WIDTH
  end

  def height
    UNIT_HEIGHT
  end

  def initial_nutriment
    INITIAL_NUTRIMENT
  end

  def initial_life_point
    INITIAL_LIFE_POINT
  end

  INITIAL_NUTRIMENT = 10 * 4
  INITIAL_LIFE_POINT = 500
end
