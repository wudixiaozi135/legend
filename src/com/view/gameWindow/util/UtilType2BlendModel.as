package com.view.gameWindow.util
{
	import flash.display.BlendMode;

	public class UtilType2BlendModel
	{
		public function UtilType2BlendModel()
		{
		}
		
		/**
		 * 根据类型获取BlendModel值
		 * @param type
		 * @return 
		 */		
		public static function getBlendModel(type:int):String
		{
			var value:String;
			switch(type)
			{
				default:
				case 0:
					value = BlendMode.NORMAL;
					break;
				case 1:
					value = BlendMode.ADD;
					break;
				case 2:
					value = BlendMode.ALPHA;
					break;
				case 3:
					value = BlendMode.DARKEN;
					break;
				case 4:
					value = BlendMode.DIFFERENCE;
					break;
				case 5:
					value = BlendMode.ERASE;
					break;
				case 6:
					value = BlendMode.HARDLIGHT;
					break;
				case 7:
					value = BlendMode.INVERT;
					break;
				case 8:
					value = BlendMode.LAYER;
					break;
				case 9:
					value = BlendMode.LIGHTEN;
					break;
				case 10:
					value = BlendMode.MULTIPLY;
					break;
				case 11:
					value = BlendMode.OVERLAY;
					break;
				case 12:
					value = BlendMode.SCREEN;
					break;
				case 13:
					value = BlendMode.SHADER;
					break;
				case 14:
					value = BlendMode.SUBTRACT;
					break;
			}
			return value;
		}
	}
}