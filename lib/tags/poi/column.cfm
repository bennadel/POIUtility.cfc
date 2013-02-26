
<!--- Check to see which version of the tag we are executing. --->
<cfswitch expression="#THISTAG.ExecutionMode#">

	<cfcase value="Start">
	
		<!--- Get a reference to the document tag context. --->
		<cfset VARIABLES.DocumentTag = GetBaseTagData( "cf_document" ) />
		
		<!--- Get a reference to the sheet tag context. --->
		<cfset VARIABLES.SheetTag = GetBaseTagData( "cf_sheet" ) />
		
		<!--- Get a reference to the columns tag context. --->
		<cfset VARIABLES.ColumnsTag = GetBaseTagData( "cf_columns" ) />
		
		
		<!--- Param tag attributes. --->
		
		<!--- This is the index of the column we are defining. --->
		<cfparam
			name="ATTRIBUTES.Index"
			type="numeric"
			default="#VARIABLES.ColumnsTag.ColumnIndex#"
			/>
			
		<!--- Default CSS class name(s). --->
		<cfparam
			name="ATTRIBUTES.Class"
			type="string"
			default=""
			/>
			
		<!--- Overriding CSS style values. --->
		<cfparam
			name="ATTRIBUTES.Style"
			type="string"
			default=""
			/>
			
		<!--- 
			A boolean for the freeze attribute of the sheet. This will override 
			any existing freeze COLUMN value that has been set.
		--->
		<cfparam
			name="ATTRIBUTES.Freeze"
			type="boolean"
			default="false"
			/>
			
			
		<!--- 
			Set the column index on the columns to be the same as the index
			of the current column (given by the user). This seems like a silly 
			fix to make given the default above, but if the user jumps to a 
			new index, we will keep the column index proper.
		--->
		<cfset VARIABLES.ColumnsTag.ColumnIndex = ATTRIBUTES.Index />
			
			
		<!--- 
			To start with, create an empty style struct. Don't worry about the 
			CELL style (that will be taken care of in the ROW tag).
		--->
		<cfset VARIABLES.Style = {} />
			
			
		<!--- 
			Loop over the passed class value as a space-delimited list. This 
			will allow us to prepend any existing styles.
		--->
		<cfloop
			index="VARIABLES.ClassName"
			list="#ATTRIBUTES.Class#"
			delimiters=" ">
			
			<!--- Check to see if this class name exists in the document. --->
			<cfif StructKeyExists( VARIABLES.DocumentTag.Classes, VARIABLES.ClassName )>
				
				<!--- Add the class to the style. --->
				<cfset StructAppend(
					VARIABLES.Style,
					VARIABLES.DocumentTag.Classes[ VARIABLES.ClassName ]
					) />
			
			</cfif>
			
		</cfloop>
		
		
		<!--- 
			Now that we've taken care of all the high-level CSS properties,
			let's add the tag-sepcific ones if they exist.
		--->
		<cfif Len( ATTRIBUTES.Style )>
		
			<cfset VARIABLES.Style = VARIABLES.DocumentTag.CSSRule.AddCSS(
				VARIABLES.Style,
				ATTRIBUTES.Style 
				) />
			
		</cfif>
		
			
		<!--- 
			Store the style object into the sheet tag so that everything 
			else in the sheet will have access to it. 
		--->	
		<cfset VARIABLES.SheetTag.ColumnClasses[ VARIABLES.ColumnsTag.ColumnIndex ] = VARIABLES.Style />
			
		
		<!--- 
			Check to see if we need to overrid the freeze column property 
			of the sheet for this column.
		--->
		<cfif ATTRIBUTES.Freeze>
		
			<!--- Store this row index as the freeze property of the parent sheet. --->
			<cfset VARIABLES.SheetTag.FreezeColumn = VARIABLES.ColumnsTag.ColumnIndex />
			
		</cfif>	
		
			
		<!--- Update the column count. --->
		<cfset VARIABLES.ColumnsTag.ColumnIndex++ />
			
	</cfcase>
	
	
	<cfcase value="End">
	
	</cfcase>
	
</cfswitch>
