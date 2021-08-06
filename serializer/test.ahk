#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.s
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force
SetBatchLines, -1
#Persistent
GroupAdd, ProjectWindow, Cubase Pro Project
GroupAdd, ProjectWindow, Cubase Version
#include PresetSerializer.ahk


; msgbox, % 200 // 2
; return
; 
Editor := new PresetSerializer()
Editor.setCPRParsing(true)
Editor.setEditorType("PLE")
Editor.setPresetName("Helllo")
Editor.setPresetFunction("Select")
Editor.setPresetSubFolder("Test")

logic := {}
logic.Actions := []


; logic.Actions.push("Channel, Set Random Values between, 5, 7")
; logic.Actions .= "Type, Set to fixed value, Note; "
; logic.Actions .= "Value 1, Transpose to scale, Eb, Major"
; logic.Actions .= "NoteExp Operation, Create One-Shot, Poly Pressure; "
; logic.Actions .= "VST 3 Value Operation, Set relative random values between, -0.5, 0.75"
; logic.Actions .= "Position, Set to fixed value, 10, PPQ; "

; leActionTargetTrackOp
;-----------------------------
; logic.Actions.push("Track Operation, Folder, Open")
; logic.Actions.push("Track Operation, Time Domain, Musical")

; leActionTargetName
;-----------------------------
; logic.Actions.push("Name, Replace Search String, Hello, Yooo")

; leActionTargetTrim
;-----------------------------
; logic.Actions.push("Trim, Multiply by, 100")
; logic.Actions.push("Trim, Divide by, 10")

; leActionTargetColor
;-----------------------------
; logic.Actions.push("Set Color, Set to fixed value, Color 1")

; leActionTargetValue1
;-----------------------------
; logic.Actions.push("Value 1, Set to fixed value, 5")

;leActionTargetNXPOp
;-----------------------------
; logic.Actions.push("NoteExp Operation, Create One-Shot, Poly Pressure")
; logic.Actions.push("NoteExp Operation, Remove NoteExp")

;leActionTargetChannel
;-----------------------------
; logic.Actions.push("Channel, Set Random Values between, 1, 2")


; logic.Actions.push("VST 3 Value Operation, Set relative random values between, -0.5, 0.75")
; logic.Actions .= "Position, Subtract, 10, PPQ; "
; logic.Actions .= "Position, Add, 10, PPQ; "
; logic.Actions .= "Position, Set to fixed value, 10, PPQ"
; logic.Actions.push("Value 2, Multiply by, 2")
; logic.Actions.push("Length, Add, 10, PPQ")
; logic.Actions.push("Length, Add, 10, PPQ")
; logic.Actions.push("Position, Add, 10, PPQ")
; logic.Actions.push("Length, Set to fixed value, 15, Frames")
; logic.Actions.push("Length, Add, 10, Frames")

; msgbox,% logic.actions


logic.Filters := []

; leTypesTarget
;-----------------------------
; logic.Filters.push( "Type Is, Equal, Controller AND " )

; leValue1Target
;-----------------------------
; logic.Filters.push( "Value 1, Equal, 121" )

; leValue2Target
;-----------------------------
; logic.Filters.push( "Value 2, Equal, 121" )

; leValue3Target
;-----------------------------
; logic.Filters.push( "Value 3, Equal, 121" )

; leFlagsTarget
;-----------------------------
; logic.Filters.push( "Property, Property is set, Event is muted" )

; leMediaTypeTarget
;-----------------------------
; logic.Filters.push( "Media Type is, Equal, Audio" )

; leContainerTypeTarget
;-----------------------------
; logic.Filters.push( "Container Type is, Equal, FolderTrack" )

; leNameTypeTarget
;-----------------------------
; logic.Filters.push( "Name, Equal, Hello" )

; leColorTypeTarget
;-----------------------------
; logic.Filters.push( "Color Name is, Equal, Red" )

; leChannelTarget
;-----------------------------
; logic.Filters.push( "Channel, Equal, 5" )

;leHistoryTarget
;-----------------------------
; logic.Filters.push( "Last Event, Equal, Value 1, 5" )

;lePositionTarget
;-----------------------------
; logic.Filters.push( "Position, Inside Bar Range, 0, 36" )
logic.Filters.push( "Position, Equal, 10,, PPQ" )

;leLengthTarget
;-----------------------------
; logic.Filters.push( "Length, Equal, 10,, PPQ" )
; logic.Filters.push( "Length, Inside Range, 10, 20, PPQ" )


; Logical Editor - Rhythm Filter
; logic.Filters.push( "Context variable, Equal, Highest Pitch AND" )
; logic.Filters.push( "Context variable, Equal, Highest Pitch" )
; logic.Filters.push( "(Property, Property is set, Event is selected OR" )
; logic.Filters.push( "Property, Property is not set, Event is selected) AND" )
; logic.Filters.push( "(Position, Inside Bar Range, 1884, 1920 OR" )
; logic.Filters.push( "Position, Inside Bar Range, 0, 36 OR" )
; logic.Filters.push( "Position, Inside Bar Range, 564, 636 OR" )
; logic.Filters.push( "Position, Inside Bar Range, 1164, 1236 OR" )
; logic.Filters.push( "Position, Inside Bar Range, 1764, 1836)" )

; logic.Filters .= "Type Is, Equal, Program Change AND Value 1, Equal, 10 AND Type Is, Equal, Note AND Value 2, Equal, 10 AND Pitch, Equal, C#6"
; logic.Filters .= "Channel, Equal, 16"
; logic.Filters .= "Position, Exactly Matching Cycle,,, PPQ"
; logic.Filters .= " AND Length, Equal, 1,, PPQ))"
; logic.Filters .= " AND Last Event, Equal, Value 1, A#-2"
; logic.Filters .= " AND Property, Property is set, Event is selected"
; logic.Filters .= " AND Context Variable, Equal, Position in Chord - Part, Minor Third"
; logic.Macro .= "Not set"
; Msgbox, % Args.Filters
 

n = 1
TC := A_TickCount
loop, % n {
   Editor.NewPreset(logic)
; temp := Editor.CPR.importMTrack(1)
; Editor.CPR.UpdateFilePath()
   ; temp := Editor.CPR.updateMTrack(500)
   ; msgbox, % Editor.CPR.Curr_FilePath
}

; TC1 := ( A_TickCount - TC ) / n
; Msgbox, TC1 = %TC1% ; `n TC2 = %TC2% `n TC3 = %TC3% `n TC4 = %TC4%
; msgbox, % temp