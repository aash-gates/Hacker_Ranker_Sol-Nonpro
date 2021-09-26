<?php

    $fp = fopen('php://stdin', 'rb');
	list($numItems, $numSwaps) = explode(' ', trim(fgets($fp)));
    $items = explode(' ', trim(fgets($fp)));
    
    for($i = 0; $i < count($items); $i++) {
        $items[$i]--;
