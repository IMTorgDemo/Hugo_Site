#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"


# Build the project.
hugo -b "https://imtorgdemo.github.io/"    # if using a theme, replace with `hugo -t <YOURTHEME>`

cd ..
cp -r Hugo_Out-Site/IMTorgDemo.github.io/.git Hugo_Site_Repo/public/
sudo rm -r Hugo_Out-Site/IMTorgDemo.github.io/
cp -r Hugo_Site_Repo/public/ Hugo_Out-Site/IMTorgDemo.github.io/

# Push and commit github.io
msg="rebuilding site `date`"
 
cd Hugo_Out-Site/IMTorgDemo.github.io/
git add -A
git commit -m "$msg"
git push origin master

# Push and commit Hugo_Site
cd ../../Hugo_Site_Repo
sudo rm -r public/.git
git add -A
git commit -m "$msg"
git push origin master