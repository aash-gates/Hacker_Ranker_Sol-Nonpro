class Edges
    attr_reader :weight, :coord1, :coord2
    def initialize(time, x, y)
      @weight = time
      @coord1 = x
      @coord2 = y
    end
  
    def printing
      printf("%d %d %d\n", @weight, @coord1, @coord2)
    end
  end
  
  $edges = Array.new
  $machine = Hash.new(0)
  $root = Array.new(100000)
  
  def input
    
    line = gets
    line = line.split
    n = line[0].to_i
    k = line[1].to_i
    $n = n
    (n-1).times do |i|
      line = gets
      line = line.split
      3.times { |i| line[i] = line[i].to_i }
      edge = Edges.new(line[2], line[0], line[1])
      $edges << edge
    end
    $edges.sort! { |a,b| b.weight<=>a.weight }
    #$edges.each { |x| x.printing }
    
    k.times do
      line = gets.to_i
      $machine[line] = 1
    end
  
    n.times { |i| $root[i] = i }
  end
  
  def findroot(x)
    if $root[x] == x
      return x
    end
    y = findroot($root[x])
    $root[x] = y
    return y
  end
  
  def setroot(x, r)
    $root[x] = r
  end
  
  def algo
    n = $n
    answer = 0
    (n-1).times do |i|
      root1 = findroot $edges[i].coord1
      root2 = findroot $edges[i].coord2
      if $machine[root1] == 1
        if $machine[root2] == 0
          setroot(root2, root1)
        else
          answer = answer + $edges[i].weight
        end
      else
        setroot(root1, root2)
      end
    end
    puts answer
  end
  
  input
  algo
  