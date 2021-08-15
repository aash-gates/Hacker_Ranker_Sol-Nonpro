<?php

function tollCostDigits($n, &$roadFrom, &$roadTo, &$roadWeight)
{
    //Connectivity Diagram
    $connectMap = [];
    $count = count($roadFrom);
    
    //Cached array used to speed up calculations
    $addCache = [];
    $reCache = [];
    for ($i = 0; $i <= 9; $i++) {
        for ($j = 0; $j <= 9; $j++) {
            //for ($k = 0; $k <= 9; $k++) {
                $addCache[$i][$j] = ($i + $j) % 10;
            //}
        }
        $reCache[$i] = (10 - $i) % 10;
    }
    
    for ($i = 0; $i < $count; $i++) {
        $weight = $roadWeight[$i] % 10;
        $rweight = $reCache[$weight];
        $connectMap[$roadFrom[$i]][$roadTo[$i]][$weight] = true;
        $connectMap[$roadTo[$i]][$roadFrom[$i]][$rweight] = true;
    }
    
    $resultArr = [];
    for ($i = 0; $i <= 9; $i++) {
        $resultArr[$i] = 0;
    }
    
    $inGroupFlag = [];
    for ($i = 1; $i <= $n; $i++) {
        if ( ! isset($inGroupFlag[$i])) {
            calcuConnectDigits($resultArr, $inGroupFlag, $connectMap, $i, $addCache, $reCache);
        }
    }
    
    for ($i = 0; $i <= 9; $i++) {
        echo $resultArr[$i]."\n";
    }
}

function processDisAndCircle(&$disDigitsMap, &$groupMap, &$connectMap, &$nowQueueMap, $nowNode, $nowDis, &$firstNode, &$addCache, &$reCache)
{
    if ( ! isset($groupMap[$nowNode])) {
        $groupMap[$nowNode] = true;
    }
    if ( ! isset($connectMap[$nowNode])) {
        return;
    }
    
    foreach ($connectMap[$nowNode] as $nextNode => $nodeDisMap) { //For each subsequent node
        foreach ($nodeDisMap as $nextDis => $dummy) {
            $tempDis = $addCache[$nowDis][$nextDis];
            if ($nextNode == $firstNode) { // If it is the first node,form a ring,record
                $disDigitsMap[$nextNode][$tempDis] = true;
            } else {
                if (isset($nowQueueMap[$nextNode])) { // If there is a ring in the middle, set the mantissa of the ring to the starting mantissa. If it is the first node,form a ring,record
                    $disDigitsMap[$firstNode][$addCache[$nowQueueMap[$nextNode]][$reCache[$tempDis]]] = true;
                    continue;
                } else {
                    if (isset($disDigitsMap[$nextNode][$tempDis])) { // If the same mantissa has been recorded, no matter
                        continue;
                    }
                    // Not recorded,continue to traverse
                    $disDigitsMap[$nextNode][$tempDis] = true;
                    $nowQueueMap[$nextNode] = $tempDis;
                    processDisAndCircle($disDigitsMap, $groupMap, $connectMap, $nowQueueMap, $nextNode, $tempDis, $firstNode, $addCache, $reCache);
                    unset($nowQueueMap[$nextNode]);
                }
            }
        }
    }
}

function calcuConnectDigits(&$resultArr, &$inGroupFlag, &$connectMap, $firstNode, &$addCache, &$reCache)
{
    //From the starting point to each node, whether there is a distance between each mantissa
    $disDigitsMap = [];
    
    //Record all nodes belonging to this group
    $groupMap = [];
    
    $nowQueueMap = [];
    // Find the ring and all the paths you can reach
    processDisAndCircle($disDigitsMap, $groupMap, $connectMap, $nowQueueMap, $firstNode, 0, $firstNode, $addCache, $reCache);
    
    //From front to back, deal with the distance between the two in turn
    $nodes = array_keys($groupMap);
    $count = count($nodes);
    if (isset($disDigitsMap[$firstNode][1]) || isset($disDigitsMap[$firstNode][3])  || isset($disDigitsMap[$firstNode][7])  || isset($disDigitsMap[$firstNode][9]) ||
            ((isset($disDigitsMap[$firstNode][2]) || isset($disDigitsMap[$firstNode][4])  || isset($disDigitsMap[$firstNode][6])  || isset($disDigitsMap[$firstNode][8]) ) && isset($disDigitsMap[$firstNode][5]))) { // Two or two. All of them.
        $allNum = $count * ($count - 1);
        for ($i = 0; $i <= 9; $i++) {
            $resultArr[$i] += $allNum;
        }
    } else if (isset($disDigitsMap[$firstNode][2]) || isset($disDigitsMap[$firstNode][4])  || isset($disDigitsMap[$firstNode][6])  || isset($disDigitsMap[$firstNode][8]) ) { // All odd or even
        // Sort, even number first, odd number after
        $tempMap = [];
        for ($i = 0; $i <= 8; $i+=2) {
            $tempMap[$i] = 0;
            $tempMap[$i+1] = 1;
        }
        
        $t1 = 0;
        foreach ($nodes as $node) {
            $value = null;
            foreach ($disDigitsMap[$node] as $dis => $dummy) {
                $value = $tempMap[$dis];
                break;
            }
            if ($value === 0) {
                $t1++;
            }
        }
        
        $t2 = $count - $t1;
        
        $oddSum = 2 * $t1 * $t2;
        $evenSum = $t1 * ($t1 - 1) + $t2 * ($t2 - 1);
        
        for ($i = 0; $i <= 8; $i+=2) {
            $resultArr[$i] += $evenSum;
            $resultArr[$i+1] += $oddSum;
        }
    } else if (isset($disDigitsMap[$firstNode][5])) { //Separated by 5
        $tempMap = [];
        $retempMap = [];
        for ($i = 0; $i <= 4; $i++) {
            $tempMap[$i] = $tempMap[$i+5] = $i;
            $retempMap[$i] = [$i, $i + 5];
        }
        
        //Record the mantissa that can be generated for each of the two groups
        $groupTailMap = [];
        for ($i = 0; $i < 4; $i++) {
            for ($j = $i + 1; $j <= 4; $j++) {
                $ttt = [];
                foreach ($retempMap[$i] as $t1) {
                    foreach ($retempMap[$j] as $t2) {
                        $addTemp = $addCache[$t1][$reCache[$t2]];
                        $ttt[$addTemp] = true;
                    }
                }
                $groupTailMap[$i][$j] = array_keys($ttt);
            }
        }
        
        $countMap = [0, 0, 0, 0, 0];
        foreach ($nodes as $node) {
            $value = null;
            foreach ($disDigitsMap[$node] as $dis => $dummy) {
                $value = $tempMap[$dis];
                break;
            }
            $countMap[$value]++;
        }
        
        $selfCount = 0;
        for ($i = 0; $i <= 4; $i++) {
            $selfCount += $countMap[$i] * ($countMap[$i] - 1);
        }
        $resultArr[0] += $selfCount;
        $resultArr[5] += $selfCount;
        
        for ($i = 0; $i < 4; $i++) {
            if ($countMap[$i] == 0) {
                continue;
            }
            for ($j = $i + 1; $j <= 4; $j++) {
                if ($countMap[$j] == 0) {
                    continue;
                }
                
                $addValue = $countMap[$i] * $countMap[$j];
                foreach ($groupTailMap[$i][$j] as $tail) {
                    $resultArr[$tail] += $addValue;
                    $resultArr[$reCache[$tail]] += $addValue;
                }
            }
        }
    } else { //All 0s, each node may only have one value from the starting point
        $countMap = [];
        for ($i = 0; $i <= 9; $i++) {
            $countMap[$i] = 0;
        }
        
        foreach ($nodes as $node) {
            $value = null;
            foreach ($disDigitsMap[$node] as $dis => $dummy) {
                $value = $dis;
                break;
            }
            $countMap[$value]++;
        }
        
        // Inside the same value, pairwise combination
        $selfCount = 0;
        for ($i = 0; $i <= 9; $i++) {
            $selfCount += $countMap[$i] * ($countMap[$i] - 1);
        }
        $resultArr[0] += $selfCount;
        
        // Between different values
        for ($i = 0; $i < 9; $i++) {
            if ($countMap[$i] == 0) {
                continue;
            }
            for ($j = $i + 1; $j <= 9; $j++) {
                if ($countMap[$j] == 0) {
                    continue;
                }
                
                $addValue = $countMap[$i] * $countMap[$j];
                $tail = $addCache[$i][$reCache[$j]];
                
                $resultArr[$tail] += $addValue;
                $resultArr[$reCache[$tail]] += $addValue;
            }
        }
    }
    
    //Identified as an existing group
    foreach ($nodes as $node) {
        $inGroupFlag[$node] = true;
    }
}

$stdin = fopen("php://stdin", "r");

fscanf($stdin, "%d %d\n", $road_nodes, $road_edges);

$road_from = array();
$road_to = array();
$road_weight = array();

for ($i = 0; $i < $road_edges; $i++) {
    fscanf($stdin, "%d %d %d\n", $road_from_item, $road_to_item, $road_weight_item);

    $road_from[] = $road_from_item;
    $road_to[] = $road_to_item;
    $road_weight[] = $road_weight_item;
}


fclose($stdin);
tollCostDigits($road_nodes, $road_from, $road_to, $road_weight);
