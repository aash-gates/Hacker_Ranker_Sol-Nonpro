<?php

/*
 * Complete the computerGame function below.
 */
function computerGame($a, $b) {
    
    //找所有素数
    $primes = getPrimes(1000000000);
    $primeMap = array_flip($primes);
    $multiMap = [];
    foreach ($primes as $prime) {
        $multiMap[$prime] = $prime * $prime;
    }
    
    $n = count($a);
    
    // 素数到数组b的映射, 每个素数能整除的数组b元素
    $primeDivbMap = [];
    for ($i = 0; $i < $n; $i++) {
        $num = $b[$i];
        
        if (isset($primeMap[$num])) {
            $primeDivbMap[$num][] = $i;
            continue;
        }
        
        foreach ($primes as $prime) {
            if ($multiMap[$prime] > $num) {
                break;
            }

            if ($num % $prime == 0) {
                $primeDivbMap[$prime][] = $i;
                do {
                    $num /= $prime;
                } while ($num % $prime == 0);
                
                if (isset($primeMap[$num])) {
                    break;
                }
            }
        }
        
        //多出来的这个肯定是素数
        if ($num > 1) {
            $primeDivbMap[$num][] = $i;
        }
    }
    
    // 数组a 到 素数的映射, 数组a里每个数包含的质因数列表
    $acontainPrimeMap = [];
    for ($i = 0; $i < $n; $i++) {
        $num = $a[$i];
        if (isset($primeDivbMap[$num])) {
            $acontainPrimeMap[$i] = [$num];
            continue;
        }
        
        $temp = [];
        foreach ($primes as $prime) {
            if ($multiMap[$prime] > $num) {
                break;
            }

            if ($num % $prime == 0) {
                isset($primeDivbMap[$prime]) && ($temp[] = $prime);
                do {
                    $num /= $prime;
                } while ($num % $prime == 0);
                
                if (isset($primeDivbMap[$num])) {
                    break;
                }
            }
        }
        
        isset($primeDivbMap[$num]) && ($temp[] = $num);
        //usort($temp, function($l, $m) use ($primeDivbMap){ return count($primeDivbMap[$l]) - count($primeDivbMap[$m]);});
        ($temp) && ($acontainPrimeMap[$i] = array_reverse($temp));
    }
    
    uasort($acontainPrimeMap, function($t1, $t2){ return count($t1) - count($t2);});
    
    //var_dump($primeDivbMap);exit;
    //对于每个a中元素,如下两种情况算能找到一个b中元素
    // 1 此元素还未被a中其他元素选中
    // 2 此元素被选中了,但是选中它的a中元素还能找到其他的b中元素,则取代之(递归处理)
    
    //第二阶段，递归取代，并且记录
    $result = 0;
    $bMatchaMap = [];
    
    $aselectFlagArr = [];
    $areplaceFlagArr = [];
    $pselectFlagArr = [];
    $preplaceFlagArr = [];
    foreach($acontainPrimeMap as $i => $dummy) {
        $nowaArr = [];
        $nowpArr = [];
        if (isset($acontainPrimeMap[$i]) && canFind($i, $acontainPrimeMap, $primeDivbMap, $bMatchaMap, $aselectFlagArr, $areplaceFlagArr, $pselectFlagArr, $preplaceFlagArr, $nowaArr, $nowpArr)) {
            $result++;
        }
    }
    
    return $result;
}

function getPrimes($value)
{
    $primes = [3];
    
    $maxValue = intval(sqrt($value)) + 1;
    for ($i = 5; $i <= $maxValue; $i += 2) {
        $isPrime = true;
        $half = $i >> 1;
        foreach ($primes as $prime) {
            if ($prime > $half) {
                break;
            }
            
            if ($i % $prime == 0) {
                $isPrime = false;
                break;
            }
        }
        
        if ($isPrime) {
            $primes[] = $i;
        }
    }
    
    array_unshift($primes, 2);
    
    return $primes;
}

/*
 * index 当前寻找的a中元素
 * acontainPrimeMap 数组a里每个数包含的质因数列表
 * primeDivbMap 每个素数能整除的数组a元素
 * bMatchaMap 已经找到的映射  b中元素 => a中元素
 * aselectFlagArr a中元素，找未选中的元素，当前遍历的位置
 * areplaceFlagArr a中元素，找可替换的元素，当前遍历的位置
 * pselectFlagArr 每个素数，找未选中的元素，当前遍历的位置
 * replaceFlagArr 每个素数，找可替换的元素，当前遍历的位置
 */
function canFind($index, &$acontainPrimeMap, &$primeDivbMap, &$bMatchaMap, &$aselectFlagArr, &$areplaceFlagArr, &$pselectFlagArr, &$preplaceFlagArr, &$nowaArr, &$nowpArr)
{
    $nowaArr[$index] = true;
    // 找还未选中的元素
    $alen = count($acontainPrimeMap[$index]);
    
    $abegin = isset($aselectFlagArr[$index]) ? $aselectFlagArr[$index] : 0;
    for ($i = $abegin; $i < $alen; $i++) {
        $prime = $acontainPrimeMap[$index][$i];
        $primeLen = count($primeDivbMap[$prime]);
        
        $primeBegin = isset($pselectFlagArr[$prime]) ? $pselectFlagArr[$prime] : 0;
        for ($j = $primeBegin; $j < $primeLen; $j++) {
            $bindex = $primeDivbMap[$prime][$j];
            $pselectFlagArr[$prime] = $j + 1;
            if ( ! isset($bMatchaMap[$bindex])) {
                $bMatchaMap[$bindex] = $index;
                return true;
            }
        }
        
        $aselectFlagArr[$index] = $i + 1;
    }
    
    // 找能替换的元素
    $abegin = isset($areplaceFlagArr[$index]) ? $areplaceFlagArr[$index] : 0;
    for ($i = $abegin; $i < $alen; $i++) {
        $prime = $acontainPrimeMap[$index][$i];
        
        if (isset($nowpArr[$prime])) {
            continue;
        }
        $nowpArr[$prime] = true;
        
        $primeLen = count($primeDivbMap[$prime]);
        $primeBegin = isset($preplaceFlagArr[$prime]) ? $preplaceFlagArr[$prime] : 0;

        for ($j = $primeBegin; $j < $primeLen; $j++) {
            $bindex = $primeDivbMap[$prime][$j];
            
            if (isset($nowaArr[$bMatchaMap[$bindex]])) {
                continue;
            }
            if (canFind($bMatchaMap[$bindex], $acontainPrimeMap, $primeDivbMap, $bMatchaMap, $aselectFlagArr, $areplaceFlagArr, $pselectFlagArr, $preplaceFlagArr, $nowaArr, $nowpArr)) {
                $bMatchaMap[$bindex] = $index;
                return true;
            }
            
            $preplaceFlagArr[$prime] = $j + 1;
        }
        
        $areplaceFlagArr[$index] = $i + 1;
    }
    
    return false;
}

$fptr = fopen(getenv("OUTPUT_PATH"), "w");

$stdin = fopen("php://stdin", "r");

fscanf($stdin, "%d\n", $n);

fscanf($stdin, "%[^\n]", $a_temp);

$a = array_map('intval', preg_split('/ /', $a_temp, -1, PREG_SPLIT_NO_EMPTY));

fscanf($stdin, "%[^\n]", $b_temp);

$b = array_map('intval', preg_split('/ /', $b_temp, -1, PREG_SPLIT_NO_EMPTY));

$result = computerGame($a, $b);

fwrite($fptr, $result . "\n");

fclose($stdin);
fclose($fptr);
