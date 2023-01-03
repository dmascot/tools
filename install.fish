set -x REPOSITORY "https://github.com/dmascot/tools.git"

set -x DEST_DIR "/tmp/tools"

function is_prerequisites_satisfied --description "Check Prerequisites"

    if command -q git
        echo "git found....OK"
    else 
        echo "Install git command!"
        false
    end 

    if test -f  "$HOME/.config/fish/functions/bass.fish"
        echo "bass found....OK"
    else
        echo "Install bass from https://github.com/edc/bass"
        false
    end

end

function clone_repository --description "Clone repository"

  echo "cloning tools repository to $DEST_DIR"
  git clone $REPOSITORY $DEST_DIR 1>/dev/null 2>&1

end

function run_setup --description "Run setup command"
  
  echo "Installing Tools"
  mkdir -p $DEST_DIR && cd $DEST_DIR && source setup.fish && cd - 1>/dev/null 2>&1

end

function clean_up --description "Clean up install dir"

  echo "Cleaning $DEST_DIR"
  rm -rf $DEST_DIR

end

function main 
  is_prerequisites_satisfied
  clone_repository
  run_setup
  clean_up
end 

main