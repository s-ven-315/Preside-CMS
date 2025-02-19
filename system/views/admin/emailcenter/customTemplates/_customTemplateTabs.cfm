<!---@feature admin and customEmailTemplates--->
<cfparam name="args.body"                                  default="" />
<cfparam name="args.tab"                                   default="preview" />
<cfparam name="args.canEdit"                type="boolean" default="false" />
<cfparam name="args.canConfigureLayout"     type="boolean" default="false" />
<cfparam name="args.canEditSendOptions"     type="boolean" default="false" />

<cfscript>
	templateId = rc.id      ?: "";
	version    = rc.version ?: "";
	tabs       = [];

	tabs.append({
		  id     = "preview"
		, icon   = "fa-eye blue"
		, title  = translateResource( "cms:emailcenter.customTemplates.template.tab.preview" )
		, active = ( args.tab == "preview" )
		, link   = ( args.tab == "preview" ) ? "" : event.buildAdminLink( linkTo="emailcenter.customTemplates.preview", queryString="id=#templateId#&version=#version#" )
	});

	if ( args.canEdit ) {
		tabs.append({
			  id     = "edit"
			, icon   = "fa-pencil green"
			, title  = translateResource( "cms:emailcenter.customTemplates.template.tab.edit" )
			, active = ( args.tab == "edit" )
			, link   = ( args.tab == "edit" ) ? "" : event.buildAdminLink( linkTo="emailcenter.customTemplates.edit", queryString="id=#templateId#&version=#version#" )
		});
	}


	if ( args.canEditSendOptions ) {
		tabs.append({
			  id     = "settings"
			, icon   = "fa-cogs orange"
			, title  = translateResource( "cms:emailcenter.customTemplates.template.tab.settings" )
			, active = ( args.tab == "settings" )
			, link   = ( args.tab == "settings" ) ? "" : event.buildAdminLink( linkTo="emailcenter.customTemplates.settings", queryString="id=" & templateId )
		});
	}

	if ( args.canConfigureLayout ) {
		tabs.append({
			  id     = "layout"
			, icon   = "fa-align-justify grey"
			, title  = translateResource( "cms:emailcenter.customTemplates.template.tab.layout" )
			, active = ( args.tab == "layout" )
			, link   = ( args.tab == "layout" ) ? "" : event.buildAdminLink( linkTo="emailcenter.customTemplates.configureLayout", queryString="id=" & templateId )
		});
	}

	tabs.append({
		  id     = "stats"
		, icon   = "fa-line-chart purple"
		, title  = translateResource( "cms:emailcenter.customTemplates.template.tab.stats" )
		, active = ( args.tab == "stats" )
		, link   = ( args.tab == "stats" ) ? "" : event.buildAdminLink( linkTo="emailcenter.customTemplates.stats", queryString="id=#templateId#" )
	});

	tabs.append({
		  id     = "log"
		, icon   = "fa-list-alt yellow"
		, title  = translateResource( "cms:emailcenter.customTemplates.template.tab.log" )
		, active = ( args.tab == "log" )
		, link   = ( args.tab == "log" ) ? "" : event.buildAdminLink( linkTo="emailcenter.customTemplates.logs", queryString="id=#templateId#" )
	});

	if ( args.tab == "send" ) {
		tabs.append({
			  id     = "send"
			, icon   = "fa-share red"
			, title  = translateResource( "cms:emailcenter.customTemplates.template.tab.send" )
			, active = true
			, link   = ""
		});
	}
</cfscript>

<cfoutput>
	#renderViewlet( "admin.emailcenter.customtemplates._customTemplateActions" )#
	#renderViewlet( "admin.emailcenter.customtemplates._customTemplateNotices" )#

	<div class="tabbable">
		<ul class="nav nav-tabs">
			<cfloop array="#tabs#" index="i" item="tab">
				<li <cfif tab.active>class="active"</cfif>>
					<a href="#tab.link#">
						<i class="fa fa-fw #tab.icon#"></i>&nbsp;
						#tab.title#
					</a>
				</li>
			</cfloop>
		</ul>
		<div class="tab-content">
			<div class="tab-pane active">#args.body#</div>
		</div>
	</div>
</cfoutput>