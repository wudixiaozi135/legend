package com.view.gameWindow.panel.panels.roleProperty.role
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.subuis.common.CheckItemBase;
	import com.view.gameWindow.mainUi.subuis.musicSet.item.McSetting;
	import com.view.gameWindow.panel.panels.guideSystem.view.NoneHitArea;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class HideFactionSettingItem extends CheckItemBase
	{
		public function HideFactionSettingItem()
		{
			super();
			_skin = new McSetting();
			addChild(_skin);
			initView();
			_skin.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		private function onClick(event:MouseEvent):void
		{
			var skin:McSetting = _skin as McSetting;
			switch (event.target)
			{
				case skin.checkBtn:
					checkHandler();
					break;
				default :
					break;
			}
		}
		
		private function checkHandler():void
		{
			checked = skin.checkBtn.selected;
			if(checked)
			{
				if(selectedFun != null)
				{
					selectedFun();
				}
			}
			else
			{
				if(cancleSelectedFun != null)
				{
					cancleSelectedFun();
				}
			}
			
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var skin:McSetting = _skin as McSetting;
			skin.label.mouseEnabled = false;
			rsrLoader.addCallBack(skin.checkBtn, function (mc:MovieClip):void
			{
				if (skin && skin.checkBtn)
					skin.checkBtn.selected = checked;
			});
		}
		
		override public function set label(value:String):void
		{
			super.label = value;
			if (_skin)
			{
				_skin.label.text = value;
			}
		}
		
		override public function set checked(value:Boolean):void
		{
			super.checked = value;
			if (_skin && _skin.checkBtn)
			{
				_skin.checkBtn.selected = value;
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
			_skin.removeEventListener(MouseEvent.CLICK, onClick);
		}
	}
}