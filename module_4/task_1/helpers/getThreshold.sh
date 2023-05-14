declare -i DEFAULT_THRESHOLD=70
declare -i threshold=$( echo $1 | tr -d -c 0-9 )
if [ -z $1 ]
then
    threshold=$DEFAULT_THRESHOLD;
elif [ $threshold -gt 100 ]
then
    echo "Max Threshold is 100, received $threshold" >&2
    echo Program exited... >&2
    exit 1
elif [ $threshold -lt 0 ]
then
    echo Min Threshold is 0, received $threshold >&2
    echo Program exited... >&2
    exit 1
fi

echo $threshold
