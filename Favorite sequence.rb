require "set"

graph = Hash.new { |hash, key| hash[key] = [] }
rgraph = Hash.new { |hash, key| hash[key] = [] }
vertices = SortedSet.new

gets.to_i.times {
    gets; last = nil
    gets.split.map(&:to_i).each { |x|
        vertices << x
        graph[last] << x if last
