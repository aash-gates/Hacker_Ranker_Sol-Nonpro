# Enter your code here. Read input from STDIN. Print output to STDOUT
require 'set'

def min_cost(n, m, adj, a, b)
    return 0 if a == b
    costs = Array.new(n)
    (0...n).each do |i|
        costs[i] = Set.new
    end
    costs[b] = nil
    connections = [[a, 0]]
    while !connections.empty?
        node, cost = connections[0]
        connections = connections[1..-1]
        if node == b
            costs[b] = cost if costs[b] == nil || cost < costs[b]
            next
        end
        next if !useful_cost(costs[node], cost) || (costs[b] != nil && cost > costs[b])
        costs[node] << cost
        (0...n).each do |i|
            adj[node][i].each do |new_cost|
                combined = cost|new_cost
                connections << [i, combined]    
            end       
        end
    end
    costs[b] == nil ? -1 : costs[b]
end

def useful_cost(costs, new_cost)
    costs.each do |cost|
        return false if cost&new_cost == cost
    end
    return true
end

n, m = gets.split.map(&:to_i)
adj = Array.new(n)
(0...n).each do |i|
    adj[i] = Array.new(n)
    (0...n).each do |j|
        adj[i][j] = Set.new
    end
end
m.times do
    u, v, c = gets.split.map(&:to_i)
    adj[u-1][v-1] << c
    adj[v-1][u-1] << c
end
a, b = gets.split.map(&:to_i)
puts min_cost(n, m, adj, a-1, b-1)