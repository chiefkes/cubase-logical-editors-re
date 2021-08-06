targetTypeAttr(attr_ID) {
   local
   this_attr := this[attr_ID]
   this.bin  .= this.attr_header(1, attr_ID)
   this.bin  .= (this_attr.attrType = "filter") ? "64000000" : "0000"

   if (op := this_attr.operators[this.oLogic[2]].opVal) {
      this.bin .= Int_HexLE( op )
   }
   else {
      Msgbox, target operator not found
      Exit
   }

   this.bin .= (attr_type = "filter") ? "00000000" : Int_HexLE( this.action_IDs[attr_ID] )

   ; could this part be recursive-mapping out of nodes?
   if this_attr.branching
      node := this_attr.branch[this_attr.operators[this.oLogic.2].branchID]
   else
      node := this_attr.branch.1

   if node.branching {
      node := node[this[node.branching]]
   }
   
   for index, spawn in node.spawns {
      this.valueTypeAttr(spawn.name, spawn.hasHeader, spawn.isSet, attr_ID, spawn.params*)  
   }

   ; retrospectively write the attribute length
   this.writeLen_Retro(attr_ID)
}

valueTypeAttr(attrID, hasHeader, isSet, parentAttr, params*) {
   local
   if ( (isSet = false) && (this.attrRecords[attrID].exists = true) )
      return
   if hasHeader
      this.bin .= this.attr_header(isSet, attrID)
   if isSet
      this[ attrID ]( parentAttr, params* )
}