package LadyBug::Model::Session;

use Fey::ORM::Table;

use LadyBug::Model::Schema;
use LadyBug::Model::User;
use LadyBug::Fail;
use LadyBug::Util::KeyGen;

use constant WEEK => 7 * 24 * 3600;

my $schema = LadyBug::Model::Schema->Schema();
has_table $schema->table('session');
transform user
    => inflate { defined $_[1] ? LadyBug::Model::User->new( id => $_[1] ) : undef }
    => deflate { defined $_[1] ? $_[1]->id : undef };

sub start {
    my ($class, $email, $password, $ip) = @_;

    # check args
    throw LadyBug::Fail("No email specified") unless $email;
    throw LadyBug::Fail("No password specified") unless $password;

    # get user
    my $user = LadyBug::Model::User->new( email => $email ) || throw LadyBug::Fail("No user with email '$email'");
    
    # check password
    throw LadyBug::Fail("Wrong password") unless $user->is_password($password);

    # create new session
    my $key     = $class->generate_key();
    my $expires = time + WEEK;
    $class->insert( user => $user, ip => $ip, key => $key, expires => $expires );
}

sub generate_key {
    my ($class) = @_;
    for (1..10) {
        my $key = LadyBug::Util::KeyGen->key(128);
        return $key unless $class->new( key => $key );
    }
    throw LadyBug::Fail("Failed to generate key");
}

1;
