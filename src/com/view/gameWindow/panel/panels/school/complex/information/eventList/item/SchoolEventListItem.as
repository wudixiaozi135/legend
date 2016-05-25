package com.view.gameWindow.panel.panels.school.complex.information.eventList.item
{
	import com.view.gameWindow.panel.panels.school.complex.MCTextItem;
	import com.view.gameWindow.panel.panels.school.complex.information.eventList.EventParseUtil;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.TimeUtils;
	
	public class SchoolEventListItem extends MCTextItem
	{
		private var _data:SchoolEventData;
		private const NO_SCHOOL:int=0;
		public function SchoolEventListItem()
		{
			super();
		}
		
		public function update(data:SchoolEventData):void
		{
			this.data = data;
			var time:String = TimeUtils.getDateString(data.time*1000);
			txt1.htmlText=HtmlUtils.createHtmlStr(0xb4b4b4,time);
			txt2.htmlText=HtmlUtils.createHtmlStr(0xb4b4b4,EventParseUtil.parseEvent(data));
		}
		

		public function get data():SchoolEventData
		{
			return _data;
		}

		public function set data(value:SchoolEventData):void
		{
			_data = value;
		}


		public function destroy():void
		{
			
		}
	}
}