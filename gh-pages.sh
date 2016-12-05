#! /usr/bin/bash

current_version="5.0.4"
previous_version="5.0.4"
mkdir -p ./$current_version
cp ./$previous_version/index.html ./$current_version
# TODO: potentially use a template for this:
# Right now we need to update index.html with
#                - Archived versions
#                - Timestamps for generation
# update the top level index.html for current_version
for pkg in "intera_interface" "intera_core_msgs"
do
    echo ">>> Documenting $pkg for release $current_version"
    mkdir -p ./$current_version/$pkg
    echo ">>> Temporarily switching directories to $pkg package.."
    pushd $(rospack find $pkg)
    git fetch origin
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    echo ">>> Checking out branch 'tmp_docs' from origin/release-$current_version"
    git checkout -b tmp_docs origin/release-$current_version
    echo ">>> Generating ROS documentation for $pkg"
    rosdoc_lite
    echo ">>> Restoring repo to its original state"
    git checkout $current_branch
    git branch -d tmp_docs
    echo ">>> Changing directory back to intera_sdk_docs"
    popd
    echo ">>> Moving generated docs contents for $pkg into $current_version folder"
    mv $(rospack find $pkg)/doc/* ./$current_version/$pkg
done

