
<!--- Kill extra space. --->
<cfsilent>

	<!--- We only care about this tag on the close. --->
	<cfif (THISTAG.ExecutionMode EQ "End")>
	
		<!--- 
			This is the variable name into which the query is 
			going to be stored.
		--->
		<cfparam
			name="ATTRIBUTES.Name"
			type="string"
			/>
	
		
		<!--- 
			Grab the generated content. This is the definition
			of the query columns and data.
		--->
		<cfset strSetup = Trim( THISTAG.GeneratedContent ) />
		
		<!--- Clear the generated content. --->
		<cfset THISTAG.GeneratedContent = "" />
		
		<!--- Clean up the generated content. --->
		<cfset strSetup = strSetup.ReplaceAll(
			"(?m)^[\t ]+|[\t ]+$",
			""
			) />
		
		<!--- Get the rows of data. --->
		<cfset arrRows = strSetup.Split( "[\r\n]+" ) />
		
		<!--- 
			Define the query using the first row of data.
			By default, all of these values are going to 
			be strings.
		--->
		<cfset qData = QueryNew( "" ) />
		
		<cfloop 
			index="intCol"
			from="1"
			to="#ListLen( arrRows[ 1 ], '|' )#"
			step="1">
			
			<!--- Add a column to the query. --->
			<cfset QueryAddColumn(
				qData, 
				ListGetAt( arrRows[ 1 ], intCol, "|" ),
				"CF_SQL_VARCHAR",
				ArrayNew( 1 )
				) />
			
		</cfloop>
		
		
		<!--- Loop over the rest of the rows to add data. --->
		<cfloop
			index="intRow"
			from="2"
			to="#ArrayLen( arrRows )#"
			step="1">
			
			<!--- Add a row to the query. --->
			<cfset QueryAddRow( qData ) />
			
			<!--- Loop over columns. --->
			<cfloop 
				index="strCol"
				list="#arrRows[ 1 ]#"
				delimiters="|">
				
				<!--- Set cell. --->
				<cfset qData[ strCol ][ qData.RecordCount ] = JavaCast(
					"string",
					ListGetAt(
						arrRows[ intRow ],
						ListFind( arrRows[ 1 ], strCol, "|" ),
						"|"
						)
					) />
				
			</cfloop>
						
		</cfloop>		
	
		
		<!--- Store the query into the caller. --->
		<cfset "CALLER.#ATTRIBUTES.Name#" = qData />
		
	</cfif>	
	
</cfsilent>