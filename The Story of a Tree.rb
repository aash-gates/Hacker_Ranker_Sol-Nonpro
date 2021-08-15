#!/bin/ruby
require 'set'

def orient_ n
  @g[n].each do |x|
    @g[x].delete(n)
  end
  return @g[n]
end
def orient root
  needs_orientation=[root]
  while needs_orientation!=[]
    needs_orientation=needs_orientation[1..-1]+orient_(needs_orientation[0])
  end
end
def assigndepths root,n
  @depths[root]=n
  @g[root].each do |x|
    assigndepths x,n+1
  end
end

def solve root
  @g[root].each do |child| 
    @roots[child]=@roots[root]-(@queries.include?([root,child]) ? 1:0)+(@queries.include?([child,root]) ? 1:0)
    solve child
  end
end
q = gets.strip.to_i
q.times do
  n = gets.strip.to_i
  @g=(1..n).to_a.zip(Array.new(n).map{Array.new()}).to_h
  @depths = (1..n).to_a.zip(Array.new(n).map{Array.new()}).to_h
  (n-1).times do
    u,v = gets.strip.split(' ').map(&:to_i)
    @g[u] << v
    @g[v] << u
  end
  orient 1
  assigndepths 1,0
  #puts @g
  #puts @depths
  g,k = gets.strip.split(' ').map(&:to_i)
  @queries = Set.new()
  @roots={1=>0}
  g.times do
    u,v = gets.strip.split(' ').map(&:to_i)
    @queries.add([u,v])
    @roots[1]+=(@depths[v]>@depths[u] ? 1 : 0)
  end

  solve 1
  acc=0
  @roots.each_key do |x|
    if @roots[x]>=k
      acc+=1
    end
  end
  gcd=acc.gcd(n)
  puts "#{acc/gcd}/#{n/gcd}"
end
