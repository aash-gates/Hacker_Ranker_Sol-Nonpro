<?php
fscanf(STDIN,"%s");
fscanf(STDIN,"%d",$kids);
while(fscanf(STDIN,"%d",$num)){$nums[]=$num;}
sort($nums);
$min=1<<63;
$min=~$min;
$i=0;
$j=$kids-1;
while($j<count($nums)){
    $diff=$nums[$j]-$nums[$i];
    if($diff<$min)
        $min=$diff;
    $i++;
    $j++;
}
echo "$min\n";    