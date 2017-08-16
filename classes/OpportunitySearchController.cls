public with sharing class OpportunitySearchController {
    public String name {get;set;}
    public String accountName {get; set;}
    public List<Opportunity> lstOpportunities {get; set;}
    
    public OpportunitySearchController(){
    	
    }
    
    public void searchOpportunities(){
    	//lstOpportunities = [Select Id, Name, Account.Name from Opportunity where name = :name and Account.Name = :accountName];
    	String query = 'Select Id, Name, Account.Name from Opportunity ';
    	String whereClause = 'where ';
    	if(name != ''){
    		whereClause = whereClause + 'name = \'' + String.escapeSingleQuotes(name) + '\'';
    	}
    	if(accountName != ''){
    		if(whereClause != 'where '){
    			whereClause = whereClause + ' and ';
    		}
    		
    		whereClause = whereClause + 'Account.Name = \'' + String.escapeSingleQuotes(accountName) + '\'';
    	}
    	
    	if(whereClause != 'where '){
    		query = query + whereClause;
    	}
    	
    	system.debug(query);
    	
    	lstOpportunities = Database.query(query);
    }
}