#! /usr/bin/perl -w

use warnings;
use strict;

my ($input, $output, $ref, $aa, $bb) = 0;
my (@ar) = ();
my (%interpro_Hash, %go_Hash) = ();

$input = $ARGV[0];
open(INPUT, "$input") or die "Can't open \"$input\"\n";

$ref = $ARGV[1];
open(REF, "$ref") or die "Can't open \"$ref\"\n";

$output = "$input.go.tsv";
open(OUTPUT, ">$output") or die "Can't open \"$output\"\n";

open(REF, "$ref") or die "Can't open \"$ref\"\n";
while(<REF>){
    if(/^InterPro\S(\S+)\s+.+?(GO\S\d+)/){
        if(exists($interpro_Hash{$1})){
            $interpro_Hash{$1} = "$interpro_Hash{$1},$2";
        }
        else{
            $interpro_Hash{$1} = $2;
        }
    }
}
close REF;

open(INPUT, "$input") or die "Can't open \"$input\"\n";
while(<INPUT>){
    if(/\t+(IPR\S+)\s+/){
        if(exists($interpro_Hash{$1})){
            @ar = ();
            @ar = split(/,/, $interpro_Hash{$1});
            foreach $aa (@ar){
                if(exists($go_Hash{$aa})){
                    $go_Hash{$aa} += 1;
                }
                else{
                    $go_Hash{$aa} = 1;
                }
            }
        }
        else{
            next;
        }
    }
}
close INPUT;

foreach $bb (sort keys %go_Hash){
    print OUTPUT "$bb\t$go_Hash{$bb}\n";
}
close OUTPUT;
exit;
