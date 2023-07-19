# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

function make_dir -a dest_dir -d "make dest_dir if it does not exist"

    # return true if directory already exists
    if test -d $dest_dir
        true
        return 
    end

    # return true if directory is created
    if ! test -d $dest_dir
        mkdir -p $dest_dir
  
    end

    return
end 

function copy_config -a src_file -a dest_dir -d "copy source to find if both source and dest exists"

    if ! test -f $src_file
        false
        return
    end

    if ! test -d $dest_dir
        false
        return
    end 

    cp $src_file $dest_dir
end 

function git_clone -a repository -a dest_dir -a "clone git repository"
    git clone $repository $dest_dir 1>/dev/null 2>&1
end