#!/usr/bin/env rexx
/*REXX
    test_Day04.rex
    Use the OORexxUnit test framework & Test Driven Development to help with puzzle. 

    https://adventofcode.com/2022/day/3


    Using TDD idea of Red -> Green -> Refactor 
    https://www.youtube.com/watch?v=llaUBH5oayw&list=PLwLLcwQlnXByqD3a13UPeT4SMhc3rdZ8q

*/

/*trace i*/

/*Test result object will be used to log all runs*/
aTr = .TestResult~new         

/*Create an instance and denote a test method to run*/
test1 =.TestDay04~new("shouldReturnTotalOfFullyEncompassedPairs") 

/*run the test code, supply a TestResult object*/
aTr = test1~execute(aTr)

/*Create an instance/instances (denoting the name of the test method to run) and run it. Supply the same test result object as before*/
.TestDay04~new("shouldReturnTotalOfAnyOverlap")~execute(aTr) 

/*runs the test case and returns the result. Fine for a single test
aTestResult=test1~execute*/

/*dump brief test results*/
call simpleDumpTestResults aTr, "test_Day04 Results"


/****************************************************************************
* Directives: Requires, Class, Methods, Attributes, requ& routine setup area*                             
*****************************************************************************/
::requires adventOfCodeDay4            /*get access to the Class*/
::requires fileWork                    /*get access to the Class*/
::requires ooRexxUnit.cls              /*get access to ooREXXUnit framework*/
::class TestDay04 subclass TestCase    /*a specialization of TestCase*/

::method shouldReturnTotalOfFullyEncompassedPairs
    checkList = .Day04~new
    listArray = .array~of('22-65,22-66')
    self~assertEquals(1, checkList~isFullyEncompassed(listArray, 'Full'))

::method shouldReturnTotalOfAnyOverlap
    checkList = .Day04~new
    listArray = .array~of('5-7,7-9', '2-8,3-7', '6-6,4-6', '2-6,4-8')
    self~assertEquals(4, checkList~isFullyEncompassed(listArray, 'Any'))
