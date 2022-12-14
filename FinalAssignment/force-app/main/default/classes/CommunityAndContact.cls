public  class CommunityAndContact {
    
    @AuraEnabled
    public static String createUser(Id recordId){
        try {
            //Getting profile Id
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name='Customer Community User' Limit 1];
            
            Contact con = [SELECT FirstName, LastName, EMail, HasOptedOutOfEmail FROM Contact WHERE Id = :recordId ];
 
            //creating new user with details of contact which is associated with some account with  contact's email not null
            User communityUser = new User(
            ProfileId = portalProfile.Id,
            Username = con.Email,
            ContactId = con.Id,
            Alias = 'sfdc',
            CommunityNickname = con.FirstName+' '+con.LastName,
            Email = con.Email,
            EmailEncodingKey = 'UTF-8',
            Firstname = con.FirstName,
            Lastname = con.LastName,
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            isActive = true
            );
 
            Database.insert(communityUser);
            //0PS5i000004wjGtGAI is the permissionSet Id having name My Community Permission Set
            //If we want to get permissionSet Id dynamically
            PermissionSet psToAssign = [SELECT Id,  Name FROM PermissionSet WHERE Name = 'My_Community_Permission_Set' LIMIT 1];
 
            //PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = '0PS5i000004wjGtGAI', AssigneeId = communityUser.Id);
            PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = psToAssign.Id, AssigneeId = communityUser.Id);

            insert psa;
            return communityUser.FirstName;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
 
}