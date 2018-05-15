/*
    Copyright (c) 2018, Salesforce.org
    All rights reserved.
    
    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
    
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Salesforce.org nor the names of
      its contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.
 
    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
    COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
    ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
    POSSIBILITY OF SUCH DAMAGE.
*/
/**
* @author Salesforce.org
* @date 2018
* @group Gift Entry
* @group-content ../../ApexDocContent/GiftEntry.htm
* @description Tests specific to Gift Entry. 
*/
@isTest
private class GiftEntryFormController_TEST {

    private static String cFirst = 'Testfirst';
    private static String cLast = 'Testlast';
    private static String donationName = 'Test Donation';
    private static Decimal donationAmount = 100;
    
    @testSetup static void setupGiftEntry() {
    	GiftEntryFormController.insertGiftEntrySettings();
    }
    
    @isTest
    private static void runGiftProcess() {
        // TODO: Create or use an existing helper method
        npsp__DataImport__c diObj = new npsp__DataImport__c(
            npsp__Contact1_Firstname__c = cFirst,
            npsp__Contact1_Lastname__c = cLast,
            npsp__Donation_Name__c = donationName,
            npsp__Payment_Method__c = 'Cash',
            npsp__Donation_Date__c = System.today(),
            npsp__Donation_Amount__c = donationAmount
        );
        insert diObj;

        // Test error handling
        Id oppId = GiftEntryFormController.getOpportunityIdFromImport(diObj.Id);
        System.assertEquals(null, oppId);

        GiftEntryFormController ge = new GiftEntryFormController();
        
        Test.startTest();
        GiftEntryFormController.runGiftProcess(diObj.Id);
        Test.stopTest();
        
        List<Opportunity> oppList = [Select Id from Opportunity where Name =: donationName];
        System.assertEquals(1, oppList.size());

        List<Contact> cList = [Select Id from Contact where FirstName =: cFirst and LastName =: cLast];
        System.assertEquals(1, cList.size());

        List<npe01__OppPayment__c> paymentList = [Select Id from npe01__OppPayment__c 
            where npe01__Payment_Amount__c =: donationAmount];
        System.assertEquals(1, paymentList.size());

        // Make sure the Opportunity ID returned is the same as the one created
        oppId = GiftEntryFormController.getOpportunityIdFromImport(diObj.Id);
        System.assertEquals(oppId, oppList[0].Id);

        Map<String,List<String>> picklistValueMap = GiftEntryFormController.getPickListValues();
        System.assert(picklistValueMap.size() > 0);
    }

    @isTest
    private static void runGiftBatch() {
        // TODO: Create or use an existing helper method
        npsp__DataImportBatch__c diBatch = new npsp__DataImportBatch__c(Name = 'Gift Entry Batch');
        insert diBatch;

        insert new npsp__DataImport__c(npsp__NPSP_Data_Import_Batch__c = diBatch.Id,
            npsp__Contact1_Firstname__c = cFirst,
            npsp__Contact1_Lastname__c = cLast,
            npsp__Donation_Name__c = donationName,
            npsp__Payment_Method__c = 'Cash',
            npsp__Donation_Date__c = System.today(),
            npsp__Donation_Amount__c = donationAmount);
        
        // Test error handling
        GiftEntryFormController.runGiftBatch(null);

        Test.startTest();
        GiftEntryFormController.runGiftBatch(diBatch.Id);
        Test.stopTest();
        
        List<Opportunity> oppList = [Select Id from Opportunity where Name =: donationName];
        System.assertEquals(1, oppList.size());

        List<Contact> cList = [Select Id from Contact where FirstName =: cFirst and LastName =: cLast];
        System.assertEquals(1, cList.size());

        List<npe01__OppPayment__c> paymentList = [Select Id from npe01__OppPayment__c 
            where npe01__Payment_Amount__c =: donationAmount];
        System.assertEquals(1, paymentList.size());
    }
    
}