package LadyBug::Util::KeyGen;

sub key {
    my ($class, $length) = @_;
    my @set = ('a'..'z','A'..'Z',0..9);
    return join "", map { $set[ int rand scalar @set ] } (1..$length);
}

1;
