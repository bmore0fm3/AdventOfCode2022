#!/usr/bin/env rexx
/*REXX
    test_Day02.rex
    Use the OORexxUnit test framework & Test Driven Development to help with puzzle. 

    1. Determine what the rock, paper scissors score would be according to the strategy guide the other elf gave you. 

    Using TDD idea of Red -> Green -> Refactor 
    https://www.youtube.com/watch?v=llaUBH5oayw&list=PLwLLcwQlnXByqD3a13UPeT4SMhc3rdZ8q

*/

/*trace i*/

/*Test result object will be used to log all runs*/
aTr = .TestResult~new         

/*Create an instance and denote a test method to run*/
test1 =.TestDay02~new("shouldReturnRockShapeForA") 

/*run the test code, supply a TestResult object*/
aTr = test1~execute(aTr)

/*Create an instance/instances (denoting the name of the test method to run) and run it.Supply the same test result object as before*/
.TestDay02~new("shouldReturnPaperShapeForB")~execute(aTr) 
.TestDay02~new("shouldReturnScissorsShapeForC")~execute(aTr)  
.TestDay02~new("shouldReturnRockShapeForX")~execute(aTr)  
.TestDay02~new("shouldReturnPaperShapeForY")~execute(aTr)  
.TestDay02~new("shouldReturnScissorsShapeForZ")~execute(aTr)  
.TestDay02~new("shouldReturnScoreForRock")~execute(aTr)
.TestDay02~new("shouldReturnScoreForPaper")~execute(aTr)
.TestDay02~new("shouldReturnScoreForScissors")~execute(aTr)
.TestDay02~new("shouldReturnHeroWinWithRock")~execute(aTr)
.TestDay02~new("shouldReturnHeroWinWithPaper")~execute(aTr)
.TestDay02~new("shouldReturnHeroWinWithScissors")~execute(aTr)
.TestDay02~new("shouldReturnHeroLossWithRock")~execute(aTr)
.TestDay02~new("shouldReturnHeroLossWithScissors")~execute(aTr)
.TestDay02~new("shouldReturnHeroDraw")~execute(aTr)
.TestDay02~new("shouldReturnRoundOutcomeWinScore")~execute(aTr)
.TestDay02~new("shouldReturnRoundOutcomeLossScore")~execute(aTr)
.TestDay02~new("shouldReturnRoundOutcomeDrawScore")~execute(aTr)
.TestDay02~new("shouldReturnRoundOutcomeInvalidScore")~execute(aTr)
.TestDay02~new("shouldReturnTotalRoundScore7")~execute(aTr)
.TestDay02~new("shouldReturnTotalScoreForOneRound")~execute(aTr)
.TestDay02~new("shouldReturnTotalScoreForTwoRounds")~execute(aTr)

/*runs the test case and returns the result. Fine for a single test
aTestResult=test1~execute*/


/*dump brief test results*/
call simpleDumpTestResults aTr, "test_Day02 Results"


/****************************************************************************
* Directives: Requires, Class, Methods, Attributes, requ& routine setup area*                             
*****************************************************************************/
::requires adventOfCodeDay2            /*get access to the Class*/
::requires ooRexxUnit.cls              /*get access to ooREXXUnit framework*/
::class TestDay02 subclass TestCase    /*a specialization of TestCase*/

::method shouldReturnRockShapeForA
    inputFileStrings = .stream~new('puzzleInput.txt')
    txtLines = inputFileStrings~arrayin
    inputFileStrings~close
    selectedShape = .Day02~new
    self~assertEquals('Rock', selectedShape~getShape('A'))

::method shouldReturnPaperShapeForB
    selectedShape = .Day02~new
    self~assertEquals('Paper', selectedShape~getShape('B'))

::method shouldReturnScissorsShapeForC
    selectedShape = .Day02~new
    self~assertEquals('Scissors', selectedShape~getShape('C'))

::method shouldReturnRockShapeForX
    selectedShape = .Day02~new
    self~assertEquals('Rock', selectedShape~getShape('X'))

::method shouldReturnPaperShapeForY
    selectedShape = .Day02~new
    self~assertEquals('Paper', selectedShape~getShape('Y'))

::method shouldReturnScissorsShapeForZ
    selectedShape = .Day02~new
    self~assertEquals('Scissors', selectedShape~getShape('Z'))

::method shouldReturnScoreForRock 
    selectedShape = .Day02~new 
    self~assertEquals('1', selectedShape~getshapeScore('Rock'))

::method shouldReturnScoreForPaper 
    selectedShape = .Day02~new 
    self~assertEquals('2', selectedShape~getshapeScore('Paper'))

::method shouldReturnScoreForScissors
    selectedShape = .Day02~new 
    self~assertEquals('3', selectedShape~getshapeScore('Scissors'))

::method shouldReturnHeroWinWithRock
    roundWinner = .Day02~new 
    opponent = 'Scissors'
    hero = 'Rock'
    self~assertEquals('Win', roundWinner~shootRPS(opponent, hero))

::method shouldReturnHeroWinWithPaper
    roundWinner = .Day02~new 
    opponent = 'Rock'
    hero = 'Paper'
    self~assertEquals('Win', roundWinner~shootRPS(opponent, hero))

::method shouldReturnHeroWinWithScissors
    roundWinner = .Day02~new 
    opponent = 'Paper'
    hero = 'Scissors'
    self~assertEquals('Win', roundWinner~shootRPS(opponent, hero))

::method shouldReturnHeroLossWithRock
    roundLoser = .Day02~new 
    opponent = 'Paper'
    hero = 'Rock'
    self~assertEquals('Loss', roundLoser~shootRPS(opponent, hero))

::method shouldReturnHeroLossWithPaper
    roundLoser = .Day02~new 
    opponent = 'Scissors'
    hero = 'Paper'
    self~assertEquals('Loss', roundLoser~shootRPS(opponent, hero))

::method shouldReturnHeroLossWithScissors
    roundLoser = .Day02~new 
    opponent = 'Rock'
    hero = 'Scissors'
    self~assertEquals('Loss', roundLoser~shootRPS(opponent, hero))

::method shouldReturnHeroDraw
    roundDraw = .Day02~new 
    opponent = 'Rock'
    hero = 'Rock'
    self~assertEquals('Draw', roundDraw~shootRPS(opponent, hero))

::method shouldReturnRoundOutcomeWinScore
    roundWin = .Day02~new 
    self~assertEquals('6', roundWin~roundOutcomeScore('Win'))

::method shouldReturnRoundOutcomeLossScore
    roundLoss = .Day02~new 
    self~assertEquals('0', roundLoss~roundOutcomeScore('Loss'))
::method shouldReturnRoundOutcomeDrawScore
    roundDraw = .Day02~new 
    self~assertEquals('3', roundDraw~roundOutcomeScore('Draw'))
::method shouldReturnRoundOutcomeInvalidScore
    roundError = .Day02~new 
    self~assertEquals('Invalid', roundError~roundOutcomeScore('Apple'))

::method shouldReturnTotalRoundScore7
    getScore = .Day02~new 
    self~assertEquals(7, getScore~totalRoundScore(getScore~getshapeScore('Rock'), getScore~roundOutcomeScore('Win'), 1))

::method shouldReturnTotalScoreForOneRound
    getTotalScore = .Day02~new 
    self~assertEquals(9, getTotalScore~totalRoundScore(getTotalScore~getshapeScore('Scissors'), getTotalScore~roundOutcomeScore('Win'), 1))

::method shouldReturnTotalScoreForTwoRounds
    getTotalScore = .Day02~new 
    self~assertEquals(18, getTotalScore~totalRoundScore(getTotalScore~getshapeScore('Scissors'), getTotalScore~roundOutcomeScore('Win'), 2))