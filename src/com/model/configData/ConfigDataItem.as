package com.model.configData
{
	public class ConfigDataItem
	{
		public var dicKey:int;
		public var idNames:String;
		public var EmbedClass:Class;
		public var DataItemClass:Class;
		
		public function ConfigDataItem(dicKey:int,idNames:String,EmbedClass:Class,DataItemClass:Class)
		{
			this.dicKey = dicKey;
			this.idNames = idNames;
			this.EmbedClass = EmbedClass;
			this.DataItemClass = DataItemClass;
		}
	}
}