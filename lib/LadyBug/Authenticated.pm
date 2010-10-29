package LadyBug::Authenticated;

use Moose::Role;
use LadyBug::Authenticate;

has session => ( is => 'ro', isa => 'LadyBug::Model::Session', required => 1);

around BUILDARGS => sub {
    my ($fn, $class, %args) = @_;
    my $auth = LadyBug::Authenticate->new(%args);
    $auth->authenticate();
    return $class->$fn( %args, session => $auth->session );
};

no Moose::Role;
1;
