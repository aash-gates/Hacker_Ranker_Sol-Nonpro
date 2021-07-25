from collections import Counter # 콜렉션에서 불러옵니다.
from math import factorial

# 홀수개의 2로 나눈 나머지들의 개수
s = input()
for _ in range(int(input())):
    l, r = map(int, input().split())
    print(s[l-1:r])
    count_s = Counter(s[l-1:r])
    print(count_s)
    odd_number = 0

    sum_of_even_numbers_factorial = 1
    sum_of_even_number = 0
    for i in count_s:
        sum_of_even_numbers_factorial *= factorial(count_s[i]//2)
        sum_of_even_number += count_s[i]//2
        if count_s[i]%2 == 1 :# 홀수인것은 더해줘야한다.
            odd_number += 1

    ans = 0
    if odd_number == 0:
        ans = factorial(sum_of_even_number) // sum_of_even_numbers_factorial
    else:
        ans = factorial(sum_of_even_number) // sum_of_even_numbers_factorial * odd_number

    print(ans % (10**9+7))
    # print('----------')
