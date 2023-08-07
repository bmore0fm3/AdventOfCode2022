#!/usr/bin/env rexx
/*REXX
    test_fileWork.rex
    Use the OORexxUnit test framework & Test Driven Development to help with puzzle. 

    1. Determine what the rock, paper scissors score would be according to the strategy guide the other elf gave you. 

    Using TDD idea of Red -> Green -> Refactor 
    https://www.youtube.com/watch?v=llaUBH5oayw&list=PLwLLcwQlnXByqD3a13UPeT4SMhc3rdZ8q

*/

/*trace i*/

/*Test result object will be used to log all runs*/
aTr = .TestResult~new         

/*Create an instance and denote a test method to run*/
test1 =.TestFileWork~new("shouldReturnPathOfFile") 

/*run the test code, supply a TestResult object*/
aTr = test1~execute(aTr)

/*Create an instance/instances (denoting the name of the test method to run) and run it.Supply the same test result object as before*/
.TestFileWork~new("shouldOpenTheFileAndReturnAnArray")~execute(aTr)

/*runs the test case and returns the result. Fine for a single test
aTestResult=test1~execute*/


/*dump brief test results*/
call simpleDumpTestResults aTr, "test_fileWork Results"


/****************************************************************************
* Directives: Requires, Class, Methods, Attributes, requ& routine setup area*                             
*****************************************************************************/     
::requires fileWork                    /*get access to the Class*/
::requires ooRexxUnit.cls              /*get access to ooREXXUnit framework*/
::class TestFileWork subclass TestCase /* a specialization of TestCase*/


::method shouldReturnPathOfFile           
    checkFile = .FileActions~new
    self~assertEquals('puzzleInput.txt', checkFile~verifyFile('puzzleInput.txt'))           
    /*self~assertEquals("test: 3 = (1 + 2)", 3, 1 + 2) supply a failure message*/

::method shouldOpenTheFileAndReturnAnArray
    openFile = .FileActions~new
    genericArray = .array~new()
    self~assertEquals(genericArray~isA(.array), openFile~readFile('puzzleInput.txt')~isA(.array))
