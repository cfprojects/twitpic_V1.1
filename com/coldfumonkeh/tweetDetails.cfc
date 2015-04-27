<!---
Name: tweetDetails.cfc
Author: Matt Gifford AKA coldfumonkeh (http://www.mattgifford.co.uk)
Date: 08.03.2010

Copyright � 2010 Matt Gifford AKA coldfumonkeh. All rights reserved.
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
<cfcomponent displayname="tweetDetails" output="false" hint="I am the tweetDetails component, and I contain the account username and password">

	<cfset variables.instance = structNew() />
	
	<cffunction name="init" access="public" output="false" returntype="com.coldfumonkeh.tweetDetails" hint="I am the constructor method for the tweetDetails class">
		<cfargument name="userName" required="true" type="string" hint="The twitter account username" />
		<cfargument name="password" required="true" type="string" hint="The twitter account password" />
			<cfscript>
				setuserName(arguments.userName);
				setpassword(arguments.password);
			</cfscript>
		<cfreturn this />
	</cffunction>
	
	<!--- MUTATORS --->
	<cffunction name="setuserName" access="private" output="false" hint="I set the twitter account username">
		<cfargument name="userName" required="true" type="string" hint="The twitter account username" />
		<cfset variables.instance.username = arguments.userName />
	</cffunction>
	
	<cffunction name="setpassword" access="private" output="false" hint="I set the twitter account password">
		<cfargument name="password" required="true" type="string" hint="The twitter account password" />
		<cfset variables.instance.password = arguments.password />
	</cffunction>
	
	<!--- ACCESSORS --->
	<cffunction name="getuserName" access="public" output="false" hint="I get the twitter account username">
		<cfreturn variables.instance.username />
	</cffunction>
	
	<cffunction name="getpassword" access="public" output="false" hint="I get the twitter account password">
		<cfreturn variables.instance.password />
	</cffunction>

</cfcomponent>