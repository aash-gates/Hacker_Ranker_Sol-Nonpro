# Hacker Rank Challenge 5

def diagonalDifference(arr):
    d1 = sum([arr[x][x] for x in range(len(arr))])
    d2 = sum([arr[x][n - 1 - x] for x in range(len(arr))])
    return(abs(d1 - d2))

# end of the program
