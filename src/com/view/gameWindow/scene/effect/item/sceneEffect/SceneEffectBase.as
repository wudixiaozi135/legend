package com.view.gameWindow.scene.effect.item.sceneEffect
{
	import com.view.gameWindow.scene.effect.item.EffectBase;
	import com.view.gameWindow.scene.effect.item.sceneEffect.interf.ISceneEffectBase;
	import com.view.gameWindow.scene.map.utils.MapTileUtils;
	
	public class SceneEffectBase extends EffectBase implements ISceneEffectBase
	{
		protected var _pixelX:Number;
		protected var _pixelY:Number;
		protected var _tileX:int;
		protected var _tileY:int;
		
		public function SceneEffectBase(path:String)
		{
			super(path);
		}
		
		public function get pixelX():Number
		{
			return _pixelX;
		}
		
		public function get pixelY():Number
		{
			return _pixelY;
		}
		
		public function set pixelX(value:Number):void
		{
			_pixelX = value;
			x = int(_pixelX);
			_tileX = MapTileUtils.pixelXToTileX(_pixelX);
		}
		
		public function set pixelY(value:Number):void
		{
			_pixelY = value;
			y = int(_pixelY);
			_tileY = MapTileUtils.pixelYToTileY(_pixelY);
		}
		
		public function get tileX():int
		{
			return _tileX;
		}
		
		public function get tileY():int
		{
			return _tileY;
		}
		
		public function set tileX(value:int):void
		{
			_tileX = value;
			_pixelX = MapTileUtils.tileXToPixelX(_tileX);
			x = int(_pixelX);
		}
		
		public function set tileY(value:int):void
		{
			_tileY = value;
			_pixelY = MapTileUtils.tileYToPixelY(_tileY);
			y = int(_pixelY);
		}
		
		public override function destory():void
		{
			super.destory();
		}
	}
}