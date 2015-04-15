public with sharing class TBN_OpportunityProductCotroller 
{
	public Q_A__c newQA {get;set;}
	public OpportunityLineItem lineitem {get;set;}
	public Product2 prduct {get;set;}
	public Answer__c ans {get;set;}
	public Question__c quest {get;set;}
	public ApexPages.StandardSetController setCon 
		{ 
			get 
			{
				if(setCon == null) 
				{
					setCon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Name, Type, Amount, CloseDate FROM Opportunity]));
					setCon.setPageSize(5);
				}
				return setCon;
			}
			set;
		}
		public List<Opportunity> getOpportunities() 
		{ 
			return (List<Opportunity>) setCon.getRecords();
		}
		public TBN_OpportunityProductCotroller()
		{
			 List<OpportunityLineItem> olis = new List<OpportunityLineItem>([SELECT OpportunityId, Product2Id FROM OpportunityLineItem]);
			 List<id> oppids = new List<id>();
			 for (opportunityLineItem lineitem : olis)
			 {
	        	oppIds.add(lineitem.OpportunityId);
	    	 } 
	    	 
	    	 List<Product2> productgroup = [SELECT Id, Product_Group__c FROM Product2 ];
	    	 List<id> pgid = new List<id>();
	    	 for (Product2 prduct : productgroup)
			 {
	        	pgid.add(prduct.Product_Group__c);
	    	 }  
	    	  List<Question__c> qtn = new List<Question__c>([SELECT Id,Questions__c, AnsTypes__c, picklist_values__c, Product_Groups__c FROM Question__c]);
	    	  // map<Product2Id, List<Question__c>> fldval = map<Product2Id, List<Question__c>>();
	    	 
		}
		public PageReference save() 
		 {   
	            try{
	                insert ans;
	                }catch(exception e){
	                }
	                PageReference page = new Pagereference('/'+ans.Id);
	            page.setRedirect(true);
	            return page;
	     }
		public Pagereference cancel(){
	       PageReference newpage = new Pagereference('/apex/TBN_OpportunityProductVF?Id='+ans.Id);
	       newpage.setRedirect(true);
	       return newpage;
	 }
}