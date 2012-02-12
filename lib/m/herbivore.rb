require "m/living_thing.rb"
class Herbivore < LivingThing

  def width
    UNIT_WIDTH
  end

  def height
    UNIT_HEIGHT
  end

  def nutriment
    10 * 4
  end

end
