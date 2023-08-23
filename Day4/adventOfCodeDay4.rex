#!/usr/bin/env rexx

/*REXX
    adventOfCodeDay4
    https://adventofcode.com/2022/day/4

    1. In how many assignment pairs does one range fully contain the other?
    2. In how many assignment pairs is there ANY overlap?
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

say time() this_ 'Total number of fully encompassed pairs:' campCleanUp~isFullyEncompassed(textLines, 'Full')
say
say time() this_ 'Total number pairs with ANY overlap:' campCleanUp~isFullyEncompassed(textLines, 'Any')

exit rc

/****************************************************************************
* Directives: Requires, Class, Methods, Attributes, requ& routine setup area*                             
*****************************************************************************/
::requires fileWork
::class Day04 public
::method isFullyEncompassed
    use arg listArray, checktype

    totalFullyEncompassed = 0
    hasOverlap = 0
    list1 = .array~new()
    list2 = .array~new()


    loop idPair over listArray
        /*separate pairs and separate upper and lower values*/
        parse var idPair id1 ',' id2 .
        parse var id1 lowerID1 '-' upperId1 .
        parse var id2 lowerID2 '-' upperId2 .


        /*compare lower values*/
        select 
            /*check as if reading from left to right for total overalp*/
            when lowerID1 >= lowerID2 &,
                 upperID1 <= upperID2 &, 
                 checkType = 'Full' then do
                say time() "Item pair " listArray~index(idPair) "is fully encompassed"
                totalFullyEncompassed = totalFullyEncompassed + 1
            end 

            /*Check if reading from right to left for total overlap*/
            when lowerID2 >= lowerID1 &,
                 upperID2 <= upperID1 &,
                 checkType = 'Full' then do
                say time() "Item pair " listArray~index(idPair) "is fully encompassed"
                totalFullyEncompassed = totalFullyEncompassed + 1
            end 

            /*check as if reading from left to right for Any overlap*/
            when checkType = 'Any' then do
                list1~empty()
                list2~empty()
               
                
                /*separate lower and higher values of section assignment*/
                do i = lowerID1 to upperId1 
                    list1~append(i)
                end i 

                /*separate lower and higher values of section assignment*/
                do j = lowerID2 to upperId2 
                    list2~append(j)
                end j

                /*See what numbers overlap*/
                listItems = list1~intersection(list2)
                if listItems~items > 0 then do
                    hasOverlap = hasOverlap + 1
                    say time() "Item pair" listArray~index(idPair) "has overlap"
                end

            end 

            otherwise iterate 
        end 

    end

    /*organize return data*/
    if checktype = 'Full' then
        overlapResults = totalFullyEncompassed
    else if checktype = 'Any' then
        overlapResults = hasOverlap
    else 'Invalid'

    return overlapResults