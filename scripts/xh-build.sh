#!/bin/bash

# This is a modified version of dist-release.sh, with the following changes:
#
#	+ 	Uses `npm install --build-from-source` rather than `yarn install`,
#		as a workaround for a node-gyp issue.
#	+	Removes support for the "no-build" flag
#	+	Skips running tests.
#	+	Skips creating a version release commit.
#
# Note that this script expects node v10.12.0 and globally installed Gulp CLI.
# (i.e. run `npm install --global gulp-cli`)

set -e

distrepo='OnsenUI-dist'

cd ..

if [[ ! ( -d $distrepo && -d $distrepo/.git ) ]]
then
	echo "* $(tput setaf 3)Cloning OnsenUI/$distrepo$(tput setaf 7)..."
	git clone https://github.com/OnsenUI/$distrepo.git
	echo "** $(tput setaf 2)Finished$(tput setaf 7)!"
else
	echo "* $(tput setaf 3)Fetching OnsenUI/$distrepo$(tput setaf 7)..."
	(cd $distrepo && git fetch --tags)
	echo "** $(tput setaf 2)Finished$(tput setaf 7)!"
fi

(cd $distrepo && git rm -r * --cached --ignore-unmatch 1>/dev/null && rm -rf *)

echo "* $(tput setaf 3)Installing dependencies of css-components$(tput setaf 7)..."
(cd css-components && yarn install)
echo "** $(tput setaf 2)Finished$(tput setaf 7)!"

echo "* $(tput setaf 3)Preparing OnsenUI$(tput setaf 7)..."

yarn install
(cd bindings/angular1 && yarn install)
node_modules/.bin/gulp dist

echo "** $(tput setaf 2)Finished$(tput setaf 7)!"
