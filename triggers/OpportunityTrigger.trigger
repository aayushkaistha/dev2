trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {
    
    system.debug('OpportunityTrigger Begin');
    for(Opportunity opp : trigger.New){
    	system.debug('Current Opportunty Name: ' + opp.Name);
    	system.debug('Current Opportunty Amount: ' + opp.Amount);
    	if(opp.Amount < 100){
    		opp.Amount.addError('Amount must always be greater than $100');
    	}
    }
    system.debug('OpportunityTrigger End');
    
    if(trigger.isAfter){
    	Set<Id> setAccountIds = new Set<Id>();
    	for(Opportunity opp : trigger.New){
    		setAccountIds.add(opp.accountId);
    	}
    	
    	Map<Id, Integer> mapNumAccounts = new Map<Id, Integer>();
    	/*List<Opportunity> lstOppty = [Select Id, accountId From Opportunity where accountId IN :setAccountIds];
    	
    	for(Opportunity opp : lstOppty){
    		Integer numAccounts = mapNumAccounts.get(opp.accountId);
    		if(numAccounts == null){
    			numAccounts = 0;
    		}
    		
    		numAccounts = numAccounts + 1;
    		mapNumAccounts.put(opp.accountId, numAccounts);
    	}
    	
    	for(Opportunity opp : trigger.New){
    		Integer numAccounts = mapNumAccounts.get(opp.accountId);
    		if(numAccounts > 5){
    			opp.addError('Only 5 opportunity is allwed per account');
    		}	
    	}*/
    	
    	List<AggregateResult> lstAgg = [Select accountId, count(Id) opptyCount From Opportunity where accountId IN :setAccountIds group by accountId];
    	for(AggregateResult ar : lstAgg){
    		Integer numOppty = (Integer) ar.get('opptyCount');
    		Id accountId = (Id) ar.get('accountId');
    		mapNumAccounts.put(accountId, numOppty);
    	}
    	
    	for(Opportunity opp : trigger.New){
    		Integer numAccounts = mapNumAccounts.get(opp.accountId);
    		if(numAccounts > 5){
    			opp.addError('Only 5 opportunity is allwed per account');
    		}	
    	}
    }
}