
<cfcomponent
	output="false"
	hint="Handles CSS utility functions.">
	
	<!--- 
		Set up the default CSS properties for this rule. This will 
		be used to create other hash maps.
	--->
	<cfset VARIABLES.CSS = {} />
	<cfset VARIABLES.CSS[ "background-attachment" ] = "" />
	<cfset VARIABLES.CSS[ "background-color" ] = "" />
	<cfset VARIABLES.CSS[ "background-image" ] = "" />
	<cfset VARIABLES.CSS[ "background-position" ] = "" />
	<cfset VARIABLES.CSS[ "background-repeat" ] = "" />
	<cfset VARIABLES.CSS[ "border-top-width" ] = "" />
	<cfset VARIABLES.CSS[ "border-top-color" ] = "" />
	<cfset VARIABLES.CSS[ "border-top-style" ] = "" />
	<cfset VARIABLES.CSS[ "border-right-width" ] = "" />
	<cfset VARIABLES.CSS[ "border-right-color" ] = "" />
	<cfset VARIABLES.CSS[ "border-right-style" ] = "" />
	<cfset VARIABLES.CSS[ "border-bottom-width" ] = "" />
	<cfset VARIABLES.CSS[ "border-bottom-color" ] = "" />
	<cfset VARIABLES.CSS[ "border-bottom-style" ] = "" />
	<cfset VARIABLES.CSS[ "border-left-width" ] = "" />
	<cfset VARIABLES.CSS[ "border-left-color" ] = "" />
	<cfset VARIABLES.CSS[ "border-left-style" ] = "" />
	<cfset VARIABLES.CSS[ "bottom" ] = "" />
	<cfset VARIABLES.CSS[ "color" ] = "" />
	<cfset VARIABLES.CSS[ "display" ] = "" />
	<cfset VARIABLES.CSS[ "font-family" ] = "" />
	<cfset VARIABLES.CSS[ "font-size" ] = "" />
	<cfset VARIABLES.CSS[ "font-style" ] = "" />
	<cfset VARIABLES.CSS[ "font-weight" ] = "" />
	<cfset VARIABLES.CSS[ "height" ] = "" />
	<cfset VARIABLES.CSS[ "left" ] = "" />
	<cfset VARIABLES.CSS[ "list-style-image" ] = "" />
	<cfset VARIABLES.CSS[ "list-style-position" ] = "" />
	<cfset VARIABLES.CSS[ "list-style-type" ] = "" />
	<cfset VARIABLES.CSS[ "margin-top" ] = "" />
	<cfset VARIABLES.CSS[ "margin-right" ] = "" />
	<cfset VARIABLES.CSS[ "margin-bottom" ] = "" />
	<cfset VARIABLES.CSS[ "margin-left" ] = "" />
	<cfset VARIABLES.CSS[ "padding-top" ] = "" />
	<cfset VARIABLES.CSS[ "padding-right" ] = "" />
	<cfset VARIABLES.CSS[ "padding-bottom" ] = "" />
	<cfset VARIABLES.CSS[ "padding-left" ] = "" />
	<cfset VARIABLES.CSS[ "position" ] = "" />
	<cfset VARIABLES.CSS[ "right" ] = "" />
	<cfset VARIABLES.CSS[ "text-align" ] = "" />
	<cfset VARIABLES.CSS[ "text-decoration" ] = "" />
	<cfset VARIABLES.CSS[ "top" ] = "" />
	<cfset VARIABLES.CSS[ "vertical-align" ] = "" />
	<cfset VARIABLES.CSS[ "white-space" ] = "" />
	<cfset VARIABLES.CSS[ "width" ] = "" />
	<cfset VARIABLES.CSS[ "z-index" ] = "" />
	
	<!--- 
		Set up the validation rules for the CSS properties. Each
		property must fit in a certain format. These formats 
		will be defined using regular expressions and will be 
		used to match the entire value (no partial matching).
	--->
	<cfset VARIABLES.CSSValidation = {} />
	<cfset VARIABLES.CSSValidation[ "background-attachment" ] = "scroll|fixed" />
	<cfset VARIABLES.CSSValidation[ "background-color" ] = "\w+|##[0-9ABCDEF]{6}" />
	<cfset VARIABLES.CSSValidation[ "background-image" ] = "url\([^\)]+\)" />
	<cfset VARIABLES.CSSValidation[ "background-position" ] = "(top|right|bottom|left|\d+(\.\d+)?(px|%|em)) (top|right|bottom|left|\d+(\.\d+)?(px|%|em))" />
	<cfset VARIABLES.CSSValidation[ "background-repeat" ] = "(no-)?repeat(-x|-y)?" />
	<cfset VARIABLES.CSSValidation[ "border-top-width" ] = "\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation[ "border-top-color" ] = "\w+|##[0-9ABCDEF]{6}" />
	<cfset VARIABLES.CSSValidation[ "border-top-style" ] = "none|dotted|dashed|solid|double|groove" />
	<cfset VARIABLES.CSSValidation[ "border-right-width" ] = "\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation[ "border-right-color" ] = "\w+|##[0-9ABCDEF]{6}" />
	<cfset VARIABLES.CSSValidation[ "border-right-style" ] = "none|dotted|dashed|solid|double|groove" />
	<cfset VARIABLES.CSSValidation[ "border-bottom-width" ] = "\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation[ "border-bottom-color" ] = "\w+|##[0-9ABCDEF]{6}" />
	<cfset VARIABLES.CSSValidation[ "border-bottom-style" ] = "none|dotted|dashed|solid|double|groove" />
	<cfset VARIABLES.CSSValidation[ "border-left-width" ] = "\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation[ "border-left-color" ] = "\w+|##[0-9ABCDEF]{6}" />
	<cfset VARIABLES.CSSValidation[ "border-left-style" ] = "none|dotted|dashed|solid|double|groove" />
	<cfset VARIABLES.CSSValidation[ "bottom" ] = "-?\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation[ "color" ] = "\w+|##[0-9ABCDEF]{6}" />
	<cfset VARIABLES.CSSValidation[ "display" ] = "inline|block|block" />
	<cfset VARIABLES.CSSValidation[ "font-family" ] = "((\w+|""[^""]""+)(\s*,\s*)?)+" />
	<cfset VARIABLES.CSSValidation[ "font-size" ] = "\d+(\.\d+)?(px|pt|em|%)" />
	<cfset VARIABLES.CSSValidation[ "font-style" ] = "normal|italic" />
	<cfset VARIABLES.CSSValidation[ "font-weight" ] = "normal|lighter|bold|bolder|[1-9]00" />
	<cfset VARIABLES.CSSValidation[ "height" ] = "\d+(\.\d+)?(px|pt|em|%)" />
	<cfset VARIABLES.CSSValidation[ "left" ] = "-?\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation[ "list-style-image" ] = "none|url\([^\)]+\)" />
	<cfset VARIABLES.CSSValidation[ "list-style-position" ] = "inside|outside" />
	<cfset VARIABLES.CSSValidation[ "list-style-type" ] = "disc|circle|square|none" />
	<cfset VARIABLES.CSSValidation[ "margin-top" ] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation[ "margin-right" ] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation[ "margin-bottom" ] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation[ "margin-left" ] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation[ "padding-top" ] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation[ "padding-right" ] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation[ "padding-bottom" ] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation[ "padding-left" ] = "\d+(\.\d+)?(px|em)" />
	<cfset VARIABLES.CSSValidation[ "position" ] = "static|relative|absolute|fixed" />
	<cfset VARIABLES.CSSValidation[ "right" ] = "-?\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation[ "text-align" ] = "left|right|center|justify" />
	<cfset VARIABLES.CSSValidation[ "text-decoration" ] = "none|underline|overline|line-through" />
	<cfset VARIABLES.CSSValidation[ "top" ] = "-?\d+(\.\d+)?px" />
	<cfset VARIABLES.CSSValidation[ "vertical-align" ] = "bottom|middle|top" />
	<cfset VARIABLES.CSSValidation[ "white-space" ] = "normal|pre|nowrap" />
	<cfset VARIABLES.CSSValidation[ "width" ] = "\d+(\.\d+)?(px|pt|em|%)|auto" />
	<cfset VARIABLES.CSSValidation[ "z-index" ] = "\d+" />
	
	
	<!--- Here is an array of the alpha-sorted keys. --->
	<cfset VARIABLES.SortedPropertyKeys = StructKeyArray( VARIABLES.CSS ) />
	
	<!--- Sort the keys alphabetically. --->
	<cfset ArraySort( VARIABLES.SortedPropertyKeys, "textnocase", "asc" ) />
	
	
	<!--- 
		This is going to be a cached value of CSS strings. I am doing this 
		because if someone has a "style" inside of a large loop, I don't want 
		to be re-parsing that every single time. 
	--->
	<cfset VARIABLES.CSSCache = {} />
	
	
	<!--- Create a struct of valid colors. --->
	<cfset VARIABLES.POIColors = { 
		AQUA = true,
		BLACK = true,
		BLUE = true,
		BLUE_GREY = true,
		BRIGHT_GREEN = true,
		BROWN = true,
		CORAL = true,
		CORNFLOWER_BLUE = true,
		DARK_BLUE = true,
		DARK_GREEN = true,
		DARK_RED = true,
		DARK_TEAL = true,
		DARK_YELLOW = true,
		GOLD = true,
		GREEN = true,
		GREY_25_PERCENT = true,
		GREY_40_PERCENT = true,
		GREY_50_PERCENT = true,
		GREY_80_PERCENT = true,
		INDIGO = true,
		LAVENDER = true,
		LEMON_CHIFFON = true,
		LIGHT_BLUE = true,
		LIGHT_CORNFLOWER_BLUE = true,
		LIGHT_GREEN = true,
		LIGHT_ORANGE = true,
		LIGHT_TURQUOISE = true,
		LIGHT_YELLOW = true,
		LIME = true,
		MAROON = true,
		OLIVE_GREEN = true,
		ORANGE = true,
		ORCHID = true,
		PALE_BLUE = true,
		PINK = true,
		PLUM = true,
		RED = true,
		ROSE = true,
		ROYAL_BLUE = true,
		SEA_GREEN = true,
		SKY_BLUE = true,
		TAN = true,
		TEAL = true,
		TURQUOISE = true,
		VIOLET = true,
		WHITE = true,
		YELLOW = true
		} />
		
	
	<cffunction
		name="Init"
		access="public"
		returntype="any"
		output="false"
		hint="Returns an initialized component.">
		
		<!--- Return THIS reference. --->
		<cfreturn THIS />
	</cffunction>
	
	
	<cffunction
		name="AddCSS"
		access="public"
		returntype="struct"
		output="false"
		hint="Adds CSS properties to passed-in css hash map returns it.">
		
		<!--- Define arguments. --->
		<cfargument 
			name="PropertyMap" 
			type="struct" 
			required="true" 
			hint="I am the CSS hash map being updated." 
			/>		
		
		<cfargument
			name="CSS"
			type="string"
			required="true"
			hint="CSS properties for to be added to the given map (may have multiple properties separated by semi-colons)."
			/>
			
		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />
		
		
		<!--- 
			Check to see if this CSS string has already been cached. If not, 
			then we want to cache it locally first, then add it to the struct.
		--->
		<cfif NOT StructKeyExists( VARIABLES.CSSCache, ARGUMENTS.CSS )>
		
			<!--- Create a local property map. --->
			<cfset LOCAL.CachedPropertyMap = {} />
		
			<!--- Loop over the list of properties passed in. --->
			<cfloop
				index="LOCAL.Property"
				list="#ARGUMENTS.CSS#"
				delimiters=";">
				
				<!--- Add this property to the css map. --->
				<cfset THIS.AddProperty( 
					LOCAL.CachedPropertyMap,
					Trim( LOCAL.Property )
					) />
				
			</cfloop>
			
			
			<!--- Cache this property map. --->
			<cfset VARIABLES.CSSCache[ ARGUMENTS.CSS ] = LOCAL.CachedPropertyMap />
			
		</cfif>
		
		
		<!--- 
			ASSERT: At this point, we know that no matter what CSS string was 
			passed-in, we now have a version of it parsed and stored in the cache.
		--->
		
		
		<!--- Add the cached property map. --->
		<cfset StructAppend(
			ARGUMENTS.PropertyMap,
			VARIABLES.CSSCache[ ARGUMENTS.CSS ]
			) />		
		
		<!--- Return the updated map. --->
		<cfreturn ARGUMENTS.PropertyMap />
	</cffunction>
	
	
	<cffunction
		name="AddProperty"
		access="public"
		returntype="boolean"
		output="false"
		hint="Parses the given property and adds it to the given CSS property map.">
		
		<!--- Define arguments. --->
		<cfargument 
			name="PropertyMap" 
			type="struct" 
			required="true" 
			hint="I am the CSS hash map being updated." 
			/>
			
		<cfargument
			name="Property"
			type="string"
			required="true"
			hint="The name-value pair property that will be added to the CSS rule."
			/>
		
		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />
		
		<!--- 
			The property should be in name=value pair format. Break up the 
			property into the two parts. Also, make sure that we only have
			one property being set (as delimited by ";").
		--->
		<cfset LOCAL.Pair = ListToArray( 
			Trim( ListFirst( ARGUMENTS.Property , ";" ) ),
			":"
			) />
		
		<!--- 
			Check to see if we have two parts. If we have 
			anything but two parts, then this is not a valid 
			name-value pair. 
		--->
		<cfif (ArrayLen( LOCAL.Pair ) EQ 2)>
		
			<!--- Trim both parts of the pair. --->
			<cfset LOCAL.Name = Trim( LOCAL.Pair[ 1 ] ) />
			<cfset LOCAL.Value = Trim( LOCAL.Pair[ 2 ] ) />
		
			<!--- 
				When it comes to parsing the property, they might be 
				using a simple one that we have. If not, we have to 
				get a little more creative with the parsing. 
			--->
			<cfif THIS.IsValidValue( LOCAL.Name, LOCAL.Value )>
				
				<!--- This value has validated. Add it to the CSS properties. --->
				<cfset ARGUMENTS.PropertyMap[ LOCAL.Name ] = LOCAL.Value />
			
				<!--- Return true for success. --->
				<cfreturn true />
			
			<cfelse>
			
				<!--- 
					We were not given a simple value; we were given a value that 
					we will have to parse out into the individual properties.
				--->
				<cfswitch expression="#LOCAL.Name#">
				
					<cfcase value="background">
						<cfset THIS.SetBackground( ARGUMENTS.PropertyMap, LOCAL.Value ) />
					</cfcase>
					
					<cfcase value="border,border-top,border-right,border-bottom,border-left" delimiters=",">
						<cfset THIS.SetBorder( ARGUMENTS.PropertyMap, LOCAL.Name, LOCAL.Value ) />
					</cfcase>
					
					<cfcase value="font">
						<cfset THIS.SetFont( ARGUMENTS.PropertyMap, LOCAL.Value ) />
					</cfcase>
					
					<cfcase value="list-style">
						<cfset THIS.SetListStyle( ARGUMENTS.PropertyMap, LOCAL.Value ) />
					</cfcase>
					
					<cfcase value="margin" delimiters=",">
						<cfset THIS.SetMargin( ARGUMENTS.PropertyMap, LOCAL.Value ) />
					</cfcase>
				
					<cfcase value="padding" delimiters=",">
						<cfset THIS.SetPadding( ARGUMENTS.PropertyMap, LOCAL.Value ) />
					</cfcase>
					
				</cfswitch>
			
			</cfif>
		
		</cfif>		
		
		<!--- 
			Return out. If we made it this far, then we 
			didn't add a valid property.
		--->
		<cfreturn false />
	</cffunction>
	
	
	<cffunction
		name="ApplyToCellStyle"
		access="public"
		returntype="any"
		output="false"
		hint="Applies the current CSS property map to the given HSSFCellStyle object.">
		
		<!--- Define arguments. --->
		<cfargument 
			name="PropertyMap" 
			type="struct" 
			required="true" 
			hint="I am the CSS hash map being updated." 
			/>
			
		<cfargument
			name="Workbook"
			type="any"
			required="true"
			hint="The workbook containing this cell style."
			/>
			
		<cfargument
			name="CellStyle"
			type="any"
			required="true"
			hint="The HSSFCellStyle instance to which we are applying the CSS property rules."
			/>
		
		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />
		
		
		<!--- Create a local copy of the full CSS definition. --->
		<cfset LOCAL.PropertyMap = StructCopy( VARIABLES.CSS ) />
		
		<!--- 
			Now, append the passed in property map to this local one. That will give 
			us a full CSS property map with only the relatvant values filled in.
		--->
		<cfset StructAppend( LOCAL.PropertyMap, ARGUMENTS.PropertyMap ) />
		
		
		<!--- Get a new font object from the workbook. --->
		<cfset LOCAL.Font = ARGUMENTS.WorkBook.CreateFont() />
		
		
		<!--- 
			Check to see if we have an appropriate background color; Excel won't 
			just use any color - it has to be one of their index colors. 
		--->
		<cfif (
			Len( LOCAL.PropertyMap[ "background-color" ] ) AND
			StructKeyExists( VARIABLES.POIColors, LOCAL.PropertyMap[ "background-color" ] )
			)>
			
			<!--- 
				Set the foreground color using the background color. We will need 
				to create an instance of the HSSFColor inner class to get the index 
				value of the color.
			--->
			<cfset ARGUMENTS.CellStyle.SetFillForegroundColor(
				CreateObject( 
					"java",
					"org.apache.poi.hssf.util.HSSFColor$#UCase( LOCAL.PropertyMap[ 'background-color' ] )#"
					).GetIndex()
				) />
				
				
			<!--- Set a solid background fill. --->
			<cfset ARGUMENTS.CellStyle.SetFillPattern( ARGUMENTS.CellStyle.SOLID_FOREGROUND ) />
		
		<cfelseif (LOCAL.PropertyMap[ "background-color" ] EQ "transparent")>
			
			<!--- The user has requested no background color.  --->
			<cfset ARGUMENTS.CellStyle.SetFillPattern( ARGUMENTS.CellStyle.NO_FILL ) />
			
		</cfif>
		
		
		<!--- Loop over the four border directions. --->
		<cfloop
			index="LOCAL.BorderSide"
			list="top,right,bottom,left"
			delimiters=",">
			
			<!--- Check to see if there is a width. --->
			<cfif Len( LOCAL.PropertyMap[ "border-#LOCAL.BorderSide#-width" ] )>
			
				<!--- Check for the style. --->
				<cfswitch expression="#LOCAL.PropertyMap[ 'border-#LOCAL.BorderSide#-style' ]#">
				
					<cfcase value="dotted">
						
						<cfswitch expression="#Val( LOCAL.PropertyMap[ 'border-#LOCAL.BorderSide#-width' ] )#">
							<cfcase value="0">
								<cfset LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_NONE />
							</cfcase>
							<cfcase value="1">
								<cfset LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_DOTTED />
							</cfcase>
							<cfcase value="2">
								<cfset LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_DASH_DOT_DOT />
							</cfcase>
							<cfdefaultcase>
								<cfset LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_MEDIUM_DASH_DOT_DOT />
							</cfdefaultcase>
						</cfswitch>
						
					</cfcase>
					
					<cfcase value="dashed">
						
						<cfswitch expression="#Val( LOCAL.PropertyMap[ 'border-#LOCAL.BorderSide#-width' ] )#">
							<cfcase value="0">
								<cfset LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_NONE />
							</cfcase>
							<cfcase value="1">
								<cfset LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_DASHED />
							</cfcase>
							<cfdefaultcase>
								<cfset LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_MEDIUM_DASHED />
							</cfdefaultcase>
						</cfswitch>
						
					</cfcase>
					
					<cfcase value="double">
						
						<cfswitch expression="#Val( LOCAL.PropertyMap[ 'border-#LOCAL.BorderSide#-width' ] )#">
							<cfcase value="0">
								<cfset LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_NONE />
							</cfcase>
							<cfdefaultcase>
								<cfset LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_DOUBLE />
							</cfdefaultcase>
						</cfswitch>
						
					</cfcase>
					
					<!--- Default to solid border. --->
					<cfdefaultcase>
						
						<cfswitch expression="#Val( LOCAL.PropertyMap[ 'border-#LOCAL.BorderSide#-width' ] )#">
							<cfcase value="0">
								<cfset LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_NONE />
							</cfcase>
							<cfcase value="1">
								<cfset LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_HAIR />
							</cfcase>
							<cfcase value="2">
								<cfset LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_THIN />
							</cfcase>
							<cfcase value="3">
								<cfset LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_MEDIUM />
							</cfcase>
							<cfdefaultcase>
								<cfset LOCAL.BorderStyle = ARGUMENTS.CellStyle.BORDER_THICK />
							</cfdefaultcase>
						</cfswitch>
						
					</cfdefaultcase>
				
				</cfswitch>	
				
				
				<!--- Check to see if we have a border color. --->
				<cfif (
					Len( LOCAL.PropertyMap[ "border-#LOCAL.BorderSide#-color" ] ) AND
					StructKeyExists( VARIABLES.POIColors, LOCAL.PropertyMap[ "border-#LOCAL.BorderSide#-color" ] )
					)>
					
					<!--- Get the border color. --->
					<cfset LOCAL.BorderColor = CreateObject( 
						"java",
						"org.apache.poi.hssf.util.HSSFColor$#UCase( LOCAL.PropertyMap[ 'border-#LOCAL.BorderSide#-color' ] )#"
						).GetIndex() />
				
				<cfelse>
					
					<!--- Get the default border color (black). --->
					<cfset LOCAL.BorderColor = CreateObject( 
						"java",
						"org.apache.poi.hssf.util.HSSFColor$BLACK"
						).GetIndex() />
						
				</cfif>
			
			
				
				<!--- Check to see which direction we are working width. --->
				<cfswitch expression="#LOCAL.BorderSide#">
					<cfcase value="top">
					
						<!--- Set border style. --->
						<cfset ARGUMENTS.CellStyle.SetBorderTop( LOCAL.BorderStyle ) />
					
						<!--- Set border color. --->
						<cfset ARGUMENTS.CellStyle.SetTopBorderColor( LOCAL.BorderColor ) />
						
					</cfcase>
					<cfcase value="right">
					
						<!--- Set border style. --->
						<cfset ARGUMENTS.CellStyle.SetBorderRight( LOCAL.BorderStyle ) />
					
						<!--- Set border color. --->
						<cfset ARGUMENTS.CellStyle.SetRightBorderColor( LOCAL.BorderColor ) />
						
					</cfcase>
					<cfcase value="bottom">
					
						<!--- Set border style. --->
						<cfset ARGUMENTS.CellStyle.SetBorderBottom( LOCAL.BorderStyle ) />
					
						<!--- Set border color. --->
						<cfset ARGUMENTS.CellStyle.SetBottomBorderColor( LOCAL.BorderColor ) />
						
					</cfcase>
					<cfcase value="left">
					
						<!--- Set border style. --->
						<cfset ARGUMENTS.CellStyle.SetBorderLeft( LOCAL.BorderStyle ) />
					
						<!--- Set border color. --->
						<cfset ARGUMENTS.CellStyle.SetLeftBorderColor( LOCAL.BorderColor ) />
						
					</cfcase>
				</cfswitch>
							
			</cfif>
			
		</cfloop>
		
		
		<!--- 
			Check to see if we have an appropriate text color; Excel won't 
			just use any color - it has to be one of their index colors. 
		--->
		<cfif (
			Len( LOCAL.PropertyMap[ "color" ] ) AND
			StructKeyExists( VARIABLES.POIColors, LOCAL.PropertyMap[ "color" ] )
			)>
		
			<!--- Set the font color. --->
			<cfset LOCAL.Font.SetColor(
				CreateObject( 
					"java",
					"org.apache.poi.hssf.util.HSSFColor$#UCase( LOCAL.PropertyMap[ 'color' ] )#"
					).GetIndex()
				) />
				
		</cfif>
		
		
		<!--- Check for font family. --->
		<cfif Len( LOCAL.PropertyMap[ "font-family" ] )>
			
			<cfset LOCAL.Font.SetFontName(
				JavaCast( "string", LOCAL.PropertyMap[ "font-family" ] )
				) />
			
		</cfif>
		
		
		<!--- Check for font style. --->
		<cfswitch expression="#LOCAL.PropertyMap[ 'font-style' ]#">
			
			<cfcase value="italic">
			
				<cfset LOCAL.Font.SetItalic( JavaCast( "boolean", true ) ) />
			
			</cfcase>
		
		</cfswitch>
		
		
		<!--- Check for font weight. --->
		<cfswitch expression="#LOCAL.PropertyMap[ 'font-weight' ]#">
			
			<cfcase value="bold,600,700,800,900" delimiters=",">
			
				<cfset LOCAL.Font.SetBoldWeight(
					LOCAL.Font.BOLDWEIGHT_BOLD
					) />
			
			</cfcase>
		
			<cfcase value="normal,100,200,300,400,500" delimiters=",">
			
				<cfset LOCAL.Font.SetBoldWeight(
					LOCAL.Font.BOLDWEIGHT_NORMAL
					) />
			
			</cfcase>
		
		</cfswitch>
		
		
		<!--- Check for font size. --->
		<cfif Val( LOCAL.PropertyMap[ "font-size" ] )>
			
			<cfset LOCAL.Font.SetFontHeightInPoints( 
				JavaCast( "int", Val( LOCAL.PropertyMap[ "font-size" ] ) )
				) />
		
		</cfif>
		
			
		<!--- Check to see if we have any text alignment. --->
		<cfswitch expression="#LOCAL.PropertyMap[ 'text-align' ]#">
			<cfcase value="right">
				<cfset ARGUMENTS.CellStyle.SetAlignment( ARGUMENTS.CellStyle.ALIGN_RIGHT ) />
			</cfcase>
			<cfcase value="center">
				<cfset ARGUMENTS.CellStyle.SetAlignment( ARGUMENTS.CellStyle.ALIGN_CENTER ) />
			</cfcase>
			<cfcase value="justify">
				<cfset ARGUMENTS.CellStyle.SetAlignment( ARGUMENTS.CellStyle.ALIGN_JUSTIFY ) />
			</cfcase>
			<cfcase value="left">
				<cfset ARGUMENTS.CellStyle.SetAlignment( ARGUMENTS.CellStyle.ALIGN_LEFT ) />
			</cfcase>
		</cfswitch>
			
			
		<!--- Check to see if we have any vertical alignment. --->
		<cfswitch expression="#LOCAL.PropertyMap[ 'vertical-align' ]#">
			<cfcase value="bottom">
				<cfset ARGUMENTS.CellStyle.SetVerticalAlignment( ARGUMENTS.CellStyle.VERTICAL_BOTTOM ) />
			</cfcase>
			<cfcase value="middle">
				<cfset ARGUMENTS.CellStyle.SetVerticalAlignment( ARGUMENTS.CellStyle.VERTICAL_CENTER ) />
			</cfcase>
			<cfcase value="center">
				<cfset ARGUMENTS.CellStyle.SetVerticalAlignment( ARGUMENTS.CellStyle.VERTICAL_CENTER ) />
			</cfcase>
			<cfcase value="justify">
				<cfset ARGUMENTS.CellStyle.SetVerticalAlignment( ARGUMENTS.CellStyle.VERTICAL_JUSTIFY ) />
			</cfcase>
			<cfcase value="top">
				<cfset ARGUMENTS.CellStyle.SetVerticalAlignment( ARGUMENTS.CellStyle.VERTICAL_TOP ) />
			</cfcase>
		</cfswitch>
		
		
		<!--- 
			Check for white space. If we have normal, which is the default, then 
			let's turn on the text wrap. If we have anything else, then turn off 
			the text wrap.
		--->
		<cfswitch expression="#LOCAL.PropertyMap[ 'white-space' ]#">
			<cfcase value="nowrap,pre" delimiters=",">
				<cfset ARGUMENTS.CellStyle.SetWrapText( JavaCast( "boolean", false ) ) />
			</cfcase>
		
			<!--- Default is "normal", which will turn it on. --->
			<cfdefaultcase>
				<cfset ARGUMENTS.CellStyle.SetWrapText( JavaCast( "boolean", true ) ) />
			</cfdefaultcase>
		</cfswitch>
								
			
		<!--- Apply the font to the current style. --->
		<cfset ARGUMENTS.CellStyle.SetFont( LOCAL.Font ) />
			
		<!--- Return the updated cell style object. --->
		<cfreturn ARGUMENTS.CellStyle />
	</cffunction>
			
	
	<!--- 
		This has been moved out into the actual POI tag code. Currently, we are 
		using the underyling Java method, .HashCode() of structures (which are 
		actually HashTables in Java). 
	--->
	<!---
	<cffunction
		name="GetHash"
		access="public"
		returntype="string"
		output="false"
		hint="Gets the hashed version of the given CSS property map. This creates a unique and easily comparable version of the map.">
		
		<!--- Define arguments. --->
		<cfargument 
			name="PropertyMap" 
			type="struct" 
			required="true" 
			hint="I am the CSS hash map for which we are getting the hash." 
			/>
		
		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />
		
		<!--- Create a buffer for the pre-hash value. --->
		<cfset LOCAL.Buffer = "" />
		
		<!--- Now, loop over the array and create out pre-hash value. --->
		<cfloop
			index="LOCAL.PropertyKey"
			array="#VARIABLES.SortedPropertyKeys#">
			
			<!--- Add the property / value pair. --->
			<cfset LOCAL.Buffer &= "#LOCAL.PropertyKey#:#ARGUMENTS.PropertyMap[ LOCAL.PropertyKey ]#&" />
			
		</cfloop>
		
		<!--- Return the hash. --->
		<cfreturn Hash( LOCAL.Buffer, "SHA-256" ) />
	</cffunction>
	--->
	
	
	<cffunction
		name="GetPropertyTokens"
		access="public"
		returntype="array"
		output="false"
		hint="Parsese the property value into individual tokens.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="string"
			required="true"
			hint="The value we want to parse into an array of tokens."
			/>
		
		<!--- 
			Get the tokens. These are the smallest meaningful 
			pieces of any CSS property. 
		--->
		<cfreturn REMatch(
			(
				"(?i)" & 
				"url\([^\)]+\)|" & 
				"""[^""]+""|" &
				"##[0-9ABCDEF]{6}|" &
				"([\w\.\-%]+(\s*,\s*)?)+"
			),
			ARGUMENTS.Value
			) />
	</cffunction>
	
	
	<cffunction 
		name="IsValidValue"
		access="public"
		returntype="boolean"
		output="false"
		hint="Checks to see if the given value validated for a given property.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Property"
			type="string"
			required="true"
			hint="The property we are checking for."
			/>
			
		<cfargument
			name="Value"
			type="string"
			required="true"
			hint="The value we are checking for validity."
			/>
		
		<!--- 
			Return whether it validates. If the property is not 
			valid, we are returning false (same as an invalid value). 
		--->
		<cfreturn (
			StructKeyExists( VARIABLES.CSS, ARGUMENTS.Property ) AND
			REFind( "(?i)^#VARIABLES.CSSValidation[ ARGUMENTS.Property ]#$", ARGUMENTS.Value )
			) />
	</cffunction>
	
	
	<cffunction
		name="ParseQuadMetric"
		access="public"
		returntype="array"
		output="false"
		hint="Takes a quad metric and returns a four-point array.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="string"
			required="true"
			hint="The metric which may have between one and four values."
			/>
			
		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />
		
		<!--- Grab metric values. --->
		<cfset LOCAL.Values = REMatch( "\d+(\.\d+)?(px|em)", ARGUMENTS.Value ) />
		
		<!--- Set up the return array. --->
		<cfset LOCAL.Return = [ "", "", "", "" ] />
			
		<!--- Check to see how many values we have. --->
		<cfif (ArrayLen( LOCAL.Values ) EQ 1)>
			
			<!--- Copy to all positions. --->
			<cfset ArraySet( LOCAL.Return, 1, 4, LOCAL.Values[ 1 ] ) />
			
		<cfelseif (ArrayLen( LOCAL.Values ) EQ 2)>
			
			<!--- Copy 2 and 2. --->
			<cfset LOCAL.Return[ 1 ] = LOCAL.Values[ 1 ] />
			<cfset LOCAL.Return[ 2 ] = LOCAL.Values[ 2 ] />
			<cfset LOCAL.Return[ 3 ] = LOCAL.Values[ 1 ] />
			<cfset LOCAL.Return[ 4 ] = LOCAL.Values[ 2 ] />
			
		<cfelseif (ArrayLen( LOCAL.Values ) EQ 3)>
			
			<!--- Copy 3 and 1. --->
			<cfset LOCAL.Return[ 1 ] = LOCAL.Values[ 1 ] />
			<cfset LOCAL.Return[ 2 ] = LOCAL.Values[ 2 ] />
			<cfset LOCAL.Return[ 3 ] = LOCAL.Values[ 3 ] />
			<cfset LOCAL.Return[ 4 ] = LOCAL.Values[ 1 ] />
			
		<cfelseif (ArrayLen( LOCAL.Values ) GTE 4)>
			
			<!--- Copy first four values. --->
			<cfset LOCAL.Return[ 1 ] = LOCAL.Values[ 1 ] />
			<cfset LOCAL.Return[ 2 ] = LOCAL.Values[ 2 ] />
			<cfset LOCAL.Return[ 3 ] = LOCAL.Values[ 3 ] />
			<cfset LOCAL.Return[ 4 ] = LOCAL.Values[ 4 ] />
			
		</cfif>
		
		<!--- Return results. --->
		<cfreturn LOCAL.Return />
	</cffunction>
	
	
	<cffunction 
		name="SetBackground"
		access="public"
		returntype="void"
		output="false"
		hint="Parses the background short-hand and sets the equivalent CSS properties.">
		
		<!--- Define arguments. --->
		<cfargument 
			name="PropertyMap" 
			type="struct" 
			required="true" 
			hint="I am the CSS hash map being updated." 
			/>
		
		<cfargument
			name="Value"
			type="string"
			required="true"
			hint="The background short hand value."
			/>
			
		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />
		
		<!--- Set up base properties that make up the background short hand. --->
		<cfset LOCAL.CSS[ "background-attachment" ] = "" />
		<cfset LOCAL.CSS[ "background-color" ] = "" />
		<cfset LOCAL.CSS[ "background-image" ] = "" />
		<cfset LOCAL.CSS[ "background-position" ] = "" />
		<cfset LOCAL.CSS[ "background-repeat" ] = "" />
			
		<!--- Get property tokens. --->
		<cfset LOCAL.Tokens = THIS.GetPropertyTokens( ARGUMENTS.Value ) />
		
		<!--- 
			Now that we have all of our tokens, we are going to loop over the 
			tokens and the properties and try to apply each. We want to apply 
			tokens with the hardest to accomodate first. 
		--->
		<cfloop
			index="LOCAL.Token"
			array="#LOCAL.Tokens#">
		
			<!--- Loop over properties, most restrictive first. --->
			<cfloop
				index="LOCAL.Property"
				list="background-attachment,background-position,background-repeat,background-image,background-color"
				delimiters=",">
			
				<!--- 
					Check to see if this value is valid. If this property 
					already has a value, then skip.
				--->
				<cfif (
					(NOT Len( LOCAL.CSS[ LOCAL.Property ] )) AND 
					THIS.IsValidValue( LOCAL.Property, LOCAL.Token ) 
					)>
			
					<!--- Assign to property. --->
					<cfset LOCAL.CSS[ LOCAL.Property ] = LOCAL.Token />
				
					<!--- Move to next token. --->
					<cfbreak />
					
				</cfif>
				
			</cfloop>
			
		</cfloop>
		
		
		<!--- Loop over local CSS to apply property. --->
		<cfloop
			item="LOCAL.Property"
			collection="#LOCAL.CSS#">
			
			<!--- Set properties. --->
			<cfif Len( LOCAL.CSS[ LOCAL.Property ] )>
				<cfset ARGUMENTS.PropertyMap[ LOCAL.Property ] = LOCAL.CSS[ LOCAL.Property ] />
			</cfif>
			
		</cfloop>
			
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
	
	<cffunction 
		name="SetBorder"
		access="public"
		returntype="void"
		output="false"
		hint="Parses the border short-hand and sets the equivalent CSS properties.">
		
		<!--- Define arguments. --->
		<cfargument 
			name="PropertyMap" 
			type="struct" 
			required="true" 
			hint="I am the CSS hash map being updated." 
			/>
			
		<cfargument
			name="Name"
			type="string"
			required="true"
			hint="The name of the pseudo property that we want to set."
			/>
		
		<cfargument
			name="Value"
			type="string"
			required="true"
			hint="The border short hand value."
			/>
			
		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />
		
		<!--- 
			Set up base properties. We will use the top-border as our base 
			since all borders act the same and we have validation set up for it.
		--->
		<cfset LOCAL.CSS = {} />
		<cfset LOCAL.CSS[ "border-top-width" ] = "" />
		<cfset LOCAL.CSS[ "border-top-color" ] = "" />
		<cfset LOCAL.CSS[ "border-top-style" ] = "" />
			
		<!--- Get property tokens. --->
		<cfset LOCAL.Tokens = THIS.GetPropertyTokens( ARGUMENTS.Value ) />
		
		<!--- 
			Now that we have all of our tokens, we are going to loop over the 
			tokens and the properties and try to apply each. We want to apply 
			tokens with the hardest to accomodate first. 
		--->
		<cfloop
			index="LOCAL.Token"
			array="#LOCAL.Tokens#">
		
			<!--- Loop over properties, most restrictive first. --->
			<cfloop
				index="LOCAL.Property"
				list="border-top-style,border-top-width,border-top-color"
				delimiters=",">
			
				<!--- 
					Check to see if this value is valid. If this property 
					already has a value, then skip.
				--->
				<cfif (
					(NOT Len( LOCAL.CSS[ LOCAL.Property ] )) AND 
					THIS.IsValidValue( LOCAL.Property, LOCAL.Token ) 
					)>
			
					<!--- Assign to property. --->
					<cfset LOCAL.CSS[ LOCAL.Property ] = LOCAL.Token />
				
					<!--- Move to next token. --->
					<cfbreak />
					
				</cfif>
				
			</cfloop>
			
		</cfloop>
		

		<!--- 
			If we are dealing with the main border, then we have to apply 
			these results to all four borders. Otherwise, we are only dealing 
			with the given property. 
		--->
		<cfif (ARGUMENTS.Name EQ "border")>
			
			<!--- All four borders. --->
			<cfset LOCAL.PropertyList = "border-top,border-right,border-bottom,border-left" />
		
		<cfelse>
		
			<!--- Just the given property. --->
			<cfset LOCAL.PropertyList = ARGUMENTS.Name />
		
		</cfif>
		
		<!--- Loop over list to apply CSS. --->
		<cfloop
			index="LOCAL.Property"
			list="#LOCAL.PropertyList#"
			delimiters=",">
			
			<!--- Set properties. --->
			<cfif Len( LOCAL.CSS[ "border-top-color" ] )>
				<cfset ARGUMENTS.PropertyMap[ "#LOCAL.Property#-color" ] = LOCAL.CSS[ "border-top-color" ] />
			</cfif>
			
			<cfif Len( LOCAL.CSS[ "border-top-style" ] )>
				<cfset ARGUMENTS.PropertyMap[ "#LOCAL.Property#-style" ] = LOCAL.CSS[ "border-top-style" ] />
			</cfif>
			
			<cfif Len( LOCAL.CSS[ "border-top-width" ] )>
				<cfset ARGUMENTS.PropertyMap[ "#LOCAL.Property#-width" ] = LOCAL.CSS[ "border-top-width" ] />
			</cfif>
			
		</cfloop>
			
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
	
	<cffunction 
		name="SetFont"
		access="public"
		returntype="void"
		output="false"
		hint="Parses the font short-hand and sets the equivalent CSS properties.">
		
		<!--- Define arguments. --->
		<cfargument 
			name="PropertyMap" 
			type="struct" 
			required="true" 
			hint="I am the CSS hash map being updated." 
			/>
			
		<cfargument
			name="Value"
			type="string"
			required="true"
			hint="The font short hand value."
			/>
			
		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />
		
		<!--- Set up base properties that make up the font short hand. --->
		<cfset LOCAL.CSS[ "font-family" ] = "" />
		<cfset LOCAL.CSS[ "font-size" ] = "" />
		<cfset LOCAL.CSS[ "font-style" ] = "" />
		<cfset LOCAL.CSS[ "font-weight" ] = "" />
			
		<!--- Get property tokens. --->
		<cfset LOCAL.Tokens = THIS.GetPropertyTokens( ARGUMENTS.Value ) />
		
		<!--- 
			Now that we have all of our tokens, we are going to loop over the 
			tokens and the properties and try to apply each. We want to apply 
			tokens with the hardest to accomodate first. 
		--->
		<cfloop
			index="LOCAL.Token"
			array="#LOCAL.Tokens#">
		
			<!--- Loop over properties, most restrictive first. --->
			<cfloop
				index="LOCAL.Property"
				list="font-style,font-size,font-weight,font-family"
				delimiters=",">
			
				<!--- 
					Check to see if this value is valid. If this property 
					already has a value, then skip.
				--->
				<cfif (
					(NOT Len( LOCAL.CSS[ LOCAL.Property ] )) AND 
					THIS.IsValidValue( LOCAL.Property, LOCAL.Token ) 
					)>
			
					<!--- Assign to property. --->
					<cfset LOCAL.CSS[ LOCAL.Property ] = LOCAL.Token />
				
					<!--- Move to next token. --->
					<cfbreak />
					
				</cfif>
				
			</cfloop>
			
		</cfloop>
		
		
		<!--- Loop over local CSS to apply property. --->
		<cfloop
			item="LOCAL.Property"
			collection="#LOCAL.CSS#">
			
			<!--- Set properties. --->
			<cfif Len( LOCAL.CSS[ LOCAL.Property ] )>
				<cfset ARGUMENTS.PropertyMap[ LOCAL.Property ] = LOCAL.CSS[ LOCAL.Property ] />
			</cfif>
			
		</cfloop>
			
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
	
	<cffunction 
		name="SetListStyle"
		access="public"
		returntype="void"
		output="false"
		hint="Parses the list style short-hand and sets the equivalent CSS properties.">
		
		<!--- Define arguments. --->
		<cfargument 
			name="PropertyMap" 
			type="struct" 
			required="true" 
			hint="I am the CSS hash map being updated." 
			/>
			
		<cfargument
			name="Value"
			type="string"
			required="true"
			hint="The list style short hand value."
			/>
			
		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />
		
		<!--- Set up base properties that make up the list style short hand. --->
		<cfset LOCAL.CSS[ "list-style-image" ] = "" />
		<cfset LOCAL.CSS[ "list-style-position" ] = "" />
		<cfset LOCAL.CSS[ "list-style-type" ] = "" />
			
		<!--- Get property tokens. --->
		<cfset LOCAL.Tokens = THIS.GetPropertyTokens( ARGUMENTS.Value ) />
		
		<!--- 
			Now that we have all of our tokens, we are going to loop over the 
			tokens and the properties and try to apply each. We want to apply 
			tokens with the hardest to accomodate first. 
		--->
		<cfloop
			index="LOCAL.Token"
			array="#LOCAL.Tokens#">
		
			<!--- Loop over properties, most restrictive first. --->
			<cfloop
				index="LOCAL.Property"
				list="list-style-type,list-style-image,list-style-position"
				delimiters=",">
			
				<!--- 
					Check to see if this value is valid. If this property 
					already has a value, then skip.
				--->
				<cfif (
					(NOT Len( LOCAL.CSS[ LOCAL.Property ] )) AND 
					THIS.IsValidValue( LOCAL.Property, LOCAL.Token ) 
					)>
			
					<!--- Assign to property. --->
					<cfset LOCAL.CSS[ LOCAL.Property ] = LOCAL.Token />
				
					<!--- Move to next token. --->
					<cfbreak />
					
				</cfif>
				
			</cfloop>
			
		</cfloop>
		
		
		<!--- Loop over local CSS to apply property. --->
		<cfloop
			item="LOCAL.Property"
			collection="#LOCAL.CSS#">
			
			<!--- Set properties. --->
			<cfif Len( LOCAL.CSS[ LOCAL.Property ] )>
				<cfset ARGUMENTS.PropertyMap[ LOCAL.Property ] = LOCAL.CSS[ LOCAL.Property ] />
			</cfif>
			
		</cfloop>
			
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="SetMargin"
		access="public"
		returntype="void"
		output="false"
		hint="Parses the margin short hand and sets the equivalent properties.">
		
		<!--- Define arguments. --->
		<cfargument 
			name="PropertyMap" 
			type="struct" 
			required="true" 
			hint="I am the CSS hash map being updated." 
			/>
			
		<cfargument
			name="Value"
			type="string"
			required="true"
			hint="The margin short hand value."
			/>
		
		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />
		
		<!--- Parse the quad metric value. --->
		<cfset LOCAL.Metrics = THIS.ParseQuadMetric( ARGUMENTS.Value ) />
		
		<!--- Set properties. --->
		<cfif IsValidValue( "margin-top", LOCAL.Metrics[ 1 ] )>
			<cfset ARGUMENTS.PropertyMap[ "margin-top" ] = LOCAL.Metrics[ 1 ] />
		</cfif>
		
		<cfif IsValidValue( "margin-right", LOCAL.Metrics[ 2 ] )>
			<cfset ARGUMENTS.PropertyMap[ "margin-right" ] = LOCAL.Metrics[ 2 ] />
		</cfif>
		
		<cfif IsValidValue( "margin-bottom", LOCAL.Metrics[ 3 ] )>
			<cfset ARGUMENTS.PropertyMap[ "margin-bottom" ] = LOCAL.Metrics[ 3 ] />
		</cfif>
		
		<cfif IsValidValue( "margin-left", LOCAL.Metrics[ 4 ] )>
			<cfset ARGUMENTS.PropertyMap[ "margin-left" ] = LOCAL.Metrics[ 4 ] />
		</cfif>
		
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="SetPadding"
		access="public"
		returntype="void"
		output="false"
		hint="Parses the padding short hand and sets the equivalent properties.">
		
		<!--- Define arguments. --->
		<cfargument 
			name="PropertyMap" 
			type="struct" 
			required="true" 
			hint="I am the CSS hash map being updated." 
			/>
			
		<cfargument
			name="Value"
			type="string"
			required="true"
			hint="The padding short hand value."
			/>
		
		<!--- Set up local scope. --->
		<cfset var LOCAL = {} />
		
		<!--- Parse the quad metric value. --->
		<cfset LOCAL.Metrics = THIS.ParseQuadMetric( ARGUMENTS.Value ) />
		
		<!--- Set properties. --->
		<cfif IsValidValue( "padding-top", LOCAL.Metrics[ 1 ] )>
			<cfset ARGUMENTS.PropertyMap[ "padding-top" ] = LOCAL.Metrics[ 1 ] />
		</cfif>
		
		<cfif IsValidValue( "padding-right", LOCAL.Metrics[ 2 ] )>
			<cfset ARGUMENTS.PropertyMap[ "padding-right" ] = LOCAL.Metrics[ 2 ] />
		</cfif>
		
		<cfif IsValidValue( "padding-bottom", LOCAL.Metrics[ 3 ] )>
			<cfset ARGUMENTS.PropertyMap[ "padding-bottom" ] = LOCAL.Metrics[ 3 ] />
		</cfif>
		
		<cfif IsValidValue( "padding-left", LOCAL.Metrics[ 4 ] )>
			<cfset ARGUMENTS.PropertyMap[ "padding-left" ] = LOCAL.Metrics[ 4 ] />
		</cfif>
		
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
		
</cfcomponent>