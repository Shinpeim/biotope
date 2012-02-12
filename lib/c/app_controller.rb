require "opengl";
require "m/stage"
require "v/stage"

require "m/grass"
require "v/grass"

WINDOW_WIDTH  = 640
WINDOW_HEIGHT = 400

UNIT_WIDTH  = 8
UNIT_HEIGHT = 8

GRASS_NUM = 50

DIRECTIONS = [:top, :right, :down, :left]

class AppController

  def display
    Gl.glClear(GL_COLOR_BUFFER_BIT)

    @stage[:view].draw

    @grasses.each do |grass|
      grass[:view].draw
    end

    Gl.glFlush
  end

  def resize(w,h)
    Glut.glutReshapeWindow(WINDOW_WIDTH, WINDOW_HEIGHT)
  end

  def initialize
    stage_model = Stage.new(WINDOW_WIDTH, WINDOW_HEIGHT)
    @stage = {
      :model => stage_model,
      :view => StageView.new(stage_model),
    }

    @grasses = []
    GRASS_NUM.times do
      possible_x = {min: (stage_model.min_x + 1), max: (stage_model.max_x - GRASS::WIDTH  - 1)}
      possible_y = {min: (stage_model.min_y + 1), max: (stage_model.max_y - GRASS::HEIGHT - 1)}

      x = rand(possible_x[:max] - possible_x[:min]) + possible_x[:min]
      y = rand(possible_y[:max] - possible_y[:min]) + possible_y[:min]
      grass_model =  Grass.new(stage_model, x: x, y: y)
      @grasses.push ({
        :model => grass_model,
        :view => GrassView.new(grass_model),
      })
    end


    Glut.glutInitWindowPosition(100, 100)
    Glut.glutInitWindowSize(WINDOW_WIDTH, WINDOW_HEIGHT)
    Glut.glutInit
    Glut.glutInitDisplayMode( GLUT::GLUT_RGB )

    Glut.glutCreateWindow("Biotope")
    Glut.glutDisplayFunc(method(:display).to_proc)
    Glut.glutReshapeFunc(method(:resize).to_proc)

    Gl.glClearColor(0.0, 0.0, 0.0, 1.0)
  end

  def run
    Glut.glutMainLoop
  end

end
