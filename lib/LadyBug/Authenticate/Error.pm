package LadyBug::Authenticate::Error;

use Moose;
with 'LadyBug::Error';

no Moose;
__PACKAGE__->meta->make_immutable;

1;
