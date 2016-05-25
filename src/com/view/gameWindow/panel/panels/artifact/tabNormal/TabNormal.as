package com.view.gameWindow.panel.panels.artifact.tabNormal
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.ArtifactCfgData;
	import com.model.configData.cfgdata.EquipCfgData;
	import com.model.consts.ConstArtifact;
	import com.model.consts.JobConst;
	import com.model.consts.SexConst;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.IPanelTab;
	import com.view.gameWindow.panel.panels.artifact.ArtifactDataManager;
	import com.view.gameWindow.panel.panels.artifact.ArtifactItemSidebar;
	import com.view.gameWindow.panel.panels.artifact.McNormal;
	import com.view.gameWindow.panel.panels.guideSystem.UICenter;
	import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
	import com.view.gameWindow.panel.panels.task.linkText.LinkText;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.propertyParse.CfgDataParse;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	import com.view.gameWindow.util.tabsSwitch.TabBase;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.utils.Dictionary;

	public class TabNormal extends TabBase
	{ 
		private var _mcNormal:McNormal;
		private var _ArtifactSidebar:ArtifactItemSidebar;
		private var _sideBarScrollBar:ScrollBar;
		private var _sidebarWidth:Number = 188;
		private var _sidebarHeight:Number = 390;
		private var _linkText:LinkText;
		private var cellEx:IconCellEx;
		private var _uiCenter:UICenter;
		
		public function TabNormal()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_skin = new McNormal();
			addChild(_skin);
			_mcNormal = _skin as McNormal;
			
			_ArtifactSidebar = new ArtifactItemSidebar(_sidebarWidth,_sidebarHeight,ConstArtifact.TYPE_NORMAL);
			refreshUi();
			_ArtifactSidebar.addEventListener(Event.CHANGE,artifactSidebarChange);
			_mcNormal.sidebarPos.addChild(_ArtifactSidebar);
			addSigns();
			_uiCenter = new UICenter();
			_mcNormal.txt.text = StringConst.ARTIFACT_PANEL_0004;
			_mcNormal.desc.addEventListener(TextEvent.LINK,linkHandle);
		}
		
		protected function linkHandle(event:TextEvent):void
		{
			var num:int = _linkText.getItemCount();
			var name:String;
			var tabIndex:int;
			for(var i:int = 1;i<num+1;i++)
			{
				if(event.text == i.toString())
				{
					name = UICenter.getUINameFromMenu(_linkText.getItemById(i).panelId.toString());
					_uiCenter.openUI(name);
					tabIndex = _linkText.getItemById(i).panelPage;
					if(tabIndex>=0)
					{
						var tab:IPanelTab = UICenter.getUI(name) as IPanelTab;
						if(tab)
						{
							tab.setTabIndex(tabIndex);
						}
					}
				}
			}
		}
		
		private function artifactSidebarChange(e:Event):void
		{
			if(_sideBarScrollBar)
			{
				_sideBarScrollBar.resetScroll();
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_mcNormal.mcScrollBar,function(mc:MovieClip):void
			{
				_sideBarScrollBar = new ScrollBar(_ArtifactSidebar,mc,0,_ArtifactSidebar,15);
				_sideBarScrollBar.resetHeight(_sidebarHeight);
			});
		}
		
		/**添加标志点*/
		private function addSigns():void
		{
			var datas:Array = [];
			var index:int = 0;
			
			for(var i:int = 1;i<ConstArtifact.TYPE_TOTAL+1;i++)
			{
				datas.push(addData(ConstArtifact.TYPE_NORMAL,i));
			}
			if(_ArtifactSidebar)
			{
				_ArtifactSidebar.setContent(datas);
				for(var j:int = 0;j<datas.length;j++)
				{
					if(datas[j].length)
					{
						_ArtifactSidebar.setData(datas[j],index);
						index++;
					}
				}
				_ArtifactSidebar.updatePos();
			}
		}
		
		
		private function addData(type:int,part:int):Array
		{
			var artifactCfgDatas:Dictionary = ConfigDataManager.instance.artifactCfgDatas(type,part);
			var artifactCfgData:ArtifactCfgData;
			var re:Array = [];
			if(!artifactCfgDatas)
			{
				return re;
			}
			var artifactArr:Array = [];
			for each(artifactCfgData in artifactCfgDatas)
			{
				if(artifactCfgData.sex == SexConst.TYPE_NO || artifactCfgData.sex == RoleDataManager.instance.sex)
				{
					if(artifactCfgData.job == JobConst.TYPE_NO || artifactCfgData.job == RoleDataManager.instance.job)
					{
						artifactArr.push(artifactCfgData);
					}
				}
			}
			artifactArr.sortOn("equipid", Array.NUMERIC);//带顺序的所有符合职业的数据
			//根据服务器传来的拥有过的装备id来过滤
			var serverDatas:Vector.<int> = ArtifactDataManager.instance.ownDatas;
			var parts:Vector.<int> = ArtifactDataManager.instance.ownDataParts;

			var equipCfg:EquipCfgData;
			var bodyEquipCfg:EquipCfgData;
			var equipid:int, part:int;
			var bool:Boolean = false;
			for (var i:int = 0, len:int = parts.length; i < len; i++)
			{
				equipid = serverDatas[i];
				part = parts[i];

				for (var j:int = 0, len1:int = artifactArr.length; j < len1; j++)
				{
					artifactCfgData = artifactArr[j];
					if (artifactCfgData.part != part) continue;

					if (equipid <= 0)
					{
						re.push(artifactCfgData);
						break;
					} else
					{
						equipCfg = ConfigDataManager.instance.equipCfgData(artifactCfgData.equipid);
						bodyEquipCfg = ConfigDataManager.instance.equipCfgData(equipid);

						if (equipCfg.id != bodyEquipCfg.id)
						{
							bool = bodyEquipCfg.reincarn > equipCfg.reincarn || (bodyEquipCfg.reincarn == equipCfg.reincarn && bodyEquipCfg.level >= equipCfg.level) as Boolean;
							if (!bool)
							{//找到比曾经拥有的装备的下一级为止
								re.push(artifactCfgData);
								break;
							}
						}
						re.push(artifactCfgData);
					}
				}
			}
			return re;
		}


		/**
		 *通过列表操作刷新UI 
		 * 
		 */		
		private function refreshUi():void
		{
			_ArtifactSidebar._fun = function(data:ArtifactCfgData):void
			{
				_linkText = new LinkText();
				while(_mcNormal.mcIcon.numChildren>0)
				{
					_mcNormal.mcIcon.removeChildAt(0);
				}
				ToolTipManager.getInstance().detach(cellEx);
				cellEx = new IconCellEx(_mcNormal.mcIcon,0,0,60,60);
				cellEx.url = ResourcePathConstants.IMAGE_ICON_EQUIP_FOLDER_LOAD + ConfigDataManager.instance.equipCfgData(data.equipid).icon + ResourcePathConstants.POSTFIX_PNG;
				cellEx.setTipType(SlotType.IT_EQUIP);
				cellEx.setTipData(ConfigDataManager.instance.equipCfgData(data.equipid));
				cellEx.text = "";
				ToolTipManager.getInstance().attach(cellEx);
				_linkText.init(CfgDataParse.pareseDesToStr(data.desc));
				_mcNormal.desc.wordWrap = true;
				_mcNormal.desc.htmlText = _linkText.htmlText;
			}	
		}
		
		override public function destroy():void
		{

			ToolTipManager.getInstance().detach(cellEx);
			cellEx = null;
			_linkText = null;
			_uiCenter = null;
			if(_sideBarScrollBar)
			{
				_sideBarScrollBar.destroy();
				_sideBarScrollBar = null;
			}
			if(_ArtifactSidebar)
			{
				_ArtifactSidebar.removeEventListener(Event.CHANGE,artifactSidebarChange);
				_ArtifactSidebar = null;
			}
			_mcNormal.desc.removeEventListener(TextEvent.LINK,linkHandle);
			_mcNormal = null;
			super.destroy();
		}
	}
}