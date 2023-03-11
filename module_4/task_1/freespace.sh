
threshold=$(./helpers/getThreshold.sh $@)

if [ -z $threshold ]
then
    exit 1
fi

watch(){
    freeSpace=$(./helpers/getFreeSpace.sh)
    if [ $freeSpace -lt $threshold ]
    then
        echo Free space is ok;
    else
        echo Attention: freespace $freeSpace% is above threshold $threshold%
    fi
}

while true
do
    watch
    sleep 1
done
