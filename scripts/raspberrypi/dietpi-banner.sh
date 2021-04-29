#!/bin/bash

	#////////////////////////////////////
	# DietPi Banner Script
	#
	#////////////////////////////////////
	# Created by Dan Knight / daniel_haze@hotmail.com / fuzon.co.uk
	#
	#////////////////////////////////////
	#
	# Info:
	# - filename /DietPi/dietpi/dietpi-banner
	# - Checks /DietPi/dietpi/.update_available
	#
	# Usage:
	# - dietpi-banner 0 = top section only
	# - dietpi-banner 1 = top section and credits
	#////////////////////////////////////

	INPUT=0
	if [[ $1 =~ ^-?[0-9]+$ ]]; then
		INPUT=$1
	fi

	#/////////////////////////////////////////////////////////////////////////////////////
	#Globals
	#/////////////////////////////////////////////////////////////////////////////////////
	DIETPI_VERSION=$(cat /DietPi/dietpi/.version)
	HW_MODEL_DESCRIPTION=$(cat /proc/device-tree/model) 
	HOSTNAME=$(cat /etc/hostname)

	#/////////////////////////////////////////////////////////////////////////////////////
	#Top section additional Text. Update available / MOTD etc
	#/////////////////////////////////////////////////////////////////////////////////////
	TEXT_TOP=""
	UPDATE_AVAILABLE=0

	#/////////////////////////////////////////////////////////////////////////////////////
	# Banner Print
	#/////////////////////////////////////////////////////////////////////////////////////
	Banner_TopText_Extras(){

		#Update Available
		if [ -f /DietPi/dietpi/.update_available ]; then
			UPDATE_AVAILABLE=$(cat /DietPi/dietpi/.update_available)

			if (( $UPDATE_AVAILABLE > 0 )); then
				TEXT_TOP="\e[90m|\e[0m \e[91mUpdate available\e[0m"
			elif (( $UPDATE_AVAILABLE == -1 )); then
				TEXT_TOP="\e[90m|\e[0m \e[91mImage available\e[0m"
			fi

		#Use TEXT_TOP for storing helpful info
		else
			#Helpful mode
			TEXT_TOP="\e[90m| $(date +"%R | %a %x")\e[0m"
		fi
	}

	PrintInfo () {	
		echo -e " $1: \e[90m $2 \e[0m" 
	}

	Banner_Dietpi(){
		clear
		echo -e " \e[38;5;93m───────────────────────────────────────\e[0m\n \e[1m$HOSTNAME\e[0m $TEXT_TOP \n \e[38;5;93m───────────────────────────────────────\e[0m"
		
		PrintInfo "Version" "V$DIETPI_VERSION \e[90m($HW_MODEL_DESCRIPTION)\e[0m"
		PrintInfo "Uptime" "$(uptime)"	

		echo -e "  \e[38;5;93m───────────────────────────────────────\e[0m"        
	}

	Credits_Print(){
		echo -e ""
		echo -e "\e[1m dietpi-config\e[0m    = Feature rich system configuration tool."
		echo -e "\e[1m dietpi-software\e[0m  = Select / Install optimized software."
		echo -e "\e[1m dietpi-uninstall\e[0m = Remove DietPi Installed Software."
		#Update available
		if (( $UPDATE_AVAILABLE > 0 )); then
			echo -e "\e[1m dietpi-update\e[0m    = \e[91mRun now to update DietPi (from V$DIETPI_VERSION to V$UPDATE_AVAILABLE).\e[0m"
		elif (( $UPDATE_AVAILABLE == -1 )); then
			echo -e "\n\e[91m An updated DietPi image is available, please goto:\e[0m\n http://fuzon.co.uk/phpbb/viewtopic.php?f=8&t=9#p9\n"
		fi
		echo -e "\e[1m dietpi-bugreport\e[0m = Found an issue or bug? Let us know!"
		echo -e "\e[1m htop\e[0m             = Resource monitor."
		echo -e "\e[1m cpu\e[0m              = Shows CPU information and stats."
		echo -e ""
	}

	#/////////////////////////////////////////////////////////////////////////////////////
	# Main Loop
	#/////////////////////////////////////////////////////////////////////////////////////
	if (( $INPUT == 0 )); then
		Banner_TopText_Extras
		Banner_Dietpi

	elif (( $INPUT == 1 )); then
		Banner_TopText_Extras
		Banner_Dietpi
		Credits_Print
	fi

	#-----------------------------------------------------------------------------------
