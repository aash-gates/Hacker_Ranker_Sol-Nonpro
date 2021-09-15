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
