#!/bin/bash

modifyJSON() {
    BRANCH=$1
    OVNER=$2
    curl "https://raw.githubusercontent.com/EPAM-JS-Competency-center/devops-fundamentals-course/main/lab_1/pipeline.json" |
        jq "del(.metadata) 
        | .pipeline.version=.pipeline.version+1 
        | (.pipeline.stages[] | select(.name==\"Source\") | .actions[] | select(.name==\"Source\") | .configuration.Branch) 
        |= \"$BRANCH\" 
        | (.pipeline.stages[] | select(.name==\"Source\") | .actions[] | select(.name==\"Source\") | .configuration.Owner) 
        |= \"$OVNER\""

}

help() {
    echo "HELP"
}

main() {
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
        *) break ;;
        esac
    done

    modifyJSON $BRANCH $OVNER
}

main $@

# .pipeline.stages | map(select(.name=="Source") | .actions | map(select(.name=="Source") | .configuration |.Branch="new branch" | .Owner="new Owner" ))
# .pipeline.stages | map(select(.name=="Source") | .actions | map(select(.name=="Source") | .configuration | .Branch |= "new branch" | .Owner |= "new Owner" ))

# (.pipeline.stages[] | select(.name=="Source") | .actions[] | select(.name=="Source") | .configuration.Branch) |= "new branch"
