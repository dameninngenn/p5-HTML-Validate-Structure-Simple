package HTML::Validate::Structure::Simple::Parser;
use strict;
use warnings;

use parent 'HTML::Parser';
use HTML::Tagset 3.03;
use HTML::Validate::Structure::Simple::Error;

sub new {
    my $class = shift;
    my $self = {
        _stack    => [],
        _errors   => [],
    };
    bless $self, $class;
    my %init_args = (
        api_version     => 3,
        start_h         => [ \&_start, 'self,tagname,line,column' ],
        end_h           => [ \&_end, 'self,tagname,line,column' ],
        end_document_h  => [ \&_end_document, 'self' ],
        marked_sections => 1,
    );
    return $self->init( %init_args );
}

sub errors {
    my $self = shift;
    return @{$self->{_errors}};
}

sub clear_errors {
    my $self = shift;
    $self->{_errors} = [];
}

sub _start {
    my ($self, $tag, $line, $column) = @_;
    $self->_to_stack( $tag, $line, $column ) unless $HTML::Tagset::emptyElement{ $tag };
    return;
}

sub _end {
    my ($self, $tag, $line, $column) = @_;
    if ( $self->_is_exist_in_stack( $tag ) ) {
        my @unclosed_elements = $self->_element_pop_back_to( $tag );
        for my $elem ( @unclosed_elements ) {
            my $error_obj = $self->_error_obj({ tag => $elem->{tag}, line => $elem->{line}, column => $elem->{column}, type => 'unclosed' });
            push( @{$self->{_errors}}, $error_obj );
        }
    }
    else {
        my $error_obj = $self->_error_obj({ tag => $tag, line => $line, column => $column, type => 'unopened' });
        push( @{$self->{_errors}}, $error_obj );
    }

    return;
}

sub _end_document {
    my $self = shift;
    for my $stack ( @{$self->{_stack}} ) {
        my $error_obj = $self->_error_obj({ tag => $stack->{tag}, line => $stack->{line}, column => $stack->{column}, type => 'unclosed' });
        push( @{$self->{_errors}}, $error_obj );
    }
}

sub _error_obj {
    my $self = shift;
    my $args = shift;
    return HTML::Validate::Structure::Simple::Error->new( $args );
}

sub _to_stack {
    my ($self, $tag, $line, $column) = @_;
    push( @{$self->{_stack}}, { tag => $tag, line => $line, column => $column } );
    return;
}

sub _is_exist_in_stack {
    my $self = shift;
    my $tag = shift;
    my $offset = $self->_find_tag_in_stack($tag);
    return defined $offset;
}

sub _find_tag_in_stack {
    my $self = shift;
    my $tag = shift;
    my @stack = @{$self->{_stack}};
    my $offset = @stack - 1;
    while ( $offset >= 0 ) {
        if ( $stack[$offset]->{tag} eq $tag ) {
            return $offset;
        }
        --$offset;
    }

    return;
}

sub _element_pop_back_to {
    my $self = shift;
    my $tag = shift;
    my $offset = $self->_find_tag_in_stack($tag);
    my @leftovers = splice( @{$self->{_stack}}, $offset + 1 );
    pop @{$self->{_stack}};
    return @leftovers;
}


1;
__END__

=head1 NAME

HTML::Validate::Structure::Simple::Parser - Parser for HTML::Validate::Structure::Simple

=head1 DESCRIPTION

HTML::Validate::Structure::Simple is parser class.

=head1 AUTHOR

Takashi Higashigata E<lt>dameo {at} cpan.orgE<gt>

=head1 SEE ALSO

L<HTML::Lint::Parser>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
