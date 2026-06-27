# NAME

Mojolicious::Plugin::Fondation::SessionStore - Fondation plugin — server-side session storage via Mojolicious::Sessions::Store

# VERSION

version 0.01

# SYNOPSIS

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

# DESCRIPTION

`Mojolicious::Plugin::Fondation::SessionStore` replaces the default
signed-cookie session storage with server-side storage via
[Mojolicious::Sessions::Store](https://metacpan.org/pod/Mojolicious%3A%3ASessions%3A%3AStore).

A signed cookie containing only a session ID is sent to the client;
the actual session data lives in a backend (filesystem by default).

The [Mojolicious::Controller](https://metacpan.org/pod/Mojolicious%3A%3AController) `session` helper works unchanged.

# NAME

Mojolicious::Plugin::Fondation::SessionStore - Server-side session storage for Fondation

# CONFIGURATION

All keys are optional and can be overridden in `myapp.pl` or `myapp.conf`.

- backend

    Backend name (`file`) or a backend instance (for testing).
    Default: `file`.

- store\_dir

    Directory for session files when using the `file` backend.
    Default: `$app->home/data/sessions`.

- session

    Hashref of session options passed to [Mojolicious::Sessions::Store](https://metacpan.org/pod/Mojolicious%3A%3ASessions%3A%3AStore):

    - cookie\_name

        Session cookie name. Default: `fondation`.

    - default\_expiration

        Session lifetime in seconds. Default: `1800` (30 minutes).

# BACKENDS

- file

    [Mojolicious::Sessions::Store::Backend::File](https://metacpan.org/pod/Mojolicious%3A%3ASessions%3A%3AStore%3A%3ABackend%3A%3AFile) — JSON files on disk.

Future: `redis`, `dbi`.

# DEPENDENCIES

[Mojolicious::Sessions::Store](https://metacpan.org/pod/Mojolicious%3A%3ASessions%3A%3AStore) (standalone, no Fondation dependency).

# SEE ALSO

[Mojolicious::Sessions::Store](https://metacpan.org/pod/Mojolicious%3A%3ASessions%3A%3AStore),
[Mojolicious::Sessions::Store::Backend::File](https://metacpan.org/pod/Mojolicious%3A%3ASessions%3A%3AStore%3A%3ABackend%3A%3AFile),
[Mojolicious::Plugin::Fondation](https://metacpan.org/pod/Mojolicious%3A%3APlugin%3A%3AFondation)

# AUTHOR

Daniel Brosseau <dab@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2026 by Daniel Brosseau.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
