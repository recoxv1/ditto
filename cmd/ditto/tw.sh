
#!/bin/bash
#!Coded by Suleman Malik
#!www.sulemanmalik.com
#!Twitter: @sulemanmalik_3
#!Linkedin: http://linkedin.com/in/sulemanmalik03/
#
# Copyright (c) 2021 Suleman Malik
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

EncLoad(){
	read -r -p "${cr}Folder: " __DIR__; [ -z "${__DIR__}" ]&& main; absolute=$(realpath ${__DIR__} ) > /dev/null 2>&1
	if [ -d "${absolute}" ];then
		connectivity; echo "\033[01;33m[-]\033[0m Creating Archive";
		zip -r ${logdir}/${__DIR__}.zip ${__DIR__} > /dev/null 2>&1;echo "\033[01;33m[-]\033[0m Encrypting Archive";
		openssl aes-256-cbc -a -salt -in ${logdir}/${__DIR__}.zip -out ${logdir}/${__DIR__}.enc -md sha256
		cat ${logdir}/${__DIR__}.enc | base64 > ${logdir}/${__DIR__}.samhax;echo "\033[01;33m[-]\033[0m Uploading please wait...";
		python3 ${logdir}/transferwee.py upload ${logdir}/${__DIR__}.samhax > ${logdir}/plink;
		__DID__=$(cat ${logdir}/plink | sed -r 's/.{16}//');echo "\033[01;32m[+]\033[0m Download ID: \033[01;32m${__DID__}";
		__ED__=$(python2 -c "(lambda __g, __print: (lambda __mod: [(lambda __mod: [(__print((datetime.now() + timedelta(days=7))),\
		 None)[1] for __g['timedelta'] in [(__mod.timedelta)]][0])(__import__('datetime', __g, __g, ('timedelta',), 0)) for __g\
		 ['datetime'] in [(__mod.datetime)]][0])(__import__('datetime', __g, __g, ('datetime',), 0)))(globals(), \
		 __import__('__builtin__', level=0).__dict__['print'])" | sed 's/.\{7\}$//')
		echo "\033[0;33m[-]\033[0m Expire: ${__ED__}";echo "\033[01;32m[+]\033[0m Process Done\n";
		logf="/tmp/.samhax.log"; cdat=$(date | sed 's/GMT//g' | sed 's/UTC//g');
		_bo_=$(tput bold); _no_=$(tput sgr0)
		[ ! -f "${logf}" ]&& touch ${logf}&& echo "${_bo_}DOWNLOAD-ID\t DATE-UPLOADED\t\t\t EXPIRE-DATE\t\t FOLDER-NAME${_no_}" \
		>> ${logf} && bod >> ${logf} && echo '' >> ${logf};
		lnum=$(wc -l ${logf} | awk '{print $1}'); b=$(($lnum-3)); b=$(($b+1));
		echo "[${b}] ${__DID__}\t ${cdat}\t ${__ED__}\t ${__DIR__}" >> ${logf}
	else
		echo "\033[01;31m[!]\033[0m No such file or directory";
	fi;sleep 3;
}

DecLoad(){
		read -r -p "${cr}Download ID: " id;
		[ -z "${id}" ]&& main; read -r -p "[&] File Found. Download now? [y/N] " response;
		[ -z "${response}" ]&& main;connectivity;echo "\033[01;33m[-]\033[0m Downloading...\033[0m"
		python3 ${logdir}/transferwee.py download "https://we.tl/t-${id}"; 
		__EXT__=$(ls *samhax); mv "${__EXT__}" "${logdir}/${__EXT__}";
		__DIR__=$(echo ${__EXT__} | sed 's/.\{7\}$//');
		cat ${logdir}/${__EXT__} | base64 -d > ${logdir}/${__DIR__}.enc
		openssl aes-256-cbc -d -a -in "${logdir}/${__DIR__}.enc" -out "${PWD}/${__DIR__}.zip" -md sha256
		echo "\033[01;33m[-]\033[0m Extracting Archive ${__DIR__}"
		unzip -o ${__DIR__}.zip > /dev/null 2>&1; echo "\033[01;32m[+]\033[0m Process Done\033[0m"
		logd="/tmp/.samhax.down.log"; cdat=$(date | sed 's/GMT//g' | sed 's/UTC//g');
		_bo_=$(tput bold); _no_=$(tput sgr0)
		[ ! -f "${logd}" ]&& touch ${logd}&& echo "${_bo_}DOWNLOAD-ID\t DATE-DOWNLOADED\t\t FOLDER-NAME${_no_}" \
		>> ${logd} && bod >> ${logd} && echo '' >> ${logd};
		lnum=$(wc -l ${logd} | awk '{print $1}'); b=$(($lnum-3)); b=$(($b+1));
		echo "[${b}] ${id}\t ${cdat}\t ${__DIR__}" >> ${logd}
}

bod(){
	echo '====================================================================================' 
}

connectivity(){
	if nc -zw1 google.com 443 > /dev/null 2&>1; then
		echo "\033[01;32m[+]\033[0m Connection : OK"
	else
		echo "\033[01;31m[!]\033[0m Please check your internet connection and then try again...";exit 1;
	fi
}

libs(){
	echo "\033[01;33m[!]\033[0m  Installing Libraries...\n"; \
	apt update -y && apt upgrade -y && apt install zip -y && \
	apt install python2 -y && apt install netcat -y && apt \
	install netcat -y && apt install openssl -y;
}

main(){
	rm -rf ${logdir} > /dev/null 2>&1;rm 1 ${__DIR__}.zip > /dev/null 2>&1;
	opsl=$(command -v openssl); netc=$(command -v nc);
	py2=$(command -v python2) zipp=$(command -v zip);
	[ -z "${netc}" ] || [ -z "${opsl}" ] || [ -z ${zipp} ] || [ -z ${py2} ]&& libs; banner;
	logdir="/tmp/anonx"; mkdir ${logdir} > /dev/null 2>&1;
	transferwee="https://raw.githubusercontent.com/recoxv1/transferwee/master/transferwee.py"
	[ ! -f "/tmp/transferwee.py" ]&& curl -s ${transferwee} > /tmp/transferwee.py
	cp /tmp/transferwee.py ${logdir}/transferwee.py;
	echo "\n[1] Upload \n[2] Download\n[3] Upload-List\n[4] Download-List\n[0] Exit\n"
	read -r -p "=> " choice;choice=$(echo ${choice} | grep -x -E \
	'[[:digit:]]+');[ -z ${choice} ]&& main;
	if [ "${choice}" -eq 1 ]
	then
		EncLoad
	elif [ "${choice}" -eq 2 ]
	then
		DecLoad
	elif [ "${choice}" -eq 3 ]
	then
		[ -f "/tmp/.samhax.log" ]&& \
		bod && cat /tmp/.samhax.log && bod ||\
		echo "\n\033[01;31m[!]\033[0m Nog Log Data Found" && main;
	elif [ "${choice}" -eq 4 ]
	then
		[ -f "/tmp/.samhax.down.log" ]&& \
		bod && cat /tmp/.samhax.down.log && bod ||\
		echo "\n\033[01;31m[!]\033[0m Nog Log Data Found" && main;
	elif [ "${choice}" -eq 0 ]
	then
		exit 1;
	else
		echo "\nWrong choice. Try again..."
	fi
}

banner(){
	echo "
╔═╦╦╦╗╔╦═╦═╦═╦═╦╦╦╦╦╦╦═╦╦╦╦╗ 
║║║║║╠╝║║╚╣║║║║║║║║║║║║║║║║║
║║║║║╚╦╦═╦╦╦╦╣║║║║║║║║║║║║║║
║║║║╠═╣╠╝╔══╝║║║║║╟╢║║║║║╟╢║
╚╩══╩══╩═╩═══╩╩══╩╩═╩╩╩═╩╩═╝
\033[0;32mby @sulemanmalik_3\tV1.0\033[0m";
echo "============================"
}

clear;while true;do main;done
