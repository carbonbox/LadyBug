package LadyBug::Controller;

use Moose::Role;
requires qw/ACTION/;

has request  => ( is => 'ro', isa => 'HTTP::Engine::Request',  required => 1 );
has response => ( is => 'ro', isa => 'HTTP::Engine::Response', required => 1 );
has param    => ( is => 'ro', isa => 'Maybe[HashRef]' );

sub do {
    my ($self, $action, @args) = @_;
    throw LadyBug::Fail("Unknown action $action") unless $action && $self->ACTION->{$action};
    $self->$action(@args);
    return $self->response;
}

no Moose::Role;

1;
