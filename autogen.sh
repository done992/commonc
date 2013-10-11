#!/bin/sh
# force locale setting to C so things like date output as expected
LC_ALL=C

AUTOCONF_VERSION=2.69
AUTOMAKE_VERSION=1.12
LIBTOOL_VERSION=2.4.2
M4_VERSION=1.4.16

#####################
# argument check	#
#####################

ARGS="$*"
PATH_TO_AUTOGEN="`dirname $0`"
NAME_OF_AUTOGEN="`basename $0`"
AUTOGEN_SH="$PATH_TO_AUTOGEN/$NAME_OF_AUTOGEN"

LIBTOOL_M4="${PATH_TO_AUTOGEN}/misc/libtool.m4"

AUTORECONF_OPTIONS="-fiv"
AUTOCONF_OPTIONS="-f"
AUTOMAKE_OPTIONS="-acf"
ALT_AUTOMAKE_OPTIONS="-ac"
LIBTOOLIZE_OPTIONS="--automake -c -f"
ALT_LIBTOOLIZE_OPTIONS="--automake --copy --force"
AUTOHEADER_OPTIONS=""


##########################
# VERSION_CHECK FUNCTION #
##########################
version_check ( ) {
    if [ "x$1" = "x" ] ; then
	echo "INTERNAL ERROR: version_check was not provided a minimum version"
	exit 1
    fi
    _min="$1"
    if [ "x$2" = "x" ] ; then
	echo "INTERNAL ERROR: version check was not provided a comparison version"
	exit 1
    fi
    _cur="$2"

    # needed to handle versions like 1.10 and 1.4-p6
    _min="`echo ${_min}. | sed 's/[^0-9]/./g' | sed 's/\.\././g'`"
    _cur="`echo ${_cur}. | sed 's/[^0-9]/./g' | sed 's/\.\././g'`"

    _min_major="`echo $_min | cut -d. -f1`"
    _min_minor="`echo $_min | cut -d. -f2`"
    _min_patch="`echo $_min | cut -d. -f3`"

    _cur_major="`echo $_cur | cut -d. -f1`"
    _cur_minor="`echo $_cur | cut -d. -f2`"
    _cur_patch="`echo $_cur | cut -d. -f3`"

    if [ "x$_min_major" = "x" ] ; then
	_min_major=0
    fi
    if [ "x$_min_minor" = "x" ] ; then
	_min_minor=0
    fi
    if [ "x$_min_patch" = "x" ] ; then
	_min_patch=0
    fi
    if [ "x$_cur_minor" = "x" ] ; then
	_cur_major=0
    fi
    if [ "x$_cur_minor" = "x" ] ; then
	_cur_minor=0
    fi
    if [ "x$_cur_patch" = "x" ] ; then
	_cur_patch=0
    fi

    #echo "Checking if ${_cur_major}.${_cur_minor}.${_cur_patch} is greater than ${_min_major}.${_min_minor}.${_min_patch}"

    if [ $_min_major -lt $_cur_major ] ; then
	return 0
    elif [ $_min_major -eq $_cur_major ] ; then
	if [ $_min_minor -lt $_cur_minor ] ; then
	    return 0
	elif [ $_min_minor -eq $_cur_minor ] ; then
	    if [ $_min_patch -lt $_cur_patch ] ; then
		return 0
	    elif [ $_min_patch -eq $_cur_patch ] ; then
		return 0
	    fi
	fi
    fi
    return 1
}

########################
# check for autoreconf #
########################
autoreconf --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "autoreconf does not exist on your system, please check."
fi

#######################################
# check for autoconf and it's version #
#######################################
autoconf --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "autoconf does not exist on your system, please check."
else
	_version=$(autoconf --version|head -1|sed 's/[^0-9]*\([0-9\.][0-9\.]*\)/\1/')
	if [ "x$_version" = "x" ]; then
		_version="0.0.0"
	fi
	version_check "$AUTOCONF_VERSION" "$_version" 
	if [ $? -ne 0 ]; then
		echo "GNU autoconf $AUTOCONF_VERSION is required, but $_version is installed on your system, please update!"
		exit 1
	else
		echo "GNU autoconf $_version found."
	fi
fi

#######################################
# check for automake and it's version #
#######################################
automake --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "automake does not exist on your system, please check."
else
	_version=$(automake --version|head -1|sed 's/[^0-9]*\([0-9\.][0-9\.]*\)/\1/')
	if [ "x$_version" = "x" ]; then
		_version="0.0.0"
	fi
	version_check "$AUTOMAKE_VERSION" "$_version"
	if [ $? -ne 0 ]; then
		echo "GUU automake $AUTOMAKE_VERSION is required, but $_version is installed on your system, please update!"
		exit 1
	else
		echo "GNU automake $_version found."
	fi
fi

#######################################
# check for libtool and it's version #
#######################################
libtoolize --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "libtoolize does not exist on your system, please check."
else
	_version=$(libtoolize --version|head -1|sed 's/[^0-9]*\([0-9\.][0-9\.]*\)/\1/')
	if [ "x$_version" = "x" ]; then
		_version="0.0.0"
	fi
	version_check "$LIBTOOL_VERSION" "$_version"
	if [ $? -ne 0 ]; then
		echo "GUU libtool $LIBTOOL_VERSION is required, but $_version is installed on your system, please update!"
		exit 1
	else
		echo "GNU libtool $_version found."
	fi
fi

#######################################
# check for m4 and it's version #
#######################################
m4 --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "m4 does not exist on your system, please check."
else
	_version=$(m4 --version|head -1|rev|cut -d' ' -f1|rev)
	if [ "x$_version" = "x" ]; then
		_version="0.0.0"
	fi
	version_check "$M4_VERSION" "$_version"
	if [ $? -ne 0 ]; then
		echo "GNU m4 $M4_VERSION is required, but $_version is installed on your system, please update!"
		exit 1
	else
		echo "GNU m4 $_version found."
	fi
fi

#######################################
# check for aclocal					  #
#######################################
aclocal --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "aclocal does not exist on your system, please check."
fi

#######################################
# check for autoheader				  #
#######################################
autoheader --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "autoheader does not exist on your system, please check."
fi

######################################
# manual autogen function			 #
######################################
manual_autogen ( ) {
	
	#############################################################
	#  manual preparation steps taken are as follows: 			#
	#	aclocal [ --force-I m4 ]							 	#
	#	#libtoolize --automake -c -f							#
	#	#aclocal [ -I m4 ]										#
	#	autoconf -f												#
	#	autoheader												#
	#	automake -a -c -f										#
	#############################################################
	if [ -d autom4te.cache ]; then
		rm -rf autom4te.cache
	fi
	
	
	#############
	# aclocal	#
	#############
	if [ ! -d m4 ]; then
		mkdir m4
	fi
	aclocal_output=$(aclocal --force -I m4  2>&1)
	if [ $? -ne 0 ]; then
		echo $aclocal_output
		exit 2
	fi
	
	#############################
	# libtoolize --copy --force	#
	#############################
	libtoolize_output=$(libtoolize --copy --force 2>&1)
	if [ $? -ne 0 ]; then
		echo $libtoolize_output
		exit 2
	fi
	
	
	
	#################
	# autoconf -f	#
	#################
	autoconf_output=$(autoconf -f 2>&1)
	if [ $? -ne 0 ]; then
		echo $autoconf_output
		exit 2
	fi
	
	#########################
	# autoheader --force	#
	#########################
	autoheader_output=$(autoheader --force 2>&1)
	if [ $? -ne 0 ]; then
		echo $autoheader_output
		exit 2
	fi
	
	#############################################################
	# automake --foreign --add-missing --copy --force-missing	#
	#############################################################
	automake_output=$(automake --foreign --add-missing --copy --force-missing 2>&1)
	if [ $? -ne 0 ]; then
		echo $automake_output
		exit 2
	fi
}


######################################
# LOCATE_CONFIGURE_TEMPLATE FUNCTION #
######################################
locate_configure_template ( ) {
    _pwd="`pwd`"
    if test -f "./configure.ac" ; then
	echo "./configure.ac"
    elif test -f "./configure.in" ; then
	echo "./configure.in"
    elif test -f "$_pwd/configure.ac" ; then
	echo "$_pwd/configure.ac"
    elif test -f "$_pwd/configure.in" ; then
	echo "$_pwd/configure.in"
    elif test -f "$PATH_TO_AUTOGEN/configure.ac" ; then
	echo "$PATH_TO_AUTOGEN/configure.ac"
    elif test -f "$PATH_TO_AUTOGEN/configure.in" ; then
	echo "$PATH_TO_AUTOGEN/configure.in"
    fi
}




#######################
_pwd="`pwd`"
if [ ! -f "./configure.ac" ]; then
	echo "./configure.ac does not exist."
	exit 1;
fi

manual_autogen

# make sure we end up with a configure script
config_ac="`locate_configure_template`"
config="`echo $config_ac | sed 's/\.ac$//' | sed 's/\.in$//'`"
if [ "x$config" = "x" ] ; then
    $echo "Could not locate the configure template (from `pwd`)"
fi

# summarize
echo
if test "x$config" = "x" -o ! -f "$config" ; then
    echo "WARNING: The $PROJECT build system should now be prepared but there"
    echo "does not seem to be a resulting configure file.  This is unexpected"
    echo "and likely the result of an error."
else
	echo "-------------------------------------------"
	echo "The build system is now prepared.  To build here, run:"
	echo "  $config"
    echo "  make"
fi


#set -x
#aclocal
#autoheader
#automake --foreign --add-missing --copy
#autoconf
#==============
# autoheader
# autoconf
# automake --add-missing --copy