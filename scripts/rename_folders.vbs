strInputFile = "titles.txt"


Function ReadTextFile(strInputFile)
'Read contents of text file and return array with one element for each line.
  Const FOR_READING = 1
  Set fso = CreateObject("Scripting.FileSystemObject")
  If Not fso.FileExists(strInputFile) Then
    WScript.Echo strInputFile & " not found!  Make sure you place it in THIS folder!!!"
    WScript.Quit(1)
  End If
  Set objTextStream = fso.OpenTextFile(strInputFile, FOR_READING)
  If objTextStream.AtEndOfStream Then
    WScript.Echo "Input text file " & strInputFile & " is empty."
    WScript.Quit(2)
  End If
  arrLines = Split(objTextStream.ReadAll, vbCrLf)
  objTextStream.Close
  Set fso = nothing
  ReadTextFile = arrLines
End Function

Function CleanFolderName(strTitle)
  Set regEx = New RegExp
  regEx.IgnoreCase = True
  regEx.Global     = True
  regEx.Pattern    =  "[/\\:*?""<>|#{}%&~]"  
  CleanFolderName = regEx.Replace(strTitle,"")
End Function

Function renameTitle(arrTitles, folder)
  renamed = false
  Set fso = CreateObject("Scripting.FileSystemObject")
  For Each strTitle in arrTitles
    If (len(strTitle) > 6) Then
		strCleaned = CleanFolderName(strTitle)
		If (left(strCleaned,6) = left(folder.name,6)) Then
			'WScript.Echo strCleaned
			newFolder = folder.ParentFolder & "\" & left(folder.name,6) & "_" & mid(strCleaned, 10, len(strCleaned))
			'WScript.Echo newFolder
			Call fso.MoveFolder(folder.Path, newFolder)
			renamed = true
			Exit For
		End If
	End If
  Next
  Set fso = nothing
  renameTitle = renamed
End Function


'################################################

arrTitles = ReadTextFile(strInputFile)
count = 0
Set fso = CreateObject("Scripting.FileSystemObject")
Set titles = fso.GetFile(strInputFile)
strParentFolder = titles.ParentFolder
Set f = fso.GetFolder(strParentFolder)
Set sf = f.SubFolders
For Each folder in sf
  if (len(folder.name) > 6) Then
    if (renameTitle (arrTitles, folder)) Then
	  count = count + 1
	End If
  End If
Next
Set fso = nothing
WScript.Echo "Done!  Renamed " & count & " folders."
