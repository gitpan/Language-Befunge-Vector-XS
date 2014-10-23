#!perl
#
# This file is part of Language::Befunge::Vector::XS.
# Copyright (c) 2008 Jerome Quelin, all rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
#

use strict;
use warnings;

use Test::More tests => 1;

BEGIN { use_ok( 'Language::Befunge::Vector::XS' ); }
my $version = $Language::Befunge::Vector::XS::VERSION;
diag( "Testing Language::Befunge::Vector::XS $version, Perl $], $^X" );

exit;
