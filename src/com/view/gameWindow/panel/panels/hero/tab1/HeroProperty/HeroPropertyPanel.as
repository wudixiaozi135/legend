package com.view.gameWindow.panel.panels.hero.tab1.HeroProperty
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.AttrCfgData;
	import com.model.consts.RolePropertyConst;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.hero.HeroDataManager;
	import com.view.gameWindow.panel.panels.hero.HeroProperty.McHeroPropertyPanel;
	import com.view.gameWindow.panel.panels.hero.tab1.HeroEquipTab;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.utils.StringUtil;
	
	
	/**英雄属性面板*/
	public class HeroPropertyPanel extends TabBase
	{
		private var _clickHandler:HeroPropertyClickHandler;
		private var _msg:String="{0}/{1}";
		private var _attrVec:Vector.<int>;
		
		public function HeroPropertyPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_skin = new McHeroPropertyPanel();
			addChild(_skin);
		}
		
		override protected function initData():void
		{
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
			var mc:McHeroPropertyPanel = _skin as McHeroPropertyPanel;
			_clickHandler = new HeroPropertyClickHandler(mc,this);
			
			initText();
			changeValue();
		}
		
		private function initText():void
		{
			var mcProperty:McHeroPropertyPanel,defaultTextFormat:TextFormat;
			mcProperty = _skin as McHeroPropertyPanel;
			defaultTextFormat = mcProperty["txtName_1"].defaultTextFormat;
			
			var textNameVec:Vector.<String>=new Vector.<String>();
			var msg:String;
			for(var i:int=6;i<13;i++)
			{
				if(i<=9)
				{
					msg=StringConst["HERO_PANEL_00"+String(i)];
				}
				else
				{
					msg=StringConst["HERO_PANEL_0"+String(i)];
				}
				
				textNameVec.push(msg);
			}
			for(i=1;i<=7;i++)
			{
				mcProperty["txtName_"+i].defaultTextFormat = defaultTextFormat;
				mcProperty["txtName_"+i].setTextFormat(defaultTextFormat);
				mcProperty["txtName_"+i].text=textNameVec[i-1];
			}
			//
			if(!_attrVec)
			{
				_attrVec = new <int>
				[
					RolePropertyConst.ROLE_PROPERTY_ACCURATE_ID,RolePropertyConst.ROLE_PROPERTY_HP_DRAIN_ID,RolePropertyConst.ROLE_PROPERTY_MP_DRAIN_ID,
					RolePropertyConst.ROLE_PROPERTY_CRIT_ID,RolePropertyConst.ROLE_PROPERTY_HP_DRAIN_RATE_ID,RolePropertyConst.ROLE_PROPERTY_MP_DRAIN_RATE_ID,
					RolePropertyConst.ROLE_PROPERTY_CRIT_HURT_ID,RolePropertyConst.ROLE_PROPERTY_MA_BI_RATE_ID,RolePropertyConst.ROLE_PROPERTY_ANTI_HP_RECOVER_ID,
					RolePropertyConst.ROLE_PROPERTY_LUCKY_ID,RolePropertyConst.ROLE_PROPERTY_HUMANOID_KILLER_ID,RolePropertyConst.ROLE_PROPERTY_GHOST_KILLER_ID,
					RolePropertyConst.ROLE_PROPERTY_DAMNATION_ID,RolePropertyConst.ROLE_PROPERTY_BEAST_KILLER_ID,RolePropertyConst.ROLE_PROPERTY_DEVIL_KILLER_ID,
					RolePropertyConst.ROLE_PROPERTY_MIAN_SHANG_CHUAN_TOU_ID,RolePropertyConst.ROLE_PROPERTY_DAMAGE_UP,RolePropertyConst.ROLE_PROPERTY_HEART_HURT_ID,
					RolePropertyConst.ROLE_PROPERTY_ATTACK_SPEED_ID,RolePropertyConst.ROLE_PROPERTY_MOVE_SPEED_ID,
					//
					RolePropertyConst.ROLE_PROPERTY_HOLY_ID,RolePropertyConst.ROLE_PROPERTY_WU_LI_MIAN_SHANG_ID,RolePropertyConst.ROLE_PROPERTY_AGILE_ID,
					RolePropertyConst.ROLE_PROPERTY_RESILIENCE_ID,RolePropertyConst.ROLE_PROPERTY_MO_FA_MIAN_SHANG_ID,RolePropertyConst.ROLE_PROPERTY_MAGIC_EVASION_ID,
					RolePropertyConst.ROLE_PROPERTY_ANTI_LUCKY_ID,RolePropertyConst.ROLE_PROPERTY_MA_BI_KANG_XING_ID,RolePropertyConst.ROLE_PROPERTY_HEART_EVASION_ID,
					RolePropertyConst.ROLE_PROPERTY_REFLECT_ID,RolePropertyConst.ROLE_PROPERTY_PARRY_ID,RolePropertyConst.ROLE_PROPERTY_PARRY_VALUE_ID,
					RolePropertyConst.ROLE_PROPERTY_REFLECT_RATE_ID,
					//
					RolePropertyConst.ROLE_PROPERTY_BLOOD_RETURN_ID,RolePropertyConst.ROLE_PROPERTY_MA_BI_RECOVER,RolePropertyConst.ROLE_PROPERTY_KILL_HP_RECOVER_ID,
					RolePropertyConst.ROLE_PROPERTY_MAGIC_RETURN_ID,RolePropertyConst.ROLE_PROPERTY_DRUG_INTENSIFY_ID,RolePropertyConst.ROLE_PROPERTY_KILL_MP_RECOVER_ID,
					RolePropertyConst.ROLE_PROPERTY_ANTI_POISON_ID,RolePropertyConst.ROLE_PROPERTY_REVIVE_HP_UP,
					
					//
					RolePropertyConst.ROLE_PROPERTY_KILL_MONSTER_MONEY_ID,RolePropertyConst.ROLE_PROPERTY_KILL_MONSTER_EXPERIENCE_ID,RolePropertyConst.ROLE_PROPERTY_ITEM_RROP_RATE_ID,
					RolePropertyConst.ROLE_PROPERTY_HEAVY_ID
				];
			}
			//
			var l:int = _attrVec.length;
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
				return HtmlUtils.createHtmlStr(0xffe1aa,cfgDt.tips);
			}
			else
			{
				return "";
			}
		}
		
		/**改变属性值*/
		public function changeValue():void
		{
			//给主属性赋值
			var msg:String=StringConst.HERO_PANEL_58;
			var msg2:String=StringConst.HERO_PANEL_62;
			var mcProperty:McHeroPropertyPanel;
			mcProperty = _skin as McHeroPropertyPanel;
			var format:TextFormat=mcProperty.txtHp.defaultTextFormat;
			
			mcProperty["txtHp"].defaultTextFormat=format;
			mcProperty["txtHp"].setTextFormat(format);
			mcProperty["txtHp"].text=StringUtil.substitute(msg,HeroDataManager.instance["attrHp"],HeroDataManager.instance["attrMaxHp"]);
			
			mcProperty["txtMp"].defaultTextFormat=format;
			mcProperty["txtMp"].setTextFormat(format);
			mcProperty["txtMp"].text=StringUtil.substitute(msg,HeroDataManager.instance["attrMp"],HeroDataManager.instance["attrMaxMp"]);
			
			mcProperty["txtPhscDmg"].defaultTextFormat=format;
			mcProperty["txtPhscDmg"].setTextFormat(format);
			mcProperty["txtPhscDmg"].text=StringUtil.substitute(msg2,HeroDataManager.instance["minPhscDmg"],HeroDataManager.instance["maxPhscDmg"]);
			
			mcProperty["txtPhscDfns"].defaultTextFormat=format;
			mcProperty["txtPhscDfns"].setTextFormat(format);
			mcProperty["txtPhscDfns"].text=StringUtil.substitute(msg2,HeroDataManager.instance["minPhscDfns"],HeroDataManager.instance["maxPhscDfns"]);
			
			mcProperty["txtMgcDmg"].defaultTextFormat=format;
			mcProperty["txtMgcDmg"].setTextFormat(format);
			mcProperty["txtMgcDmg"].text=StringUtil.substitute(msg2,HeroDataManager.instance["minMgcDmg"],HeroDataManager.instance["maxMgcDmg"]);
			
			mcProperty["txtMgcDfns"].defaultTextFormat=format;
			mcProperty["txtMgcDfns"].setTextFormat(format);
			mcProperty["txtMgcDfns"].text=StringUtil.substitute(msg2,HeroDataManager.instance["minPhscDfns"],HeroDataManager.instance["maxPhscDfns"]);
			
			mcProperty["txtTrailDmg"].defaultTextFormat=format;
			mcProperty["txtTrailDmg"].setTextFormat(format);
			mcProperty["txtTrailDmg"].text=StringUtil.substitute(msg2,HeroDataManager.instance["minTrailDmg"],HeroDataManager.instance["maxTrailDmg"]);
			//给特殊属性赋值
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
		
		public function removePanel():void
		{
			(this.parent as HeroEquipTab).removeHeroPropertyPanel();
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
			if(_clickHandler)
			{
				_clickHandler.destroy();
			}
			_clickHandler = null;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			// TODO Auto Generated method stub
			super.addCallBack(rsrLoader);
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			HeroDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			HeroDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}