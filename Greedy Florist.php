<?php
 /* Enter your code here. Read input from STDIN. Print output to STDOUT */
    
fscanf(STDIN, "%d %d", $N,$K);
fscanf(STDIN, "%[ -~]", $string);
$explode=explode(" ",$string);

rsort($explode);

$total=0;
$tour=0;
