import itertools

n1,n2,n3 = list(map(int, input().strip().split(' ')))
n4,n5,n6 = list(map(int, input().strip().split(' ')))
n7,n8,n9 = list(map(int, input().strip().split(' ')))

l = [n1,n2,n3,n4,n5,n6,n7,n8,n9]
tests = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
def im(l):
    sums = [l[i[0]] + l[i[1]] + l[i[2]] for i in tests]
    return len(set(sums)) == 1

squares = [(2, 7, 6, 9, 5, 1, 4, 3, 8),
(2, 9, 4, 7, 5, 3, 6, 1, 8),
(4, 3, 8, 9, 5, 1, 2, 7, 6),
(4, 9, 2, 3, 5, 7, 8, 1, 6),
(6, 1, 8, 7, 5, 3, 2, 9, 4),
(6, 7, 2, 1, 5, 9, 8, 3, 4),
(8, 1, 6, 3, 5, 7, 4, 9, 2),
(8, 3, 4, 1, 5, 9, 6, 7, 2)]
r = []
for i in squares:
    if im(i):
        cost = sum([abs(l[j] - i[j]) for j in range(9)])
        r.append(cost)
print(min(r))