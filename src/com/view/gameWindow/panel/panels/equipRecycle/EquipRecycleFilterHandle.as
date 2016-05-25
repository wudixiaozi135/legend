package com.view.gameWindow.panel.panels.equipRecycle
{
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.DropDownListWithLoad;
	import com.view.gameWindow.panel.panels.McEquipRecycle;

	import flash.display.MovieClip;
	import flash.events.Event;

	public class EquipRecycleFilterHandle
	{
		private var _panel:PanelEquipRecycle;
		private var _skin:McEquipRecycle;
		private var _soldierFilterDropDown:DropDownListWithLoad;
		private var _taoistFilterDropDown:DropDownListWithLoad;
		private var _wizardFilterDropDown:DropDownListWithLoad;
		
		public var  soldierFilterStr:Array = ['无','40级以下','50级以下','60级以下','65级以下','70级以下','75级以下','80级以下','85级以下','90级以下','95级以下'];
		public var  filterData:Array = [0,40,50,60,65,70,75,80,85,90,95];
		public var  wizardFilterStr:Array =  ['无','40级以下','50级以下','60级以下','65级以下','70级以下','75级以下','80级以下','85级以下','90级以下','95级以下'];
		public var  taoistFilterStr:Array =  ['无','40级以下','50级以下','60级以下','65级以下','70级以下','75级以下','80级以下','85级以下','90级以下','95级以下'];

		public function EquipRecycleFilterHandle(panel:PanelEquipRecycle)
		{
			_panel = panel;
			_skin = panel.skin as McEquipRecycle;
			 
		}
		
		public function init(rsrLoader:RsrLoader):void
		{
			_soldierFilterDropDown= new DropDownListWithLoad(soldierFilterStr,_skin.soldierTxt,_skin.soldierTxt.width+_skin.soldierBtn1.width,rsrLoader,_skin,"soldierBtn0","soldierBtn1");
			_taoistFilterDropDown= new DropDownListWithLoad(taoistFilterStr,_skin.taoistTxt,_skin.taoistTxt.width+_skin.taoistBtn1.width,rsrLoader,_skin,"taoistBtn0","taoistBtn1");
			_wizardFilterDropDown= new DropDownListWithLoad(wizardFilterStr,_skin.wizardTxt,_skin.wizardTxt.width+_skin.wizardBtn1.width,rsrLoader,_skin,"wizardBtn0","wizardBtn1");
			
			_soldierFilterDropDown.selectedIndex = 0;
			_taoistFilterDropDown.selectedIndex = 0;
			_wizardFilterDropDown.selectedIndex = 0;
	
			_soldierFilterDropDown.addEventListener(Event.CHANGE,dropDownChangeHandler);
			_taoistFilterDropDown.addEventListener(Event.CHANGE,dropDownChangeHandler);
			_wizardFilterDropDown.addEventListener(Event.CHANGE,dropDownChangeHandler);
			
			rsrLoader.addCallBack(_skin.soldierBtn,function (mc:MovieClip):void
			{
				mc.addEventListener(Event.SELECT,handleEvent);
				mc.selected = true;
			}
			);
			rsrLoader.addCallBack(_skin.wizardBtn,function (mc:MovieClip):void
			{
				mc.addEventListener(Event.SELECT,handleEvent);
				mc.selected = true;
			}
			);
			rsrLoader.addCallBack(_skin.taoistBtn,function (mc:MovieClip):void
			{
				mc.addEventListener(Event.SELECT,handleEvent);
				mc.selected = true;
			}
			);
			rsrLoader.addCallBack(_skin.noRoleBtn,function (mc:MovieClip):void
			{
				mc.addEventListener(Event.SELECT,handleEvent);
				mc.selected = true;
			}
			);
		}
		public function handleEvent(e:Event):void
		{
			var flag:int;
			switch(e.target)
			{
				case _skin.soldierBtn:
				{
					 
					flag = EquipRecycleDataManager.instance.selcetOption[0].flag;
					EquipRecycleDataManager.instance.selcetOption[0].flag = flag == 1 ? 0:1;
					break;
				}	
				case _skin.wizardBtn:
				{
					flag = EquipRecycleDataManager.instance.selcetOption[1].flag;
					EquipRecycleDataManager.instance.selcetOption[1].flag = flag == 1 ? 0:1;
				 
					break;
				}	
				case _skin.taoistBtn:
				{

					flag = EquipRecycleDataManager.instance.selcetOption[2].flag;
					EquipRecycleDataManager.instance.selcetOption[2].flag = flag == 1 ? 0:1;
					 
					break;
				}	
				case _skin.noRoleBtn:
				{
					flag = EquipRecycleDataManager.instance.selcetOption[3].flag;
					EquipRecycleDataManager.instance.selcetOption[3].flag = flag == 1 ? 0:1;
					break;
				}
			}
			
			 
			/*EquipRecycleDataManager.instance.getEecyaleEquipDatas();
			EquipRecycleDataManager.instance.filterEecyaleEquipDatas();*/
			_panel.viewhandle.refresh();
		}
		
		private function dropDownChangeHandler(e:Event):void
		{
			var dp:DropDownListWithLoad = e.currentTarget as DropDownListWithLoad;
			var index:int = dp.selectedIndex;
			if(index < 0)
			{
				return;
			}
			switch(dp)
			{
				case _soldierFilterDropDown:
					EquipRecycleDataManager.instance.selcetOption[0].lv = filterData[index];
					break;
				case _wizardFilterDropDown:
					EquipRecycleDataManager.instance.selcetOption[1].lv = filterData[index];
					break;
				case _taoistFilterDropDown:
					EquipRecycleDataManager.instance.selcetOption[2].lv = filterData[index];
					break;
			}
			/*EquipRecycleDataManager.instance.getEecyaleEquipDatas();
			EquipRecycleDataManager.instance.filterEecyaleEquipDatas();*/
			_panel.viewhandle.refresh();
			 
		}
		
		internal function destroy():void
		{
			_soldierFilterDropDown.removeEventListener(Event.CHANGE,dropDownChangeHandler);
			_taoistFilterDropDown.removeEventListener(Event.CHANGE,dropDownChangeHandler);
			_wizardFilterDropDown.removeEventListener(Event.CHANGE,dropDownChangeHandler);
			_soldierFilterDropDown.destroy();
			_taoistFilterDropDown.destroy();
			_wizardFilterDropDown.destroy();
			
			_soldierFilterDropDown = null;
			_taoistFilterDropDown = null;
			_wizardFilterDropDown = null;
			
			soldierFilterStr.length = 0;
			filterData.length = 0;
			wizardFilterStr.length = 0;
			taoistFilterStr.length = 0;
			
			soldierFilterStr= null;
			filterData= null;
			wizardFilterStr= null;
			taoistFilterStr= null;
		}
	}
}