<?php

    $fp = fopen('php://stdin', 'rb');
	list($numItems, $numSwaps) = explode(' ', trim(fgets($fp)));
    $items = explode(' ', trim(fgets($fp)));
    
    for($i = 0; $i < count($items); $i++) {
        $items[$i]--;
    }
    $numItems--;
    
    $itemsReverse = array_flip($items);
    
    for($i = 0; $i < $numItems; $i++) {
        $worstItemValue = $numItems - $i;
        
        if($items[$i] != $worstItemValue) {
            $worstItemPos = $itemsReverse[$worstItemValue];
            $firstItemValue = $items[$i];
            $firstItemPos = $i;

            $items[$firstItemPos] = $worstItemValue;
            $items[$worstItemPos] = $firstItemValue;
            
            $itemsReverse[$firstItemValue] = $worstItemPos;
            $itemsReverse[$worstItemValue] = $firstItemPos;
            
            $numSwaps--;
            if($numSwaps == 0) {
                break;
            }
        }
    }
    
    $result = '';
    for($i = 0; $i < count($items); $i++) {
        $result .= ($items[$i] + 1) . ' ';
    }
    trim($result);
    echo $result . PHP_EOL;
