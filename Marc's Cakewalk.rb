#!/bin/ruby

n = gets.strip.to_i
calories = gets.strip
calories = calories.split(' ').map(&:to_i)
# your code goes here
calories.sort!.reverse!

a = 0
i = 0
calories.each do |x|
   a+= 2**i * x
   i+=1
end
puts a