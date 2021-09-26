<?php
fscanf(STDIN,"%s");
fscanf(STDIN,"%d",$kids);
while(fscanf(STDIN,"%d",$num)){$nums[]=$num;}
sort($nums);
$min=1<<63;
