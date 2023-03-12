#!/bin/bash
DB="../data/users.db"
BACKUP="../backup"

readString() {
    promt=$1

    read -p "$promt" value
    until [[ $value =~ ^[[:alpha:]]+$ ]]; do
        echo Err: Only letters are supported >&2
        read -p "$promt" value
    done

    echo $value
}

checkDBExistance() {
    if [ ! -f "$DB" ]; then
        promt="File $DB is not exist. Do you want to create it? "
        read -p "$promt" answer
        until [[ $answer =~ ^(yes|no|y|n)$ ]]; do
            echo Err: Only yes or no >&2
            read -p "$promt" answer
        done
        case $answer in
        y | yes) touch $DB ;;
        n | no)
            echo Program exited... >&2
            exit 1
            ;;
        esac
    fi
}

add() {
    echo Adding to DB...
    username=$(readString "Enter new user name: ")
    role=$(readString "Enter the user's role: ")
    checkDBExistance
    echo $username, $role >>$DB
}

help() {
    echo User Data Base
    echo
    echo Commands:
    echo " add        add a new user"
    echo " backup     backup DB"
    echo " find       find a recodrd in DB"
    echo " help       view help"
    echo " list       list all records in DB"
    echo "              --inverted list in inverted order"
    echo " restore    restore DB"
}

backup() {
    checkDBExistance
    if [ ! -d "$BACKUP" ]; then
        mkdir $BACKUP
    fi
    date=$(date "+%Y-%m-%d-%H-%M")
    cp $DB "$BACKUP/$date-users.db.backup"
}

restore() {
    mostResent=$(ls -Art $BACKUP | tail -n 1)
    if [ -z $mostResent ]; then
        echo "No backup file found" >&2
        exit 1
    fi
    checkDBExistance
    cp "$BACKUP/$mostResent" $DB
}

find() {
    username=$(readString "Enter user name to find: ")
    res=$(grep -Ei "$username[^.]*," $DB)
    if [ -z $res ]; then
        echo "User not found"
    else
        echo "$res"
    fi
}

list() {
    list=$(awk -v ln=1 '{print ln++  ". "  $0 }' $DB)
    inverted=$1
    if [ -z $inverted ]; then
        echo "${list}"
    else
        echo "${list}" | tac
    fi
}

main() {
    if [ $# -eq 0 ]; then
        help
        exit 1
    fi

    action=$1

    case $action in
    add) add ;;
    backup) backup ;;
    find) find ;;
    help) help ;;
    list) list $2 ;;
    restore) restore ;;
    *)
        echo Unknown command: $action >&2
        help
        exit 1
        ;;
    esac
}

main $@
