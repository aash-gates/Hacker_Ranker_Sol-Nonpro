def activityNotifications(expenditure, d):
    total = 0
    counts = [0] * 201

    for day in range(d):
        counts[expenditure[day]] += 1

    if d%2 == 0: #even
        odd = False
    else: #odd
        odd = True

    oldest_day = 0
    for i in range(d, len(expenditure)):
        median = get_median(counts, odd, d)
        if expenditure[i] >= 2*median:
            total += 1
        counts[expenditure[oldest_day]] -= 1
        counts[expenditure[i]] += 1
        oldest_day += 1
    return total

def get_median(counts, odd, d):
    temp = 0
    left, right = -1, -1
    for i, v in enumerate(counts):
        temp += v
        if odd:
            if temp >= ((d//2)+1):
                return i
        else:
            if temp >= (d//2):
                left = i
            if temp > (d//2) and left != -1:
                right = i
                return (left + right) // 2
            if temp > (d//2) and left == -1:
                return i