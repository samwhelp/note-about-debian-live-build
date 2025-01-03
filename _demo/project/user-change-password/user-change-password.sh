#!/usr/bin/env bash




##
## # User Change Password
##

set -e

##
## ## Main / Init
##

REF_BASE_DIR_PATH="$(cd -- "$(dirname -- "$0")" ; pwd)"
REF_CMD_FILE_NAME="$(basename "$0")"


DEFAULT_IS_DEBUG="false"
IS_DEBUG="${IS_DEBUG:=$DEFAULT_IS_DEBUG}"


##
## ## Main / Util
##

util_error_echo () {
	echo "${@}" 1>&2
}

util_debug_echo () {

	if is_debug; then
		echo "${@}" 1>&2
	fi

}

is_debug () {

	if [[ "${IS_DEBUG}" == "true" ]]; then
		return 0
	fi

	return 1

}

is_not_debug () {

	! is_debug

}


##
## ## Main / Args
##

#REF_CRYPT_METHOD="openssl_passwd_to_md5"
#REF_CRYPT_METHOD="openssl_passwd_to_sha256"
#REF_CRYPT_METHOD="openssl_passwd_to_sha512"

#REF_CRYPT_METHOD="mkpasswd_to_yescrypt"
#REF_CRYPT_METHOD="mkpasswd_to_gost_yescrypt"
#REF_CRYPT_METHOD="mkpasswd_to_scrypt"
#REF_CRYPT_METHOD="mkpasswd_to_bcrypt"
#REF_CRYPT_METHOD="mkpasswd_to_bcrypt_a"
#REF_CRYPT_METHOD="mkpasswd_to_sha512crypt"
#REF_CRYPT_METHOD="mkpasswd_to_sha256crypt"
#REF_CRYPT_METHOD="mkpasswd_to_sunmd5"
#REF_CRYPT_METHOD="mkpasswd_to_md5crypt"
#REF_CRYPT_METHOD="mkpasswd_to_bsdicrypt"
REF_CRYPT_METHOD="mkpasswd_to_descrypt"
#REF_CRYPT_METHOD="mkpasswd_to_nt"




##
## ## Install Package
##


##
## > install Package: `usermode` for Command `usermod`
##
## ``` sh
## sudo apt-get install usermode
## ```
##


##
## > install Package: `openssl` for Command `openssl`
##
## ``` sh
## sudo apt-get install openssl
## ```
##


##
## > install Package: `whois` for Command `mkpasswd`
##
## ``` sh
## sudo apt-get install whois
## ```
##





##
## ## Util / Crypt Password / By openssl_passwd
##

##
## ``` sh
## man openssl-passwd
## ```
##

util_password_crypt_by_openssl_passwd_to_md5 () {
	openssl passwd -1 ${1}
}

util_password_crypt_by_openssl_passwd_to_sha256 () {
	openssl passwd -5 ${1}
}

util_password_crypt_by_openssl_passwd_to_sha512 () {
	openssl passwd -6 ${1}
}




##
## ## Util / Crypt Password / By mkpasswd
##

##
## ``` sh
## man mkpasswd
## ```
##

util_password_crypt_by_mkpasswd_crypt_method () {

	#mkpasswd -s -m ${1} <<< ${2}

	echo -n ${2} | mkpasswd -s -m ${1}

}




##
## ## Util / Crypt Password / By mkpasswd / methods
##

##
## run
##
## ``` sh
## mkpasswd -m help
## ```
##
## show
##
## ```
## Available methods:
## yescrypt        Yescrypt
## gost-yescrypt   GOST Yescrypt
## scrypt          scrypt
## bcrypt          bcrypt
## bcrypt-a        bcrypt (obsolete $2a$ version)
## sha512crypt     SHA-512
## sha256crypt     SHA-256
## sunmd5          SunMD5
## md5crypt        MD5
## bsdicrypt       BSDI extended DES-based crypt(3)
## descrypt        standard 56 bit DES-based crypt(3)
## nt              NT-Hash
## ```
##

util_password_crypt_by_mkpasswd_to_yescrypt () {
	util_password_crypt_by_mkpasswd_crypt_method "yescrypt" ${1}
}

util_password_crypt_by_mkpasswd_to_gost_yescrypt () {
	util_password_crypt_by_mkpasswd_crypt_method "gost-yescrypt" ${1}
}

util_password_crypt_by_mkpasswd_to_scrypt () {
	util_password_crypt_by_mkpasswd_crypt_method "scrypt" ${1}
}

util_password_crypt_by_mkpasswd_to_bcrypt () {
	util_password_crypt_by_mkpasswd_crypt_method "bcrypt" ${1}
}

util_password_crypt_by_mkpasswd_to_bcrypt_a () {
	util_password_crypt_by_mkpasswd_crypt_method "bcrypt-a" ${1}
}

util_password_crypt_by_mkpasswd_to_sha512crypt () {
	util_password_crypt_by_mkpasswd_crypt_method "sha512crypt" ${1}
}

util_password_crypt_by_mkpasswd_to_sha256crypt () {
	util_password_crypt_by_mkpasswd_crypt_method "sha256crypt" ${1}
}

util_password_crypt_by_mkpasswd_to_sunmd5 () {
	util_password_crypt_by_mkpasswd_crypt_method "sunmd5" ${1}
}

util_password_crypt_by_mkpasswd_to_md5crypt () {
	util_password_crypt_by_mkpasswd_crypt_method "md5crypt" ${1}
}

util_password_crypt_by_mkpasswd_to_bsdicrypt () {
	util_password_crypt_by_mkpasswd_crypt_method "bsdicrypt" ${1}
}

util_password_crypt_by_mkpasswd_to_descrypt () {
	util_password_crypt_by_mkpasswd_crypt_method "descrypt" ${1}
}

util_password_crypt_by_mkpasswd_to_nt () {
	util_password_crypt_by_mkpasswd_crypt_method "nt" ${1}
}




##
## ## Util / Crypt Password
##

util_password_crypt () {

	#util_password_crypt_by_openssl_passwd_512 "${1}"
	#util_password_crypt_by_mkpasswd_to_descrypt "${1}"

	local crypt_method="${REF_CRYPT_METHOD}"
	local crypt_function="util_password_crypt_by_${crypt_method}"

	${crypt_function} ${1}

	return 0
}




##
## ## Util / Change Password
##


##
## ## Link
##
##

util_user_change_password () {

	local username_mod=${1}
	local password_new=${2}
	local password_mod="$(util_password_crypt ${password_new})"


	util_error_echo
	util_error_echo
	util_error_echo "##"
	util_error_echo "## ## Argument"
	util_error_echo "##"
	util_error_echo
	util_error_echo "username=${username_mod}"
	util_error_echo
	util_error_echo "password=${password_new}"
	util_error_echo "password_crypted=${password_mod}"
	util_error_echo


	if [[ -z "${username_mod}" ]]; then

		util_error_echo
		util_error_echo "##"
		util_error_echo "## ## User ID Required"
		util_error_echo "##"

		util_error_echo
		util_error_echo "> Please run root, and [User Id] as argument"
		util_error_echo
		util_error_echo "Example: sudo ./${REF_CMD_FILE_NAME} user_id"
		util_error_echo

		exit 0
	fi


	##
	## ## password crypted format
	##
	## $id$salt$hash
	##


	##
	## ## Change Password
	##

	util_error_echo
	util_error_echo "##"
	util_error_echo "## ## Change Password"
	util_error_echo "##"
	util_error_echo

	util_error_echo
	util_error_echo usermod -p "${password_mod}" "${username_mod}"
	usermod -p "${password_mod}" "${username_mod}"
	util_error_echo


	return 0
}




##
## ## Model / Start
##

model_start () {

	limit_root_user_required

	util_user_change_password "${@}"

	return 0
}




##
## ## Limit / Root User Required
##

limit_root_user_required () {

	if [[ "${EUID}" == 0 ]]; then

		return 0

	else

		util_error_echo
		util_error_echo "##"
		util_error_echo "## ## Root User Required"
		util_error_echo "##"

		util_error_echo
		util_error_echo "> Please Run As Root"
		util_error_echo
		util_error_echo "Example: sudo ./${REF_CMD_FILE_NAME} user_id"
		util_error_echo

		#sleep 2
		exit 0
	fi

}


##
## ## Main / Start
##

__main__ () {

	model_start "${@}"

}

__main__ "${@}"
