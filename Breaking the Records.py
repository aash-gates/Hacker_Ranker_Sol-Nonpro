n = int(input().strip())
score = list(map(int, input().strip().split(' ')))

max_score = score[0]
min_score = score[0]

ans1 = 0
ans2 = 0
for val in score:
    if val > max_score:
        max_score = val
        ans1 = ans1 + 1
    if val < min_score:
        min_score = val
        ans2 = ans2 + 1
print(ans1, ans2)