package com.view.gameWindow.util.propertyParse
{
	public class PropertyData
	{
		/**使用RolePropertyConst中的常量*/
		public var propertyId:int;
		public var name:String;
		public var type:int;
		public var isMain:Boolean;
		public var color:int;
		public var value:Number;
		public var value1:int;//a-b类型属性的第二个值
		public var fightPower:Number;
		
		public function PropertyData()
		{
			propertyId = 0;
			name = "";
			type = 0;
			isMain = false;
			color = 0;
			value = 0;
			value1 = 0;
		}
		
		public function clone():PropertyData
		{
			var propertyData:PropertyData = new PropertyData();
			propertyData.propertyId = propertyId;
			propertyData.name = name;
			propertyData.type = type;
			propertyData.isMain = isMain;
			propertyData.color = color;
			propertyData.value = value;
			propertyData.value1 = value1;
			propertyData.fightPower = fightPower;
			return propertyData;
		}
	}
}