<?php
$_fp = fopen("php://stdin", "r");

$amount = 0;

fscanf(STDIN, "%d\n", $amount);

$custs = array();

for($i = 0; $i < $amount; $i++) {
    $custs[$i+1] = 0;
    fscanf(STDIN, "%d %d\n", $a, $b);
    $custs[$i+1] = ($i+1) . '|' . ($a+$b);
}
uasort($custs, function($a, $b){
    $aArr = explode('|', $a);
    $bArr = explode('|', $b);
