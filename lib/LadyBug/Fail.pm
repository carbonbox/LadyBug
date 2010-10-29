package LadyBug::Fail;

use overload '""' => \&to_string;

use Moose;
with 'LadyBug::Error';

sub to_string {
    my ($self) = @_;
    return $self->message;
}

1;
