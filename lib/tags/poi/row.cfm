
<!--- Check to see which version of the tag we are executing. --->
<cfswitch expression="#THISTAG.ExecutionMode#">

	<cfcase value="Start">
	
		<!--- Get a reference to the document tag context. --->
		<cfset VARIABLES.DocumentTag = GetBaseTagData( "cf_document" ) />

		<!--- Get a reference to the sheet tag context. --->
		<cfset VARIABLES.SheetTag = GetBaseTagData( "cf_sheet" ) />
		
		
		<!--- Param tag attributes. --->
		
		<!--- This is the index of the row we are about to create. --->
		<cfparam
			name="ATTRIBUTES.Index"
			type="numeric"
			default="#VARIABLES.SheetTag.RowIndex#"
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
			any existing freeze ROW value that has been set.
		--->
		<cfparam
			name="ATTRIBUTES.Freeze"
			type="boolean"
			default="false"
			/>
		
		
		<!--- 
			Set the row index on the sheet to be the same as the index
			of the current row (given by the user). This seems like a silly 
			fix to make given the default above, but if the user jumps to a 
			new index, we will keep the row index proper.
		--->
		<cfset VARIABLES.SheetTag.RowIndex = ATTRIBUTES.Index />
			
			
		<!--- Create the new row. --->
		<cfset VARIABLES.Row = VARIABLES.SheetTag.Sheet.CreateRow(
			JavaCast( "int", (VARIABLES.SheetTag.RowIndex - 1) )
			) />
		
			
		<!--- 
			Create a variable for the current cell index. There are hooks for 
			this value into the Row object, but they seem to be buggy, so I 
			am gonna run my own index to make sure that I really know what's 
			going on. This cell index holdes the INDEX OF THE CURRENT CELL.
		--->
		<cfset VARIABLES.CellIndex = 1 />
		
		
		<!--- 
			Let's create cell style for this cell. We are going to start off 
			by creating a duplicate of the global cell style. Then, we will 
			add to that CSS representation.
		--->
		<cfset VARIABLES.Style = StructCopy( VARIABLES.DocumentTag.Classes[ "@cell" ] ) />
		
		
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
				
				<!--- Append the class to the current CSS. --->
				<cfset StructAppend( 
					VARIABLES.Style,
					VARIABLES.DocumentTag.Classes[ VARIABLES.ClassName ]
					) />
					
			</cfif>
			
		</cfloop>
		
		
		<!--- 
			Now, check to see if there are any passed-in styles. We are only 
			going to parse this if a style was actually set.
		--->
		<cfif Len( ATTRIBUTES.Style )>
		
			<!--- Add row styles. --->
			<cfset VARIABLES.DocumentTag.CSSRule.AddCSS(
				VARIABLES.Style,
				ATTRIBUTES.Style 
				) />
		
		</cfif>
				
		
		<!--- Get the row height property to see if has been set. --->
		<cfif (
			StructKeyExists( VARIABLES.Style, "height" ) AND
			Val( VARIABLES.RowHeight )
			)>
		
			<!--- Set row height in points. --->
			<cfset VARIABLES.Row.SetHeightInPoints( JavaCast( "float", Val( VARIABLES.Style[ "height" ] ) ) ) />
		
		</cfif>
		
	</cfcase>
	
	
	<cfcase value="End">
	
		<!--- 
			Check to see if we need to overrid the freeze row property 
			of the sheet for this row.
		--->
		<cfif ATTRIBUTES.Freeze>
		
			<!--- Store this row index as the freeze property of the parent sheet. --->
			<cfset VARIABLES.SheetTag.FreezeRow = VARIABLES.SheetTag.RowIndex />
			
		</cfif>
	
	
		<!--- Update the row count. --->
		<cfset VARIABLES.SheetTag.RowIndex++ />
		
	</cfcase>
	
</cfswitch>

