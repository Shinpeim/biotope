# -*- coding: utf-8 -*-
require "opengl";
require "m/stage"
require "v/stage"
require "m/grass"
require "v/grass"
require "m/herbivore"
require "v/herbivore"
require "m/carnivore"
require "v/carnivore"
require "m/quad_tree_space"

WINDOW_WIDTH  = 600
WINDOW_HEIGHT = 400

GRASS_NUM = 60
HERBIVORE_NUM = 20
CARNIVORE_NUM = 5

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
    @frame += 1
    time = Time.now
    current_time = time.to_f

    if current_time - @last_time > 1
      p "#{@frame - @last_frame} fps"
      p "#{@living_things.size} living_things"
      @last_time = current_time
      @last_frame = @frame
    end

    # move
    @quad_tree_space.clear
    @living_things.each do |thing|
      thing[:model].move
      thing[:in][:depth],thing[:in][:morton] = @quad_tree_space.register(thing[:model])
    end

    #衝突判定
    conflicted = []
    herbivores = @living_things.select{|t| t[:model].class == Herbivore}
    carnivores = @living_things.select{|t| t[:model].class == Carnivore}
    grasses    = @living_things.select{|t| t[:model].class == Grass}
    herbivores.each do |h|
      grasses.each do |g|
        if h[:model].conflict?(g[:model])
          conflicted.push [h[:model], g[:model]]
        end
      end
    end
    carnivores.each do |c|
      herbivores.each do |h|
        if c[:model].conflict?(h[:model])
          conflicted.push [c[:model], h[:model]]
        end
      end
    end

    #捕食
    deleted = {}
    conflicted.each do |pair|
      next if deleted[pair[0]] || deleted[pair[1]]
      ret = pair[0].eat(pair[1])
      @living_things.delete_if{|t| t[:model].eql? pair[1]} if ret
      deleted[pair[1]] = true if ret
    end

    #死んだり生まれたり
    new_living_things = []
    @living_things.each do |thing|
      if thing[:model].dead?
        dead = true
        grasses = thing[:model].to_grasses
        grasses.each do |grass|
          new_living_things.push(model: grass, view: GrassView.new(grass), in: {})
        end
      end
      children_model = thing[:model].breed
      children = children_model.map do |model|
        view = Object.const_get(model.class.to_s + "View").new(model)
        {:model => model, :view => view, :in => {}}
      end
      new_living_things.concat children
    end
    @living_things.delete_if{|thing| thing[:model].dead?}
    @living_things.concat new_living_things

    Glut.glutPostRedisplay
    Glut.glutTimerFunc(1,method(:update).to_proc,nil)
  end

  def initialize
    stage_model = Stage.new(WINDOW_WIDTH, WINDOW_HEIGHT)
    @stage = {
      :model => stage_model,
       :view => StageView.new(stage_model),
    }

    @living_things = init_living_things(stage_model)
    space = {:min => {:x => stage_model.min_x, :y => stage_model.min_y},
             :max => {:x => stage_model.max_x, :y => stage_model.max_y}}
    @quad_tree_space = QuadTreeSpace.new(space,3)

    @frame = 0
    @last_frame = 0
    @last_time = Time.now.to_f

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
      living_things.push ({:model => model, :view => GrassView.new(model), :in => {}})
    end

    HERBIVORE_NUM.times do
      possible_x = {min: (stage_model.min_x + 1), max: (stage_model.max_x - Herbivore::WIDTH  - 1)}
      possible_y = {min: (stage_model.min_y + 1), max: (stage_model.max_y - Herbivore::HEIGHT - 1)}
      x = rand(possible_x[:max] - possible_x[:min]) + possible_x[:min]
      y = rand(possible_y[:max] - possible_y[:min]) + possible_y[:min]
      model =  Herbivore.new(stage_model, {x: x, y: y})
      living_things.push ({:model => model, :view => HerbivoreView.new(model), :in => {}})
    end

    CARNIVORE_NUM.times do
      possible_x = {min: (stage_model.min_x + 1), max: (stage_model.max_x - Carnivore::WIDTH  - 1)}
      possible_y = {min: (stage_model.min_y + 1), max: (stage_model.max_y - Carnivore::HEIGHT - 1)}
      x = rand(possible_x[:max] - possible_x[:min]) + possible_x[:min]
      y = rand(possible_y[:max] - possible_y[:min]) + possible_y[:min]
      model =  Carnivore.new(stage_model, {x: x, y: y})
      living_things.push ({:model => model, :view => CarnivoreView.new(model), :in => {}})
    end

    return living_things
  end
end
