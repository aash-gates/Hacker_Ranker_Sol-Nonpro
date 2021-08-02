#!/bin/ruby

a,b,c,d = gets.strip.split(' ').map(&:to_i).sort
A = a.to_i
B = b.to_i
C = c.to_i
D = d.to_i


res = 0
abs = {}
abs_ = [0] * (B + 1)
(1..A).each do |a|
    (a..B).each do |b|
        ab = a ^ b
        abs[ab] ||= [0] * (B + 1)
        abs[ab][b] += 1
        abs_[b] += 1
    end
end

abs_total = 0
sabs_ = abs_.map{ |a| abs_total += a }

sabs = {}
abs.each do |k,v|
    vtotal = 0
    sabs[k] = v.map{ |a| vtotal += a }
end

cds = {}
(1..C).each do |c|
    (c..D).each do |d|
        cd = c^d
        #next if cds[cd]
        #cds[cd] = true
        cc = c
        cc = B if c > B
        res += sabs_[cc]
        res -= sabs[cd][cc] if sabs[cd]
    end
end
puts res