n = gets.to_i
line = Array.new(n).map{|i| gets.to_i}.insert(0,0).push(0)
candies1 = Array.new(n,1).insert(0,0).push(0)
candies2 = Array.new(n,1).insert(0,0).push(0)
candies1[1] = 1
for i in 2..n
    if line[i-1] < line[i]