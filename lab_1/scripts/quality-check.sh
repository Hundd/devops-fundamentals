declare PROJECT_FOLDER=$(realpath "../project")
declare PROJECT_NAME="shop-angular-cloudfront"

lint() {
    cd $PROJECT_FOLDER/$PROJECT_NAME
    echo "Start linting..."
    npm run lint
}

test() {
    cd $PROJECT_FOLDER/$PROJECT_NAME
    echo "Start testing..."
    npm run test
}

main() {
    if [ ! -d $PROJECT_FOLDER/$PROJECT_NAME/node_modules ]; then
        ./build-client.sh install
    fi
    # Disable angular questionarie
    export NG_FORCE_TTY=false
    lint
    test
}

main $@
