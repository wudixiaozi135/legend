package com.view.gameWindow.panel.panels.roleProperty.property
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.AttrCfgData;
	import com.model.consts.RolePropertyConst;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.roleProperty.McProperty;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.events.Event;
	import flash.text.TextField;
	
	
	/**人物角色面板中子面板属性面板*/
	public class PropertyPanel extends TabBase
	{
		private var _attrVec:Vector.<int>;
		
		public function PropertyPanel()
		{
			super();
		}
		
		
		override public function update(proc:int=0):void
		{
			changeValue();
		}
		
		
		override protected function initSkin():void
		{
			_skin = new McProperty();
			addChild(_skin);
		}
		
		override protected function initData():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
			initText();
		}
		
		private function initText():void
		{
			if(!_attrVec)
			{
				_attrVec = new <int>[RolePropertyConst.ROLE_PROPERTY_CRIT_HURT_ID,RolePropertyConst.ROLE_PROPERTY_MA_BI_RATE_ID,
					RolePropertyConst.ROLE_PROPERTY_HP_DRAIN_ID,RolePropertyConst.ROLE_PROPERTY_HP_DRAIN_RATE_ID,
					RolePropertyConst.ROLE_PROPERTY_MP_DRAIN_ID,RolePropertyConst.ROLE_PROPERTY_MP_DRAIN_RATE_ID,
					RolePropertyConst.ROLE_PROPERTY_HUMANOID_KILLER_ID,RolePropertyConst.ROLE_PROPERTY_BEAST_KILLER_ID,
					RolePropertyConst.ROLE_PROPERTY_GHOST_KILLER_ID,RolePropertyConst.ROLE_PROPERTY_DEVIL_KILLER_ID,
					RolePropertyConst.ROLE_PROPERTY_ANTI_HP_RECOVER_ID,RolePropertyConst.ROLE_PROPERTY_MIAN_SHANG_CHUAN_TOU_ID,
					//
					RolePropertyConst.ROLE_PROPERTY_HOLY_ID,RolePropertyConst.ROLE_PROPERTY_RESILIENCE_ID,
					RolePropertyConst.ROLE_PROPERTY_HEART_EVASION_ID,RolePropertyConst.ROLE_PROPERTY_MAGIC_EVASION_ID,
					RolePropertyConst.ROLE_PROPERTY_WU_LI_MIAN_SHANG_ID,RolePropertyConst.ROLE_PROPERTY_MO_FA_MIAN_SHANG_ID,
					RolePropertyConst.ROLE_PROPERTY_REFLECT_ID,RolePropertyConst.ROLE_PROPERTY_REFLECT_RATE_ID,
					RolePropertyConst.ROLE_PROPERTY_PARRY_ID,RolePropertyConst.ROLE_PROPERTY_PARRY_VALUE_ID,
					RolePropertyConst.ROLE_PROPERTY_ANTI_LUCKY_ID,RolePropertyConst.ROLE_PROPERTY_MA_BI_KANG_XING_ID,
					//
					RolePropertyConst.ROLE_PROPERTY_BLOOD_RETURN_ID,RolePropertyConst.ROLE_PROPERTY_MAGIC_RETURN_ID,
					RolePropertyConst.ROLE_PROPERTY_ANTI_POISON_ID,RolePropertyConst.ROLE_PROPERTY_MA_BI_RECOVER,
					RolePropertyConst.ROLE_PROPERTY_DRUG_INTENSIFY_ID,RolePropertyConst.ROLE_PROPERTY_REVIVE_HP_UP,
					RolePropertyConst.ROLE_PROPERTY_KILL_HP_RECOVER_ID,RolePropertyConst.ROLE_PROPERTY_KILL_MP_RECOVER_ID,
					//
					RolePropertyConst.ROLE_PROPERTY_KILL_MONSTER_MONEY_ID,RolePropertyConst.ROLE_PROPERTY_KILL_MONSTER_EXPERIENCE_ID,
					RolePropertyConst.ROLE_PROPERTY_ITEM_RROP_RATE_ID];
			}
			//
			var i:int,l:int = _attrVec.length;
			for (i=0;i<l;i++) 
			{
				var txtName:TextField = _skin["txtName"+i] as TextField;
				var txtValue:TextField = _skin["txtValue"+i] as TextField;
				var attrType:int = _attrVec[i];
				ToolTipManager.getInstance().attachByTipVO(txtName,ToolTipConst.TEXT_TIP,getTipData,attrType);
				ToolTipManager.getInstance().attachByTipVO(txtValue,ToolTipConst.TEXT_TIP,getTipData,attrType);
				var cfgDt:AttrCfgData = ConfigDataManager.instance.attrCfgData(attrType);
				txtName.text = cfgDt.name+StringConst.COLON;
			}
		}
		
		private function getTipData(attrType:int):String
		{
			var cfgDt:AttrCfgData = ConfigDataManager.instance.attrCfgData(attrType);
			if(cfgDt)
			{
				return CfgDataParse.pareseDesToStr(cfgDt.tips);
//				return HtmlUtils.createHtmlStr(0xffe1aa,cfgDt.tips);
			}
			else
			{
				return "";
			}
		}
		
		public function changeValue():void
		{
			var i:int,l:int = _attrVec.length;
			for (i=0;i<l;i++) 
			{
				var txtValue:TextField = _skin["txtValue"+i] as TextField;
				var attrType:int = _attrVec[i];
				var value:int = RoleDataManager.instance.getAttrValueByType(attrType);
				var cfgDt:AttrCfgData = ConfigDataManager.instance.attrCfgData(attrType);
				if(cfgDt.percentage)
				{
					txtValue.text = CfgDataParse.getPercentValue(value) + "%";
				}
				else
				{
					txtValue.text = "+"+value+"";
				}
			}
		}
		
		private function removeFromStage(event:Event):void
		{
			var i:int,l:int = _skin.numChildren;
			for (i=0;i<l;i++) 
			{
				var textField:TextField = _skin.getChildAt(i) as TextField;
				if(textField)
				{
					ToolTipManager.getInstance().detach(textField);
				}
			}
			_attrVec = null;
			removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			// TODO Auto Generated method stub
			super.addCallBack(rsrLoader);
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			RoleDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			RoleDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}