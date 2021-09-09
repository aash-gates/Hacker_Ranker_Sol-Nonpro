<?php

/*
 * Complete the treeFlow function below.
 */
function treeFlow($n, &$connectMap) {
    $start = 1;
    $end = $n;
    
   
    $queue = new SplFixedArray($n + 1);
    
    $disMap = new SplFixedArray($n + 1);
    processDis($start, $disMap, $connectMap, $queue, $n);
    
   
    $reDisMap = new SplFixedArray($n + 1);
    processDis($end, $reDisMap, $connectMap, $queue, $n);
    
    
    
    $result = 0;
    $remain = 0;
    $lack = 0;
    
    for ($i = 2; $i < $n; $i++) {
        
        $diff = $disMap[$i] - $reDisMap[$i];
        if ($diff >= 0) {
            $result += $reDisMap[$i];
            $remain += $diff;
        } else {
            $result += $disMap[$i];
            $lack -= $diff;
        }
    }
    
    
    $result += min($remain, $lack);
    $result += $disMap[$end];
    return $result;
}


function processDis($startNode, &$distanceMap, &$connectMap, &$queue, $n)
{
    $nowIndex = 0;
    $endIndex = 0;
    $flagArr = new SplFixedArray($n + 1);
    $queue[$endIndex++] = $startNode.",0"; 
    $flagArr[$startNode] = true;
    
    while ($nowIndex < $endIndex) {
        $item = explode(',', $queue[$nowIndex]);
        $nowNode = intval($item[0]);
        $nowDis = intval($item[1]);
        unset($queue[$nowIndex++]);
        $distanceMap[$nowNode] = $nowDis;
        foreach ($connectMap[$nowNode] as $nextNode => $dis) { 
            if (isset($flagArr[$nextNode])) {
                continue;
            }
            $queue[$endIndex++] = $nextNode.",".($nowDis + $dis);
            $flagArr[$nextNode] = true;
        }
    }
}

$fptr = fopen(getenv("OUTPUT_PATH"), "w");

$stdin = fopen("php://stdin", "r");

fscanf($stdin, "%d\n", $n);


$connectMap = [];
for ($tree_row_itr = 0; $tree_row_itr < $n-1; $tree_row_itr++) {
    fscanf($stdin, "%[^\n]", $tree_temp);
    $item = array_map('intval', preg_split('/ /', $tree_temp, -1, PREG_SPLIT_NO_EMPTY));
    $connectMap[$item[0]][$item[1]] = $connectMap[$item[1]][$item[0]] = $item[2];
}

$result = treeFlow($n, $connectMap);

fwrite($fptr, $result . "\n");

fclose($stdin);
fclose($fptr);
