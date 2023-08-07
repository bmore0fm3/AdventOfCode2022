#!/usr/bin/env rexx
/*REXX
    fileWork
    Learning to use a class. Maybe even dependency injection since this is i/o. Harder to test these things. 
*/
  
/*trace i*/
rc = 0 
puzzleInputFile = 'puzzleInput.txt'



exit rc

/****************************************************************************
* Directives: Requires, Class, Methods, Attributes, requ& routine setup area*                             
*****************************************************************************/
::class FileActions public
::method verifyFile
    use arg inputFile 
     
    queryFile = .stream~new(inputFile)
    fullPath = reverse(queryFile~query("exists"))
    parse var fullPath fileName '/' . 
    fileName = reverse(fileName)

    return fileName


::method readFile
    use arg inputFile 

    /*create stream object. Then attempt to open for read only*/
    inputFile = .stream~new(inputFile)  
    if inputFile~open(read) != 'READY:' then 
        txtLines = ''
    else do     
        /*save stings in array object then close file*/
        txtLines = inputFile~arrayin
        inputFile~close
    end 

    return txtLines



