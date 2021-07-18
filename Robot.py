import os
import sys

def best_total_score(config):
    N, V, P = config
    routes = [(0, 0)] #start state is step = 1(implied), energy = 0, accumulated score=0
    for step in range(1, N): #step = 1 through step = N - 1 : 2 cases, lose if energy becomes 0
        #all routes fail - will happen if P has 0 at beginning, or too many 0 in a row.
        if not routes:
            print("all routes failed")
            return None
        this_score = V[step - 1]
        this_energy = P[step-1]
        # all "take score" cases which are not better than each other continue to not be better than each other
        # V can have  - then the "take energy" branch loses immediately.
        if this_energy > 0:
            #"take energy" option: energy becomes the same whatever it was before. so all states going to it become one, score is max of their scores.
            all_max_score = max([route_max_score for (energy, route_max_score) in routes])
            takeEnergy = (this_energy - 1, all_max_score)
            #then add "pick score" ones - only if they dont lose (e > 0) and are better than the "take energy" case.
            newRoutes = [(energy - 1, route_max_score + this_score) for (energy,  route_max_score) in routes if (energy > this_energy or (energy > 0 and route_max_score+this_score > all_max_score))]
            newRoutes.append(takeEnergy)
        else:
            newRoutes = [(energy - 1, route_max_score + this_score) for (energy, route_max_score) in routes if energy > 0]
        routes = newRoutes
    #step = N: only the plus score case, no energy >0 check
    this_score = V[N - 1]
    return max(route_max_score for (energy, route_max_score) in routes) + this_score

def robot(vp):
    N = len(vp)
    V = []
    P = []
    for [vi, pi] in vp:
        V.append(vi)
        P.append(pi)
    config = (N,V,P)
    return best_total_score(config)

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')
    n = int(input())
    vp = []
    for _ in range(n):
        vp.append(list(map(int, input().rstrip().split())))
    result = robot(vp)
    fptr.write(str(result) + '\n')
    fptr.close()