# -*- coding: utf-8 -*-
root = File.join(File.dirname(__FILE__), "..")
$LOAD_PATH.unshift File.join(root, 'lib')

require "util"
require "rspec"

describe Util do

  before do
    @window_width = 640
    @window_height = 400
  end

  describe "#modelpoint_to_viewpoint" do
    it "左上の座標は{-1.0(float),1(float)} に変換される" do
      Util.modelpoint_to_viewpoint(@window_width, @window_height, {x: 0, y: 0}).
        should == {x: -1.0, y: 1.0}
    end

    it "右上の座標は{1.0,1.0}に変換される" do
      Util.modelpoint_to_viewpoint(@window_width, @window_height, {x: @window_width, y: 0}).
        should == {x: 1.0, y: 1.0}
    end

    it "左下の座標は{-1.0, -1,0}に変換される" do
      Util.modelpoint_to_viewpoint(@window_width, @window_height, {x: 0, y: @window_height}).
        should == {x: -1.0, y: -1.0}
    end

    it "右下の座標は{1.0, -1,0}に変換される" do
      Util.modelpoint_to_viewpoint(@window_width, @window_height, {x: @window_width, y: @window_height}).
        should == {x: 1.0, y: -1.0}
    end

    it "真ん中の座標は{0.0,0.0}に変換される" do
      Util.modelpoint_to_viewpoint(@window_width, @window_height, {x: @window_width/2, y: @window_height/2}).
        should == {x: 0.0, y: -0.0}
    end

    it "右上ボックスの真ん中の座標は{0.5, 0.5}に変換される" do
      x = @window_width * 3 / 4
      y = @window_height / 4
      Util.modelpoint_to_viewpoint(@window_width, @window_height, {x: x, y: y}).
        should == {x: 0.5, y: 0.5}
    end
  end
end
