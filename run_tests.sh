#!/usr/bin/env bash

TOTAL=0
SUCCESS=0
SKIPPED=0
FAILED=0

TEMP_FILE='/tmp/run_tests.log'

__total_from_expression()
{
    total=0
    for v in $(eval $1)
    do
        total=$(expr $total + $v)
    done 
    return $total
}

run_tests(){
    for test_file in $(find tests/linux/ -name "*.sh")
    do
        echo "========================="
        echo "### `basename $test_file`" 
        echo "========================="
        ./$test_file | tee -a $TEMP_FILE
    done
}

summary(){
    __total_from_expression "grep -i ran $TEMP_FILE  | awk -F' ' '{print \$2}'"
    TOTAL=$?

    __total_from_expression "grep -i skipped $TEMP_FILE | awk -F'=' '{print \$2}' |awk -F')' '{print \$1}'"
    SKIPPED=$?

    __total_from_expression "grep -i fail $TEMP_FILE | awk -F'=' '{print \$2}' |awk -F')' '{print \$1}'"
    FAILED=$?

    SUCCESS=$(expr $TOTAL - $SKIPPED - $FAILED)

    echo ""
    echo "======================"
    echo "Summary"
    echo "======================"
    echo "SUCCESS: | $SUCCESS"  
    echo "SKIPPED: | $SKIPPED"
    echo "FAILED:  | $FAILED"
    echo "======================"    
    echo "TOTAL:   | $TOTAL"
    echo "======================"

    rm -f $TEMP_FILE  
}

main(){
    run_tests
    summary
    
    exit $FAILED
}

main
