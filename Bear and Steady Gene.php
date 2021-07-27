<?php
fscanf(STDIN, "%d", $n);
$s = str_split(trim(fgets(STDIN)));
$a = array("A" => 0, "T" => 0, "C" => 0, "G" => 0);
$b = $a;
foreach ($s as $ch) $a[$ch]++;

foreach ($a as $k => &$v) $v -= $n >> 2;
unset($v);

function isok()
{
    global $a, $b;
    return $b["A"] >= $a["A"] && $b["T"] >= $a["T"] && $b["C"] >= $a["C"] && $b["G"] >= $a["G"];
}

$ans = PHP_INT_MAX;
// [left, right)
for ($left = 0, $right = 0; $right <= $n; $right++) {
    while ($left < $right && $b[$s[$left]] - 1 >= $a[$s[$left]]) $b[$s[$left++]]--;
    if (isok()) $ans = min($ans, $right - $left);
    if ($right < $n) $b[$s[$right]]++;
}

echo $ans . "\n";
