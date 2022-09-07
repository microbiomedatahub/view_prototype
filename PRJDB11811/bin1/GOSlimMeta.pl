#! /usr/bin/perl -w

use warnings;
use strict;

my ($input, $output, $ref, $goid, $name, $namespace) = 0;
my (%name_Hash, %namespace_Hash, %goabu_Hash) = ();

$input = $ARGV[0];
open(INPUT, "$input") or die "Can't open \"$input\"\n";

$ref = $ARGV[1];
open(REF, "$ref") or die "Can't open \"$ref\"\n";

$output = "$input.goslimmeta.tsv";
open(OUTPUT, ">$output") or die "Can't open \"$output\"\n";

open(REF, "$ref") or die "Can't open \"$ref\"\n";
while(<REF>){
    if(/^id\S\s+(GO\S\d+)/){
        $goid = $1;
    }
    elsif(/^name\S\s+(\S.+?)\s*$/){
        $name = $1;
    }
    elsif(/^namespace\S\s+(\S.+?)\s*$/){
        $namespace = $1;
        $name_Hash{$goid} = $name;
        $namespace_Hash{$goid} = $namespace;
        $goabu_Hash{$goid} = 0;
    }
}
close REF;

open(INPUT, "$input") or die "Can't open \"$input\"\n";
while(<INPUT>){
    if(/^(\S+)\s+(\d+)/){
        if(exists($goabu_Hash{$1})){
            print OUTPUT "$1\t$namespace_Hash{$1}\t$name_Hash{$1}\t$2\n";
        }
        else{
            next;
        }
    }
}
close INPUT;
close OUTPUT;
exit;
