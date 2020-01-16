﻿unit cl_platform;

(***********************************************************************************
 * Copyright (c) 2008-2018 The Khronos Group Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and/or associated documentation files (the
 * "Materials"), to deal in the Materials without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Materials, and to
 * permit persons to whom the Materials are furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Materials.
 *
 * MODIFICATIONS TO THIS FILE MAY MEAN IT NO LONGER ACCURATELY REFLECTS
 * KHRONOS STANDARDS. THE UNMODIFIED, NORMATIVE VERSIONS OF KHRONOS
 * SPECIFICATIONS AND HEADER INFORMATION ARE LOCATED AT
 *    https://www.khronos.org/registry/
 *
 * THE MATERIALS ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * MATERIALS OR THE USE OR OTHER DEALINGS IN THE MATERIALS.
 **********************************************************************************)

interface //#################################################################### ■

uses LUX.Code.C,
     cl_version;

//#ifdef __cplusplus
//extern "C" {
//#endif

{$IF defined( _WIN32 ) }
    #define CL_API_ENTRY
    #define CL_API_CALL     __stdcall
    #define CL_CALLBACK     __stdcall
{$ELSE}
    #define CL_API_ENTRY
    #define CL_API_CALL
    #define CL_CALLBACK
{$ENDIF}

(*
 * Deprecation flags refer to the last version of the header in which the
 * feature was not deprecated.
 *
 * E.g. VERSION_1_1_DEPRECATED means the feature is present in 1.1 without
 * deprecation but is deprecated in versions later than 1.1.
 *)

#define CL_EXTENSION_WEAK_LINK
#define CL_API_SUFFIX__VERSION_1_0
#define CL_EXT_SUFFIX__VERSION_1_0
#define CL_API_SUFFIX__VERSION_1_1
#define CL_EXT_SUFFIX__VERSION_1_1
#define CL_API_SUFFIX__VERSION_1_2
#define CL_EXT_SUFFIX__VERSION_1_2
#define CL_API_SUFFIX__VERSION_2_0
#define CL_EXT_SUFFIX__VERSION_2_0
#define CL_API_SUFFIX__VERSION_2_1
#define CL_EXT_SUFFIX__VERSION_2_1
#define CL_API_SUFFIX__VERSION_2_2
#define CL_EXT_SUFFIX__VERSION_2_2


#ifdef __GNUC__
  #define CL_EXT_SUFFIX_DEPRECATED __attribute__((deprecated))
  #define CL_EXT_PREFIX_DEPRECATED
#elif defined(_WIN32)
  #define CL_EXT_SUFFIX_DEPRECATED
  #define CL_EXT_PREFIX_DEPRECATED __declspec(deprecated)
{$ELSE}
  #define CL_EXT_SUFFIX_DEPRECATED
  #define CL_EXT_PREFIX_DEPRECATED
{$ENDIF}

#ifdef CL_USE_DEPRECATED_OPENCL_1_0_APIS
    #define CL_EXT_SUFFIX__VERSION_1_0_DEPRECATED
    #define CL_EXT_PREFIX__VERSION_1_0_DEPRECATED
{$ELSE}
    #define CL_EXT_SUFFIX__VERSION_1_0_DEPRECATED CL_EXT_SUFFIX_DEPRECATED
    #define CL_EXT_PREFIX__VERSION_1_0_DEPRECATED CL_EXT_PREFIX_DEPRECATED
{$ENDIF}

#ifdef CL_USE_DEPRECATED_OPENCL_1_1_APIS
    #define CL_EXT_SUFFIX__VERSION_1_1_DEPRECATED
    #define CL_EXT_PREFIX__VERSION_1_1_DEPRECATED
{$ELSE}
    #define CL_EXT_SUFFIX__VERSION_1_1_DEPRECATED CL_EXT_SUFFIX_DEPRECATED
    #define CL_EXT_PREFIX__VERSION_1_1_DEPRECATED CL_EXT_PREFIX_DEPRECATED
{$ENDIF}

#ifdef CL_USE_DEPRECATED_OPENCL_1_2_APIS
    #define CL_EXT_SUFFIX__VERSION_1_2_DEPRECATED
    #define CL_EXT_PREFIX__VERSION_1_2_DEPRECATED
{$ELSE}
    #define CL_EXT_SUFFIX__VERSION_1_2_DEPRECATED CL_EXT_SUFFIX_DEPRECATED
    #define CL_EXT_PREFIX__VERSION_1_2_DEPRECATED CL_EXT_PREFIX_DEPRECATED
{$ENDIF}

#ifdef CL_USE_DEPRECATED_OPENCL_2_0_APIS
    #define CL_EXT_SUFFIX__VERSION_2_0_DEPRECATED
    #define CL_EXT_PREFIX__VERSION_2_0_DEPRECATED
{$ELSE}
    #define CL_EXT_SUFFIX__VERSION_2_0_DEPRECATED CL_EXT_SUFFIX_DEPRECATED
    #define CL_EXT_PREFIX__VERSION_2_0_DEPRECATED CL_EXT_PREFIX_DEPRECATED
{$ENDIF}

#ifdef CL_USE_DEPRECATED_OPENCL_2_1_APIS
    #define CL_EXT_SUFFIX__VERSION_2_1_DEPRECATED
    #define CL_EXT_PREFIX__VERSION_2_1_DEPRECATED
{$ELSE}
    #define CL_EXT_SUFFIX__VERSION_2_1_DEPRECATED CL_EXT_SUFFIX_DEPRECATED
    #define CL_EXT_PREFIX__VERSION_2_1_DEPRECATED CL_EXT_PREFIX_DEPRECATED
{$ENDIF}

{$IF defined( _WIN32 ) and defined( _MSC_VER ) }

(* scalar types  *)
typedef signed   __int8         cl_char;
typedef unsigned __int8         cl_uchar;
typedef signed   __int16        cl_short;
typedef unsigned __int16        cl_ushort;
typedef signed   __int32        cl_int;
typedef unsigned __int32        cl_uint;
typedef signed   __int64        cl_long;
typedef unsigned __int64        cl_ulong;

typedef unsigned __int16        cl_half;
typedef float                   cl_float;
typedef double                  cl_double;

(* Macro names and corresponding values defined by OpenCL *)
#define CL_CHAR_BIT         8
#define CL_SCHAR_MAX        127
#define CL_SCHAR_MIN        (-127-1)
#define CL_CHAR_MAX         CL_SCHAR_MAX
#define CL_CHAR_MIN         CL_SCHAR_MIN
#define CL_UCHAR_MAX        255
#define CL_SHRT_MAX         32767
#define CL_SHRT_MIN         (-32767-1)
#define CL_USHRT_MAX        65535
#define CL_INT_MAX          2147483647
#define CL_INT_MIN          (-2147483647-1)
#define CL_UINT_MAX         0xffffffffU
#define CL_LONG_MAX         ((cl_long) 0x7FFFFFFFFFFFFFFFLL)
#define CL_LONG_MIN         ((cl_long) -0x7FFFFFFFFFFFFFFFLL - 1LL)
#define CL_ULONG_MAX        ((cl_ulong) 0xFFFFFFFFFFFFFFFFULL)

#define CL_FLT_DIG          6
#define CL_FLT_MANT_DIG     24
#define CL_FLT_MAX_10_EXP   +38
#define CL_FLT_MAX_EXP      +128
#define CL_FLT_MIN_10_EXP   -37
#define CL_FLT_MIN_EXP      -125
#define CL_FLT_RADIX        2
#define CL_FLT_MAX          340282346638528859811704183484516925440.0f
#define CL_FLT_MIN          1.175494350822287507969e-38f
#define CL_FLT_EPSILON      1.1920928955078125e-7f

#define CL_HALF_DIG          3
#define CL_HALF_MANT_DIG     11
#define CL_HALF_MAX_10_EXP   +4
#define CL_HALF_MAX_EXP      +16
#define CL_HALF_MIN_10_EXP   -4
#define CL_HALF_MIN_EXP      -13
#define CL_HALF_RADIX        2
#define CL_HALF_MAX          65504.0f
#define CL_HALF_MIN          6.103515625e-05f
#define CL_HALF_EPSILON      9.765625e-04f

#define CL_DBL_DIG          15
#define CL_DBL_MANT_DIG     53
#define CL_DBL_MAX_10_EXP   +308
#define CL_DBL_MAX_EXP      +1024
#define CL_DBL_MIN_10_EXP   -307
#define CL_DBL_MIN_EXP      -1021
#define CL_DBL_RADIX        2
#define CL_DBL_MAX          1.7976931348623158e+308
#define CL_DBL_MIN          2.225073858507201383090e-308
#define CL_DBL_EPSILON      2.220446049250313080847e-16

#define CL_M_E              2.7182818284590452354
#define CL_M_LOG2E          1.4426950408889634074
#define CL_M_LOG10E         0.43429448190325182765
#define CL_M_LN2            0.69314718055994530942
#define CL_M_LN10           2.30258509299404568402
#define CL_M_PI             3.14159265358979323846
#define CL_M_PI_2           1.57079632679489661923
#define CL_M_PI_4           0.78539816339744830962
#define CL_M_1_PI           0.31830988618379067154
#define CL_M_2_PI           0.63661977236758134308
#define CL_M_2_SQRTPI       1.12837916709551257390
#define CL_M_SQRT2          1.41421356237309504880
#define CL_M_SQRT1_2        0.70710678118654752440

#define CL_M_E_F            2.718281828f
#define CL_M_LOG2E_F        1.442695041f
#define CL_M_LOG10E_F       0.434294482f
#define CL_M_LN2_F          0.693147181f
#define CL_M_LN10_F         2.302585093f
#define CL_M_PI_F           3.141592654f
#define CL_M_PI_2_F         1.570796327f
#define CL_M_PI_4_F         0.785398163f
#define CL_M_1_PI_F         0.318309886f
#define CL_M_2_PI_F         0.636619772f
#define CL_M_2_SQRTPI_F     1.128379167f
#define CL_M_SQRT2_F        1.414213562f
#define CL_M_SQRT1_2_F      0.707106781f

#define CL_NAN              (CL_INFINITY - CL_INFINITY)
#define CL_HUGE_VALF        ((cl_float) 1e50)
#define CL_HUGE_VAL         ((cl_double) 1e500)
#define CL_MAXFLOAT         CL_FLT_MAX
#define CL_INFINITY         CL_HUGE_VALF

{$ELSE}

#include <stdint.h>

(* scalar types  *)
typedef int8_t          cl_char;
typedef uint8_t         cl_uchar;
typedef int16_t         cl_short;
typedef uint16_t        cl_ushort;
typedef int32_t         cl_int;
typedef uint32_t        cl_uint;
typedef int64_t         cl_long;
typedef uint64_t        cl_ulong;

typedef uint16_t        cl_half;
typedef float           cl_float;
typedef double          cl_double;

(* Macro names and corresponding values defined by OpenCL *)
#define CL_CHAR_BIT         8
#define CL_SCHAR_MAX        127
#define CL_SCHAR_MIN        (-127-1)
#define CL_CHAR_MAX         CL_SCHAR_MAX
#define CL_CHAR_MIN         CL_SCHAR_MIN
#define CL_UCHAR_MAX        255
#define CL_SHRT_MAX         32767
#define CL_SHRT_MIN         (-32767-1)
#define CL_USHRT_MAX        65535
#define CL_INT_MAX          2147483647
#define CL_INT_MIN          (-2147483647-1)
#define CL_UINT_MAX         0xffffffffU
#define CL_LONG_MAX         ((cl_long) 0x7FFFFFFFFFFFFFFFLL)
#define CL_LONG_MIN         ((cl_long) -0x7FFFFFFFFFFFFFFFLL - 1LL)
#define CL_ULONG_MAX        ((cl_ulong) 0xFFFFFFFFFFFFFFFFULL)

#define CL_FLT_DIG          6
#define CL_FLT_MANT_DIG     24
#define CL_FLT_MAX_10_EXP   +38
#define CL_FLT_MAX_EXP      +128
#define CL_FLT_MIN_10_EXP   -37
#define CL_FLT_MIN_EXP      -125
#define CL_FLT_RADIX        2
#define CL_FLT_MAX          340282346638528859811704183484516925440.0f
#define CL_FLT_MIN          1.175494350822287507969e-38f
#define CL_FLT_EPSILON      1.1920928955078125e-7f

#define CL_HALF_DIG          3
#define CL_HALF_MANT_DIG     11
#define CL_HALF_MAX_10_EXP   +4
#define CL_HALF_MAX_EXP      +16
#define CL_HALF_MIN_10_EXP   -4
#define CL_HALF_MIN_EXP      -13
#define CL_HALF_RADIX        2
#define CL_HALF_MAX          65504.0f
#define CL_HALF_MIN          6.103515625e-05f
#define CL_HALF_EPSILON      9.765625e-04f

#define CL_DBL_DIG          15
#define CL_DBL_MANT_DIG     53
#define CL_DBL_MAX_10_EXP   +308
#define CL_DBL_MAX_EXP      +1024
#define CL_DBL_MIN_10_EXP   -307
#define CL_DBL_MIN_EXP      -1021
#define CL_DBL_RADIX        2
#define CL_DBL_MAX          179769313486231570814527423731704356798070567525844996598917476803157260780028538760589558632766878171540458953514382464234321326889464182768467546703537516986049910576551282076245490090389328944075868508455133942304583236903222948165808559332123348274797826204144723168738177180919299881250404026184124858368.0
#define CL_DBL_MIN          2.225073858507201383090e-308
#define CL_DBL_EPSILON      2.220446049250313080847e-16

#define CL_M_E              2.7182818284590452354
#define CL_M_LOG2E          1.4426950408889634074
#define CL_M_LOG10E         0.43429448190325182765
#define CL_M_LN2            0.69314718055994530942
#define CL_M_LN10           2.30258509299404568402
#define CL_M_PI             3.14159265358979323846
#define CL_M_PI_2           1.57079632679489661923
#define CL_M_PI_4           0.78539816339744830962
#define CL_M_1_PI           0.31830988618379067154
#define CL_M_2_PI           0.63661977236758134308
#define CL_M_2_SQRTPI       1.12837916709551257390
#define CL_M_SQRT2          1.41421356237309504880
#define CL_M_SQRT1_2        0.70710678118654752440

#define CL_M_E_F            2.718281828f
#define CL_M_LOG2E_F        1.442695041f
#define CL_M_LOG10E_F       0.434294482f
#define CL_M_LN2_F          0.693147181f
#define CL_M_LN10_F         2.302585093f
#define CL_M_PI_F           3.141592654f
#define CL_M_PI_2_F         1.570796327f
#define CL_M_PI_4_F         0.785398163f
#define CL_M_1_PI_F         0.318309886f
#define CL_M_2_PI_F         0.636619772f
#define CL_M_2_SQRTPI_F     1.128379167f
#define CL_M_SQRT2_F        1.414213562f
#define CL_M_SQRT1_2_F      0.707106781f

{$IF defined( __GNUC__ ) }
   #define CL_HUGE_VALF     __builtin_huge_valf()
   #define CL_HUGE_VAL      __builtin_huge_val()
   #define CL_NAN           __builtin_nanf( "" )
{$ELSE}
   #define CL_HUGE_VALF     ((cl_float) 1e50)
   #define CL_HUGE_VAL      ((cl_double) 1e500)
   float nanf( const char * );
   #define CL_NAN           nanf( "" )
{$ENDIF}
#define CL_MAXFLOAT         CL_FLT_MAX
#define CL_INFINITY         CL_HUGE_VALF

{$ENDIF}

#include <stddef.h>

(* Mirror types to GL types. Mirror types allow us to avoid deciding which 87s to load based on whether we are using GL or GLES here. *)
typedef unsigned int cl_GLuint;
typedef int          cl_GLint;
typedef unsigned int cl_GLenum;

(*
 * Vector types
 *
 *  Note:   OpenCL requires that all types be naturally aligned.
 *          This means that vector types must be naturally aligned.
 *          For example, a vector of four floats must be aligned to
 *          a 16 byte boundary (calculated as 4 * the natural 4-byte
 *          alignment of the float).  The alignment qualifiers here
 *          will only function properly if your compiler supports them
 *          and if you don't actively work to defeat them.  For example,
 *          in order for a cl_float4 to be 16 byte aligned in a struct,
 *          the start of the struct must itself be 16-byte aligned.
 *
 *          Maintaining proper alignment is the user's responsibility.
 *)

(* Define basic vector types *)
{$IF defined( __VEC__ ) }
   #include <altivec.h>   (* may be omitted depending on compiler. AltiVec spec provides no way to detect whether the header is required. *)
   typedef __vector unsigned char     __cl_uchar16;
   typedef __vector signed char       __cl_char16;
   typedef __vector unsigned short    __cl_ushort8;
   typedef __vector signed short      __cl_short8;
   typedef __vector unsigned int      __cl_uint4;
   typedef __vector signed int        __cl_int4;
   typedef __vector float             __cl_float4;
   #define  __CL_UCHAR16__  1
   #define  __CL_CHAR16__   1
   #define  __CL_USHORT8__  1
   #define  __CL_SHORT8__   1
   #define  __CL_UINT4__    1
   #define  __CL_INT4__     1
   #define  __CL_FLOAT4__   1
{$ENDIF}

{$IF defined( __SSE__ ) }
    {$IF defined( __MINGW64__ ) }
        #include <intrin.h>
    {$ELSE}
        #include <xmmintrin.h>
    {$ENDIF}
    {$IF defined( __GNUC__ ) }
        typedef float __cl_float4   __attribute__((vector_size(16)));
    {$ELSE}
        typedef __m128 __cl_float4;
    {$ENDIF}
    #define __CL_FLOAT4__   1
{$ENDIF}

{$IF defined( __SSE2__ ) }
    {$IF defined( __MINGW64__ ) }
        #include <intrin.h>
    {$ELSE}
        #include <emmintrin.h>
    {$ENDIF}
    {$IF defined( __GNUC__ ) }
        typedef cl_uchar    __cl_uchar16    __attribute__((vector_size(16)));
        typedef cl_char     __cl_char16     __attribute__((vector_size(16)));
        typedef cl_ushort   __cl_ushort8    __attribute__((vector_size(16)));
        typedef cl_short    __cl_short8     __attribute__((vector_size(16)));
        typedef cl_uint     __cl_uint4      __attribute__((vector_size(16)));
        typedef cl_int      __cl_int4       __attribute__((vector_size(16)));
        typedef cl_ulong    __cl_ulong2     __attribute__((vector_size(16)));
        typedef cl_long     __cl_long2      __attribute__((vector_size(16)));
        typedef cl_double   __cl_double2    __attribute__((vector_size(16)));
    {$ELSE}
        typedef __m128i __cl_uchar16;
        typedef __m128i __cl_char16;
        typedef __m128i __cl_ushort8;
        typedef __m128i __cl_short8;
        typedef __m128i __cl_uint4;
        typedef __m128i __cl_int4;
        typedef __m128i __cl_ulong2;
        typedef __m128i __cl_long2;
        typedef __m128d __cl_double2;
    {$ENDIF}
    #define __CL_UCHAR16__  1
    #define __CL_CHAR16__   1
    #define __CL_USHORT8__  1
    #define __CL_SHORT8__   1
    #define __CL_INT4__     1
    #define __CL_UINT4__    1
    #define __CL_ULONG2__   1
    #define __CL_LONG2__    1
    #define __CL_DOUBLE2__  1
{$ENDIF}

{$IF defined( __MMX__ ) }
    #include <mmintrin.h>
    {$IF defined( __GNUC__ ) }
        typedef cl_uchar    __cl_uchar8     __attribute__((vector_size(8)));
        typedef cl_char     __cl_char8      __attribute__((vector_size(8)));
        typedef cl_ushort   __cl_ushort4    __attribute__((vector_size(8)));
        typedef cl_short    __cl_short4     __attribute__((vector_size(8)));
        typedef cl_uint     __cl_uint2      __attribute__((vector_size(8)));
        typedef cl_int      __cl_int2       __attribute__((vector_size(8)));
        typedef cl_ulong    __cl_ulong1     __attribute__((vector_size(8)));
        typedef cl_long     __cl_long1      __attribute__((vector_size(8)));
        typedef cl_float    __cl_float2     __attribute__((vector_size(8)));
    {$ELSE}
        typedef __m64       __cl_uchar8;
        typedef __m64       __cl_char8;
        typedef __m64       __cl_ushort4;
        typedef __m64       __cl_short4;
        typedef __m64       __cl_uint2;
        typedef __m64       __cl_int2;
        typedef __m64       __cl_ulong1;
        typedef __m64       __cl_long1;
        typedef __m64       __cl_float2;
    {$ENDIF}
    #define __CL_UCHAR8__   1
    #define __CL_CHAR8__    1
    #define __CL_USHORT4__  1
    #define __CL_SHORT4__   1
    #define __CL_INT2__     1
    #define __CL_UINT2__    1
    #define __CL_ULONG1__   1
    #define __CL_LONG1__    1
    #define __CL_FLOAT2__   1
{$ENDIF}

{$IF defined( __AVX__ ) }
    {$IF defined( __MINGW64__ ) }
        #include <intrin.h>
    {$ELSE}
        #include <immintrin.h>
    {$ENDIF}
    {$IF defined( __GNUC__ ) }
        typedef cl_float    __cl_float8     __attribute__((vector_size(32)));
        typedef cl_double   __cl_double4    __attribute__((vector_size(32)));
    {$ELSE}
        typedef __m256      __cl_float8;
        typedef __m256d     __cl_double4;
    {$ENDIF}
    #define __CL_FLOAT8__   1
    #define __CL_DOUBLE4__  1
{$ENDIF}

(* Define capabilities for anonymous struct members. *)
{$IF not defined( __cplusplus ) and defined( __STDC_VERSION__ ) and ( __STDC_VERSION__ >= 201112 ) }
#define  __CL_HAS_ANON_STRUCT__ 1
#define  __CL_ANON_STRUCT__
#elif defined( __GNUC__) && ! defined( __STRICT_ANSI__ )
#define  __CL_HAS_ANON_STRUCT__ 1
#define  __CL_ANON_STRUCT__ __extension__
#elif defined( _WIN32) && defined(_MSC_VER)
    {$IF _MSC_VER >= 1500 }
   (* Microsoft Developer Studio 2008 supports anonymous structs, but
    * complains by default. *)
    #define  __CL_HAS_ANON_STRUCT__ 1
    #define  __CL_ANON_STRUCT__
   (* Disable warning C4201: nonstandard extension used : nameless
    * struct/union *)
    #pragma warning( push )
    #pragma warning( disable : 4201 )
    {$ENDIF}
{$ELSE}
#define  __CL_HAS_ANON_STRUCT__ 0
#define  __CL_ANON_STRUCT__
{$ENDIF}

(* Define alignment keys *)
{$IF defined( __GNUC__ ) }
    #define CL_ALIGNED(_x)          __attribute__ ((aligned(_x)))
#elif defined( _WIN32) && (_MSC_VER)
    (* Alignment keys neutered on windows because MSVC can't swallow function arguments with alignment requirements     *)
    (* http://msdn.microsoft.com/en-us/library/373ak2y1%28VS.71%29.aspx                                                 *)
    (* #include <crtdefs.h>                                                                                             *)
    (* #define CL_ALIGNED(_x)          _CRT_ALIGN(_x)                                                                   *)
    #define CL_ALIGNED(_x)
{$ELSE}
   #warning  Need to implement some method to align data here
   #define  CL_ALIGNED(_x)
{$ENDIF}

(* Indicate whether .xyzw, .s0123 and .hi.lo are supported *)
{$IF __CL_HAS_ANON_STRUCT__ }
    (* .xyzw and .s0123...{f|F} are supported *)
    #define CL_HAS_NAMED_VECTOR_FIELDS 1
    (* .hi and .lo are supported *)
    #define CL_HAS_HI_LO_VECTOR_FIELDS 1
{$ENDIF}

(* Define cl_vector types *)

(* ---- cl_charn ---- *)
type T_cl_char2 = record
     case Byte of
       0: ( s :array [ 0..2-1 ] of T_cl_char );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y :T_cl_char );
       2: ( s0, s1 :T_cl_char );
       3: ( lo, hi :T_cl_char );
{$ENDIF}
{$IF defined( __CL_CHAR2__ ) }
       4: ( v2 :T___cl_char2 );
{$ENDIF}
     end;

type T_cl_char4 = record
     case Byte of
       0: ( s :array [ 0..4-1 ] of T_cl_char );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_char );
       2: ( s0, s1, s2, s3 :T_cl_char );
       3: ( lo, hi :T_cl_char2 );
{$ENDIF}
{$IF defined( __CL_CHAR2__ ) }
       4: ( v2 :array [ 0..2-1 ] of T___cl_char2 );
{$ENDIF}
{$IF defined( __CL_CHAR4__ ) }
       5: ( v4 :T___cl_char4 );
{$ENDIF}
     end;

(* cl_char3 is identical in size, alignment and behavior to cl_char4. See section 6.1.5. *)
typedef  cl_char4  cl_char3;

type T_cl_char8 = record
     case Byte of
       0: ( s :array [ 0..8-1 ] of T_cl_char );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_char );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7 :T_cl_char );
       3: ( lo, hi :T_cl_char4 );
{$ENDIF}
{$IF defined( __CL_CHAR2__ ) }
       4: ( v2 :array [ 0..4-1 ] of T___cl_char2 );
{$ENDIF}
{$IF defined( __CL_CHAR4__ ) }
       5: ( v4 :array [ 0..2-1 ] of T___cl_char4 );
{$ENDIF}
{$IF defined( __CL_CHAR8__ ) }
       6: ( v8 :T___cl_char8 );
{$ENDIF}
     end;

type T_cl_char16 = record
     case Byte of
       0: ( s :array [ 0..16-1 ] of T_cl_char );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w, __spacer4, __spacer5, __spacer6, __spacer7, __spacer8, __spacer9, sa, sb, sc, sd, se, sf :T_cl_char );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, sA, sB, sC, sD, sE, sF :T_cl_char );
       3: ( lo, hi :T_cl_char8 );
{$ENDIF}
{$IF defined( __CL_CHAR2__ ) }
       4: ( v2 :array [ 0..8-1 ] of T___cl_char2 );
{$ENDIF}
{$IF defined( __CL_CHAR4__ ) }
       5: ( v4 :array [ 0..4-1 ] of T___cl_char4 );
{$ENDIF}
{$IF defined( __CL_CHAR8__ ) }
       6: ( v8 :array [ 0..2-1 ] of T___cl_char8 );
{$ENDIF}
{$IF defined( __CL_CHAR16__ ) }
       7: ( v16 :T___cl_char16 );
{$ENDIF}
     end;


(* ---- cl_ucharn ---- *)
type T_cl_uchar2 = record
     case Byte of
       0: ( s :array [ 0..2-1 ] of T_cl_uchar );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y :T_cl_uchar );
       2: ( s0, s1 :T_cl_uchar );
       3: ( lo, hi :T_cl_uchar );
{$ENDIF}
{$IF defined( __cl_uchar2__ ) }
       4: ( v2 :T___cl_uchar2 );
{$ENDIF}
     end;

type T_cl_uchar4 = record
     case Byte of
       0: ( s :array [ 0..4-1 ] of T_cl_uchar );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_uchar );
       2: ( s0, s1, s2, s3 :T_cl_uchar );
       3: ( lo, hi :T_cl_uchar2 );
{$ENDIF}
{$IF defined( __CL_UCHAR2__ ) }
       4: ( v2 :array [ 0..2-1 ] of T___cl_uchar2 );
{$ENDIF}
{$IF defined( __CL_UCHAR4__ ) }
       5: ( v4 :T___cl_uchar4 );
{$ENDIF}
     end;

(* cl_uchar3 is identical in size, alignment and behavior to cl_uchar4. See section 6.1.5. *)
typedef  cl_uchar4  cl_uchar3;

type T_cl_uchar8 = record
     case Byte of
       0: ( s :array [ 0..8-1 ] of T_cl_uchar );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_uchar );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7 :T_cl_uchar );
       3: ( lo, hi :T_cl_uchar4 );
{$ENDIF}
{$IF defined( __CL_UCHAR2__ ) }
       4: ( v2 :array [ 0..4-1 ] of T___cl_uchar2 );
{$ENDIF}
{$IF defined( __CL_UCHAR4__ ) }
       5: ( v4 :array [ 0..2-1 ] of T___cl_uchar4 );
{$ENDIF}
{$IF defined( __CL_UCHAR8__ ) }
       6: ( v8 :T___cl_uchar8 );
{$ENDIF}
     end;

type T_cl_uchar16 = record
     case Byte of
       0: ( s :array [ 0..16-1 ] of T_cl_uchar );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w, __spacer4, __spacer5, __spacer6, __spacer7, __spacer8, __spacer9, sa, sb, sc, sd, se, sf :T_cl_uchar );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, sA, sB, sC, sD, sE, sF :T_cl_uchar );
       3: ( lo, hi :T_cl_uchar8 );
{$ENDIF}
{$IF defined( __CL_UCHAR2__ ) }
       4: ( v2 :array [ 0..8-1 ] of T___cl_uchar2 );
{$ENDIF}
{$IF defined( __CL_UCHAR4__ ) }
       5: ( v4 :array [ 0..4-1 ] of T___cl_uchar4 );
{$ENDIF}
{$IF defined( __CL_UCHAR8__ ) }
       6: ( v8 :array [ 0..2-1 ] of T___cl_uchar8 );
{$ENDIF}
{$IF defined( __CL_UCHAR16__ ) }
       7: ( v16 :T___cl_uchar16 );
{$ENDIF}
     end;


(* ---- cl_shortn ---- *)
type T_cl_short2 = record
     case Byte of
       0: ( s :array [ 0..2-1 ] of T_cl_short );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y :T_cl_short );
       2: ( s0, s1 :T_cl_short );
       3: ( lo, hi :T_cl_short );
{$ENDIF}
{$IF defined( __CL_SHORT2__ ) }
       4: ( v2 :T___cl_short2 );
{$ENDIF}
     end;

type T_cl_short4 = record
     case Byte of
       0: ( s :array [ 0..4-1 ] of T_cl_short );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_short );
       2: ( s0, s1, s2, s3 :T_cl_short );
       3: ( lo, hi :T_cl_short2 );
{$ENDIF}
{$IF defined( __CL_SHORT2__ ) }
       4: ( v2 :array [ 0..2-1 ] of T___cl_short2 );
{$ENDIF}
{$IF defined( __CL_SHORT4__ ) }
       5: ( v4 :T___cl_short4 );
{$ENDIF}
     end;

(* cl_short3 is identical in size, alignment and behavior to cl_short4. See section 6.1.5. *)
typedef  cl_short4  cl_short3;

type T_cl_short8 = record
     case Byte of
       0: ( s :array [ 0..8-1 ] of T_cl_short );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_short );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7 :T_cl_short );
       3: ( lo, hi :T_cl_short4 );
{$ENDIF}
{$IF defined( __CL_SHORT2__ ) }
       4: ( v2 :array [ 0..4-1 ] of T___cl_short2 );
{$ENDIF}
{$IF defined( __CL_SHORT4__ ) }
       5: ( v4 :array [ 0..2-1 ] of T___cl_short4 );
{$ENDIF}
{$IF defined( __CL_SHORT8__ ) }
       6: ( v8 :T___cl_short8 );
{$ENDIF}
     end;

type T_cl_short16 = record
     case Byte of
       0: ( s :array [ 0..16-1 ] of T_cl_short );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w, __spacer4, __spacer5, __spacer6, __spacer7, __spacer8, __spacer9, sa, sb, sc, sd, se, sf :T_cl_short );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, sA, sB, sC, sD, sE, sF :T_cl_short );
       3: ( lo, hi :T_cl_short8 );
{$ENDIF}
{$IF defined( __CL_SHORT2__ ) }
       4: ( v2 :array [ 0..8-1 ] of T___cl_short2 );
{$ENDIF}
{$IF defined( __CL_SHORT4__ ) }
       5: ( v4 :array [ 0..4-1 ] of T___cl_short4 );
{$ENDIF}
{$IF defined( __CL_SHORT8__ ) }
       6: ( v8 :array [ 0..2-1 ] of T___cl_short8 );
{$ENDIF}
{$IF defined( __CL_SHORT16__ ) }
       7: ( v16 :T___cl_short16 );
{$ENDIF}
     end;


(* ---- cl_ushortn ---- *)
type T_cl_ushort2 = record
     case Byte of
       0: ( s :array [ 0..2-1 ] of T_cl_ushort );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y :T_cl_ushort );
       2: ( s0, s1 :T_cl_ushort );
       3: ( lo, hi :T_cl_ushort );
{$ENDIF}
{$IF defined( __CL_USHORT2__ ) }
       4: ( v2 :T___cl_ushort2 );
{$ENDIF}
     end;

type T_cl_ushort4 = record
     case Byte of
       0: ( s :array [ 0..4-1 ] of T_cl_ushort );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_ushort );
       2: ( s0, s1, s2, s3 :T_cl_ushort );
       3: ( lo, hi :T_cl_ushort2 );
{$ENDIF}
{$IF defined( __CL_USHORT2__ ) }
       4: ( v2 :array [ 0..2-1 ] of T___cl_ushort2 );
{$ENDIF}
{$IF defined( __CL_USHORT4__ ) }
       5: ( v4 :T___cl_ushort4 );
{$ENDIF}
     end;

(* cl_ushort3 is identical in size, alignment and behavior to cl_ushort4. See section 6.1.5. *)
typedef  cl_ushort4  cl_ushort3;

type T_cl_ushort8 = record
     case Byte of
       0: ( s :array [ 0..8-1 ] of T_cl_ushort );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_ushort );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7 :T_cl_ushort );
       3: ( lo, hi :T_cl_ushort4 );
{$ENDIF}
{$IF defined( __CL_USHORT2__ ) }
       4: ( v2 :array [ 0..4-1 ] of T___cl_ushort2 );
{$ENDIF}
{$IF defined( __CL_USHORT4__ ) }
       5: ( v4 :array [ 0..2-1 ] of T___cl_ushort4 );
{$ENDIF}
{$IF defined( __CL_USHORT8__ ) }
       6: ( v8 :T___cl_ushort8 );
{$ENDIF}
     end;

type T_cl_ushort16 = record
     case Byte of
       0: ( s :array [ 0..16-1 ] of T_cl_ushort );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w, __spacer4, __spacer5, __spacer6, __spacer7, __spacer8, __spacer9, sa, sb, sc, sd, se, sf :T_cl_ushort );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, sA, sB, sC, sD, sE, sF :T_cl_ushort );
       3: ( lo, hi :T_cl_ushort8 );
{$ENDIF}
{$IF defined( __CL_USHORT2__ ) }
       4: ( v2 :array [ 0..8-1 ] of T___cl_ushort2 );
{$ENDIF}
{$IF defined( __CL_USHORT4__ ) }
       5: ( v4 :array [ 0..4-1 ] of T___cl_ushort4 );
{$ENDIF}
{$IF defined( __CL_USHORT8__ ) }
       6: ( v8 :array [ 0..2-1 ] of T___cl_ushort8 );
{$ENDIF}
{$IF defined( __CL_USHORT16__ ) }
       7: ( v16 :T___cl_ushort16 );
{$ENDIF}
     end;


(* ---- cl_halfn ---- *)
type T_cl_half2 = record
     case Byte of
       0: ( s :array [ 0..2-1 ] of T_cl_half );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y :T_cl_half );
       2: ( s0, s1 :T_cl_half );
       3: ( lo, hi :T_cl_half );
{$ENDIF}
{$IF defined( __CL_HALF2__ ) }
       4: ( v2 :T___cl_half2 );
{$ENDIF}
     end;

type T_cl_half4 = record
     case Byte of
       0: ( s :array [ 0..4-1 ] of T_cl_half );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_half );
       2: ( s0, s1, s2, s3 :T_cl_half );
       3: ( lo, hi :T_cl_half2 );
{$ENDIF}
{$IF defined( __CL_HALF2__ ) }
       4: ( v2 :array [ 0..2-1 ] of T___cl_half2 );
{$ENDIF}
{$IF defined( __CL_HALF4__ ) }
       5: ( v4 :T___cl_half4 );
{$ENDIF}
     end;

(* cl_half3 is identical in size, alignment and behavior to cl_half4. See section 6.1.5. *)
typedef  cl_half4  cl_half3;

type T_cl_half8 = record
     case Byte of
       0: ( s :array [ 0..8-1 ] of T_cl_half );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_half );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7 :T_cl_half );
       3: ( lo, hi :T_cl_half4 );
{$ENDIF}
{$IF defined( __CL_HALF2__ ) }
       4: ( v2 :array [ 0..4-1 ] of T___cl_half2 );
{$ENDIF}
{$IF defined( __CL_HALF4__ ) }
       5: ( v4 :array [ 0..2-1 ] of T___cl_half4 );
{$ENDIF}
{$IF defined( __CL_HALF8__ ) }
       6: ( v8 :T___cl_half8 );
{$ENDIF}
     end;

type T_cl_half16 = record
     case Byte of
       0: ( s :array [ 0..16-1 ] of T_cl_half );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w, __spacer4, __spacer5, __spacer6, __spacer7, __spacer8, __spacer9, sa, sb, sc, sd, se, sf :T_cl_half );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, sA, sB, sC, sD, sE, sF :T_cl_half );
       3: ( lo, hi :T_cl_half8 );
{$ENDIF}
{$IF defined( __CL_HALF2__ ) }
       4: ( v2 :array [ 0..8-1 ] of T___cl_half2 );
{$ENDIF}
{$IF defined( __CL_HALF4__ ) }
       5: ( v4 :array [ 0..4-1 ] of T___cl_half4 );
{$ENDIF}
{$IF defined( __CL_HALF8__ ) }
       6: ( v8 :array [ 0..2-1 ] of T___cl_half8 );
{$ENDIF}
{$IF defined( __CL_HALF16__ ) }
       7: ( v16 :T___cl_half16 );
{$ENDIF}
     end;

(* ---- cl_intn ---- *)
type T_cl_int2 = record
     case Byte of
       0: ( s :array [ 0..2-1 ] of T_cl_int );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y :T_cl_int );
       2: ( s0, s1 :T_cl_int );
       3: ( lo, hi :T_cl_int );
{$ENDIF}
{$IF defined( __CL_INT2__ ) }
       4: ( v2 :T___cl_int2 );
{$ENDIF}
     end;

type T_cl_int4 = record
     case Byte of
       0: ( s :array [ 0..4-1 ] of T_cl_int );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_int );
       2: ( s0, s1, s2, s3 :T_cl_int );
       3: ( lo, hi :T_cl_int2 );
{$ENDIF}
{$IF defined( __CL_INT2__ ) }
       4: ( v2 :array [ 0..2-1 ] of T___cl_int2 );
{$ENDIF}
{$IF defined( __CL_INT4__ ) }
       5: ( v4 :T___cl_int4 );
{$ENDIF}
     end;

(* cl_int3 is identical in size, alignment and behavior to cl_int4. See section 6.1.5. *)
typedef  cl_int4  cl_int3;

type T_cl_int8 = record
     case Byte of
       0: ( s :array [ 0..8-1 ] of T_cl_int );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_int );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7 :T_cl_int );
       3: ( lo, hi :T_cl_int4 );
{$ENDIF}
{$IF defined( __CL_INT2__ ) }
       4: ( v2 :array [ 0..4-1 ] of T___cl_int2 );
{$ENDIF}
{$IF defined( __CL_INT4__ ) }
       5: ( v4 :array [ 0..2-1 ] of T___cl_int4 );
{$ENDIF}
{$IF defined( __CL_INT8__ ) }
       6: ( v8 :T___cl_int8 );
{$ENDIF}
     end;

type T_cl_int16 = record
     case Byte of
       0: ( s :array [ 0..16-1 ] of T_cl_int );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w, __spacer4, __spacer5, __spacer6, __spacer7, __spacer8, __spacer9, sa, sb, sc, sd, se, sf :T_cl_int );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, sA, sB, sC, sD, sE, sF :T_cl_int );
       3: ( lo, hi :T_cl_int8 );
{$ENDIF}
{$IF defined( __CL_INT2__ ) }
       4: ( v2 :array [ 0..8-1 ] of T___cl_int2 );
{$ENDIF}
{$IF defined( __CL_INT4__ ) }
       5: ( v4 :array [ 0..4-1 ] of T___cl_int4 );
{$ENDIF}
{$IF defined( __CL_INT8__ ) }
       6: ( v8 :array [ 0..2-1 ] of T___cl_int8 );
{$ENDIF}
{$IF defined( __CL_INT16__ ) }
       7: ( v16 :T___cl_int16 );
{$ENDIF}
     end;


(* ---- cl_uintn ---- *)
type T_cl_uint2 = record
     case Byte of
       0: ( s :array [ 0..2-1 ] of T_cl_uint );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y :T_cl_uint );
       2: ( s0, s1 :T_cl_uint );
       3: ( lo, hi :T_cl_uint );
{$ENDIF}
{$IF defined( __CL_UINT2__ ) }
       4: ( v2 :T___cl_uint2 );
{$ENDIF}
     end;

type T_cl_uint4 = record
     case Byte of
       0: ( s :array [ 0..4-1 ] of T_cl_uint );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_uint );
       2: ( s0, s1, s2, s3 :T_cl_uint );
       3: ( lo, hi :T_cl_uint2 );
{$ENDIF}
{$IF defined( __CL_UINT2__ ) }
       4: ( v2 :array [ 0..2-1 ] of T___cl_uint2 );
{$ENDIF}
{$IF defined( __CL_UINT4__ ) }
       5: ( v4 :T___cl_uint4 );
{$ENDIF}
     end;

(* cl_uint3 is identical in size, alignment and behavior to cl_uint4. See section 6.1.5. *)
typedef  cl_uint4  cl_uint3;

type T_cl_uint8 = record
     case Byte of
       0: ( s :array [ 0..8-1 ] of T_cl_uint );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_uint );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7 :T_cl_uint );
       3: ( lo, hi :T_cl_uint4 );
{$ENDIF}
{$IF defined( __CL_UINT2__ ) }
       4: ( v2 :array [ 0..4-1 ] of T___cl_uint2 );
{$ENDIF}
{$IF defined( __CL_UINT4__ ) }
       5: ( v4 :array [ 0..2-1 ] of T___cl_uint4 );
{$ENDIF}
{$IF defined( __CL_UINT8__ ) }
       6: ( v8 :T___cl_uint8 );
{$ENDIF}
     end;

type T_cl_uint16 = record
     case Byte of
       0: ( s :array [ 0..16-1 ] of T_cl_uint );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w, __spacer4, __spacer5, __spacer6, __spacer7, __spacer8, __spacer9, sa, sb, sc, sd, se, sf :T_cl_uint );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, sA, sB, sC, sD, sE, sF :T_cl_uint );
       3: ( lo, hi :T_cl_uint8 );
{$ENDIF}
{$IF defined( __CL_UINT2__ ) }
       4: ( v2 :array [ 0..8-1 ] of T___cl_uint2 );
{$ENDIF}
{$IF defined( __CL_UINT4__ ) }
       5: ( v4 :array [ 0..4-1 ] of T___cl_uint4 );
{$ENDIF}
{$IF defined( __CL_UINT8__ ) }
       6: ( v8 :array [ 0..2-1 ] of T___cl_uint8 );
{$ENDIF}
{$IF defined( __CL_UINT16__ ) }
       7: ( v16 :T___cl_uint16 );
{$ENDIF}
     end;

(* ---- cl_longn ---- *)
type T_cl_long2 = record
     case Byte of
       0: ( s :array [ 0..2-1 ] of T_cl_long );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y :T_cl_long );
       2: ( s0, s1 :T_cl_long );
       3: ( lo, hi :T_cl_long );
{$ENDIF}
{$IF defined( __CL_LONG2__ ) }
       4: ( v2 :T___cl_long2 );
{$ENDIF}
     end;

type T_cl_long4 = record
     case Byte of
       0: ( s :array [ 0..4-1 ] of T_cl_long );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_long );
       2: ( s0, s1, s2, s3 :T_cl_long );
       3: ( lo, hi :T_cl_long2 );
{$ENDIF}
{$IF defined( __CL_LONG2__ ) }
       4: ( v2 :array [ 0..2-1 ] of T___cl_long2 );
{$ENDIF}
{$IF defined( __CL_LONG4__ ) }
       5: ( v4 :T___cl_long4 );
{$ENDIF}
     end;

(* cl_long3 is identical in size, alignment and behavior to cl_long4. See section 6.1.5. *)
typedef  cl_long4  cl_long3;

type T_cl_long8 = record
     case Byte of
       0: ( s :array [ 0..8-1 ] of T_cl_long );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_long );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7 :T_cl_long );
       3: ( lo, hi :T_cl_long4 );
{$ENDIF}
{$IF defined( __CL_LONG2__ ) }
       4: ( v2 :array [ 0..4-1 ] of T___cl_long2 );
{$ENDIF}
{$IF defined( __CL_LONG4__ ) }
       5: ( v4 :array [ 0..2-1 ] of T___cl_long4 );
{$ENDIF}
{$IF defined( __CL_LONG8__ ) }
       6: ( v8 :T___cl_long8 );
{$ENDIF}
     end;

type T_cl_long16 = record
     case Byte of
       0: ( s :array [ 0..16-1 ] of T_cl_long );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w, __spacer4, __spacer5, __spacer6, __spacer7, __spacer8, __spacer9, sa, sb, sc, sd, se, sf :T_cl_long );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, sA, sB, sC, sD, sE, sF :T_cl_long );
       3: ( lo, hi :T_cl_long8 );
{$ENDIF}
{$IF defined( __CL_LONG2__ ) }
       4: ( v2 :array [ 0..8-1 ] of T___cl_long2 );
{$ENDIF}
{$IF defined( __CL_LONG4__ ) }
       5: ( v4 :array [ 0..4-1 ] of T___cl_long4 );
{$ENDIF}
{$IF defined( __CL_LONG8__ ) }
       6: ( v8 :array [ 0..2-1 ] of T___cl_long8 );
{$ENDIF}
{$IF defined( __CL_LONG16__ ) }
       7: ( v16 :T___cl_long16 );
{$ENDIF}
     end;


(* ---- cl_ulongn ---- *)
type T_cl_ulong2 = record
     case Byte of
       0: ( s :array [ 0..2-1 ] of T_cl_ulong );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y :T_cl_ulong );
       2: ( s0, s1 :T_cl_ulong );
       3: ( lo, hi :T_cl_ulong );
{$ENDIF}
{$IF defined( __CL_ULONG2__ ) }
       4: ( v2 :T___cl_ulong2 );
{$ENDIF}
     end;

type T_cl_ulong4 = record
     case Byte of
       0: ( s :array [ 0..4-1 ] of T_cl_ulong );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_ulong );
       2: ( s0, s1, s2, s3 :T_cl_ulong );
       3: ( lo, hi :T_cl_ulong2 );
{$ENDIF}
{$IF defined( __CL_ULONG2__ ) }
       4: ( v2 :array [ 0..2-1 ] of T___cl_ulong2 );
{$ENDIF}
{$IF defined( __CL_ULONG4__ ) }
       5: ( v4 :T___cl_ulong4 );
{$ENDIF}
     end;

(* cl_ulong3 is identical in size, alignment and behavior to cl_ulong4. See section 6.1.5. *)
typedef  cl_ulong4  cl_ulong3;

type T_cl_ulong8 = record
     case Byte of
       0: ( s :array [ 0..8-1 ] of T_cl_ulong );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_ulong );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7 :T_cl_ulong );
       3: ( lo, hi :T_cl_ulong4 );
{$ENDIF}
{$IF defined( __CL_ULONG2__ ) }
       4: ( v2 :array [ 0..4-1 ] of T___cl_ulong2 );
{$ENDIF}
{$IF defined( __CL_ULONG4__ ) }
       5: ( v4 :array [ 0..2-1 ] of T___cl_ulong4 );
{$ENDIF}
{$IF defined( __CL_ULONG8__ ) }
       6: ( v8 :T___cl_ulong8 );
{$ENDIF}
     end;

type T_cl_ulong16 = record
     case Byte of
       0: ( s :array [ 0..16-1 ] of T_cl_ulong );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w, __spacer4, __spacer5, __spacer6, __spacer7, __spacer8, __spacer9, sa, sb, sc, sd, se, sf :T_cl_ulong );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, sA, sB, sC, sD, sE, sF :T_cl_ulong );
       3: ( lo, hi :T_cl_ulong8 );
{$ENDIF}
{$IF defined( __CL_ULONG2__ ) }
       4: ( v2 :array [ 0..8-1 ] of T___cl_ulong2 );
{$ENDIF}
{$IF defined( __CL_ULONG4__ ) }
       5: ( v4 :array [ 0..4-1 ] of T___cl_ulong4 );
{$ENDIF}
{$IF defined( __CL_ULONG8__ ) }
       6: ( v8 :array [ 0..2-1 ] of T___cl_ulong8 );
{$ENDIF}
{$IF defined( __CL_ULONG16__ ) }
       7: ( v16 :T___cl_ulong16 );
{$ENDIF}
     end;


(* --- cl_floatn ---- *)

type T_cl_float2 = record
     case Byte of
       0: ( s :array [ 0..2-1 ] of T_cl_float );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y :T_cl_float );
       2: ( s0, s1 :T_cl_float );
       3: ( lo, hi :T_cl_float );
{$ENDIF}
{$IF defined( __CL_FLOAT2__ ) }
       4: ( v2 :T___cl_float2 );
{$ENDIF}
     end;

type T_cl_float4 = record
     case Byte of
       0: ( s :array [ 0..4-1 ] of T_cl_float );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_float );
       2: ( s0, s1, s2, s3 :T_cl_float );
       3: ( lo, hi :T_cl_float2 );
{$ENDIF}
{$IF defined( __CL_FLOAT2__ ) }
       4: ( v2 :array [ 0..2-1 ] of T___cl_float2 );
{$ENDIF}
{$IF defined( __CL_FLOAT4__ ) }
       5: ( v4 :T___cl_float4 );
{$ENDIF}
     end;

(* cl_float3 is identical in size, alignment and behavior to cl_float4. See section 6.1.5. *)
typedef  cl_float4  cl_float3;

type T_cl_float8 = record
     case Byte of
       0: ( s :array [ 0..8-1 ] of T_cl_float );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_float );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7 :T_cl_float );
       3: ( lo, hi :T_cl_float4 );
{$ENDIF}
{$IF defined( __CL_FLOAT2__ ) }
       4: ( v2 :array [ 0..4-1 ] of T___cl_float2 );
{$ENDIF}
{$IF defined( __CL_FLOAT4__ ) }
       5: ( v4 :array [ 0..2-1 ] of T___cl_float4 );
{$ENDIF}
{$IF defined( __CL_FLOAT8__ ) }
       6: ( v8 :T___cl_float8 );
{$ENDIF}
     end;

type T_cl_float16 = record
     case Byte of
       0: ( s :array [ 0..16-1 ] of T_cl_float );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w, __spacer4, __spacer5, __spacer6, __spacer7, __spacer8, __spacer9, sa, sb, sc, sd, se, sf :T_cl_float );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, sA, sB, sC, sD, sE, sF :T_cl_float );
       3: ( lo, hi :T_cl_float8 );
{$ENDIF}
{$IF defined( __CL_FLOAT2__ ) }
       4: ( v2 :array [ 0..8-1 ] of T___cl_float2 );
{$ENDIF}
{$IF defined( __CL_FLOAT4__ ) }
       5: ( v4 :array [ 0..4-1 ] of T___cl_float4 );
{$ENDIF}
{$IF defined( __CL_FLOAT8__ ) }
       6: ( v8 :array [ 0..2-1 ] of T___cl_float8 );
{$ENDIF}
{$IF defined( __CL_FLOAT16__ ) }
       7: ( v16 :T___cl_float16 );
{$ENDIF}
     end;

(* --- cl_doublen ---- *)

type T_cl_double2 = record
     case Byte of
       0: ( s :array [ 0..2-1 ] of T_cl_double );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y :T_cl_double );
       2: ( s0, s1 :T_cl_double );
       3: ( lo, hi :T_cl_double );
{$ENDIF}
{$IF defined( __CL_DOUBLE2__ ) }
       4: ( v2 :T___cl_double2 );
{$ENDIF}
     end;

type T_cl_double4 = record
     case Byte of
       0: ( s :array [ 0..4-1 ] of T_cl_double );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_double );
       2: ( s0, s1, s2, s3 :T_cl_double );
       3: ( lo, hi :T_cl_double2 );
{$ENDIF}
{$IF defined( __CL_DOUBLE2__ ) }
       4: ( v2 :array [ 0..2-1 ] of T___cl_double2 );
{$ENDIF}
{$IF defined( __CL_DOUBLE4__ ) }
       5: ( v4 :T___cl_double4 );
{$ENDIF}
     end;

(* cl_double3 is identical in size, alignment and behavior to cl_double4. See section 6.1.5. *)
typedef  cl_double4  cl_double3;

type T_cl_double8 = record
     case Byte of
       0: ( s :array [ 0..8-1 ] of T_cl_double );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w :T_cl_double );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7 :T_cl_double );
       3: ( lo, hi :T_cl_double4 );
{$ENDIF}
{$IF defined( __CL_DOUBLE2__ ) }
       4: ( v2 :array [ 0..4-1 ] of T___cl_double2 );
{$ENDIF}
{$IF defined( __CL_DOUBLE4__ ) }
       5: ( v4 :array [ 0..2-1 ] of T___cl_double4 );
{$ENDIF}
{$IF defined( __CL_DOUBLE8__ ) }
       6: ( v8 :T___cl_double8 );
{$ENDIF}
     end;

type T_cl_double16 = record
     case Byte of
       0: ( s :array [ 0..16-1 ] of T_cl_double );
{$IF __CL_HAS_ANON_STRUCT__ }
       1: ( x, y, z, w, __spacer4, __spacer5, __spacer6, __spacer7, __spacer8, __spacer9, sa, sb, sc, sd, se, sf :T_cl_double );
       2: ( s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, sA, sB, sC, sD, sE, sF :T_cl_double );
       3: ( lo, hi :T_cl_double8 );
{$ENDIF}
{$IF defined( __CL_DOUBLE2__ ) }
       4: ( v2 :array [ 0..8-1 ] of T___cl_double2 );
{$ENDIF}
{$IF defined( __CL_DOUBLE4__ ) }
       5: ( v4 :array [ 0..4-1 ] of T___cl_double4 );
{$ENDIF}
{$IF defined( __CL_DOUBLE8__ ) }
       6: ( v8 :array [ 0..2-1 ] of T___cl_double8 );
{$ENDIF}
{$IF defined( __CL_DOUBLE16__ ) }
       7: ( v16 :T___cl_double16 );
{$ENDIF}
     end;

(* Macro to facilitate debugging
 * Usage:
 *   Place CL_PROGRAM_STRING_DEBUG_INFO on the line before the first line of your source.
 *   The first line ends with:   CL_PROGRAM_STRING_DEBUG_INFO \"
 *   Each line thereafter of OpenCL C source must end with: \n\
 *   The last line ends in ";
 *
 *   Example:
 *
 *   const char *my_program = CL_PROGRAM_STRING_DEBUG_INFO "\
 *   kernel void foo( int a, float * b )             \n\
 *   {                                               \n\
 *      // my comment                                \n\
 *      *b[ get_global_id(0)] = a;                   \n\
 *   }                                               \n\
 *   ";
 *
 * This should correctly set up the line, (column) and file information for your source
 * string so you can do source level debugging.
 *)
#define  __CL_STRINGIFY( _x )               # _x
#define  _CL_STRINGIFY( _x )                __CL_STRINGIFY( _x )
#define  CL_PROGRAM_STRING_DEBUG_INFO       "#line "  _CL_STRINGIFY(__LINE__) " \"" __FILE__ "\" \n\n"

//#ifdef __cplusplus
//}
//#endif

#undef __CL_HAS_ANON_STRUCT__
#undef __CL_ANON_STRUCT__
#if defined( _WIN32) && defined(_MSC_VER)
    #if _MSC_VER >=1500
    #pragma warning( pop )
    #endif
#endif

implementation //############################################################### ■

end. //######################################################################### ■
