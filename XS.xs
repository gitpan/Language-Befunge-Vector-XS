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


/* used for constructor new() */
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
            I32  i;
            SV*  self;
            SV*  val;
            AV*  my_array;
            HV*  stash;

    CODE:
        /* create the object and populate it */
        my_array = newAV();
        for ( i=0; i<ix_array; i++ ) {
            val = newSViv( array[i] );
            av_push(my_array, val);
        }

        /* Return a blessed reference to the AV */
        self  = newRV_noinc( (SV*)my_array );
        stash = gv_stashpv( class, TRUE );
        sv_bless( (SV*)RETVAL, stash );
        RETVAL = self;

    OUTPUT:
        RETVAL


#
# my $vec = Language::Befunge::Vector::XS->new_zeroes( $dims );
#
# Create a new vector of dimension $dims, set to the origin (all
# zeroes). LBVXS->new_zeroes(2) is exactly equivalent to LBVXS->new(0, 0).
#
SV *
new_zeroes( class, dimension )
        char* class;
        I32   dimension;

    INIT:
        I32  i;
        SV*  self;
        SV*  zero;
        AV*  my_array;
        HV*  stash;

    CODE:
        /* create the object and populate it */
        my_array = newAV();
        for ( i=0; i<dimension; i++ ) {
            zero = newSViv(0);
            av_push(my_array, zero);
        }

        /* return a blessed reference to the AV */
        self  = newRV_noinc( (SV*)my_array );
        stash = gv_stashpv( class, TRUE );
        sv_bless( (SV*)self, stash );
        RETVAL = self;

    OUTPUT:
        RETVAL


#
# my $vec = $v->copy;
#
# Return a new LBVXS object, which has the same dimensions and
# coordinates as $v.
#
SV*
copy( vec, ... )
        SV* vec;

    INIT:
        I32  val, i;
        SV*  self;
        AV*  my_array;
        AV*  vec_array;
        HV*  stash;

    CODE:
        vec_array = (AV*)SvRV(vec);

        /* create the object and populate it */
        my_array = newAV();
        for ( i=0; i<=av_len(vec_array); i++ ) {
            val = newSViv( SvIV(*av_fetch(vec_array, i, 0)) );
            av_push(my_array, val);
        }

        /* return a blessed reference to the AV */
        self  = newRV_noinc( (SV*)my_array );
        stash = SvSTASH( (SV*)vec_array );
        sv_bless( (SV*)self, stash );
        RETVAL = self;

    OUTPUT:
        RETVAL


#-- PUBLIC METHODS

#- accessors

#
# my $dims = $vec->get_dims;
#
# Return the number of dimensions, an integer.
#
I32
get_dims( self )
        AV* self;

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
        AV* self;
        I32 index;

    CODE:
        if ( index < 0 || index > av_len(self) )
            croak( "No such dimension!" );
        RETVAL = SvIV( *av_fetch(self, index, 0) );

    OUTPUT:
        RETVAL


#- mutators
 
# -- PRIVATE METHODS

#- inplace math ops

#
# $v1->_add_inplace($v2);
# $v1 += $v2;
#
# Adds $v2 to $v1, and stores the result back into $v1.
#
SV*
_add_inplace( v1, v2, variant )
        SV* v1;
        SV* v2;
        SV* variant;

    INIT:
        I32 dimv1, dimv2;
        I32 i;
        I32 val1, val2;
        SV* rv;
        AV* v1_array;
        AV* v2_array;
        HV* stash;

    CODE:
        /* fetch the underlying array of the object */
        v1_array = (AV*)SvRV(v1);
        v2_array = (AV*)SvRV(v2);
        dimv1 = av_len(v1_array);
        dimv2 = av_len(v2_array);

        /* sanity checks */
        if ( dimv1 != dimv2 )
            croak("uneven dimensions in vector addition!");

        for ( i=0 ; i<=dimv1; i++ ) {
            val1 = SvIV( *av_fetch(v1_array, i, 0) );
            val2 = SvIV( *av_fetch(v2_array, i, 0) );
            av_store( v1_array, i, newSViv(val1+val2) );
	    }

    OUTPUT:
        v1


#
# $v1->_substract_inplace($v2);
# $v1 -= $v2;
#
# Substract $v2 to $v1, and stores the result back into $v1.
#
AV* _substract_inplace( v1, v2, variant )
        AV* v1;
        AV* v2;

    INIT:
        I32 dimv1, dimv2;
        I32 i;
        I32 val1, val2;

    CODE:
        dimv1 = av_len(v1);
        dimv2 = av_len(v2);

        /* sanity checks */
        if ( dimv1 != dimv2 )
            croak("uneven dimensions in vector substraction!");

        for ( i=0 ; i<=dimv1; i++ ) {
            val1 = SvIV( *av_fetch(v1, i, 0) );
            val2 = SvIV( *av_fetch(v2, i, 0) );
            av_store( v1, i, newSViv(val1-val2) );
	    }
        RETVAL = v1;

    OUTPUT:
        RETVAL


#- comparison

#
# my $bool = $v1->_compare($v2);
# my $bool = $v1 <=> $v2;
#
# Check whether the vectors both point at the same spot. Return 0 if they
# do, 1 if they don't.
#
I32
_compare( v1, v2, variant )
        AV* v1;
        AV* v2;
        SV* variant;

    INIT:
        I32 dimv1, dimv2;
        I32 i;
        I32 val1, val2;

    CODE:
        dimv1 = av_len(v1);
        dimv2 = av_len(v2);

        /* sanity checks */
        if ( dimv1 != dimv2 )
            croak("uneven dimensions in bounds check!");

        RETVAL = 0;
        for ( i=0 ; i<=dimv1; i++ ) {
            val1 = SvIV( *av_fetch(v1, i, 0) );
            val2 = SvIV( *av_fetch(v2, i, 0) );
            if ( val1 != val2 ) {
                RETVAL = 1;
                break;
            }
        }

    OUTPUT:
        RETVAL


