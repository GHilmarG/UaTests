
if [ $# -ne 1 ]; then
    printf " which file type? \n "
    exit 1
fi

rsync --recursive -auve ssh ghg@bslcene.nerc-bas.ac.uk:/data/glacier3/ghg/Ua/Tests/PIG-TWG/*.$1 .
