
function config_gitprompt --description "copy fish shell config with git prompt"

    set -l git_prompt_config_src "$SOURCE_CONFIG_DIR/git_prompt.fish"
    set -l git_prompt_config_dest "$DEST_CONFIG_DIR"

    copy_config $git_prompt_config_src $git_prompt_config_dest
    
end 