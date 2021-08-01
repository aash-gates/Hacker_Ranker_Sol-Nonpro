
def navigate_forest(forest, hermione, waves)
    waves_used = run_through_forest(forest, hermione[:row], hermione[:col], 0)
  
    if waves == waves_used then 'Impressed' else 'Oops!' end
  end
  
  def run_through_forest(forest, curr_row, curr_col, curr_waves)
    #Check current position
    if forest[curr_row][curr_col] == '*'
      return curr_waves
    end
    #mark as visited
    forest[curr_row][curr_col] = 'o'
  
    #Check each direction
    directions = 0
    check_north = false
    check_south = false
    check_east = false
    check_west = false
    #NORTH
    if curr_row - 1 >= 0 && !forest[curr_row - 1][curr_col].nil? && (forest[curr_row - 1][curr_col] == '.' || forest[curr_row - 1][curr_col] == '*')
      check_north = true
      directions += 1
    end
    #SOUTH
    if curr_row + 1 < forest.length && !forest[curr_row + 1][curr_col].nil? && (forest[curr_row + 1][curr_col] == '.' || forest[curr_row + 1][curr_col] == '*')
      check_south = true
      directions += 1
    end
    #EAST
    if curr_col + 1 < forest[0].length && !forest[curr_row][curr_col + 1].nil? && (forest[curr_row][curr_col + 1] == '.' || forest[curr_row][curr_col + 1] == '*')
      check_east = true
      directions += 1
    end
    #WEST
    if curr_col - 1 >= 0 && !forest[curr_row][curr_col - 1].nil? && (forest[curr_row][curr_col - 1] == '.' || forest[curr_row][curr_col - 1] == '*')
      check_west = true
      directions += 1
    end
  
    #If we're at a fork, wave wand like a nerd
    increase_waves_by = 0
    if directions > 1
      increase_waves_by = 1
    end
    return (check_north ? run_through_forest(forest, curr_row - 1, curr_col, curr_waves + increase_waves_by) : 0) +
      (check_south ? run_through_forest(forest, curr_row + 1, curr_col, curr_waves + increase_waves_by) : 0) +
      (check_east ? run_through_forest(forest, curr_row, curr_col + 1, curr_waves + increase_waves_by) : 0) +
      (check_west ? run_through_forest(forest, curr_row, curr_col - 1, curr_waves + increase_waves_by) : 0)
  end
  
  t = gets.to_i
  for i in 0...t
    forest = []
    hermione = {}
    n, m = gets.chomp.split(' ').map{|g| g.to_i}
    for j in 0...n
      forest_row = gets.chomp.split('')
      loc = forest_row.index 'M'
      if loc.nil?.!
        hermione[:row] = j
        hermione[:col] = loc
      end
      forest << forest_row
    end
    wand_waves = gets.to_i
    
    puts navigate_forest(forest, hermione, wand_waves)
  end
  