package com.model.configData
{
	import com.model.configData.cfgdata.NameWordCfgData;
	import com.model.configData.constants.ConfigType;

	import mx.core.ByteArrayAsset;

	public class ConfigDataCreateRole
	{
		[Embed("../../../../config/male.name",mimeType="application/octet-stream")]
		private static const cfg_maleName : Class;
		private static function getXMLMaleName():Array
		{
			var ba : ByteArrayAsset = ByteArrayAsset(new cfg_maleName());
			var str:String = String(ba.readUTFBytes(ba.length));
			return str.split("|");
		}
		public static var male_Config : Array = getXMLMaleName();
		
		[Embed("../../../../config/female.name",mimeType="application/octet-stream")]
		private static const cfg_femaleName : Class;
		private static function getXMLFemaleName():Array
		{
			var ba : ByteArrayAsset = ByteArrayAsset(new cfg_femaleName());
			var str:String = String(ba.readUTFBytes(ba.length));
			return str.split("|");
		}
		public static var female_Config : Array = getXMLFemaleName();
		
		[Embed("../../../../config/lastName.name",mimeType="application/octet-stream")]
		private static const cfg_lastName : Class;
		private static function getXMLLastName():Array
		{
			var ba : ByteArrayAsset = ByteArrayAsset(new cfg_lastName());
			var str:String = String(ba.readUTFBytes(ba.length));
			return str.split("|");
		}
		public static var lastName_Config : Array = getXMLLastName();

		[Embed("../../../../config/name_word.cfg", mimeType="application/octet-stream")]
		private static const nameWordClass:Class;

		public static function getAllConfigData():Vector.<ConfigDataItem>
		{
			var cfgInfos:Vector.<ConfigDataItem>, i:int, l:int;
			cfgInfos = new Vector.<ConfigDataItem>();
			cfgInfos.push(new ConfigDataItem(ConfigType.KeyNameWord, "id", nameWordClass, NameWordCfgData));
			return cfgInfos;
		}

		public function ConfigDataCreateRole()
		{
		}
	}
}