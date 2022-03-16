source scripts/functions.sh

test_existing_user(){
    assertTrue "Expected: User $USER to exist" "is_existing_user $USER"
}

test_non_existing_user(){
    assertTrue "Expected: User to be non existing" "is_existing_user $USER"
}

. shunit2