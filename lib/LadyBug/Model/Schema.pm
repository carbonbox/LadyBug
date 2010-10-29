package LadyBug::Model::Schema;

use Fey::DBIManager::Source;
use Fey::Loader;
use Fey::ORM::Schema;

my $db     = LadyBug->conf->{db};
my $source = Fey::DBIManager::Source->new( dsn => "dbi:SQLite:dbname=$db" );
my $schema = Fey::Loader->new( dbh => $source->dbh() )->make_schema();

has_schema $schema;

__PACKAGE__->DBIManager()->add_source($source);

no Fey::ORM::Schema;

1;
