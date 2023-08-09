#!/usr/bin/env rexx

/*REXX
    adventOfCodeDay3
    https://adventofcode.com/2022/day/3

    1. Find the item type that appears in both compartments of each rucksack. 
       What is the sum of the priorities of those item types? 
    2.  
*/
  

rc = 0 
prioritySum = 0
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
    txtLines = inputFile~readFile(puzzleInputFile)

/*Construct object*/
calculatePrioritySum = .Day03~new

/*loop through strings to calculate priority*/
loop i over txtLines
    compartmentsArray = calculatePrioritySum~getCompartments(i)
    commonItem = calculatePrioritySum~getItem(compartmentsArray)
    itemPriority = calculatePrioritySum~getItemPriority(commonItem)
    prioritySum = prioritySum + itemPriority

    /*Print out messages for every round
    say time() this_ 'Compartments in array:' compartmentsArray~allItems
    say time() this_ 'The common item is:' commonItem
    say time() this_ 'The item priority for' commonItem 'is:' itemPriority 
    leave
    */
end

say time() this_ 'Sum of priority items pull from ruck sacks is:' prioritySum

exit rc

/****************************************************************************
* Directives: Requires, Class, Methods, Attributes, requ& routine setup area*                             
*****************************************************************************/
::requires fileWork
::class Day03 public
::method getCompartments
    use arg ruckSack

    compartments = .array~new()

    /*get length of rucksack*/
    ruckSackLength = ruckSack~length

    /*split rucksack into two compartments*/
    compartment1 = ruckSack~substr(1, (ruckSackLength/2))
    compartment2 = ruckSack~substr(((ruckSackLength/2) + 1), ruckSackLength)
    /*say compartment1*/
    /*say compartment2*/

    /*append compartments to compartments array*/
    compartments~append(compartment1)
    compartments~append(compartment2)
    /*say compartments~allitems*/

    return compartments

::method getItem
    use arg compartments

    /*say compartments~allitems */
    
    /*use verify to get the position of matching item then use subchar to grab item*/
    positionOfItem = compartments[1]~verify(compartments[2], 'M')
    commonItem =  compartments[1]~subchar(positionOfItem)
    /*say commonItem*/

  return commonItem

  ::method getItemPriority
    use arg commonItem

    priorityList ='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' 

    return priorityList~pos(commonItem)