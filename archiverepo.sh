echo "Cloning Repo $1/$2"
git clone git@github.com:$1/$2.git

echo "Fetching all branches"
cd $2
for branch in `git branch -a | grep remotes | grep -v HEAD | grep -v master `; do
   git branch --track ${branch#remotes/origin/} $branch
done

echo "Zipping up the repo"
cd ..
zip -r9 -s 50m $2.zip $2

echo "Copying to archive"
mv $2.zip ~/git/archive
rm -rf $2

echo "Updating archive"
cd ~/git/archive
git add -A
git commit -a -m "Archiving repo $1 $2"
git push

echo "Archive complete"
