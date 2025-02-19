/**
 * SMTP Service provider for email sending with plain SMTP.
 *
 * @feature emailCenter
 */
component {
	property name="emailService"  inject="emailService";
	property name="asyncSmtp"     inject="coldbox:setting:email.smtp.async";

	private boolean function send( struct sendArgs={}, struct settings={} ) {
		var m           = new Mail();
		var mailServer  = settings.server      ?: "";
		var port        = settings.port        ?: "";
		var username    = settings.username    ?: "";
		var password    = settings.password    ?: "";
		var useTls      = IsTrue( settings.use_tls ?: "" );
		var params      = sendArgs.params      ?: {};
		var attachments = sendArgs.attachments ?: [];

		m.setTo( sendArgs.to.toList( ";" ) );
		m.setFrom( sendArgs.from );
		m.setSubject( sendArgs.subject );
		m.setUseTls( useTls );
		m.setAsync( asyncSmtp );

		if ( sendArgs.cc.len()  ) {
			m.setCc( sendArgs.cc.toList( ";" ) );
		}
		if ( sendArgs.bcc.len() ) {
			m.setBCc( sendArgs.bcc.toList( ";" ) );
		}
		if ( sendArgs.replyTo.len() ) {
			m.setReplyTo( sendArgs.replyTo.toList( ";" ) );
		}
		if ( sendArgs.failTo.len() ) {
			m.setFailTo( sendArgs.failTo.toList( ";" ) );
		}
		if ( Len( Trim( sendArgs.textBody ) ) ) {
			m.addPart( type='text', body=Trim( sendArgs.textBody ) );
		}
		if ( Len( Trim( sendArgs.htmlBody ) ) ) {
			m.addPart( type='html', body=Trim( sendArgs.htmlBody ) );
		}
		if ( Len( Trim( mailServer ) ) ) {
			m.setServer( mailServer );
		}
		if ( Len( Trim( port ) ) ) {
			m.setPort( port );
		}
		if ( Len( Trim( username ) ) ) {
			m.setUsername( username );
		}
		if ( Len( Trim( password ) ) ) {
			m.setPassword( password );
		}


		for( var param in params ){
			m.addParam( argumentCollection=sendArgs.params[ param ] );
		}
		for( var attachment in attachments ) {
			var md5sum   = Hash( attachment.binary );
			var tmpDir   = getTempDirectory() & "/" & md5sum & "/";
			var filePath = tmpDir & attachment.name
			var remove   = IsBoolean( attachment.removeAfterSend ?: "" ) ? attachment.removeAfterSend : true;

			if ( !FileExists( filePath ) ) {
				try {
					DirectoryCreate( tmpDir, true, true );
					FileWrite( filePath, attachment.binary );
				} catch( any e ) {
					// concurrency can lead to errors here (multiple processes creating the same file)
					// just check that it exists again
					if ( !FileExists( filePath ) ) {
						rethrow;
					}
				}
			}

			m.addParam( disposition="attachment", file=filePath, remove=remove );
		}

		sendArgs.messageId = sendArgs.messageId ?: CreateUUId();

		m.addParam( name="X-Mailer", value="Preside" );
		m.addParam( name="X-Message-ID", value=sendArgs.messageId );
		m.send();

		return true;
	}

	private any function validateSettings( required struct settings, required any validationResult ) {
		if ( IsTrue( settings.check_connection ?: "" ) ) {
			var errorMessage = emailService.validateConnectionSettings(
				  host     = arguments.settings.server    ?: ""
				, port     = Val( arguments.settings.port ?: "" )
				, username = arguments.settings.username  ?: ""
				, password = arguments.settings.password  ?: ""
				, useTls   = IsTrue( arguments.settings.use_tls ?: "" )
			);

			if ( Len( Trim( errorMessage ) ) ) {
				if ( errorMessage == "authentication failure" ) {
					validationResult.addError( "username", "email.serviceProvider.smtp:validation.server.authentication.failure" );
				} else {
					validationResult.addError( "server", "email.serviceProvider.smtp:validation.server.details.invalid", [ errorMessage ] );
				}
			}
		}

		return validationResult;
	}
}