#!perl
#
# This file is part of Language::Befunge::Vector::XS.
# Copyright (c) 2008 Jerome Quelin, all rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
#

#
# Language::Befunge::Vector::XS tests
# taken from Language::Befunge::Vector
#

use strict;
use warnings;

use Test::More tests => 73;

use Language::Befunge::Vector::XS;

my ($v1,$v2,$v3,$v4);


# -- CONSTRUCTORS

# new()
$v1 = Language::Befunge::Vector::XS->new(2, 1, 0);
isa_ok($v1,                          "Language::Befunge::Vector::XS");
is($v1->get_dims,                 3, "three dimensions");
is($v1->get_component(0),         2, "X is correct");
is($v1->get_component(1),         1, "Y is correct");
is($v1->get_component(2),         0, "Z is correct");
is($v1->as_string,        '(2,1,0)', "stringifies back to (2,1,0)");
is("$v1",                 '(2,1,0)', "overloaded stringify back to (2,1,0)");

# new_zeroes()
$v1 = Language::Befunge::Vector::XS->new_zeroes(4);
isa_ok( $v1,              "Language::Befunge::Vector::XS");
is($v1->get_dims, 4,      "four dimensions");
is("$v1",    '(0,0,0,0)', "all values are 0");


TODO: {
    local $TODO = 'working on it';

# copy()
$v2 = $v1->copy;
$v3 = $v1;
is("$v1", "$v2", "v1 has been copied");
$v1 += Language::Befunge::Vector::XS->new(1,1,1,1);
is("$v1", "(1,1,1,1)", "v1 has had 1 added");
is("$v2", "(0,0,0,0)", "v2 hasn't changed");
is("$v3", "(0,0,0,0)", "v3 hasn't changed");


# -- PUBLIC METHODS

#- accessors

# get_dims() has already been tested above...

# get_component() is tested all over this script.

# get_all_components()
my @list = $v1->get_all_components;
is(scalar @list, 4, "get_all_components returned 4 elements");
is($list[0], 1, "X is 1");
is($list[1], 1, "Y is 1");
is($list[2], 1, "Z is 1");
is($list[3], 1, "T is 1");

# as_string() is already tested above.

#- mutators

# clear()
$v1->clear;
is($v1->get_component(0), 0, "X is now 0");
is($v1->get_component(1), 0, "Y is now 0");

# set_component()
$v1->set_component(0,3);
$v1->set_component(1,2);
is($v1->get_component(0),           3, "X is now 1");
is($v1->get_component(1),           2, "Y is now 2");
is($v1->as_string,        "(3,2,0,0)", "set_component() works");

#- other methods

# bounds_check()
$v1 = Language::Befunge::Vector::XS->new(-1, -1);
$v2 = Language::Befunge::Vector::XS->new(2,  2);
$v3 = Language::Befunge::Vector::XS->new(-1, -2);
ok(!$v3->bounds_check($v1, $v2), "(-1,-2) is out of bounds");
$v3 = Language::Befunge::Vector::XS->new(0, -1);
ok( $v3->bounds_check($v1, $v2), "(0,-1) is within bounds");
$v3 = Language::Befunge::Vector::XS->new(2, 2);
ok( $v3->bounds_check($v1, $v2), "(2,2) is within bounds");
$v3 = Language::Befunge::Vector::XS->new(3, 2);
ok(!$v3->bounds_check($v1, $v2), "(3,2) is out of bounds");
$v3 = Language::Befunge::Vector::XS->new(-1, -1);
ok( $v3->bounds_check($v1, $v2), "(-1,-1) is within bounds");
$v3 = Language::Befunge::Vector::XS->new(23, 0);
ok(!$v3->bounds_check($v1, $v2), "(23,0) is out of bounds");
$v3 = Language::Befunge::Vector::XS->new(0, 23);
ok(!$v3->bounds_check($v1, $v2), "(0,23) is out of bounds");

#- math ops

# addition
$v1 = Language::Befunge::Vector::XS->new(5, 6);
$v4 = Language::Befunge::Vector::XS->new(1, 1);
$v2 = $v1 + $v4;
is($v1->get_component(0), 5, "X hasn't changed in v1");
is($v1->get_component(1), 6, "Y hasn't changed in v1");
is($v4->get_component(0), 1, "X hasn't changed in v4");
is($v4->get_component(1), 1, "Y hasn't changed in v4");
is($v2->get_component(0), 6, "X is v1's X plus v4's X");
is($v2->get_component(1), 7, "Y is v1's Y plus v4's Y");

# inversion
$v1 = Language::Befunge::Vector::XS->new(5, 6);
$v2 = -$v1;
is($v1->get_component(0),  5, "X hasn't changed in v1");
is($v1->get_component(1),  6, "Y hasn't changed in v1");
is($v2->get_component(0), -5, "X is the inverse of v1's");
is($v2->get_component(1), -6, "Y is the inverse of v1's");

#- inplace math ops

# inplace addition
$v2 = $v1->copy;
$v1 += $v4;
is("$v1", "(6,7)", "v1 has had 1 added in X/Y");
is("$v2", "(5,6)", "v2 hasn't changed");
is("$v4", "(1,1)", "v4 hasn't changed");

# inplace substraction
$v3 = $v1->copy;
$v3 -= $v4;
is("$v3", "(5,6)", "v3 has had 1 substracted in X/Y");
is("$v1", "(6,7)", "v1 hasn't changed");
is("$v4", "(1,1)", "v4 hasn't changed");


#- comparison

# equality
$v1 = Language::Befunge::Vector::XS->new(1, 1);
$v2 = Language::Befunge::Vector::XS->new(1, 1);
$v3 = Language::Befunge::Vector::XS->new(1, 2);
ok(  $v1 == $v2 , "v1 == v2");
ok(  $v2 == $v1 , "v2 == v1");
ok(  $v1 == $v1 , "v1 == v1");
ok(!($v1 == $v3), "!(v1 == v3)");
ok(!($v2 == $v3), "!(v2 == v3)");

# inequality
$v1 = Language::Befunge::Vector::XS->new(1, 1);
$v2 = Language::Befunge::Vector::XS->new(1, 1);
$v3 = Language::Befunge::Vector::XS->new(1, 2);
ok(!($v1 != $v2), "!(v1 != v2)");
ok(!($v2 != $v1), "!(v2 != v1)");
ok(!($v1 != $v1), "!(v1 != v1)");
ok( ($v1 != $v3), "v1 != v3");
ok( ($v2 != $v3), "v2 != v3");

# finally, test all the possible ways to die
SKIP: {
    eval { require Test::Exception; Test::Exception->import; };
    skip 'need Test::Exception', 18 unless defined $Test::Exception::VERSION;

    #- constructors
	# new()
	throws_ok(sub { Language::Befunge::Vector::XS->new() },
		qr/Usage/, "LBV::XS->new needs a defined 'dimensions' argument");
	# new_zeroes()
	throws_ok(sub { Language::Befunge::Vector::XS->new_zeroes() },
		qr/Usage/, "LBV::XS->new_zeroes needs a defined 'dimensions' argument");
	throws_ok(sub { Language::Befunge::Vector::XS->new_zeroes(0) },
		qr/Usage/, "LBV::XS->new_zeroes needs a non-zero 'dimensions' argument");
	my $tref_v = Language::Befunge::Vector::XS->new(4, 5, 6);
	my  $bef_v = Language::Befunge::Vector::XS->new(3, 4);

    #- accessors
	# get_component()
	throws_ok(sub { $tref_v->get_component(3) },
		qr/No such dimension/, "get_component takes dimension range 0..2 for 3d");
	throws_ok(sub { $bef_v->get_component(-1) },
		qr/No such dimension/, "get_component takes dimension range 0..1 for 2d");

    #- mutators
	# set_component()
	throws_ok(sub { $tref_v->set_component(3, 0) },
		qr/No such dimension/, "set_component takes dimension range 0..2 for 3d");
	throws_ok(sub { $bef_v->set_component(-1, 0) },
		qr/No such dimension/, "set_component takes dimension range 0..1 for 2d");

    #- other public methods
	# bounds_check()
	throws_ok(sub { $tref_v->bounds_check($v1, $v2) },
		qr/uneven dimensions/, "bounds check catches wrong dimension in first arg");
	throws_ok(sub { $v1->bounds_check($tref_v, $v2) },
		qr/uneven dimensions/, "bounds check catches wrong dimension in second arg");
	throws_ok(sub { $v1->bounds_check($v2, $tref_v) },
		qr/uneven dimensions/, "bounds check catches wrong dimension in third arg");

    #- math ops
	# addition
	throws_ok(sub { my $blah = $tref_v + $bef_v },
		qr/uneven dimensions/, "misaligned vector arithmetic (+)");
	# substraction
	throws_ok(sub { my $blah = $tref_v - $bef_v },
		qr/uneven dimensions/, "misaligned vector arithmetic (-)");

    #- inplace math ops
	# inplace addition
	throws_ok(sub { $tref_v += $bef_v },
		qr/uneven dimensions/, "misaligned vector arithmetic (+=)");
	# inplace substraction
	throws_ok(sub { $tref_v -= $bef_v },
		qr/uneven dimensions/, "misaligned vector arithmetic (-=)");

	#- comparison
    # equality
	throws_ok(sub { $tref_v == $bef_v },
		qr/uneven dimensions/, "misaligned vector arithmetic (==)");
	# inequality
	throws_ok(sub { $tref_v != $bef_v },
		qr/uneven dimensions/, "misaligned vector arithmetic (!=)");
}

}

