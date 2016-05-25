package com.view.gameWindow.panel.panels.vip.vipPrivilege
{
	import com.model.configData.cfgdata.VipCfgData;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.vip.VipDataManager;
	import com.view.gameWindow.util.NumUtil;
	import com.view.gameWindow.util.scrollBar.PageScrollBar;
	
	import flash.display.MovieClip;
	
	import mx.utils.StringUtil;

	internal class TabVipPrivilegeViewHandle
	{
		private var _tab:TabVipPrivilege;
		private var _mc:McVipPrivilege;
		private var _pageScrollBar:PageScrollBar;
		internal var items:Vector.<McPrivilegeItem>;
		
		public function TabVipPrivilegeViewHandle(tab:TabVipPrivilege)
		{
			_tab = tab;
			_mc = _tab.skin as McVipPrivilege;
			init();
		}
		
		private function init():void
		{
			items = new Vector.<McPrivilegeItem>(VipDataManager.TOTAL_PRIVILEGES,true);
			var i:int,l:int = VipDataManager.TOTAL_PRIVILEGES;
			for(i=0;i<l;i++)
			{
				var item:McPrivilegeItem = new McPrivilegeItem();
				item.y = i*24;
				_mc.mcLayer.addChild(item);
				items[i] = item;
			}
			refresh();
		}
		
		internal function addScrollBar(mc:MovieClip):void
		{
			var datas:Vector.<PrivilegeData> = VipDataManager.instance.getPrivilegeData();
			var l:int = VipDataManager.TOTAL_PRIVILEGES;
			var totalPage:int = datas.length ? int((datas.length+l-1)/l) : 1;
			_pageScrollBar = new PageScrollBar(mc,_mc.mcLayer.height,refresh,totalPage);
		}
		
		internal function refresh():void
		{
			var datas:Vector.<PrivilegeData> = VipDataManager.instance.getPrivilegeData();
			var page:int = _pageScrollBar ? _pageScrollBar.page : 1,index:int;
			var i:int,l:int = VipDataManager.TOTAL_PRIVILEGES;
			var j:int,jl:int = VipDataManager.MAX_LV;
			for(i=0;i<l;i++)
			{
				var item:McPrivilegeItem = items[i];
				index = (page-1)*l+i;
				if(index < datas.length)
				{
					if(datas[index]==null)
					{
						continue;
					}
					
					item.visible = true;
					item.txtName.text = datas[index].name;
					for(j=1;j<=jl;j++)
					{
						var cell:McPrivilegeCell = item["mcVip"+j] as McPrivilegeCell;
						var value:int = datas[index].privileges[j];
						cell.txt.visible = false;
						cell.mc.visible = false;
						switch (index)
						{
							case VipCfgData.PRIVILEGE_9:
							case VipCfgData.PRIVILEGE_12:
							case VipCfgData.PRIVILEGE_19:
							case VipCfgData.PRIVILEGE_20:
								cell.txt.visible = true;
								cell.txt.text = "+"+(value)+"%";
								break;
							case VipCfgData.PRIVILEGE_16:
							case VipCfgData.PRIVILEGE_17:
								cell.txt.visible = true;
								cell.txt.text = (value)+StringConst.VIP_PANEL_0034;
								break;
							case VipCfgData.PRIVILEGE_2:
							case VipCfgData.PRIVILEGE_4:
							case VipCfgData.PRIVILEGE_6:
//							case VipCfgData.PRIVILEGE_7:
							case VipCfgData.PRIVILEGE_10:
								cell.mc.visible = true;
								cell.mc.gotoAndStop(value+1);
								break;
							case VipCfgData.PRIVILEGE_1:
							case VipCfgData.PRIVILEGE_13:
							case VipCfgData.PRIVILEGE_14:
							case VipCfgData.PRIVILEGE_15:
							case VipCfgData.PRIVILEGE_18:
//							case VipCfgData.PRIVILEGE_21:
								cell.txt.visible = true;
								cell.txt.text = (value)+StringConst.VIP_PANEL_0035;
								break;
							case VipCfgData.PRIVILEGE_11:
								cell.txt.visible = true;
								cell.txt.text = "+"+int(value/10)+"%";
								break;
							case VipCfgData.PRIVILEGE_5:
								cell.txt.visible = true;
								cell.txt.text = StringUtil.substitute(StringConst.VIP_PANEL_0036,NumUtil.getNUM(value-4));
								break;
//							case VipCfgData.PRIVILEGE_3:
//							cell.txt.visible = true;
//							cell.txt.text = (value)+StringConst.VIP_PANEL_0037;
//							break;
						}
					}
				}
				else
				{
					item.visible = false;
				}
			}
		}
		
		internal function destroy():void
		{
			if(_pageScrollBar)
			{
				_pageScrollBar.destroy();
				_pageScrollBar = null;
			}
			items = null;
			_mc = null;
			_tab = null;
		}
	}
}