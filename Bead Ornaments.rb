t = gets.chomp.to_i
(1..t).each{
n = gets.chomp.to_i

p = 1
 
line = gets.chomp.split(" ").collect! {|x| x.to_i}
p1 = 2
sum = 0
line.each{|k| sum+=k}
term = sum
if n==1
	puts (sum**(sum-2))%1000000007
else

sum = 1


(3..n).each{
	sum = (sum*term)%1000000007
}


line.each {|k|
 q = (k**(k-1))%1000000007
 p = (p*q)%1000000007
}

puts (p*sum)%1000000007
end
}