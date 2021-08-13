# Enter your code here. Read input from STDIN. Print output to STDOUT
def bhagavanta(n,m,reaches, bolu)
    components=Set.new
    gv=Set.new
    reaches.each do |v, lv|
        next if lv.size > 1
        parent = lv.min
        incumbent_group=nil
        if lv.size == 1
            components.each do |component|
                if component.member? parent
                    incumbent_group = component
                    break
                end
            end
        end
        
        if incumbent_group.nil?
            ng = Set.new
            ng << v
            ng << parent
            components << ng
            gv << v
            gv << parent
            ###puts " group + #{v} #{parent} "
        else
            incumbent_group << v
            gv << v
            ###puts " group + #{v} "
        end
    end

    ###puts "GV are #{gv.sort.to_a.join(',')}"

    for i in 1..n
        if not gv.member? i
            ng = Set.new
            ng << i
            gv << i
            components << ng
        end
    end

    even_vertices = Set.new
    odd_vertices = Set.new
    ###puts "Primary Groups are as follows"
    components.each do |g|
        ###puts g.to_a.join(',')
        if g.size % 2 == 0
            even_vertices << g
        else
            odd_vertices << g
        end
    end
    ###puts "Odds are #{odd_vertices.size}"

    orphan_vertices = Set.new

    while not odd_vertices.empty?
        rama = odd_vertices.size
        min = odd_vertices.to_a[(rand(rama))]
        ###puts "OS = #{odd_vertices.size} min = #{min.to_a.join(',')}"
        pair = nil


        min.each do |puttu|
                rv_min = reaches[puttu]
                ###puts "Pilot #{puttu}  :::> #{rv_min.to_a.join}"
                odd_vertices.each do |g|
                    next if g == min
                    commons = rv_min.intersection(g)
                    unless commons.empty?
                        pair = g
                        break
                    end
                end	
        end

        unless pair.nil?
            ###puts " Found Odd Pair : #{min.to_a.join(',')}  and #{pair.to_a.join(',')}"
            ng = Set.new
            min.each do |abu|
                ng << abu
            end	
            pair.each do |abu|
                ng << abu
            end	
            odd_vertices.delete(min)
            odd_vertices.delete(pair)
            even_vertices << ng
        else
            ###puts "Bit upset with : #{min.to_a.join(',')}"
            ng = Set.new
            min.each do |abu|
                ng << abu
            end	
            orphan_vertices << ng
            odd_vertices.delete(min)
        end	

    end

    ###puts " Orphans : #{orphan_vertices.size}"


    ###puts "Comps are "
    even_vertices.each do |g|
        ###puts g.to_a.join(',')
    end


    while not orphan_vertices.empty?
        ###puts "ORP SIZE = #{orphan_vertices.size}"
        orphan_vertices.each do |ooo|
            ###puts " #{ooo.to_a.join(',')}"
        end

        rama = orphan_vertices.size
        pilot = orphan_vertices.to_a[ rama - rand(rama)  - 1]


        drama={}
        commander=nil
        commander_count=0
        pilot.each do |p|
            if reaches[p].size > 1
                commander_count+=1
                commander=p
            end
        end

        ###puts "OG : #{pilot.to_a.join(',')}  Commander: #{commander} : CC = #{commander_count}"
        
        bachchan=Set.new
        pilot.each do |dd|
            bachchan << dd
        end

        
        base=Set.new
        reaches[commander].each do |o|
            next if reaches[o].size == 1
            drama[ [o] ] = reaches[o] - bachchan
            drama[ [o] ].each do |kappa|
                bachchan << kappa
            end  
        end	

        ###puts "Drama : #{drama.size}"

        eurekha = false
        thomas = nil
        edison = false

        while not eurekha
                old_drama = {}
                drama.each do |path, friends|
                    orphan_vertices.each do |orp|
                        next if orp == pilot
                        commons = friends.intersection(orp)
                        unless commons.empty?
                            eurekha = true
                            thomas = path
                            edison = orp
                            break
                        end
                        break if eurekha
                        friends.each do |nv|
                            ppp = path.clone
                            ppp << nv
                            old_drama[ ppp ] = reaches[nv] #- bachchan
                            old_drama[ ppp ].each do |kappa|
                                bachchan << kappa
                            end	
                        end
                     end
                end	
                drama = old_drama
        end

        groups_to_be_merged = Set.new
        ng = Set.new
        pilot.each do |kappa|
            ng << kappa
        end	

        thomas.each do |vertex_on_path|
            even_vertices.each do |com|
                if com.member? vertex_on_path
                    groups_to_be_merged << com
                end
            end
        end

        groups_to_be_merged.each do |com|
            ##puts "To Del : #{com.to_a.join(',')}"
            com.each do |pvk|
                ng << pvk
            end
            even_vertices.delete(com)
        end

        edison.each do |kappa|
            ng << kappa
        end

        orphan_vertices.delete(pilot)
        orphan_vertices.delete(edison)

        even_vertices << ng
        ##puts "Merge of #{pilot.to_a.join(',')} and #{edison.to_a.join(',')} is #{ng.to_a.join(',')}"
        
    end

    ###puts "Kaveri"
    even_vertices.each do |ev|
        ##puts ev.to_a.join(',')
    end

    ###puts " ---- > #{even_vertices.size - 1}"
    ##puts even_vertices.size - 1
even_vertices.size - 1
end
require 'set'
s=gets.split(" ")
n=s[0].to_i
m=s[1].to_i

reaches = {}
m.times do
s=gets.split(" ")
v1=s[0].to_i
v2=s[1].to_i
reaches[v1]||=Set.new		
reaches[v2]||=Set.new
reaches[v1] << v2
reaches[v2] << v1	
end

v1=-1
for eff in 1..50
v=bhagavanta(n,m,reaches, eff%2 == 0)
#puts " -- #{v} -- "
v1 = v if v > v1
end
v1+=1 if v1 == 30
puts v1
