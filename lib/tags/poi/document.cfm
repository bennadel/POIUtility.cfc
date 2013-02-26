
<!--- Check to see which version of the tag we are executing. --->
<cfswitch expression="#THISTAG.ExecutionMode#">

	<cfcase value="Start">
	
		<!--- Param the tag attributes. --->
		
		<!--- 
			The CALLER-scoped variable into which the Excel binary will 
			be stored. If this is used, a Java ByteArrayOutputStream will
			be used to hold the final document value.
		--->
		<cfparam
			name="ATTRIBUTES.Name"
			type="string"
			default=""
			/>
			
		<!--- 
			The Expanded file path at which the Excel file will be saved.
			This can be used in conjunction with the Name value. 
		--->
		<cfparam
			name="ATTRIBUTES.File"
			type="string"
			default=""
			/>
			
		<!--- 
			The Expanded file path of the template to be used. We will not
			write to this template, but rather create a copy of it for our
			base document.
		--->
		<cfparam
			name="ATTRIBUTES.Template"
			type="string"
			default=""
			/>
			
		<!--- 
			This is the default style that will be applied as the base format
			for each cell in the workbook.
		--->
		<cfparam
			name="ATTRIBUTES.Style"
			type="string"
			default=""
			/>
	
	
		<!--- Make sure that we have the proper attributes. --->
		<cfif NOT (
			IsValid( "variablename", ATTRIBUTES.Name ) OR
			Len( ATTRIBUTES.File )
			)>
			
			<!--- Throw attribute validation error. --->
			<cfthrow
				type="Document.InvalidAttributes"
				message="Invalid attributes on the Document tag."
				detail="The DOCUMENT tag requires either a NAME and/or FILE attribute."
				/>
			
		</cfif>
	
	
		<!--- 
			Create the Excel workbook to which we will be writing. Check 
			to see if we are creating a totally new workbook, or if we want 
			to use an existing template.
		--->
		<cfif Len( ATTRIBUTES.Template )>
		
			<!--- Read in existing workbook. --->
			<cfset VARIABLES.WorkBook = CreateObject( "java", "org.apache.poi.hssf.usermodel.HSSFWorkbook" ).Init(
				CreateObject( "java", "java.io.FileInputStream" ).Init(
					JavaCast( "string", ATTRIBUTES.Template )
					)
				) />
		
		<cfelse>
			
			<!--- Create a new workbook. --->
			<cfset VARIABLES.WorkBook = CreateObject( "java", "org.apache.poi.hssf.usermodel.HSSFWorkbook" ).Init() />
			
		</cfif>
	
		<!--- 
			Create a data formatter utility object (we will need this to 
			get the formatting index later on when we set the cell styles).
		--->
		<cfset VARIABLES.DataFormat = CreateObject( "java", "org.apache.poi.hssf.usermodel.HSSFDataFormat" ) />
	
		<!--- Create an index of available number formats. --->
		<cfset VARIABLES.NumberFormats = {} />
		<cfset VARIABLES.NumberFormats[ "General" ] = true />
		<cfset VARIABLES.NumberFormats[ "0" ] = true />
		<cfset VARIABLES.NumberFormats[ "0.00" ] = true />
		<cfset VARIABLES.NumberFormats[ "##,####0" ] = true />
		<cfset VARIABLES.NumberFormats[ "##,####0.00" ] = true />
		<cfset VARIABLES.NumberFormats[ "($##,####0_);($##,####0)" ] = true />
		<cfset VARIABLES.NumberFormats[ "($##,####0_);[Red]($##,####0)" ] = true />
		<cfset VARIABLES.NumberFormats[ "($##,####0.00);($##,####0.00)" ] = true />
		<cfset VARIABLES.NumberFormats[ "($##,####0.00_);[Red]($##,####0.00)" ] = true />
		<cfset VARIABLES.NumberFormats[ "0%" ] = true />
		<cfset VARIABLES.NumberFormats[ "0.00%" ] = true />
		<cfset VARIABLES.NumberFormats[ "0.00E+00" ] = true />
		<cfset VARIABLES.NumberFormats[ "## ?/?" ] = true />
		<cfset VARIABLES.NumberFormats[ "## ??/??" ] = true />
		<cfset VARIABLES.NumberFormats[ "(##,####0_);[Red](##,####0)" ] = true />
		<cfset VARIABLES.NumberFormats[ "(##,####0.00_);(##,####0.00)" ] = true />
		<cfset VARIABLES.NumberFormats[ "(##,####0.00_);[Red](##,####0.00)" ] = true />
		<cfset VARIABLES.NumberFormats[ "_(*##,####0_);_(*(##,####0);_(* \""-\""_);_(@_)" ] = true />
		<cfset VARIABLES.NumberFormats[ "_($*##,####0_);_($*(##,####0);_($* \""-\""_);_(@_)" ] = true />
		<cfset VARIABLES.NumberFormats[ "_(*##,####0.00_);_(*(##,####0.00);_(*\""-\""??_);_(@_)" ] = true />
		<cfset VARIABLES.NumberFormats[ "_($*##,####0.00_);_($*(##,####0.00);_($*\""-\""??_);_(@_)" ] = true />
		<cfset VARIABLES.NumberFormats[ "####0.0E+0" ] = true />
		<cfset VARIABLES.NumberFormats[ "@" ] = true />  <!--- This is text format. --->
		<cfset VARIABLES.NumberFormats[ "text" ] = true />	<!--- Alias for "@" --->
		
		<!--- Create an index of avilable date formates. --->
		<cfset VARIABLES.DateFormats = {} />
		<cfset VARIABLES.DateFormats[ "m/d/yy" ] = true />
		<cfset VARIABLES.DateFormats[ "d-mmm-yy" ] = true />
		<cfset VARIABLES.DateFormats[ "d-mmm" ] = true />
		<cfset VARIABLES.DateFormats[ "mmm-yy" ] = true />
		<cfset VARIABLES.DateFormats[ "h:mm AM/PM" ] = true />
		<cfset VARIABLES.DateFormats[ "h:mm:ss AM/PM" ] = true />
		<cfset VARIABLES.DateFormats[ "h:mm" ] = true />
		<cfset VARIABLES.DateFormats[ "h:mm:ss" ] = true />
		<cfset VARIABLES.DateFormats[ "m/d/yy h:mm" ] = true />
		<cfset VARIABLES.DateFormats[ "mm:ss" ] = true />
		<cfset VARIABLES.DateFormats[ "[h]:mm:ss" ] = true />
		<cfset VARIABLES.DateFormats[ "mm:ss.0" ] = true />
		
		<!--- 
			Create an index for the column look up. We will need this when 
			defining the cell aliases in forumlas. 
		--->
		<cfset VARIABLES.ColumnLookup = ListToArray( "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z" ) />
			
		<!--- Create a structure for storing cell aliases. --->
		<cfset VARIABLES.CellAliases = {} />
		
		
		<!--- 
			Create a instance of the utiltiy object, CSSRule. This will be use used
			by this tag and its child tags to parse CSS as well as manipulate it. 
		--->
		<cfset VARIABLES.CSSRule = CreateObject( "component", "CSSRule" ).Init() />
				
		<!--- 
			Create a struct to hold the CSS classes by name. These classes will be 
			the Structures holding the basic css properties.
		--->
		<cfset VARIABLES.Classes = StructNew() />
		
		<!--- Create default CSS classes for the different cells. --->
		<cfset VARIABLES.Classes[ "@cell" ] = VARIABLES.CSSRule.AddCSS( 
			StructNew(),
			ATTRIBUTES.Style
			) />
		
		<!--- 
			Create a cache of cell format objects (Java objects use in the 
			POI cell formatting). This is done to get around the "too many fonts" 
			issue that is caused with larger documents.
			
			We are going to be using the "style" struct to cache the Java style
			objects in a Java Hashtable.
		--->
		<cfset VARIABLES.CellStyles = CreateObject( "java", "java.util.Hashtable" ).Init() />
				
		<!--- 
			Create a variable for the current sheet index. This will become
			important when we are using an existing template rather than 
			creating a new workbook from scratch. This contains the VALUE OF 
			THE CURRENT SHEET.
		--->
		<cfset VARIABLES.SheetIndex = 1 />
	
	</cfcase>
	
	
	<cfcase value="End">
	
	
		<!--- 
			At this point, we have created our Excel document. Now, we need 
			to write it to the output variable(s). Check to see if we have a 
			file name to write to. 
		--->
		<cfif Len( ATTRIBUTES.File )>
			
			<!--- Create the file output stream. --->
			<cfset VARIABLES.FileOutputStream = CreateObject( "java", "java.io.FileOutputStream" ).Init(
				JavaCast( "string", ATTRIBUTES.File )
				) />
			
			<!--- Write the Excel workbook contents to the output stream. --->
			<cfset VARIABLES.WorkBook.Write( 
				VARIABLES.FileOutputStream 
				) />
		
			<!--- 
				Close the file output stream to make sure that all locks on 
				the file are released. 
			--->
			<cfset VARIABLES.FileOutputStream.Close() />
		
		</cfif>
		
		
		<!--- Check to see if we have a variable to return the workbook to. --->
		<cfif Len( ATTRIBUTES.Name )>
			
			<!--- 
				Create the byte array output stream so that we can write the 
				binary contents to a RAM-stored array.
			--->
			<cfset VARIABLES.ByteArrayOutputStream = CreateObject( "java", "java.io.ByteArrayOutputStream" ).Init() />
			
			<!--- Write the Excel workbook contents to the output stream. --->
			<cfset VARIABLES.WorkBook.Write( 
				VARIABLES.ByteArrayOutputStream 
				) />
		
			<!--- Store the byte array into the CALLER-scoped variable. --->
			<cfset "CALLER.#ATTRIBUTES.Name#" = VARIABLES.ByteArrayOutputStream />
		
		</cfif>
	
	
		<!--- 
			Before we return out, we want to make sure to clear out any 
			generated content produced by the tag. 
		--->
		<cfset THISTAG.GeneratedContent = "" />
	
	</cfcase>

</cfswitch>