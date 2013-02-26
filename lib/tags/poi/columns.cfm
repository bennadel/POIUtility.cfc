
<!--- Check to see which version of the tag we are executing. --->
<cfswitch expression="#THISTAG.ExecutionMode#">

	<cfcase value="Start">
	
		<!--- Get a reference to the document tag context. --->
		<cfset VARIABLES.DocumentTag = GetBaseTagData( "cf_document" ) />
		
		<!--- Get a reference to the sheet tag context. --->
		<cfset VARIABLES.SheetTag = GetBaseTagData( "cf_sheet" ) />
		
			
		<!--- 
			Create a variable for the current column index. This 
			will contain the index OF THE CURRENT COLUMN.
		--->
		<cfset VARIABLES.ColumnIndex = 1 />
		
	</cfcase>
	
	
	<cfcase value="End">
	
	</cfcase>
	
</cfswitch>
