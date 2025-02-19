/**
 * @feature assetManager
 */
component {

	property name="imageManipulationService" inject="imageManipulationService";

	private binary function resize( event, rc, prc, args={} ) {
		return imageManipulationService.resize( argumentCollection=args );
	}

	private binary function shrinkToFit( event, rc, prc, args={} ) {
		return imageManipulationService.shrinkToFit( argumentCollection=args );
	}

	private binary function pdfPreview( event, rc, prc, args={} ) {
		return imageManipulationService.pdfPreview( argumentCollection=args );
	}

	private binary function resizeCrop( event, rc, prc, args={} ) {
		args.useCropHint      = true;
		args.ignoreDimension  = true;
		return imageManipulationService.resize( argumentCollection=args );
	}

}