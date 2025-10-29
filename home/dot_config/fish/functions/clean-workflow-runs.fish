function clean-workflow-runs --description="Clean Github workflow runs"
    for i in (seq 1 10)
        set ids (gh run list --json databaseId -L 100)
        if test -z $ids
            break
        end
        echo $ids | jq --raw-output '.[].databaseId' | xargs -n 1 gh run delete
    end
end
