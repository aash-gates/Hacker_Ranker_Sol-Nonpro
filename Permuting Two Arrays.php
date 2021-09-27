<?php
$_fp = fopen("php://stdin", "r");
$tests = intval(fgets($_fp));
for( $i = 0; $i < $tests; $i++ )
{
    list($cnt, $K) = explode(' ', fgets($_fp));
    $a = array_map('intval', explode(' ', fgets($_fp)));
    $b = array_map('intval', explode(' ', fgets($_fp)));
    sort($a);
