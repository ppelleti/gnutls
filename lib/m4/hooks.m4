# Copyright (C) 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008
#    Free Software Foundation, Inc.
#
# Author: Nikos Mavrogiannopoulos, Simon Josefsson
#
# This file is part of GNUTLS.
#
# The GNUTLS library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public License
# as published by the Free Software Foundation; either version 2.1 of
# the License, or (at your option) any later version.
#
# The GNUTLS library is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with the GNUTLS library; if not, write to the Free
# Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA

AC_DEFUN([LIBGNUTLS_HOOKS],
[
  # Library code modified:                              REVISION++
  # Interfaces changed/added/removed:   CURRENT++       REVISION=0
  # Interfaces added:                             AGE++
  # Interfaces removed:                           AGE=0
  AC_SUBST(LT_CURRENT, 38)
  AC_SUBST(LT_REVISION, 2)
  AC_SUBST(LT_AGE, 12)

  # Used when creating the Windows libgnutls-XX.def files.
  SOVERSION=`expr ${LT_CURRENT} - ${LT_AGE}`
  AC_SUBST(SOVERSION)

  AC_PROG_CXX

  AC_ARG_ENABLE(cxx,
                AS_HELP_STRING([--disable-cxx],
                               [unconditionally disable the C++ library]),
                use_cxx=$enableval, use_cxx=yes)
  if test "$use_cxx" != "no"; then
    AC_LANG_PUSH(C++)
    AC_COMPILE_IFELSE([AC_LANG_PROGRAM([],[])], use_cxx=yes, use_cxx=no)
    AC_LANG_POP(C++)
  fi
  AM_CONDITIONAL(ENABLE_CXX, test "$use_cxx" != "no")
  AC_MSG_CHECKING([whether to build C++ library])
  AC_MSG_RESULT($use_cxx)

  AC_LIB_HAVE_LINKFLAGS(gcrypt,, [#include <gcrypt.h>],
    [enum gcry_cipher_algos i = GCRY_CIPHER_CAMELLIA128])
  if test "$ac_cv_libgcrypt" != yes; then
    AC_MSG_ERROR([[
***  
*** libgcrypt was not found. You may want to get it from
*** ftp://ftp.gnupg.org/gcrypt/libgcrypt/
***
    ]])
  fi

  AC_ARG_WITH(included-libtasn1,
    AS_HELP_STRING([--with-included-libtasn1], [use the included libtasn1]),
      included_libtasn1=$withval,
      included_libtasn1=no)
  if test "$included_libtasn1" = "no"; then
    AC_LIB_HAVE_LINKFLAGS(tasn1,, [#include <libtasn1.h>],
    				[asn1_check_version (NULL)])
    if test "$ac_cv_libtasn1" != yes; then
      included_libtasn1=yes
      AC_MSG_WARN([[
  *** 
  *** Libtasn1 was not found. Will use the included one.
  ]])
    fi
  fi
  AC_MSG_CHECKING([whether to use the included minitasn1])
  AC_MSG_RESULT($included_libtasn1)
  AM_CONDITIONAL(ENABLE_MINITASN1, test "$included_libtasn1" = "yes")
  
  AC_MSG_CHECKING([whether C99 macros are supported])
  AC_TRY_COMPILE(,
  [
    #define test_mac(...) 
    int z,y,x;
    test_mac(x,y,z);
    return 0;
  ], [
    AC_DEFINE(C99_MACROS, 1, [C99 macros are supported])
    AC_MSG_RESULT(yes)
  ], [
    AC_MSG_RESULT(no)
    AC_MSG_WARN([C99 macros not supported. This may affect compiling.])
  ])

  AC_MSG_CHECKING([whether to enable Opaque PRF input support])
  AC_ARG_ENABLE(opaque-prf-input,
  	AS_HELP_STRING([--enable-opaque-prf-input=DD],
  		[enable Opaque PRF input using DD as extension type]),
  	ac_opaque_prf_input=$enableval, ac_opaque_prf_input=no)
  if test "$ac_opaque_prf_input" != "no"; then
    if ! echo $ac_opaque_prf_input | egrep -q '^[[0-9]]+$'; then
      ac_opaque_prf_input=no
      AC_MSG_WARN([[
  *** Could not parse Opaque PRF Input extension type.
  *** Use --enable-opaque-prf-input=XX where XX is decimal, for example
  *** to use extension value 42 use --enable-opqaue-prf-input=42]])
    fi
  fi
  if test "$ac_opaque_prf_input" != "no"; then
   AC_MSG_RESULT([yes (extension value $ac_opaque_prf_input)])
   AC_DEFINE_UNQUOTED(ENABLE_OPRFI, $ac_opaque_prf_input,
                      [enable Opaque PRF Input])
  else
   AC_MSG_RESULT(no)
  fi
  AM_CONDITIONAL(ENABLE_OPRFI, test "$ac_opaque_prf_input" != "no")
  
  AC_MSG_CHECKING([whether to disable SRP authentication support])
  AC_ARG_ENABLE(srp-authentication,
  	AS_HELP_STRING([--disable-srp-authentication],
  		[disable the SRP authentication support]),
  	ac_enable_srp=no)
  if test x$ac_enable_srp != xno; then
   AC_MSG_RESULT(no)
   AC_DEFINE(ENABLE_SRP, 1, [enable SRP authentication])
  else
   ac_full=0
   AC_MSG_RESULT(yes)
  fi
  AM_CONDITIONAL(ENABLE_SRP, test "$ac_enable_srp" != "no")
  
  AC_MSG_CHECKING([whether to disable PSK authentication support])
  AC_ARG_ENABLE(psk-authentication,
         AS_HELP_STRING([--disable-psk-authentication],
                 [disable the PSK authentication support]),
         ac_enable_psk=no)
  if test x$ac_enable_psk != xno; then
   AC_MSG_RESULT(no)
   AC_DEFINE(ENABLE_PSK, 1, [enable PSK authentication])
  else
   ac_full=0
   AC_MSG_RESULT(yes)
  fi
  AM_CONDITIONAL(ENABLE_PSK, test "$ac_enable_psk" != "no")
  
  AC_MSG_CHECKING([whether to disable anonymous authentication support])
  AC_ARG_ENABLE(anon-authentication,
  	AS_HELP_STRING([--disable-anon-authentication],
  		[disable the anonymous authentication support]),
  	ac_enable_anon=no)
  if test x$ac_enable_anon != xno; then
   AC_MSG_RESULT(no)
   AC_DEFINE(ENABLE_ANON, 1, [enable anonymous authentication])
  else
   ac_full=0
   AC_MSG_RESULT(yes)
  fi
  AM_CONDITIONAL(ENABLE_ANON, test "$ac_enable_anon" != "no")
  
  # Allow disabling Camellia
  AC_ARG_ENABLE(camellia,
    AS_HELP_STRING([--disable-camellia], [disable Camellia cipher]),
    enable_camellia=$enableval, enable_camellia=no)
  AC_MSG_CHECKING([whether to disable Camellia cipher])
  if test "$enable_camellia" != "no"; then
   AC_MSG_RESULT([no])
   AC_DEFINE(ENABLE_CAMELLIA, 1, [enable camellia block cipher])
  else
   AC_MSG_RESULT([yes])
  fi
  
  AC_MSG_CHECKING([whether to disable extra PKI stuff])
  AC_ARG_ENABLE(extra-pki,
  	AS_HELP_STRING([--disable-extra-pki],
  		[only enable the basic PKI stuff]),
  	enable_pki=$enableval, enable_pki=yes)
  if test "$enable_pki" != "yes"; then
   ac_full=0
   AC_MSG_RESULT(yes)
  else
   AC_MSG_RESULT(no)
   AC_DEFINE(ENABLE_PKI, 1, [whether to include all the PKCS/PKI stuff])
  fi
  AM_CONDITIONAL(ENABLE_PKI, test "$enable_pki" = "yes")
  
  ac_enable_openpgp=yes
  AC_MSG_CHECKING([whether to disable OpenPGP Certificate authentication support])
  AC_ARG_ENABLE(openpgp-authentication,
  	AS_HELP_STRING([--disable-openpgp-authentication],
  		[disable the OpenPGP authentication support]),
  	ac_enable_openpgp=no)
  if test x$ac_enable_openpgp = xno; then
   AC_MSG_RESULT(yes)
   ac_full=0
  else
   AC_DEFINE(ENABLE_OPENPGP, 1, [use openpgp authentication])
   AC_MSG_RESULT(no)
  fi
  AM_CONDITIONAL(ENABLE_OPENPGP, test "$ac_enable_openpgp" = "yes")

  AC_MSG_CHECKING([if gcc/ld supports -Wl,--output-def])
  if test "$enable_shared" = no; then
    output_def=no
    AC_MSG_RESULT([no need, since shared libraries are disabled])
  else
    _gcc_ldflags_save=$LDFLAGS
    LDFLAGS="-Wl,--output-def,foo.def"
    AC_LINK_IFELSE(AC_LANG_PROGRAM([]),output_def=yes,output_def=no)
    rm -f foo.def
    AC_MSG_RESULT($output_def)
    LDFLAGS="$_gcc_ldflags_save"
  fi
  AM_CONDITIONAL(HAVE_LD_OUTPUT_DEF, test "$output_def" = "yes")

  # For some systems we know that we have ld_version scripts.
  # Use it then as default.
  have_ld_version_script=no
  case "${host}" in
      *-*-linux*)
          have_ld_version_script=yes
          ;;
      *-*-gnu*)
          have_ld_version_script=yes
          ;;
  esac
  AC_ARG_ENABLE([ld-version-script],
                AC_HELP_STRING([--enable-ld-version-script],
                               [enable/disable use of linker version script.
                                (default is system dependent)]),
                [have_ld_version_script=$enableval],
                [ : ] )
  AM_CONDITIONAL(HAVE_LD_VERSION_SCRIPT, test "$have_ld_version_script" = "yes")

  # For storing integers in pointers without warnings
  # http://developer.gnome.org/doc/API/2.0/glib/glib-Type-Conversion-Macros.html#desc
  AC_CHECK_SIZEOF(void *)
  AC_CHECK_SIZEOF(long)
  AC_CHECK_SIZEOF(int)
  case $ac_cv_sizeof_void_p in
    $ac_cv_sizeof_long)
      AC_DEFINE(GNUTLS_POINTER_TO_INT_CAST, [(long)],
                [Additional cast to bring void* to a type castable to int.])
      ;;
    *)
      AC_DEFINE(GNUTLS_POINTER_TO_INT_CAST, [])
      ;;
  esac
])