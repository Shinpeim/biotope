class Grass

  attr_reader :nutriment, :min_x, :min_y, :max_x, :max_y

  def initialize(stage, position)
    @stage = stage

    @min_x = position[:x]
    @min_y = position[:y]
    @max_x = position[:x] + GRASS::WIDTH
    @max_y = position[:y] + GRASS::HEIGHT

    @nutriment = GRASS::NUTRIMENT

    unless @stage.include?(min: {x: @min_x, y: @min_y}, max: {x: @max_x, y: @max_y})
        raise ArgumentError "grass must be included in stage"
    end
  end

end

module GRASS
  WIDTH = 10
  HEIGHT = 10

  NUTRIMENT = 10
end
