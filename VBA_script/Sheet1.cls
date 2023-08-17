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
    Date_String = ThisWorkbook.ActiveSheet.Range("Q1").value
    Date_String = WorksheetFunction.Text(Date_String, "dd-mmm-yyyy")
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
                ThisWorkbook.ActiveSheet.Range("Q7").value = "30"
            Case 2
                ThisWorkbook.ActiveSheet.Range("Q7").value = "50"
            Case 3
                ThisWorkbook.ActiveSheet.Range("Q7").value = "100"
            Case 4
                ThisWorkbook.ActiveSheet.Range("Q7").value = "130"
        End Select
        Run_get_balance
        If Not ThisWorkbook.ActiveSheet.Range("C9").value = "" Then
            Exit For
        End If
        ThisWorkbook.ActiveSheet.Range("Q7").value = ""
    Next i
End Sub

Private Sub Inform_button_Click()
    Dim Date_String As String
    Date_String = ThisWorkbook.ActiveSheet.Range("Q1").value
    Date_String = WorksheetFunction.Text(Date_String, "dd-mmm-yyyy")
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
    ThisWorkbook.ActiveSheet.Range("Q2").value = filePath
End Sub

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
    ThisWorkbook.ActiveSheet.Range("Q3").value = filePath
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
    ThisWorkbook.ActiveSheet.Range("Q4").value = filePath
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
    ThisWorkbook.ActiveSheet.Range("Q5").value = filePath
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
    ThisWorkbook.ActiveSheet.Range("Q6").value = filePath
End Sub

Private Sub Today_button_Click()
    ThisWorkbook.ActiveSheet.Range("Q1").value = Date
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
        sourceFilePath = ThisWorkbook.ActiveSheet.Range("Q2").value ' Update this with the correct file path
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
            Set resultCell = lookupRange.Find(Partcode, LookIn:=xlValues, LookAt:=xlWhole)
            On Error GoTo 0
            
            If Not resultCell Is Nothing Then
            
                ' Customer
                ThisWorkbook.ActiveSheet.Range("C2").value = sourceWorksheet.Cells(resultCell.Row, "M").value
                ' Part name
                ThisWorkbook.ActiveSheet.Range("C4").value = sourceWorksheet.Cells(resultCell.Row, "C").value
                
                Dim size_ton As String
                size_ton = sourceWorksheet.Cells(resultCell.Row, "L").value
                ThisWorkbook.ActiveSheet.Range("Q7").value = size_ton
                ThisWorkbook.ActiveSheet.Range("Q8").value = sourceWorksheet.Cells(resultCell.Row, "P").value
            Else
                Set lookupRange = sourceWorksheet.Range("BN4:BN4096") ' Update with the desired range
                ' Find the match in the lookup range
                On Error Resume Next
                Set resultCell = lookupRange.Find(Partcode, LookIn:=xlValues, LookAt:=xlWhole)
                On Error GoTo 0
                If Not resultCell Is Nothing Then
            
                    ' Customer
                    ThisWorkbook.ActiveSheet.Range("C2").value = sourceWorksheet.Cells(resultCell.Row, "M").value
                    ' Part name
                    ThisWorkbook.ActiveSheet.Range("C4").value = sourceWorksheet.Cells(resultCell.Row, "C").value
                    
                    size_ton = sourceWorksheet.Cells(resultCell.Row, "L").value
                    ThisWorkbook.ActiveSheet.Range("Q7").value = size_ton
                ThisWorkbook.ActiveSheet.Range("Q8").value = sourceWorksheet.Cells(resultCell.Row, "P").value
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
    size_ton = ThisWorkbook.ActiveSheet.Range("Q7").value
    If IsNumeric(size_ton) Then
        Dim value As Double
        value = CDbl(size_ton)
        
        Dim Select_schedule As String
        Select_schedule = "Exit"
        Select Case value
            Case 30
                Select_schedule = "Q3"
            Case 50 To 80
                Select_schedule = "Q4"
            Case 100
                Select_schedule = "Q5"
            Case 130 To 450
                Select_schedule = "Q6"
            Case Else
                Dim inputString As String
                inputString = InputBox("Enter M/C Size-ton ->" & size_ton & " :")
                If Not inputString = "" Then
                    value = CDbl(inputString)
                    Select Case value
                        Case 30
                            Select_schedule = "Q3"
                        Case 50 To 80
                            Select_schedule = "Q4"
                        Case 100
                            Select_schedule = "Q5"
                        Case 130 To 450
                            Select_schedule = "Q6"
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
                    If CStr(cell.value) = Partcode And ws.Cells(cell.Row + 13, "M").value = "BALANCE" Then
                        'MsgBox cell.Row & " " & cell.Column & "@" & ws.Name & ws.Cells(cell.Row + 13, "M").value
                        Dim lookupValue As Variant
                        ' Set the lookup value from cell A1
                        lookupValue = ThisWorkbook.ActiveSheet.Range("R1").value ' Update with the desired sheet
                        
                        ' Set the lookup range
                        Set lookupRange = ws.Range("T5:AX5") ' Update with the desired range
                        
                        Dim columnIndex As Long
                        ' Find the match in the lookup range
                        On Error Resume Next
                        Set resultCell = lookupRange.Find(lookupValue, LookIn:=xlValues, LookAt:=xlWhole)
                        On Error GoTo 0
                        
                        If Not resultCell Is Nothing Then
                            ' Get the column index of the match
                            columnIndex = resultCell.Column
                            
                            ' Get the corresponding value from rows of that column
                            ThisWorkbook.ActiveSheet.Range("C9").value = ws.Cells(cell.Row + 13, columnIndex).value
                        Else
                            MsgBox "No match found."
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

