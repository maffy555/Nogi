package DLIMG;
#!/usr/bin/perl
# http://cpanmag.koneta.org/011-dbix-class/
use strict;
use warnings;
use File::Temp 'tempfile';
use WWW::Mechanize;

use lib '.\lib';
use Nogizaka::Schema;

#getimg("", 1, "", 10);

sub getimg{
	my ($url, $awalker, $blogurl, $memberID) = @_;
	my $schema = Nogizaka::Schema->connect('dbi:SQLite:dbname=db/nogizaka.db');
	my $mech = WWW::Mechanize->new;
	
	if($awalker == 1){
		#特殊リンクが有る場合はそれに応じた画像をget
		$mech->get($url);
		if($mech->content =~ /expired.gif/){ return; }

		print "$url\n";
		$url =~ s/img1/img2/;
		$url =~ s/id/sec_key/;

		$mech->get($url);
		print "$url\n\n";

		#$mech->save_content(FILENAME);
	}
	else{
		#特殊リンクがない場合はそのままURLの画像をget
		$mech->get($url);	
	}
	#デフォの挙動でファイルは削除されません。消したいときはUNLINK => 1
	my $tmp = File::Temp->new(DIR => '.\\image', SUFFIX => '.jpg', UNLINK=> 0);
	print $tmp->filename;
	$mech->save_content($tmp->filename);

	### windows ###
	my @fnames = split(/\\/, $tmp->filename);

	#tableがimageでも、source名はImageになるので注意
	#source名はschema.pmのdebug => 1にして確認のこと
	$schema->resultset('Image')->create({
		articleurl => $blogurl,
		origurl => $url,
		memberid => $memberID,
		filename => $fnames[-1],
	});
}
1;
