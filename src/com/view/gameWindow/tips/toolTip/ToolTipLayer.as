package com.view.gameWindow.tips.toolTip
{
	import com.model.consts.ToolTipConst;
	import com.view.gameWindow.tips.toolTip.icon.EquipBaptizeSuiteTip;
	import com.view.gameWindow.tips.toolTip.icon.EquipStrengSuiteTip;
	import com.view.gameWindow.tips.toolTip.icon.HeroReincarnSuiteTip;
	import com.view.gameWindow.tips.toolTip.icon.PositionSuiteTip;
	import com.view.gameWindow.util.Container;
	
	import flash.utils.Dictionary;
	
	/**
	 * tip显示层
	 * @author jhj
	 */
	public class ToolTipLayer extends Container
	{
		/** * tips管理  */		
		private var _tipMap:Dictionary;
		
		private var _currentTip:BaseTip;
		
		public function ToolTipLayer()
		{
			super();
			_tipMap = new Dictionary();
		}
		
		private function addTip(tipType:int):void
		{
			var toolTip:BaseTip;
			
			switch(tipType)
			{
				case ToolTipConst.TEXT_TIP:
					toolTip = new TextTip();
					break;
				case ToolTipConst.EQUIP_BASE_TIP:
					toolTip = new EquipBaseTip(tipType);
					break;
				case ToolTipConst.EQUIP_BASE_TIP_NO_COMPLETE:
					toolTip = new EquipBaseTip(tipType);
					break;
				case ToolTipConst.EQUIP_BASE_TIP_NO_COMPLETE_HERO:
					toolTip = new EquipBaseTip(tipType);
					break
				case ToolTipConst.EQUIP_BASE_TIP_HERO:
					toolTip = new EquipBaseTip(tipType);
					break;
				case ToolTipConst.ITEM_BASE_TIP:
					toolTip = new ItemBaseTip();
					break;
				case ToolTipConst.COMPLETE_EQUIP_BASE_TIP:
					toolTip = new EquipBaseTip(tipType);
					break;
				case ToolTipConst.COMPLETE_HERO_EQUIP_BASE_TIP:
					toolTip = new EquipBaseTip(tipType);
					break;
				case ToolTipConst.SHOP_EQUIP_TIP:
					toolTip = new ShopEquipTip(tipType);
				    break;
				case ToolTipConst.FASHION_TIP:
					toolTip = new FashionTip(tipType);
		            break;
				case ToolTipConst.FORGE_PROGRESS_TIP:
					toolTip = new ForgeProgressTip();
					break;
				case ToolTipConst.SHOP_ITEM_TIP:
					toolTip = new ShopItemTip();
					break;
				case ToolTipConst.SKILL_TIP:
					toolTip = new SkillToolTip();
					break;
				case ToolTipConst.BOSS_TIP:
					toolTip = new BossToolTip();
					break;
				case ToolTipConst.EQUIP_UPGRADE_TIP:
					toolTip=new EquipUpgradeTip();
					break;
				case ToolTipConst.LASTING_TIP:
					toolTip=new LastingTip();
					break;
				case ToolTipConst.JOINT_TIP:
					toolTip=new BuffUpgradeTip();
					break;
				case ToolTipConst.HERO_UGRADE_TIP:
					toolTip=new HeroUpgradeTip();
					break;
				case ToolTipConst.EQUIP_STRENG_SUITE_TIP:
					toolTip=new EquipStrengSuiteTip();
					break;
				case ToolTipConst.EQUIP_BAPTIZE_SUITE_TIP:
					toolTip=new EquipBaptizeSuiteTip();
					break;
				case ToolTipConst.EQUIP_REINCAIN_SUITE_TIP:
					toolTip=new HeroReincarnSuiteTip();
					break;
				case ToolTipConst.POSITION_SUITE_TIP:
					toolTip=new PositionSuiteTip();
					break;
				default:
					break;
			}
			
			_tipMap[tipType] = toolTip;
		}
		
		public function removeTip(tipType:int):void
		{
			if(_tipMap[tipType])
			{
				var toolTip:BaseTip=_tipMap[tipType];
				
				if(toolTip)
				{
					toolTip.removeFromDisplayList();
					toolTip.dispose();
					toolTip.target = null;
					delete _tipMap[tipType];
				}
			}
		}
		
		public function removeAllTip():void
		{
			for (var tipType:String in _tipMap)
			{
				var tip:BaseTip = _tipMap[tipType];
				tip.removeFromDisplayList();
				tip.dispose();
				tip.target = null;
				delete _tipMap[tipType];
			}
		}
		
		public function getToolTip(tipeType:int):BaseTip
		{
			if(!_tipMap[tipeType])
			{
				addTip(tipeType);
			}
			return _tipMap[tipeType];
		}
	}
}