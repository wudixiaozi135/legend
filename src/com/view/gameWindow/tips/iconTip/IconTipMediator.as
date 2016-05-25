package com.view.gameWindow.tips.iconTip
{
	import com.view.gameWindow.tips.iconTip.iconTips.IconTipReincarn;
	
	import flash.display.Sprite;

	public class IconTipMediator
	{
		private static var _instance:IconTipMediator;
		
		private var _layer:Sprite;
		private var _iconTipReincarn:Vector.<IconTipReincarn>;
		private var _iconTip:IconTip;
		
		public static function get instance():IconTipMediator
		{
			if(!_instance)
				_instance = new IconTipMediator(new PrivateClass());
			return _instance;
		}
		
		public function IconTipMediator(pc:PrivateClass)
		{
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			_iconTipReincarn = new Vector.<IconTipReincarn>();
		}
		
		public function initData(layer:Sprite):void
		{
			_layer = layer;
		}
		
		public function showIconTip(type:int,text:String,callback:Function):void
		{
			if(type == IconTipType.IconTipREINCARN && _iconTipReincarn.length)
			{
				return;
			}
			_iconTip = initRollTip(type,text,callback);
			if(_iconTip)
			{
				initPos(type,_iconTip);
				doDeal(type,_iconTip);
			}
		}
		
		private function initRollTip(type:int,text:String,callback:Function):IconTip
		{
			switch(type)
			{
				case IconTipType.IconTipREINCARN:
					return new IconTipReincarn(text,callback);
				default:
					return null;
			}
		}
		
		private function initPos(type:int,iconTip:IconTip):void
		{
			switch(type)
			{
				case IconTipType.IconTipREINCARN:
					_iconTip.x = (_layer.stage.stageWidth - _iconTip.width)/2;
					_iconTip.y = (_layer.stage.stageHeight - _iconTip.height)/2;
					break;
			}
			_layer.addChild(iconTip);
		}
		
		public function resize(newWidth:int, newHeight:int):void
		{
			if(!_iconTip)
			{
				return;
			}
			_iconTip.x = (newWidth - _iconTip.width)/2;
			_iconTip.y = (newHeight - _iconTip.height)/2 + 225;
		}
		
		private function doDeal(type:int,iconTip:IconTip):void
		{
			switch(type)
			{
				case IconTipType.IconTipREINCARN:
					_iconTipReincarn.push(iconTip);
					break;
			}
			iconTip.deal();
		}
		
		public function removeIcontip(iconTip:IconTip):void
		{
			var indexOf:int;
			if(iconTip is IconTipReincarn)
			{
				indexOf = _iconTipReincarn.indexOf(iconTip);
				if(indexOf != -1)
				{
					_iconTipReincarn.splice(indexOf,1);
				}
			}
		}
	}
}
class PrivateClass{}