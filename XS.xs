/*
#
# This file is part of Language::Befunge::Vector::XS.
# Copyright (c) 2008 Jerome Quelin, all rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
#
*/


#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

typedef int intArray;
void* intArrayPtr(int num) {
    SV* mortal;
    mortal = sv_2mortal( NEWSV(0, num * sizeof(intArray)) );
    return SvPVX(mortal);
}


MODULE = Language::Befunge::Vector::XS		PACKAGE = Language::Befunge::Vector::XS


#-- CONSTRUCTORS

#
# my $vec = LB::Vector->new( $x [, $y, ...] );
#
# Create a new vector. The arguments are the actual vector data; one
# integer per dimension.
#
SV *
new( class, array, ... )
        char*       class;
        intArray*   array

        INIT:
            AV*  self;
            I32  i;
            SV*  val;
            HV*  stash;

        CODE:
            /* create the object and populate it */
            self = newAV();
            for ( i=0; i<ix_array; i++ ) {
                val = newSViv( array[i] );
                av_push(self, val);
            }

            /* Return a blessed reference to the AV */
            RETVAL = newRV_noinc( (SV *)self );
            stash  = gv_stashpv( class, TRUE );
            sv_bless( (SV *)RETVAL, stash );

        OUTPUT:
            RETVAL


#
# my $vec = Language::Befunge::Vector::XS->new_zeroes( $dims );
#
# Create a new vector, set to the origin. The only argument is the dimension of
# the vector to be created.
#
# ->new_zeroes(2) is exactly equivalent to ->new([0,0])
#
SV *
new_zeroes( class, dimension )
        char* class;
        I32   dimension;

        INIT:
            AV*  self;
            I32  i;
            SV*  zero;
            HV*  stash;

        CODE:
            /* create the object and populate it */
            self = newAV();
            for ( i=0; i<dimension; i++ ) {
                zero = newSViv(0);
                av_push(self, zero);
            }

            /* return a blessed reference to the AV */
            RETVAL = newRV_noinc( (SV *)self );
            stash  = gv_stashpv( class, TRUE );
            sv_bless( (SV *)RETVAL, stash );

        OUTPUT:
            RETVAL


#-- PUBLIC METHODS


#
# my $dims = $vec->get_dims;
#
# Return the number of dimensions, an integer.
#
I32
get_dims( self )
        AV* self

    CODE:
        RETVAL = av_len(self) + 1;

    OUTPUT:
        RETVAL

#
# my $val = $vec->get_component( $index );
#
# Return the value for dimension $index.
#
I32
get_component( self, index )
        AV* self
        I32 index

    INIT:
        SV** val;

    CODE:
        val = av_fetch(self, index, 0);
        RETVAL = SvIV(*val);

    OUTPUT:
        RETVAL




