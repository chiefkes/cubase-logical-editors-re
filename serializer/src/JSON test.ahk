#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.s
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force
SetBatchLines, -1
#Persistent
#Include _JSON.ahk



JSON_Map := [
(Join
   "leActionTargetTrackOp",
   "leActionTargetValue1"
)]


leActionTargetTrackOp =
(
{
   "attrType": "action",
   "attrID":4012,
   "branching": 0,
   "operators": {
      "Folder"        : { "opVal": 331 }, 
      "Record"        : { "opVal": 332 }, 
      "Monitor"       : { "opVal": 333 },
      "Solo"          : { "opVal": 334 },
      "Mute"          : { "opVal": 335 },
      "Read"          : { "opVal": 337 },
      "Write"         : { "opVal": 338 },
      "EQ Bypass"     : { "opVal": 339 },
      "Inserts Bypass": { "opVal": 340 },
      "Sends Bypass"  : { "opVal": 341 },
      "Lanes Active"  : { "opVal": 342 },
      "Hide Track"    : { "opVal": 343 },
      "Time Domain"   : { "opVal": 344 }
   },
   "values": {
      ; "length": 4
      "branching": 2,
      "Folder": {
         "branching": 3,
         "Open": {
            "branching": 0
            "type": "Int"
            "values": [4, 0]
         }
      }
   }
   "branch": {
      "1": {
         "branching": 0,
         "spawns": [
            {
               "name":"UIntValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"UValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"LeGenericOpValue",
               "isSet":1,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"LeUIntValue",
               "isSet":1,
               "hasHeader":1,
               "params":[]
            }
         ]
      }
   }
}
)

leActionTargetValue1 =
(
{
   "attrType":"action",
   "LastTypeValue":"Controller",
   "attrID":4002,
   "branching":1,
   "operators": {
      "Add"                          :{ "val": 304, "branchID": 1 }, 
      "Subtract"                     :{ "val": 306, "branchID": 1 }, 
      "Multiply by"                  :{ "val": 307, "branchID": 2 },
      "Divide by"                    :{ "val": 308, "branchID": 2 },
      "Round by"                     :{ "val": 309, "branchID": 1 },
      "Set Random Values between"    :{ "val": 310, "branchID": 3 },
      "Set to fixed value"           :{ "val": 312, "branchID": 3 },
      "Use Value 2"                  :{ "val": 316, "branchID": 1 },
      "Transpose to Scale"           :{ "val": 314, "branchID": 4 },
      "Mirror"                       :{ "val": 313, "branchID": 3 },
      "Linear Change in Loop Range"  :{ "val": 317, "branchID": 1 },
      "Relative Change in Loop Range":{ "val": 318, "branchID": 1 },
   },
   "branch":{
      "1":{
         "branching": 0,
         "spawns":[
            {
               "name":"UIntValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"UValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"LeUIntValue",
               "isSet":1,
               "hasHeader":1,
               "params":[2,3]
            },
            {
               "name":"LeUIntValue",
               "isSet":1,
               "hasHeader":1,
               "params":[2,4]
            }
         ]
      },
      "2":{
         "branching":0,
         "spawns":[
            {
               "name":"UFloatValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"UValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"LeUFloatValue",
               "isSet":1,
               "hasHeader":1,
               "params":[2,3]
            },
            {
               "name":"LeUFloatValue",
               "isSet":1,
               "hasHeader":1,
               "params":[2]
            }
         ]
      },
      "3":{
         "branching":"LastTypeValue",
         "Note":{
            "branching":"",
            "spawns":[
               {
                  "name":"UValue",
                  "isSet":0,
                  "hasHeader":1,
                  "params":[]
               },
               {
                  "name":"PMidiNoteValue",
                  "isSet":1,
                  "hasHeader":1,
                  "params":[3]
               },
               {
                  "name":"PMidiNoteValue",
                  "isSet":1,
                  "hasHeader":1,
                  "params":[4]
               }
            ]
         },
         "Controller":{
            "branching":"",
            "spawns":[
               {
                  "name":"UValue",
                  "isSet":0,
                  "hasHeader":1,
                  "params":[]
               },
               {
                  "name":"PControllerValue",
                  "isSet":1,
                  "hasHeader":1,
                  "params":[3]
               },
               {
                  "name":"PControllerValue",
                  "isSet":1,
                  "hasHeader":1,
                  "params":[4]
               }
            ]
         },
         "default":{
            "branching":0,
            "spawns":[
               {
                  "name":"UIntValue",
                  "isSet":0,
                  "hasHeader":1,
                  "params":[]
               },
               {
                  "name":"UValue",
                  "isSet":0,
                  "hasHeader":1,
                  "params":[]
               },
               {
                  "name":"LeUIntValue",
                  "isSet":1,
                  "hasHeader":1,
                  "params":[2,3]
               },
               {
                  "name":"LeUIntValue",
                  "isSet":1,
                  "hasHeader":1,
                  "params":[2,4]
               }
            ]
         }
      },
      "4":{
         "branching":0,
         "spawns":[
            {
               "name":"UIntValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"UValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"PMidiKeyValue",
               "isSet":1,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"PMidiKeyValue",
               "isSet":1,
               "hasHeader":1,
               "params":[]
            }
         ]
      }
   }
}
)

for i, attr in JSON_Map
   %attr% := JSON.Parse(%attr%)

msgbox, % leActionTargetValue1.attrType