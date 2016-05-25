package com.view.gameWindow.panel.panels.school.complex.storage
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.configData.cfgdata.EquipRecycleCfgData;
	import com.model.consts.SlotType;
	import com.model.gameWindow.mem.MemEquipData;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.school.McStorage;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.util.PageListData;

	public class SchoolStorageHandler
	{

		private var _panel:SchoolStoragePanel;
		private var _skin:McStorage;
		private var bagCellDatas:Vector.<BagData>;
		
		public function SchoolStorageHandler(panel:SchoolStoragePanel)
		{
			this._panel = panel;
			_skin=panel.skin as McStorage;
			bagCellDatas = BagDataManager.instance.bagCellDatas;
		}
		
		public function updatePanel():void
		{
			_skin.txtv2.text=SchoolElseDataManager.getInstance().schoolInfoData.contribute+"";
		}
		
		public function destroy():void
		{
			
		}
		
		public function updateBags():void
		{
			var len:uint = bagCellDatas.length;
			var index:int=0;
			bagCellDatas = BagDataManager.instance.bagCellDatas;
			SchoolElseDataManager.getInstance().bagDatas.length=0;
			for(var i:int=0;i<len;i++)
			{
				if(bagCellDatas[i]&&bagCellDatas[i].type==SlotType.IT_EQUIP&&bagCellDatas[i].bind==0)
				{
					if(index>42)
						return ;
					var mem:MemEquipData= bagCellDatas[i].memEquipData;
					if(mem==null)
					{
						continue;
					}
					var equipCfgData:EquipCfgData = mem.equipCfgData;
					var equipRecycleCfgData:EquipRecycleCfgData = ConfigDataManager.instance.equipRecycleCfgData(equipCfgData.type,equipCfgData.quality,equipCfgData.level);
					if(equipRecycleCfgData==null||equipRecycleCfgData.is_operation==0||equipRecycleCfgData.is_operation==1)continue;
					_panel.bagCells[index].refreshData(bagCellDatas[i]);
					SchoolElseDataManager.getInstance().bagDatas[index]=bagCellDatas[i];
					index++;
				}
			}
			while(index<42)
			{
				_panel.bagCells[index].setNull();
				index++;
			}
		}
		
		
		
		public function updateSchoolBags():void
		{
			checkCondition();
			
			var schoolBagListPage:PageListData = SchoolElseDataManager.getInstance().schoolBagListPage;
			_skin.txtPage.text=schoolBagListPage.curPage+"/"+schoolBagListPage.totalPage;
			var currentSchoolBagData:Array = schoolBagListPage.getCurrentPageData();
			var len:uint =currentSchoolBagData.length;
			for(var i:int=0;i<len;i++)
			{
				var bagData:BagData=currentSchoolBagData[i] as BagData;
				if(bagData==null)
				{
					_panel.schoolBagCells[i].setNull();
					continue;
				}
				_panel.schoolBagCells[i].refreshData(bagData);
			}
			while(i<36)
			{
				_panel.schoolBagCells[i].setNull();
				i++;
			}
		}
		
		private function checkCondition():void
		{
			var schoolBagList:Array = SchoolElseDataManager.getInstance().schoolBagList;
			if(_skin.singleBtn1.selected||_skin.singleBtn2.selected)
			{
				var contribute:int = SchoolElseDataManager.getInstance().schoolInfoData.contribute;
				var job:int = RoleDataManager.instance.job;
				var newArr:Array=[];
				for(var k:int=0;k<schoolBagList.length;k++)
				{
					var bagData:BagData= schoolBagList[k] as BagData;
					if(bagData==null||bagData.memEquipData==null)continue;
					var equipCfgData:EquipCfgData = bagData.memEquipData.equipCfgData;
					if(_skin.singleBtn1.selected)
					{
						var equipRecycleCfgData:EquipRecycleCfgData = ConfigDataManager.instance.equipRecycleCfgData(equipCfgData.type,equipCfgData.quality,equipCfgData.level);
						if(equipRecycleCfgData.family_contribute>contribute)
						{
							continue;
						}
					}
					if(_skin.singleBtn2.selected)
					{
						if(equipCfgData.job!=0&&equipCfgData.job!=job)
						{
							continue;
						}
					}
					newArr.push(bagData);
				}
				SchoolElseDataManager.getInstance().schoolBagListPage.changeList(newArr);
			}else
			{
				SchoolElseDataManager.getInstance().schoolBagListPage.changeList(schoolBagList);
			}
		}
	}
}