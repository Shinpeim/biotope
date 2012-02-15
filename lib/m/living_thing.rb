class LivingThing

  attr_reader :width, :height, :nutriment, :min_x, :min_y, :max_x, :max_y, :direction, :life_point

  abstract_methods = [:eat]
  abstract_methods.each do |m|
    define_method m do
      raise "abstract method"
    end
  end

  def initialize(stage, position, nutriment = nil)
    @stage = stage

    @min_x = position[:x]
    @min_y = position[:y]
    @max_x = position[:x] + self.class::WIDTH
    @max_y = position[:y] + self.class::HEIGHT
    @nutriment = nutriment || self.class::INITIAL_NUTRIMENT
    @life_point = self.class::INITIAL_LIFE_POINT
    @width = self.class::WIDTH
    @height = self.class::HEIGHT
    @move_unit_per_frame = self.class::MOVE_UNIT_PER_FRAME

    @direction = DIRECTIONS[rand(DIRECTIONS.size)]

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

  def to_grasses
    raise "can't be grasses unless dead" unless dead?
    grass_num = @nutriment / Grass::INITIAL_NUTRIMENT
    mod = @nutriment % Grass::INITIAL_NUTRIMENT

    grasses = []
    grass_num.times do |n|
      nut = Grass::INITIAL_NUTRIMENT
      if mod > 0
        nut += 1
      end

      delta_x = rand(Grass::WIDTH * (n + 2))
      delta_y = rand(Grass::HEIGHT * (n + 2))
      delta_x -= rand(Grass::WIDTH * (n + 1))
      delta_y -= rand(Grass::HEIGHT * (n + 1))
      delta_x = - delta_x if rand(2) == 0
      delta_y = - delta_y if rand(2) == 0
      position = {x: @min_x + delta_x, y: @min_y + delta_y}

      begin
        grasses.push Grass.new(@stage,position,nut)
      rescue
        redo
      end

      mod -= 1
    end
    return grasses
  end

  def conflict?(target)
    (@min_x <= target.max_x) &&
      (@max_x >= target.min_x) &&
      (@min_y <= target.max_y) &&
      (@max_y >= target.min_y)
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
