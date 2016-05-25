package com.view.gameWindow.scene.viewItem
{
	import com.view.gameWindow.scene.entity.constants.EntityTypes;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class SceneViewItem extends Sprite implements ISceneViewItem
	{
		public static const FRAME_TIME:Number = 1000 / 60;
		public static const FRAME_TIME_INT:int =17;
		
		protected var _viewBitmap:Bitmap;
		
		public function SceneViewItem()
		{
		}
		
		public function get entityId():int
		{
			return 0;
		}
		
		public function set entityId(value:int):void
		{
		}
		
		public function get entityType():int
		{
			return EntityTypes.ET_NONE;
		}
		
		public function set entityType(value:int):void
		{
		}
		
		public function updateFrame(timeDiff:int):void
		{
			
		}
		
		public function destory():void
		{
			if (_viewBitmap)
			{
				if (_viewBitmap.bitmapData)
				{
					_viewBitmap.bitmapData = null;
				}
				if (_viewBitmap.parent)
				{
					removeChild(_viewBitmap);
				}
				_viewBitmap.filters = null;
				_viewBitmap = null;
			}
		}
	}
}