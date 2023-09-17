set -e

npm run build
cd dist
git init
git add -A
git commit -m "new deployment"

git push -f git@github.com:hamzahfaisala/era-daya-apps.git master:gh-pages

cd -