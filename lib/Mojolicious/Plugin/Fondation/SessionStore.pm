package Mojolicious::Plugin::Fondation::SessionStore;

# ABSTRACT: Fondation plugin — server-side session storage via Mojolicious::Sessions::Store

use Mojo::Base 'Mojolicious::Plugin', -signatures;
use Mojolicious::Sessions::Store;
use Mojolicious::Sessions::Store::Backend::File;

our $VERSION = '0.01';

sub fondation_meta {
    return {
        dependencies => [],
        defaults     => {
            backend   => 'file',
            store_dir => undef,       # resolved at startup: $app->home->child('data/sessions')
            session   => {
                cookie_name        => 'fondation',
                default_expiration => 1800,
            },
        },
    };
}

sub register ($self, $app, $config) {

    # ── Resolve store_dir ──────────────────────────────────────────────
    my $store_dir = $config->{store_dir}
        // $app->home->child('data/sessions')->to_string;

    # ── Instantiate backend ────────────────────────────────────────────
    my $backend;
    if (ref $config->{backend}) {
        # Direct backend instance (useful for tests)
        $backend = $config->{backend};
    }
    elsif ($config->{backend} eq 'file') {
        $backend = Mojolicious::Sessions::Store::Backend::File->new(
            store_dir => $store_dir,
        );
    }
    else {
        die "Unknown session store backend: $config->{backend}";
    }

    # ── Create Sessions::Store and replace app sessions ────────────────
    my %session_opts = %{$config->{session} // {}};
    my $store = Mojolicious::Sessions::Store->new(
        backend => $backend,
        %session_opts,
    );
    $app->sessions($store);

    $self->log->info(
        sprintf("SessionStore: using backend '%s' at %s",
            $config->{backend}, $store_dir));

    return $self;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Mojolicious::Plugin::Fondation::SessionStore - Server-side session storage for Fondation

=head1 SYNOPSIS

    # In myapp.pl or myapp.conf
    plugin 'Fondation' => {
        dependencies => [
            'Fondation::SessionStore',
        ],
    };

    # With custom configuration
    plugin 'Fondation' => {
        dependencies => [
            { 'Fondation::SessionStore' => {
                backend   => 'file',
                store_dir => '/var/lib/myapp/sessions',
                session   => {
                    cookie_name        => 'myapp',
                    default_expiration => 3600,
                },
            }},
        ],
    };

=head1 DESCRIPTION

C<Mojolicious::Plugin::Fondation::SessionStore> replaces the default
signed-cookie session storage with server-side storage via
L<Mojolicious::Sessions::Store>.

A signed cookie containing only a session ID is sent to the client;
the actual session data lives in a backend (filesystem by default).

The L<Mojolicious::Controller> C<session> helper works unchanged.

=head1 CONFIGURATION

All keys are optional and can be overridden in C<myapp.pl> or C<myapp.conf>.

=over 4

=item backend

Backend name (C<file>) or a backend instance (for testing).
Default: C<file>.

=item store_dir

Directory for session files when using the C<file> backend.
Default: C<$app-E<gt>home/data/sessions>.

=item session

Hashref of session options passed to L<Mojolicious::Sessions::Store>:

=over 4

=item cookie_name

Session cookie name. Default: C<fondation>.

=item default_expiration

Session lifetime in seconds. Default: C<1800> (30 minutes).

=back

=back

=head1 BACKENDS

=over 4

=item file

L<Mojolicious::Sessions::Store::Backend::File> — JSON files on disk.

=back

Future: C<redis>, C<dbi>.

=head1 DEPENDENCIES

L<Mojolicious::Sessions::Store> (standalone, no Fondation dependency).

=head1 SEE ALSO

L<Mojolicious::Sessions::Store>,
L<Mojolicious::Sessions::Store::Backend::File>,
L<Mojolicious::Plugin::Fondation>

=cut
