#!/usr/bin/bash

set -o errexit -o noclobber -o noglob -o nounset -o pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CNAME='openhab' UGID='170000' PRIMPATH='/openhab'
MEMORY='4G' CPU_SHARES='1024'

source "${SCRIPTDIR}/../../scripts/variables.sh"

ADDONPATH="${HOSTPATH}/addons"
CONFIGPATH="${HOSTPATH}/config"
STATEPATH="${HOSTPATH}/state"
TMPPATH="${HOSTPATH}/tmp"
WEBAPPPATH="${HOSTPATH}/webapps"

perm_group "${ADDONPATH}"
perm_group "${CONFIGPATH}"
perm_custom "${STATEPATH}" "${UGID}" '0' 'u=rwX,g=rwX,o='
perm_user "${TMPPATH}"
perm_group "${WEBAPPPATH}" '' "-and -not -path ${WEBAPPPATH}/static*"
perm_user "${WEBAPPPATH}/static"

TELLSTICKPATH="$(readlink --canonicalize /dev/tellstickduo0)"

perm_user "${TELLSTICKPATH}"

docker create \
    --read-only \
    --volume="${ADDONPATH}:${PRIMPATH}/addons:ro" \
    --volume="${CONFIGPATH}:${PRIMPATH}/config:ro" \
    --volume="${STATEPATH}:${PRIMPATH}/state:rw" \
    --volume="${TMPPATH}:${PRIMPATH}/tmp:rw" \
    --volume="${WEBAPPPATH}:${PRIMPATH}/webapps:rw" \
    --device="${TELLSTICKPATH}" \
    --cap-drop 'ALL' \
    --net='none' \
    --dns="${DNSSERVER}" \
    --name="${CNAME}" \
    --hostname="${CNAME}" \
    --memory="${MEMORY}" \
    --memory-swap='-1' \
    --cpu-shares="${CPU_SHARES}" \
    nfnty/arch-openhab:latest

CID="$(docker inspect --format='{{.Id}}' "${CNAME}")"

cd "${BTRFSPATH}/${CID}"
setfattr --name=user.pax.flags --value=em usr/lib/jvm/java-8-openjdk/jre/bin/java
