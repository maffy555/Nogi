#!/usr/bin/perl
use strict;
use warnings;

use lib './lib'
use Feed;
use TB;
use DLIMG;

use Nogizaka::Schema;

my @url = Feed::GetUrl;
foreach (@url){
	#DBに登録済みか
	#registerとか
	my @img = TB::Parse($_);
	for (@img){
		DLIMG::DL($_);
	}
}
