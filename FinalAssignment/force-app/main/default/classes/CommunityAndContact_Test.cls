@isTest
public with sharing class CommunityAndContact_Test {
    
    @testSetup
    //inserting the contacts and account
    static void setupTestData(){
        Account acc = new Account(Name = 'Test');
        insert acc;
        
        List<Contact> conList = new List<Contact>();
        Contact conCorrect = new Contact(FirstName = 'Abcdef', LastName ='Star',Email = 'test@gmail.com', HasOptedOutOfEmail = false,
                                         AccountId = acc.Id);
        Contact conError = new Contact(FirstName = 'Abc', LastName ='Star',Email = 'abc@gmail.com', HasOptedOutOfEmail = false,
                                       AccountId = acc.Id);
        conList.add(conCorrect);
        conList.add(conError);
        insert conList;
    }
    
    @isTest
    //Now checking the createUser functionality with success state
    static void test_createUser(){
        Profile portalProfile = [SELECT Id FROM Profile WHERE Name='Customer Community User' Limit 1];
        //If we want to get permissionSet Id dynamically
        PermissionSet psaToCheck = [SELECT Id,  Name FROM PermissionSet WHERE Name = 'My_Community_Permission_Set' LIMIT 1];
 
        Test.startTest();
        
        Contact con = [SELECT Id, FirstName, LastName FROM Contact WHERE FirstName = 'Abcdef'];
        String communityUserFirstName = CommunityAndContact.createUser(con.Id);
        
        User communityUser = [SELECT ProfileId, Name, FirstName, LastName FROM User WHERE FirstName =  :con.FirstName];
        System.debug(communityUser);
        
        //Asserting whether Profile Id is correctly assigned to user or not
        System.assertEquals(portalProfile.Id, communityUser.ProfileId);
        
        PermissionSetAssignment psa = [SELECT Id, PermissionSetId, PermissionSet.Name, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE PermissionSet.Name = 'My_Community_Permission_Set' AND  Assignee.Name = :communityUser.Name];
        
        //Asserting whether Permission Set is assigned to user or not
        //System.assertEquals('0PS5i000004wjGtGAI', psa.PermissionSetId);
        System.assertEquals(psaToCheck.Id, psa.PermissionSetId);

        Test.stopTest();
        
    }
    
    //Now checking the createUser functionality with failure state
    @isTest
    static void test_createUserCatch(){
        
        Test.startTest();
        
        try{
            Contact con = [SELECT Id, FirstName, LastName FROM Contact WHERE FirstName = 'Abc'];
            String communityUserFirstName = CommunityAndContact.createUser(con.Id);
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('Script-thrown exception'));
        }
        
        Test.stopTest();
        
    }
    
}