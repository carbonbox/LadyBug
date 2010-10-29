package LadyBug;

use strict;
use warnings;
require Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/load route handle/;

use LadyBug::Config;
use LadyBug::Router;
use TryCatch;

my $router = LadyBug::Router->new();

sub load {
    my ($file) = @_;
    LadyBug::Config->load($file);
}

sub route {
    my ($pattern, $class) = @_;
    $router->add($pattern, $class);
}

sub handle {
    my ($class, $request) = @_;
    try {
        return $router->route($request);
    }
    catch (LadyBug::Fail $e) {
         my $response = HTTP::Engine::Response->new;
         $response->body("<pre style='white-space:pre-wrap'>" . $e->message . "</pre>");
         warn $e->message;
         return $response;
    }
    catch ($e) {
         my $response = HTTP::Engine::Response->new;
         $response->body("<pre style='white-space:pre-wrap'>$e</pre>");
         return $response;
    }
}

1;
