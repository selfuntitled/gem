({
	doInit: function(component, event, helper) {
		// Add the new item to the related array
		helper.addRowHelper(component);
	},
	clickDeleteRow: function(component, event, helper) {
        // Can't fully remove because array index numbers after this one would be wrong
		var rowIdentifier = component.get("v.rowNum");
		var rowList = component.get("v.rowList");
		rowList[rowIdentifier] = null;
		component.destroy();
	},
	checkValidation: function(component, event, helper) {
		var isValid = helper.validateRow(component, helper);
		return isValid;
	},
	handleAmountChange: function(component, event, helper) {
		helper.amountChanged(component, event, helper);
	},
	handleAmountCheck: function(component, event, helper) {
		helper.amountCheck(component, event, helper);
	}
})