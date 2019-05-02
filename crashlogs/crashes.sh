#!/bin/bash

readonly WORKDIR="`mktemp -d`"
readonly SCRIPTDIR="`cd "$( dirname "$0" )" && pwd`"
readonly OUTDIR="${SCRIPTDIR}/out"
readonly DATADIR="${SCRIPTDIR}/data"

(
    cd "${WORKDIR}"
    find "${DATADIR}" -iname "*.tar.gz" -exec tar xf '{}' ';'
    # Find all the Ghostery json files
    FILES=`find "${WORKDIR}" -iname "*.json"| xargs grep -l "Ghostery"`
    for log in ${FILES}
    do
        stacktrace="$( cat "${log}"|jq ".JavaStackTrace" )"
        lines="$( echo -e "${stacktrace}"|head -2 )"
        out="$( echo "${lines}"|md5sum|cut -d' ' -f1 )"
        file="${OUTDIR}/${out}.json"
        cp "${log}" "${file}"
    done
)

rm -rf "${WORKDIR}"
