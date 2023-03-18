#!/bin/bash
declare PROJECT_FOLDER=$(realpath "../project")
declare PROJECT_NAME="shop-angular-cloudfront"
declare DIST_FOLDER=$(realpath "../dist")

cloneRepo() {
    echo "Cloning working repository..."
    mkdir $PROJECT_FOLDER
    cd $PROJECT_FOLDER
    git clone https://github.com/EPAM-JS-Competency-center/$PROJECT_NAME.git
}

installDeps() {
    if [ ! -d $PROJECT_FOLDER/$PROJECT_NAME ]; then
        cloneRepo
    fi
    echo "Installing dependencies..."
    cd "$PROJECT_FOLDER/$PROJECT_NAME"
    npm install
}

buildProject() {
    if [ ! -d $PROJECT_FOLDER/$PROJECT_NAME/node_modules ]; then
        installDeps
    fi
    echo "Building project..."
    cd "$PROJECT_FOLDER/$PROJECT_NAME"
    export ENV_CONFIGURATION="production"
    # Disable angular questionarie
    export NG_FORCE_TTY=false
    npm run build --production
}

zipProject() {
    if [ ! -d $PROJECT_FOLDER/$PROJECT_NAME/dist ]; then
        buildProject
    fi
    if [ ! -d $DIST_FOLDER ]; then
        mkdir $DIST_FOLDER
    fi
    if [ -f $DIST_FOLDER/client-app.zip ]; then
        rm $DIST_FOLDER/client-app.zip
    fi
    echo "Zipping files...."
    zip -r $DIST_FOLDER/client-app.zip $PROJECT_FOLDER/$PROJECT_NAME/dist
}

help() {
    echo 'HELP'
    echo 'ACTIONS:'
    echo ''
    echo 'clone' clone repository
    echo 'install' install dependencies
    echo 'build' build project
    echo 'zip' zip files
}

main() {
    if [ $# -eq 0 ]; then
        buildProject
        zipProject
        exit 0
    fi

    action=$1
    case $action in
    clone) cloneRepo ;;
    install) installDeps ;;
    build) buildProject ;;
    zip) zipProject ;;
    *) help ;;
    esac
}

main $@
