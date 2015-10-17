package Nogizaka::Schema;
use strict;
use base qw/DBIx::Class::Schema::Loader/;

__PACKAGE__->loader_options(
    debug => 0,
    sqlite_unicode => 1,
    naming => 1,
);

1;
