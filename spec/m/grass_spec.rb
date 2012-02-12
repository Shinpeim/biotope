# -*- coding: utf-8 -*-
root = File.join(File.dirname(__FILE__), "..", "..")
$LOAD_PATH.unshift File.join(root, 'lib')

require "c/app_controller"
require "m/stage"
require "m/grass"
require "rspec"

describe Grass do
  before do
    @stage = Stage.new(WINDOW_WIDTH,WINDOW_HEIGHT)
  end

  it "stageに入ってなかったらエラーになること" do
    lambda{Grass.new(@stage, {x: 5, y: 5})}.should raise_error
  end

  it "stageに入っていれば問題なくnewできること" do
    lambda{Grass.new(@stage, {x: 11, y: 11})}.should_not raise_error
  end

  it "養分を取得できること" do
    Grass.new(@stage, {x: 11, y: 11}).nutriment.should == GRASS::NUTRIMENT
  end

  describe "xに20, yに30を与えた場合" do
    before do
      @grass = Grass.new(@stage, {x: 20, y: 30})
    end

    it "min_x が20なこと" do
      @grass.min_x.should == 20
    end

    it "min_y が20なこと" do
      @grass.min_y.should == 30
    end

    it "max_x が20 + WIDTHなこと" do
      @grass.max_x.should == 20 + GRASS::WIDTH
    end

    it "max_y が30 + HEIGHTなこと" do
      @grass.max_y.should == 30 + GRASS::HEIGHT
    end

  end
end