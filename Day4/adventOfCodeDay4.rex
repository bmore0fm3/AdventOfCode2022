#!/usr/bin/env rexx

/*REXX
    adventOfCodeDay4
    https://adventofcode.com/2022/day/4

    1. In how many assignment pairs does one range fully contain the other?
    2. 
*/
  

rc = 0 
puzzleInputFile = 'puzzleInput.txt'


/*Get this program's name*/
parse source system invocation fullProgramPath
fullProgramPath = reverse(fullProgramPath)
parse var fullProgramPath 'xer.' this_ '/' .
this_ = reverse(this_) 

/*verify file then read it into an array*/
inputFile = .FileActions~new
if inputFile~verifyFile(puzzleInputFile) == "" then do
    rc = 8
    say time() this_ rc 'Unable to verify that file' puzzleInputFile 'exists'
    exit rc
end
else 
    textLines = inputFile~readFile(puzzleInputFile)

/*Construct object*/
 campCleanUp = .Day04~new



say time() this_ 'Total number of fully encompassed pairs:' campCleanUp~isFullyEncompassed(textLines)

exit rc

/****************************************************************************
* Directives: Requires, Class, Methods, Attributes, requ& routine setup area*                             
*****************************************************************************/
::requires fileWork
::class Day04 public
::method isFullyEncompassed
    use arg listArray 

    totalFullyEncompassed = 0

    loop idPair over listArray
        /*separate pairs and separate upper and lower values*/
        parse var idPair id1 ',' id2 .
        parse var id1 lowerID1 '-' upperId1 .
        parse var id2 lowerID2 '-' upperId2 .


        /*compare lower values*/
        select 
            /*check as if reading from left to right*/
            when lowerID1 >= lowerID2 &,
                 upperID1 <= upperID2 then do
                say time() "Item pair " listArray~index(idPair) 'is fully encompassed'
                totalFullyEncompassed = totalFullyEncompassed + 1
            end 

            /*Check if reading from right to left*/
            when lowerID2 >= lowerID1 &,
                 upperID2 <= upperID1 then do
                say time() "Item pair " listArray~index(idPair) 'is fully encompassed'
                totalFullyEncompassed = totalFullyEncompassed + 1
            end 

            otherwise iterate 
        end 

    end

    return totalFullyEncompassed