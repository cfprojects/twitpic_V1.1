<!---
Name: index.cfm
Author: Matt Gifford AKA coldfumonkeh (http://www.mattgifford.co.uk)
Date: 08.03.2010

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


Usage: The twitpic component accepts two required parameters in the constructor;
1) twitter username
2) password associated with the account

The single public-facing method (uploadPic) and it's parameters are documented within 
the twitpic component and hints provided to assist with use.

--->

<cfscript>
	strUsername = '<Twitter account username>';
	strPassword = '<Twitter account password>';

	// instantiate the component
	// parseResults set to false as default, so String values are returned.
	objTwitPic = createObject('component',
					'com.coldfumonkeh.twitpic').init(
						userName=strUsername,
						password=strPassword,
						parseResults='true');
</cfscript>

<cfif structKeyExists(form, 'submit_btn')>
	<!--- form has been posted --->
	<!--- upload the file to temporary location on the server --->
	<cffile action="upload" destination="#getTempDirectory()#" file="#form.file#" nameconflict="overwrite" />	
	<!--- call the uploadPic() method and send image location on server and message --->
	<cfscript>
		upload = objTwitPic.uploadPic(media='#cffile.serverdirectory#\#cffile.serverfile#',message=form.message);    	    
    	writeDump(upload);
	</cfscript>
</cfif>

<!--- typical upload form. --->
<cfoutput>
	<form name="upload" action="#cgi.script_name#" method="post" enctype="multipart/form-data">
	<label for="file">Photo:</label> 
	<input type="file" name="file" id="file" /><br />
	<label for="message">Tweet:</label> 
	<input type="text" name="message" id="message" maxlength="140" size="70" /><br />
	<input type="submit" name="submit_btn" value="upload" />
	</form>
</cfoutput>