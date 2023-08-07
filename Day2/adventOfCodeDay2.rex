#!/usr/bin/env rexx
/*REXX
    adventOfCodeDay02
    1. Determine what the rock, paper scissors score would be according to the strategy guide the other elf gave you. 
*/
  


rc = 0 
totalIncompleteScore = 0
totalCompleteScore = 0
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


/*Construct Day02 object*/
calculateScore = .Day02~new

/*loop through strings to calculate total score*/
loop i over txtLines
    parse var i opponentShapeCode heroShapeCode
    opponentShape = calculateScore~getShape(opponentShapeCode)
    heroShape = calculateScore~getShape(heroShapeCode)
    shapeScore = calculateScore~getShapeScore(heroShape)
    heroStatus = calculateScore~shootRPS(opponentShape, heroShape)
    rpsOutcomeScore = calculateScore~roundOutcomeScore(heroStatus)
    roundScore = calculateScore~totalRoundScore(shapeScore, rpsOutcomeScore, 1)
    totalIncompleteScore = totalIncompleteScore + roundScore

    heroAction = calculateScore~actionToTake(heroShapeCode)
    heroNewShape = calculateScore~changeShape(heroAction, opponentShape)
    newShapeScore = calculateScore~getShapeScore(heroNewShape)
    newHeroStatus = calculateScore~shootRPS(opponentShape, heroNewShape)
    newRpsOutcomeScore = calculateScore~roundOutcomeScore(newHeroStatus)
    newRoundScore = calculateScore~totalRoundScore(newShapeScore, newRpsOutcomeScore, 1)
    totalCompleteScore = totalCompleteScore + newRoundScore

    /*Print out messages for every round
    say time() this_ 'Opponent shape is:' opponentShape 
    say time() this_ 'Hero shape is:' heroShape 
    say time() this_ 'Hero shape score is:' shapeScore
    say time() this_ 'Hero win/loss status is:' heroStatus
    say time() this_ 'Hero rock, paper, scissors score for the round is:' rpsOutcomeScore
    say time() this_ 'Hero rock, paper, scissors score + shape score for the round is:' roundScore 
    say time() this_ 'Hero action to take is:' heroAction 
    say time() this_ 'Hero new shape to 'heroAction' is:' heroNewShape
    leave
    */
end

say time() this_ 'Total combined score with incomplete strategy guide is:' totalIncompleteScore 
say time() this_ 'Total combined score with complete strategy guide is:' totalCompleteScore


exit rc 

/****************************************************************************
* Directives: Requires, Class, Methods, Attributes, requ& routine setup area*                             
*****************************************************************************/
::requires filework
::class Day02 public
::method getShape 
    use arg shapeCode

    /*Create stem with all shapes*/
    hero.A = 'Rock'
    hero.B = 'Paper'
    hero.C = 'Scissors'
    hero.X = 'Rock'
    hero.Y = 'Paper'
    hero.Z = 'Scissors'

    /*loop txtLine over totalLines*/ 

    heroShape = hero.shapeCode

    return heroShape

::method getshapeScore 
    use arg shape 

    select 
        when shape == 'Rock' then 
            score = 1 
        when shape == 'Paper' then 
            score = 2 
        when shape == 'Scissors' then 
            score = 3 
        otherwise 
            score = 'invalid'
    end
    
    return score 

::method shootRPS
    use arg opponent, hero  

    select 
        /*Hero Win Section*/
        when hero == 'Rock' & opponent == 'Scissors' then 
            status = 'Win'
        when hero == 'Paper' & opponent == 'Rock' then 
            status = 'Win'
        when hero == 'Scissors' & opponent == 'Paper' then 
            status = 'Win'

        /*Hero Lose section*/
         when hero == 'Rock' & opponent == 'Paper' then 
            status = 'Loss'
         when hero == 'Paper' & opponent == 'Scissors' then 
            status = 'Loss'
         when hero == 'Scissors' & opponent == 'Rock' then 
            status = 'Loss'

        /*Hero Draw Section*/
        otherwise 
            status = 'Draw'
    end
    
    return status

::method roundOutcomeScore
    use arg roundStatus 

    select 
        when roundStatus == 'Win' then 
            roundScore = 6
        when roundStatus == 'Loss' then 
            roundScore = 0
        when roundStatus == 'Draw' then 
            roundScore = 3
        otherwise 
            roundScore = 'Invalid'
    end
    
    return roundScore

::method totalRoundScore
    use arg shapeScore, roundOutcomeScore, numberOfRounds

    /*totalScore = .array~new()*/
    totalScore = 0

    do i = 1 to numberOfRounds
        roundScore = shapeScore + roundOutcomeScore
        totalScore = totalScore + roundScore
    end i 

    return totalScore

::method actionToTake
    use arg actionCode

    select
        when actionCode == 'X' then
            action = 'Lose' 
        when actionCode == 'Y' then
            action = 'Draw' 
        when actionCode == 'Z' then
            action = 'Win' 
    end 

    return action

::method changeShape
    use arg actionToTake, opponentShape

    select
        /*Logic to win*/
        when actionToTake == 'Win' then do 
            if opponentShape == 'Rock' then 
                newHeroShape = 'Paper' 
            else if opponentShape == 'Paper' then 
                newHeroShape = 'Scissors'
            else if opponentShape == 'Scissors' then 
                newHeroShape = 'Rock'
            else 
                newHeroShape = 'Invalid'
        end

        /*logic to lose*/
        when actionToTake == 'Lose' then do 
            if opponentShape == 'Rock' then 
                newHeroShape = 'Scissors' 
            else if opponentShape == 'Paper' then 
                newHeroShape = 'Rock'
            else if opponentShape == 'Scissors' then 
                newHeroShape = 'Paper'
            else 
                newHeroShape = 'Invalid'
        end 

        /*logic to draw*/
        when actionToTake == 'Draw' then
                newHeroShape = opponentShape
    end 

    return newHeroShape


