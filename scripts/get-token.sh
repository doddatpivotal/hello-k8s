#!/bin/bash -e

function usage()
{
    echo "--API=[FQDN-OF-YOUR-PKS-API]"
    echo "--USER=[LDAP-USER]"
    echo "example: ./get-token.sh --API=pks.mg.lab --USER=cody"
}

urlencode() {
    local l=${#1}
    for (( i = 0 ; i < l ; i++ )); do
        local c=${1:i:1}
        case "$c" in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            ' ') printf + ;;
            *) printf '%%%.2X' "'$c"
        esac
    done
}


if [ "$#" -ne 2 ]; then
        usage
        exit 1
fi

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        --API)
            PKS_API=$VALUE
            ;;
        --USER)
            PKS_USER=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

#Prompt for Password
echo -n "Password:"
read -s PKS_PASSWORD_RAW
echo -n ""

PKS_PASSWORD=$(urlencode $PKS_PASSWORD_RAW)

# Collect Tokens from UAA
CURL_CMD="curl 'https://${PKS_API}:8443/oauth/token' -sk -X POST -H 'Accept: application/json' -d \"client_id=pks_cluster_client&client_secret=\"\"&grant_type=password&username=${PKS_USER}&password=\"${PKS_PASSWORD}\"&response_type=id_token\""
# edited from the original which had {print $4, $12}, which incorrectly pulled to access-token and id-token
read access_token  <<< $(eval $CURL_CMD | awk -F\" '{print $4}')\

printf "\n\naccess_token: $access_token"

#echo $(eval $CURL_CMD) | jq
