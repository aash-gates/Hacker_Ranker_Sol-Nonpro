#! /usr/bin/env ruby

require 'pp'

MODULO = 1000000000

def get_int
  gets.scan(/\d+/).map{|i| i.to_i}
end

cityNum, roadNum = get_int
roads = Array.new(cityNum) { Array.new }
roadNum.times do
  u, v = get_int
  u -= 1;
  v -= 1;
  roads[u] << v
end

def dfs(roads, u, status, hasLoop)
  visitedCities = []
  status[u] = :visiting
  roads[u].each do |v|
    case status[v]
    when :visiting
      hasLoop << v
    when :unvisited
      cities = dfs(roads, v, status, hasLoop)
      return :infinity if cities == :infinity
      visitedCities += cities
    end
  end
  status[u] = :visited
  visitedCities << u
  return visitedCities
end

hasLoop = []
visitedCities = dfs(roads, 0, Array.new(cityNum, :unvisited), hasLoop)

paths = [1] + [0] * (cityNum - 1)
hasLoop.each { |i| paths[i] = 1.0/0.0 }
visitedCities.reverse.each do |u|
  roads[u].each { |v| paths[v] += paths[u] }
end

if paths[cityNum-1] == 1.0/0.0
  puts "INFINITE PATHS"
else
  puts paths[cityNum-1] % MODULO
end



