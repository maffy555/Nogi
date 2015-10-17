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
		#���ꃊ���N���L��ꍇ�͂���ɉ������摜��get
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
		#���ꃊ���N���Ȃ��ꍇ�͂��̂܂�URL�̉摜��get
		$mech->get($url);	
	}
	#�f�t�H�̋����Ńt�@�C���͍폜����܂���B���������Ƃ���UNLINK => 1
	my $tmp = File::Temp->new(DIR => '.\\image', SUFFIX => '.jpg', UNLINK=> 0);
	print $tmp->filename;
	$mech->save_content($tmp->filename);

	### windows ###
	my @fnames = split(/\\/, $tmp->filename);

	#table��image�ł��Asource����Image�ɂȂ�̂Œ���
	#source����schema.pm��debug => 1�ɂ��Ċm�F�̂���
	$schema->resultset('Image')->create({
		articleurl => $blogurl,
		origurl => $url,
		memberid => $memberID,
		filename => $fnames[-1],
	});
}
1;
