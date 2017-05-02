public with sharing class CheckListClientController
{
	public List<CheckList__c> results {get; set;}

	private Itinerary__c itinerary;
	private @TestVisible Id checklistId;

	public CheckListClientController(Apexpages.StandardController controller)
	{
		itinerary = (Itinerary__c)controller.getRecord();

		results = new List<CheckList__c>([
				SELECT Short_Description__c, Full_Description__c, Done__c, Order__c, Itinerary__c
				FROM CheckList__c
				WHERE Itinerary__c = :itinerary.Id
				  ORDER BY Order__c]);
	}

	public void doChangeCheckBox()
	{
		if (!Test.isRunningTest())
		{
			checklistId = ApexPages.currentPage().getParameters().get('checklistId');
		}
		CheckList__c checklistToUpdate;
		for (CheckList__c checklist : results)
		{
			if (checklist.Id == checklistId)
			{
				checklistToUpdate = checklist;
			}
		}
		if (checklistToUpdate != null)
		{
			try
			{
				update checklistToUpdate;

			} catch (DmlException e)
			{
				System.debug('Some DML Exception has occurred: ' + e.getMessage());
			}
		}
	}

	/*@TestVisible
	private List<CheckList__c> sortMethod(List<CheckList__c> results)
	{
		for (Integer barrier = 0; barrier < results.size() - 1; barrier++)
		{
			for (Integer i = barrier + 1; i < results.size(); i++)
			{
				if (results.get(i).Order__c < results.get(barrier).Order__c)
				{
					Integer tmp = Integer.valueOf(results.get(i).Order__c);
					results.get(i).Order__c = results.get(barrier).Order__c;
					results.get(barrier).Order__c = tmp;
				}
			}
		}
		return results;
	}*/
}