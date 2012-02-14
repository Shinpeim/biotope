require "opengl";
require "m/stage"
require "v/stage"
require "m/grass"
require "v/grass"
require "m/herbivore"
require "v/herbivore"

WINDOW_WIDTH  = 800
WINDOW_HEIGHT = 600

GRASS_NUM = 80
HERBIVORE_NUM = 40

DIRECTIONS = [:top, :right, :bottom, :left]

class AppController

  def display
    Gl.glClear(GL_COLOR_BUFFER_BIT)

    @stage[:view].draw

    @living_things.each do |living_thing|
      living_thing[:view].draw
    end

    Gl.glFlush
  end

  def resize(w,h)
    Glut.glutReshapeWindow(WINDOW_WIDTH, WINDOW_HEIGHT)
  end

  def update(param)
    new_living_things = []

    @living_things.each do |thing|
      thing[:model].move

      if thing[:model].dead?
        grasses = thing[:model].to_grasses
        grasses.each do |grass|
          new_living_things.push(model: grass, view: GrassView.new(grass))
        end
        @living_things.delete(thing)
      end
    end

    @living_things.concat new_living_things

    Glut.glutPostRedisplay
    Glut.glutTimerFunc(16,method(:update).to_proc,nil)
  end

  def initialize
    stage_model = Stage.new(WINDOW_WIDTH, WINDOW_HEIGHT)
    @stage = {
      :model => stage_model,
      :view => StageView.new(stage_model),
    }

    @living_things = init_living_things(stage_model)

    Glut.glutInitWindowPosition(100, 100)
    Glut.glutInitWindowSize(WINDOW_WIDTH, WINDOW_HEIGHT)
    Glut.glutInit
    Glut.glutInitDisplayMode( GLUT::GLUT_RGB )

    Glut.glutCreateWindow("Biotope")
    Glut.glutDisplayFunc(method(:display).to_proc)
    Glut.glutReshapeFunc(method(:resize).to_proc)
    Glut.glutTimerFunc(16,method(:update).to_proc,nil)

    Gl.glClearColor(0.0, 0.0, 0.0, 1.0)
  end

  def run
    Glut.glutMainLoop
  end

  private
  def init_living_things(stage_model)
    living_things = []

    GRASS_NUM.times do
      possible_x = {min: (stage_model.min_x + 1), max: (stage_model.max_x - Grass::WIDTH  - 1)}
      possible_y = {min: (stage_model.min_y + 1), max: (stage_model.max_y - Grass::HEIGHT - 1)}
      x = rand(possible_x[:max] - possible_x[:min]) + possible_x[:min]
      y = rand(possible_y[:max] - possible_y[:min]) + possible_y[:min]
      model =  Grass.new(stage_model, {x: x, y: y})
      living_things.push ({:model => model, :view => GrassView.new(model)})
    end

    HERBIVORE_NUM.times do
      possible_x = {min: (stage_model.min_x + 1), max: (stage_model.max_x - Herbivore::WIDTH  - 1)}
      possible_y = {min: (stage_model.min_y + 1), max: (stage_model.max_y - Herbivore::HEIGHT - 1)}
      x = rand(possible_x[:max] - possible_x[:min]) + possible_x[:min]
      y = rand(possible_y[:max] - possible_y[:min]) + possible_y[:min]
      model =  Herbivore.new(stage_model, {x: x, y: y})
      living_things.push ({:model => model, :view => HerbivoreView.new(model)})
    end

    return living_things
  end
end
