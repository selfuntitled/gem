({
    doInit: function(component, event, helper) {
        var recordId = component.get('v.recordId');
        // Get the data model class for the form
        // Includes picklist options, field labels, and objects if loading an existing record
        helper.getDonationInformation(component, helper, recordId);

        // Set the namespace var so components load in managed package
        var namespace = component.getType().split(':')[0];
        component.set('v.namespacePrefix', namespace);
        if(namespace != 'c'){
            component.set('v.namespaceFieldPrefix', namespace+'__');
        }
    },
    handleFieldChange: function(component, event, helper){
        // Each time a required input changes, check validation
        helper.checkValidation(component);
    },
    handleLookupChange: function(component, event, helper){
        // When a lookup field change, we may need to check for data matches using that value
        // var newVal = event.getParam('value');
        // var oldVal = event.getParam('oldValue');
        // console.log(newVal + ' was: ' + oldVal);
        // console.log('Run Match Check');

        helper.checkMatches(component);
        helper.checkValidation(component);
    },
    clickEditDonor: function(component, event, helper) {
        var donorType = component.get('v.di.npsp__Donation_Donor__c');
        var donorId;
        if(donorType == 'Account1'){
            donorId = component.get('v.di.npsp__Account1Imported__c');
        } else {
            donorId = component.get('v.di.npsp__Contact1Imported__c');
        }
        helper.showEditRecordModal(component, donorId);
    },
    clickCreate: function(component, event, helper) {
        component.set('v.showSpinner', true);
        var validForm = helper.validateForm(component, true);

        // If we pass validation, submit the form
        if(validForm){
            // Fill in the JSON data field
            var jsonIsValid = helper.fillJsonField(component);
            if(jsonIsValid){
                component.set('v.submitError', '');
                helper.handleSaveGift(component);
            } else {
                helper.showErrorMessage(component, $A.get('$Label.c.Gift_Form_Error'), true);
            }
        } else {
            // Did not pass validation, show generic error if no other one has been set
            if(!component.get('v.submitError')){
                helper.showErrorMessage(component, $A.get('$Label.c.Gift_Form_Error'), true);
            }
        }
    },
    clickCancel: function(component, event, helper) {
        // TODO: Clear the form? Close a modal?
        console.log('Do Cancel');
    },
    handleCheckMatches: function(component, event, helper) {
        // The form should send its current information and check for data matches
        var isEditMode = component.get('v.editMode');

        var newVal = event.getParam('value');
        // console.log(newVal); 
        if(!newVal || isEditMode){
            return;
        }

        // console.log('Checking Matches'); 
        helper.checkMatches(component);
    },
    clickBackToForm: function(component, event, helper){
        component.set('v.showForm', true);
        component.set('v.showSuccess', false);
        helper.scrollToTop();
    },
    handleDonorTypeChange: function(component, event, helper){
        var donorType = event.getParam('value');
        // Need to clear the other donor fields
        if(donorType == 'Account1'){
            helper.clearInputs(component, 'contactLookup');
        } else if(donorType == 'Contact1'){
            helper.clearInputs(component, 'accountLookup');
        }
    },
    handleMessage: function(component, event, helper){
        var message = event.getParam('message');
        var channel = event.getParam('channel');

        if(channel == 'picklistChangeEvent'){
            helper.handlePicklistChange(component, message);
        } else if(channel == 'matchChangeEvent'){
            helper.handleMatchChange(component, message, helper);
        }
    },
    clickMarkPaymentPaid: function(component, event, helper) {
        var paymentId = component.get('v.payment.Id');
        helper.setPaymentPaid(component, paymentId);
    },
    expandTributeSection: function(component, event, helper) {
        helper.doToggleSection(component, 'expandTribute');
    },
    expandMatchingSection: function(component, event, helper) {
        helper.doToggleSection(component, 'expandMatching');
    }
})