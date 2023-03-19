#!/bin/bash

modifyJSON() {
    options=$1

    getConfiguration="(.pipeline.stages[] | select(.name==\"Source\") | .actions[] | select(.name==\"Source\") | .configuration"
    getEnv="(.pipeline.stages[].actions[].configuration | select(.EnvironmentVariables).EnvironmentVariables)"
    JSON=$(cat ${options[PIPELINE_PATH]} | jq "del(.metadata) | .pipeline.version=.pipeline.version+1 ")

    if [ ! -z ${options[BRANCH]} ]; then
        JSON=$(jq "${getConfiguration}.Branch) |= \"${options[BRANCH]}\" " <<<$JSON)
    fi

    if [ ! -z ${options[OVNER]} ]; then
        JSON=$(jq "${getConfiguration}.Owner) |= \"${options[OVNER]}\"" <<<$JSON)
    fi

    if [ ! -z ${options[POLL_FOR_SOURCE_CHANGES]} ]; then
        JSON=$(jq "${getConfiguration}.PollForSourceChanges) |= \"${options[POLL_FOR_SOURCE_CHANGES]}\"" <<<$JSON)
    fi

    if [ ! -z ${options[REPO]} ]; then
        JSON=$(jq "${getConfiguration}.Repo) |= \"${options[REPO]}\"" <<<$JSON)
    fi

    if [ ! -z ${options[CONFIGURATION]} ]; then
        JSON=$(jq "$getEnv|= sub(\"{{BUILD_CONFIGURATION value}}\"; \"${options[CONFIGURATION]}\")" <<<$JSON)
    fi

    echo "$JSON"
}

help() {
    echo "HELP"
}

checkIfJQExist() {
    if ! command -v jq &>/dev/null; then
        echo "jq could not be found"
        ehco "To install execute"
        echo " git clone https://github.com/stedolan/jq.git"
        echo " cd jq"
        echo " autoreconf -i"
        echo " ./configure --disable-maintainer-mode"
        echo " make"
        echo " sudo make install"
        exit 1
    fi
}

main() {
    checkIfJQExist
    declare -A options
    options[PIPELINE_PATH]=$1
    shift
    while true; do
        case "$1" in
        -b | --branch)
            options[BRANCH]="$2"
            shift 2
            ;;
        -b | --ovner)
            options[OVNER]="$2"
            shift 2
            ;;
        --poll-for-source-changes)
            options[POLL_FOR_SOURCE_CHANGES]="$2"
            shift 2
            ;;
        --repo)
            options[REPO]="$2"
            shift 2
            ;;
        --configuration)
            options[CONFIGURATION]="$2"
            shift 2
            ;;
        *) break ;;
        esac
    done

    modifyJSON $options
}

main $@
