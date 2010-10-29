package LadyBug::View::HTML;

use Moose::Role;
with 'LadyBug::View';

requires qw(template title);

sub render {
    my ($self, %vars) = @_;

    # process the body
    my $body = $self->process($self->template, %vars);

    # process the HTML template
    return $self->process("html.tt", body => $body); 
}

1;
