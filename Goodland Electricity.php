<?php
$_fp = fopen("php://stdin", "r");
$config = explode(' ', trim(fgets($_fp)));
$n = intval($config[0]);
$k = intval($config[1]);
