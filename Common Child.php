<?php

$time_start = microtime(true); 

	$fp = fopen("php://stdin", "r");
	$word1 = trim(fgets($fp));
	$word2 = trim(fgets($fp));
	$word_length = strlen($word1);

//////////
	
	$common_start = 0;
	$common_end = 0;
	for($i = 0; $i < $word_length; $i++) {
		if($word1[$i] == $word2[$i])
			$common_start++;
		else
			break;
	}
	for($i = 0; $i < $word_length; $i++) {
		if($word1[$word_length - 1 - $i] == $word2[$word_length - 1 - $i])
			$common_end++;
		else
			break;
	}
	
	$word_length = $word_length - ($common_start + $common_end);
	$word1 = substr($word1, $common_start, $word_length);
	$word2 = substr($word2, $common_start, $word_length);
	
	//echo $word1."\n".$word2."\n";
	//echo $common_start."\n".$common_end."\n";
	//exit();

//////////
	
	for($i = 0; $i < $word_length; $i++) {
		$word_diff[$i] = ord($word1[$i]) - ord($word2[$i]);
	}

	for($i = 0; $i <= $word_length; $i++) {
		$index = $i;
		$check_array[$i][0] = 0;
	}
	
	for($j = 0; $j <= $word_length; $j++) {
		$index = $j * $word_length;
		$check_array[0][$j] = 0;
	}
	
	for($i = 1; $i <= $word_length; $i++) {
		$mod_i = $i % 2;
		$mod_i_prev = ($i - 1) % 2;
		$letter_1 = $word1[$i - 1];
		for($j = 1; $j <= $word_length; $j++) {

			//if($word_diff[$i - 1] == 0) {
			if($letter_1 == $word2[$j - 1]) {
				$check_array[$mod_i][$j] = $check_array[$mod_i_prev][$j - 1] + 1;
			} else {
				//$check_array[$mod_i][$j] = max($check_array[$mod_i_prev][$j], $check_array[$mod_i][$j - 1]);
				$asdf_1 = $check_array[$mod_i_prev][$j];
				$asdf_2 = $check_array[$mod_i][$j - 1];
				if($asdf_1 > $asdf_2)
					$check_array[$mod_i][$j] = $asdf_1;
				else
					$check_array[$mod_i][$j] = $asdf_2;
			}			
		}
	}

	$i--;
	$j--;
	$mod_i = $i % 2;
	$result = $check_array[$mod_i][$j];
	$result += $common_start + $common_end;	
	echo $result."\n";
	
	$time_end = microtime(true);
	$execution_time = ($time_end - $time_start);
	//echo 'Time: '.$execution_time." s\n";
