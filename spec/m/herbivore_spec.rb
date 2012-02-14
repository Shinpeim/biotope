# -*- coding: utf-8 -*-
root = File.join(File.dirname(__FILE__), "..", "..")
$LOAD_PATH.unshift File.join(root, 'lib')

require File.join(File.dirname(__FILE__), "..", "spec_helper")
require "c/app_controller"
require "m/stage"
require "m/herbivore"

describe Herbivore do
  before do
    @stage = Stage.new(WINDOW_WIDTH,WINDOW_HEIGHT)
    @move_unit_per_frame = 1
    @center_point = {x: ((@stage.min_x + @stage.max_x) / 2), y: ((@stage.min_y + @stage.max_y) / 2)}
  end

  # 初期化について
  describe "stageに入っていないとき" do
    it "エラーになること" do
      lambda{Herbivore.new(@stage, {x: 5, y: 5}, @move_unit_per_frame)}.should raise_error
    end
  end

  describe "初期化時に" do
    before do
      @herbivore = Herbivore.new(@stage, {x: 11, y: 11}, @move_unit_per_frame)
    end

    it "初期養分がHerbivore::INITIAL_NUTRIMENTであること" do
      @herbivore.nutriment.should == Herbivore::INITIAL_NUTRIMENT
     end

    it "進行方向を持っていること" do
      DIRECTIONS.should be_include @herbivore.direction
    end

    it "life_pointがHerbivore::INITIAL_LIFE_POINTなこと" do
      @herbivore.life_point.should == Herbivore::INITIAL_LIFE_POINT
    end

    it "幅が単位幅であること" do
      @herbivore.width.should == UNIT_WIDTH
    end

    it "高さが単位高さであること" do
      @herbivore.height.should == UNIT_HEIGHT
    end

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
  end

  # 歩き方について
  DIRECTIONS.each do |direction|
    describe direction.to_s + "方向へ進むとき" do
      before do
        begin
          @herbivore = Herbivore.new(@stage, @center_point, @move_unit_per_frame)
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
        elsif @herbivore.direction == :bottom
          before_point[:min][:x].should == after_point[:min][:x]
          before_point[:max][:x].should == after_point[:max][:x]
          before_point[:min][:y].should == after_point[:min][:y] - @move_unit_per_frame
          before_point[:max][:y].should == after_point[:max][:y] - @move_unit_per_frame
        elsif @herbivore.direction == :left
          before_point[:min][:x].should == after_point[:min][:x] + @move_unit_per_frame
          before_point[:max][:x].should == after_point[:max][:x] + @move_unit_per_frame
          before_point[:min][:y].should == after_point[:min][:y]
          before_point[:max][:y].should == after_point[:max][:y]
        elsif @herbivore.direction == :right
          before_point[:min][:x].should == after_point[:min][:x] - @move_unit_per_frame
          before_point[:max][:x].should == after_point[:max][:x] - @move_unit_per_frame
          before_point[:min][:y].should == after_point[:min][:y]
          before_point[:max][:y].should == after_point[:max][:y]
        end
      end
    end
  end

  describe "邪魔するものがないとき" do
    before do
      begin
        @herbivore = Herbivore.new(@stage, @center_point, @move_unit_per_frame)
      end until @herbivore.direction == :left
    end

    it "70歩は歩き続けること" do
      lambda {
        (70 / @move_unit_per_frame).times do
          @herbivore.move
        end
      }.should change(@herbivore, :max_x).by(-70)
    end

    it "120歩以内に曲がること" do
      lambda {
        (120 / @move_unit_per_frame).times do
          @herbivore.move
        end
      }.should change(@herbivore, :max_x)

      lambda {
        (120 / @move_unit_per_frame).times do
          @herbivore.move
        end
      }.should_not change(@herbivore, :max_x).by(-140)
    end
  end

  test_cases = [
    {
      :direction => :top,
      :walls_to_test =>  [ [:top], [:top, :left], [:top, :right] ],
    },
    {
      :direction => :left,
      :walls_to_test =>  [ [:left], [:top, :left], [:bottom, :left] ],
    },
    {
      :direction => :bottom,
      :walls_to_test =>  [ [:bottom], [:bottom, :left], [:bottom, :right] ],
    },
    {
      :direction => :right,
      :walls_to_test =>  [ [:right], [:top, :right], [:bottom, :right] ],
    },
  ];
  test_cases.each do |test_case|
    describe "#{test_case[:direction].to_s}に向かっているとき" do
      test_case[:walls_to_test].each do |walls|

        describe "#{walls.map{|item|item.to_s}.join("と")}に壁があったら" do

          before do
            x = @center_point[:x]
            y = @center_point[:y]
            to_start = {
              :top =>  {x: nil, y: @stage.min_y + @move_unit_per_frame},
              :left => {x: @stage.min_x + @move_unit_per_frame, y: nil},
              :bottom =>  {x: nil, y: @stage.max_y - UNIT_HEIGHT - @move_unit_per_frame},
              :right => {x: @stage.max_x - UNIT_HEIGHT -  @move_unit_per_frame, y: nil},
            }
            to_start.each do |d,point|
              if walls.include? d
                x = point[:x] if point[:x]
                y = point[:y] if point[:y]
              end
            end
            @start_point = {x: x, y: y}
          end

          will_turn_to = DIRECTIONS.reject{|d| walls.include? d}
          turned_to = []
          it "#{will_turn_to.map{|i|i.to_s}.join('か')}にのみターンしうること" do
            50.times do
              begin
                @herbivore = Herbivore.new(@stage, @start_point, @move_unit_per_frame)
              end until @herbivore.direction == test_case[:direction]
              @herbivore.move
              turned_to.push @herbivore.direction
            end
            turned_to.uniq.sort{|a,b| a.to_s <=> b.to_s}.should ==
              will_turn_to.sort{|a,b| a.to_s <=> b.to_s}
          end

        end

      end
    end
  end

  # 死活について
  describe "死活に関して" do
    before do
      @herbivore = Herbivore.new(@stage, @center_point, @move_unit_per_frame)
    end

    it "1歩動くとlife_pointが1減ること" do
      lambda{@herbivore.move}.should change(@herbivore,:life_point).by(-1)
    end

    it "life_pointが0になると死に、動けなくなること" do
      (Herbivore::INITIAL_LIFE_POINT).times do
        @herbivore.should_not be_dead
        @herbivore.move
      end

      @herbivore.should be_dead
      lambda{@herbivore.move}.should raise_error
    end
  end

end
