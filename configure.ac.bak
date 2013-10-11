#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([common-c], [0.1], [amao.chj@gmail.com])
AC_CONFIG_SRCDIR([class/architecture.h])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_AUX_DIR([config])
AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE(1.8 foreign -Wall -Werror)
# Checks for programs.
AC_PROG_CC

#if we will create lib
AM_PROG_AR
AC_PROG_LIBTOOL
LT_INIT

# Checks for libraries.
# FIXME: Replace `main' with a function in `-lclass':
AC_CHECK_LIB([class], [main])
# FIXME: Replace `main' with a function in `-lcommon':
AC_CHECK_LIB([common], [main])
# FIXME: Replace `main' with a function in `-lgreatutil':
AC_CHECK_LIB([greatutil], [main])

# Checks for header files.
AC_CHECK_HEADERS([fcntl.h inttypes.h limits.h stddef.h stdint.h stdlib.h string.h strings.h sys/socket.h sys/time.h syslog.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADER_STDBOOL
AC_C_INLINE
AC_TYPE_INT32_T
AC_TYPE_INT64_T
AC_TYPE_PID_T
AC_TYPE_SIZE_T
AC_TYPE_SSIZE_T
AC_TYPE_UINT16_T
AC_TYPE_UINT32_T
AC_TYPE_UINT64_T
AC_TYPE_UINT8_T
AC_CHECK_TYPES([ptrdiff_t])

# Checks for library functions.
AC_FUNC_ERROR_AT_LINE
AC_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_CHECK_FUNCS([atexit gethostname gettimeofday localtime_r memmove memset select strchr strdup strerror strrchr strstr strtol strtoul])

AC_CONFIG_FILES([
				 Makefile
				 class/Makefile
                 common/Makefile
                 util/Makefile
                 ztest/Makefile
                 ztest/class/Makefile
                 ztest/common/Makefile
                 ztest/util/Makefile])
AC_OUTPUT
