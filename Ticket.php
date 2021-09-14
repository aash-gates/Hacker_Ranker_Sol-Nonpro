<?php
function ticket($desList, $customerList, $m)
{
    $disCount = 0.2;
    
    $desStrToIdMap = [];
    $priceMap = [];
    
    $k = count($desList);
    for ($i = 0; $i < $k; $i++) {
        $desStrToIdMap[$desList[$i][0]] = $i;
        $priceMap[$i] = intval($desList[$i][1]);
    }
    
    
    $customerIdList = [];
    
    $normalPrice = 0;
    $n = count($customerList);
    for ($i = 0; $i < $n; $i++) {
        $destId = $desStrToIdMap[$customerList[$i]];
        $customerIdList[] = $destId;
        $normalPrice += $priceMap[$destId];
    }
    
    $start = 0;
    $end = 2 * $n + 1;
    
    
    $edges = [];
    
    
    for ($i = 0; $i < $n; $i++) {
        
        addEdge($edges, $start, $i + 1, 1, 0);
        
        addEdge($edges, $n + $i + 1, $end, 1, 0);
    }
    
    
    for ($i = 0; $i < $n; $i++) {
        for ($j = $i + 1; $j < $n; $j++) {
            addEdge($edges, $i + 1, $n + $j + 1, 1, 
                    $customerIdList[$i] == $customerIdList[$j] ? -$priceMap[$customerIdList[$i]] : 0);
        }
    }
    

    $realPreMap = [];
    $realAfterMap = [];
    
    $discountPrice = 0;
    $t1 = microtime(true);
    for ($i = 1; $i < $n; $i++) {
        $preMap = [];
        $disMap = [];
        $t1 = microtime(true);
        spfa($edges, $disMap, $preMap, $start, $end);
        
        if ($disMap[$end] == 500003) {
            break;
        }
        
    
        if ($disMap[$end] >= 0 && $i > $n - $m) {
            break;
        }
        
        $discountPrice += $disMap[$end];
        
        for ($j = $end; $j != $start; $j = $preMap[$j]) {
        
            if ( $j > $n && $j != $end) {
                $realPreMap[$j - $n] = $preMap[$j];
                $realAfterMap[$preMap[$j]] = $j - $n;
            }
            
        
            $edges[$preMap[$j]][$j][0] = 0;
            $edges[$j][$preMap[$j]][0] = 1;
        }
    }
    

    $queueMap = [];
    $index = 1;

    for ($i = 1; $i <= $n; $i++) {
        if (isset($realAfterMap[$i])) {
            continue;
        }
        
        $j = $i;
        $queueMap[$j] = $index;
        
        while (isset($realPreMap[$j])) {
            $j = $realPreMap[$j];
            $queueMap[$j] = $index;
        }
        
        $index++;
    } 

    $result = [];
    
    $result[] = $normalPrice + $disCount * $discountPrice;
    for ($i = 1; $i <= $n; $i++) {
        $result[] = $queueMap[$i];
    }
    
    return $result;
}

function addEdge(&$edges, $from, $to, $flow, $cost)
{
    
    $edges[$from][$to] = [$flow, $cost];
    
    
    $edges[$to][$from] = [0, -$cost];
}

function spfa(&$edges, &$disMap, &$preMap, $startIndex, $end)
{
    $queue = [];
    
    $inQueueMap = [];
    
    $disMap[$startIndex] = 0;
    $nowIndex = 0;
    $count = 1;
    $queue[] = $startIndex;

    while ($nowIndex < $count) {
        $now = $queue[$nowIndex++];
        unset($inQueueMap[$now]);
        
        if ($now == $end) {
            continue;
        }
        
        foreach ($edges[$now] as $to => $item) {
            if ( ! $item[0]) {
                continue;
            }
            
            $tempDis = $disMap[$now] + $item[1];
            if ( ! isset($disMap[$to]) || $disMap[$to] > $tempDis) {
                $disMap[$to] = $tempDis;
                $preMap[$to] = $now;
                
                if ( ! isset($inQueueMap[$to])) {
                    $queue[] = $to;
                    $count++;
                    $inQueueMap[$to] = true;
                }
            }
        }
    }
}

$fptr = fopen(getenv("OUTPUT_PATH"), "w");
$stdin = fopen('php://stdin', "r");

$temp = explode(' ', rtrim(fgets($stdin)));

$n = intval($temp[0]);

$m = intval($temp[1]);

$k = intval($temp[2]);

$desList = [];
for ($i = 0; $i < $k; $i++) {
    $desList[] = explode(' ', rtrim(fgets($stdin)));
}

$customerList = [];
for ($i = 0; $i < $n; $i++) {
    $customerList[] = rtrim(fgets($stdin));
}

$result = ticket($desList, $customerList, $m);

fwrite($fptr, implode("\n", $result) . "\n");

fclose($stdin);
fclose($fptr);