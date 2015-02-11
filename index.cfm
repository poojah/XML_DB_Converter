<!--- Please insert your code here --->
<cfset adminAPI = createObject( 'component', 'cfide.adminapi.administrator' ) />
<cfset adminAPI.login( 'aaaa' ) />
<cfset strPath = ExpandPath( "./" ) />
<cffile action="read" file="C:\Users\vadiraja\Documents\xmldoc.xml" variable="myxml">
<cfset mydoc = XmlParse(myxml)>
<cfset datasrc =#mydoc.datasource.XmlAttributes.name#>
<cfscript>
	dsnAPI = createObject( 'component', 'cfide.adminapi.datasource' );

	dsn = {
		name="#datasrc#", database="#strPath#db\#datasrc#", isnewdb=true
	};

	dsnAPI.setDerbyEmbedded( argumentCollection = dsn );
</cfscript>
<cfset table = #mydoc.datasource.table.XmlAttributes.name#>
<cfloop index="i" from="1" to="#ArrayLen(mydoc.datasource.table)#">
	<!---<cfoutput >
		<!---table name--->
		#mydoc.datasource.table[i].XmlAttributes.name#
	</cfoutput>	--->
	<cfset tablename = "#mydoc.datasource.table[i].XmlAttributes.name#">
	<cfset str="create table #tablename# (">
	<cfloop index="j" from="1" to="#ArrayLen(mydoc.datasource.table[i].field)#">
		<!---field name--->
		<cfoutput >
			#mydoc.datasource.table[i].field[j].XmlAttributes.name#
		</cfoutput>
		<cfset str= str & #mydoc.datasource.table[i].field[j].XmlAttributes.name#>
		
			
			<cfset str = str & " VARCHAR(50) ,">
			
		
	</cfloop>
		<cfset str= Left(str, len(str)-1)>
	<cfset str= str & ")">
	<cfdump var="#str#" >
	<cfoutput >
		<cfquery datasource="#datasrc#" >
			#str#
		</cfquery>
	</cfoutput>
	<cfloop index="k" from="1" to="#ArrayLen(mydoc.datasource.table[i].data.row)#">
		<cfset str="INSERT INTO #tablename# VALUES (">
		<cfloop index="l" from="1" to="#ArrayLen(mydoc.datasource.table[i].data.row[k].field)#">
			<cfoutput >
				#mydoc.datasource.table[i].data.row[k].field[l]#
			</cfoutput>
			<cfset value= "#mydoc.datasource.table[i].data.row[k].field[l].XmlText#">
			<cfdump var="#value#" >
			<cfif IsNull(#mydoc.datasource.table[i].data.row[k].field[l]#)>
				<cfset str = str & "null" & ",">
				<cfelse>
				<cfset str = str & "'" & "#Replace(value,"'","","ALL")#" & "'" & ",">
			</cfif>
		</cfloop>
		<cfset str= Left(str, len(str)-1)>
		<cfset str= str & ")">
		<cfdump var="#str#" >
			<cfquery datasource="#datasrc#" >
			#preserveSingleQuotes(str)#
			</cfquery>
	</cfloop>
</cfloop>
<cfdump var="#mydoc#" >