@isTest
private class TBN_OpportunityProductController_Test {

	private static testMethod void test() 
	{
        List<Product_Group__c> lstProductGroupToInsert = new List<Product_Group__c>();
         Product_Group__c objProduct1 = new Product_Group__c(Name='Test Product Group 1');
         Product_Group__c objProduct2 = new Product_Group__c(Name='Test Product Group 2');
         lstProductGroupToInsert.add(objProduct1);
         lstProductGroupToInsert.add(objProduct2);
        insert lstProductGroupToInsert;
        
        List<Question__c> lstQuestionsToInsert = new List<Question__c>();
        Question__c objQuest1 = new Question__c(Questions__c='Test Question 1', Product_Groups__c = lstProductGroupToInsert[0].Id, AnsTypes__c='Comment'); 
        Question__c objQuest2 = new Question__c(Questions__c='Test Question 2', Product_Groups__c = lstProductGroupToInsert[1].Id, AnsTypes__c='Comment');
	    lstQuestionsToInsert.add(objQuest1);
	    lstQuestionsToInsert.add(objQuest2);
	    insert lstQuestionsToInsert;
	    
	    List<Product2> lstProductToInsert = new List<Product2>();
	    Product2 objProd1 = new Product2(Name = 'Test Product 1', Product_Group__c = lstProductGroupToInsert[0].Id);
	    Product2 objProd2 = new Product2(Name = 'Test Product 2', Product_Group__c = lstProductGroupToInsert[1].Id);
	    lstProductToInsert.add(objProd1);
	    lstProductToInsert.add(objProd2);
	    insert lstProductToInsert;
	    
	    Pricebook2 objPriceBook = new Pricebook2(Name='Test Pricebook' , isActive=true);
	    insert objPriceBook;
	    
	    List<PricebookEntry> lstPriceBookEntryToInsert = new List<PricebookEntry>(); 
	    PricebookEntry objPriceBk1 = new PricebookEntry(Pricebook2Id=objPriceBook.Id, Product2Id=lstProductToInsert[0].Id,isActive=true, UnitPrice=40, UseStandardPrice = true);
	    PricebookEntry objPriceBk2 = new PricebookEntry(Pricebook2Id=objPriceBook.Id, Product2Id=lstProductToInsert[1].Id,isActive=true, UnitPrice=50, UseStandardPrice = false);
	    lstPriceBookEntryToInsert.add(objPriceBk1);
	    lstPriceBookEntryToInsert.add(objPriceBk2);
	    insert lstPriceBookEntryToInsert;
	   
	    Opportunity objOppor = new Opportunity(Name='Test Opportunity 1', StageName='Closed Won', CloseDate=date.today());
	    insert objOppor;
	    
	    List<OpportunityLineItem> lstOLItoInsert = new List<OpportunityLineItem>();
	    OpportunityLineItem objOpporLI1 =  new OpportunityLineItem(OpportunityId=objOppor.Id, PricebookEntryId = lstPriceBookEntryToInsert[0].Id, Quantity = 40);
	    OpportunityLineItem objOpporLI2 =  new OpportunityLineItem(OpportunityId=objOppor.Id, PricebookEntryId = lstPriceBookEntryToInsert[1].Id, Quantity = 50);
	    lstOLItoInsert.add(objOpporLI1);
	    lstOLItoInsert.add(objOpporLI2);
	    insert lstOLItoInsert;
	         
        ApexPages.StandardController sc = new ApexPages.StandardController(objOppor);
        PageReference pageRef = Page.TBN_OpportunityProductVF;
        pageRef.getParameters().put('id', String.valueOf(objOppor.Id));
        TBN_OpportunityProductCotroller objControllerInstancee = new TBN_OpportunityProductCotroller(sc);
	    }
}