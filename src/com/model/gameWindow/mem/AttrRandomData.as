package com.model.gameWindow.mem
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.QualityCfgData;
	import com.view.gameWindow.util.propertyParse.PropertyData;

	public class AttrRandomData
	{
		public var attrDt:PropertyData;
		public var star:int;
		
		public function AttrRandomData()
		{
		}
		
		public function get starColor():int
		{
			var number:Number = Math.ceil(star/3)+1;
			var qualityCfgData:QualityCfgData = ConfigDataManager.instance.qualityCfgData(number);
			if(qualityCfgData)
			{
				return int(qualityCfgData.rgb_num);
			}
			return 0xffffff;
		}
	}
}