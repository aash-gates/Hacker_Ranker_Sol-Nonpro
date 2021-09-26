<?php

    $fp = fopen('php://stdin', 'rb');
	list($numItems, $numSwaps) = explode(' ', trim(fgets($fp)));
