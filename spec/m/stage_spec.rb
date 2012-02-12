# -*- coding: utf-8 -*-
root = File.join(File.dirname(__FILE__), "..", "..")
$LOAD_PATH.unshift File.join(root, 'lib')

require "c/app_controller"
require "m/stage"
require "rspec"

describe Stage, "初期化時に" do
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
end
