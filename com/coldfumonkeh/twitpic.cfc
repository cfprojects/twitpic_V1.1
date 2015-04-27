<!---
Name: twitpic.cfc
Author: Matt Gifford AKA coldfumonkeh (http://www.mattgifford.co.uk)
Date: 08.03.2010
Version: 1.0

Copyright 2010 Matt Gifford AKA coldfumonkeh. All rights reserved.
Product and company names mentioned herein may be
trademarks or trade names of their respective owners.

Subject to the conditions below, you may, without charge:

Use, copy, modify and/or merge copies of this software and
associated documentation files (the 'Software')

Any person dealing with the Software shall not misrepresent the source of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

--->
<cfcomponent output="false" displayname="twitpic" hint="I am the main facade / service object for the twitpic api">

	<cfset variables.instance = structNew() />
	<cfset variables.instance.twitPicURL = 'http://twitpic.com/' />

	<cffunction name="init" access="public" output="false" returntype="com.coldfumonkeh.twitpic">
		<cfargument name="userName" 	required="true" 					type="string" 	hint="The twitter account username" />
		<cfargument name="password" 	required="true" 					type="string" 	hint="The twitter account password" />
		<cfargument name="parseResults"	required="false" default="false" 	type="boolean" 	hint="A boolean value to determine if the output data is parsed or returned as a string" />
			<cfscript>
				setTweetDetails(arguments.userName,arguments.password);
				setParseResults(arguments.parseResults);
			</cfscript>	
		<cfreturn this />
	</cffunction>
	
	<!--- MUTATORS --->
	<cffunction name="setTweetDetails" access="private" output="false" hint="I set the twitter account details">
		<cfargument name="userName" required="true" type="string" hint="The twitter account username" />
		<cfargument name="password" required="true" type="string" hint="The twitter account password" />
		<cfset variables.instance.tweetDetails = createObject('component', 'com.coldfumonkeh.tweetDetails').init(arguments.userName,arguments.password) />
	</cffunction>
	
	<cffunction name="setParseResults" access="private" output="false" hint="I set the parseResult boolean value">
		<cfargument name="parseResults"	required="false" default="false" type="boolean" hint="A boolean value to determine if the output data is parsed or returned as a string" />
		<cfset variables.instance.parseResults = arguments.parseResults />
	</cffunction>
	
	<!--- ACCESSORS --->
	<cffunction name="getTweetDetails" access="public" output="false" hint="I get the twitter account details">
		<cfreturn variables.instance.tweetDetails />
	</cffunction>
	
	<cffunction name="getTweetUserName" access="public" output="false" returntype="string" hint="I get the twitter account username">
		<cfreturn getTweetDetails().getuserName() />
	</cffunction>
	
	<cffunction name="getTweetPassword" access="public" output="false" returntype="string" hint="I get the twitter account password">
		<cfreturn getTweetDetails().getpassword() />
	</cffunction>
	
	<cffunction name="getTwitPicURL" access="public" output="false" returntype="string" hint="I get the twitpic API URL">
		<cfreturn variables.instance.twitPicURL />
	</cffunction>
	
	<cffunction name="getParseResults" access="public" output="false" returntype="boolean" hint="I set the parseResult boolean value">
		<cfreturn variables.instance.parseResults />
	</cffunction>
	
	<!--- PUBLIC METHODS --->
	<cffunction name="uploadPic" access="public" output="false" hint="I am the function that handles the file upload, and can also publish a status message to your Twitter account">
		<cfargument name="media" 	required="true" 									type="string" hint="The binary image data to submit" />
		<cfargument name="username"	required="false" default="#getTweetUserName()#"		type="string" hint="The Twitter username" />
		<cfargument name="password"	required="false" default="#getTweetPassword()#"		type="string" hint="The Twitter password" />
		<cfargument name="message"	required="false" default="" 						type="string" hint="Message to post to Twitter. The URL of the image is automatically added" />
			<cfset var cfhttp 		= '' />
			<cfset var strResponse 	= '' />
			<cfset var strMethodURL	= '' />
			<cfset var stuError		= structNew() />
			<cfset var arrXMLError	= arrayNew(1) />
				<!--- build the required URL for submission --->
				<cfset strMethodURL = getTwitPicURL() & 'api/upload' />
				<cfif len(arguments.message)><cfset strMethodURL = strMethodURL & 'AndPost' /></cfif>
				<!--- send the POST request to the URL --->
				<cfhttp url="#strMethodURL#" method="post">
					<cfhttpparam name="media"		type="file"  		file="#arguments.media#" />
					<cfhttpparam name="username"	type="formfield" 	value="#arguments.username#" />
					<cfhttpparam name="password"	type="formfield" 	value="#arguments.password#" />
					<cfif len(arguments.message)>
						<cfhttpparam name="message"	type="formfield" 	value="#arguments.message#" />
					</cfif>
				</cfhttp>
				<!--- handle the return --->
				<cfif len(cfhttp.fileContent)>
					<cfset arrXMLError = xmlSearch(cfhttp.fileContent, 'rsp/err') />
					<cfif arrayLen(arrXMLError)>
						<cfset stuError = arrXMLError[1].XmlAttributes />
						<cfreturn stuError />
						<cfabort>
					</cfif>
					<cfreturn handleReturnFormat(cfhttp.fileContent) />
				</cfif>	
	</cffunction>
	<!--- END OF PUBLIC METHODS --->
	
	<!--- PRIVATE METHODS --->	
	<cffunction name="handleReturnFormat" access="public" output="false" hint="I handle how the data is returned based upon the provided format">
		<cfargument name="data" required="true" type="string" hint="The data returned from the API." />
			<cfif getparseResults()>
				<cfreturn XmlParse(arguments.data) />
			<cfelse>
				<cfreturn arguments.data />
			</cfif>
		<cfabort>
	</cffunction>
	<!--- END OF PRIVATE METHODS --->
	
</cfcomponent>