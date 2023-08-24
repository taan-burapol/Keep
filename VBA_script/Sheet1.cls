VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "Sheet1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Private Sub Claim_button_Click()
    Dim Date_String As String
    Date_String = ThisWorkbook.ActiveSheet.Range("AB1").value
    Date_String = WorksheetFunction.text(Date_String, "dd-mmm-yyyy")
    ThisWorkbook.ActiveSheet.Range("A1").value = "Meeting Claim " & Date_String
    Run_main
End Sub

Private Sub Findall_Click()
    Dim Select_schedule As String
    Dim sourceFilePath As String
    Dim sourceWorkbook As Workbook
    Dim sourceWorksheet As Worksheet
    Dim i As Integer
    ThisWorkbook.ActiveSheet.Range("C9").value = ""
    For i = 1 To 4
        Select Case i
            Case 1
                ThisWorkbook.ActiveSheet.Range("AB7").value = "30"
            Case 2
                ThisWorkbook.ActiveSheet.Range("AB7").value = "50"
            Case 3
                ThisWorkbook.ActiveSheet.Range("AB7").value = "100"
            Case 4
                ThisWorkbook.ActiveSheet.Range("AB7").value = "130"
        End Select
        Run_get_balance
        If Not ThisWorkbook.ActiveSheet.Range("C9").value = "" Then
            Exit For
        End If
        ThisWorkbook.ActiveSheet.Range("AB7").value = ""
    Next i
End Sub

Private Sub Inform_button_Click()
    Dim Date_String As String
    Date_String = ThisWorkbook.ActiveSheet.Range("AB1").value
    Date_String = WorksheetFunction.text(Date_String, "dd-mmm-yyyy")
    ThisWorkbook.ActiveSheet.Range("A1").value = "Meeting Inform " & Date_String
    Run_main
End Sub

Private Sub Getbalance_Click()
    Run_get_balance
End Sub

Private Sub MasterListFile_Click()
    Dim filePath As String
    
    ' Create a FileDialog object as a File Picker dialog box.
    With Application.FileDialog(msoFileDialogFilePicker)
        .AllowMultiSelect = False
        .Title = "Select a Master list File"
        If .Show = -1 Then ' If the user clicks OK
            filePath = .SelectedItems(1) ' Get the selected file path
        End If
    End With
    
    ' Save the file path in cell C1 of the active worksheet
    ThisWorkbook.ActiveSheet.Range("AB2").value = filePath
End Sub

Private Sub moldLife_folder_Click()
    Dim folderPath As String
    Dim dialog As FileDialog
    
    ' Create a FileDialog object as a Folder Picker dialog
    Set dialog = Application.FileDialog(msoFileDialogFolderPicker)
    
    ' Display the dialog and get the selected folder path
    If dialog.Show = -1 Then
        folderPath = dialog.SelectedItems(1)
        
        ' Write the selected folder path to cell A1
        ThisWorkbook.ActiveSheet.Range("AB17").value = folderPath
    End If
    
    ' Release the dialog object
    Set dialog = Nothing
End Sub

Private Sub moldLife_run_Click()
    If Not ThisWorkbook.ActiveSheet.Range("C7").value = "" Then
        Dim folderPath As String
        Dim fileNameStart As String
        
        Dim sourceWorkbook As Workbook
        Dim sourceWorksheet As Worksheet
        
        Dim moldRange As Range
        Dim moldRow As Range
        
        Dim linesArray() As String
        Dim numberOfStrings As Integer
        
        fileNameStart = ThisWorkbook.ActiveSheet.Range("C3").value
        folderPath = ThisWorkbook.ActiveSheet.Range("AB17").value ' Change this to your folder path
        
        ThisWorkbook.ActiveSheet.Range("AE18").value = ""
        ThisWorkbook.ActiveSheet.Range("AE19").value = ""
        ThisWorkbook.ActiveSheet.Range("AE20").value = ""
        ThisWorkbook.ActiveSheet.Range("AE21").value = ""
        
        ThisWorkbook.ActiveSheet.Range("AB18").value = ""
        ThisWorkbook.ActiveSheet.Range("AB19").value = ""
        FindExcelFilesRecursive folderPath, fileNameStart
        If Not ThisWorkbook.ActiveSheet.Range("AB18").value = "" Then
            linesArray = Split(ThisWorkbook.ActiveSheet.Range("AB18").value, "|")
            
            numberOfStrings = UBound(linesArray)
            
            For j = 0 To numberOfStrings
                If Len(linesArray(j)) > 1 Then
                    ' Open the workbook
                    On Error Resume Next
                    ' Open the source workbook
                    Application.ScreenUpdating = False
                    Set sourceWorkbook = Workbooks.Open(Filename:=linesArray(j), UpdateLinks:=0, ReadOnly:=True)
                    On Error GoTo 0
                    
                    If sourceWorkbook Is Nothing Then
                        MsgBox "Workbook not found or unable to open."
                        Exit Sub
                    End If
                    
                    Set sourceWorksheet = sourceWorkbook.ActiveSheet
                    Set moldRange = sourceWorksheet.Range("A:A")
                    
                    Set moldRow = moldRange.Find(ThisWorkbook.ActiveSheet.Range("C7").value, LookIn:=xlValues, LookAt:=xlWhole)
                    
                    If Not moldRow Is Nothing Then
                        ThisWorkbook.ActiveSheet.Range("AE18").value = sourceWorksheet.Cells(moldRow.Row, "I").value
                        ThisWorkbook.ActiveSheet.Range("AE19").value = sourceWorksheet.Cells(moldRow.Row, "F").value
                        ThisWorkbook.ActiveSheet.Range("AE20").value = sourceWorksheet.Cells(moldRow.Row, "J")
                        ThisWorkbook.ActiveSheet.Range("AE21").value = "'" & CStr(sourceWorksheet.Range("C7")) & CStr(sourceWorksheet.Range("E7"))
                    End If
                    
                    ' Close the workbook
                    sourceWorkbook.Close SaveChanges:=False
                    Application.ScreenUpdating = True
                End If
            Next j
        Else
            linesArray = Split(ThisWorkbook.ActiveSheet.Range("AB19").value, "|")
            
            numberOfStrings = UBound(linesArray)
            
            For j = 0 To numberOfStrings
                If Len(linesArray(j)) > 1 Then
                    ' Open the workbook
                    On Error Resume Next
                    ' Open the source workbook
                    Application.ScreenUpdating = False
                    Set sourceWorkbook = Workbooks.Open(Filename:=linesArray(j), UpdateLinks:=0, ReadOnly:=True)
                    On Error GoTo 0
                    
                    If sourceWorkbook Is Nothing Then
                        MsgBox "Workbook not found or unable to open."
                        Exit Sub
                    End If
                    
                    For Each sourceWorksheet In sourceWorkbook.Sheets
                        If Left(sourceWorksheet.Name, Len(fileNameStart)) = fileNameStart Then
                            
                            Set moldRange = sourceWorksheet.Range("A:A")
                            
                            Set moldRow = moldRange.Find(ThisWorkbook.ActiveSheet.Range("C7").value, LookIn:=xlValues, LookAt:=xlWhole)
                            
                            If Not moldRow Is Nothing Then
                                ThisWorkbook.ActiveSheet.Range("AE18").value = sourceWorksheet.Cells(moldRow.Row, "I").value
                                ThisWorkbook.ActiveSheet.Range("AE19").value = sourceWorksheet.Cells(moldRow.Row, "F").value
                                ThisWorkbook.ActiveSheet.Range("AE20").value = sourceWorksheet.Cells(moldRow.Row, "J")
                                ThisWorkbook.ActiveSheet.Range("AE21").value = "'" & CStr(sourceWorksheet.Range("C7")) & CStr(sourceWorksheet.Range("E7"))
                                Exit For
                            End If
                        End If
                    Next sourceWorksheet
                    
                    ' Close the workbook
                    sourceWorkbook.Close SaveChanges:=False
                    Application.ScreenUpdating = True
                End If
            Next j
        End If
    Else
        MsgBox "Please enter Prod. Date and try again!"
    End If
End Sub

Sub FindExcelFilesRecursive(ByVal folderPath As String, ByVal fileNameStart As String)
    If ThisWorkbook.ActiveSheet.Range("AB18").value = "" Then
        Dim fso As Object
        Dim folder As Object
        Dim subfolder As Object
        Dim file As Object
        Dim ext As String
    
        Set fso = CreateObject("Scripting.FileSystemObject")
        Set folder = fso.GetFolder(folderPath)
        For Each file In folder.Files
            ext = fso.GetExtensionName(file.Path)
            If ext = "xlsx" Or ext = "xls" Then
                If InStr(1, LCase(CStr(file.Name)), fileNameStart, vbTextCompare) > 0 Then
                    ThisWorkbook.ActiveSheet.Range("AB18").value = ThisWorkbook.ActiveSheet.Range("AB18").value & file.Path & "|"
                    'Debug.Print "Found Excel file: " & fileNameStart & " " & file.Name
                End If
                If Left(file.Name, Len(folder.Name)) = folder.Name And Len(folder.Name) > 3 Then
                    ThisWorkbook.ActiveSheet.Range("AB19").value = ThisWorkbook.ActiveSheet.Range("AB19").value & file.Path & "|"
                    'Debug.Print folder.Name & "----"; file.Name & "----" & file.Path
                End If
                ' Do something with the file, such as processing it
            End If
        Next file
    
        For Each subfolder In folder.Subfolders
            FindExcelFilesRecursive subfolder.Path, fileNameStart
        Next subfolder
        
        Set fso = Nothing
        Set folder = Nothing
        Set subfolder = Nothing
        Set file = Nothing
    End If
End Sub

Private Sub Run_shipping_Click()
    ThisWorkbook.ActiveSheet.Range("AC16").value = ""
    Dim wb As Workbook
    Dim ws As Worksheet
    Dim maxNumber As Double
    Dim sheetNameWithMaxNumber As String
    Dim sheetName As String
    Dim extractedNumber As Double
    
    Application.ScreenUpdating = False
    ' Change the file path to your Excel file
    Set wb = Workbooks.Open(ThisWorkbook.ActiveSheet.Range("AB14").value)
    
    maxNumber = -1 ' Initialize to a low value
    
    For Each ws In wb.Sheets
        If ws.Visible = xlSheetVisible Then ' Check if sheet is visible
            sheetName = ws.Name
            ' Extract numbers from sheet name using regular expression
            extractedNumber = CDbl(Val(RegExpReplace(sheetName, "[^\d.]", "")))
            
            ' Check if extracted number is greater than current maxNumber
            If extractedNumber > maxNumber Then
                maxNumber = extractedNumber
                sheetNameWithMaxNumber = sheetName
            End If
        End If
    Next ws
    
    If sheetNameWithMaxNumber <> "" Then
        Dim targetRange As Range
        Dim foundCell As Range
        
        ThisWorkbook.ActiveSheet.Range("AC16").value = sheetNameWithMaxNumber
        'MsgBox "Visible sheet with greatest number: " & sheetNameWithMaxNumber
        
        Set ws = wb.Sheets(sheetNameWithMaxNumber)
        Set targetRange = ws.Range("A1:J10")
        
        Set foundCell = targetRange.Find("PART CODE", LookIn:=xlValues, LookAt:=xlWhole)
        
        If Not foundCell Is Nothing Then
            'MsgBox "Found 'PART CODE' at Row: " & foundCell.Row & ", Column: " & foundCell.Column
            
            Dim foundColumn As Range
            Set foundColumn = ws.Columns(foundCell.Column)
            Dim foundRow As Range
            Set foundRow = ws.Rows(foundCell.Row)
            
            Dim foundPartCode As Range
            Set foundPartCode = foundColumn.Find(ThisWorkbook.ActiveSheet.Range("C3").value, LookIn:=xlValues, LookAt:=xlWhole)
            
            If Not foundPartCode Is Nothing Then
                'MsgBox "Partial match for " & ThisWorkbook.ActiveSheet.Range("C3").value & " found at row " & foundPartCode.Row
                
                Dim foundDay As Range
                
                Dim i As Integer
                For i = 1 To CInt(ThisWorkbook.ActiveSheet.Range("AA16").value)
                    Set foundDay = foundRow.Find(Day(ThisWorkbook.ActiveSheet.Cells(14, 2 + i).value), LookIn:=xlValues, LookAt:=xlWhole)
                    If Not foundDay Is Nothing Then
                        Dim ship_val As String
                        ship_val = ws.Cells(foundPartCode.Row, foundDay.Column).value
                        If Not ship_val = "" Then
                            ThisWorkbook.ActiveSheet.Cells(16, 2 + i).value = ship_val
                        Else
                            ThisWorkbook.ActiveSheet.Cells(16, 2 + i).value = "0"
                        End If
                    End If
                Next i
            Else
                MsgBox "Partial match for " & ThisWorkbook.ActiveSheet.Range("C3").value & " not found"
            End If
        Else
            MsgBox "'PART CODE' not found in the specified range."
        End If
    Else
        MsgBox "No visible sheets found with numbers in their names."
    End If
    
    wb.Close SaveChanges:=False ' Close the workbook without saving changes
    Application.ScreenUpdating = True
End Sub

Function RegExpReplace(ByVal text As String, ByVal replacePattern As String, ByVal replaceWith As String) As String
    Dim regex As Object
    Set regex = CreateObject("VBScript.RegExp")
    
    regex.Global = True
    regex.IgnoreCase = True
    regex.Pattern = replacePattern
    
    RegExpReplace = regex.Replace(text, replaceWith)
End Function

Private Sub schedule30T_Click()
    Dim filePath As String
    
    ' Create a FileDialog object as a File Picker dialog box.
    With Application.FileDialog(msoFileDialogFilePicker)
        .AllowMultiSelect = False
        .Title = "Select a Schedule molding 30T File"
        If .Show = -1 Then ' If the user clicks OK
            filePath = .SelectedItems(1) ' Get the selected file path
        End If
    End With
    
    ' Save the file path in cell C1 of the active worksheet
    ThisWorkbook.ActiveSheet.Range("AB3").value = filePath
End Sub

Private Sub Schedule5080T_Click()
    Dim filePath As String
    
    ' Create a FileDialog object as a File Picker dialog box.
    With Application.FileDialog(msoFileDialogFilePicker)
        .AllowMultiSelect = False
        .Title = "Select a Schedule molding 50-80T File"
        If .Show = -1 Then ' If the user clicks OK
            filePath = .SelectedItems(1) ' Get the selected file path
        End If
    End With
    
    ' Save the file path in cell C1 of the active worksheet
    ThisWorkbook.ActiveSheet.Range("AB4").value = filePath
End Sub

Private Sub Schedule100T_Click()
    Dim filePath As String
    
    ' Create a FileDialog object as a File Picker dialog box.
    With Application.FileDialog(msoFileDialogFilePicker)
        .AllowMultiSelect = False
        .Title = "Select a Schedule molding 100T File"
        If .Show = -1 Then ' If the user clicks OK
            filePath = .SelectedItems(1) ' Get the selected file path
        End If
    End With
    
    ' Save the file path in cell C1 of the active worksheet
    ThisWorkbook.ActiveSheet.Range("AB5").value = filePath
End Sub

Private Sub Schedule130450T_Click()
    Dim filePath As String
    
    ' Create a FileDialog object as a File Picker dialog box.
    With Application.FileDialog(msoFileDialogFilePicker)
        .AllowMultiSelect = False
        .Title = "Select a Schedule molding 130-150T File"
        If .Show = -1 Then ' If the user clicks OK
            filePath = .SelectedItems(1) ' Get the selected file path
        End If
    End With
    
    ' Save the file path in cell C1 of the active worksheet
    ThisWorkbook.ActiveSheet.Range("AB6").value = filePath
End Sub

Private Sub Shipping_File_Click()
    Dim filePath As String
    
    ' Create a FileDialog object as a File Picker dialog box.
    With Application.FileDialog(msoFileDialogFilePicker)
        .AllowMultiSelect = False
        .Title = "Select a Schedule Shipping File"
        If .Show = -1 Then ' If the user clicks OK
            filePath = .SelectedItems(1) ' Get the selected file path
        End If
    End With
    
    ' Save the file path in cell C1 of the active worksheet
    ThisWorkbook.ActiveSheet.Range("AB14").value = filePath
End Sub

Private Sub Today_button_Click()
    ThisWorkbook.ActiveSheet.Range("AB1").value = Date
End Sub

Sub Run_main()
    Dim Partcode As String
    Dim sourceFilePath As String
    Dim sourceWorkbook As Workbook
    Dim sourceWorksheet As Worksheet
    
    Application.DisplayAlerts = False
    Application.EnableEvents = False
    
    ' Clear all old data
    ThisWorkbook.ActiveSheet.Range("C2").value = ""
    ThisWorkbook.ActiveSheet.Range("C4").value = ""
    ThisWorkbook.ActiveSheet.Range("C9").value = ""
    
    ' Get part code for lookup
    Partcode = ThisWorkbook.ActiveSheet.Range("C3").value
    If Not Partcode = "" Then
        sourceFilePath = ThisWorkbook.ActiveSheet.Range("AB2").value ' Update this with the correct file path
        ' Check if the source file exists
        If Dir(sourceFilePath) <> "" Then
            Application.ScreenUpdating = False ' Turn off screen updating to prevent flickering
                    
            ' Open the source workbook
            Set sourceWorkbook = Workbooks.Open(Filename:=sourceFilePath, UpdateLinks:=0, ReadOnly:=True)
            ' Set the source worksheet and cell
            Set sourceWorksheet = sourceWorkbook.Sheets("Materpart new") ' Update with the desired source sheet
            
            Dim lookupRange As Range
            ' Set the lookup range
            Set lookupRange = sourceWorksheet.Range("B4:B4096") ' Update with the desired range
            
            Dim resultCell As Range
            ' Find the match in the lookup range
            On Error Resume Next
            Set resultCell = lookupRange.Find(Partcode, LookIn:=xlValues, LookAt:=xlPart)
            On Error GoTo 0
            
            If Not resultCell Is Nothing Then
            
                ' Customer
                ThisWorkbook.ActiveSheet.Range("C2").value = sourceWorksheet.Cells(resultCell.Row, "M").value
                ' Part name
                ThisWorkbook.ActiveSheet.Range("C4").value = sourceWorksheet.Cells(resultCell.Row, "C").value
                
                Dim size_ton As String
                size_ton = sourceWorksheet.Cells(resultCell.Row, "L").value
                ThisWorkbook.ActiveSheet.Range("AB7").value = size_ton
                ThisWorkbook.ActiveSheet.Range("AB8").value = sourceWorksheet.Cells(resultCell.Row, "P").value
            Else
                Set lookupRange = sourceWorksheet.Range("BN4:BN4096") ' Update with the desired range
                ' Find the match in the lookup range
                On Error Resume Next
                Set resultCell = lookupRange.Find(Partcode, LookIn:=xlValues, LookAt:=xlPart)
                On Error GoTo 0
                If Not resultCell Is Nothing Then
            
                    ' Customer
                    ThisWorkbook.ActiveSheet.Range("C2").value = sourceWorksheet.Cells(resultCell.Row, "M").value
                    ' Part name
                    ThisWorkbook.ActiveSheet.Range("C4").value = sourceWorksheet.Cells(resultCell.Row, "C").value
                    
                    size_ton = sourceWorksheet.Cells(resultCell.Row, "L").value
                    ThisWorkbook.ActiveSheet.Range("AB7").value = size_ton
                ThisWorkbook.ActiveSheet.Range("AB8").value = sourceWorksheet.Cells(resultCell.Row, "P").value
                Else
                    MsgBox "No match found."
                End If
            End If
            
            ' Close the source workbook without saving
            sourceWorkbook.Close False
        
            Application.ScreenUpdating = True ' Turn screen updating back on
            
            Getbalance_Click
        Else
            MsgBox "Source file not found."
        End If
    Else
        MsgBox "Please Enter PART CODE"
    End If
End Sub

Sub Run_get_balance()
    Dim Partcode As String
    Dim size_ton As String
    Dim sourceWorkbook As Workbook
    Dim sourceWorksheet As Worksheet
    
    Partcode = ThisWorkbook.ActiveSheet.Range("C3").value
    size_ton = ThisWorkbook.ActiveSheet.Range("AB7").value
    If IsNumeric(size_ton) Then
        Dim value As Double
        value = CDbl(size_ton)
        
        Dim Select_schedule As String
        Select_schedule = "Exit"
        Select Case value
            Case 30
                Select_schedule = "AB3"
            Case 50 To 80
                Select_schedule = "AB4"
            Case 100
                Select_schedule = "AB5"
            Case 130 To 450
                Select_schedule = "AB6"
            Case Else
                Dim inputString As String
                inputString = InputBox("Enter M/C Size-ton ->" & size_ton & " :")
                If Not inputString = "" Then
                    value = CDbl(inputString)
                    Select Case value
                        Case 30
                            Select_schedule = "AB3"
                        Case 50 To 80
                            Select_schedule = "AB4"
                        Case 100
                            Select_schedule = "AB5"
                        Case 130 To 450
                            Select_schedule = "AB6"
                        Case Else
                            MsgBox "Invalid size-ton try again!"
                    End Select
                Else
                    MsgBox "Not found input try again!"
                End If
            End Select
    End If
    Dim cell As Range
    If Not Select_schedule = "Exit" Then
        sourceFilePath = ThisWorkbook.ActiveSheet.Range(Select_schedule).value ' Update this with the correct file path
        ' Check if the source file exists
        If Dir(sourceFilePath) <> "" Then
            Application.ScreenUpdating = False ' Turn off screen updating to prevent flickering

            ' Open the source workbook
            Set sourceWorkbook = Workbooks.Open(Filename:=sourceFilePath, UpdateLinks:=0, ReadOnly:=True)
            ' Loop through each worksheet in the workbook
            For Each ws In sourceWorkbook.Sheets
                ' Find the last row in column D of the current sheet
                lastRow = ws.Cells(ws.Rows.count, "D").End(xlUp).Row
                ' Loop through each cell in column D and highlight matching cells
                For Each cell In ws.Range("D1:D" & lastRow)
                    If InStr(1, LCase(CStr(cell.value)), Partcode, vbTextCompare) > 0 And ws.Cells(cell.Row + 13, "M").value = "BALANCE" Then
                        ThisWorkbook.ActiveSheet.Range("AE8").value = "'" & CStr(cell.value)
                        'MsgBox cell.Row & " " & cell.Column & "@" & ws.Name & ws.Cells(cell.Row + 13, "M").value
                        Dim lookupValue As Variant
                        ' Set the lookup value from cell A1
                        lookupValue = Day(ThisWorkbook.ActiveSheet.Range("AB1").value) ' Update with the desired sheet
                        
                        'Debug.Print InStr(1, LCase(CStr(cell.value)), Partcode, vbTextCompare) & "|" & Partcode & "|" & CStr(cell.value)
                        
                        Dim rng As Range
                        Dim Rcell As Range
                        Dim rowNum As Integer
                        
                        ' Initial rowNum
                        rowNum = 0
                        
                        ' Set the range to import
                        Set rng = ws.Range("B1:B8")
                        
                        ' Loop through each cell in the range and print the value in the Immediate window
                        For Each Rcell In rng
                            If InStr(1, LCase(Rcell.value), "MODEL", vbTextCompare) > 0 Then
                                rowNum = Rcell.Row
                                'Debug.Print Rcell.value & " " & Rcell.Row
                            End If
                            'Debug.Print Rcell.value
                        Next Rcell
                        
                        ' Set the lookup range
                        Set lookupRange = ws.Range(ws.Cells(rowNum, "T"), ws.Cells(rowNum, "AX")) ' Update with the desired range
                        
                        Dim columnIndex As Long
                        ' Find the match in the lookup range
                        On Error Resume Next
                        Set resultCell = lookupRange.Find(lookupValue, LookIn:=xlValues, LookAt:=xlPart)
                        On Error GoTo 0
                        
                        If Not resultCell Is Nothing Then
                            ' Get the column index of the match
                            columnIndex = resultCell.Column
                            
                            ' Get the corresponding value from rows of that column
                            ThisWorkbook.ActiveSheet.Range("C9").value = ws.Cells(cell.Row + 13, columnIndex).value
                        Else
                            MsgBox "No match found!"
                        End If
                    End If
                Next cell
            Next ws
            
            ' Close the source workbook without saving
            sourceWorkbook.Close False
        
            Application.ScreenUpdating = True ' Turn screen updating back on
        Else
            MsgBox "Source file not found."
        End If
    End If
End Sub




