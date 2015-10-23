#!/use/bin/perl
# http://ramtiga.hatenablog.jp/entry/20110711/p1
use strict;
use warnings;
use utf8;
use Encode;
use XML::Feed;
use URI;
use DateTime::Format::W3CDTF;
binmode STDOUT, ':encoding(cp932)';

use lib './lib';
use Nogizaka::Schema;

use Member;
use TB;

my $c = 0;
my $schema = Nogizaka::Schema->connect('dbi:SQLite:dbname=db/nogizaka.db');

my $url = 'http://blog.nogizaka46.com/atom.xml';
my $feed = XML::Feed->parse( URI->new($url) ) or die XML::Feed->errstr;

my $w3cdtf = DateTime::Format::W3CDTF->new;

for my $entry ($feed->entries){
	my $rs = $schema->resultset('Article')->search({url => $entry->link})->first;
	my $lastUpdate = $w3cdtf->parse_datetime($entry->issued);

	if(!defined($rs)){
		print $entry->link." is not on db.\n";
		if(Member::is_registerd($entry) != 1){
			print "Not registerd\n";
			Member::register($entry);
		}
		#do something
		TB::Parse_and_Fetch($entry->link, $entry->content->base, Member::getID($entry));
		$schema->resultset('Article')->create({
			url => $entry->link,
			lastupdate => $lastUpdate->datetime,
			memberid => Member::getID($entry),
		});
	}
	else{
		print $entry->link." is on db.\n";
		if(DateTime->compare($lastUpdate,  $w3cdtf->parse_datetime($rs->lastupdate)) == 1){
			print $entry->link." has new update\n";
			#do something
			TB::Parse_and_Fetch($entry->link, $entry->content->base, Member::getID($entry));
			$rs->lastupdate($lastUpdate->datetime);
			$rs->update;

		}
	}
	open(IN,"stop.txt");
	my $line = <IN>;
	close(IN);
	die "died by stop.txt == 1" if($line =~ /1/);

	$c++;
	#if($c == 32){
	if(0){
		last;
	}
}
