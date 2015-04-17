public with sharing class TBN_OpportunityProductCotroller 
{    
    private map<Id, Set<Answer__c>> mapProductToAnswerSet {get;set;}
    public map<Id, String> mapProductIdName{get;set;}
    private map<Id, Set<Id>> mapProductIdQuestion {get;set;}
    public map<Id, Question__c> mapIdQuestion {get;set;} 
    public Answer__c ans {get;set;} 
	public Question__c quest {get;set;}
    public map<Product2, List<wrapclass>> mapProductIdQA{get;set;}
    private map<Id , Answer__c> mapQueAns{get;set;} 
    public List<wrapclass> LstWrapper{get;set;}
    public Id OpporID {get;set;}
    public Product_Group__c prductgrp {get;set;}
    //public List<Product_Group__c> prductgrp{get;set;}  
    
     
   /*
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
		} */
		public TBN_OpportunityProductCotroller(ApexPages.StandardController Control)
		{
		     mapProductIdName = new map<Id, String>();		
		     mapIdQuestion = new map<id, Question__c>();
			 OpporID = Control.getId();  
			 mapProductIdQA = new map<Product2 , List<wrapclass>>();
			 mapQueAns = new map<Id, Answer__c>();
       		 LstWrapper = new List<wrapclass>();
       		 //prductgrp = [SELECT Name FROM Product_Group__c Limit 1 ];
       		quest = [SELECT Questions__c, picklist_values__c FROM Question__c Limit 1 ];
       		
       		 //ans = [SELECT myquestion__c FROM Answer__c ];
       		 
			 fetchAQ();
			 
		}
   
   
	/*public TBN_OpportunityProductCotroller(ApexPages.StandardController Ctrl)
	{
		 //stdCntrlr = Ctrl;
	     OpporID = Ctrl.getId();  
	     fetchAQ();
	}*/
    /*private map<Id, String> mapIdProductName {get;set;}
	public Q_A__c newQA {get;set;}
	public OpportunityLineItem lineitem {get;set;}      
	public Product2 prduct {get;set;}
	
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
			 List<id> OpporIDs = new List<id>();
			 for (opportunityLineItem lineitem : olis)
			 {
	        	OpporIDs.add(lineitem.OpportunityId);
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
		
	 }*/
	 private void fetchAQ()
	 {
	     set<Id> setPRGroup = new set<Id>();
	     
	     for(OpportunityLineItem objOppLineItem : [Select Id, Product2Id, Product2.Name, Product2.Product_Group__c from OpportunityLineItem where OpportunityId =:OpporID ])
	     {
	         mapProductIdName.put(objOppLineItem.Product2Id , objOppLineItem.Product2.Name);
	         setPRGroup.add(objOppLineItem.Product2.Product_Group__c);
	     }
	     
	     //map<Id, Question__c> mapIdQuestion = new map<Id , Question__c>();
	     for(Question__c obQuest : [Select Id,Name, Questions__c, AnsTypes__c from Question__c where Product_Groups__c =: setPRGroup])
	     {
	         mapIdQuestion.put(obQuest.id, obQuest);   
	         setPRGroup.add(obQuest.id);  
	         
	     }
	     
	     
	     //Set<Id> idSet = new Set<Id>();
		//Map<Id,Question__c> mapIdToObj = new Map<Id, Question__c>([select Id, Name, Questions__c FROM Question__c ]);
		//mapIdToObj.get(Id).Questions__c;
		
	     
	     
	     for(Answer__c obAns : [Select Id, Answers__c, No__c, Picklist_ans__c, Product__c, myquestion__c, Yes__c from Answer__c where (Question__c IN :mapIdQuestion.keySet() AND Opportunity__c =: OpporID)])
         {
            if(!mapProductToAnswerSet.containsKey(obAns.Product__c))
            {
                mapProductToAnswerSet.put(obAns.Product__c , new set<Answer__c>{obAns});
            }
            if(mapProductIdQuestion.containsKey(obAns.Product__c))
            {
                mapProductIdQuestion.put(obAns.Product__c , new set<Id>{obAns.myquestion__c});
            }
            mapProductToAnswerSet.get(obAns.Product__c).add(obAns);
            mapProductIdQuestion.get(obAns.Product__c).add(obAns.myquestion__c);
         }
         
	 }
	 
	 public string selectedValue {get;set;}   
     public PageReference test() {
     	
        if(selectedValue == 'Yes'){
        	
        	//Answer__c objAns = new Answer__c(Yes__c == true); 
        //logic here
        } else if (selectedValue == 'No'){
        	//Answer__c.No__c = true;
        // logic here
        } return null;
    }
                
    	public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options; 
    }   
    public void InsertAnswers()
	{
	    List<Answer__c> ListInsertAns = new List<Answer__c>();
	    for(Id objProductID : mapProductIdName.keySet())
	    {
	        for(Id QID : mapIdQuestion.keySet())
	        {
	            if(!mapProductToAnswerSet.containsKey(objProductID))
	            {
	                ListInsertAns.add(new Answer__c(Product__c = objProductID, Question__c = QID, Opportunity__c = OpporID));
	            }
	            else
	            {
	                if(!mapProductIDQuestion.get(objProductID).contains(QID))
	                {
	                    ListInsertAns.add(new Answer__c(Product__c = objProductID, Question__c = QID, Opportunity__c = OpporID));
	                }
	            }
	        }
	    }
    if(!ListInsertAns.isEmpty())
        insert ListInsertAns;
}

     public class wrapclass
     {
         public String strQuest {get;set;}
         public Boolean isComment {get;set;}
         public Boolean isPicklist {get;set;}
         public Boolean isCheckbox {get;set;}
         public String strComment {get;set;}
         public Boolean isYes {get;set;}
         public Boolean isNo {get;set;}
         public String strPicklist {get;set;}
         
         public wrapclass(String strQuest, String strComment, Boolean isYes, Boolean isNO, String isPicklist, String strAnsType)
         {
             this.isComment=false;
             this.isPicklist=false;
             this.isCheckbox=false;
         }
     }
    
}