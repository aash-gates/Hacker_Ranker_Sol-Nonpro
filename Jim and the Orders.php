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
    if ($aArr[1] > $bArr[1]) {
        return 1;
    } elseif ($aArr[1] < $bArr[1]) {
        return -1;
    } elseif ($aArr[0] > $bArr[0]) {
        return 1;
    } elseif ($aArr[0] < $bArr[0]) {
        return -1;
    }
    return 0;
});
