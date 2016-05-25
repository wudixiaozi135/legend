package com.view.gameWindow.scene.entity.entityInfoLabel
{
	import com.view.gameWindow.scene.entity.entityInfoLabel.interf.IEntityInfoLabel;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class EntityInfoLabel extends Sprite implements IEntityInfoLabel
	{
		private var _entityId:int;

		public function get entityId():int
		{
			return _entityId;
		}

		public function set entityId(value:int):void
		{
			_entityId = value;
		}
		
		protected var _nameTxtBitmap:Bitmap;
		
		public function EntityInfoLabel()
		{
		}
		
		public function clearNameText():void
		{
			if(_nameTxtBitmap)
			{
				if (_nameTxtBitmap.bitmapData)
				{
					_nameTxtBitmap.bitmapData.dispose();
					_nameTxtBitmap.bitmapData = null;
				}
				if(_nameTxtBitmap.parent)
				{
					_nameTxtBitmap.parent.removeChild(_nameTxtBitmap);
				}
				_nameTxtBitmap = null;
			}
		}
		
		public function refreshNameTextContent(nameTxt:TextField):void
		{
			
		}
		
		public function refreshNameTextPos(nameTxt:TextField, modelHeight:int):void
		{
			
		}
		
		public function isMouseOn():Boolean
		{
			if(_nameTxtBitmap && _nameTxtBitmap.bitmapData)
			{
				var mx:Number = _nameTxtBitmap.mouseX*_nameTxtBitmap.scaleX;//返回相对图像的起始点位置
				var my:Number = _nameTxtBitmap.mouseY*_nameTxtBitmap.scaleY;
				var result:Boolean = mx > 0 && mx <= _nameTxtBitmap.width && my > 0 && my <= _nameTxtBitmap.height && _nameTxtBitmap.bitmapData;
				if (result)
				{
					try
					{
						result = result && _nameTxtBitmap.bitmapData.getPixel32(_nameTxtBitmap.mouseX, _nameTxtBitmap.mouseY) != 0;
					}
					catch (error:Error)
					{
						
					}
				}
				return result;
			}
			else
			{
				return false;
			}
		}
		
		public function destroy():void
		{
			clearNameText();
		}
	}
}