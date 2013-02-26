<cfoutput>

	<!--- Create an instance of the POIUtility.cfc. --->
	<cfset objPOI = CreateObject( 
		"component", 
		"POIUtility" 
		).Init() 
		/>
	
	
	<!--- 
		Read in the Exercises excel sheet. This has Push, Pull,
		and Leg exercises split up on to three different sheets.
		By default, the POI Utilty will read in all three sheets
		from the workbook. Since our excel sheet has a header
		row, we want to strip it out of our returned queries.
	--->
	<cfset arrSheets = objPOI.ReadExcel( 
		FilePath = ExpandPath( "./exercises.xls" ),
		HasHeaderRow = true
		) />
		
	
	<!--- 
		The ReadExcel() has returned an array of sheet object.
		Let's loop over sheets and output the data. NOTE: This
		could be also done to insert into a DATABASE!
	--->
	<cfloop
		index="intSheet"
		from="1"
		to="#ArrayLen( arrSheets )#"
		step="1">
		
		<!--- Get a short hand to the current sheet. --->
		<cfset objSheet = arrSheets[ intSheet ] />
		
		
		<!--- 
			Output the name of the sheet. This is taken from 
			the Tabs at the bottom of the workbook.
		--->
		<h3>
			#objSheet.Name#
		</h3>
		
		<!--- 
			Output the data from the Excel sheet in a table. 
			We know the structrure of the Excel, so we can
			use the auto-named columns. Also, since we flagged
			the workbook as using column headers, the first 
			row of the excel was stripped out and put into an
			array of column names.
		--->
		<table border="1">
		<tr>
			<td>
				#objSheet.ColumnNames[ 1 ]#
			</td>
			<td>
				#objSheet.ColumnNames[ 2 ]#
			</td>
			<td>
				#objSheet.ColumnNames[ 3 ]#
			</td>
		</tr>
				
		<!--- Loop over the data query. --->
		<cfloop query="objSheet.Query">
			
			<!--- 
				It is possible that the query read in read in 
				blank rows of data. For our scenario, we know 
				that we HAVE to have an exercise name. 
				Therefore, if there is no exercise name returned
				(in Column1), then this row is not valid - skip 
				over it.
			--->
			<cfif Len( objSheet.Query.column1 )>
				
				<tr>
					<td>
						#objSheet.Query.column1#
					</td>
					<td>
						#objSheet.Query.column2#
					</td>
					<td>
						#objSheet.Query.column3#
					</td>
				</tr>
		
			</cfif>
		
		</cfloop>
		</table>
		
	</cfloop>
	
</cfoutput>
