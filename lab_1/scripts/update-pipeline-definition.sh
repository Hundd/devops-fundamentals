#!/bin/bash

modifyJSON() {
    PIPELINE_PATH=$1
    BRANCH=$2
    OVNER=$3
    POLL_FOR_SOURCE_CHANGES=$4
    REPO=$5

    getConfiguration="(.pipeline.stages[] | select(.name==\"Source\") | .actions[] | select(.name==\"Source\") | .configuration"
    JSON=$(cat "$PIPELINE_PATH" | jq "del(.metadata) | .pipeline.version=.pipeline.version+1 ")

    if [ ! -z $BRANCH ]; then
        JSON=$(jq "${getConfiguration}.Branch) |= \"$BRANCH\" " <<<$JSON)
    fi

    if [ ! -z $OVNER ]; then
        JSON=$(jq "${getConfiguration}.Owner) |= \"$OVNER\"" <<<$JSON)
    fi

    if [ ! -z $POLL_FOR_SOURCE_CHANGES ]; then
        JSON=$(jq "${getConfiguration}.PollForSourceChanges) |= \"$POLL_FOR_SOURCE_CHANGES\"" <<<$JSON)
    fi

    if [ ! -z $REPO ]; then
        JSON=$(jq "${getConfiguration}.Repo) |= \"$REPO\"" <<<$JSON)
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

    PIPELINE_PATH=$1
    shift
    while true; do
        case "$1" in
        -b | --branch)
            BRANCH="$2"
            shift 2
            ;;
        -b | --ovner)
            OVNER="$2"
            shift 2
            ;;
        --poll-for-source-changes)
            POLL_FOR_SOURCE_CHANGES="$2"
            shift 2
            ;;
        --repo)
            REPO="$2"
            shift 2
            ;;
        *) break ;;
        esac
    done

    modifyJSON "$PIPELINE_PATH" $BRANCH $OVNER $POLL_FOR_SOURCE_CHANGES $REPO
}

main $@
