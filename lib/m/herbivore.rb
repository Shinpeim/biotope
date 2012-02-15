require "m/living_thing"
require "m/grass"
class Herbivore < LivingThing

  def eat(target)
    return false if target.class != Grass

    @life_point = INITIAL_LIFE_POINT
    @nutriment += target.nutriment
  end

  WIDTH = 8
  HEIGHT = 8
  INITIAL_NUTRIMENT = 10 * 4
  INITIAL_LIFE_POINT = 500
  MOVE_UNIT_PER_FRAME = 1
end
