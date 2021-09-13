require "set"

graph = Hash.new { |hash, key| hash[key] = [] }
rgraph = Hash.new { |hash, key| hash[key] = [] }
vertices = SortedSet.new

gets.to_i.times {
    gets; last = nil
    gets.split.map(&:to_i).each { |x|
        vertices << x
        graph[last] << x if last
        rgraph[x] << last if last
        last = x
    }
}

s = SortedSet.new vertices.select { |x| rgraph[x].empty? }
l = []

until s.empty?
    u = s.take(1)[0]
    graph[u].each { |v|
        rgraph[v].delete u
