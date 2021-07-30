#!/bin/ruby

n,k = gets.strip.split(' ')
n = n.to_i
k = k.to_i
x = gets.strip
x = x.split(' ').map(&:to_i).sort
cc = 0
while x.length > 0
    a = x[0]
    mm = x.take_while{|y| y <= a + k}.max + k
    x = x.drop_while{|y| y <= mm}
    cc += 1
end
puts cc