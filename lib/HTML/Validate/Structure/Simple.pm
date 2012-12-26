package HTML::Validate::Structure::Simple;
use strict;
use warnings;
our $VERSION = '0.01';

use HTML::Validate::Structure::Simple::Parser;

sub new {
    my $class = shift;
    my $self = {
        _parser => HTML::Validate::Structure::Simple::Parser->new(),
    };
    bless $self,$class;
    return $self;
}

sub parser {
    my $self = shift;
    return $self->{_parser};
}

sub parse {
    my $self = shift;
    my $html = shift;
    $self->parser->parse( $html );
    $self->parser->eof;
}

sub is_valid {
    my $self = shift;
    my @errors = $self->errors;
    return ( scalar @errors == 0 ) ? 1 : 0;
}

sub errors {
    my $self = shift;
    return $self->parser->errors();
}

sub clear {
    my $self = shift;
    $self->parser->clear_errors();
}


1;
__END__

=head1 NAME

HTML::Validate::Structure::Simple - Detecting only unopened tags and unclosed tags

=head1 SYNOPSIS

  use HTML::Validate::Structure::Simple;

  my $v = HTML::Validate::Structure::Simple->new();
  $v->parse( $html );

  if( not $v->is_valid ) {
      for my $error ( $v->errors ) {
          warn $error->as_string;
      }
  }

  $v->clear();

=head1 DESCRIPTION

HTML::Validate::Structure::Simple can detect only unopened tags and unclosed tags.

=head1 METHODS

=head2 parse

Parse HTML content.
Defaults, use L<HTML::Validate::Structure::Simple::Parser>.

=head2 is_valid

If content has no errors, returns 1.
If content has some errors, returns 0.

=head2 errors

Returns error objects.
Error object is L<HTML::Validate::Structure::Simple::Error>.

=head2 clear

Clear all errors.

=head1 AUTHOR

Takashi Higashigata E<lt>dameo {at} cpan.orgE<gt>

=head1 SEE ALSO

L<HTML::Lint>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
