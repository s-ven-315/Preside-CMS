/**
 * The asset derivative object represents a derived version of an [[presideobject-asset]], storing the file path and named derivative used to transform the initial asset.
 *
 * @feature assetManager
 */
component extends="preside.system.base.SystemPresideObject" displayName="Asset derivative" {

	property name="asset"         relationship="many-to-one" required=true  uniqueindexes="derivative|1" ondelete="cascade";
	property name="asset_version" relationship="many-to-one" required=false uniqueindexes="derivative|2" ondelete="cascade";

	property name="label" maxLength=200 required=true uniqueindexes="derivative|3";

	property name="storage_path" type="string"  dbtype="varchar" maxLength=255  required=true  uniqueindexes="assetpath";
	property name="asset_url"    type="string"  dbtype="varchar" maxLength=1024 required=false;
	property name="asset_type"   type="string"  dbtype="varchar" maxLength=10   required=true;
	property name="width"        type="numeric" dbtype="int"                    required=false;
	property name="height"       type="numeric" dbtype="int"                    required=false;
	property name="config"       type="string"  dbtype="text"                   required=false;
	property name="config_hash"  type="string"  dbtype="varchar" maxLength=12   required=false uniqueindexes="derivative|4";

	property name="is_trashed"   type="boolean" dbtype="boolean"               required=false default=false;
	property name="trashed_path" type="string"  dbtype="varchar" maxLength=255 required=false;
	property name="retry_count"  type="numeric" dbtype="int"                   required=false default=0;
}