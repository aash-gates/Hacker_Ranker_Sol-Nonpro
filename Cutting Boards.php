<?php
$fp = fopen("php://stdin", "r");

$modulo=1000000007;

$T=(int)fgets($fp);

for($z=0;$z<$T;$z++){
    $count=0;
    $MN=fgets($fp);
    $explode=explode(" ",$MN);
    $M=$explode[0];
    $N=(int)$explode[1];
