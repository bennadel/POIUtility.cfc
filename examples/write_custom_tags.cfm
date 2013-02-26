
<cfsetting showdebugoutput="true" />


<!--- Create out data query. --->
<cfset qPeople = QueryNew( 
	"rank, name, hair, best_feature, hotness, last_fantasy", 
	"integer, varchar, varchar, varchar, decimal, timestamp"
	) />
	
	
<!--- Populate query. --->
<cfset QueryAddRow( qPeople, 5 ) />

<cfset qPeople[ "rank" ][ 1 ] = JavaCast( "int", 1 ) />
<cfset qPeople[ "name" ][ 1 ] = JavaCast( "string", "Christina Cox" ) />
<cfset qPeople[ "hair" ][ 1 ] = JavaCast( "string", "Dirty Blonde" ) />
<cfset qPeople[ "best_feature" ][ 1 ] = JavaCast( "string", "Lips" ) />
<cfset qPeople[ "hotness" ][ 1 ] = JavaCast( "float", 9.0 ) />
<cfset qPeople[ "last_fantasy" ][ 1 ] = ParseDateTime( "03/15/2008" ) />
	
<cfset qPeople[ "rank" ][ 2 ] = JavaCast( "int", 2 ) />
<cfset qPeople[ "name" ][ 2 ] = JavaCast( "string", "Meg Ryan" ) />
<cfset qPeople[ "hair" ][ 2 ] = JavaCast( "string", "Blonde" ) />
<cfset qPeople[ "best_feature" ][ 2 ] = JavaCast( "string", "Smile" ) />
<cfset qPeople[ "hotness" ][ 2 ] = JavaCast( "float", 9.0 ) />
<cfset qPeople[ "last_fantasy" ][ 2 ] = ParseDateTime( "07/02/2005" ) />
	
<cfset qPeople[ "rank" ][ 3 ] = JavaCast( "int", 3 ) />
<cfset qPeople[ "name" ][ 3 ] = JavaCast( "string", "Winonna Ryder" ) />
<cfset qPeople[ "hair" ][ 3 ] = JavaCast( "string", "Brunette" ) />
<cfset qPeople[ "best_feature" ][ 3 ] = JavaCast( "string", "Eyes" ) />
<cfset qPeople[ "hotness" ][ 3 ] = JavaCast( "float", 8.0 ) />
<cfset qPeople[ "last_fantasy" ][ 3 ] = ParseDateTime( "11/22/2002" ) />
	
<cfset qPeople[ "rank" ][ 4 ] = JavaCast( "int", 4 ) />
<cfset qPeople[ "name" ][ 4 ] = JavaCast( "string", "Angela Bassett" ) />
<cfset qPeople[ "hair" ][ 4 ] = JavaCast( "string", "Brunette" ) />
<cfset qPeople[ "best_feature" ][ 4 ] = JavaCast( "string", "Angularity" ) />
<cfset qPeople[ "hotness" ][ 4 ] = JavaCast( "float", 8.0 ) />
<cfset qPeople[ "last_fantasy" ][ 4 ] = ParseDateTime( "05/15/2003" ) />

<cfset qPeople[ "rank" ][ 5 ] = JavaCast( "int", 5 ) />
<cfset qPeople[ "name" ][ 5 ] = JavaCast( "string", "Michelle Rodriguez" ) />
<cfset qPeople[ "hair" ][ 5 ] = JavaCast( "string", "Brunette" ) />
<cfset qPeople[ "best_feature" ][ 5 ] = JavaCast( "string", "Muscularity" ) />
<cfset qPeople[ "hotness" ][ 5 ] = JavaCast( "float", 8.0 ) />
<cfset qPeople[ "last_fantasy" ][ 5 ] = ParseDateTime( "01/01/2008" ) />


<!--- Import the POI tag library. --->
<cfimport taglib="../lib/tags/poi/" prefix="poi" />
	
	
<!--- 
	Create an excel document and store binary data into 
	REQUEST variable. 
--->
<poi:document 
	name="REQUEST.ExcelData"
	file="#ExpandPath( './celebrities.xls' )#"
	style="font-family: verdana ; font-size: 10pt ; color: black ; white-space: nowrap ;">
	
	<!--- Define style classes. --->
	<poi:classes>
		
		<poi:class
			name="title"
			style="font-family: arial ; color: white ; background-color: green ; font-size: 18pt ; text-align: left ;"
			/>
		
		<poi:class 
			name="header" 
			style="font-family: arial ; background-color: lime ; color: white ; font-size: 14pt ; border-bottom: solid 3px green ; border-top: 2px solid white ;" 
			/>
			
	</poi:classes>
		
	<!--- Define Sheets. --->
	<poi:sheets>
	
		<poi:sheet 
			name="Smokin' Hotties"
			freezerow="2"
			orientation="landscape"
			zoom="130%">
		
			<!--- Define global column styles. --->
			<poi:columns>
				<poi:column style="width: 50px ; text-align: center ;" />
				<poi:column style="width: 150px ;" />
				<poi:column style="width: 130px ;" />
				<poi:column style="width: 100px ; text-align: center ;" />
				<poi:column style="width: 150px ; text-align: left ;" />
			</poi:columns>
			
			<!--- Title row. --->
			<poi:row class="title">
				<poi:cell value="Hot Celebrity Action" colspan="5" />
			</poi:row>
			
			<!--- Header row. --->
			<poi:row class="header">
				<poi:cell value="Rank" />
				<poi:cell value="Name" />
				<poi:cell value="Best Feature" />
				<poi:cell value="Hotness" />
				<poi:cell value="Last Fantasy" />
			</poi:row>
			
			<!--- Output the people. --->
			<cfloop query="qPeople">
			
				<poi:row>
					<poi:cell type="numeric" value="#qPeople.rank#" />
					<poi:cell value="#qPeople.name#" />
					<poi:cell value="#qPeople.best_feature#" />
					<poi:cell type="numeric" numberformat="0.00" value="#qPeople.hotness#" />
					<poi:cell type="date" value="#qPeople.last_fantasy#" />
				</poi:row>
			
			</cfloop>
				
		</poi:sheet>
		
	</poi:sheets>
		
</poi:document>



<!--- Tell the browser to expect an Excel file attachment. --->
<cfheader
	name="content-disposition"
	value="attachment; filename=celebrities.xls"
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