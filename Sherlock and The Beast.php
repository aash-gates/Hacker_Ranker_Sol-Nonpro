<?php
$n = fgets(STDIN);
for($p=0;$p<$n;$p++){
    $x = intval(fgets(STDIN));
    $found = false;
    $j = 0;
    for($i=0;$i<=$x;$i=$i+5){
        $j = floor(($x-$i)/3);
        if ((($j*3)+$i)==$x){
            $found = true;
            break;
        }
    }
    if ($found){
        $input = "";
        echo (str_pad($input, (3*$j), "5")).(str_pad($input, $i, "3"))."\n";
    } else {
        echo "-1\n";
    }
}
?>