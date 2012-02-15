# -*- coding: utf-8 -*-
root = File.join(File.dirname(__FILE__), "..", "..")
$LOAD_PATH.unshift File.join(root, 'lib')

require File.join(File.dirname(__FILE__), "..", "spec_helper")
require "m/quad_tree_space"

class MockObj
  attr_reader :min_x, :min_y, :max_x, :max_y
  def initialize(x1,y1,x2,y2)
    @min_x = x1
    @min_y = y1
    @max_x = x2
    @max_y = y2
  end
end

describe QuadTreeSpace do
  it "space{x1:1, y1:1, x2:80, y2:80}で分割数0のとき" do
    qts = QuadTreeSpace.new({:min => {:x => 1, :y => 1}, :max => {:x => 80, :y => 80}}, 0)
    qts.depth.should == 0
    qts.spaces.size.should == 1
  end

  it "space{x1:1, y1:1, x2:80, y2:80}で分割数1のとき" do
    qts = QuadTreeSpace.new({:min => {:x => 1, :y => 1}, :max => {:x => 80, :y => 80}}, 1)
    qts.depth.should == 1
    qts.spaces.size.should == 5
  end

  it "space{x1:1, y1:1, x2:80, y2:80}で分割数2のとき" do
    qts = QuadTreeSpace.new({:min => {:x => 1, :y => 1}, :max => {:x => 80, :y => 80}}, 2)
    qts.depth.should == 2
    qts.spaces.size.should == 21
  end

  describe "#get_morton_no" do
    describe "space{x1:0, y1:0, x2:32, y2:32}で分割数4の木に" do
      before do
        @qts = QuadTreeSpace.new({:min => {:x => 0, :y => 0}, :max => {:x => 32, :y => 32}}, 4)
      end

      it "x:0, y:0を渡したとき" do
        @qts.send(:get_morton_no,0,0).should == 0
      end
      it "x:1, y:1を渡したとき" do
        @qts.send(:get_morton_no,1,1).should == 0
      end
      it "x:2, y:0を渡したとき" do
        @qts.send(:get_morton_no,2,0).should == 1
      end
      it "x:0, y:2を渡したとき" do
        @qts.send(:get_morton_no,0,2).should == 2
      end
      it "x:7, y:7を渡したとき" do
        @qts.send(:get_morton_no,7,7).should == 15
      end
    end
  end

  describe "#space_index_of" do
    describe "space{x1:0, y1:0, x2:32, y2:32}で分割数4の木に" do
      before do
        @qts = QuadTreeSpace.new({:min => {:x => 0, :y => 0}, :max => {:x => 32, :y => 32}}, 4)
      end

      it "depth:0, morton:0を渡したとき" do
        @qts.send(:space_index_of,0,0).should == 0
      end
      it "depth:1, morton:0を渡したとき" do
        @qts.send(:space_index_of,1,0).should == 1
      end
      it "depth:1, morton:1を渡したとき" do
        @qts.send(:space_index_of,1,1).should == 2
      end
      it "depth:2, morton:0を渡したとき" do
        @qts.send(:space_index_of,2,0).should == 5
      end
    end
  end

  describe "#register" do
    describe "space{x1:0, y1:0, x2:32, y2:32}で分割数4の木に" do
      before do
        @qts = QuadTreeSpace.new({:min => {:x => 0, :y => 0}, :max => {:x => 32, :y => 32}}, 4)
      end

      it "{0,0,1,1}を渡したら depth:4 morton_no:0に登録されること" do
        @qts.register(MockObj.new(0, 0, 1, 1)).
          should == [4,0]
      end

      it "{1,1,2,2}を渡したら depth:3 morton_no:0に登録されること" do
        @qts.register(MockObj.new(1, 1, 2, 2)).
          should == [3,0]
      end

      it "{3,2,4,3}を渡したら、depth:2,morton_no:0に登録されること" do
        @qts.register(MockObj.new(3, 2, 4, 3)).
          should == [2,0]
       end

      it "{7,4,8,5}を渡したら depth:1 morton_no:0に登録されること" do
        @qts.register(MockObj.new(7, 4, 8, 5)).
          should == [1,0]
      end

      it "{6,24,7,25}を渡したら、depth:4 morton_no:165に登録されること" do
        @qts.register(MockObj.new(6,24,7,25)).
          should == [4,165]
      end

      it "{5,24,6,25}を渡したら、depth:4 morton_no:165に登録されること" do
        @qts.register(MockObj.new(5,24,6,25)).
          should == [3,41]
      end

      it "{5,24,6,25}を渡したら、depth:4 morton_no:165に登録されているオブジェクトの数が1なこと" do
        @qts.register(MockObj.new(5,24,6,25))
        @qts.get_objects_in(3,41).size.should == 1
      end

      it "{7,4,8,5}を渡したら depth:1 morton_no:0に登録されているオブジェクトが1のこと" do
        @qts.register(MockObj.new(7,4,8,5))
        @qts.get_objects_in(1,0).size.should == 1
      end

    end
  end

  describe "#get_objects_in" do
    describe "space{x1:0, y1:0, x2:32, y2:32}で分割数2の木に" do
      before do
        @qts = QuadTreeSpace.new({:min => {:x => 0, :y => 0}, :max => {:x => 32, :y => 32}}, 2)
      end
      objects = [{obj: MockObj.new(15,15,16,16)}, #root

                 {obj: MockObj.new( 7, 7, 8, 8)}, #depth:1 morton:0
                 {obj: MockObj.new(23, 7,24, 8)}, #depth:1 morton:1
                 {obj: MockObj.new( 7,23, 8,24)}, #depth:1 morton:2
                 {obj: MockObj.new(23,23,24,24)}, #depth:1 motron:3

                 {obj: MockObj.new( 8, 8, 9, 9)}, #depth:2 (in depth:1 morton:0)
                 {obj: MockObj.new(10,10,11,11)}, #depth:2 (in depth:1 morton:0)
                 {obj: MockObj.new(17, 8, 18,9)}, #depth:2 (in depth:1 morton:1)
                 {obj: MockObj.new(18,10,19,11)}, #depth:2 (in depth:1 morton:1)
                 {obj: MockObj.new( 8,24, 9,25)}, #depth:2 (in depth:1 morton:2)
                 {obj: MockObj.new(16,16,17,17)},] #depth:2 (in depth:1 morton:3)
      describe "たくさんのオブジェクトがあるとき" do
        before do
          @qts = QuadTreeSpace.new({:min => {:x => 0, :y => 0}, :max => {:x => 32, :y => 32}}, 2)
          objects.each do |obj|
            depth,morton = @qts.register(obj[:obj])
            obj[:depth] = depth
            obj[:morton] = morton
          end
        end

        it "rootにいるオブジェクトはぜんぶと衝突判定する" do
          root_obj = objects[0]
          @qts.get_objects_in(root_obj[:depth], root_obj[:morton]).sort{|a,b|
            a.object_id <=> b.object_id
          }.should == objects.map{|item|item[:obj]}.sort{|a,b|
            a.object_id <=> b.object_id
          }
        end

        it "depth:1 morton0 にいるオブジェクトはそことその子孫空間にいるものと衝突判定する" do
          subject = objects[1]
          to_check = [objects[1],objects[5],objects[6]].
            map{|i|i[:obj]}.
            sort { |a,b| a.object_id <=> b.object_id }

          @qts.get_objects_in(subject[:depth], subject[:morton]).sort{|a,b|
            a.object_id <=> b.object_id
          }.should == to_check
        end
      end
    end
  end


end

