echo "mode: set" > acc.out
for Dir in $(go list ./...);
do
    if [[ ${Dir} != *"/vendor/"* ]]
    then
        returnval=`go test -coverprofile=profile.out $Dir`
        echo ${returnval}
        if [[ ${returnval} != *FAIL* ]]
        then
            if [ -f profile.out ]
            then
                cat profile.out | grep -v "mode: set" >> acc.out
            fi
        else
            exit 1
        fi
    else
        exit 1
    fi

done

goveralls -coverprofile=acc.out -service=travis-ci
