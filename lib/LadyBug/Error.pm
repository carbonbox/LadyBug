package LadyBug::Error;

use Moose::Role;
use Carp;

has message => ( is => 'ro', isa => 'Str' );

sub throw {
    my ($class, @args) = @_;
    confess "Cannot throw LadyBug::Error" if $class eq "LadyBug::Error";
    croak $class->new( scalar @args == 1 ? ( message => $args[0] ) : @args );
}

1;
