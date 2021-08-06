#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.s
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force
SetBatchLines, -1
#Persistent

; static leContextTypeTarget := {
; (Join
;    "attrType": "filter",
;    "branching": false,
;    "operators": {
;       "Equal"          : { "val": 200 }, 
;       "Unequal"        : { "val": 201 }, 
;       "Bigger"         : { "val": 202 },
;       "Bigger or Equal": { "val": 203 },
;       "Less"           : { "val": 204 },
;       "Less or Equal"  : { "val": 205 },
;       "Inside Range"   : { "val": 207 },
;       "Outside Range"  : { "val": 209 }
;    },
;    "branch": {
;       1: {
;          "branching": "",
;          "spawns": [
;             {
;                "name": "leContextTypeTarget_Value",
;                "isSet": true, 
;                "hasHeader": false, 
;                "params": []
;             }
;          ]
;       }
;    }
; )}

sJSON =
(
{
   "attrType":"action",
   "LastTypeValue":"Controller",
   "attrID":4002,
   "branching":1,
   "operators": {
      "Add"                         : { "val": 304, "branchID": 1 }, 
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
               "params":[
                  
               ]
            },
            {
               "name":"UValue",
               "isSet":0,
               "hasHeader":1,
               "params":[
                  
               ]
            },
            {
               "name":"LeUIntValue",
               "isSet":1,
               "hasHeader":1,
               "params":[
                  2,
                  3
               ]
            },
            {
               "name":"LeUIntValue",
               "isSet":1,
               "hasHeader":1,
               "params":[
                  2,
                  4
               ]
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
               "params":[
                  
               ]
            },
            {
               "name":"UValue",
               "isSet":0,
               "hasHeader":1,
               "params":[
                  
               ]
            },
            {
               "name":"LeUFloatValue",
               "isSet":1,
               "hasHeader":1,
               "params":[
                  2,
                  3
               ]
            },
            {
               "name":"LeUFloatValue",
               "isSet":1,
               "hasHeader":1,
               "params":[
                  2
               ]
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
                  "params":[
                     
                  ]
               },
               {
                  "name":"PMidiNoteValue",
                  "isSet":1,
                  "hasHeader":1,
                  "params":[
                     3
                  ]
               },
               {
                  "name":"PMidiNoteValue",
                  "isSet":1,
                  "hasHeader":1,
                  "params":[
                     4
                  ]
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
                  "params":[
                     
                  ]
               },
               {
                  "name":"PControllerValue",
                  "isSet":1,
                  "hasHeader":1,
                  "params":[
                     3
                  ]
               },
               {
                  "name":"PControllerValue",
                  "isSet":1,
                  "hasHeader":1,
                  "params":[
                     4
                  ]
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
                  "params":[
                     
                  ]
               },
               {
                  "name":"UValue",
                  "isSet":0,
                  "hasHeader":1,
                  "params":[
                     
                  ]
               },
               {
                  "name":"LeUIntValue",
                  "isSet":1,
                  "hasHeader":1,
                  "params":[
                     2,
                     3
                  ]
               },
               {
                  "name":"LeUIntValue",
                  "isSet":1,
                  "hasHeader":1,
                  "params":[
                     2,
                     4
                  ]
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
               "params":[
                  
               ]
            },
            {
               "name":"UValue",
               "isSet":0,
               "hasHeader":1,
               "params":[
                  
               ]
            },
            {
               "name":"PMidiKeyValue",
               "isSet":1,
               "hasHeader":1,
               "params":[
                  
               ]
            },
            {
               "name":"PMidiKeyValue",
               "isSet":1,
               "hasHeader":1,
               "params":[
                  
               ]
            }
         ]
      }
   }
}
)

leActionTargetValue1 := JSON.Parse(sJSON)

msgbox, % leActionTargetValue1.attrType

this := leActionTargetValue1
this_attr := leActionTargetValue1
op := "Set to fixed value"

n = 1
TC := A_TickCount
loop, % n {

   if this_attr.branching {
      node := this_attr.branch[this_attr.operators[op].branchID]
      if node.branching
         node := node[this[node.branching]]
   }
   else
      node := this_attr.branch.1
   

   for index, spawn in node.spawns {
      attr := spawn.name
      print(attr, spawn.isSet, spawn.hasHeader, spawn.params*)
      ; would be: this.valueTypeAttr(spawn.name, attr_ID, spawn.isSet, spawn.hasHeader, spawn.params*)  
   }

}
TC1 := ( A_TickCount - TC ) / n
; Msgbox, TC1 = %TC1% ; `n TC2 = %TC2% `n TC3 = %TC3% `n TC4 = %TC4%

; add a hasHeader bool variable for each valueattr
; so hasHeader, isSet, params* 


print(params*) {
   for i, v in params
      string .= v . ", "
   msgbox, % string
   return
}

; class leActionTargetValue1 {
;    static hex_len_name := "150000006C65416374696F6E54617267657456616C756531" ; precomputed to save processing
;    , LastTypeValue := "Note"
;    , attrName := "leActionTargetValue1"
;    , attrType := "action"
;    , attrID := 4002 ; so-called "action_IDs" which is "00000000" for filter attr
;    , branching := true
;    , operators := {
;    (Join
;       "Add": {
;          "val":304,
;          "branchID":"_1"
;       }, 
;       "Multiply by":{
;          "val":307,
;          "branchID":"_1"
;       }, 
;       "Set to fixed value":{
;          "val":312,
;          "branchID":"_2"
;       }
;    )}
;    , branch_1 := {
;    (Join
;       "branching":"",
;       "spawns": [
;          {
;             "name": "UIntValue",
;             "isSet": false, 
;             "hasHeader": true, 
;             "params": []
;          }, 
;          {
;             "name": "UValue",
;             "isSet": false, 
;             "hasHeader": true,
;             "params": []
;          },
;          {
;             "name": "LeUIntValue",
;             "isSet": true,
;             "hasHeader": true,
;             "params": [2, 3]
;          },
;          {
;             "name": "LeUIntValue",
;             "isSet": true,
;             "hasHeader": true,
;             "params": [2, 4]
;          }
;       ]
;    )}
;    , branch_2 := {
;    (Join
;       "branching":"LastTypeValue",
;       "Note": {
;          "branching":"",
;          "spawns": [
;             {
;                "name": "UValue",
;                "isSet": false, 
;                "hasHeader": true, 
;                "params": []
;             },
;             {
;                "name": "PMidiNoteValue",
;                "isSet": true, 
;                "hasHeader": true, 
;                "params": [3]
;             },
;             {
;                "name": "PMidiNoteValue",
;                "isSet": true, 
;                "hasHeader": true, 
;                "params": [4]
;             }
;          ]
;       },
;       "Controller": {
;          "branching": "",
;          "spawns": [
;             {
;                "name": "UValue",
;                "isSet": false, 
;                "hasHeader": true, 
;                "params": []
;             },
;             {
;                "name": "PControllerValue",
;                "isSet": true, 
;                "hasHeader": true, 
;                "params": [3]
;             },
;             {
;                "name": "PControllerValue",
;                "isSet": true, 
;                "hasHeader": true, 
;                "params": [4]
;             }
;          ]
;       },
;       "default": {
;          "branching":"",
;          "spawns": [
;             {
;                "name": "UIntValue",
;                "isSet": false, 
;                "hasHeader": true, 
;                "params": []
;             }, 
;             {
;                "name": "UValue",
;                "isSet": false, 
;                "hasHeader": true,
;                "params": []
;             },
;             {
;                "name": "LeUIntValue",
;                "isSet": true,
;                "hasHeader": true,
;                "params": [2, 3]
;             },
;             {
;                "name": "LeUIntValue",
;                "isSet": true,
;                "hasHeader": true,
;                "params": [2, 4]
;             }
;          ]
;       }
;    )}
; }

valueTypeAttr(attrID, parentAttr, isSet, hasHeader, params*) {
   local
   if hasHeader
      this.bin .= this.attr_header(set_flag, attrID, this.hexLenName[attrID])
   if !isSet
      return
   this[ attrID ]( parentAttr, params* )
}

class LeUFloatValue {
   static hex_len_name := "0E0000004C6555466C6F617456616C7565"
   , length := "0C000000" ; 12
   , content
}

class JSON
{
   static JS := JSON._GetJScriptObject(), true := {}, false := {}, null := {}
   
   Parse(sJson, js := false)  {
      if jsObj := this.VerifyJson(sJson)
         Return js ? jsObj : this._CreateObject(jsObj)
   }
   
   Stringify(obj, js := false, indent := "") {
      if js
         Return this.JS.JSON.stringify(obj, "", indent)
      else {
         sObj := this._ObjToString(obj)
         Return this.JS.eval("JSON.stringify(" . sObj . ",'','" . indent . "')")
      }
   }
   
   GetKey(sJson, key, indent := "") {
      if !this.VerifyJson(sJson)
         Return
      
      try Return this.JS.eval("JSON.stringify((" . sJson . ")" . (SubStr(key, 1, 1) = "[" ? "" : ".") . key . ",'','" . indent . "')")
      catch
         MsgBox, Bad key:`n`n%key%
   }
   
   SetKey(sJson, key, value, indent := "") {
      if !this.VerifyJson(sJson)
         Return
      if !this.VerifyJson(value, true) {
         MsgBox, % "Bad value: " . value                      . "`n"
                 . "Must be a valid JSON string."             . "`n"
                 . "Enclose literal strings in quotes '' or """".`n"
                 . "As an empty string pass '' or """""
         Return
      }
      try {
         res := this.JS.eval( "var obj = (" . sJson . ");"
                            . "obj" . (SubStr(key, 1, 1) = "[" ? "" : ".") . key . "=" . value . ";"
                            . "JSON.stringify(obj,'','" . indent . "')" )
         this.JS.eval("obj = ''")
         Return res
      }
      catch
         MsgBox, Bad key:`n`n%key%
   }
   
   RemoveKey(sJson, key, indent := "") {
      if !this.VerifyJson(sJson)
         Return
      
      sign := SubStr(key, 1, 1) = "[" ? "" : "."
      try {
         if !RegExMatch(key, "(.*)\[(\d+)]$", match)
            res := this.JS.eval("var obj = (" . sJson . "); delete obj" . sign . key . "; JSON.stringify(obj,'','" . indent . "')")
         else
            res := this.JS.eval( "var obj = (" . sJson . ");" 
                               . "obj" . (match1 != "" ? sign . match1 : "") . ".splice(" . match2 . ", 1);"
                               . "JSON.stringify(obj,'','" . indent . "')" )
         this.JS.eval("obj = ''")
         Return res
      }
      catch
         MsgBox, Bad key:`n`n%key%
   }
   
   Enum(sJson, key := "", indent := "") {
      if !this.VerifyJson(sJson)
         Return
      
      conc := key ? (SubStr(key, 1, 1) = "[" ? "" : ".") . key : ""
      try {
         jsObj := this.JS.eval("(" sJson ")" . conc)
         res := jsObj.IsArray()
         if (res = "")
            Return
         obj := {}
         if (res = -1) {
            Loop % jsObj.length
               obj[A_Index - 1] := this.JS.eval("JSON.stringify((" sJson ")" . conc . "[" . (A_Index - 1) . "],'','" . indent . "')")
         }
         else if (res = 0) {
            keys := jsObj.GetKeys()
            Loop % keys.length
               k := keys[A_Index - 1], obj[k] := this.JS.eval("JSON.stringify((" sJson ")" . conc . "['" . k . "'],'','" . indent . "')")
         }
         Return obj
      }
      catch
         MsgBox, Bad key:`n`n%key%
   }
   
   VerifyJson(sJson, silent := false) {
      try jsObj := this.JS.eval("(" sJson ")")
      catch {
         if !silent
            MsgBox, Bad JSON string:`n`n%sJson%
         Return
      }
      Return IsObject(jsObj) ? jsObj : true
   }
   
   _ObjToString(obj) {
      if IsObject( obj ) {
         for k, v in ["true", "false", "null"]
            if (obj = this[v])
               Return v
            
         isArray := true
         for key in obj {
            if IsObject(key)
               throw Exception("Invalid key")
            if !( key = A_Index || isArray := false )
               break
         }
         for k, v in obj
            str .= ( A_Index = 1 ? "" : "," ) . ( isArray ? "" : """" . k . """:" ) . this._ObjToString(v)

         Return isArray ? "[" str "]" : "{" str "}"
      }
      else if !(obj*1 = "" || RegExMatch(obj, "\s"))
         Return obj
      
      for k, v in [["\", "\\"], [A_Tab, "\t"], ["""", "\"""], ["/", "\/"], ["`n", "\n"], ["`r", "\r"], [Chr(12), "\f"], [Chr(08), "\b"]]
         obj := StrReplace( obj, v[1], v[2] )

      Return """" obj """"
   }

   _GetJScriptObject() {
      static doc
      doc := ComObjCreate("htmlfile")
      doc.write("<meta http-equiv=""X-UA-Compatible"" content=""IE=9"">")
      JS := doc.parentWindow
      JSON._AddMethods(JS)
      Return JS
   }

   _AddMethods(ByRef JS) {
      JScript =
      (
         Object.prototype.GetKeys = function () {
            var keys = []
            for (var k in this)
               if (this.hasOwnProperty(k))
                  keys.push(k)
            return keys
         }
         Object.prototype.IsArray = function () {
            var toStandardString = {}.toString
            return toStandardString.call(this) == '[object Array]'
         }
      )
      JS.eval(JScript)
   }

   _CreateObject(jsObj) {
      res := jsObj.IsArray()
      if (res = "")
         Return jsObj
      
      else if (res = -1) {
         obj := []
         Loop % jsObj.length
            obj[A_Index] := this._CreateObject(jsObj[A_Index - 1])
      }
      else if (res = 0) {
         obj := {}
         keys := jsObj.GetKeys()
         Loop % keys.length
            k := keys[A_Index - 1], obj[k] := this._CreateObject(jsObj[k])
      }
      Return obj
   }
}