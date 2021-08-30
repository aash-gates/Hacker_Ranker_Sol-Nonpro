# Enter your code here. Read input from STDIN. Print output to STDOUT
#use Math::BigInt;
use Data::Dumper;
($N, $M) = split(/\s+/,<>);
@a = map {[ split/\s+/,<> ]} 1 .. $M;
@a = sort { $a->[2] <=> $b->[2] } @a;

@R = ();
$#R = $N+1;
@S = ();
$#S = $N+1;
sub clr {
    my $v = shift;
    $v = $R[$v] while $R[$v];
    return $v;
}

#%h = ();
#push( @{$h{$_->[0]}||=[]}, [$_->[1], $_->[2]] ) for @a;
#push( @{$h{$_->[1]}||=[]}, [$_->[0], $_->[2]] ) for @a;

$vsd = {};
@frd = ();
for(my $i=0; $i<@a; $i++){
#    next if $vsd->{$a[$i][0]} && $vsd->{$a[$i][1]};
    #my $c1 = clr($a[$i][0]);
    my $c1 = $a[$i][0];
    $c1 = $R[$c1] while $R[$c1];
    my $c2 = $a[$i][1];
    $c2 = $R[$c2] while $R[$c2];
    #print "c1 $c1 c2 $c2\n";
    next if $c1 == $c2;
    if($S[$c1] > $S[$c2]){
        $R[$c2] = $c1;
        $S[$c1] += $S[$c2] + 1;
    }else{
        $R[$c1] = $c2;
        $S[$c2] += $S[$c1] + 1;
    }
    #$vsd->{$a[$i][0]}++;
    #$vsd->{$a[$i][1]}++;
    push(@frd, $a[$i]);
}

#print Dumper(\@frd);

%h = ();
keys %h = $N+1;
push( @{$h{$_->[0]}||=[]}, [$_->[1], $_->[2]] ) for @frd;
push( @{$h{$_->[1]}||=[]}, [$_->[0], $_->[2]] ) for @frd;

#print Dumper(\%h);

#exit;

my $rrr = [];
sub addbin {
    my ($v) = @_;
    if($rrr->[$v] == 0){
        $rrr->[$v] = 1;
    }else{
        $rrr->[$v] = 0;
        addbin($v+1);
    }
}
sub addttl {
    my ($st, $vv) = @_;
    while($vv % 2 == 0){
        $vv /= 2;
        $st++;
    }
    my @bt = reverse split//, sprintf("%b", $vv);
    for(my $i=0; $i<@bt; $i++){
        addbin($st+$i) if $bt[$i];
    }
}

#my $ttl = Math::BigInt->new(0);
my @vsdd = ();
$#vsdd = $N+1;
sub dd {
    my $v = shift;
    $vsdd[$v]++;
    my $arr = $h{$v};
    #@arr = grep {! $vsdd[$_->[0]]} @arr;
    #print Dumper([$v, \@arr]);
    my $res = 1;
    for my $nxt (@$arr){
        next if $vsdd[$nxt->[0]];
        my $cur = dd($nxt->[0]);
        #print "$v => $nxt->[0] ($nxt->[1]) $cur\n";
        #my $cc = Math::BigInt->new(2);
        #$cc = $cc ** $nxt->[1];
        #$ttl += $cc * $cur * ($N-$cur);
        addttl( $nxt->[1], $cur * ($N-$cur) );
        $res += $cur;
    }
    return $res;
}
dd(1);
#print "$ttl\n";
#printf("%b\n", $ttl);
#print Dumper($rrr);
print join('', reverse map {$_ || 0} @$rrr);


