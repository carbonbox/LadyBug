package LadyBug::Router::Route;

use Moose;

has class   => ( is => 'ro', isa => 'ClassName' );
has pattern => ( is => 'ro', isa => 'RegexpRef' );

sub BUILDARGS {
    my ($class, %args) = @_;
    if ($args{pattern} && !(ref $args{pattern})) {
        my $pattern = $args{pattern};
        $pattern  =~ s/\[(.*?)\]/(?:$1)?/g;   # handle [...] as an optional section
        $pattern  =~ s/\*/([^\/?]\*)/g;        # handle '*' as an arument
        $pattern .= "(?:\\?.*)?";             # handle ?arg=val... get variables
        $args{pattern} = qr/^$pattern$/;
    }
    return \%args;
}

sub match {
    my ($self, $uri) = @_;
    throw LadyBug::Fail("This route has no pattern and is not matchable") unless $self->pattern;
    return $uri =~ $self->pattern;
}

sub dispatch {
    my ($self, $request, $param, @args) = @_;
    my $response = HTTP::Engine::Response->new;
    $self->class->new( request => $request, response => $response, param => $param )->do(@args);
    return $response;
}

no Moose;
__PACKAGE__->meta->make_immutable;
