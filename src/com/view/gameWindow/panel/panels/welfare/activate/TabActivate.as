package com.view.gameWindow.panel.panels.welfare.activate
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.panels.welfare.MCActivate;
	import com.view.gameWindow.panel.panels.welfare.WelfareDataMannager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	
	public class TabActivate extends TabBase
	{
		public function TabActivate()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:MCActivate = new MCActivate;
			_skin = skin;
			addChild(skin);
		}
		
		override protected function initData():void
		{
			_skin.inforTxt.htmlText = StringConst.WELFARE_PANEL_0033;
			_skin.inputTxt.text = StringConst.WELFARE_PANEL_0034;
			_skin.inputTxt.type = TextFieldType.INPUT;
			_skin.addEventListener(MouseEvent.CLICK,onClick); 
			_skin.addEventListener(Event.ADDED_TO_STAGE,onStage);
		}
		
		protected function onStage(event:Event):void
		{
			_skin.stage.addEventListener(MouseEvent.CLICK,onClick); 
		}
		
		private function onClick(e:MouseEvent):void
		{
			if(e.target == _skin.awardBtn  && e.currentTarget != _skin.stage)
			{
				var str:String = _skin.inputTxt.text;
				if(str == '' || str == StringConst.WELFARE_PANEL_0034)
				{
					Alert.message(StringConst.WELFARE_PANEL_0035);
					return;
				}
				WelfareDataMannager.instance.getActivateAward(str);
			}
			else if(e.target == _skin.inputTxt)
			{
				_skin.inputTxt.text = '';
			}
			else
			{
				_skin.inputTxt.text = StringConst.WELFARE_PANEL_0034;
			}
			e.stopImmediatePropagation();
		}
 		
		override public function refresh():void
		{
			 
		}
		
		override public function update(proc:int=0):void
		{
			 
		}
		
		override public function destroy():void
		{
			_skin.removeEventListener(MouseEvent.CLICK,onClick);
			_skin.removeEventListener(Event.ADDED_TO_STAGE,onStage);
			if(_skin.stage)
			{
				_skin.stage.removeEventListener(MouseEvent.CLICK,onClick);
			}
			super.destroy();
		}
		
	}
}