require "gl"
require "util"
class StageView
  def initialize(model)
    @model = model
  end

  def draw
    model_point = {}
    [:min_x, :min_y, :max_x, :max_y].each do |simbol|
      model_point[simbol] = @model.method(simbol).call
    end

    view_point = {}
    view_point[:min] = Util.modelpoint_to_viewpoint(
      WINDOW_WIDTH,
      WINDOW_HEIGHT,
      {x: model_point[:min_x], y: model_point[:min_y]}
    )
    view_point[:max] = Util.modelpoint_to_viewpoint(
      WINDOW_WIDTH,
      WINDOW_HEIGHT,
      {x: model_point[:max_x], y: model_point[:max_y]}
    )

    # y is reversed
    view_point[:min_y], view_point[:max_y] = view_point[:max_y], view_point[:min_y]
    p view_point

    Gl.glBegin(GL_QUADS);
    Gl.glColor3d(1.0, 1.0, 1.0);
    Gl.glVertex2d(view_point[:min][:x], view_point[:min][:y]);
    Gl.glVertex2d(view_point[:max][:x], view_point[:min][:y]);
    Gl.glVertex2d(view_point[:max][:x], view_point[:max][:y]);
    Gl.glVertex2d(view_point[:min][:x], view_point[:max][:y]);
    Gl.glEnd();
  end
end
