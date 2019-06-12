#!/usr/bin/env bash

function gameboard() {
    # up-to-date
    ## switch back to development
    git checkout development

    # git pull is same as:
    #    git fetch upstream
    #    git merge upstream/development
    git pull --ff upstream development
    git submodule update --init --recursive
    git push

    git checkout -b ${task}

    # ** do work **
    git add ....
    git add ....
    git commit

    git push origin ${task}
    open https://github-ca.corp.zynga.com/jpollak/TheNewWordsWithFriends

    # GWF testing
    bundle exec rake
    # If you see “failed to migrate the test DB”, try
    bundle exec rake db:create test

    # Start GWF server
    bundle exec script/rails server -p8080


    # skip using personal development branch
    git fetch upstream
    git checkout upstream/development
    git checkout -b ${task}
    git submodule update --init --recursive
}

# make local look like head
function revert_all() {
    git reset --hard
}

function my_branches() {
    git for-each-ref --format=' %(authorname) %(refname)' --sort=authorname | grep Pollak | grep heads | perl -pe 's|.*/||'
}

function local_branches() {
    git branch | perl -pe 's/^..//'
}

function pull_all_local_branches() {
    for branch in $(local_branches); do
        git checkout ${branch}
        git pull
        git push
    done
}
