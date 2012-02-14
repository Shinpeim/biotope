# -*- coding: utf-8 -*-
require "m/living_thing.rb"
class Grass < LivingThing

  def move
    #植物は動かない
  end

  def dead?
    false #植物は死なない
  end

  INITIAL_NUTRIMENT = 10
  INITIAL_LIFE_POINT= 1
  WIDTH = 8
  HEIGHT = 8
  MOVE_UNIT_PER_FRAME = 0
end

