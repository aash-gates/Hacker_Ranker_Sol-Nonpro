<?php

$handle = fopen ("php://stdin","r");
fscanf($handle,"%d",$n);

$a_temp = fgets($handle);

$a = explode(" ",$a_temp);

array_walk($a,'intval');

