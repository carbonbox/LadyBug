package LadyBug::Config;

use YAML::Tiny;
use LadyBug::Fail;

my $yaml;
sub load {
    my ($class, $file) = @_;
    throw LadyBug::Fail("No file specified for config") unless $file;
    $yaml = YAML::Tiny->read($file) or throw LadyBug::Fail("Failed to open config file '$file': " . YAML::Tiny->errstr);
}

sub config {
    $yaml->[0];
}

package LadyBug;

sub conf {
    LadyBug::Config->config;
}

1;
