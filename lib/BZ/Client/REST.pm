package BZ::Client::REST;

use parent qw(Class::Accessor);
BZ::Client::REST->mk_accessors(qw(user password url _client _token));

use REST::Client;
use JSON;

our $VERSION = '0.01';

=head1 NAME

BZ::Client::REST - Bugzilla client for Perl using the RESTful API

=head1 SYNOPSIS

    use BZ::Client::REST;

    my $client = BZ::Client::REST->new(
        {
            user     => $user,
            password => $password,
            url      => $url,
        }
    );

    $id   = $client->create_bug($params);
    $bugs = $client->search_bugs($params);

=head1 DESCRIPTION

This module is an object-oriented interface for Bugzilla's REST api.
It differs from other avaiable options in that it uses the current /rest
endpoint instead of the currently deprecated XML-RPC or JSON-RPC options.

=head2 Methods

=over 3

=item login()

$client->login();

This method triggers the modules to call Bugzilla's login api to generate
a token for later use. It is not necessary to call this method, as it will
be called automatically if a login is needed.

=cut

sub login {
    my $self = shift;

    $self->_client || $self->_client( REST::Client->new() );

    my $url  = $self->url;
    my $user = $self->user;
    my $pass = $self->password;

    $self->_client->GET("$url/rest/login?login=$user&password=$pass");
    my $response = from_json( $self->_client->responseContent() );
    my $token    = $response->{token};
    die("No token recieved") unless $token;

    $self->_token($token);

    return $self;
}

=item search_bugs()

$bugs = $client->search_bugs($params);

This method accepts a hashref of key/value parameters to search on.
Refer to L<http://bugzilla.readthedocs.io/en/latest/api/core/v1/bug.html#search-bugs>
for the valid keys that can be used.

=cut

sub search_bugs {
    my $self   = shift;
    my $params = shift;

    $self->login unless $self->_token;

    my $url = $self->url;

    my @pairs;
    while ( my ( $key, $value ) = each %$params ) {
        push( @pairs, "$key=$value" );
    }
    my $query_params = join( "&", @pairs );

    $self->_client->GET("$bz_tracker_url/rest/bug?$query_params");
    $response = from_json( $rest_client->responseContent() );

    return $response;
}

=item create_bug()

$bug_id = $client->create_bug($params);

This method accepts a hashref of key/value parameters to create a new bug with.
Refer to L<http://bugzilla.readthedocs.io/en/latest/api/core/v1/bug.html#create-bugs>
for the valid keys that can be used.

=cut

sub create_bug {
    my $self = shift;
    my $data = shift;

    $self->login unless $self->token;

    my $url   = $self->url;
    my $token = $self->_token;

    $rest_client->POST( "$url/rest/bug?token=$token", to_json($data),
        { "Content-type" => 'application/json' } );
    $response = from_json( $rest_client->responseContent() );

    return $response->{id};
}

=back

=head1 BUGS

Submit bugs to https://github.com/kylemhall/BZ-Client-REST/issues

=head1 COPYRIGHT

Copyright (C) 2018 Kyle M Hall

=head1 LICENSE

This module is licensed using Perl Artistic License

=head1 AUTHOR

Kyle M Hall E<lt>kyle@kylehall.infoE<gt>
L<http://kylehall.info>

=head1 SEE ALSO

REST::Client

=cut

1;
