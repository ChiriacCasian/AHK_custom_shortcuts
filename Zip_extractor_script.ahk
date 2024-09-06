﻿; script that extracts all the selected zip files in the current folder

^e::  ; Ctrl + e

{
    ; Ensure File Explorer is active
    if WinActive("ahk_class CabinetWClass")
    {
        ; Create a Shell application COM object
        shell := ComObject("Shell.Application")
        selectedFiles := []

        ; Get the current active window in Explorer
        for window in shell.Windows
        {
            if (window.hwnd = WinExist("A"))  ; Make sure it's the active window
            {
                folderView := window.Document  ; Get the FolderView object
                break
            }
        }

        ; Retrieve selected files in the active folder
        for item in folderView.SelectedItems
            selectedFiles.Push(item.Path)

        ; Loop through the selected files
        for filePath in selectedFiles
        {
            ; Check if the file is a .zip
            if InStr(filePath, ".zip")
            {
                ; Extract folder will be the directory of the .zip file
                ;extractFolder := StrReplace(filePath, "\" . RegExReplace(filePath, "^.*\\"))
                
		extractorFolder := RegExReplace(filePath, "\\[^\\]*$")

		RunWait('"C:\winrar\WinRAR.exe" x "' filePath '" "' extractorFolder '"')
		
		FileDelete(filePath)
            }
        }
    }
}