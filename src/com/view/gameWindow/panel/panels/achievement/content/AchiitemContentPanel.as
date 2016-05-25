package com.view.gameWindow.panel.panels.achievement.content
{
	import com.view.gameWindow.panel.panels.achievement.common.IScrollItem;
	import com.view.gameWindow.panel.panels.achievement.common.ScrollContentBase;
	
	public class AchiitemContentPanel extends ScrollContentBase
	{
		private const scrollRectH:int=395;
		public function AchiitemContentPanel()
		{
			super();
			
		}
		
		override public function setItemSelect(item:IScrollItem):void
		{
			
		}
		
		override public function destroy():void
		{
			
		}
		
		override public function get scrollRectHeight():int
		{
			return scrollRectH;
		}
	}
}