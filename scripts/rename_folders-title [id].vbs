strInputFile = "titles.txt"


Function ReadTextFile(strInputFile)
'Read contents of text file and return array with one element for each line.
  Const FOR_READING = 1
  Set fso = CreateObject("Scripting.FileSystemObject")
  If Not fso.FileExists(strInputFile) Then
    WScript.Echo strInputFile & " not found!  Make sure you place it in THIS folder!!!"
    WScript.Quit(1)
  End If
  Set objTextStream = fso.OpenTextFile(strInputFile, FOR_READING, False, -2)
  If objTextStream.AtEndOfStream Then
    WScript.Echo "Input text file " & strInputFile & " is empty."
    WScript.Quit(2)
  End If
  arrLines = Split(objTextStream.ReadAll, vbCrLf)
  objTextStream.Close
  Set fso = nothing
  ReadTextFile = arrLines
End Function

Function ReadTextFileU8(strInputFile)
  Set fso = CreateObject("Scripting.FileSystemObject")
  If Not fso.FileExists(strInputFile) Then
    WScript.Echo strInputFile & " not found!  Make sure you place it in THIS folder!!!"
    WScript.Quit(1)
  End If
  Set fso = nothing
  Set oStream = CreateObject("ADODB.Stream")
    oStream.Open
    oStream.Type = 2  'Set type to text
    oStream.CharSet = "utf-8"
    oStream.LoadFromFile("titles.txt")
    s = oStream.ReadText
    oStream.Close
  Set oStream = nothing  
  arrLines = Split(s, vbCrLf)
  ReadTextFileU8 = arrLines
End Function

Function CleanFolderName(strTitle)
  Set regEx = New RegExp
  regEx.IgnoreCase = True
  regEx.Global     = True
  'regEx.Pattern    =  "[&]"
  'strTitle = regEx.Replace(strTitle,"and")
  regEx.Pattern    =  "[/\\:]"
  strTitle = regEx.Replace(strTitle,"-")
  regEx.Pattern    =  "[*?""<>|]"
  CleanFolderName = regEx.Replace(strTitle," ")
End Function

Function renameTitle(arrTitles, folder)
  renamed = false
  Set fso = CreateObject("Scripting.FileSystemObject")
  For Each strTitle in arrTitles
    If (len(strTitle) > 6) Then
		If (left(strTitle,6) = left(folder.name,6)) Then
			'WScript.Echo "Raw: " & strTitle
			'WScript.Echo "folder.Path: " & folder.Path
			strCleaned = CleanFolderName(strTitle)
			'WScript.Echo "Cleaned: " & strCleaned
			newFolder = folder.ParentFolder & "\" & mid(strCleaned, 10, len(strCleaned)) & " [" & left(folder.name,6) & "]"
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

WScript.Echo "This can take some time to run so be patient and wait for the Done message!"
arrTitles = ReadTextFileU8(strInputFile)
count = 0
Set fso = CreateObject("Scripting.FileSystemObject")
Set titles = fso.GetFile(strInputFile)
strParentFolder = titles.ParentFolder
Set f = fso.GetFolder(strParentFolder)
Set sf = f.SubFolders
For Each folder in sf
  if (len(folder.name) >= 6) Then
    if (renameTitle (arrTitles, folder)) Then
	  count = count + 1
	End If
  End If
Next
Set fso = nothing
WScript.Echo "Done!  Renamed " & count & " folders."
