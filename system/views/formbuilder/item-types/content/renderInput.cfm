<!---@feature formbuilder--->
<cfoutput>#renderContent( renderer="richeditor", data=( args.body ?: "" ) )#</cfoutput>