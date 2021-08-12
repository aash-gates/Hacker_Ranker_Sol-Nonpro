#!/bin/ruby
def cost(n, m, c_l, c_r, adj)
    return n*c_l if c_l <= c_r
    result = 0
    visited = Array.new(n, false)
    (0...n).each do |i|
        if !visited[i]
            result += c_l
            result += dfs(i, adj, visited)*c_r
        end
    end
    result
end

def dfs(x, adj, visited)
    visited[x] = true
    roads = 0
    adj[x].each do |i|
        if !visited[i]
            roads += dfs(i, adj, visited)+1
        end
    end
    roads
end

q = gets.strip.to_i
for a0 in (0..q-1)
    n,m,x,y = gets.strip.split(' ')
    n = n.to_i
    m = m.to_i
    x = x.to_i
    y = y.to_i
    adj = Array.new(n)
    (0...n).each do |i|
        adj[i] = []
    end
    for a1 in (0..m-1)
        city_1,city_2 = gets.strip.split(' ')
        city_1 = city_1.to_i
        city_2 = city_2.to_i
        adj[city_1-1] << city_2-1
        adj[city_2-1] << city_1-1
    end
    puts cost(n, m, x, y, adj)
end
