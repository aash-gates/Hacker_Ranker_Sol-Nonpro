<?php

$n = trim( fgets( STDIN ) );

for( $i = 0; $i < $n; $i++ ) {
    $c = trim( fgets( STDIN ) );
    $flavors = array();
    
    $l = trim( fgets( STDIN ) );
    $flavorsPrices = explode( ' ', trim( fgets( STDIN ) ) );
    foreach( $flavorsPrices as $j => $price ) {
        $index = $j + 1;
        if( isset( $flavors[ $c - $price ] ) ) {
            echo "{$flavors[ $c - $price]} $index\n"; 
            break;
        }
        
        $flavors[ $price ] = $index;
    }
    
}