#!/usr/bin/env rexx

/*REXX
    adventOfCodeDay3
    https://adventofcode.com/2022/day/3

    1. Find the item type that appears in both compartments of each rucksack. 
       What is the sum of the priorities of those item types? 
    2. Find the item type that corresponds to the badges of each three-Elf group. 
        What is the sum of the priorities of those item types?
*/
  

rc = 0 
prioritySum = 0
elvesPrioritySum = 0
badgeSum = 0
puzzleInputFile = 'puzzleInput.txt'
elfArray = .array~new()


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
calculatePrioritySum = .Day03~new

/*loop through strings to calculate priority*/
loop i over textLines
    compartmentsArray = calculatePrioritySum~getCompartments(i)
    commonItem = calculatePrioritySum~getItem(compartmentsArray, 'Y')
    itemPriority = calculatePrioritySum~getItemPriority(commonItem)
    prioritySum = prioritySum + itemPriority

    /*Add ruck to bag unless we have three. If 3 rucks then find the priority of badge, then badgeSum*/
    if (textlines~index(i) // 3) > 0 then
        elfArray~append(i)

    else do
        elfArray~append(i)
        elvesCommonItem = calculatePrioritySum~getItem(elfArray, 'N')
        elvesItemPriority = calculatePrioritySum~getItemPriority(elvesCommonItem)
        elvesPrioritySum = elvesPrioritySum + elvesItemPriority
        elfArray~empty
    end



    /*Print out messages for every round
    say time() this_ 'Compartments in array:' compartmentsArray~allItems
    say time() this_ 'The common item is:' commonItem
    say time() this_ 'The item priority for' commonItem 'is:' itemPriority 
    leave
    */
end

say time() this_ 'Sum of priority items pull from ruck sacks is:' prioritySum
say time() this_ 'Sum of priority items pull from ruck sacks is:' elvesPrioritySum

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
    use arg ruckArray, compartments
    
    if compartments == 'Y' then do
        /*use verify to get the position of matching item then use subchar to grab item*/
        positionOfItem = ruckArray[1]~verify(ruckArray[2], 'M')
        commonItem =  ruckArray[1]~subchar(positionOfItem)
        /*say commonItem*/
    end
    else do
        /*loop through each char of the first array to check the others for the character*/
        do i = 1 to ruckArray[1]~length
            /*Char not in array two? Then move to next character*/
            if pos(ruckArray[1]~subchar(i), ruckArray[2]) == 0 then
                iterate

            /*Character in array 1 matches a char in array 2. Let's check array 3*/
            else do
                /*Move to next char in array 1 if we can't find char in array 3*/
                if pos(ruckArray[1]~subchar(i), ruckArray[3]) == 0 then
                    iterate
                else 
                    commonItem = ruckArray[1]~subchar(i)
                    leave
            end

        end
    end 

  return commonItem

  ::method getItemPriority
    use arg commonItem

    priorityList ='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' 

    return priorityList~pos(commonItem)
