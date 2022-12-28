optional_scripts_path="$(pwd -P )/lib/unix/optional"

case $UNIX_SYSTEM in
    Linux)
    optional_functions='linux.sh'
    ;;
    Darwin)
    optional_functions='mac.sh'   
    ;;
esac

source "$optional_scripts_path/$optional_functions"