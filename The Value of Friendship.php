<?php

$handle = fopen ("php://stdin","r");
fscanf($handle,"%d",$t);
for($a0 = 0; $a0 < $t; $a0++){
    fscanf($handle,"%d %d",$n,$m);
	
	$conns = [];
    for($a1 = 0; $a1 < $m; $a1++){
        fscanf($handle,"%d %d",$x,$y);
        // your code goes here
		$conns[$x][$y] = $y;
		$conns[$y][$x] = $x;
    }
	
	$add = function ($key) use (&$conns, &$temp, &$cgrp) {
		$cgrp[] = $key;
		unset ($temp[$key]);
		$cox = $conns[$key];
		unset ($conns[$key]);
		if ($cox) {
			foreach ($cox as $to) {
				unset ($conns[$to][$key]);
				if (!$conns[$to]) unset ($conns[$to]);
			}
			$temp += $cox;
		}
	};
	
    $groups = [];
	while ($conns) {
		$cgrp = [];
		$key = array_keys ($conns)[0];
		$temp = [$key => $key];
		while ($temp) {
			$add (array_keys ($temp)[0]);
		}
		$groups[] = count ($cgrp);
	}
	rsort ($groups);
	
	$pos = 0;
	$total = 0;
	foreach ($groups as $group) {
		$pos += $group - 1;
		$total += $group * ($group + 1) * ($group - 1) / 3;
		$total += $group * ($group - 1) * ($m - $pos);
	}
	echo $total, "\n";
}

?>
