package com.view.gameWindow.panel.panels.boss.vip
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.MCVIPBossItem;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class VipBossItem
	{
		private var _skin:MCVIPBossItem;
		private var _data:VipBossItemData;
		private var _rsloader:RsrLoader;
		private var _parent:TabVipViewHandle;
		private var _isloaded:Boolean;
		private var isClick:Boolean;
		 
		public function VipBossItem(parent:TabVipViewHandle)
		{
			_parent = parent;
			_skin = new MCVIPBossItem();
			
		}
		
		public function get skin():MCVIPBossItem
		{
			return _skin;
		}

		public function init(_rsloader:RsrLoader):void
		{
			
			_skin.nameTxt.mouseEnabled = false;
			//_skin.appearMc.mouseEnabled = false;
			//_rsloader.loadItemRes(_skin.appearMc.mc);
			
			_rsloader.addCallBack(_skin.changeBtnMc,function (mc:MovieClip):void
			{
				_isloaded = true;
				mc.Num = int(_data.bossVip);
				var flag:Boolean = _data.hp>0;
				mc.Fresh = !flag;
			});
			_rsloader.loadItemRes(_skin.changeBtnMc);
			_skin.addEventListener(MouseEvent.CLICK,onClickItem);
			_skin.addEventListener(Event.ADDED_TO_STAGE,onAdd);
			
 
		}
		
		protected function onAdd(event:Event):void
		{
			_skin.stage.addEventListener(MouseEvent.CLICK,onstageclick);
			
		}
		
		protected function onstageclick(event:MouseEvent):void
		{
			//trace("_skin>>>",_skin,_skin.name,event.target,' ',event.currentTarget);
			if(_skin.changeBtnMc && event.target != _skin.changeBtnMc.mcBtn &&(event.target.parent.parent is MCVIPBossItem))
			{
				_skin.changeBtnMc.Fresh = false;
				isClick = false;
			}
			
		}
		
 
		public function onClickItem(e:MouseEvent = null):void
		{
			_parent.showItem(_data);
			//trace("_skin>>>",_skin,_skin.name);
			if(_skin.changeBtnMc && !_skin.changeBtnMc.Fresh)
			{
				_skin.changeBtnMc.Fresh = true;
				isClick = true;
			}
			
		}
		
		internal function refresh(data:VipBossItemData):void
		{
			_data = data;
			_skin.nameTxt.text = data.bossName;
			//trace(_skin.changeBtnMc); 
			if(_isloaded)
			{
				_skin.changeBtnMc.Num = int(_data.bossVip)
				var flag:Boolean = _data.hp>0;
				_skin.changeBtnMc.Fresh = !flag;
			}
					
			 	
		}

		internal function destroy():void
		{
			if(_skin.parent)
			{
				_skin.stage.removeEventListener(MouseEvent.CLICK,onstageclick);
				_skin.parent.removeChild(_skin);
				_skin.x = 0;
				_skin.y = 0;
			}
			_skin.removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			
			_skin.removeEventListener(MouseEvent.CLICK,onClickItem);
			_skin = null;
		}
	}
}