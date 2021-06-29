# Hacker Rank Challenge based on Pyhton 2

INF = 999999999999999999L
EPS = 1e-12

def read():
    return raw_input().strip()

def read_ints():
    return map(int,read().split())
    
def contains(chars, word):
    for c in chars:
        if c in word:
            return True
    return False 

numbers = "0123456789"
lower_case = "abcdefghijklmnopqrstuvwxyz"
upper_case = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
special_characters = "!@#$%^&*()-+"

n = int(read())
word = read()

if n < 6:
    val1 = 6-n
else:
    val1 = 0
    
if not contains(numbers,word):
    val2 = 1 
else:
    val2 = 0 
if not contains(lower_case,word):
    val2 += 1 
if not contains(upper_case,word):
    val2 += 1 
if not contains(special_characters,word):
    val2 += 1 
    
print max(val1,val2)

