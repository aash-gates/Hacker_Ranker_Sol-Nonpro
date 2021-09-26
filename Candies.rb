n = gets.to_i
line = Array.new(n).map{|i| gets.to_i}.insert(0,0).push(0)
candies1 = Array.new(n,1).insert(0,0).push(0)
candies2 = Array.new(n,1).insert(0,0).push(0)
candies1[1] = 1
for i in 2..n
    if line[i-1] < line[i]
        candies1[i] = candies1[i-1] + 1
    else
        candies1[i] = 1
    end
end
candies2[n] = 1
(n-1).downto(1){ |i|
    if line[i] > line[i+1]
        candies2[i] = candies2[i+1] + 1
    else
        candies2[i] = 1
    end
}
ans = 0
for i in 1..n
    if candies1[i] >= candies2[i]
        ans += candies1[i]
    else
