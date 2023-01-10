#!/bin/bash
echo $HOSTNAME
a=$1
b=$2

value=$(echo "$a + $b" |bc)

#GROUP_ID=$(cat ./creds.csv | cut -d "," -f 1)
#BOT_TOKEN=$(cat ./creds.csv | cut -d "," -f 2)

send_telegram_message() {
  echo Connection $status 
  curl -s --data "text=$ports %0A $connection %0A $status %0A value $value" --data "chat_id=$GROUP_ID" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
}


while IFS=, read -r ip port;
do
  ports=$(echo ip:port="${ip}:${port}")
  echo ip:port="${ip}:${port}"
  connection=$(nc -w 1 -zv ${ip} ${port} 2>&1 | grep 'Connected') 
  echo connection: ${connection}
  if  [ -z "${connection}" ]
  then
      status="Not Successfull"
      send_telegram_message
  else
      status="Successfull"
      send_telegram_message
  fi



done <<EOF
google.com.ua,443
microsoft.com,22
EOF
