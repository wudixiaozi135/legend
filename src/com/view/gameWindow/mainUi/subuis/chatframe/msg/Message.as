package com.view.gameWindow.mainUi.subuis.chatframe.msg
{
	import com.view.gameWindow.mainUi.subuis.chatframe.MessageCfg;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextLine;
	
	
	/**
	 * @author wqhk
	 * 2014-8-8
	 */
	public class Message extends Sprite
	{
		public var numLine:int;
		public var totalHeight:Number;
		/**
		 * 清理事件监听用
		 */
		public var recordLinks:Vector.<LinkWordView>
		private var txtLayer:Sprite;
		public function Message()
		{
			super();
			txtLayer = new Sprite();
			addChild(txtLayer);
		}
		
		public function hideBg():void
		{
			graphics.clear();
		}
		
		public function remove():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
		}
		
		public function destroy():void
		{
			removeEvents();
			recordLinks = null;
			remove();
		}
		
		public function removeEvents():void
		{
			for each(var link:LinkWordView in recordLinks)
			{
				link.removeEvents();
			}
		}
		
		public function addEvents():void
		{
			for each(var link:LinkWordView in recordLinks)
			{
				link.addEvents();
			}
		}
		
		
		/**
		 * @param color 0 特殊处理代表没有底色
		 */
		public function createTextLines(textBlock:TextBlock,color:uint=0,lineLength:int=-1):void 
		{
			//clear
			numLine = 0;
			totalHeight = 0;
			graphics.clear();
			while(txtLayer.numChildren)
			{
				txtLayer.removeChildAt(0);
			}
			//do
			var yPos:Number = 0;
			var textLine:TextLine = textBlock.createTextLine (null, lineLength == -1 ? MessageCfg.LINE_LENGTH:lineLength);
			numLine = 0;
			while (textLine)
			{
				++numLine;
				txtLayer.addChild(textLine);
				textLine.x = 0;
				yPos += textLine.height+MessageCfg.LINE_SPACE;
				totalHeight = yPos;//字符的基线在底部
				textLine.y = yPos;
				
				if(color)
				{
					graphics.beginFill(color);
					graphics.drawRect(0,yPos-textLine.height,textLine.width,textLine.height+MessageCfg.LINE_SPACE);
					graphics.endFill();
				}
				
				textLine = textBlock.createTextLine(textLine, MessageCfg.LINE_LENGTH);
			}
			
			txtLayer.filters = [new GlowFilter(0,1,3,3,5)];
		}
	}
}