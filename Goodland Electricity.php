<?php
$_fp = fopen("php://stdin", "r");
$config = explode(' ', trim(fgets($_fp)));
$n = intval($config[0]);
$k = intval($config[1]);
$arr = explode(' ', trim(fgets($_fp)));
$needLight = 0;
$answer = 0;
$impossible = false;
while ($needLight < $n && !$impossible) {
    $dark = true;
    for ($i = min($n - 1, $needLight + $k - 1); $i >= max(0, $needLight - $k + 1); $i--) {
        if ($arr[$i] && $dark) {
            $dark = false;
            $needLight = $i + $k;
            $answer++;
            break;
        }
    }
    if ($dark) {$impossible = true; break;}
}
