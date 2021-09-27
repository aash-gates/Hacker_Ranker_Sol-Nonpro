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

    $Y=explode(" ",str_replace(PHP_EOL,"",fgets($fp)));
    $X=explode(" ",str_replace(PHP_EOL,"",fgets($fp)));
    
    sort($Y);
    sort($X);
    $cx=1;
    $cy=1;
    
 
    while(sizeof($Y)||sizeof($X)){
        $count=$count%$modulo;
        if(sizeof($Y)&&sizeof($X)){
            if($Y[sizeof($Y)-1]>$X[sizeof($X)-1]){
                $cy++;
