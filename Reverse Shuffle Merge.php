<?php
$S = trim(fgets(STDIN));
$strLength = strlen($S);
$S = str_split(strrev($S));
$positions = [];
for ($i = 0; $i < $strLength; $i++) {
    $positions[$S[$i]][] = $i;
}

$freq = array_count_values($S);
array_walk($freq, function (&$val) { $val /= 2; });
$written = $freqSeen;
