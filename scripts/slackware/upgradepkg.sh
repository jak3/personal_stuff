#!/bin/sh
for dir in a ap d e f k kde l n t tcl x xap xfce y ; do
    ( cd $dir ; upgradepkg *.t?z ) # add --install-new for ad-hoc new slackware
done

