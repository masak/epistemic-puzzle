use 5.006;
use strict;
use warnings;

# Solving the "Mr.S and Mr.P" puzzle by John McCarthy:
#
#       Formalization of two Puzzles Involving Knowledge
#       McCarthy, John (1987).
#       http://www-formal.stanford.edu/jmc/puzzles.html

# We pick two numbers a and b, so that a>=b and both numbers are within
# the range [2,99]. We give Mr.P the product a*b and give Mr.S the sum
# a+b.

# The following dialog takes place:
#
#       Mr.P: I don't know the numbers
#       Mr.S: I knew you didn't know. I don't know either.
#       Mr.P: Now I know the numbers
#       Mr.S: Now I know them too
#
# Can we find the numbers a and b?

use List::Util qw(all);


# The following is Perl 5 code, interspersed with comments.
# It takes a while to compute; the optimizations are
# straightforward; yet we deliberately chose the simplest code.
#
# Chung-chieh Shan has pointed out the paper
#    Hans P. van Ditmarsch, Ji Ruan and Rineke Verbrugge
#    Sum and Product in Dynamic Epistemic Logic
#    Journal of Logic and Computation, 2008, v18, N4, pp.563--588.
#
# that discusses at great extent the history of the riddle, its
# modeling in modal `public announcement logic', and solving using
# epistemic model checkers.

# First, let's define good numbers

my @good_nums = (2..99);

# Given a number p, find all good factors a and b (a>=b)
# and return them (the pairs of them) in a list. We use the obvious and
# straightforward memoization (tabling):

sub group_by {
    my ($fn) = @_;

    my %result;
    for my $aa (@good_nums) {
        for my $bb (@good_nums) {
            next unless $aa >= $bb;

            my $n = $fn->($aa, $bb);
            $result{$n} ||= [];
            push @{ $result{$n} }, [$aa, $bb];
        }
    }

    return %result;
}

my %good_factors = group_by(sub { $_[0] * $_[1] });

sub good_factors {
    my ($p) = @_;

    return $good_factors{$p} || [];
}

# Given a number s, find all good summands a and b (a>=b)
# and return the pairs of them in a list

my %good_summands = group_by(sub { $_[0] + $_[1] });

sub good_summands {
    my ($s) = @_;

    return $good_summands{$s} || [];
}

sub is_singleton {
    # Test if an array is a singleton (has exactly one element)
    my ($array_ref) = @_;

    return scalar(@$array_ref) == 1;
}

# Let's encode the first fact: Mr.P doesn't know the numbers.
# Mr. P would have known the numbers if the product had had a unique good
# factorization

sub fact1 {
    my ($aa, $bb) = @_;

    return !is_singleton(good_factors($aa * $bb));
}

# Let's encode the second fact: Mr.S doesn't know the numbers

sub fact2 {
    my ($aa, $bb) = @_;

    return !is_singleton(good_summands($aa + $bb));
}

# Let's encode the third fact: Mr.S knows that Mr.P doesn't know the numbers.
# In other words, for all possible summands that make a+b, Mr.P cannot be
# certain of the numbers

sub fact3 {
    my ($aa, $bb) = @_;

    return all { fact1($_->[0], $_->[1]) } @{good_summands($aa + $bb)};
}

# Let's encode the fourth fact: Mr.P _now_ knows that fact3 is true
# and is able to find the numbers. That is, of all factorizations
# of a*b there exists only one that makes fact3 being true.

sub fact4 {
    my ($aa, $bb) = @_;

    return is_singleton([
        grep { fact3($_->[0], $_->[1]) } @{good_factors($aa * $bb)}
    ]);
}
#
# The fifth fact is that Mr.S. knows that Mr.P found the numbers:
# of all the possible decompositions of a+b, there exists only one that
# makes fact4 true.

sub fact5 {
    my ($aa, $bb) = @_;

    return is_singleton([
        grep { fact4($_->[0], $_->[1]) } @{good_summands($aa + $bb)}
    ]);
}
#
# Finally, we compute the list of all numbers such that fact1..fact5
# hold:

for my $aa (@good_nums) {
    for my $bb (@good_nums) {
        next unless $aa >= $bb
            && fact1($aa, $bb)
            && fact2($aa, $bb)
            && fact3($aa, $bb)
            && fact4($aa, $bb)
            && fact5($aa, $bb);
        print("[$aa, $bb]\n");
    }
}

# The answer is
#
# [13, 4]

# That is, a unique answer. Note how Perl notation is relatively concise,
# compared to the one employed in the paper by McCarthy.
