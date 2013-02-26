

<!--- Create out data query. --->
<cfset qPeople = QueryNew( 
	"rank, name, hair, best_feature, hotness, last_fantasy", 
	"integer, varchar, varchar, varchar, decimal, timestamp"
	) />
	
	
<!--- Populate with a lot of data. --->
<cfloop index="i" from="1" to="1">
	
	<!--- Populate query. --->
	<cfset QueryAddRow( qPeople ) />
	<cfset qPeople[ "rank" ][ qPeople.RecordCount ] = JavaCast( "int", qPeople.RecordCount ) />
	<cfset qPeople[ "name" ][ qPeople.RecordCount ] = JavaCast( "string", "Christina Cox" ) />
	<cfset qPeople[ "hair" ][ qPeople.RecordCount ] = JavaCast( "string", "Dirty Blonde" ) />
	<cfset qPeople[ "best_feature" ][ qPeople.RecordCount ] = JavaCast( "string", "Lips" ) />
	<cfset qPeople[ "hotness" ][ qPeople.RecordCount ] = JavaCast( "float", 9.0 ) />
	<cfset qPeople[ "last_fantasy" ][ qPeople.RecordCount ] = ParseDateTime( "03/15/2008" ) />
		
	<cfset QueryAddRow( qPeople ) />
	<cfset qPeople[ "rank" ][ qPeople.RecordCount ] = JavaCast( "int", 2 ) />
	<cfset qPeople[ "name" ][ qPeople.RecordCount ] = JavaCast( "string", "Meg Ryan" ) />
	<cfset qPeople[ "hair" ][ qPeople.RecordCount ] = JavaCast( "string", "Blonde" ) />
	<cfset qPeople[ "best_feature" ][ qPeople.RecordCount ] = JavaCast( "string", "Smile" ) />
	<cfset qPeople[ "hotness" ][ qPeople.RecordCount ] = JavaCast( "float", 9.0 ) />
	<cfset qPeople[ "last_fantasy" ][ qPeople.RecordCount ] = ParseDateTime( "07/02/2005" ) />
		
	<cfset QueryAddRow( qPeople ) />
	<cfset qPeople[ "rank" ][ qPeople.RecordCount ] = JavaCast( "int", 3 ) />
	<cfset qPeople[ "name" ][ qPeople.RecordCount ] = JavaCast( "string", "Winonna Ryder" ) />
	<cfset qPeople[ "hair" ][ qPeople.RecordCount ] = JavaCast( "string", "Brunette" ) />
	<cfset qPeople[ "best_feature" ][ qPeople.RecordCount ] = JavaCast( "string", "Eyes" ) />
	<cfset qPeople[ "hotness" ][ qPeople.RecordCount ] = JavaCast( "float", 8.0 ) />
	<cfset qPeople[ "last_fantasy" ][ qPeople.RecordCount ] = ParseDateTime( "11/22/2002" ) />
		
	<cfset QueryAddRow( qPeople ) />
	<cfset qPeople[ "rank" ][ qPeople.RecordCount ] = JavaCast( "int", 4 ) />
	<cfset qPeople[ "name" ][ qPeople.RecordCount ] = JavaCast( "string", "Angela Bassett" ) />
	<cfset qPeople[ "hair" ][ qPeople.RecordCount ] = JavaCast( "string", "Brunette" ) />
	<cfset qPeople[ "best_feature" ][ qPeople.RecordCount ] = JavaCast( "string", "Angularity" ) />
	<cfset qPeople[ "hotness" ][ qPeople.RecordCount ] = JavaCast( "float", 8.0 ) />
	<cfset qPeople[ "last_fantasy" ][ qPeople.RecordCount ] = ParseDateTime( "05/15/2003" ) />
	
	<cfset QueryAddRow( qPeople ) />
	<cfset qPeople[ "rank" ][ qPeople.RecordCount ] = JavaCast( "int", 5 ) />
	<cfset qPeople[ "name" ][ qPeople.RecordCount ] = JavaCast( "string", "Michelle Rodriguez" ) />
	<cfset qPeople[ "hair" ][ qPeople.RecordCount ] = JavaCast( "string", "Brunette" ) />
	<cfset qPeople[ "best_feature" ][ qPeople.RecordCount ] = JavaCast( "string", "Muscularity" ) />
	<cfset qPeople[ "hotness" ][ qPeople.RecordCount ] = JavaCast( "float", 8.0 ) />
	<cfset qPeople[ "last_fantasy" ][ qPeople.RecordCount ] = ParseDateTime( "01/01/2008" ) />
	
</cfloop>

<!---
<cfdump var="#qPeople#" />
<cfabort />
--->

<!--- Import the POI tag library. --->
<cfimport taglib="../lib/tags/poi/" prefix="poi" />
	
	
<!--- 
	Create an excel document and store binary data into REQUEST variable 
	(if we also/or wanted to save this to disk, we could have supplied a 
	"file" attribute). We are going to supply our branded template for 
	this report by using the "template" attribute in the document tag.
--->
<poi:document 
	name="REQUEST.ExcelData"
	template="#ExpandPath( './branded_template.xls' )#"
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
			name="Smokin' Hotties">
		
			<!--- 
				Define global column styles. 
				
				NOTE: Because our branded template has an image, we do NOT 
				want to use the column width style. This will cause the image 
				to be resized if it is in a cell that get's resized.
			--->
			<poi:columns>
				<poi:column style="text-align: center ;" />
				<poi:column />
				<poi:column />
				<poi:column style="text-align: center ;" />
				<poi:column style="text-align: left ;" />
			</poi:columns>
			
			<!--- 
				Title row. Start on the second (2nd) row since the first row 
				of our branded template has our corporate logo on it.
			--->
			<poi:row index="2" class="title">
				<poi:cell value="Hot Celebrity Action" colspan="5" />
			</poi:row>
			
			<!--- Header row. --->
			<poi:row class="header" freeze="true">
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
					<poi:cell type="numeric" value="#qPeople.hotness#" />
					<poi:cell type="date" dateformat="m/d/yy" value="#qPeople.last_fantasy#" />
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

