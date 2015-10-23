use strict;
use warnings;
use Net::Twitter;
use utf8;
use Encode;

use lib './lib';
use Nogizaka::Schema;

my $schema = Nogizaka::Schema->connect('dbi:SQLite:dbname=db/nogizaka.db');

my $consumer_key = 'LIcMGTiT2UkxwmX3cDvtTAUjO',
my $consumer_secret = 'FUumbViFDqXqzF4ol6WEz2LZwtZ84VWEmfObsAML2KDokFreHm',
my $token = '3924665666-7JLS4w3TIDLO8H1miNo2eNajrNIMbvQIw6pej7s';
my $token_secret = 'DVfLlhv5V2xIxn4OsPF9vQLTm11l1GAqZxT9QSKWpSpGB';

my $nt = Net::Twitter->new(
   traits => ['API::RESTv1_1'],
   consumer_key => $consumer_key,
   consumer_secret => $consumer_secret,
   access_token => $token,
   access_token_secret => $token_secret,
   ssl => 1
);

#my $result = $nt->update('Hello, world!');
#$nt->update_with_media('HELLO', $

# 画像付きでつぶやく場合

my @files = glob("image/*");
my $num = int(rand($#files));
my $entry = $schema->resultset('Image')->find($num);
my $fname = $entry->filename;
my $memberID = $entry->memberid;
my $entry2 = $schema->resultset('Member')->find($memberID);
my $memberName = decode_utf8($entry2->name);

my $file = "./image/".$fname;
my $content = do {
    open my $fh, '<:bytes', $file or die "$!: $file";
    local $/;
    <$fh>;
};
my $filename = "./image/".$fname;

eval {
    $nt->update_with_media($memberName, [ undef, $filename, Content_Type => 'image/jpeg', Content => $content ])
};
die $@ if $@;