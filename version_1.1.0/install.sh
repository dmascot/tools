# Copyright (c) 2023 DMascot
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

REPOSITORY="https://github.com/dmascot/tools.git"

DEST_DIR='/tmp/tools'

git_exists(){
  if ! command -v git 1>/dev/null 2>&1; then
    echo "tools: Git is not installed, can't continue." >&2
    exit 1
  fi
}

clone_repository(){
  echo "cloning tools repository to $DEST_DIR"
  git clone $REPOSITORY $DEST_DIR 1>/dev/null 2>&1
}

run_setup(){
  echo "Installing Tools"
  cd $DEST_DIR && source setup.sh && cd - 1>/dev/null 2>&1
}

clean_up(){
  echo "Cleaning $DEST_DIR"
  rm -rf ${DEST_DIR}
}

main(){
  git_exists
  clone_repository
  run_setup
  clean_up
}

main