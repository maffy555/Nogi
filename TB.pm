package TB;
# http://dqn.sakusakutto.jp/2010/06/perlhtml.html
use strict;
use warnings;
use LWP::UserAgent;
use HTML::TreeBuilder;
use utf8;
use Encode;
binmode STDOUT, ':encoding(cp932)';

use DLIMG;

# url���w�肷��
#���ꃊ���N����
#my $url = 'http://blog.nogizaka46.com/rina.ikoma/2015/10/025269.php';
#���ꃊ���N����
#my $url = 'http://blog.nogizaka46.com/erika.ikuta/2015/10/025242.php';

sub Parse_and_Fetch{
	my ($url, $blogURL, $memberID) = @_;
# IE8�̃t��������
	my $user_agent = "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)";

# LWP���g���ăT�C�g�ɃA�N�Z�X���AHTML�̓��e���擾����
#my $ua = LWP::UserAgent->new(agent => $user_agent);
	my $ua = LWP::UserAgent->new();
	my $res = $ua->get($url);
	my $content = $res->content;

	#�u���O�̃����N�������ɂȂ��Ă���ꍇ
	if($content =~ /404 File Not Found/){
		return;
	}
# HTML::TreeBuilder�ŉ�͂���
	my $tree = HTML::TreeBuilder->new;
	$tree->parse($content);

#���ꃊ���N�̂���Ȃ���dcimg.awalker.jp���܂�ł��邩�őΉ�
#HINT: ���̂����ł͗����̃A�b�v���[�_�̉摜���܂ޏꍇ�Aawalker�̉摜�݂̂������Ƃ��܂���
	if($content =~ /dcimg.awalker.jp/){
#���ꃊ���N����
		my @address =  $tree->look_down('class', 'entrybody')->find('a');
		#my @img;
		#push(@img, $_->find('img')) for @address;
		#print decode_utf8($_->as_HTML)."\n" for @img;     
		for (@address){
			#�q�v�f�Ƃ���img�������Ȃ����͉摜�����N�ł͂Ȃ�
			unless($_->as_HTML =~ /<img/){ next; }
			if($_->as_HTML =~ /href="(.*?)"/){
				print $1."\n";
				DLIMG::getimg($1, 1, $blogURL, $memberID);
			}
		}
	}
	else{
#���ꃊ���N����
		print $url;
		my @items =  $tree->look_down('class', 'entrybody')->find('img');
		for (@items){
			#.gif�ŏI���t�@�C���͊G�����ł���
			if($_->as_HTML =~ /\.gif"/){ next; }
			if($_->as_HTML =~ /src="(.*?)"/){
				print $1."\n";
				DLIMG::getimg($1, 0, $blogURL, $memberID);
			}
		}
	}
}
1;
