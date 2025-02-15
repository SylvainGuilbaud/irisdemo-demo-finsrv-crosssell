Include DEMOMACROS

Class IRISDemo.DataLoadingUtils
{	
	/// This is called from IRISDemo.Installer to create the user merchants, 
	/// customer accounts and transactions between them
	ClassMethod LoadFullDataFromCSVFile(pFileName As %String) As %Status
	{
		#Dim oTrans As IRISDemo.Trans
		
		Set tSC = $$$OK
		Try
		{
			DO DISABLE^%NOJRN
			
			Set iLine=0 //Header is consumed
			
			Set oRSTransactions=##class(%ResultSet).%New("IRISDemo.Util.FileReader:CSV")
			Set tSC = oRSTransactions.Execute(pFileName)
			Quit:$System.Status.IsError(tSC)
						
			Do ..ClearErrors()
			
			Set tBaseDate=$ZDateH("2018-01-01",3)
			
			While oRSTransactions.Next()
			{
				Set iLine=iLine+1
				//Quit:iLine>10000
				
				Set oTrans = ##class(CheckingTrans).%New()
				
				// step must be transformed into TransDateTime. One step is 1 hour
				Set day=oRSTransactions.Get("step")
				Set dateH=tBaseDate+day
				Set hourH=$ZTime($Random(60*60*24))
				Set oTrans.TransDateTime=$ZDate(dateH,3)_" "_$ZTime(hourH)
				
				Set oTrans.Amount=+oRSTransactions.Get("amount")
				
				Set tSC = ##class(Account).OpenOrCreateByNumber(oRSTransactions.Get("merchant"), .oToAccount)
				Quit:$System.Status.IsError(tSC)
				
				Set oTrans.ToAccount=oToAccount
				If oTrans.ToAccount.%Id()=""
				{
					Set tCategoryCode=$Piece(oRSTransactions.Get("category"),"_",2)
					Set tSC=##class(MerchantCategory).OpenOrCreateByCode(tCategoryCode, .oCategory)
					$$$ThrowStatusExceptionIfError(tSC, "CreateCategoryException")
					
					Set oCategory.Description=$ZConvert(tCategoryCode, "S")
					
					Set oTrans.ToAccount.Category=oCategory
				}
				
				Set tSC = ##class(Account).OpenOrCreateByNumber(oRSTransactions.Get("customer"), .oFromAccount)
				Quit:$System.Status.IsError(tSC)
				
				Set oTrans.FromAccount=oFromAccount
				If oTrans.FromAccount.%Id()=""
				{
					Set oTrans.FromAccount.Gender=oRSTransactions.Get("gender")
					If oTrans.FromAccount.Gender="E" Set oTrans.FromAccount.Gender="U" //This should not happen!
					Set oTrans.FromAccount.DateOfBirth=..DateOfBirthForAgeGroup(oRSTransactions.Get("age"))
				}
				
				Set oTrans.TransType="PAYMENT"
				
				Set oTrans.FromAccountOldBalance=oTrans.FromAccount.Balance
				Set oTrans.ToAccountOldBalance=oTrans.ToAccount.Balance
				
				Set oTrans.ToAccount.Balance=oTrans.ToAccount.Balance+oTrans.Amount
				Set oTrans.FromAccount.Balance=oTrans.FromAccount.Balance-oTrans.Amount
				
				Do oTrans.ValidateTransaction(1)
				
				Set oTrans.FromAccountNewBalance=oTrans.FromAccount.Balance
				Set oTrans.ToAccountNewBalance=oTrans.ToAccount.Balance
				
				//This is a single transaction involving three objects!
				Set tSC = oTrans.%Save(1)
				Quit:$System.Status.IsError(tSC) //This is not really necessary. It's here for the habit of it.
			}
		}
		Catch (oException)
		{
			Set tSC = oException.AsStatus()
		}
		
		DO ENABLE^%NOJRN
		
		Set ^IRISDemo.TransL("Total")=iLine
		Do ..ShowResults(tSC)
		
		Quit tSC
	}
	
	ClassMethod DateOfBirthForAgeGroup(pAgeGroup As %Integer) As %Date
	{
		If pAgeGroup=0
		{
			Set iAgeMin=15
			Set iAgeMax=18 
		}
		ElseIf pAgeGroup=1
		{
			Set iAgeMin=19
			Set iAgeMax=25 
		}
		ElseIf pAgeGroup=2
		{
			Set iAgeMin=26
			Set iAgeMax=35 
		}
		ElseIf pAgeGroup=3
		{
			Set iAgeMin=36
			Set iAgeMax=45 
		}
		ElseIf pAgeGroup=4
		{
			Set iAgeMin=46
			Set iAgeMax=55 
		}
		ElseIf pAgeGroup=5
		{
			Set iAgeMin=56
			Set iAgeMax=65 
		}
		Else
		{
			Set iAgeMin=$Random(60)+18
			Set iAgeMax=iAgeMin+1
		}
	
		Set iDateMax=$H-(iAgeMin*365)
		Set iDateMin=$H-(iAgeMax*365)
		
		Set iDateDelta=$Random(iDateMax-iDateMin)
		
		Quit iDateMin+iDateDelta	
	}
	
	ClassMethod ClearErrors() [ Private ]
	{
		Kill ^IRISDemo.TransL
	}
	
	ClassMethod LogError(pLine As %Integer, pError As %String) [ Private ]
	{
		Set i=$Increment(^IRISDemo.TransL("Errors"))
		Set ^IRISDemo.TransL("Errors",i)=$LB(pLine, pError)
	}
	
	ClassMethod ShowResults(pSC As %Status) [ Private ]
	{
		Do $System.Status.DisplayError(pSC)
		
		Set iTotalLines=^IRISDemo.TransL("Total")
		Set iTotalErrors=$Get(^IRISDemo.TransL("Errors"),0)
		
		For i=1:1:iTotalErrors 
		{
			Set i=$Order(^IRISDemo.TransL("Errors",i))
			
			Set tErrorData = ^IRISDemo.TransL("Errors",i)
			
			Write !,$LG(tErrorData,1),$C(9),": ",$LG(tErrorData,2)
		}
		
		Write !,iTotalLines," lines processed.",!
		Write !,iTotalErrors," errors reported - "_(iTotalErrors/iTotalLines*100)_"% of the records.",!
		
		Kill ^IRISDemo.Trans
	}
	
	/// This is called from IRISDemo.Installer to make sure the demo account has appropriate transaction volume to tell the story 
	ClassMethod FixDemoAccountTransactions(pDemoAccountCode As %String) As %Status
	{
		
		Set tSC = $$$OK
		Set transactionThreshold = 5000
		Set desiredTransactionSumAmount = 4990
		
		Try
		{
			Write !!,"Fixing Demo Account Transaction Data...",!
			
			Set rsAccount = ##class(%SQL.Statement).%ExecDirect(,"SELECT ID from IRISDemo.Account WHERE AccountNumber = '"_ pDemoAccountCode_"'")
			$$$ThrowSQLExceptionIfResultError(rsAccount, "NonExistentDemoAccountException")
			
			While rsAccount.%Next() 
			{
				Set demoAccountID = rsAccount.%Get("ID")
			}
			
			Set rsTransactionSum = ##class(%SQL.Statement).%ExecDirect(,"SELECT Count(*) as trans_count, SUM(Amount) as trans_sum from IRISDemo.CheckingTrans WHERE FromAccount ="_demoAccountID)
			$$$ThrowSQLExceptionIfResultError(rsTransactionSum, "SelectDemoTransactionsSUMException")
			
			While rsTransactionSum.%Next() 
			{
				Set transSum = rsTransactionSum.%Get("trans_sum")
				Set transCount = rsTransactionSum.%Get("trans_count")
			}
			
			if ((transSum '= "") && (transSum > transactionThreshold)) {
			
				Set transactionDifference = transSum - desiredTransactionSumAmount
				Set splitSubtractor = (transactionDifference / (transCount / 2))
				
				Set rsTransactions = ##class(%SQL.Statement).%ExecDirect(,"SELECT * from IRISDemo.CheckingTrans WHERE FromAccount ="_demoAccountID)
				$$$ThrowSQLExceptionIfResultError(rsTransactions, "SelectDemoTransactionsException")
				
				While ((rsTransactions.%Next()) && (transactionDifference > 0))
				{
					Set transactionID = rsTransactions.%Get("ID")
					Set transactionAmount = rsTransactions.%Get("Amount")
					
					If (transactionAmount > splitSubtractor)
					{
						#Dim transaction As IRISDemo.CheckingTrans
						
						Set transaction = ##class(IRISDemo.CheckingTrans).%OpenId(transactionID)
						
						Set transaction.Amount = transaction.Amount - splitSubtractor
						Set transaction.FromAccountNewBalance = transaction.FromAccountNewBalance + splitSubtractor
						Set transaction.ToAccountNewBalance = transaction.ToAccountNewBalance - splitSubtractor
						
						Set rsFromAccountLiquiditySync = ##class(%SQL.Statement).%ExecDirect(,"UPDATE IRISDemo.CheckingTrans Set FromAccountNewBalance= FromAccountNewBalance + "_splitSubtractor_", FromAccountOldBalance=FromAccountOldBalance + "_splitSubtractor_" WHERE FromAccount ='"_transaction.FromAccount_"' AND ID > "_transactionID)
						$$$ThrowSQLExceptionIfResultError(rsFromAccountLiquiditySync, "FromAccountLiquiditySyncException")
				
						Set rsToAccountLiquiditySync = ##class(%SQL.Statement).%ExecDirect(,"UPDATE IRISDemo.CheckingTrans Set ToAccountNewBalance= ToAccountNewBalance - "_splitSubtractor_", ToAccountOldBalance=ToAccountOldBalance - "_splitSubtractor_" WHERE ToAccount ='"_transaction.ToAccount_"' AND ID > "_transactionID)
						$$$ThrowSQLExceptionIfResultError(rsToAccountLiquiditySync, "ToAccountLiquiditySyncException")
						
						
						Set tSC = transaction.%Save()
						$$$ThrowStatusExceptionIfError(tSC, "UpdateEncounterDischargeLocationException")
						
						Set transactionDifference = transactionDifference - splitSubtractor
					}
				}
			
			}
			
			Write !,"Fixing of Demo Account Transaction Data finished OK!",!
		}
		Catch (oException)
		{
			Write !,"Exception",!
			Set tSC = oException.AsStatus()
		}
		
		Do $System.Status.DisplayError(tSC)
				
		Quit tSC
	}
}