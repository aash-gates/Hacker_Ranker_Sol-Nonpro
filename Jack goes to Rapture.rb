# Enter your code here. Read input from STDIN. Print output to STDOUT

class Solver
    def initialize(num_nodes, graph_hash, cost_hash)
      @num_nodes  = num_nodes
      @graph_hash = graph_hash
      @cost_hash  = cost_hash
      @min_cost   = @cost_hash.values.max
      @seen_node  = {}
    end
  
    def min_cost_from_start_to_end(start_node, end_node)
      tree = kruskal_algorithm_build_mini_spanning_tree
      dijkstra_algorithm_run(start_node, end_node, tree)
    end
  
    private
  
    def dijkstra_algorithm_run(start_node, end_node, graph_hash = nil)
      graph_hash ||= @graph_hash
      min_cost_ary = Array.new(@num_nodes + 1)
      min_cost_ary[1] = 0
      queue = [1]
      seen_nodes = {}
  
      while(!queue.empty?)
        node = queue.shift
        seen_nodes[node] = true
  
        adjacent_nodes = graph_hash[node]
        local_min = 0
        adjacent_nodes.each do |adjacent_node|
          queue << adjacent_node unless seen_nodes.key?(adjacent_node)
  
          if min_cost_ary[node] > @cost_hash[[node, adjacent_node].sort]
            local_min = min_cost_ary[node]
          else
            local_min = @cost_hash[[node, adjacent_node].sort]
          end
  
          if min_cost_ary[adjacent_node].nil? || min_cost_ary[adjacent_node] > local_min
            if seen_nodes.key?(adjacent_node)
              queue << adjacent_node
            end
            min_cost_ary[adjacent_node] = local_min
          end
        end
      end
  
      min_cost_ary[end_node]
    end
  
    def kruskal_algorithm_build_mini_spanning_tree
      # initialize one node one set
      # each set, look like {1 => 1, 2 => 2... n => n}
      sets = {}
      revert_sets = {}
      @num_nodes.times.each do |i|
        sets[i+1] = i+1
        revert_sets[i+1] = [i+1]
      end
      mini_spanning_tree = Hash.new { |hash, key| hash[key] = [] }
  
      # sorted edges
      sorted_edges = Hash[@cost_hash.sort_by { |k,v| v }]
  
      # traverse edge with smallest cost first
      sorted_edges.each do |(node1, node2), _|
        if sets[node1] != sets[node2]
          # if vertiex of a edge does not belongs to the same set, union them
          union_set(node1, node2, sets, revert_sets)
          mini_spanning_tree[node1] << node2
          mini_spanning_tree[node2] << node1
        end
      end
  
      mini_spanning_tree
    end
  
    def union_set(node1, node2, sets, revert_sets)
      node1_set = sets[node1]
      node2_set = sets[node2]
  
      merged_set        = [node1_set, node2_set].max
      to_be_changed_set = node1_set == merged_set ? node2_set : node1_set
  
      to_be_changed_nodes = revert_sets[to_be_changed_set]
      revert_sets.delete(to_be_changed_set)
  
      to_be_changed_nodes.each do |node|
        sets[node] = merged_set
        revert_sets[merged_set] << node
      end
    end
  
    # NOTE: Note using this method and this is only for testing
    # and it is not working with this algorithm to create a mini_spanning_tree
    def prim_algorithm_build_mini_spanning_tree
      start_node = @graph_hash.keys.first
      mini_spanning_tree = Hash.new { |hash, key| hash[key] = [] }
      all_external_edges = initialize_edges(start_node)
  
      while(mini_spanning_tree.size < @graph_hash.size)
        # choose the minimum edge and add that to the tree
        minimum_cost_edge = nil
        all_external_edges.each do |edge|
          if minimum_cost_edge.nil? || @cost_hash[minimum_cost_edge] > @cost_hash[edge]
            minimum_cost_edge = edge
          end
        end
  
        # add this edge to the mini_spanning_tree
        node1 = minimum_cost_edge.first
        node2 = minimum_cost_edge.last
        new_node = mini_spanning_tree.key?(node1) ? node2 : node1
        mini_spanning_tree[node1] << node2
        mini_spanning_tree[node2] << node1
  
        # remove edge from the all_external_edges
        all_external_edges.delete(minimum_cost_edge)
  
        # add the other external edges to the all_external_edges
        others = @graph_hash[new_node] - mini_spanning_tree.keys
        others.each do |other|
          all_external_edges << [new_node, other].sort
        end
      end
  
      mini_spanning_tree
    end
  
    def initialize_edges(start_node)
      others = @graph_hash[start_node]
      others.map { |other| [start_node, other].sort }
    end
  
  end
  
  graph_hash = Hash.new { |hash, key| hash[key] = [] }
  cost_hash = {}
  
  num_nodes, num_edges = gets.strip.split(' ').map(&:to_i)
  
  num_edges.times.each do
    node1, node2, cost = gets.strip.split(' ').map(&:to_i)
  
    graph_hash[node1] << node2
    graph_hash[node2] << node1
    cost_hash[[node1,node2].sort] = cost
  end
  
  s = Solver.new(num_nodes, graph_hash, cost_hash)
  
  puts s.min_cost_from_start_to_end(1, num_nodes) || 'NO PATH EXISTS'
  
  
  
  
  
  