require "gl"
require "util"
require "v/rectangle"

class CarnivoreView

  def initialize(model)
    @model = model
  end

  private
  def color
    return 1.0, 0.0, 0.0
  end

  attr_reader :model

  include Rectangle
end
