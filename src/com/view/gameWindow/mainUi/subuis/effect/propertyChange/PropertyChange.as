package com.view.gameWindow.mainUi.subuis.effect.propertyChange
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.AttrCfgData;
	import com.model.consts.RolePropertyConst;
	import com.model.consts.StringConst;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.MainUi;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilsTimeOut;
	
	import flash.utils.Dictionary;
	
	public class PropertyChange extends MainUi implements IObserver
	{
		private var _attrs:Dictionary;
		
		private const red:uint = 0xff0000;
		private const green:uint = 0x00ff00;
		
		private var timer:int = 0;
		
		public function PropertyChange()
		{
			super();
			RoleDataManager.instance.attach(this);
		}
		
		override public function initView():void
		{
			
		}
		
		public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_CHR_INFO)
			{
				initData();
				resetTime();
				showRollTip();
			}
		}
		
		private function initData():void
		{
			if(!_attrs)
			{
				_attrs = new Dictionary();
				var attrTypes:Vector.<int> = RolePropertyConst.attrTypes;
				var attrType:int;
				for each (attrType in attrTypes)
				{
					var attr:int = RoleDataManager.instance.attrPool[attrType] as int;
					_attrs[attrType] = attr;
				}
			}
		}
		
		private function resetTime():void
		{
			if(!RollTipMediator.instance.rewards.length)
			{
				timer = 0;
			}
		}
		
		private function showRollTip():void
		{
			var attrTypes:Vector.<int> = RolePropertyConst.attrTypes;
			var attrType:int
			for each (attrType in attrTypes)
			{
				var attrCfgData:AttrCfgData = ConfigDataManager.instance.attrCfgData(attrType);
				if(!attrCfgData || !attrCfgData.is_dialog)
				{
					continue;
				}
				var attr:int = RoleDataManager.instance.attrPool[attrType] as int;
				var attrTemp:int = _attrs[attrType] as int;
				var attD:int = attr - attrTemp;
				var str:String;
				if(attD > 0)
				{
					str = RolePropertyConst.getPropertyName(attrType) + StringConst.ROLE_PROPERTY_ADD + attD;
					creatStr(green,str);
					_attrs[attrType] = attr;
				}
				else if (attD < 0)
				{
					str = RolePropertyConst.getPropertyName(attrType) + attD;
					creatStr(red,str);
					_attrs[attrType] = attr;
				}
			}
		}
		
		private function creatStr(color:uint,str:String,font:int = 18):void
		{
			var string:String;
			string = HtmlUtils.createHtmlStr(color, str,font);
			UtilsTimeOut.dealTimeOut(string,timer,RollTipType.PROPERTY);
			timer += 500;
		}
	}
}