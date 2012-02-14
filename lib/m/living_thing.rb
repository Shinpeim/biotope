class LivingThing

  public
  attr_reader :width, :height, :nutriment, :min_x, :min_y, :max_x, :max_y, :direction, :life_point

  def initialize(stage, position, move_unit_per_frame)
    @stage = stage

    @min_x = position[:x]
    @min_y = position[:y]
    @max_x = position[:x] + self.class::WIDTH
    @max_y = position[:y] + self.class::HEIGHT
    @nutriment = self.class::INITIAL_NUTRIMENT
    @life_point = self.class::INITIAL_LIFE_POINT
    @width = self.class::WIDTH
    @height = self.class::HEIGHT

    @direction = DIRECTIONS[rand(DIRECTIONS.size)]

    @move_unit_per_frame = move_unit_per_frame
    @go_straight_to = 70 + rand(50)

    unless @stage.include?(min: {x: @min_x, y: @min_y}, max: {x: @max_x, y: @max_y})
        raise ArgumentError "grass must be included in stage"
    end
  end

  def move
    raise "can't move when dead" if dead?
    case @direction
    when :top
      @min_y = @min_y - @move_unit_per_frame
      @max_y = @max_y - @move_unit_per_frame
    when :bottom
      @min_y = @min_y + @move_unit_per_frame
      @max_y = @max_y + @move_unit_per_frame
    when :left
      @min_x = @min_x - @move_unit_per_frame
      @max_x = @max_x - @move_unit_per_frame
    when :right
      @min_x = @min_x + @move_unit_per_frame
      @max_x = @max_x + @move_unit_per_frame
    end
    @go_straight_to -= @move_unit_per_frame

    if @go_straight_to < 0
      turn
    end

    @life_point -= 1

    unless @stage.include?({min: {x: @min_x, y: @min_y}, max: {x: @max_x, y: @max_y} })
      turn
    end
  end

  def dead?
    @life_point <= 0
  end

  private
  def demove
    case @direction
    when :top
      @min_y = @min_y + @move_unit_per_frame
      @max_y = @max_y + @move_unit_per_frame
    when :bottom
      @min_y = @min_y - @move_unit_per_frame
      @max_y = @max_y - @move_unit_per_frame
    when :left
      @min_x = @min_x + @move_unit_per_frame
      @max_x = @max_x + @move_unit_per_frame
    when :right
      @min_x = @min_x - @move_unit_per_frame
      @max_x = @max_x - @move_unit_per_frame
    end
    @life_point += 1
  end

  def turn
    demove
    @direction = DIRECTIONS.reject{|item|item == @direction}.fetch(rand(DIRECTIONS.size - 1))
    @go_straight_to = 70 + rand(50)
    move
  end


end
