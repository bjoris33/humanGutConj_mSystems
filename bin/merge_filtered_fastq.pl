#!/usr/bin/env perl -w
use strict;

# generate a hash of read IDs in common in one pass through both
# in a second pass print out sequences that are in common to both
# assumes that at no time did the order of the sequences in the files change

my %ids; # hash of ides
my $c = 0;

open (IN1, "< $ARGV[0]") or die;
open (IN2, "< $ARGV[1]") or die;

    while(my $l1 = <IN1>){
          my $l2 = <IN2>;
        if ($c % 4 == 0){ # if defline
            my @l1 = split(/\//, $l1);
            my @l2 = split(/\//, $l2);
            $ids{$l1[0]}++;
            $ids{$l2[0]}++;
        }
    $c++;
    }
close IN1;
close IN;

$c = 0;
my $id1 = my $id2 = "";
my $fq1 = my $fq2; # print asynchronously
my %data1 = my %data2;

open (IN1, "< $ARGV[0]") or die;
open (IN2, "< $ARGV[1]") or die;


    while(my $l1 = <IN1>){
          my $l2 = <IN2>;
        if ($c % 4 == 0){ # if defline
            my @l1 = split(/\//, $l1);
            my @l2 = split(/\//, $l2);
            $id1 = $l1[0]; # no need to chomp
            $id2 = $l2[0]; # no need to chomp

            if($ids{$id1} ==2){
                $fq1 = $l1;
            }
            if($ids{ $id2} ==2){
                $fq2 = $l2;
            }
        }
        if ($c % 4 != 0 && $ids{$id1} == 2){ # if !defline and in common
                $fq1 .= $l1;
                $data1{$id1} = $fq1 if $c % 4 == 3;
        }
        if ($c % 4 != 0 && $ids{$id2} == 2){ # if !defline and in common
                $fq2 .= $l2;
                $data2{$id2} = $fq2 if $c % 4 == 3;
        }
    $c++;
    }

close IN1;
close IN;


my @keys = keys(%ids);


open (OUT1, "> $ARGV[2]") or die;
open (OUT2, "> $ARGV[3]") or die;

foreach(@keys){
    if ($ids{$_} > 1){
        print OUT2 $data2{$_};
        print OUT1 $data1{$_};
    }
}

close OUT1;
close OUT2;
