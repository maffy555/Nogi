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

# urlを指定する
#特殊リンク無し
#my $url = 'http://blog.nogizaka46.com/rina.ikoma/2015/10/025269.php';
#特殊リンクあり
#my $url = 'http://blog.nogizaka46.com/erika.ikuta/2015/10/025242.php';

sub Parse_and_Fetch{
	my ($url, $blogURL, $memberID) = @_;
# IE8のフリをする
	my $user_agent = "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)";

# LWPを使ってサイトにアクセスし、HTMLの内容を取得する
#my $ua = LWP::UserAgent->new(agent => $user_agent);
	my $ua = LWP::UserAgent->new();
	my $res = $ua->get($url);
	my $content = $res->content;

	#ブログのリンクが無効になっている場合
	if($content =~ /404 File Not Found/){
		return;
	}
# HTML::TreeBuilderで解析する
	my $tree = HTML::TreeBuilder->new;
	$tree->parse($content);

#特殊リンクのあるなしはdcimg.awalker.jpを含んでいるかで対応
#HINT: このやり方では両方のアップローダの画像を含む場合、awalkerの画像のみしか落とせません
	if($content =~ /dcimg.awalker.jp/){
#特殊リンクあり
		my @address =  $tree->look_down('class', 'entrybody')->find('a');
		#my @img;
		#push(@img, $_->find('img')) for @address;
		#print decode_utf8($_->as_HTML)."\n" for @img;     
		for (@address){
			#子要素としてimgを持たない時は画像リンクではない
			unless($_->as_HTML =~ /<img/){ next; }
			if($_->as_HTML =~ /href="(.*?)"/){
				print $1."\n";
				DLIMG::getimg($1, 1, $blogURL, $memberID);
			}
		}
	}
	else{
#特殊リンク無し
		print $url;
		my @items =  $tree->look_down('class', 'entrybody')->find('img');
		for (@items){
			#.gifで終わるファイルは絵文字である
			if($_->as_HTML =~ /\.gif"/){ next; }
			if($_->as_HTML =~ /src="(.*?)"/){
				print $1."\n";
				DLIMG::getimg($1, 0, $blogURL, $memberID);
			}
		}
	}
}
1;
