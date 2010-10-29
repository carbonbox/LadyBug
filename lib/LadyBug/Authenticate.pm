package LadyBug::Authenticate;

use Moose;
with 'LadyBug::Controller';

use LadyBug::Model::Session;
use LadyBug::Authenticate::Error;

# auth/login
# auth/logout
# auth/register
# auth/activate/[code]

has session => ( is => 'rw', isa => 'LadyBug::Model::Session' );

use constant {
    ACTION => { map {$_=>1} qw/login logout activate register setpassword/ },
};

sub login {
    my ($self) = @_;

    # create session
    my $session = LadyBug::Model::Session->start(
        $self->request->param('email'),
        $self->request->param('password'),
        $self->request->address,
    ) || throw LadyBug::Authenticate::Error("Failed to create session"); 

    # set the cookie
    $self->response->cookies->{key} = { value => $session->key };

    # redirect
    $self->response->code(302);
    $self->response->headers->header( Location => '/' );
    return $self->response;
}

sub logout {
    my ($self) = @_;
    $self->authenticate();
    $self->session->delete;
    $self->response->code(302);
    $self->response->headers->header( Location => '/' );
    return $self->response;
}

sub register {
    my ($self)   = @_;
    my $error    = "LadyBug::Authenticate::Error";
    my $email    = $self->request->param('email');
    my $password = $self->request->param('password');
    my $confirm  = $self->request->param('confirm');
    
    throw $error("Missing email") unless $email;
    throw $error("New passwords don't match") unless $password eq $confirm;

    LadyBug::Model::User->register($email, $password);

    $self->response->content(1);
    return $self->response;
}

sub activate {
    my ($self, $code) = @_;
    LadyBug::Model::User->activate($code);
    $self->response->content(1);
    return $self->response;
}

sub authenticate {
    my ($self)  = @_;
    my $error   = "LadyBug::Authenticate::Error";
    my $key     = $self->request->cookies->{key} || throw $error("No key in cookie");
    my $ip      = $self->request->address        || throw $error("No IP address");
    my $session = LadyBug::Model::Session->new( key => $key->value, ip => $ip ) || throw $error("No session");

    # check if session expired

    $self->session($session);
}

sub setpassword {
    my ($self)  = @_;
    my $error   = "LadyBug::Authenticate::Error";
    my $old     = $self->request->param('old');
    my $new     = $self->request->param('new');
    my $confirm = $self->request->param('confirm');
    
    $self->authenticate();

    throw $error("Incorrect password") unless $self->session->user->is_password($old);
    throw $error("New passwords don't match") unless $new eq $confirm;

    $self->session->user->set_password($new);
    $self->response->content(1);
    return $self->response;
}

no Moose;
__PACKAGE__->meta->make_immutable;
