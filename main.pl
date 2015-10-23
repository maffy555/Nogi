#!/usr/bin/perl -w

use lib './lib';
use Nogizaka::Schema;

my $schema = Nogizaka::Schema->connect('dbi:SQLite:dbname=db/nogizaka.db');
my $memberID = 11;
	
print "Content-type: text/html\n\n";
print "<html><head></head><body>\n";

    @array = split(/&/,$ENV{'QUERY_STRING'});
 
    foreach $set (@array) {
        ($key,$value) = split(/=/, $set);
	if($key eq "id"){ $memberID = $value; }
	print "$key and $value <br />\n";
	print "$memberID";
    }	

my @file = $schema->resultset('Image')->search({ memberID => $memberID})->all;
for (@file){
	print("<img src=\"image/".$_->filename."\" />\n");
}
print "</body></html>\n";
