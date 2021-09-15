#!/bin/ruby

n = gets.strip.to_i
calories = gets.strip
calories = calories.split(' ').map(&:to_i)
# your code goes here
calories.sort!.reverse!
