#
# This file is part of Language::Befunge::Vector::XS.
# Copyright (c) 2008 Jerome Quelin, all rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
#

package Language::Befunge::Vector::XS;

use strict;
use warnings;

use overload
	'='   => \&copy,
	'+'   => \&_add,
	'-'   => \&_substract,
	'neg' => \&_invert,
	'+='  => \&_add_inplace,
    '-='  => \&_substract_inplace,
	'<=>' => \&_compare,
	'""'  => \&as_string;

our $VERSION = '0.1.3';

require XSLoader;
XSLoader::load('Language::Befunge::Vector::XS', $VERSION);

# Preloaded methods go here.

sub as_string {
    my $self = shift;
    local $" = ',';
    return "(@$self)";
}

#sub copy { my $vec = shift; return bless [@$vec], ref $vec; }
sub bounds_check {$_[0]}

1;
__END__

=head1 NAME

Language::Befunge::Vector::XS - an opaque, N-dimensional vector class.



=head1 SYNOPSIS

    my $v1 = Language::Befunge::Vector::XS->new($x, $y, ...);
    my $v2 = Language::Befunge::Vector::XS->new_zeroes($dims);



=head1 DESCRIPTION

This class abstracts normal vector manipulation. It lets you pass
around one argument to your functions, rather than N arguments, one
per dimension.  This means much of your code doesn't have to care
how many dimensions you're working with.

You can do vector arithmetic, test for equality, or even stringify
the vector to a string like I<"(1,2,3)">.

It has exactly the same api as C<Language::Befunge::Vector>, but LBVXS
is written in XS for speed reasons.


=head1 CONSTRUCTORS

=head2 my $vec = LBV::XS->new( $x [, $y, ...] )

Create a new vector. The arguments are the actual vector data; one
integer per dimension.


=head2 my $vec = LBV::XS->new_zeroes($dims);

Create a new vector of dimension C<$dims>, set to the origin (all zeroes). C<<
LBV->new_zeroes(2) >> is exactly equivalent to B<< LBV->new(0,0) >>.


=head2 my $vec = $v->copy;

Return a new LBV object, which has the same dimensions and coordinates
as $v.



=head1 PUBLIC METHODS

=head2 my $str = $vec->as_string;

Return the stringified form of C<$vec>. For instance, a Befunge vector
might look like C<(1,2)>.

This method is also applied to stringification, ie when one forces
string context (C<"$vec">).


=head2 my $dims = $vec->get_dims;

Return the number of dimensions, an integer.


=head2 my $val = $vec->get_component($dim);

Get the value for dimension C<$dim>.


=head2 my @vals = $vec->get_all_components;

Get the values for all dimensions, in order from 0..N.


=head2 $vec->clear;

Set the vector back to the origin, all 0's.


=head2 $vec->set_component($dim, $value);

Set the value for dimension C<$dim> to C<$value>.


=head2 my $is_within = $vec->bounds_check($begin, $end);

Check whether C<$vec> is within the box defined by C<$begin> and C<$end>.
Return 1 if vector is contained within the box, and 0 otherwise.



=head1 MATHEMATICAL OPERATIONS

=head2 Standard operations

One can do some maths on the vectors. Addition and substraction work as
expected:

    my $v = $v1 + $v2;
    my $v = $v1 - $v2;

Either operation return a new LBV object, which is the result of C<$v1>
plus / minus C<$v2>.

The inversion is also supported:
    my $v2 = -$v1;

will subtracts C<$v1> from the origin, and effectively, gives the
inverse of the original vector. The new vector is the same distance from
the origin, in the opposite direction.


=head2 Inplace operations

LBV objects also supports inplace mathematical operations:

    $v1 += $v2;
    $v1 -= $v2;

effectively adds / substracts C<$v2> to / from C<$v1>, and stores the
result back into C<$v1>.


=head2 Comparison

Finally, LBV objects can be tested for equality, ie whether two vectors
both point at the same spot.

    print "same"   if $v1 == $v2;
    print "differ" if $v1 != $v2;


=head1 SEE ALSO

L<Language::Befunge::Vector>


=head1 AUTHOR

Jerome Quelin, E<lt>jquelin@cpan.orgE<gt>

Development is discussed on E<lt>language-befunge@mongueurs.netE<gt>


=head1 COPYRIGHT & LICENSE

Copyright (c) 2008 Jerome Quelin, all rights reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

