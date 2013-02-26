<cfscript>

component 
	output = "false"
	hint = "I define the application settings and event handlers."
	{


	// Define the application settings. 
	this.name = hash( getCurrentTemplatePath() );
	this.applicationTimeout = createTimeSpan( 0, 0, 10, 0 );

	// Get the current directory and the root directory so that we can
	// set up the mappings to our components.
	this.appDirectory = getDirectoryFromPath( getCurrentTemplatePath() );
	this.projectDirectory = ( this.appDirectory & "../" );

	// Map to our Lib folder so we can access our project components.
	this.mappings[ "/lib" ] = ( this.projectDirectory & "lib/" );


}

</cfscript>