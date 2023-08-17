#!/usr/bin/env rexx
/*REXX
    test_Day03.rex
    Use the OORexxUnit test framework & Test Driven Development to help with puzzle. 

    https://adventofcode.com/2022/day/3

    1. Find the item type that appears in both compartments of each rucksack. 
       What is the sum of the priorities of those item types? 
    2. Find the item type that corresponds to the badges of each three-Elf group. 
        What is the sum of the priorities of those item types?

    Using TDD idea of Red -> Green -> Refactor 
    https://www.youtube.com/watch?v=llaUBH5oayw&list=PLwLLcwQlnXByqD3a13UPeT4SMhc3rdZ8q

*/

/*trace i*/

/*Test result object will be used to log all runs*/
aTr = .TestResult~new         

/*Create an instance and denote a test method to run*/
test1 =.TestDay03~new("shouldReturnArrayWith2Compartments") 

/*run the test code, supply a TestResult object*/
aTr = test1~execute(aTr)

/*Create an instance/instances (denoting the name of the test method to run) and run it. Supply the same test result object as before*/
.TestDay03~new("shouldReturnACommonItemThatsInBothCompartments")~execute(aTr) 
.TestDay03~new("shouldReturnPriorityOfItemForLowerCase")~execute(aTr) 
.TestDay03~new("shouldReturnPriorityOfItemForUpperCase")~execute(aTr) 
.TestDay03~new("shouldReturnNewItemInArray")~execute(aTr) 
.TestDay03~new("shouldReturnCommonBadgeItemFrom3Elves")~execute(aTr) 


/*runs the test case and returns the result. Fine for a single test
aTestResult=test1~execute*/


/*dump brief test results*/
call simpleDumpTestResults aTr, "test_Day03 Results"


/****************************************************************************
* Directives: Requires, Class, Methods, Attributes, requ& routine setup area*                             
*****************************************************************************/
::requires adventOfCodeDay3            /*get access to the Class*/
::requires fileWork                    /*get access to the Class*/
::requires ooRexxUnit.cls              /*get access to ooREXXUnit framework*/
::class TestDay03 subclass TestCase    /*a specialization of TestCase*/

::method shouldReturnArrayWith2Compartments
    compartment = .Day03~new
    genericArray = .array~new()
    self~assertEquals(genericArray~isA(.array), compartment~getCompartments('qwertyuiot')~isA(.array))

::method shouldReturnACommonItemThatsInBothCompartments
    commonItem = .Day03~new
    genericArray = .array~of('qwert', 'tuioy', 'anvtd')
    self~assertEquals('t', commonItem~getItem(genericArray, 'Y'))

::method shouldReturnPriorityOfItemForLowerCase
    commonItem = .Day03~new
    self~assertEquals(20, commonItem~getItemPriority('t'))

::method shouldReturnPriorityOfItemForUpperCase
    commonItem = .Day03~new
    self~assertEquals(49, commonItem~getItemPriority('W'))

::method shouldReturnNewItemInArray
    elfArray = .array~of("newElf")
    self~assertEquals('newElf', elfArray[1])

::method shouldReturnCommonBadgeItemFrom3Elves
    commonItem = .Day03~new
    elfArray = .array~new()
    elfArray~append('LhfjhcdjcGdhFfdGfdjdvwCCZMvvLvWwMLCLSwZC')
    elfArray~append('rDnsbmptPmlbQMCrQWQQBZQW')
    elfArray~append('gltgVPngDPbptPsbPzVgmDldfTdfczThjJJjfMcJdFHjjH')

    self~assertEquals('M',commonItem~getItem(elfArray, 'N'))
