#!/bin/bash
function capitalize_first_letter {
	local name=$1
	echo "$(tr '[:lower:]' '[:upper:]' <<< ${name:0:1})${name:1}"
}

names=""
firstname=""
lastname=""
projecthome="/usr/share/trac/projects/ArchAndInfra"
while read username
do
IFS='.' read -ra nameArray <<< "$username"
firstname=$(capitalize_first_letter ${nameArray[0]})
lastname=$(capitalize_first_letter ${nameArray[1]})
names=$names'|'$firstname' '$lastname
done <<< "$(sqlite3 ${projecthome}/db/trac.db "SELECT username FROM permission where action = 'interviewer' ORDER BY username COLLATE NOCASE")"
cp ${projecthome}/conf/trac.ini ${projecthome}/conf/trac.ini.dailybackup
sed -i "s/\(.*interview_interviewer.*options.*\)=.*/\1= ${names}/g" ${projecthome}/conf/trac.ini
echo $names
