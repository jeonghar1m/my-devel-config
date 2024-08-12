#!/bin/sh

noUbuntu=`uname -a | grep -i -e ubuntu -e microsoft`
VI=`which vi`
if [ "$noUbuntu" != "" ]; then
    wget https://gist.githubusercontent.com/kostaz/6e0cf1eee35a34cd6589ec15b58e682c/raw/8491560fd53c98ee85a2f9916000167190113b52/install-ripgrep-on-ubuntu.sh
    chmod 755 install-ripgrep-on-ubuntu.sh
    $SUDO ./install-ripgrep-on-ubuntu.sh
fi
go get -u github.com/jstemmer/gotags

GOCORE="$HOME/.git_template/hooks"

COMMITID='f4ebea4fde9663e05d0d961d6f9705c1d93ba94b'
echo "Git & go Hook 설치"
for_mac=`uname -a | grep -ie Darwin`
if [ "$for_mac" != "" ]; then
$SUDO wget https://gist.githubusercontent.com/newro/2e87f37a88e406521fc03825669d2d47/raw/$COMMITID/commit-msg_for_mac -O $GOCORE/commit-msg
else
$SUDO wget https://gist.githubusercontent.com/newro/2e87f37a88e406521fc03825669d2d47/raw/$COMMITID/gistfile1.txt -O $GOCORE/commit-msg
fi
$SUDO wget https://gist.githubusercontent.com/newro/2e87f37a88e406521fc03825669d2d47/raw/$COMMITID/gotags_hook -O $GOCORE/gotags
$SUDO wget https://gist.githubusercontent.com/newro/2e87f37a88e406521fc03825669d2d47/raw/$COMMITID/post-commit-hook -O $GOCORE/post-commit
$SUDO wget https://gist.githubusercontent.com/newro/2e87f37a88e406521fc03825669d2d47/raw/$COMMITID/post-checkout-hook -O $GOCORE/post-checkout
$SUDO chmod 755 $GOCORE/commit-msg
$SUDO chmod 755 $GOCORE/post-commit
$SUDO chmod 755 $GOCORE/post-checkout
$SUDO chmod 755 $GOCORE/gotags
$SUDO cp -fp $GOCORE/post-commit $GOCORE/post-merge

