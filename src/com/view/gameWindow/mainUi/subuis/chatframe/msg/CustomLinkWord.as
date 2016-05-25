package com.view.gameWindow.mainUi.subuis.chatframe.msg
{
	
	/**
	 * @author wqhk
	 * 2015-1-16
	 */
	public class CustomLinkWord extends LinkWord
	{
		public function CustomLinkWord()
		{
			super();
		}
		
		override public function getDescription():String
		{
			if(!des)
			{
				if(data)
				{
					var d:Array = LinkWord.splitData(data);
					des = d[1];
				}
			}
			return des;
		}
		
		public var des:String = "";
		public var color:int = 0;
		
		override public function getEventName():String
		{
			if(!event)
			{
				var e:Array = LinkWord.splitData(data);
				if(e.length > 2)
				{
					event = e[2];
				}
			}
			
			return event;
		}
		
		override public function getEventData():String
		{
			if(!eventData)
			{
				var e:Array = LinkWord.splitData(data);
				if(e.length > 3)
				{
					eventData = e[3];
				}
			}
			return eventData;
		}
		
		override public function getUnderline():Boolean
		{
			return Boolean(getEventName());
		}
		
		override public function getColor():uint
		{
			if(data)
			{
				if(color == 0)
				{
					var cls:Array = LinkWord.splitData(data);
					color = parseInt(cls[0]);
				}
				
				return color;
			}
			else
			{
				return 0xcccc00;
			}
		}
	}
}