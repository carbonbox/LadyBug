package LadyBug::Controller::CRUD;

use Moose::Role;
with 'LadyBug::Authenticated';
requires qw/MODEL ATTRIBUTES/;

sub get {
    my ($self, $id) = @_;
    $self->response->content($self->fetch($id)->json);
    return $self->response;
}

sub add {
    my ($self) = @_;
    $self->response->content($self->MODEL->insert($self->args)->json);
    return $self->response;
}

sub remove {
    my ($self, $id) = @_;
    $self->fetch($id)->delete;
    $self->response->content(1);
    return $self->response;
}

sub update {
    my ($self, $id) = @_;
    my $obj = $self->fetch($id);
    $obj->update($self->args);
    $self->response->content($obj->json);
    return $self->response;
}

sub fetch {
    my ($self, $id) = @_;
    throw LadyBug::Fail("No id passed to get") unless $id;
    my $obj = $self->MODEL->new( id => $id );
    throw LadyBug::Fail("No object with id $id") unless $obj;
    throw LadyBug::Fail("Object $id does not belong to user") unless $self->session->user->id == $obj->user->id;
    return $obj;
}

sub args {
    my ($self) = @_;
    my %args = ( user => $self->session->user );
    my %attribute = map {$_=>1} $self->ATTRIBUTES;
    for my $param ($self->request->param) {
        throw LadyBug::Fail("$param is not a valid attribute") unless $attribute{$param};
        $args{$param} = $self->request->param($param)
    }
    return %args;
}

1;
