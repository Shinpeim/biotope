# -*- coding: utf-8 -*-
root = File.join(File.dirname(__FILE__), "..", "..")
$LOAD_PATH.unshift File.join(root, 'lib')

require File.join(File.dirname(__FILE__), "..", "spec_helper")
require "c/app_controller"
require "m/stage"
require "m/grass"

describe Grass do
  before do
    @stage = Stage.new(WINDOW_WIDTH,WINDOW_HEIGHT)
  end

  it "stageに入ってなかったらエラーになること" do
    lambda{Grass.new(@stage, {x: 5, y: 5}, 0)}.should raise_error
  end

  it "stageに入っていれば問題なくnewできること" do
    lambda{Grass.new(@stage, {x: 11, y: 11}, 0)}.should_not raise_error
  end

  it "養分が10であること" do
    Grass.new(@stage, {x: 11, y: 11}, 0).nutriment.should == 10
  end

  describe "xに20, yに30を与えた場合" do
    before do
      @grass = Grass.new(@stage, {x: 20, y: 30}, 0)
    end

    it "min_x が20なこと" do
      @grass.min_x.should == 20
    end

    it "min_y が20なこと" do
      @grass.min_y.should == 30
    end

    it "max_x が20 + WIDTHなこと" do
      @grass.max_x.should == 20 + UNIT_WIDTH
    end

    it "max_y が30 + HEIGHTなこと" do
      @grass.max_y.should == 30 + UNIT_HEIGHT
    end

    it "動かないこと" do
      before_point = {min: {x: @grass.min_x, y: @grass.min_y},
                      max: {x: @grass.max_x, y: @grass.max_y} }
      @grass.move
      after_point = {min: {x: @grass.min_x, y: @grass.min_y},
                     max: {x: @grass.max_x, y: @grass.max_y} }
      before_point.should == after_point
    end

  end
end
