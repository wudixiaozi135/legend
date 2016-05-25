package com.view.gameWindow.panel.panels.onhook.states.drug
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.gameWindow.mem.MemEquipData;
	import com.pattern.state.IIntention;
	import com.pattern.state.IState;
	import com.view.gameWindow.mainUi.subuis.lasting.LastingDataMananger;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.onhook.AutoDataManager;
	import com.view.gameWindow.panel.panels.onhook.states.common.AxFuncs;
	import com.view.gameWindow.panel.panels.onhook.states.common.CDState;
	import com.view.gameWindow.panel.panels.onhook.states.common.ConfigAuto;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
	
	
	/**
	 * @author wqhk
	 * 2014-11-21
	 */
	public class CheckEquipDur implements IState
	{
		public function CheckEquipDur()
		{
		}
		
		public function next(i:IIntention=null):IState
		{
			var repairPercent:Number = AutoDataManager.instance.repairOilPercent/100;
			var isRepaire:Boolean = AutoDataManager.instance.isRepairOil;
			if(isRepaire && repairPercent != 0 && repairPercent != 1)
			{
				if(!BagDataManager.instance.getItemById(ConfigAuto.REPAIR_OIL_ID))
				{
					return this;
				}
				
				var data:Vector.<EquipData> = RoleDataManager.instance.equipDatas;
				
				for each(var equip:EquipData in data)
				{
					var mem:MemEquipData = equip.memEquipData;
					
					if(mem)
					{
						var cfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(mem.baseId);
						
						if(cfg)
						{
							var percent:Number = mem.duralibility/cfg.durability;
						
							if(percent < repairPercent)
							{
								
								var needReset:Boolean = false;
								if(LastingDataMananger.getInstance().lasting == false)
								{
									LastingDataMananger.getInstance().lasting = true;
									needReset = true;
								}
								
								if(AxFuncs.useBagItem(ConfigAuto.REPAIR_OIL_ID,1))
								{
									trace("使用了战神油（好恶心的名字……）");
									
									if(needReset)
									{
										LastingDataMananger.getInstance().lasting = true;
									}
									return new CDState(60,this);
								}
								
								if(needReset)
								{
									LastingDataMananger.getInstance().lasting = true;
								}
							}
						}
					}
				}
			}
			
			return this;
		}
	}
}