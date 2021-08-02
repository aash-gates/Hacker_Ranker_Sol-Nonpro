use strict;
use Data::Dumper;
use List::Util qw(min max);


my $t = <STDIN>;
chomp($t);

my @data = ();

my $s = 0;

for (1..$t) {
    $_ = <STDIN>;
    chomp;
    my ($d, $m) = split " ";
    $d += 0;
    $m += 0;

    my $a = 0;
    my $b = @data;

    while ($a < $b) {
        my $c = ($a + $b) >> 1;
        if ($data[$c][0] < $d) {
            $a = $c+1;
        } else {
            $b = $c;
        }
    }

    if ($a < @data && ($data[$a][0] == $d || ($a ? $data[$a-1][0]+$data[$a-1][1]+$m-$d : $m-$d) <= $data[$a][1])) {
        $data[$a][1] += $m;
    } else {
        splice(@data, $a, 0, [$d, $a ? $data[$a-1][0]+$data[$a-1][1]+$m-$d : $m-$d]);
    }

    my $c = $data[$a];
    my $k = $$c[1];
    $s = $k if $s < $k;

    while ($a && $data[$a-1][1] <= $data[$a][1]) {
        --$a;
        splice(@data, $a, 1);
    }

    ++$a;
    while ($a < @data) {
        $data[$a][1] += $m;

        my $c = $data[$a];
        my $k = $$c[1];
        $s = $k if $s < $k;

        ++$a;
    }


    print $s, "\n";
}
