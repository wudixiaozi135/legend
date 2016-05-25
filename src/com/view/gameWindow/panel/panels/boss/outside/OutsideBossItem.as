package com.view.gameWindow.panel.panels.boss.outside
{
	import com.model.configData.cfgdata.BossCfgData;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.boss.MCFieldBossItem;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class OutsideBossItem
	{
		private var _data:BossCfgData;
		private var _rsloader:RsrLoader;
		private var _isloaded:Boolean;
		private var isClick:Boolean;

		private var _handler:TabOutsideViewHandle;
		private var _skin:MCFieldBossItem;
		 
		public function OutsideBossItem(handler:TabOutsideViewHandle)
		{
			this._handler = handler;
			_skin = new MCFieldBossItem();
		}
		
		public function get skin():MCFieldBossItem
		{
			return _skin;
		}
		
		public function init(_rsloader:RsrLoader):void
		{
			_skin.nameTxt.mouseEnabled = false;
			_rsloader.addCallBack(_skin.changeBtnMc,function (mc:MovieClip):void
			{
				_isloaded = true;
				mc.mcVip.visible=false;
				//				var flag:Boolean = _data.hp>0;
				if(isClick)
				{
					mc.Fresh = true;
				}
			});
			_rsloader.loadItemRes(_skin.changeBtnMc);
			_skin.addEventListener(MouseEvent.CLICK,onClickItem);
		}
		
		
		public function onClickItem(e:MouseEvent = null):void
		{
			if(_handler.selectItem!=null)
			{
				_handler.selectItem.setCheck(false);
			}
			_handler.showDetail(_data);
			_handler.selectItem=this;
			setCheck(true);
		}
		
		public function setCheck(bool:Boolean):void
		{
			if(_skin.changeBtnMc)
			{
				_skin.changeBtnMc.Fresh = bool;
				isClick = bool;
			}
		}
		
		internal function refresh(bossCfgData:BossCfgData):void
		{
			_data = bossCfgData;
			_skin.nameTxt.text = bossCfgData.name;
			//			if(_isloaded)
			//			{
			//				var flag:Boolean = _data.hp>0;
			//				_skin.changeBtnMc.Fresh = true;
			//			}
		}
		
		internal function destroy():void
		{
			if(_skin.parent)
			{
				_skin.parent.removeChild(_skin);
				_skin.x = 0;
				_skin.y = 0;
			}
			_skin.removeEventListener(MouseEvent.CLICK,onClickItem);
			_skin = null;
		}
	}
}