package com.view.gameWindow.panel.panels.bag.menu
{
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * 包裹单元格菜单项
	 * @author Administrator
	 */	
	public class BagCellMenuItem extends Sprite
	{
		public var type:int;
		
		public function BagCellMenuItem(type:int)
		{
			this.type = type;
			var word:String = ConstBagCellMenu.getWordByType(type);
			var skin:McBagCellMenuItem = new McBagCellMenuItem();
			var txt:TextField = skin.txt;
			txt.text = word;
			txt.mouseEnabled = false;
			txt.x = 0;
			txt.y = 0;
			addChild(txt);
		}
	}
}