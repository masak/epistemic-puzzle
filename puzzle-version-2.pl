#! /usr/bin/perl
use v5.006;
use strict;
use warnings;

sub factorize {
    my ($n) = @_;
    if ($n == 1) {
        return ();
    }
    for my $prime (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47) {
        if ($n % $prime == 0) {
            return $prime, factorize($n / $prime);
        }
    }
    die "Unknown non-prime factor: $n";
}

for my $sum (4..198) {
    my $is_possible = 1;
    for my $f1 (2..$sum/2) {
        my $f2 = $sum - $f1;
        my $prod = $f1 * $f2;
        my @factors = factorize($prod);
        my $factors = join(" * ", @factors);
        if (scalar(@factors) <= 2) {
            $is_possible = 0;
        }
    }
    if ($is_possible) {
        print("$sum\n");
    }
}

