class Util

  def self.modelpoint_to_viewpoint(window_width,window_height,model_point)
    width_unit = 2.0 / window_width.to_f
    height_unit = 2.0 / window_height.to_f

    view_x = model_point[:x] * width_unit - 1.0
    view_y = model_point[:y] * height_unit - 1.0
    view_y = - view_y

    return {x: view_x, y: view_y}
  end

end
