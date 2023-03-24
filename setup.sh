source $PWD/lib/unix/posix.sh

is_prerequisites_satisfied && install_tools && return $TRUE || return $FALSE
