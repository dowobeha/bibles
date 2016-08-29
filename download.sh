#!/bin/bash

url="http://bibles.org/esu-YPK/Gen/int"

function update_values() {
	
	lang=$(   echo "${url}" | sed 's,.*/\([^/]\+\)/\([^/]\+\)/\([^/]\+\),\1,')
	book=$(   echo "${url}" | sed 's,.*/\([^/]\+\)/\([^/]\+\)/\([^/]\+\),\2,')
	chapter=$(echo "${url}" | sed 's,.*/\([^/]\+\)/\([^/]\+\)/\([^/]\+\),\3,')

	if [[ "${chapter}" == "int" ]]; then
		chapter=00
	elif [[ "${chapter}" -lt 10 ]]; then
		chapter="0${chapter}"
	fi

	mkdir -p "${lang}/${book}"

	output_file="${lang}/${book}/${chapter}"

}

function update_url() {
	local previous_url="${url}"
	
	url=$(cat "${output_file}" | sed 's,>,>\n,g' | grep '<a class="next"' | sed 's,.*href="\(.*\)/">,\1,')
	echo -e "Downloading...\t${url}"
	
	if [[ "${url}" == "${prev_url}" ]]; then
		return 1 # False
	elif [[ "${url}" == "" ]]; then
		return 1 # False
	else
		return 0 # True
	fi
}

function download_url() {
	wget --no-host-directories --force-directories "${url}" --output-document="${output_file}" &> "${output_file}.log"
}

# Process the first URL
update_values
download_url
update_url

# Process the remaining URLs
while [[ $? -eq 0 ]]; do

	update_values
	download_url
	update_url
	
done


