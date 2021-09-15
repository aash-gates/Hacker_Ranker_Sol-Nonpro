<?php
list($n, $k) = array_map("intval", explode(" ", trim(fgets(STDIN))));
$contests = array();
for ($i = 0; $i < $n; $i++) {
  $contests[] = array_map("intval", explode(" ", trim(fgets(STDIN))));
}

$important = array();
$luck = 0;
foreach ($contests as $contest) {
  if ($contest[1] == 1) {
    $important[] = $contest[0];
  } else {
    $luck += $contest[0];
  }
}
