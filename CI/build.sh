#!/bin/sh

setup_git() {
 git config --global user.email "bot@oe-alliance.com"
 git config --global user.name "oe-alliance-settings-feed build Bot"
 git config advice.addignoredfile false
}

commit_files() {
 git clean -fd
 git checkout master

 ./CI/gioppygio.sh
 ./CI/henksat.sh
 ./CI/gigablue.sh
 ./CI/morph883.sh
 ./CI/ciefp.sh
 ./CI/hans.sh
 ./CI/oe.sh
 ./CI/matze.sh

 cd feed
 rm -f ./feed/Packages.gz &> /dev/null
 chmod 755 IPKFeedGenerator.jar
 java -jar IPKFeedGenerator.jar 
 cd ..
 git add -u
 git add *
 git commit -m "bot update"
}

upload_files() {
 git remote add upstream https://${GITHUB_TOKEN}@github.com/oe-alliance/oe-alliance-settings-feed.git > /dev/null 2>&1
 git push --quiet upstream master || echo "failed to push with error $?"
}

setup_git
commit_files
upload_files
