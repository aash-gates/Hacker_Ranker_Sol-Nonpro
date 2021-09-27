<?php
$_fp = fopen("php://stdin", "r");
$tests = intval(fgets($_fp));
for( $i = 0; $i < $tests; $i++ )
{
    $a = array_map('intval', explode(' ', fgets($_fp)));
