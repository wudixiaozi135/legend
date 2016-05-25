package com.view.gameWindow.util
{
	/**
	 * 文本样式处理
	 * @author jhj
	 */
	public class HtmlUtils
	{
		public function HtmlUtils()
		{
			
		}
		
		public static function createHtmlStr(color:uint, value:String,fontSize:int=12,isBold:Boolean=false,leading:int=2,
											 face:String="SimSun",underLine:Boolean=false,underLineEventName:String="",align:String=""):String
		{
			var str:String = "";
			value = align != "" ? "<p align='"+align+"'>" + value + "</p>" : value;
			if (underLine)
			{
				str= "<span><u><font face='"+face+"' color='#" + color.toString(16) + "'><a href='event:" + underLineEventName + "'>" + value + "</a></font></u></span>";
			}
			else
			{
				var tempValue:String = "";
				isBold ? tempValue="<b>" + value + "</b>" : tempValue = value;
				if(leading == 0)
				{
					str= "<span><font face='"+face+"' size='" + fontSize + "' color='#" + color.toString(16) + "'>" + tempValue + "</font></span>";
				}
				else
				{
					str= "<TEXTFORMAT LEADING='"+leading+"'><span><font face='"+face+"' size='" + fontSize + "' color='#" + color.toString(16) + "'>" + tempValue + "</font></span></TEXTFORMAT>";
				}
			}
			return str;
		}
	}
}