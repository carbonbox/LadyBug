package LadyBug::View::Controller;

use Moose::Role;
requires 'render';

has request  => ( is => 'ro', isa => 'Maybe[HTTP::Engine::Request]',  required => 1 );
has response => ( is => 'ro', isa => 'HTTP::Engine::Response', required => 1 );
has param    => ( is => 'ro', isa => 'Maybe[HashRef]' );

sub do {
    my ($self, $uri, @args) = @_;
    my %param = defined $self->param ? %{$self->param} : ();
    $self->response->body( $self->render($self->render_args(@args), %param) );
}

sub render_args { () }

no Moose::Role;
1;
