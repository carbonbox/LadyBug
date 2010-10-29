package LadyBug::View;

use Moose::Role;
use Template;
requires 'render';

my $tt;
sub engine {
    my ($class) = @_;
    return $tt if defined $tt;
    return $tt = Template->new({
        INCLUDE_PATH => LadyBug->conf->{templates},
        INTERPOLATE  => 1,
    }) or throw LadyBug::Fail($Template::ERROR->info);
}

sub process {
    my ($class, $template, %vars) = @_;
    my $content = "";
    my $tt      = $class->engine;
    $tt->process($template, \%vars, \$content) or throw LadyBug::Fail($tt->error->info);
    return $content;
}

no Moose::Role;

1;
