VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Presentasi H5P"
   ClientHeight    =   5910
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   9855
   ForeColor       =   &H000000FF&
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5910
   ScaleWidth      =   9855
   StartUpPosition =   3  'Windows Default
   Begin VB.Frame Frame1 
      Caption         =   "Server Presentasi"
      Height          =   5655
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   9615
      Begin VB.CommandButton Command1 
         Caption         =   "HIDUPKAN SERVER"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   18
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1095
         Left            =   120
         TabIndex        =   3
         Top             =   2040
         Width           =   4695
      End
      Begin VB.CommandButton Command2 
         Caption         =   "MATIKAN SERVER"
         Enabled         =   0   'False
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   18
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1095
         Left            =   5040
         TabIndex        =   2
         Top             =   2040
         Width           =   4455
      End
      Begin VB.CommandButton Buka 
         Caption         =   "BUKA BROWSER"
         Enabled         =   0   'False
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   18
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   1095
         Left            =   120
         TabIndex        =   1
         Top             =   4440
         Width           =   9375
      End
      Begin VB.Label siswa 
         Caption         =   "SISWA : "
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   22.5
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   240
         TabIndex        =   6
         Top             =   480
         Width           =   9255
      End
      Begin VB.Label guru 
         Caption         =   "GURU : "
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   22.5
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   615
         Left            =   240
         TabIndex        =   5
         Top             =   1320
         Width           =   9255
      End
      Begin VB.Label server 
         Alignment       =   2  'Center
         Caption         =   "SERVER"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   30
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   855
         Left            =   120
         TabIndex        =   4
         Top             =   3480
         Width           =   9255
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private nodeProcess As Object
Private Const NODE_CMD As String = "cmd.exe /c node c:\h5p\server.js"
Private Const KILL_CMD As String = "taskkill /F /IM node.exe"
Private nodeProcessID As Long
Dim ipAddresses As String

Private Declare Function ShellExecute Lib "shell32.dll" _
    Alias "ShellExecuteA" (ByVal hwnd As Long, _
    ByVal lpOperation As String, ByVal lpFile As String, _
    ByVal lpParameters As String, ByVal lpDirectory As String, _
    ByVal nShowCmd As Long) As Long

Private Const SW_HIDE As Long = 0

Private Sub Buka_Click()
 Dim url As String
    url = "http://" & ipAddresses & ":3000/guru"
    
    Dim result As Long
    result = ShellExecute(Me.hwnd, "open", url, vbNullString, vbNullString, SW_SHOWNORMAL)
    
    If result <= 32 Then
        MsgBox "Gagal Menjalankan Link.", vbCritical, "Info"
    End If
End Sub

Private Sub Command1_Click()
On Error GoTo ErrorHandler
    Dim result As Long
    result = ShellExecute(Me.hwnd, "open", "cmd.exe", "cmd.exe /c node c:\h5p\server.js", "", SW_HIDE)
        
    If result <= 32 Then
        server.ForeColor = RGB(0, 255, 0)
        server.Caption = "Server Hidup"
        Command2.Enabled = True
        Command1.Enabled = False
        Buka.Enabled = True
    Else
        server.ForeColor = RGB(0, 255, 0)
        server.Caption = "Server Hidup"
        Command2.Enabled = True
        Command1.Enabled = False
        Buka.Enabled = True
    End If
    Exit Sub

ErrorHandler:
    MsgBox "Gagal Menjalankan Server.", vbCritical, "Info"
End Sub

Private Sub Command2_Click()
On Error GoTo ErrorHandler
    Dim shell As Object
    Set shell = CreateObject("WScript.Shell")
    shell.Run "cmd.exe /c echo taskkill /F /IM node.exe", 0, True
    shell.Run "taskkill /F /IM node.exe", 0, True
        server.ForeColor = RGB(255, 0, 0)
        server.Caption = "Server Mati"
        Command2.Enabled = False
        Command1.Enabled = True
        Buka.Enabled = False
   
    Exit Sub
    

ErrorHandler:
    MsgBox "Gagal menghentikan Server.", vbCritical, "Info"
End Sub

Private Sub Form_Load()
    Dim hostName As String
    
    Dim objWMIService As Object
    Dim colItems As Object
    Dim objItem As Object
    Dim shell As Object
    
    ' Menampilkan IP Address
    hostName = CreateObject("WScript.Network").ComputerName
    Set objWMIService = GetObject("winmgmts:\root\cimv2")
    Set colItems = objWMIService.ExecQuery("Select * from Win32_NetworkAdapterConfiguration where IPEnabled = True")

    For Each objItem In colItems
        If IsArray(objItem.IPAddress) Then
            ipAddresses = Join(objItem.IPAddress, ", ")
        End If
    Next
    
    If ipAddresses = "" Then
        MsgBox "Koneksi Perangkat Ke Jaringan Gagal, Silahkan Hubungkan Wifi", vbCritical, "IP Address"
        Unload Me
    End If
    
    siswa.Caption = "Siswa : " & ipAddresses & ":3000"
    guru.Caption = "Guru : " & ipAddresses & ":3000/guru"
    server.ForeColor = RGB(255, 0, 0)
    server.Caption = "Server Mati"
    
End Sub

