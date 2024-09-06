; script that unravels all selected folders

^+f::  ; Ctrl + Shift + F

{
    ; Ensure File Explorer is active
    if WinActive("ahk_class CabinetWClass")
    {
        ; Create a Shell application COM object
        shell := ComObjCreate("Shell.Application")
        selectedFiles := []

        ; Get the current active window in Explorer
        for window in shell.Windows
        {
            if (window.hwnd = WinExist("A"))  ; Make sure it's the active window
            {
                folderView := window.Document  ; Get the FolderView object
		destinationFolder := folderView.Folder.Self.Path
                break
            }
        }

	; Retrieve selected files in the active folder
        for item in folderView.SelectedItems
	{
		nume := item.Path
            selectedFiles.Push(nume)
		MoveAllFilesAndFolders(nume, destinationFolder)
	}
        
    }
}

; Function to move all files from a source folder to a destination folder
MoveAllFiles2(sourceFolder, destinationFolder) {

    ; Move all files from the source folder to the destination folder
    Loop, Files, %sourceFolder%\*.*, F
    {
        ; Move each file to the destination folder
        FileMove, %A_LoopFileFullPath%, %destinationFolder%\%A_LoopFileName%, 1
    }
	Loop, Files, %sourceFolder%\*.*, R
    {
        ; Move each file to the destination folder
        FileMove, %A_LoopFileFullPath%, %destinationFolder%\%A_LoopFileName%, 1
    }
    
}


MoveAllFilesAndFolders(sourceFolder, destinationFolder) {
    
    ; Loop through all files and folders in the source folder
    Loop, Files, %sourceFolder%\*.*, RD  ; R = Include folders, D = Recurse into subdirectories
    {
        ; Check if it's a folder
        if (InStr(A_LoopFileAttrib, "D"))  ; "D" in attributes indicates it's a folder
        {
            ; Create the same folder structure in the destination folder
            if !FileExist(destinationFolder "\" A_LoopFileName)
                FileCreateDir, %destinationFolder%\%A_LoopFileName%
            
            ; Recursively move contents of the folder
            MoveAllFilesAndFolders(A_LoopFileFullPath, destinationFolder "\" A_LoopFileName)
        }
        else
        {
            ; Move the file to the destination folder
            FileMove, %A_LoopFileFullPath%, %destinationFolder%\%A_LoopFileName%, 1
	}
    }
	MoveAllFiles2(sourceFolder, destinationFolder)	

	; Attempt to remove the source folder itself after everything is moved
    FileRemoveDir, %sourceFolder%, 1  ;
}
