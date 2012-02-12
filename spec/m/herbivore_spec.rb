# -*- coding: utf-8 -*-
root = File.join(File.dirname(__FILE__), "..", "..")
$LOAD_PATH.unshift File.join(root, 'lib')

require "c/app_controller"
require "m/stage"
require "m/herbivore"
require "rspec"

describe Herbivore do
  before do
    @stage = Stage.new(WINDOW_WIDTH,WINDOW_HEIGHT)
    @move_unit_per_frame = 1
  end

  it "stageに入ってなかったらエラーになること" do
    lambda{Herbivore.new(@stage, {x: 5, y: 5}, @move_unit_per_frame)}.should raise_error
  end

  it "stageに入っていれば問題なくnewできること" do
    lambda{Herbivore.new(@stage, {x: 11, y: 11}, @move_unit_per_frame)}.should_not raise_error
  end

  it "初期養分が40であること" do
    Herbivore.new(@stage, {x: 11, y: 11}, @move_unit_per_frame).nutriment.should == 40
  end

  describe "xに20, yに30を与えた場合" do
    before do
      @herbivore = Herbivore.new(@stage, {x: 20, y: 30}, @move_unit_per_frame)
    end

    it "min_x が20なこと" do
      @herbivore.min_x.should == 20
    end

    it "min_y が20なこと" do
      @herbivore.min_y.should == 30
    end

    it "max_x が20 + WIDTHなこと" do
      @herbivore.max_x.should == 20 + UNIT_WIDTH
    end

    it "max_y が30 + HEIGHTなこと" do
      @herbivore.max_y.should == 30 + UNIT_HEIGHT
    end

    it "進行方向を持っていること" do
      DIRECTIONS.should be_include @herbivore.direction
    end
  end

  [:top, :left, :down, :right].each do |direction|
    describe direction.to_s + "方向へ進むとき" do
      before do
        begin
          @herbivore = Herbivore.new(@stage, {x: 50, y: 50}, @move_unit_per_frame)
        end until @herbivore.direction == direction
      end

      it "進行方向へ移動単位分動くこと" do
        before_point = {min: {x: @herbivore.min_x, y: @herbivore.min_y},
          max: {x: @herbivore.max_x, y: @herbivore.max_y} }
        @herbivore.move
        after_point = {min: {x: @herbivore.min_x, y: @herbivore.min_y},
          max: {x: @herbivore.max_x, y: @herbivore.max_y} }
        if @herbivore.direction == :top
          before_point[:min][:x].should == after_point[:min][:x]
          before_point[:max][:x].should == after_point[:max][:x]
          before_point[:min][:y].should == after_point[:min][:y] + @move_unit_per_frame
          before_point[:max][:y].should == after_point[:max][:y] + @move_unit_per_frame
        elsif @herbivore.direction == :down
          before_point[:min][:x].should == after_point[:min][:x]
          before_point[:max][:x].should == after_point[:max][:x]
          before_point[:min][:y].should == after_point[:min][:y] - @move_unit_per_frame
          before_point[:max][:y].should == after_point[:max][:y] - @move_unit_per_frame
        elsif @herbivore.direction == :left
          before_point[:min][:x].should == after_point[:min][:x] + @move_unit_per_frame
          before_point[:max][:x].should == after_point[:max][:x] + @move_unit_per_frame
          before_point[:min][:y].should == after_point[:min][:y]
          before_point[:max][:y].should == after_point[:max][:y]
        elsif @herbivore.direction == :left
          before_point[:min][:x].should == after_point[:min][:x] - @move_unit_per_frame
          before_point[:max][:x].should == after_point[:max][:x] - @move_unit_per_frame
          before_point[:min][:y].should == after_point[:min][:y]
          before_point[:max][:y].should == after_point[:max][:y]
        end
      end
    end
  end
end
