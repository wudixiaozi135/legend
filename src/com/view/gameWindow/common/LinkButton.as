package com.view.gameWindow.common
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	
	
	/**
	 * @author wqhk
	 * 2014-8-28
	 */
	public class LinkButton extends Sprite
	{
		private var text:TextField;
		private var light:ColorMatrixFilter;
		public function LinkButton()
		{
			super();
			buttonMode = true;
			useHandCursor = true;
			
			
			light = new ColorMatrixFilter();
			light.matrix = [1,0,0,0,50,
				0,1,0,0,50,
				0,0,1,0,50,
				0,0,0,1,0];
			
			addEventListener(MouseEvent.ROLL_OVER,rollOverHandler,false,0,true);
			addEventListener(MouseEvent.ROLL_OUT,rollOutHandler,false,0,true);
			
		}
		
		public function destroy():void
		{
			removeEventListener(MouseEvent.ROLL_OVER,rollOverHandler);
			removeEventListener(MouseEvent.ROLL_OUT,rollOutHandler);
		}
		
		private function rollOverHandler(e:Event):void
		{
			filters = [light];
		}
		
		private function rollOutHandler(e:Event):void
		{
			filters = null;
		}
		
		
		public function set label(htmlText:String):void
		{
			if(!text)
			{
				text = new TextField();
				text.selectable = false;
				text.mouseEnabled = false;
				addChild(text);
			}
			
			text.htmlText = htmlText;
			text.width = text.textWidth + 5;
			text.height = text.textHeight + 5;
		}
	}
}