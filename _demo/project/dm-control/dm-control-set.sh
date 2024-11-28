#!/usr/bin/env bash




##
## # Change default x display manager / debian
##


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
## ## Util / Display Manager
##


##
## ## Link
##
## * Search: [change debian default x display manager](https://www.google.com/search?q=change+debian+default+x+display+manager)
## * [Reconfigure the display-manager non-interactively](https://askubuntu.com/questions/1114525/reconfigure-the-display-manager-non-interactively)
## * Debian Wiki / [DisplayManager](https://wiki.debian.org/DisplayManager)
## * Arch Wiki / [Display manager](https://wiki.archlinux.org/title/Display_manager)
##

##
## * `sudo dpkg-reconfigure lightdm`
## * `sudo dpkg-reconfigure sddm`
##

##
## * https://packages.debian.org/source/stable/lightdm
## * https://packages.debian.org/source/stable/sddm
##

##
## * https://salsa.debian.org/xfce-extras-team/lightdm
## * https://salsa.debian.org/qt-kde-team/3rdparty/sddm
##

##
## * `cat /var/lib/dpkg/info/lightdm.config`
## * [/var/lib/dpkg/info/lightdm.config](https://salsa.debian.org/xfce-extras-team/lightdm/-/blob/debian/master/debian/lightdm.config?ref_type=heads)
## * `cat /var/lib/dpkg/info/sddm.config`
## * [/var/lib/dpkg/info/sddm.config](https://salsa.debian.org/qt-kde-team/3rdparty/sddm/-/blob/master/debian/sddm.config?ref_type=heads)
##


##
## `file /etc/systemd/system/display-manager.service`
## `cat /etc/X11/default-display-manager`
##

##
## ## lightdm
##
## run
##
## ``` sh
## sudo apt-get install lightdm
## sudo dpkg-reconfigure lightdm
## ```
##
## or run
##
## ``` sh
## sudo apt-get install lightdm
##
## sudo rm /etc/systemd/system/display-manager.service
## sudo systemctl enable lightdm
##
## sudo sh -c 'echo set shared/default-x-display-manager $(which lightdm) | debconf-communicate'
##
## sudo which lightdm | sudo tee /etc/X11/default-display-manager
## ```
##


##
## ## sddm
##
## run
##
## ``` sh
## sudo apt-get install sddm
## sudo dpkg-reconfigure sddm
## ```
##
## or run
##
## ``` sh
## sudo apt-get install sddm
##
## sudo rm /etc/systemd/system/display-manager.service
## sudo systemctl enable sddm
##
## sudo sh -c 'echo set shared/default-x-display-manager $(which sddm) | debconf-communicate'
##
## sudo which sddm | sudo tee /etc/X11/default-display-manager
## ```
##
## check
##
## ``` sh
## file /etc/systemd/system/display-manager.service
## cat /etc/X11/default-display-manager
## sudo sh -c 'echo get shared/default-x-display-manager | debconf-communicate
## ```
##


util_dm_set () {

	local display_manager_selected="lightdm"
	local display_manager_service_file_path="/etc/systemd/system/display-manager.service"
	local default_display_manager_file_path="/etc/X11/default-display-manager"

	if [ -n "${1}" ]; then
		display_manager_selected="${1}"
	fi


	display_manager_bin_path="$(which ${display_manager_selected})"

	if [ ! -e "${display_manager_bin_path}" ] ; then
		echo "${display_manager_selected} seems not to be a valid display manager or is not installed."
		exit 1
	fi




	##
	## ## main process
	##

	echo "${display_manager_bin_path}" > "${default_display_manager_file_path}"
	DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true dpkg-reconfigure "${display_manager_selected}"
	echo set shared/default-x-display-manager "${display_manager_selected}" | debconf-communicate &> /dev/null




	##
	## ## done info
	##

	util_error_echo
	util_error_echo -n "I: systemd service is set to: "
	readlink "${display_manager_service_file_path}"

	util_error_echo
	util_error_echo -n "I: ${default_display_manager_file_path} is set to: "
	cat "${default_display_manager_file_path}"

	util_error_echo
	util_error_echo -n "I: debconf is set to: "
	util_error_echo get shared/default-x-display-manager | debconf-communicate


	return 0
}




##
## ## Model / Start
##

model_start () {

	limit_root_user_required

	util_dm_set "${@}"

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
		util_error_echo "Example: sudo ./${REF_CMD_FILE_NAME} lightdm"
		util_error_echo
		util_error_echo "Example: sudo ./${REF_CMD_FILE_NAME} sddm"
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
