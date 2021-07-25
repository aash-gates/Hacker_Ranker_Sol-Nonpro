import math
import os
import random
import re
import sys

# Complete the isValid function below.
def isValid(s):
    # Go over string and count how many times string occured
    char_dict = {}
    for char in s:
        if char in char_dict:
            char_dict[char] += 1
        else:
            char_dict[char] = 1
    #initiate largest and smallest count with last char
    min_count = char_dict[char]
    max_count = char_dict[char]
    # count how many times a count occured
    count_dict = {}
    for char, value in char_dict.items():
        if value in count_dict:
            count_dict[value] += 1
        else:
            count_dict[value] = 1
        #also update max and min count
        if value < min_count:
            min_count = value
        if value > max_count:
            max_count = value
    # final test:
    if len(count_dict) == 1:
        return 'YES'
    elif len(count_dict) == 2:
        if count_dict[max_count] == 1 and max_count - min_count == 1:
            return 'YES'
        elif count_dict[min_count] == 1 and min_count == 1:
            return 'YES'
    return 'NO'

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    s = input()

    result = isValid(s)

    fptr.write(result + '\n')

    fptr.close()