package LadyBug::Model::User;

use Fey::ORM::Table;

use LadyBug::Model::Schema;
use LadyBug::Fail;
use LadyBug::Util::KeyGen;

my $schema = LadyBug::Model::Schema->Schema();
has_table $schema->table('user');

sub is_password {
    my ($self, $password) = @_;
    $self->password eq crypt $password, $self->password;
}

sub set_password {
    my ($self, $password) = @_;
    my $salt = join '', ('.','/',0..9,'A'..'Z','a'..'z')[rand 64, rand 64];
    $self->update( password => crypt($password, $salt) );
}

sub register {
    my ($class, $email, $password) = @_;
    my $key  = $class->generate_key();
    my $user = $class->insert( email => $email, key => $key );

}

sub generate_key {
    my ($class) = @_;
    for (1..10) {
        my $key = LadyBug::Util::KeyGen->key(12);
        return $key unless $class->new( key => $key );
    }
    throw LadyBug::Fail("Failed to generate key");
}

1;
