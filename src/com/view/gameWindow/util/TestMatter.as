package com.view.gameWindow.util
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	public class TestMatter extends Sprite
	{
		public function TestMatter()
		{
			super();
			var text:TextField=new TextField();
			addChild(text);
//			text.x=480;
			text.text="test mc  matter";
		}
		
		
		private static var _instace:TestMatter;
		public static function getInstace():TestMatter
		{
			if(_instace==null)
			{
				_instace=new TestMatter();
			}
			return _instace;
		}
		
		public function addItem(dis:BitmapData):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xff0000,0.2);
			this.graphics.drawRect(0,0,dis.rect.width,dis.rect.height);
			
			this.graphics.beginBitmapFill(dis, new Matrix(-1, 0, 0, 1,dis.rect.width , 0),false);
			this.graphics.drawRect(0,0,dis.rect.width,dis.rect.height);
			this.graphics.endFill();
		}
	}
}