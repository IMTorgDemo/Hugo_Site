#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"


# Build the project.
hugo -b "https://imtorgdemo.github.io/"    # if using a theme, replace with `hugo -t <YOURTHEME>`

cd ..
cp -r Hugo_IMTorgDemo/IMTorgDemo.github.io/.git Hugo_Site/public/
sudo rm -r Hugo_IMTorgDemo/IMTorgDemo.github.io/
cp -r Hugo_Site/public/ Hugo_IMTorgDemo/IMTorgDemo.github.io/

# Push and commit github.io
msg="rebuilding site `date`"
 
cd Hugo_IMTorgDemo/IMTorgDemo.github.io/
git add -A
git commit -m "$msg"
git push origin master

# Push and commit Hugo_Site
cd ../../Hugo_Site
sudo rm -r public/.git
git add -A
git commit -m "$msg"
git push origin master