<?php
$_fp = fopen("php://stdin", "r");
/* Enter your code here. Read input from STDIN. Print output to STDOUT */
    $line_of_text = fgets($_fp);
    $data = explode(' ', $line_of_text);
    $N = (int)$data[0];
