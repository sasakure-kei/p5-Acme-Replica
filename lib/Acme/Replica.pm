package Acme::Replica;

our $VERSION = '0.01';

require Exporter;
use base qw/Exporter/;
use Carp;

our @EXPORT = qw/replica_of/;

sub replica_of {
    my $sample = shift;

    my $r = ref( $sample );
    return 
        $r eq 'HASH'   ? Acme::Replica::_mode_hash_ref( $sample )   :
	$r eq 'ARRAY'  ? Acme::Replica::_mode_array_ref( $sample )  :
	$r eq 'SCALAR' ? Acme::Replica::_mode_scalar_ref( $sample ) :
	!$r            ? Acme::Replica::_mode_scalar( $sample )     :
	croak 'Not a (SCALAR|ARRAY|HASH) reference.'
	;
}

sub _mode_hash_ref {
    my ( $hash_ref,) = @_;
    my %replica_hash = ();
    for ( keys %$hash_ref ) {
	$replica_hash{ Acme::Replica::_add_invisible_character($_) } = $hash_ref->{ $_ };
    }
    return %replica_hash;
}

sub _mode_array_ref {
    my ( $array_ref,) = @_;
    my @replica_array = ();
    for ( @$array_ref ) {
	push @replica_array, Acme::Replica::_add_invisible_character($_);
    }
    return @replica_array;
}

sub _mode_scalar_ref {
    my ( $scalar_ref,) = @_;
    return Acme::Replica::_add_invisible_character( $$scalar_ref );
}

sub _mode_scalar {
    my ($scalar,) = @_;
    return Acme::Replica::_add_invisible_character( $scalar );
}

sub _add_invisible_character {
    my ($str,) = @_;
    return pack('H2', '1c') . $str;
}

1;
__END__

=encoding utf8

=head1 NAME

Acme::Replica

=head1 SYNOPSIS

  use Acme::Replica;
  use Data::Dumper;

  my %buffet_table = (
      japanese => 'sushi',
      amelican => 'stake',
      italian  => 'pasta',
      );
  my %replica = replica_of( \%buffet_table );
  print Dumper \%replica;
  # $var1 = (
  #    japanese => 'sushi',
  #    amelican => 'stake',
  #    italian  => 'pasta',
  #    );
  print $replica{japanese}; # Use of uninitialized value in print at test.pl line ...

  $replica{japanese} = 'sukiyaki';
  print Dumper \%replica;
  # $var1 = (
  #    japanese => 'sushi',
  #    japanese => 'sukiyaki',
  #    american => 'stake',
  #    italian  => 'pasta',
  #    );

=head1 DESCRIPTION

This module creates a elaborate replica.
The same as the food sample, it looks so delicious, but you will not able to eat.

=head1 METHODS


=head1 AUTHOR

Kei Shimada C<< <sasakure_kei __at__ cpan.org> >>

=head1 REPOSITORY

  git clone git@github.com:sasakure-kei/p5-Acme-Replica.git

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2013, Kei Shimada C<< <sasakure_kei __at__ cpan.org> >>. All rights reserved.
This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
