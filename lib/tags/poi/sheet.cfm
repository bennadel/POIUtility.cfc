
<!--- Check to see which version of the tag we are executing. --->
<cfswitch expression="#THISTAG.ExecutionMode#">

	<cfcase value="Start">
	
		<!--- Get a reference to the document tag context. --->
		<cfset VARIABLES.DocumentTag = GetBaseTagData( "cf_document" ) />
		
		
		<!--- Param tag attributes. --->
		
		<!--- The label that is put in the sheet tab. --->
		<cfparam
			name="ATTRIBUTES.Name"
			type="string"
			/>
			
		<!--- 
			This determines which row to freeze if any. Defautls to zero, 
			meaning no freeze. If you want to freeze a row, provide a number 
			GTE 1. This can be overridden by a Row tag within this sheet.
		--->
		<cfparam
			name="ATTRIBUTES.FreezeRow"
			type="string"
			default="0"
			/>
			
		<!--- 
			This determines which column to freeze if any. Defautls to zero, 
			meaning no freeze. If you want to freeze a column, provide a number 
			GTE 1. This can be overriden by a Column tag within this sheet.
		--->
		<cfparam
			name="ATTRIBUTES.FreezeColumn"
			type="string"
			default="0"
			/>
			
		<!--- 
			The print orientation of the sheet. Defaults to portrait. Can also 
			be "landscape" orientation.
		--->
		<cfparam
			name="ATTRIBUTES.Orientation"
			type="string"
			default="portrait"
			/>
			
		<!--- 
			The default zoom of the sheet. This is entered as a percentage.
			100% would be the normal zoom.
		--->
		<cfparam
			name="ATTRIBUTES.Zoom"
			type="regex"
			pattern="^[\d]+%$"
			default="100%"
			/>
		
		
		<!--- 
			When creating the sheet, let's check to see if we already have a 
			sheet or if we need to create a new one. If we are using a template, 
			then we should just be able to grab the existing sheet.
		--->
		<cfif (VARIABLES.DocumentTag.Workbook.GetNumberOfSheets() GTE VARIABLES.DocumentTag.SheetIndex)>
		
			<!--- We have an existing sheet to use. Grab it from the workbook. --->
			<cfset VARIABLES.Sheet = VARIABLES.DocumentTag.WorkBook.GetSheetAt(
				JavaCast( "int", (VARIABLES.DocumentTag.SheetIndex - 1) )
				) />
				
			<!--- Rename the sheet. --->
			<cfset VARIABLES.DocumentTag.WorkBook.SetSheetName(
				JavaCast( "int", (VARIABLES.DocumentTag.SheetIndex - 1) ),
				JavaCast( "string", ATTRIBUTES.Name )
				) />
		
		<cfelse>
		
			<!--- Create a new sheet within the current workbook. --->
			<cfset VARIABLES.Sheet = VARIABLES.DocumentTag.WorkBook.CreateSheet(
				JavaCast( "string", ATTRIBUTES.Name )
				) />
				
		</cfif>
			
			
		<!---
			We might have column-wide classes that need to be 
			accessible from the cells in the subsequent rows. Let's 
			create a struct-by-column-index of the classes defined for 
			each column (ex. width of column).
		--->
		<cfset VARIABLES.ColumnClasses = StructNew() />	
		
		
		<!--- 
			Store the freeze properties into the variables scope such that 
			they can be overriden by other tags within this sheet.
		--->
		<cfset VARIABLES.FreezeRow = ATTRIBUTES.FreezeRow />
		<cfset VARIABLES.FreezeColumn = ATTRIBUTES.FreezeColumn />
			
			
		<!--- 
			Let's set the zoom. The external zoom is entered as a percentage, 
			but the internal zoom is implemented as a fraction. Let's just
			get the zoom as a whole number without the percentage. We can
			use this as the value over 100 (ex. 130 / 100).
		--->
		<cfset VARIABLES.Zoom = Val( ATTRIBUTES.Zoom ) />
			
			
		<!--- 
			Create a variable for the current row offset. There are hooks for 
			this value into the Sheet object, but they seem to be buggy, so I 
			am gonna run my own index to make sure that I really know what's 
			going on. The row index is going to hold the index OF THE CURRENT ROW.
		--->
		<cfset VARIABLES.RowIndex = 1 />
			
	</cfcase>
	
	
	<cfcase value="End">
	
		<!--- 
			At the end of the sheet, we have to adjust the widths of our columns.
			The columns width are either not set, in which case, we let Excel do 
			what ever it does. If it is explicit, we set it, otherwise if it is 
			auto, we grow the column to fit the content. 
			
			Loop over the column classes to examine the styles.
		--->
		<cfloop
			item="VARIABLES.ColumnIndex"
			collection="#VARIABLES.ColumnClasses#">
			
			<!--- Check to see if we have a width value for this column. --->
			<cfif StructKeyExists( VARIABLES.ColumnClasses[ VARIABLES.ColumnIndex ], "width" )>
			
				<!--- Get the column class width style. --->
				<cfset VARIABLES.ColumnWidth = VARIABLES.ColumnClasses[ VARIABLES.ColumnIndex ][ "width" ] />
				
				<!--- Check the width. --->
				<cfif (VARIABLES.ColumnWidth EQ "auto")>
					
					<!--- 
						NOTE: This is in the documentation but does not seem to be 
						supported in the ColdFusion version of the POI library. 
					--->
					
					<!--- Autosize the current column. --->
					<!--- <cfset VARIABLES.Sheet.AutoSizeColumn( JavaCast( "short", VARIABLES.ColumnIndex ) ) /> --->
				
				<cfelseif Val( VARIABLES.ColumnWidth )>
				
					<!--- Set column to explicit width. --->
					<cfset VARIABLES.Sheet.SetColumnWidth(
						JavaCast( "short", (VARIABLES.ColumnIndex - 1) ),
						JavaCast( "short", Min( 32767, (Val( VARIABLES.ColumnWidth ) * 37) ) )
						) />
					
				</cfif>
			
			</cfif>
			
		</cfloop>
		
		
		<!--- 
			Let's check to see if we have any freeze panes to create based 
			on our frozen row and column.
		--->
		<cfif (
			(VARIABLES.FreezeRow GT 0) OR
			(VARIABLES.FreezeColumn GT 0)
			)>
			
			<!--- Create a freeze pane. --->
			<cfset VARIABLES.Sheet.CreateFreezePane(
				JavaCast( "int", VARIABLES.FreezeColumn ),
				JavaCast( "int", VARIABLES.FreezeRow )
				) />
			
		</cfif>
		
		
		<!--- Check to see if the print orientation was set to landscape. --->
		<cfif (ATTRIBUTES.Orientation EQ "landscape")>
		
			<!--- 
				Get the print setup and set the landscape orientation of 
				the current sheet.
			--->
			<cfset VARIABLES.Sheet.GetPrintSetup().SetLandscape( 
				JavaCast( "boolean", true )
				) />
		
		</cfif>
		
		
		<!--- Set the sheet zoom. --->
		<cfset VARIABLES.Sheet.SetZoom(
			JavaCast( "int", VARIABLES.Zoom ),
			JavaCast( "int", 100 )
			) />
		
		
		<!--- Update the sheet count. --->
		<cfset VARIABLES.DocumentTag.SheetIndex++ />	
	
	</cfcase>
	
</cfswitch>

