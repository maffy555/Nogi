#!/usr/bin/perl
use strict;
use warnings;
use WWW::Mechanize;

main();

sub main{
	my $mech = WWW::Mechanize->new;
	my $url = 'http://blog.nogizaka46.com/erika.ikuta/2015/10/025242.php';
	$mech->get($url);
	my $content = $mech->content();
	while($content =~ /<a href="(.*?)"><img src="(.*?)"><\/a>/g){
		$mech->get($1);

		print "$1\n";
		my $img = $1;
		my $orig = $2;
		$img =~ s/img1/img2/;
		$img =~ s/id/sec_key/;

		$mech->get($img);
		print "$img\n\n";

		my @fnames = split(/\//, $orig);
		$mech->save_content($fnames[-1]);
	}
}
