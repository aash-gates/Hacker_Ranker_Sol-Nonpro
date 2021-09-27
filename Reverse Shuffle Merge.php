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
$freqSeen = array_combine(array_keys($freq), array_fill(0, count($freq), 0));
$written = $freqSeen;
$nextToUse = $freqSeen;
$needs = [];
for ($j = $strLength-1; $j >= 0; $j--) {
    if ($freqSeen[$S[$j]] < $freq[$S[$j]]) {
        $needs[$j] = $freq[$S[$j]] - $freqSeen[$S[$j]];
    } else {
        $needs[$j] = 0;
    }
    $freqSeen[$S[$j]]++;
}

ksort($freq);
$minLetter = abs(ord(key($freq)) - 97);
$next_bottleneck = 0;
$lastPos = 0;
$out = '';

while (strlen($out) != count($S)/2) {

    while ($written[$S[$next_bottleneck]] >= $needs[$next_bottleneck]) {
        $next_bottleneck++;
    }

    $nextChar = $minLetter;

    while ($written[chr($nextChar+97)] == $freq[chr($nextChar+97)] ||
        $positions[chr($nextChar+97)][$nextToUse[chr($nextChar+97)]] > $next_bottleneck) {
        $nextChar++;
        if (!isset($written[chr($nextChar+97)])) {
            $nextChar++;
            continue;
        }
    }

    $strPos = $positions[chr($nextChar+97)][$nextToUse[chr($nextChar+97)]];

    while ($lastPos != $strPos) {
        $nextToUse[$S[$lastPos]]++;
        $lastPos++;
    }

    do {
        $out .= chr($nextChar + 97);
        $written[chr($nextChar + 97)]++;
        $nextToUse[chr($nextChar + 97)]++;
    } while ($written[chr($nextChar + 97)] < $needs[$strPos]);
