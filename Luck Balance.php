<?php
list($n, $k) = array_map("intval", explode(" ", trim(fgets(STDIN))));
$contests = array();
for ($i = 0; $i < $n; $i++) {
  $contests[] = array_map("intval", explode(" ", trim(fgets(STDIN))));
}

$important = array();
