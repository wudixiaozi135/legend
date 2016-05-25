package com.view.gameWindow.scene.entity.entityInfoLabel
{
	import com.view.gameWindow.scene.entity.entityInfoLabel.interf.IDropItemInfoLabel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.TextField;
	
	public class DropItemInfoLabel extends EntityInfoLabel implements IDropItemInfoLabel
	{
		public function DropItemInfoLabel()
		{
			super();
		}
		
		public override function refreshNameTextPos(nameTxt:TextField, modelHeight:int):void
		{
			if (!_nameTxtBitmap)
			{
				_nameTxtBitmap = new Bitmap();
			}
			if (!_nameTxtBitmap.bitmapData)
			{
				_nameTxtBitmap.bitmapData = new BitmapData(nameTxt.width, nameTxt.height, true, 0x00000000);
				_nameTxtBitmap.bitmapData.draw(nameTxt);
			}
			if(_nameTxtBitmap.y != -_nameTxtBitmap.height/2-25)
				_nameTxtBitmap.y = -_nameTxtBitmap.height/2-25;
			if(_nameTxtBitmap.x != -_nameTxtBitmap.width/2)
				_nameTxtBitmap.x = -_nameTxtBitmap.width/2;
			if(!_nameTxtBitmap.parent)
				addChild(_nameTxtBitmap);
		}
	}
}