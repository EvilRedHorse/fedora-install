#! /usr/bin/sh
printf "make sure you have author set, this will commit\nCommit message: "
read MESSAGE
git add -A && git commit -m "$MESSAGE"
printf "now...\ngit push\n"
