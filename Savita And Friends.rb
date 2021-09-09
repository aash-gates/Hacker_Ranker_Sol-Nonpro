def process_testcase(graph, kth_road)
    dist_a, max_dist = find_point(graph, kth_road)
    puts("%0.5f %0.5f" % [dist_a, max_dist])
  end
  
  def find_point(graph, kth_road)
    a, b, c = *kth_road
  
    spa = shortest_paths(a, graph)
    spb = shortest_paths(b, graph)
  
    sp_either = graph.keys.each_with_object({}) do |n, memo|
      if spa[n] <= spb[n]
        memo[n] = [spa[n], :a]
      else
        memo[n] = [spb[n], :b]
      end
    end
  
    max_a = sp_either.values.select { |_,which| which == :a }.map(&:first).max
    max_b = sp_either.values.select { |_,which| which == :b }.map(&:first).max
  
    if max_a - max_b >= c
      return [0.0, max_a]
    elsif max_b - max_a >= c
      return [c, max_b]
    end
  
    dist = (c + max_b - max_a) / 2.0
  
    if spa.values.max < max_a + dist || spb.values.max < max_a + dist
      if spa.values.max <= spb.values.max
        return [0, spa.values.max]
      else
        return [c, spb.values.max]
      end
    end
  
    [dist, max_a + dist]
  end
  
  def shortest_paths(a, graph)
    shortest_path = Hash.new { |h,k| 1/0.0 }
    queue = MinHeap.new
  
    shortest_path[a] = 0
    graph[a].each do |b,c|
      queue.add(b, c)
    end
  
    while !queue.empty?
      n, dist = queue.pop
      if dist < shortest_path[n]
        shortest_path[n] = dist
        graph[n].each do |b,c|
          queue.add(b, dist + c) if dist + c < shortest_path[b]
        end
      end
    end
  
    shortest_path
  end
  
  
  class MinHeap
    class Node
      attr_reader :key
      attr_accessor :cost
  
      def initialize(key, cost)
        @key, @cost = key, cost
      end
    end
  
    def initialize
      @heap = []
    end
  
    def add(key, cost)
      @heap << Node.new(key, cost)
      return if @heap.length == 1
  
      i = @heap.length - 1
      p = parent(i)
  
      while @heap[p].cost > @heap[i].cost
        swap(i, p)
  
        break if p == 0
  
        i = p
        p = parent(i)
      end
    end
  
    def pop
      if @heap.length == 1
        root = @heap.pop
        return root.key, root.cost
      end
  
      root = @heap.first
      @heap[0] = @heap.pop
  
      i = 0
      l = left_child(i)
      r = right_child(i)
      parent_cost = @heap[i].cost
  
      while (l < @heap.length && @heap[l].cost < parent_cost) || (r < @heap.length && @heap[r].cost < parent_cost)
        if r < @heap.length
          if @heap[l].cost <= @heap[r].cost
            swap(i, l)
            i = l
          else
            swap(i, r)
            i = r
          end
  
          l = left_child(i)
          r = right_child(i)
          parent_cost = @heap[i].cost
        else # only l is < heap_length
          swap(i, l)
          break
        end
      end
  
      [root.key, root.cost]
    end
  
    def empty?
      @heap.empty?
    end
  
    private
  
    def swap(i, j)
      n = @heap[j]
      @heap[j] = @heap[i]
      @heap[i] = n
    end
  
    def parent(i)
      ((i - 1) / 2).floor
    end
  
    def left_child(i)
      (2 * i) + 1
    end
  
    def right_child(i)
      (2 * i) + 2
    end
  end
  
  lines = STDIN.readlines
  
  testcase_count = lines.shift.to_i
  testcases_processed = 0
  
  while !lines.empty?
    n, m, k = lines.shift.split.map(&:to_i)
    testcase_lines = lines[0..m-1]
    lines = lines[m..-1]
  
    graph = Hash.new { |h,k| h[k] = {} }
    kth_road = nil
    testcase_lines.each_with_index do |line, i|
      a, b, c = line.split.map(&:to_i)
      graph[a][b] = c
      graph[b][a] = c
      kth_road = [a,b,c] if i == k - 1
    end
  
    raise "no #{k}th_road:\n #{testcase_lines}" unless kth_road
  
    friend_count = graph.keys.count
    raise "friends: #{n} != #{friend_count}" unless friend_count == n
  
    process_testcase(graph, kth_road)
  
    testcases_processed += 1
  end
  
  raise "testcases: #{testcase_count} != #{testcases_processed}" unless testcase_count == testcases_processed
  