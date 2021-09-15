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
        if($a+$b>$c && $a+$c>$b && $b+$c>$a) {
            $p=$a+$b+$c;
            if(empty($max)) {
                $max=$p;
                $found[]=array($a, $b, $c);
                $max_a=$a;
                $max_c=$c;
                $a=null;
                $b=null;
                $c=null;
            } elseif($p==$max) {
                if($a==$max_a && $c==$max_c) {
                    $found[]=array($a, $b, $c);
                    $a=null;
                    $b=null;
                    $c=null;
                } elseif($a>$max_a) {
                    $found=array();
                    $found[]=array($a, $b, $c);
                    $max_a=$a;
                    $max_c=$c;
                    $a=null;
                    $b=null;
                    $c=null;
                } elseif($a==$max_a) {
                    if($c>$max_c) {
                        $found=array();
                        $found[]=array($a, $b, $c);
                        $a=null;
                        $b=null;
                        $c=null;
                        $max_a=$a;
                        $max_c=$c;
                    }
                }
            }
        } else {
            $c=$b;
            $b=$a;
            $a=null;
        }
    }
    
}

if(empty($found))
    echo -1;
else {
    $found=$found[0];
    $str=implode(' ', $found);
    echo $str;
