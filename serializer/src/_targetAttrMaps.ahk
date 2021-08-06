; ideas for improving the JSON structure
; - have generic branches to avoid duplication
; - we could skip storing opVals and just lookup in a global operator array
; - could value structs be combined
;  - seperate property called values, each has a conditional property and other identifiers (datatype)
; - could use a short hand for generating these structures...
; have branching: "operation" instead of branching: 1

static action_IDs := {
   (Join,
      "leActionTargetStart":4000
      "leActionTargetLength":4001
      "leActionTargetValue1":4002
      "leActionTargetValue2":4003
      "leActionTargetValue3":4004
      "leActionTargetChannel":4005
      "leActionTargetTypes":4006
      "leActionTargetName":4007
      "leActionTargetTrackOp":4012
      "leActionTargetTrim":4013
      "leActionTargetColor":4014
      "leActionTargetNXPOp":4016
      "leActionTargetFloat":4017
   )}

;---------- GENERIC SPAWNS ----------;

static std_LeUIntValue := [
(Join
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
)]

static std_LeUFloatValue := [
(Join
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
)]

static std_UStringValue := [
(Join
   {
      "name":"UValue",
      "isSet":0,
      "hasHeader":1,
      "params":[]
   },
   {
      "name":"UStringValue",
      "isSet":1,
      "hasHeader":1,
      "params":[3]
   },
   {
      "name":"UIntValue",
      "isSet":0,
      "hasHeader":1,
      "params":[]
   },
   {
      "name":"LeUIntValue",
      "isSet":1,
      "hasHeader":1,
      "params":[2,4]
   }
)]

static std_TDiffTimeValue := [
(Join
   {
      "name":"TDiffTimeValue",
      "isSet":0,
      "hasHeader":1,
      "params":[]
   },
   {
      "name":"TTimeValueBase",
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
      "name":"LeTTimeDiffValue",
      "isSet":1,
      "hasHeader":1,
      "params":[4,3]
   },
   {
      "name":"UIntValue",
      "isSet":0,
      "hasHeader":1,
      "params":[]
   },
   {
      "name":"LeDomainTypeValue",
      "isSet":1,
      "hasHeader":1,
      "params":[]
   }
)]

static std_LeUFloatValue_long := [
(Join
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
      "name":"UIntValue",
      "isSet":0,
      "hasHeader":1,
      "params":[]
   },
   {
      "name":"LeUIntValue",
      "isSet":1,
      "hasHeader":1,
      "params":[2]
   }
)]

static std_PMidiNoteValue := [
(Join
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
)]

static std_PControllerValue := [
(Join
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
)]

static std_LEMidiChannelValue := [
(Join
   {
      "name":"LeUIntValue",
      "isSet":0,
      "hasHeader":1,
      "params":[]
   },
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
      "name":"LEMidiChannelValue",
      "isSet":1,
      "hasHeader":1,
      "params":[3]
   },
   {
      "name":"LEMidiChannelValue",
      "isSet":1,
      "hasHeader":1,
      "params":[4]
   }
)]

;---------- TARGET ATTRIBUTE BLUEPRINTS ----------;


static leActionTargetTrackOp := {
(Join
   "attrType": "action",
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
   "branching": 0,
   "branch": {
      1: {
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
)}

static leActionTargetName := {
(Join
   "attrType":"action",
   "operators": {
      "Replace"              : { "opVal": 326, "branchID": 1 }, 
      "Append"               : { "opVal": 327, "branchID": 1 }, 
      "Prepend"              : { "opVal": 328, "branchID": 1 },
      "Generate Name"        : { "opVal": 329, "branchID": 1 },
      "Replace Search String": { "opVal": 330, "branchID": 2 }
   },
   "branching":1,
   "branch":{
      1:{
         "branching": 0,
         "spawns": PresetSerializer.std_UStringValue
      },
      2:{
         "branching":0,
         "spawns":[
            {
               "name":"UValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"UStringValue",
               "isSet":1,
               "hasHeader":1,
               "params":[3]
            },
            {
               "name":"UStringValue",
               "isSet":1,
               "hasHeader":1,
               "params":[4]
            }
         ]
      }
   }
)}


static leActionTargetTrim := {
(Join
   "attrType": "action",
   "operators": {
      "Multiply by": { "opVal": 307 }, 
      "Divide by"  : { "opVal": 308 }
   },
   "branching": 0,
   "branch": {
      1: {
         "branching": 0,
         "spawns": [
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
               "name":"UIntValue",
               "isSet":0,
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
)}

static leActionTargetColor := {
(Join
   "attrType": "action",
   "operators": {
      "Set to fixed value": { "opVal": 312 }
   },
   "branching": 0,
   "branch": {
      1: {
         "branching": 0,
         "spawns": [
            {
               "name":"UValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"UStringValue",
               "isSet":1,
               "hasHeader":1,
               "params":[3]
            },
            {
               "name":"UIntValue",
               "isSet":0,
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
)}

static leActionTargetValue1 := {
(Join
   "attrType":"action",
   "operators": {
      "Add"                          :{ "opVal": 304, "branchID": 1 }, 
      "Subtract"                     :{ "opVal": 306, "branchID": 1 }, 
      "Multiply by"                  :{ "opVal": 307, "branchID": 2 },
      "Divide by"                    :{ "opVal": 308, "branchID": 2 },
      "Round by"                     :{ "opVal": 309, "branchID": 1 },
      "Set Random Values between"    :{ "opVal": 310, "branchID": 3 },
      "Set to fixed value"           :{ "opVal": 312, "branchID": 3 },
      "Use Value 2"                  :{ "opVal": 316, "branchID": 1 },
      "Transpose to Scale"           :{ "opVal": 314, "branchID": 4 },
      "Mirror"                       :{ "opVal": 313, "branchID": 3 },
      "Linear Change in Loop Range"  :{ "opVal": 317, "branchID": 1 },
      "Relative Change in Loop Range":{ "opVal": 318, "branchID": 1 }
   },
   "branching":1,
   "branch":{
      1:{
         "branching": 0,
         "spawns": PresetSerializer.std_LeUIntValue
      },
      2:{
         "branching":0,
         "spawns": PresetSerializer.std_LeUFloatValue
      },
      3:{
         "branching":"LastTypeValue",
         "Note":{
            "branching":0,
            "spawns": PresetSerializer.std_PMidiNoteValue
         },
         "Controller":{
            "branching":0,
            "spawns": PresetSerializer.std_PControllerValue
         },
         "default":{
            "branching":0,
            "spawns": PresetSerializer.std_LeUIntValue
         }
      },
      4:{
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
)}

static leActionTargetValue2 := {
(Join
   "attrType":"action",
   "branching":1,
   "operators": {
      "Add"                               :{ "opVal": 304, "branchID": 1 }, 
      "Subtract"                          :{ "opVal": 306, "branchID": 1 }, 
      "Multiply by"                       :{ "opVal": 307, "branchID": 2 },
      "Divide by"                         :{ "opVal": 308, "branchID": 2 },
      "Round by"                          :{ "opVal": 309, "branchID": 1 },
      "Set Random Values between"         :{ "opVal": 310, "branchID": 1 },
      "Set to fixed value"                :{ "opVal": 312, "branchID": 1 },
      "Set relative Random Values between":{ "opVal": 311, "branchID": 1 },
      "Use Value 1"                       :{ "opVal": 315, "branchID": 1 },
      "Mirror"                            :{ "opVal": 313, "branchID": 1 },
      "Linear Change in Loop Range"       :{ "opVal": 317, "branchID": 1 },
      "Relative Change in Loop Range"     :{ "opVal": 318, "branchID": 1 }
   },
   "branch":{
      1:{
         "branching": 0,
         "spawns": PresetSerializer.std_LeUIntValue
      },
      2:{
         "branching":0,
         "spawns": PresetSerializer.std_LeUFloatValue
      }
   }
)}

static leActionTargetValue3 := PresetSerializer.leActionTargetValue2

static leActionTargetChannel := {
(Join
   "attrType":"action",
   "branching":1,
   "operators": {
      "Add"                               :{ "opVal": 304, "branchID": 1 }, 
      "Subtract"                          :{ "opVal": 306, "branchID": 1 }, 
      "Set Random Values between"         :{ "opVal": 310, "branchID": 2 },
      "Set to fixed value"                :{ "opVal": 312, "branchID": 2 }
   },
   "branch":{
      1:{
         "branching": 0,
         "spawns": PresetSerializer.std_LeUIntValue
      },
      2:{
         "branching":0,
         "spawns": PresetSerializer.std_LEMidiChannelValue
      }
   }
)}

static leActionTargetTypes := {
(Join
   "attrType": "action",
   "branching": 0,
   "operators": {
      "Set to fixed value": { "opVal": 312 }
   },
   "branch": {
      1: {
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
               "name":"LeTypeValue",
               "isSet":1,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"LeUIntValue",
               "isSet":1,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"nullspawn",
               "isSet":1,
               "hasHeader":0,
               "params":[]
            }
         ]
      }
   }
)}

; Could be std_LeUIntValue here (does the lack of attr_val matter?)
static leActionTargetNXPOp := {
(Join
   "attrType":"action",
   "branching":1,
   "operators": {
      "Remove NoteExp" : { "opVal": 355, "branchID": 1 }, 
      "Create One-Shot": { "opVal": 357, "branchID": 2 }, 
      "Reverse"        : { "opVal": 356, "branchID": 1 }
   },
   "branch":{
      1:{
         "branching": 0,
         "spawns": PresetSerializer.std_LeUIntValue
      },
      2:{
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
               "name":"LeTypeValue",
               "isSet":1,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"LeUIntValue",
               "isSet":1,
               "hasHeader":1,
               "params":[2]
            }
         ]
      }
   }
)}

static leActionTargetFloat := {
(Join
   "attrType": "action",
   "branching": 0,
   "operators": {
      "Add"                               :{ "opVal": 304 }, 
      "Subtract"                          :{ "opVal": 306 }, 
      "Multiply by"                       :{ "opVal": 307 },
      "Divide by"                         :{ "opVal": 308 },
      "Invert"                            :{ "opVal": 320 },
      "Set Random Values between"         :{ "opVal": 310 },
      "Set to fixed value"                :{ "opVal": 312 },
      "Set relative Random Values between":{ "opVal": 311 }
   },
   "branch": {
      1: {
         "branching": 0,
         "spawns": [
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
               "params":[2,4]
            }
         ]
      }
   }
)}

static leActionTargetStart := {
(Join
   "attrType":"action",
   "branching":1,
   "operators": {
      "Add"                               :{ "opVal": 304, "branchID": 1 }, 
      "Subtract"                          :{ "opVal": 306, "branchID": 1 }, 
      "Multiply by"                       :{ "opVal": 307, "branchID": 2 },
      "Divide by"                         :{ "opVal": 308, "branchID": 2 },
      "Round by"                          :{ "opVal": 309, "branchID": 3 },
      "Set relative random values between":{ "opVal": 311, "branchID": 3 },
      "Set to fixed value"                :{ "opVal": 312, "branchID": 4 }
   },
   "branch":{
      1:{
         "branching": 0,
         "spawns": PresetSerializer.std_TDiffTimeValue
      },
      2:{
         "branching":0,
         "spawns": PresetSerializer.std_LeUFloatValue_long
      },
      3:{
         "branching":0,
         "spawns": PresetSerializer.std_LeUIntValue
      },
      4:{
         "branching":0,
         "spawns":[
            {
               "name":"TTimeValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"TTimeValueBase",
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
               "name":"LeTTimeValue",
               "isSet":1,
               "hasHeader":1,
               "params":[4,3]
            },
            {
               "name":"UIntValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"LeDomainTypeValue",
               "isSet":1,
               "hasHeader":1,
               "params":[]
            }
         ]
      }
   }
)}

static leActionTargetLength := {
(Join
   "attrType":"action",
   "branching":1,
   "operators": {
      "Add"                               :{ "opVal": 304, "branchID": 1 }, 
      "Subtract"                          :{ "opVal": 306, "branchID": 1 }, 
      "Multiply by"                       :{ "opVal": 307, "branchID": 2 },
      "Divide by"                         :{ "opVal": 308, "branchID": 2 },
      "Round by"                          :{ "opVal": 309, "branchID": 3 },
      "Set Random Values Between"         :{ "opVal": 310, "branchID": 3 },
      "Set relative random values between":{ "opVal": 311, "branchID": 3 },
      "Set to fixed value"                :{ "opVal": 312, "branchID": 1 }
   },
   "branch":{
      1:{
         "branching": 0,
         "spawns": PresetSerializer.std_TDiffTimeValue
      },
      2:{
         "branching":0,
         "spawns": PresetSerializer.std_LeUFloatValue_long
      },
      3:{
         "branching":0,
         "spawns": PresetSerializer.std_LeUIntValue
      }
   }
)}

;--------------------------
; FilterTarget Attributes

static leValue1Target := {
(Join
   "attrType":"filter",
   "operators": {
      "Equal"           :{ "opVal": 200 }, 
      "Unequal"         :{ "opVal": 201 }, 
      "Bigger"          :{ "opVal": 202 },
      "Bigger or Equal" :{ "opVal": 203 },
      "Less"            :{ "opVal": 204 },
      "Less or Equal"   :{ "opVal": 205 },
      "Inside Range"    :{ "opVal": 207 },
      "Outside Range"   :{ "opVal": 209 }
   },
   "branching":0,
   "branch":{
      1:{
         "branching":"LastTypeValue",
         "Note":{
            "branching":0,
            "spawns": PresetSerializer.std_PMidiNoteValue
         },
         "Controller":{
            "branching":0,
            "spawns": PresetSerializer.std_PControllerValue
         },
         "default":{
            "branching":0,
            "spawns": PresetSerializer.std_LeUIntValue
         }
      }
   }
)}

static leValue2Target := {
(Join
   "attrType":"filter",
   "operators": PresetSerializer.leValue1Target.operators,
   "branching":0,
   "branch":{
      1:{
         "branching": 0,
         "spawns": PresetSerializer.std_LeUIntValue
      }
   }
)}

static leValue3Target := PresetSerializer.leValue2Target

static leFlagsTarget := {
(Join
   "attrType": "filter",
   "operators": {
      "Property is set"     : { "opVal": 211 }, 
      "Property is not set" : { "opVal": 212 }
   },
   "branching": 0,
   "branch": {
      1: {
         "branching": 0,
         "spawns": [
            {
               "name":"LeUIntValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
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
               "name":"LeFlagsValue",
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
)}

static leMediaTypeTarget := {
(Join
   "attrType": "filter",
   "operators": {
      "Equal"     :{ "opVal": 200 }, 
      "Unequal"   :{ "opVal": 201 },
      "All Types" :{ "opVal": 214 }
   },
   "branching": 0,
   "branch": {
      1: {
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
               "name":"LeMediaTypeValue",
               "isSet":1,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"LeUIntValue",
               "isSet":1,
               "hasHeader":1,
               "params":[2]
            }
         ]
      }
   }
)}

static leContainerTypeTarget := {
(Join
   "attrType": "filter",
   "operators": {
      "Equal"     :{ "opVal": 200 }, 
      "Unequal"   :{ "opVal": 201 },
      "All Types" :{ "opVal": 214 }
   },
   "branching": 0,
   "branch": {
      1: {
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
               "name":"LeContainerTypeValue",
               "isSet":1,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"LeUIntValue",
               "isSet":1,
               "hasHeader":1,
               "params":[2]
            }
         ]
      }
   }
)}

static leNameTypeTarget := {
(Join
   "attrType": "filter",
   "operators": {
      "Equal"       :{ "opVal": 200 }, 
      "Contains"    :{ "opVal": 210 }, 
      "Contains not":{ "opVal": 221 }
   },
   "branching": 0,
   "branch": {
      1: {
         "branching": 0,
         "spawns": PresetSerializer.std_UStringValue
      }
   }
)}

static leColorTypeTarget := {
(Join
   "attrType": "filter",
   "operators": PresetSerializer.leNameTypeTarget.operators,
   "branching": 0,
   "branch": {
      1: {
         "branching": 0,
         "spawns": [
            {
               "name":"UValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"UStringValue",
               "isSet":1,
               "hasHeader":1,
               "params":[3]
            },
            {
               "name":"nullspawn",
               "isSet":1, 
               "hasHeader":0, 
               "params":[]
            }
         ]
      }
   }
)}

static leChannelTarget := {
(Join
   "attrType":"filter",
   "branching":0,
   "operators": PresetSerializer.leValue1Target.operators,
   "branch":{
      1:{
         "branching":0,
         "spawns": PresetSerializer.std_LEMidiChannelValue
      }
   }
)}

static leHistoryTarget := {
(Join
   "attrType":"filter",
   "operators": {
      "Equal"             :{ "opVal": 200 }, 
      "Unequal"           :{ "opVal": 201 }, 
      "Bigger"            :{ "opVal": 202 },
      "Bigger or Equal"   :{ "opVal": 203 },
      "Less"              :{ "opVal": 204 },
      "Less or Equal"     :{ "opVal": 205 },
      "Every other Event" :{ "opVal": 215 }
   },
   "branching":0,
   "branch":{
      1:{
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
               "name":"LeHistoryValue",
               "isSet":1,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"LeUIntValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"LeAllroundValue",
               "isSet":1,
               "hasHeader":1,
               "params":[]
            }
         ]
      }
   }
)}

static lePositionTarget := {
(Join
   "attrType":"filter",
   "branching":1,
   "operators": {
      "Equal"                  :{ "opVal": 200, "branchID": 1 }, 
      "Unequal"                :{ "opVal": 201, "branchID": 1 }, 
      "Bigger"                 :{ "opVal": 202, "branchID": 1 },
      "Bigger or Equal"        :{ "opVal": 203, "branchID": 1 },
      "Less"                   :{ "opVal": 204, "branchID": 1 },
      "Less or Equal"          :{ "opVal": 205, "branchID": 1 },
      "Inside Bar Range"       :{ "opVal": 206, "branchID": 2 },
      "Inside Range"           :{ "opVal": 207, "branchID": 1 },
      "Outside Bar Range"      :{ "opVal": 208, "branchID": 2 },
      "Outside Range"          :{ "opVal": 209, "branchID": 1 },
      "Before Cursor"          :{ "opVal": 216, "branchID": 1 },
      "Beyond Cursor"          :{ "opVal": 217, "branchID": 1 },
      "Inside Cycle"           :{ "opVal": 218, "branchID": 1 },
      "Inside Track Loop"      :{ "opVal": 219, "branchID": 1 },
      "Exactly Matching Cycle" :{ "opVal": 220, "branchID": 1 }
   },
   "branch":{
      1:{
         "branching":0,
         "spawns":[
            {
               "name":"TTimeValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"TTimeValueBase",
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
               "name":"LeTTimeValue",
               "isSet":1,
               "hasHeader":1,
               "params":[5,3]
            },
            {
               "name":"LeTTimeValue",
               "isSet":1,
               "hasHeader":1,
               "params":[5,4]
            }
         ]
      },
      2:{
         "branching":0,
         "spawns": PresetSerializer.std_LeUIntValue
      }
   }
)}

static leLengthTarget := {
(Join
   "attrType":"filter",
   "branching":0,
   "operators": PresetSerializer.leValue1Target.operators,
   "branch":{
      1:{
         "branching":0,
         "spawns":[
            {
               "name":"TDiffTimeValue",
               "isSet":0,
               "hasHeader":1,
               "params":[]
            },
            {
               "name":"TTimeValueBase",
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
               "name":"LeTTimeDiffValue",
               "isSet":1,
               "hasHeader":1,
               "params":[5,3]
            },
            {
               "name":"LeTTimeDiffValue",
               "isSet":1,
               "hasHeader":1,
               "params":[5,4]
            }
         ]
      }
   }
)}

static leContextTypeTarget := {
(Join
   "attrType": "filter",
   "branching": 0,
   "operators": {
      "Equal"          : { "opVal": 200 }, 
      "Unequal"        : { "opVal": 201 }, 
      "Bigger"         : { "opVal": 202 },
      "Bigger or Equal": { "opVal": 203 },
      "Less"           : { "opVal": 204 },
      "Less or Equal"  : { "opVal": 205 },
      "Inside Range"   : { "opVal": 207 },
      "Outside Range"  : { "opVal": 209 }
   },
   "branch": {
      1: {
         "branching": 0,
         "spawns": [
            {
               "name": "leContextTypeTarget_Value",
               "isSet": 1, 
               "hasHeader": 0, 
               "params": []
            }
         ]
      }
   }
)}

static leTypesTarget := {
(Join
   "attrType": "filter",
   "branching": 0,
   "operators": {
      "Equal"    : { "opVal": 200 }, 
      "Unequal"  : { "opVal": 201 }, 
      "All Types": { "opVal": 214 }
   },
   "branch": {
      1: {
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
               "name":"LeTypeValue",
               "isSet":1, 
               "hasHeader":1, 
               "params":[]
            },
            {
               "name":"LeUIntValue",
               "isSet":1, 
               "hasHeader":1, 
               "params":[]
            },
            {
               "name":"nullspawn",
               "isSet":1, 
               "hasHeader":0, 
               "params":[]
            }
         ]
      }
   }
)}