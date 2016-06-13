component {

	property name="presideObjectService" inject="presideObjectService";

	private string function datamanager( event, rc, prc, args={} ) {
		var action       = args.action            ?: "";
		var known_as     = args.known_as          ?: "";
		var userLink     = args.userLink          ?: "";
		var record_id    = args.record_id         ?: "";
		var objectName   = args.detail.objectName ?: "";
		var labelField   = objectName.len() ? presideObjectService.getObjectAttribute( objectName, "labelField" ) : "";
		var userLink     = '<a href="#args.userLink#">#args.known_as#</a>';
		var objectTitle  = translateResource( uri="preside-objects.#objectName#:title.singular" );
		var objectUrl    = event.buildAdminLink( linkTo="datamanager.object", queryString="id=" & objectName );
		var objectLink   = '<a href="#objectUrl#">#objectTitle#</a>';
		var recordLabel  = args.detail[ labelField ] ?: "unknown";
		var recordUrl    = event.buildAdminLink( linkTo="datamanager.viewRecord", queryString="object=#objectName#&id=#args.record_id#" );
		var recordLink   = '<a href="#recordUrl#">#recordLabel#</a>';

		switch( action ) {
			case "datamanager_translate_record":
				var language = renderLabel( "multilingual_language", args.detail.languageId ?: "" );
				return translateResource( uri="auditlog.datamanager:#args.action#.message", data=[ userLink, objectLink, recordLink, language ] );
			break;
		}


		return translateResource( uri="auditlog.datamanager:#args.action#.message", data=[ userLink, objectLink, recordLink ] );
	}

}