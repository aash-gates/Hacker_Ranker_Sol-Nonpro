<?php
$_fp = fopen("php://stdin", "r");
/* Enter your code here. Read input from STDIN. Print output to STDOUT */

$n=intval(trim(fgets($_fp)));
$line=trim(fgets($_fp));
$arr=explode(' ', $line);
$arr=array_map('intval', $arr);
sort($arr);

$c=null;
$b=null;
$d=null;
$max=null;
$found=array();
$max_c=null;
$max_a=null;

for($i=$n-1; $i>=0; $i--) {
    if($i==$n-1 || empty($c)) {
        $c=$arr[$i];
    } elseif($i==$n-2 || empty($b)) {
        $b=$arr[$i];
    } else {
        $a=$arr[$i];
