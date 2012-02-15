class QuadTreeSpace

  attr_accessor :depth, :spaces

  def initialize(space, depth)
    @depth = depth
    @root_space = space

    @unit_length = {}
    [:x, :y].each do |simbol|
      @unit_length[simbol] =
        (@root_space[:max][simbol] - @root_space[:min][simbol]).to_f / (2 ** @depth).to_f
    end
    @space_num = 0
    depth.downto(0) do |n|
      @space_num += calc_space_num(n)
    end
    @spaces = []
    @space_num.times do
      @spaces.push []
    end
  end

  def register(obj)
    depth,morton_no = get_space_of_rect(:min => {:x => obj.min_x, :y => obj.min_y},
                                        :max => {:x => obj.max_x, :y => obj.max_y})
    @spaces[space_index_of(depth,morton_no)].push obj
    return depth,morton_no
  end

  def clear
    @spaces = Array.new(@space_num){[]}
    @memo_get_objects_in = {}
  end

  def get_objects_in(depth,morton_no)
    @memo_get_objects_in ||= {}
    memo_key = :"#{depth}_#{morton_no}"
    memo = @memo_get_objects_in[memo_key]
    return memo if memo

    indexes = descended_indexes(depth,morton_no)
    ret = indexes.map{|i|@spaces[i]}.flatten
    @memo_get_objects_in[memo_key] = ret
    return ret
  end


  private
  def calc_space_num(depth)
    if depth == 0
      return 1
    end

    return 4 * calc_space_num(depth - 1)
  end

  def descended_indexes(depth,morton_no)
    @memo_descended_indexes ||= {}
    memo_key = :"#{depth}_#{morton_no}"
    memo = @memo_descended_indexes[memo_key]
    return memo if memo

    indexes = []

    r = lambda {|depth,morton_no|
      indexes.push space_index_of(depth,morton_no)
      if depth == @depth
        return
      else
        r.call(depth + 1, morton_no * 4 + 0)
        r.call(depth + 1, morton_no * 4 + 1)
        r.call(depth + 1, morton_no * 4 + 2)
        r.call(depth + 1, morton_no * 4 + 3)
      end
    }

    r.call(depth,morton_no)
    @memo_descended_indexes[memo_key] = indexes
    return indexes
  end

  def get_space_of_rect(rect)
    n = get_morton_no(rect[:min][:x], rect[:min][:y])
    m = get_morton_no(rect[:max][:x], rect[:max][:y])
    o = n ^ m

    level = 0
    q = 1
    while true
      break if q > o
      level += 1
      q = q << 2
    end

    object_depth = @depth - level
    morton_no = n >> level * 2
    return object_depth, morton_no
  end

  def space_index_of(depth,morton_no)
    k = 0
    last_val = 0
    while true
      break if k == depth
      k += 1
      last_val = last_val + (4 ** (k-1))
    end
    last_val + morton_no
  end


  def get_morton_no(x,y)
    x = ((x - @root_space[:min][:x]) / @unit_length[:x]).floor
    y = ((y - @root_space[:min][:y]) / @unit_length[:y]).floor
    return bitseparate(x) | (bitseparate(y) << 1)
  end

  def bitseparate(n)
    n = (n|(n << 8)) & 0x00ff00ff
    n = (n|(n << 4)) & 0x0f0f0f0f;
    n = (n|(n << 2)) & 0x33333333;
    return (n|(n << 1)) & 0x55555555;
  end
end
