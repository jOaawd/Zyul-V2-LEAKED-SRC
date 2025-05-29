#SingleInstance, Force
#Persistent
#InstallKeybdHook
#UseHook
SetKeyDelay, -1, -1
SetControlDelay, -1
SetMouseDelay, -1
SetWinDelay, -1
SendMode, InputThenPlay
SetBatchLines, -1
CoordMode, Pixel, screen

Sleep, 400

Width := 470
Height := 330
CornerRadius := 30
TopBarVisible := true
ArrowVisible := true

Gui, +LastFound +AlwaysOnTop -Caption +ToolWindow
WinSet, Transparent, 205
Gui, Color, 242424
Gui, Margin, 10, 10

hRgn := DllCall("CreateRoundRectRgn", "int", 0, "int", 0, "int", Width + 1, "int", Height + 1, "int", CornerRadius, "int", CornerRadius, "ptr")
DllCall("SetWindowRgn", "ptr", WinExist(), "ptr", hRgn, "int", true)
DllCall("DeleteObject", "ptr", hRgn)

Gui, Add, Button, x432 y-2 w40 h30 gExitApp +E0x80000 +BackgroundTrans, X
Gui, Add, Button, x5 y-2 w40 h30 gToggleTopBar +E0x80000 +BackgroundTrans, -  

Gui, Add, Progress, % "x-1 y-1 w" (Width+2) " h31 Background5856D6 Disabled hwndHPROG"
Control, ExStyle, -0x20000, , ahk_id %HPROG%
Gui, Add, Text, % "x97 y-2 w" Width " h34 BackgroundTrans Center 0x200 gGuiMove vCaption c232323", LEAKED SOURCE ZYUL V2 MEKO U SUCK NIGGA                                                                X

Gui, Font, s11 c232323,
Gui, Add, Text, % "x5 y-2 w40 h30 BackgroundTrans Center 0x200 vArrowText", % Chr(8595)

Gui, Font, s9 c181818, Tahoma
Gui, Add, Edit, vJsonEdit w380 h200 -WantTab x50 y70 +VScroll, Import / Paste Config Here

Gui, Font, s10 c5856D6, Tahoma
Gui, Add, Text, x110 y291 w80 h25 BackgroundTrans Center gInject, Inject
Gui, Add, Text, x179 y291 w100 h25 BackgroundTrans Center gOpenConfigs, Import Config
Gui, Add, Text, x271 y291 w100 h25 BackgroundTrans Center gSaveConfigs, Save Config

Gui, Add, Button, x110 y287 w80 h25 gInject +E0x80000 vBtnSave
Gui, Add, Button, x179 y287 w100 h25 gOpenConfigs +E0x80000 vBtnOpen
Gui, Add, Button, x271 y287 w100 h25 gSaveConfigs +E0x80000 vBtnConfig

Gui, Show, w%Width% h%Height%, ZyuL V2

Return

GuiMove:
    PostMessage, 0xA1, 2,,, A
Return

ToggleTopBar:
    if (TopBarVisible) {
        TopBarVisible := false
        hRgn := DllCall("CreateRoundRectRgn", "int", 0, "int", 0, "int", Width + 1, "int", 40, "int", CornerRadius, "int", CornerRadius, "ptr")
        DllCall("SetWindowRgn", "ptr", WinExist(), "ptr", hRgn, "int", true)
        DllCall("DeleteObject", "ptr", hRgn)
        
        if (ArrowVisible) {
            ArrowVisible := false
            Gui, Font, s11 c232323
            GuiControl,, ArrowText, _
        }
    } else {
        TopBarVisible := true
        hRgn := DllCall("CreateRoundRectRgn", "int", 0, "int", 0, "int", Width + 1, "int", Height + 1, "int", CornerRadius, "int", CornerRadius, "ptr")
        DllCall("SetWindowRgn", "ptr", WinExist(), "ptr", hRgn, "int", true)
        DllCall("DeleteObject", "ptr", hRgn)
        
        if (!ArrowVisible) {
            ArrowVisible := true
            Gui, Font, s11 c232323
            GuiControl,, ArrowText, % Chr(8595)
        }
    }
Return

Inject:
    Gui, Submit, NoHide
    File := FileOpen("data\config.json", "w")
    if !File {
        MsgBox, ERROR 0003: Failed to write config.json
        ExitApp
    }
    File.Write(JsonEdit)
    File.Close()
    Click, x100 y100
    Sleep, 100
    SetWorkingDir, %A_ScriptDir%\data
    Run, cam.ahk
Return

OpenConfigs:
    FileSelectFile, selectedFile, 3, %A_ScriptDir%\CONFIGS\
    if (selectedFile != "") {
        File := FileOpen(selectedFile, "r")
        if !File {
            MsgBox, ERROR 0004: Failed to open the selected file
            return
        }
        FileContent := File.Read()
        File.Close()
        GuiControl,, JsonEdit, %FileContent%
    }
Return

SaveConfigs:
    Gui, Submit, NoHide
    configContent := JsonEdit
    FileSelectFile, saveFilePath, S16, %A_ScriptDir%\CONFIGS\, Save Config As, Text Files (*.txt)
    if (saveFilePath != "") {
        FileCreateDir, %A_ScriptDir%\CONFIGS\
        File := FileOpen(saveFilePath, "w")
        if !File {
            MsgBox, ERROR 0005: Failed to save Config
            return
        }
        File.Write(configContent)
        File.Close()
    }
Return

ExitApp:
   ExitApp
Return

GuiClose:
    ExitApp
Return

ExitApp
#SingleInstance off