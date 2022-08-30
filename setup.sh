source $PWD/lib/unix.sh
source $PWD/setup/helper.sh

is_prerequisites_satisfied && install_tools && return $TRUE || return $FALSE