package com.view.gameWindow.panel.panels.school.simpleness.create
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.FamilyCfgData;
	import com.model.configData.cfgdata.ItemCfgData;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.cell.IconCellEx;
	
	import mx.utils.StringUtil;
	import com.view.gameWindow.panel.panels.school.create.MCcreateSchool;

	public class SchoolCHandler
	{

		private var _panel:SchoolCPanel;
		private var _skin:MCcreateSchool;
		private var _itemIcon:IconCellEx;
		public function SchoolCHandler(panel:SchoolCPanel)
		{
			this._panel = panel;
			_skin=panel.skin as MCcreateSchool;
			initText();
		}
		
		private function initText():void
		{
			var familyCfg:FamilyCfgData=SchoolDataManager.getInstance().getSchoolCreateCfg();
			var itemCfg:ItemCfgData=ConfigDataManager.instance.itemCfgData(familyCfg.item_id);
			_skin.txt2.htmlText=HtmlUtils.createHtmlStr(0xd4a460,StringUtil.substitute(StringConst.SCHOOL_PANEL_0005,"<font color='#006699'>"+itemCfg.name+"</font>"));
			_itemIcon=new IconCellEx(_skin,499,175,42,42);
			IconCellEx.setItem(_itemIcon,SlotType.IT_ITEM,itemCfg.id,1,true);
			ToolTipManager.getInstance().attach(_itemIcon);
			var itemCount:int=BagDataManager.instance.getItemNumById(familyCfg.item_id);
			var color:int=0x00ff00;
			if(itemCount<familyCfg.item_num)color=0xff0000;
			_itemIcon.htmlText=HtmlUtils.createHtmlStr(color,itemCount+"/"+familyCfg.item_num);
			_skin.txt4.htmlText=HtmlUtils.createHtmlStr(0xd4a460,StringUtil.substitute(StringConst.SCHOOL_PANEL_0007,familyCfg.creat_level));
		}
		
		public function updateNum():void
		{
			var familyCfg:FamilyCfgData=SchoolDataManager.getInstance().getSchoolCreateCfg();
			var itemCount:int=BagDataManager.instance.getItemNumById(familyCfg.item_id);
			var color:int=0x00ff00;
			if(itemCount<familyCfg.item_num)color=0xff0000;
			_itemIcon.htmlText=HtmlUtils.createHtmlStr(color,itemCount+"/"+familyCfg.item_num);
		}
		
		public function destroy():void
		{
			
			if(_itemIcon)
			{
				_itemIcon.parent&&_itemIcon.parent.removeChild(_itemIcon);
				_itemIcon.destroy();
			}
			_itemIcon=null;
			// TODO Auto Generated method stub
		}
	}
}