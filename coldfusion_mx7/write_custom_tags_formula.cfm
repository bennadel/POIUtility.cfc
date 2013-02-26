
<cfsetting showdebugoutput="true" />

<!--- Import the POI tag library. --->
<cfimport taglib="./poi/" prefix="poi" />
	
	
<!--- 
	Create an excel document and store binary data into 
	REQUEST variable. 
--->
<poi:document 
	name="REQUEST.ExcelData"
	file="#ExpandPath( './incomes.xls' )#"
	style="font-family: verdana ; font-size: 10pt ; color: black ; white-space: nowrap ;">
	
	
	<!--- Define style classes. --->
	<poi:classes>
		
		<poi:class
			name="title"
			style="font-family: arial ; color: white ; background-color: green ; font-size: 18pt ; text-align: center ;"
			/>
		
		<poi:class 
			name="header" 
			style="font-family: arial ; background-color: lime ; color: white ; font-size: 14pt ; border-bottom: solid 3px green ; border-top: 2px solid white ;" 
			/>
			
		<poi:class 
			name="footer" 
			style="background-color: red ; color: white ; border-top: 3px solid black ;" 
			/>
			
	</poi:classes>
	
	
	<!--- Define Sheets. --->
	<poi:sheets>
	
		<poi:sheet name="Incomes">
		
			<!--- Define global column styles. --->
			<poi:columns>
				<poi:column style="width: 150px ;" />
				<poi:column style="width: 150px ;" />
			</poi:columns>
			
			
			<!--- Title row. --->
			<poi:row class="title">
				<poi:cell value="Yearly Incomes" colspan="2" />
			</poi:row>
			
			<!--- Header row. --->
			<poi:row class="header">
				<poi:cell value="Name" />
				<poi:cell value="Income" />
			</poi:row>
			
			
			<poi:row>
				<poi:cell value="Katie" />
				<poi:cell value="35000" type="numeric" numberformat="0.00" alias="StartSum" />
			</poi:row>
			
			<poi:row>
				<poi:cell value="Allison" />
				<poi:cell value="72500" type="numeric" numberformat="0.00" />
			</poi:row>
			
			<poi:row>
				<poi:cell value="Libby" />
				<poi:cell value="57000" type="numeric" numberformat="0.00" />
			</poi:row>
			
			<poi:row>
				<poi:cell value="Kit" />
				<poi:cell value="110000" type="numeric" numberformat="0.00" />
			</poi:row>
			
			<poi:row>
				<poi:cell value="Anna" />
				<poi:cell value="63000" type="numeric" numberformat="0.00" alias="EndSum" />
			</poi:row>
			
			
			<!--- In the footer, create a formula for summing the income values. --->
			<poi:row class="footer">
				<poi:cell value="" />
				<poi:cell value="SUM( @StartSum:@EndSum )" type="formula" numberformat="0.00" />
			</poi:row>
				
		</poi:sheet>
		
	</poi:sheets>
		
</poi:document>



<!--- Tell the browser to expect an Excel file attachment. --->
<cfheader
	name="content-disposition"
	value="attachment; filename=incomes.xls"
	/>
	
<!--- 
	Tell browser the length of the byte array output stream. 
	This will help the browser provide download duration to 
	the user. 
--->
<cfheader
	name="content-length"
	value="#REQUEST.ExcelData.Size()#"
	/>

<!--- Stream the binary data to the user. --->
<cfcontent
	type="application/excel"
	variable="#REQUEST.ExcelData.ToByteArray()#"
	/>




<!--- 
Done. 
<cfoutput>
	#Now()#
</cfoutput> --->