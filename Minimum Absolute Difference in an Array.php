<?php

$handle = fopen ("php://stdin","r");
fscanf($handle,"%d",$n);

$a_temp = fgets($handle);

$a = explode(" ",$a_temp);

array_walk($a,'intval');

// the Yoruba's say: gidigba o shi ilekun :-)
sort($a, SORT_NUMERIC); $asort = $a;

// set diff to value higher than max possible integer
