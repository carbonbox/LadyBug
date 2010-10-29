package LadyBug::View::Text;

use Moose::Role;
with 'LadyBug::View';

requires qw(template_path template);

use Template;
use LadyBug::Fail;

sub render {
    my ($self, %vars) = @_;

    # new template
    my $tt = Template->new({
        INCLUDE_PATH => $self->template_path,
        INTERPOLATE  => 1,
    }) || throw LadyBug::Fail($Template::ERROR->info);

    # process the template
    my $content = "";
    $tt->process($self->template, \%vars, \$content) || throw LadyBug::Fail($tt->error->info);

    # return the rendered content
    return $content;
}

1;
