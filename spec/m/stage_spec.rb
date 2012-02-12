# -*- coding: utf-8 -*-
root = File.join(File.dirname(__FILE__), "..", "..")
$LOAD_PATH.unshift File.join(root, 'lib')

require "c/app_controller"
require "m/stage"
require "rspec"

describe Stage do
  before do
    @stage = Stage.new(WINDOW_WIDTH,WINDOW_HEIGHT)
  end

  it "左上の座標が{10,10}のこと" do
    @stage.min_x.should == 10
    @stage.min_y.should == 10
  end

  it "右下の座標が{ウィンドウの幅 - 10, ウィンドウの高さ - 10}なこと" do
    @stage.max_x.should == WINDOW_WIDTH - 10
    @stage.max_y.should == WINDOW_HEIGHT - 10
  end

  describe "#include" do
    before do
      @center_point = {x: WINDOW_WIDTH / 2, y: WINDOW_HEIGHT / 2}
    end

    it "左上にはみ出しているものに対してきちんとinclude判定ができること" do
      @stage.should_not be_include({ min: {x: @stage.min_x, y: @stage.min_y},
                                     max: {x: @center_point[:x], y: @center_point[:y]} })
      @stage.should be_include({ min: {x: @stage.min_x + 1, y: @stage.min_y + 1},
                                 max: {x: @center_point[:x], y: @center_point[:y]} })
    end

    it "左にはみ出しているものに対してきちんとinclude判定ができること" do
      @stage.should_not be_include({ min: {x: @stage.min_x, y: @center_point[:y] - 1}, max: @center_point})
      @stage.should be_include({ min: {x: @stage.min_x + 1, y: @center_point[:y] - 1}, max: @center_point})
    end

    it "左下にはみ出しているものに対してきちんとinclude判定ができること" do
      @stage.should_not be_include({ min: {x: @stage.min_x, y: @center_point[:y]},
                                     max: {x: @center_point[:x], y: @stage.max_y} })
      @stage.should be_include({ min: {x: @stage.min_x + 1, y: @center_point[:y]},
                                 max: {x: @center_point[:x], y: @stage.max_y - 1} })
    end

    it "下にはみ出しているものに対してきちんとinclude判定ができること" do
      @stage.should_not be_include({ min: {x: @center_point[:x] - 1, y: @center_point[:y]},
                                     max: {x: @center_point[:x] + 1, y: @stage.max_y} })
      @stage.should be_include({ min: {x: @center_point[:x] - 1, y: @center_point[:y]},
                                 max: {x: @center_point[:x] + 1, y: @stage.max_y - 1} })
    end

    it "右下にはみ出しているものに対してきちんとinclude判定ができること" do
      @stage.should_not be_include({ min: {x: @center_point[:x], y: @center_point[:y]},
                                     max: {x: @stage.max_x, y: @stage.max_y} })
      @stage.should be_include({ min: {x: @center_point[:x], y: @center_point[:y]},
                                 max: {x: @stage.max_x - 1, y: @stage.max_y - 1} })
    end

    it "右にはみ出しているものに対してきちんとinclude判定ができること" do
      @stage.should_not be_include({ min: {x: @center_point[:x], y: @center_point[:y] - 1},
                                     max: {x: @stage.max_x, y: @center_point[:y] + 1} })
      @stage.should be_include({ min: {x: @center_point[:x], y: @center_point[:y] - 1},
                                 max: {x:  @stage.max_x - 1, y: @center_point[:y] + 1} })
    end

    it "右上にはみ出しているものに対してきちんとinclude判定ができること" do
      @stage.should_not be_include({ min: {x: @center_point[:x], y: @stage.min_y},
                                     max: {x: @stage.max_x, y: @center_point[:y]} })
      @stage.should be_include({ min: {x: @center_point[:x], y: @stage.min_y + 1},
                                 max: {x: @stage.max_x - 1, y: @center_point[:y]} })
    end

    it "上にはみ出しているものに対してきちんとinclude判定ができること" do
      @stage.should_not be_include({ min: {x: @center_point[:x] - 1, y: @stage.min_y},
                                     max: {x: @center_point[:x] + 1, y: @center_point[:y]} })
      @stage.should be_include({ min: {x: @center_point[:x] - 1, y: @stage.min_y + 1},
                                 max: {x: @center_point[:x] + 1, y: @center_point[:y]} })
    end
  end
end
