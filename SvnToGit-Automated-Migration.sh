#!/bin/bash

            username=("alex Jackson") #username
            email=("alex_jackson@jmmb.com") #emaill 

            git config --global user.name $username 

            git config --global user.email $email


# File containing the list of SVN repository names
repo_file="repo_list.txt"
repo_git_file="repo_git_list.txt"
csv_file="svn-sample-30.csv"


# Loop through the list of repository names
#while read repo_name; do
    #while read repo_git; do
        # Loop through the lines in the file
        while IFS="," read -r repo_name repo_description language; do

            #if [$name == $repo_name] ; then
                        #echo "$repo_git"

            repo_name=${repo_name//$'\r'}
            repo_git="$repo_name.git"

            URL=("http://monaco:9000/svn/$repo_name") #paste repository here
            remoteOrigin=("https://gitlab.jmmb.com/alex-final-tests/$repo_git") #paste remote origin here


            git svn clone -r1:HEAD --no-minimize-url --stdlayout --no-metadata --authors-file MainAuthors.txt $URL --trunk="trunk" --branches="branches/" --tags="tags/"

            pwd
            cd $repo_name/ #navigate to dir where folder was created

            git config --local description "$repo_description written in $language" #add descripton
            git push --set-upstream git@gitlab.jmmb.com:git-migration-test/$(git rev-parse --show-toplevel | xargs basename).git $(git rev-parse --abbrev-ref HEAD)
            git remote add origin $remoteOrigin #runs the git remote command
            pwd

            #git branch -a #get list of branches

            touch README.md
            git add README.md
            git commit -m "$repo_description"
            git for-each-ref refs/remotes/tags | cut -d / -f 4- | while read ref; do git tag "$ref" "refs/remotes/tags/$ref"; git branch -r -d "tags/$ref";  done
            git branch -r | grep -v --invert-match "@" | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
            #git commit -m "$repo_description"
            git push -f --all origin
            git push -f --tags origin


            cd ../
            #echo $URL
            #echo "  "
           # echo $remoteOrigin

       # else
          #  echo "$name is Not in XML FILE LIST"
       # fi
        
        sed -i '/./{x;d};x' svn-sample-30.csv #deleting the completed line
        done < "$csv_file"
   # done < "$repo_git_file"
#done < "$repo_file"