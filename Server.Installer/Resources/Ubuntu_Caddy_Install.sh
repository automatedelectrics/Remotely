#!/bin/bash
echo "Thanks for trying Remotely!"
echo

Args=( "$@" )
ArgLength=${#Args[@]}

for (( i=0; i<${ArgLength}; i+=2 ));
do
	if [ "${Args[$i]}" = "--host" ]; then
		HostName="${Args[$i+1]}"
	elif [ "${Args[$i]}" = "--approot" ]; then
		AppRoot="${Args[$i+1]}"
	fi
done

if [ -z "$AppRoot" ]; then
	read -p "Enter path where the Remotely server files should be installed (typically /var/www/remotely): " AppRoot
	if [ -z "$AppRoot" ]; then
		AppRoot="/var/www/remotely"
	fi
fi

if [ -z "$HostName" ]; then
	read -p "Enter server host (e.g. remotely.yourdomainname.com): " HostName
fi


echo "Using $AppRoot as the Remotely website's content directory."


echo "Making the Remotely_Server file executable..."
chmod +x "$AppRoot/Remotely_Server"


# Configure Caddy
echo "Creating Caddy config file..."
caddyConfig="
$HostName {
	reverse_proxy 127.0.0.1:5000
}
"
echo "$caddyConfig" > /etc/caddy/Caddyfile
