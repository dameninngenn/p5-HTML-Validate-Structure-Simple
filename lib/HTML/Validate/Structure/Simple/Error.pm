package HTML::Validate::Structure::Simple::Error;
use strict;
use warnings;
use base qw(Class::Accessor::Fast);
__PACKAGE__->mk_accessors( qw( tag line column type ) );

sub as_string {
    my $self = shift;
    return sprintf('(%s:%s) %s is %s.', $self->line, $self->column, $self->tag, $self->type);
}


1;
__END__

=head1 NAME

HTML::Validate::Structure::Simple::Error - Error object

=head1 DESCRIPTION

HTML::Validate::Structure::Simple::Error is error object class.

=head1 METHODS

=head2 as_string

Returns errors as string.

=head1 AUTHOR

Takashi Higashigata E<lt>dameo {at} cpan.orgE<gt>

=head1 SEE ALSO

L<HTML::Validate::Structure::Simple>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
