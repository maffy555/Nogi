package Member;

use lib '.\lib';
use Nogizaka::Schema;


sub is_registerd{
	my $entry = shift;
	my $schema = Nogizaka::Schema->connect('dbi:SQLite:dbname=db/nogizaka.db');
	if($schema->resultset('Member')->search({name => $entry->author}) == 0){
		return 0;
	}
	return 1;
}

sub register{
	my $entry = shift;
	my $schema = Nogizaka::Schema->connect('dbi:SQLite:dbname=db/nogizaka.db');
	$schema->resultset('Member')->create({
			name => $entry->author,
			blogurl => $entry->content->base,
		});
}

sub getID{
	my $entry = shift;
	my $schema = Nogizaka::Schema->connect('dbi:SQLite:dbname=db/nogizaka.db');
	my $e = $schema->resultset('Member')->search({name => $entry->author})->first;
	return $e->id;
}
1;
