package com.view.gameWindow.panel.panels.artifact.tabArtifact
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.ArtifactCfgData;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.consts.ConstArtifact;
    import com.model.consts.EffectConst;
    import com.model.consts.JobConst;
    import com.model.consts.SexConst;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.panel.panels.artifact.ArtifactDataManager;
    import com.view.gameWindow.panel.panels.artifact.ArtifactItemSidebar;
    import com.view.gameWindow.panel.panels.artifact.McArtifact;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.task.linkText.LinkText;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.UtilItemParse;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;
    import com.view.gameWindow.util.scrollBar.ScrollBar;
    import com.view.gameWindow.util.tabsSwitch.TabBase;

    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.utils.Dictionary;

    public class TabArtifact extends TabBase
	{
		
		private var _mcArtifact:McArtifact;
		internal var _ArtifactSidebar:ArtifactItemSidebar;
		private var _sideBarScrollBar:ScrollBar;
		private var _sidebarWidth:Number = 188;
		private var _sidebarHeight:Number = 390;
		private var _tabArtifactMouseHandle:TabArtifactMouseHandle;
		private var cellEx:IconCellEx;
		private var cellEx2:IconCellEx;
		private var cellEx3:IconCellEx;
		internal var _linkText:LinkText;
		private var _uieffect:UIEffectLoader;
		
		public function TabArtifact()
		{
			super();
		}
	
		override protected function initSkin():void
		{
			_skin = new McArtifact();
			addChild(_skin);
			_mcArtifact = _skin as McArtifact;
			_ArtifactSidebar = new ArtifactItemSidebar(_sidebarWidth,_sidebarHeight,ConstArtifact.TYPE_ARTIFACT);
			refreshUi();
			_ArtifactSidebar.addEventListener(Event.CHANGE,artifactSidebarChange);
			_mcArtifact.sidebarPos.addChild(_ArtifactSidebar);	
			addSigns();
			setEquipTips();
			_uieffect = new UIEffectLoader(_mcArtifact.fazhen,_mcArtifact.fazhen.width*.5,_mcArtifact.fazhen.height*.5,1,1,EffectConst.RES_MAGIC);
		}
		
		private function setEquipTips():void
		{
			var tipVo:TipVO = new TipVO();
			tipVo.tipType = ToolTipConst.EQUIP_BASE_TIP;
			tipVo.tipData = getTipData;
			ToolTipManager.getInstance().hashTipInfo(_mcArtifact.loader,tipVo);
			ToolTipManager.getInstance().attach(_mcArtifact.loader);
		}
		
		private function getTipData():EquipCfgData
		{
			var equipCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(_ArtifactSidebar._selectedItemCfg.equipid);
			return equipCfg;
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
			rsrLoader.addCallBack(_mcArtifact.mcScrollBar,function(mc:MovieClip):void
			{
				_sideBarScrollBar = new ScrollBar(_ArtifactSidebar,mc,0,_ArtifactSidebar,15);
				_sideBarScrollBar.resetHeight(_sidebarHeight);
			});
			rsrLoader.addCallBack(_mcArtifact.mcStar,function(mc:MovieClip):void
			{
				_mcArtifact.mcStar.mouseEnabled = false;
			});
		}
		
		
		override protected function initData():void
		{
			initText();
			_tabArtifactMouseHandle = new TabArtifactMouseHandle(this);
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.CM_GOD_MAGIC_WEAPON)
			{
				if(_tabArtifactMouseHandle.cfg)
				{
					var  name:String = ConfigDataManager.instance.equipCfgData(_tabArtifactMouseHandle.cfg.equipid).name;
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.ARTIFACT_PANEL_0011.replace("XX",name));
				}
			}
			updateTxtNum();			
		}
		
		private function updateTxtNum():void
		{
			if(_ArtifactSidebar._selectedItemCfg)
			{
				var bagNum:int = BagDataManager.instance.getItemNumById(UtilItemParse.getThingsData(_ArtifactSidebar._selectedItemCfg.item_cost).id);
				var needNum:int = UtilItemParse.getThingsData(_ArtifactSidebar._selectedItemCfg.item_cost).count;
				if(_ArtifactSidebar._selectedItemCfg.equip_cost)
				{
					if(!RoleDataManager.instance.getEquipCellDataById(UtilItemParse.getThingsData(_ArtifactSidebar._selectedItemCfg.equip_cost).id) && !BagDataManager.instance.getBagCellDataByBaseId(UtilItemParse.getThingsData(_ArtifactSidebar._selectedItemCfg.equip_cost).id))
					{
						_mcArtifact.mcContain.ui2.txtNum.htmlText = HtmlUtils.createHtmlStr(0xff0000,"0/1");
					}
					else
					{
						_mcArtifact.mcContain.ui2.txtNum.htmlText = HtmlUtils.createHtmlStr(0x00ff00,"1/1");
					}
					if( bagNum < needNum)
					{
						_mcArtifact.mcContain.ui2.txtNum2.htmlText = HtmlUtils.createHtmlStr(0xff0000,bagNum + "/" + needNum);
					}
					else
					{
						_mcArtifact.mcContain.ui2.txtNum2.htmlText = HtmlUtils.createHtmlStr(0x00ff00,needNum + "/" + needNum);
					}
				}
				else
				{
					if( bagNum < needNum)
					{
						_mcArtifact.mcContain.ui1.txtNum.htmlText = HtmlUtils.createHtmlStr(0xff0000,bagNum + "/" + needNum);
					}
					else
					{
						_mcArtifact.mcContain.ui1.txtNum.htmlText = HtmlUtils.createHtmlStr(0x00ff00,needNum + "/" + needNum);
					}
				}
			}
		}
		
		private function initText():void
		{
			_mcArtifact.txt_00.text = StringConst.ARTIFACT_PANEL_0004;
			_mcArtifact.mcContain.txt_01.text = StringConst.ARTIFACT_PANEL_0005;
			_mcArtifact.mcContain.ui2.txt_04.text = StringConst.ARTIFACT_PANEL_0007;
			_mcArtifact.mcContain.ui1.txt_04.text = StringConst.ARTIFACT_PANEL_0007;
			_mcArtifact.mcContain.btnTxt.text = StringConst.ARTIFACT_PANEL_0008;
			_mcArtifact.mcContain.btnTxt.mouseEnabled = false;
			_mcArtifact.mcContain.ui2.txtNum.mouseEnabled = false;
			_mcArtifact.mcContain.ui2.txtNum2.mouseEnabled = false;
			_mcArtifact.mcContain.ui1.txtNum.mouseEnabled = false;
		}		
		
		/**添加标志点*/
		private function addSigns():void
		{
			var datas:Array = [];
			var index:int = 0;
			
			for(var i:int = 1;i<ConstArtifact.TYPE_TOTAL+1;i++)
			{
				datas.push(addData(ConstArtifact.TYPE_ARTIFACT,i));
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
            var equipCfg:EquipCfgData;
			if(!artifactCfgDatas)
			{
				return re;
			}
			for each(artifactCfgData in artifactCfgDatas)
			{
                equipCfg = ConfigDataManager.instance.equipCfgData(artifactCfgData.equipid);
                if (equipCfg && RoleDataManager.instance.checkReincarnLevel(equipCfg.reincarn, equipCfg.level))
                {
                    if (artifactCfgData.sex == SexConst.TYPE_NO || artifactCfgData.sex == RoleDataManager.instance.sex)
                    {
                        if (artifactCfgData.job == JobConst.TYPE_NO || artifactCfgData.job == RoleDataManager.instance.job)
                        {
                            re.push(artifactCfgData);
                        }
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
				while(_mcArtifact.mcContain.ui1.icon1.numChildren>0)
				{
					_mcArtifact.mcContain.ui1.icon1.removeChildAt(0);
				}
				while(_mcArtifact.mcContain.ui2.icon1.numChildren>0)
				{
					_mcArtifact.mcContain.ui2.icon1.removeChildAt(0);
				}
				while(_mcArtifact.mcContain.ui2.icon2.numChildren>0)
				{
					_mcArtifact.mcContain.ui2.icon2.removeChildAt(0);
				}
				if (cellEx)
				{
					ToolTipManager.getInstance().detach(cellEx);
					cellEx.loadEffect("");
				}
				if (cellEx2)
				{
					ToolTipManager.getInstance().detach(cellEx2);
					cellEx2.loadEffect("");
				}
				if (cellEx3)
				{
					ToolTipManager.getInstance().detach(cellEx3);
					cellEx3.loadEffect("");
				}
				if(data.is_grade == ConstArtifact.TYPE_NOGRADE)
				{
					_mcArtifact.mcContain.visible = false;
				}
				else
				{
					_mcArtifact.mcContain.visible = true;
					if(data.equip_cost == "")
					{
						_mcArtifact.mcContain.ui2.visible = false;
						_mcArtifact.mcContain.ui1.visible = true;
						cellEx = new IconCellEx(_mcArtifact.mcContain.ui1.icon1,0,0,36,36);
						cellEx.loadEffect("");
						if(data.item_cost)
						{
							IconCellEx.setItemByThingsData(cellEx,UtilItemParse.getThingsData(data.item_cost));
						}
						
						cellEx.text = "";
						ToolTipManager.getInstance().attach(cellEx);
						_mcArtifact.mcContain.ui1.coinTxt.text = data.coin_cost;
					}
					else
					{
						_mcArtifact.mcContain.ui1.visible = false;
						_mcArtifact.mcContain.ui2.visible = true;
						cellEx2 = new IconCellEx(_mcArtifact.mcContain.ui2.icon1,0,0,36,36);
						IconCellEx.setItemByThingsData(cellEx2,UtilItemParse.getThingsData(data.equip_cost));
						cellEx2.text = "";
						ToolTipManager.getInstance().attach(cellEx2);
						if(data.item_cost)
						{
							cellEx3 = new IconCellEx(_mcArtifact.mcContain.ui2.icon2,0,0,36,36);
							IconCellEx.setItemByThingsData(cellEx3,UtilItemParse.getThingsData(data.item_cost));
							cellEx3.text = "";
							ToolTipManager.getInstance().attach(cellEx3);
						}
						_mcArtifact.mcContain.ui2.coinTxt.text = data.coin_cost;
					}
				}
				_linkText.init(CfgDataParse.pareseDesToStr(data.desc));
				_mcArtifact.desc.wordWrap = true;
				_mcArtifact.desc.htmlText = _linkText.htmlText;
				updateTxtNum();
			}	
		}
		
		override public function destroy():void
		{
			ToolTipManager.getInstance().detach(cellEx);
			ToolTipManager.getInstance().detach(cellEx2);
			ToolTipManager.getInstance().detach(cellEx3);
			ToolTipManager.getInstance().detach(_mcArtifact.loader);
			cellEx = null;
			cellEx2 = null;
			cellEx3 = null;
			_linkText = null;
			if(_tabArtifactMouseHandle)
			{
				_tabArtifactMouseHandle.destory();
				_tabArtifactMouseHandle = null;
			}
			if(_sideBarScrollBar)
			{
				_sideBarScrollBar.destroy();
				_sideBarScrollBar = null;
			}
			if(_ArtifactSidebar)
			{
				_ArtifactSidebar.destroyPic();
				_ArtifactSidebar.removeEventListener(Event.CHANGE,artifactSidebarChange);
				_ArtifactSidebar = null;
			}
			_mcArtifact = null;
			super.destroy();
		}
		
		override protected function attach():void
		{
			// TODO Auto Generated method stub
			ArtifactDataManager.instance.attach(this);
			BagDataManager.instance.attach(this);
			RoleDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			ArtifactDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			RoleDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}