#!/usr/bin/perl

use strict;
use warnings;
no warnings 'experimental';

use v5.10.1;

sub run {
    my $debug = 0;
    my ($idx, $regs, $arr, $inqueue, $outqueue, $res) = @_;
    return 0 if ($$idx > $#$arr or $$idx < 0);
    my $retval = 0;
    while (1) {
        my @instr = split / /, $arr->[$$idx];
        $regs->{$instr[1]} //= 0 if not $instr[1] =~ /\d/;
        given ($instr[0]) {
            when (/snd/) {
                push @$outqueue, $instr[1] =~ /\d/ ? $instr[1] : $regs->{$instr[1]};
                $$idx++;
                $$res++ if defined $res;
            }
            when (/set/) {
                $regs->{$instr[1]} = $instr[2] =~ /\d/ ? $instr[2] : $regs->{$instr[2]};
                $$idx++;
            }
            when (/add/) {
                $regs->{$instr[1]} += $instr[2] =~ /\d/ ? $instr[2] : $regs->{$instr[2]};
                $$idx++;
            }
            when (/mul/) {
                $regs->{$instr[1]} *= $instr[2] =~ /\d/ ? $instr[2] : $regs->{$instr[2]};
                $$idx++;
            }
            when (/mod/) {
                $regs->{$instr[1]} %= $instr[2] =~ /\d/ ? $instr[2] : $regs->{$instr[2]};
                $$idx++;
            }
            when (/rcv/) {
                return $retval if not @$inqueue;
                $regs->{$instr[1]} = shift @$inqueue;
                $$idx++;
            }
            when (/jgz/) {
                my $regval = $instr[1] =~ /\d/ ? $instr[1] : $regs->{$instr[1]};
                if ($regval > 0) {
                    $$idx += $instr[2] =~ /\d/ ? $instr[2] : $regs->{$instr[2]};
                }
                else {
                    $$idx++;
                }
            }
        }
        $retval = 1;
    }
}

my $fname = shift;

open my $fh, "<", $fname
    or die "Can't open $fname: $!";

chomp(my @arr = <$fh>);

my ($idx0, $idx1) = (0, 0);
my (%regs0, %regs1);
$regs0{p} = 0;
$regs1{p} = 1;

my (@queue0, @queue1);

my $res = 0;

while (1) {
    my $retval0 = run(\$idx0, \%regs0, \@arr, \@queue0, \@queue1);
    my $retval1 = run(\$idx1, \%regs1, \@arr, \@queue1, \@queue0, \$res);
    last if ($retval0 == 0 and $retval1 == 0);
}

say $res;
