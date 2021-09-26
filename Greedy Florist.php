<?php
 /* Enter your code here. Read input from STDIN. Print output to STDOUT */
    
fscanf(STDIN, "%d %d", $N,$K);
fscanf(STDIN, "%[ -~]", $string);
$explode=explode(" ",$string);

rsort($explode);

$total=0;
$tour=0;
$client=0;

foreach($explode as $value){

    $total+=$value*($tour+1);
    
    $client++;
    if($client == $K){
        $tour++;
        $client=0;
