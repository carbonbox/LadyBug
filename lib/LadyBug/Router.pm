package LadyBug::Router;

use Moose;
use TryCatch;

has keyed  => ( is => 'ro', isa => 'HashRef[LadyBug::Router::Route]',  default => sub { {} } );
has routes => ( is => 'ro', isa => 'ArrayRef[LadyBug::Router::Route]', default => sub { [] } );

use constant KEYS => { map {$_=>1} qw/error login/ };
use LadyBug::Router::Route;

sub add {
    my ($self, $pattern, $class) = @_;
    if (KEYS->{$pattern}) {
        $self->keyed->{$pattern} = LadyBug::Router::Route->new( class => $class );
    }
    else {
        push @{$self->routes}, LadyBug::Router::Route->new( pattern => $pattern, class => $class );
    }
}

sub route {
    my ($self, $request, $param) = @_;
    try {
        if (ref $request) {
            my $uri = $request->request_uri;
            warn "$uri";
            for my $route (@{$self->routes}) {
                my @args = $route->match($uri) or next;
                return $route->dispatch($request, $param, @args);
            }
            throw LadyBug::Fail("No routes for $uri");
        }
        else {
            return $self->keyed->{$request}->dispatch(undef, $param);
        }
    }
    catch (LadyBug::Authenticate::Error $e) {
        return $self->route('login');
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;
