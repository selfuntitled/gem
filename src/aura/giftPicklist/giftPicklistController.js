({
    handlePicklistChange : function(component, event, helper) {
		// We don't want the default option to overwrite the existing object value
		// Will be needed to enable editing
		var callEvent = component.get("v.callEvent");
		var fieldId = component.get("v.inputFieldId");
		if(!callEvent || !fieldId){
			// We either shouldn't make the update, or there is no field provided
			return;
		}
		var newVal = event.getParam("value");
		var cmpEvent = component.getEvent("giftPicklistChangeEvent");
		cmpEvent.setParams({
			"newValue" : newVal,
			"fieldId" : fieldId
		});
		cmpEvent.fire();
	}
})