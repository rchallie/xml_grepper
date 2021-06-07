#!/bin/bash
# V1 by rchallie

helper() {
	echo ""
	echo "################################################################"
	echo "######################## XML GREPPER ###########################"
	echo "################################################################"
	echo ""
	echo "command: ./xml_grepper <file> <tag_to_grep>" 
}

# If not enought parameters are given
if [[ "$1" == "" || "$2" == "" ]]; then
	helper
	exit
fi

# Read the file to get the next "tag>value"
read_xml_file() {
	SAVE_IFS=$IFS
	local IFS=\>
	read -d \< TAG VALUE
	local rtn=$?
	TAG=${TAG%% *}
	IFS=$SAVE_IFS
	return $rtn
}

# Try all "tag>value", output all <tag_to_grep> with it parent path
while read_xml_file; do
	if [[ ${TAG::1} == "/" ]]; then
		PARENT=${PARENT%/*}
	elif [[ $TAG != "" && ${TAG::3} != "!--" && ${TAG::1} != "?" ]]; then
		PARENT="$PARENT/$TAG"
	fi
	if [[ $TAG = $2 ]]; then
		echo $PARENT=$VALUE
	fi
done < $1
