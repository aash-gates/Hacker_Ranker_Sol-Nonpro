<?php
$_fp = fopen("php://stdin", "r");
/* Enter your code here. Read input from STDIN. Print output to STDOUT */
    $line_of_text = fgets($_fp);
    $data = explode(' ', $line_of_text);
    $N = (int)$data[0];
    $K = (int)$data[1];
    $line_of_text = fgets($_fp);
    $toysPrices = array_map('intval', explode(' ', $line_of_text));  
