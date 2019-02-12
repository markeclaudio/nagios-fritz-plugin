#!/bin/bash
#cd /root/cdr/
header="User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:23.0) Gecko/20100101 Firefox/23.0"
user="$1"
pass="$2"
url="$3"

echo "$1 $2 $3 " > /tmp/cosacosa

#avmfbip=$url
#avmfbuser=$user
#avmfbpwd=$pass
avmsidfile="/tmp/avmsid-$url"


if [ ! -f $avmsidfile ]; then
       touch $avmsidfile
fi

avmsid=$(cat $avmsidfile)

result=$(curl -k -s "https://$url/login_sid.lua?sid=$avmsid" | grep -c "0000000000000000")
#echo $result

if [ $result -gt 0 ]; then

#echo "Login neccessary"
challenge=$(wget --no-check-certificate  -O - https://$url/login_sid.lua -o /dev/null|  grep -o "<Challenge>[a-z0-9]\{8\}" | cut -d'>' -f 2)
#echo $challenge
#challenge="9b994641"
hash=$(echo -n "$challenge-$pass" |sed -e 's,.,&\n,g' | tr '\n' '\0' | md5sum | grep -o "[0-9a-z]\{32\}")
#echo $hash
curl -A "$header" -k -s "https://$url/login_sid.lua" -d "response=$challenge-$hash" -d 'username='${user} | grep -o "<SID>[a-z0-9]\{16\}" |  cut -d'>' -f 2 > $avmsidfile

fi

avmsid=$(cat $avmsidfile)
#echo "$avmsid"
output=$(wget --no-check-certificate -O - "https://$url/data.lua?xhr=1&sid=$avmsid&lang=it&page=overview&xhrId=first&noMenuRef=1&no_sidrenew=" -o /dev/null)

is_conn=$(echo $output| /usr/bin/jq ".data.internet.txt[0]"|sed -e 's/"//g')
up=$(echo $output| /usr/bin/jq ".data.internet.up"|sed -e 's/↑//g'|sed -e 's/"//g')
down=$(echo $output| /usr/bin/jq ".data.internet.down"|sed -e 's/↓//g'|sed -e 's/"//g')
provider=$(echo $output| /usr/bin/jq ".data.internet.txt[1]"|sed -e 's/"//g'|sed -e 's/,//g')

up_perf=$(echo $up |sed -e 's/Mbit\/s//g' |sed -e 's/,/./g' |sed -e 's/ //g')
down_perf=$(echo $down |sed -e 's/Mbit\/s//g' |sed -e 's/,/./g'|sed -e 's/ //g')



echo "OK - $is_conn. UP:$up DOWN:$down - $provider|up=$up_perf;down=$down_perf"


