package LadyBug::View::MIME;

use Moose::Role;
with 'LadyBug::View';

requires qw(template title);

sub render {
    my ($self, %vars) = @_;

    # process the body
    my $body = $self->process($self->template, \%vars);

    # process the HTML template
    my $vars    = {
        body  => $body,
        title => $self->title,
        type  => $self->type,
    };
    return $self->process("html.tt", %$vars);
}

send {

}

1;
