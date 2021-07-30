# Enter your code here. Read input from STDIN. Print output to STDOUT
use Data::Dumper;
use Math::BigInt;
$n = <>;
#@prices = map {Math::BigInt->new($_)} split / /,<>;
#$min = Math::BigInt->new(10000000000000000);
#$loss = Math::BigInt->new(0);
@prices = split / /,<>;
$min = 4000000000;
$loss = 0;
#for $i (0..$n-2) {
#    for $j ($i+1..$n-1) {
#        next if $prices[$j] >= $prices[$i];
#        $loss = $prices[$i] - $prices[$j];
#        $min = $loss if ($min > $loss);
#    }
#}

#print "$min\n";

%data = ();
for $i (0..$n-1) {
    $data{$prices[$i]} = $i; 
}

@prices = sort {$a <=> $b} @prices;
for $i (0..$n-2) {
  if ($data{$prices[$i]}> $data{$prices[$i+1]}) {
        $loss = $prices[$i+1] - $prices[$i];
        $min = $loss if ($min > $loss);
    }
     
}

print "$min\n";