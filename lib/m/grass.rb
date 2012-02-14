require "m/living_thing.rb"
class Grass < LivingThing

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
    1
  end

  INITIAL_NUTRIMENT = 10
end

