<?php
$S = trim(fgets(STDIN));
$strLength = strlen($S);
$S = str_split(strrev($S));
$positions = [];
for ($i = 0; $i < $strLength; $i++) {
