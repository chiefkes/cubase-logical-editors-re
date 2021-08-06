;--------------------------
; Arrays

static PresetFunction_array := {
   (Join,
      "Delete": 0
      "Transform": 1
      "Insert": 2
      "Insert Exclusive": 3
      "Copy": 4
      "Extract": 5
      "Select": 6
   )}

static LEfuncs := [
   (Join,
      "Delete"
      "Transform"
      "Insert"
      "Insert Exclusive"
      "Copy"
      "Extract"
      "Select"
   )]

static PLEfuncs := [
   (Join,
      "Delete"
      "Transform"
      "Select"
   )]

static HLN := {
   (Join
      "leToken"              : "080000006C65546F6B656E",
      "leContextTypeTarget"  : "140000006C65436F6E7465787454797065546172676574",
      "leActionTargetTrackOp": "160000006C65416374696F6E546172676574547261636B4F70",
      "leActionTargetName"   : "130000006C65416374696F6E5461726765744E616D65",
      "leActionTargetTrim"   : "130000006C65416374696F6E5461726765745472696D",
      "leActionTargetColor"  : "140000006C65416374696F6E546172676574436F6C6F72",
      "leActionTargetValue1" : "150000006C65416374696F6E54617267657456616C756531",
      "leActionTargetValue2" : "150000006C65416374696F6E54617267657456616C756532",
      "leActionTargetValue3" : "150000006C65416374696F6E54617267657456616C756533",
      "leActionTargetChannel": "160000006C65416374696F6E5461726765744368616E6E656C",
      "leActionTargetTypes"  : "140000006C65416374696F6E5461726765745479706573",
      "leActionTargetNXPOp"  : "140000006C65416374696F6E5461726765744E58504F70",
      "leActionTargetFloat"  : "140000006C65416374696F6E546172676574466C6F6174",
      "leActionTargetStart"  : "140000006C65416374696F6E5461726765745374617274",
      "leActionTargetLength" : "150000006C65416374696F6E5461726765744C656E677468",
      "leValue1Target"       : "0F0000006C6556616C756531546172676574",
      "leValue2Target"       : "0F0000006C6556616C756532546172676574",
      "leValue3Target"       : "0F0000006C6556616C756533546172676574",
      "leFlagsTarget"        : "0E0000006C65466C616773546172676574",
      "leMediaTypeTarget"    : "120000006C654D6564696154797065546172676574",
      "leContainerTypeTarget": "160000006C65436F6E7461696E657254797065546172676574",
      "leNameTypeTarget"     : "110000006C654E616D6554797065546172676574",
      "leColorTypeTarget"    : "120000006C65436F6C6F7254797065546172676574",
      "leTypesTarget"        : "0E0000006C655479706573546172676574",
      "leChannelTarget"      : "100000006C654368616E6E656C546172676574",
      "leHistoryTarget"      : "100000006C65486973746F7279546172676574",
      "lePositionTarget"     : "110000006C65506F736974696F6E546172676574",
      "leLengthTarget"       : "0F0000006C654C656E677468546172676574",
      "UIntValue"            : "0A00000055496E7456616C7565",
      "UFloatValue"          : "0C00000055466C6F617456616C7565",
      "LeUFloatValue"        : "0E0000004C6555466C6F617456616C7565",
      "UValue"               : "070000005556616C7565",
      "UStringValue"         : "0D00000055537472696E6756616C7565",
      "LeUIntValue"          : "0C0000004C6555496E7456616C7565",
      "LeTTimeValue"         : "0D0000004C655454696D6556616C7565",
      "TTimeValue"           : "0B0000005454696D6556616C7565",
      "TTimeValueBase"       : "0F0000005454696D6556616C756542617365",
      "LeDomainTypeValue"    : "120000004C65446F6D61696E5479706556616C7565",
      "LeTTimeDiffValue"     : "110000004C655454696D654469666656616C7565",
      "TDiffTimeValue"       : "0F000000544469666654696D6556616C7565",
      "PMidiKeyValue"        : "0E000000504D6964694B657956616C7565",
      "PMidiScaleValue"      : "10000000504D6964695363616C6556616C7565",
      "LeGenericOpValue"     : "110000004C6547656E657269634F7056616C7565",
      "LeAllroundValue"      : "100000004C65416C6C726F756E6456616C7565",
      "LeHistoryValue"       : "0F0000004C65486973746F727956616C7565",
      "LEMidiChannelValue"   : "130000004C454D6964694368616E6E656C56616C7565",
      "LeTypeValue"          : "0C0000004C655479706556616C7565",
      "PMidiNoteValue"       : "0F000000504D6964694E6F746556616C7565",
      "PControllerValue"     : "1100000050436F6E74726F6C6C657256616C7565",
      "LeContainerTypeValue" : "150000004C65436F6E7461696E65725479706556616C7565",
      "LeMediaTypeValue"     : "110000004C654D656469615479706556616C7565",
      "LeFlagsValue"         : "0D0000004C65466C61677356616C7565"
   )}

static action_operators := {
   (Join,
      "Add":304
      "Subtract":306
      "Multiply":307
      "Divide":308
      "Round by":309
      "Set Random Values Between":310
      "Set relative random values between":311
      "Set to fixed value":312
      "Mirror":313
      "Transpose to Scale":314
      "Use Value 1":315
      "Use Value 2":316
      "Linear Change in Loop Range":317
      "Relative Change in Loop Range":318
      "Invert":320
      "Add Length":325
      "Replace":326
      "Append":327
      "Prepend":328
      "Generate Name":329
      "Replace Search String":330
      "Folder":331
      "Record":332
      "Monitor":333
      "Solo":334
      "Mute":335
      "Read":337
      "Write":338
      "EQ Bypass":339
      "Inserts Bypass":340
      "Sends Bypass":341
      "Lanes Active":342
      "Hide Track":343
      "Time Domain":344
      "Remove NoteExp":355
      "Reverse":356
      "Create One Shot":357
      "Not Set":359
   )}

static filter_conditions := {
   (Join,
      "Equal":200
      "Unequal":201
      "Bigger":202
      "Bigger or Equal":203
      "Less":204
      "Less or Equal":205
      "Inside Bar Range":206
      "Inside Range":207
      "Outside Bar Range":208
      "Outside Range":209
      "Contains":210
      "Property Is Set":211
      "Property Is Not Set":212
      "Note Is Equal To":213
      "All Types":214
      "Every other Event":215
      "Before Cursor":216
      "Beyond Cursor":217
      "Inside Cycle":218
      "Inside Track Loop":219
      "Exactly Matching Cycle":220
      "Contains Not":221
   )}

static ct_intervals := {
   (Join,
      "Root Note"   : 0
      "Minor Second": 1
      "Major Second": 2
      "Minor Third" : 3
      "Major Third" : 4
      "Fourth"      : 5
      "Dim Fifth"   : 6
      "Fifth"       : 7
      "Aug Fifth"   : 8
      "Sixth"       : 9
      "Min Seventh" : 10
      "Maj Seventh" : 11
   )}

static ct_voices := {
   (Join,
      "Soprano"  : 0
      "Alto"     : 1
      "Tenor"    : 2
      "Bass"     : 3
      "Soprano_2": 4
      "Alto_2"   : 5
      "Tenor_2"  : 6
      "Bass_2"   : 7
   )}

static note_array := {"C":0, "C#":1, "Db":1, "D":2, "D#":3, "Eb":3, "E":4, "F":5, "F#":6
      , "Gb":6, "G":7, "G#":8, "Ab":8, "A":9, "A#":10, "Bb":10, "B":11, "Cb":11}

static scale_array := {
   (Join,
      "Major"           : 0
      "Harmonic Minor"  : 1
      "Melodic Minor"   : 2
      "Blues I"         : 3
      "Pentatonic"      : 4
      "Myxolydic9/11"   : 5
      "Lydic diminished": 6
      "Blues 2"         : 7
      "Major Augmented" : 8
      "Arabian"         : 9
      "Balinese"        : 10
      "Hungarian"       : 11
      "Oriental"        : 12
      "RagaTodi"        : 13
      "Chinese"         : 14
      "Hungarian_2"     : 15
      "Japanese 1"      : 16
      "Japanese 2"      : 17
      "Persian"         : 18
      "Diminished"      : 19
      "Whole Tone"      : 20
      "Blues 3"         : 21
      "Dorian"          : 22
      "Phrygian"        : 23
      "Lydian"          : 24
      "Myxolydian"      : 25
      "Aeolian"         : 26
      "Locrian"         : 27
      "No Scale"        : 28
   )}

static valuetarget_ops := {
   (Join,
      "Equal"           :200
      "Unequal"         :201
      "Bigger"          :202
      "Bigger or Equal" :203
      "Less"            :204
      "Less or Equal"   :205
      "Inside Range"    :207
      "Outside Range"   :209
   )}

static ActionTargetValue_ops := {
   (Join,
      "Add":304
      "Subtract":306
      "Multiply by":307
      "Divide by":308
      "Round by":309
      "Set Random Values between":310
      "Set to fixed value":312
      "Set relative Random Values between":311
      "Use Value 1":315
      "Mirror":313
      "Linear Change in Loop Range":317
      "Relative Change in Loop Range":318
   )}

static FrameRate_array := {
   (Join,
      2 : "555555555555A53F"
      3 : "7B14AE47E17AA43F"
      4 : "7240388C6F15A13F"
      5 : "111111111111A13F"
      6 : "7240388C6F15A13F"
      7 : "111111111111A13F"
      12 : "8E50466FCB5AA53F"
      13 : "554D10751F80A43F"
      14 : "7B14AE47E17A943F"
      15 : "7240388C6F15913F"
      16 : "111111111111913F"
   )}

static LEheader := "<?xml version=""1.0"" encoding=""utf-8""?>"
                 . "`r`n<Logical_EditPreset>"
                 . "`r`n   <int name=""Can Modify"" value=""1""/>"
                 . "`r`n   <bin name=""Preset"">"

static PLEheader := "<?xml version=""1.0"" encoding=""utf-8""?>"
                  . "`r`n<Project_Logical_EditorPreset>"
                  . "`r`n   <int name=""Can Modify"" value=""1""/>"
                  . "`r`n   <bin name=""Preset"">"

static LEfooter := "`r`n   </bin>"
                 . "`r`n</Logical_EditPreset>"

static PLEfooter := "`r`n   </bin>"
                  . "`r`n</Project_Logical_EditorPreset>"