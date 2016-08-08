package Mojolicious::Plugin::LocaleTextDomainOO;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

sub register {
  my ($self, $app) = @_;
}

1;
__END__

=encoding utf8

=head1 NAME

Mojolicious::Plugin::LocaleTextDomainOO - Mojolicious Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('LocaleTextDomainOO');

  # Mojolicious::Lite
  plugin 'LocaleTextDomainOO';

=head1 DESCRIPTION

L<Mojolicious::Plugin::LocaleTextDomainOO> is a L<Mojolicious> plugin.

=head1 METHODS

L<Mojolicious::Plugin::LocaleTextDomainOO> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 AUTHOR

Munenori Sugimura <clicktx@gmail.com>

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicious.org>.

=cut
