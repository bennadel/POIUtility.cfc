
<!--- Check to see which version of the tag we are executing. --->
<cfswitch expression="#THISTAG.ExecutionMode#">

	<cfcase value="Start">
	
		<!--- Get a reference to the document tag context. --->
		<cfset VARIABLES.DocumentTag = GetBaseTagData( "cf_document" ) />
		
		
		<!--- Param tag attributes. --->
		
		<!--- The name of the class. --->
		<cfparam
			name="ATTRIBUTES.Name"
			type="string"
			/>
			
		<!--- The raw CSS for this class. --->
		<cfparam
			name="ATTRIBUTES.Style"
			type="string"
			/>
			
			
		<!--- Add the CSS Rule to the document classes. --->
		<cfset VARIABLES.DocumentTag.Classes[ ATTRIBUTES.Name ] = VARIABLES.DocumentTag.CSSRule.AddCSS(
			StructNew(),
			ATTRIBUTES.Style
			)/>
			
	</cfcase>
	
	
	<cfcase value="End">
	
	</cfcase>
	
</cfswitch>
