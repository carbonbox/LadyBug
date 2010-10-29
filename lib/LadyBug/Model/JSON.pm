package LadyBug::Model::JSON;

use Moose::Role;
requires 'JSON_ATTRIBUTES';

use JSON;

sub TO_JSON {
    my ($self) = @_;
    my $object = {};
    for my $attribute ($self->JSON_ATTRIBUTES) {
        $object->{$attribute} = $self->$attribute();
    }
    return $object;
}

sub json {
    my ($self) = @_;
    return JSON->new->allow_blessed->convert_blessed->encode( $self );
}

1;
