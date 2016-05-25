package com.view.gameWindow.panel.panels.bag
{
	import com.model.consts.ConstStorage;

	public class DrugCDData
	{
		private static var _drugCDChr:Array = new Array;
		private static var _drugCDHero:Array = new Array;
		public function DrugCDData()
		{
		}
		
		public static function drugCDChr(type:int):Array
		{
			if(type == ConstStorage.ST_CHR_BAG)
				return _drugCDChr;
			else
				return _drugCDHero;
		}
		
	}
}