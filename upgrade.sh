for f_name in `ls pack`
do
    if ! [[ $f_name == 'base' ]]
    then
        for sub_f_name in `ls pack/$f_name/start/`
        do
            cd pack/$f_name/start/$sub_f_name
            git pull
            cd ../../../../
        done
    fi
done
