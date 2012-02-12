class Stage

  attr_reader :min_x, :min_y, :max_x, :max_y

  def initialize(window_width,window_height)
    wall_width = 10
    @min_x = wall_width
    @min_y = wall_width
    @max_x = window_width - wall_width
    @max_y = window_height - wall_width
  end

  def include?(param)
     @min_x < param[:min][:x] &&
     @min_y < param[:min][:y] &&
     @max_x > param[:max][:x] &&
     @max_y > param[:max][:y]
  end
end
