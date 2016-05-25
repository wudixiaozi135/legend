package com.view.gameWindow.panel.panels.hejiSkill.tabHejiBuff
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.JointHaloCfgData;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.McPanelHejiBuff;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilColorMatrixFilters;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import mx.utils.StringUtil;

	public class TabHejiBuff extends TabBase
	{
		private var _bagCells:Vector.<IconCellEx>;
		private var _buffCells:Vector.<IconCellEx>;
		public var bagCellPanel:Sprite;
		private const TOTAL_CELL_NUM:int=45;
		private var _currentBuffID:int;
		private var _skillCell:IconCellEx;
		public var isAdvance:Boolean=false;
		public var noAdvanceType:int;
		private var _handler:TabHejiBuffHandler;
		private var _mouseHandler:TabHejiBuffMouseHandler;
		public function TabHejiBuff()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			var skin:McPanelHejiBuff = new McPanelHejiBuff();
			_skin = skin;
			addChild(_skin);
			_handler=new TabHejiBuffHandler(this);
		}
		
		override protected function initData():void
		{
			_currentBuffID=0;
			initText();
			initBuffCell();
			initBagCells();
			initSkillCell();
			
			_mouseHandler=new TabHejiBuffMouseHandler(this);
			HejiSkillDataManager.instance.getJointHaloData();
		}
		
		public function setSelectBuff(index:int):void
		{
			if(_currentBuffID==index)return;
			var mcPanel:McPanelHejiBuff=_skin as McPanelHejiBuff;
			mcPanel.mcSelect.x=89+162*_currentBuffID;
			var jointData:JointHaloData=HejiSkillDataManager.instance.buffArr[index];
			if(jointData==null)
			{
				var jointNextCfgData:JointHaloCfgData=ConfigDataManager.instance.jointHaloCfgData(index+1,1);
				Alert.warning(StringUtil.substitute(StringConst.JOINT_PANEL_0029,jointNextCfgData.start_level));
				return;
			}
			_currentBuffID=index;
			updatePanel();
		}
		
		private function initBottom():void
		{
			var mcPanel:McPanelHejiBuff=_skin as McPanelHejiBuff;
			mcPanel.mcSelect.x=89+162*_currentBuffID;
			mcPanel.mcMainBuff.x=68+162*HejiSkillDataManager.instance.mainBuffIndex;
			
			for (var i:int=0;i<3;i++)
			{
				mcPanel[("txtb"+i)].mouseEnabled=false;
				var data:JointHaloData= HejiSkillDataManager.instance.buffArr[i];
				if(data==null)
				{
					mcPanel[("txtb"+i)].text=StringConst.JOINT_PANEL_0021;
					mcPanel[("mc"+i)].filters=UtilColorMatrixFilters.GREY_FILTERS;
					continue;
				}
				var num:int;
				if(data.type==HejiSkillDataManager.MAIN_BUFF)
				{
					num=100;
				}else
				{
					var jointCfgData:JointHaloCfgData=ConfigDataManager.instance.jointHaloCfgData(data.id,data.level);
					num=jointCfgData.vice_halo_add_rate/10;
				}
				mcPanel[("mc"+i)].filters=null;
				mcPanel[("txtb"+i)].text=StringConst.ROLE_PROPERTY_PANEL_0023+"+"+num+"%";
			}
		}
		
		private function initSkillCell():void
		{
			_skillCell=new IconCellEx(_skin,9,330,41,41);
			ToolTipManager.getInstance().attach(_skillCell);
		}
		
		private function initBuffCell():void
		{
			_buffCells=new Vector.<IconCellEx>();
			for(var i:int=0;i<6;i++)
			{
				//312 89
				var x:int=i%2==0?218:533;
				var y:int=int(i/2)*92+85;
				var cell:IconCellEx=new IconCellEx(_skin,x,y,52,52);
				ToolTipManager.getInstance().attach(cell);
				_buffCells.push(cell);
			}
		}
		/**
		 * item type  146 147 148 149为活力，防御，攻击，合击符文
		 * 
		 */
		public function getNullCellIndexByType(itemType:int):int
		{
			switch (itemType)
			{
				case 146:
					if(_buffCells[0].isEmpty())
					{
						return 1;
					}
					if(_buffCells[1].isEmpty())
					{
						return 2;
					}
					break;
				case 147:
					if(_buffCells[2].isEmpty())
					{
						return 3;
					}
					if(_buffCells[3].isEmpty())
					{
						return 4;
					}
					break;
				case 148:
					if(_buffCells[4].isEmpty())
					{
						return 5;
					}
					break;
				case 149:
					if(_buffCells[5].isEmpty())
					{
						return 6;
					}
					break;
			}
			return 0;
		}
		
		private function initText():void
		{
			var mcPanel:McPanelHejiBuff=_skin as McPanelHejiBuff;
			mcPanel.txtBuffName.mouseEnabled=false;
			mcPanel.txtLog.htmlText=HtmlUtils.createHtmlStr(0x53b436,"<u>"+StringConst.JOINT_PANEL_0001+"</u>");
			mcPanel.txtLink.htmlText=HtmlUtils.createHtmlStr(0x53b436,"<u>"+StringConst.JOINT_PANEL_0002+"</u>");
			mcPanel.txt1.text=StringConst.JOINT_PANEL_0003;
			mcPanel.txt2.text=StringConst.JOINT_PANEL_0004;
			mcPanel.txt3.text=StringConst.JOINT_PANEL_0008;
			mcPanel.txt1.mouseEnabled=false;
			mcPanel.txt2.mouseEnabled=false;
			ToolTipManager.getInstance().attachByTipVO(mcPanel.txtLog,ToolTipConst.TEXT_TIP,HtmlUtils.createHtmlStr(0xffffff,StringConst.JOINT_PANEL_0022,12,false,4));
		}
		
		/**初始化背包单元格*/
		private function initBagCells():void
		{
			var jl:int = 9,il:int = 5,i:int,j:int,vector:Vector.<IconCellEx>;
			bagCellPanel=new Sprite();
			bagCellPanel.mouseEnabled=false;
			_skin.addChild(bagCellPanel);
			bagCellPanel.x=652.5;
			bagCellPanel.y=6;
			_bagCells = new Vector.<IconCellEx>();
			for(j=0;j<jl;j++)
			{
				for(i=0;i<il;i++)
				{
					var bagCell:IconCellEx = new IconCellEx(bagCellPanel,46*i,46*j,42,42);
					_bagCells[j*il+i] = bagCell;
				}
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			// TODO Auto Generated method stub
			rsrLoader.addCallBack(_skin.mcMainBuff,function (mc:MovieClip):void
			{
				_skin.mcMainBuff.mouseEnabled=false;
			});
			rsrLoader.addCallBack(_skin.mcSelect,function (mc:MovieClip):void
			{
				_skin.mcSelect.mouseEnabled=false;
			});
			rsrLoader.addCallBack(_skin.mc0,function (mc:MovieClip):void
			{
				var data:JointHaloData= HejiSkillDataManager.instance.buffArr[0];
				if(data==null)
				{
					mc.filters=UtilColorMatrixFilters.GREY_FILTERS;
				}
			});
			rsrLoader.addCallBack(_skin.mc1,function (mc:MovieClip):void
			{
				var data:JointHaloData= HejiSkillDataManager.instance.buffArr[0];
				if(data==null)
				{
					mc.filters=UtilColorMatrixFilters.GREY_FILTERS;
				}
			});
			rsrLoader.addCallBack(_skin.mc2,function (mc:MovieClip):void
			{
				var data:JointHaloData= HejiSkillDataManager.instance.buffArr[0];
				if(data==null)
				{
					mc.filters=UtilColorMatrixFilters.GREY_FILTERS;
				}
			});
			rsrLoader.addCallBack(_skin.btnSub,function (mc:MovieClip):void
			{
				if(isAdvance=false)
				{
					mc.filters=UtilColorMatrixFilters.GREY_FILTERS;
				}else
				{
					mc.filters=null;
				}
				var data:JointHaloData= getCurrentJointHaloData();
				ToolTipManager.getInstance().attachByTipVO(mc,ToolTipConst.JOINT_TIP,data);
			});
			super.addCallBack(rsrLoader);
		}
		
		override public function update(proc:int=0):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_BAG_ITEMS:
					_handler.updateBag(_bagCells);
					break;
				case GameServiceConstants.SM_JOINT_HALO_INFO_LIST:
					updatePanel();
					break;
			}
			super.update(proc);
		}
		
		private function updatePanel():void
		{
			var jointData:JointHaloData=HejiSkillDataManager.instance.buffArr[_currentBuffID];
			if(jointData==null)return;
			var jointCfgData:JointHaloCfgData=ConfigDataManager.instance.jointHaloCfgData(jointData.id,jointData.level);
			updateBuffIcon(jointData,jointCfgData);
			_handler.updatePanel(jointCfgData,jointData,_buffCells,_skillCell);
			initBottom();
			_handler.updateBag(_bagCells);
		}
		
		public function getCurrentJointHaloData():JointHaloData
		{
			return HejiSkillDataManager.instance.buffArr[_currentBuffID];
		}
		
		private function updateBuffIcon(jointData:JointHaloData,jointCfgData:JointHaloCfgData):void
		{
			var mcPanel:McPanelHejiBuff=_skin as McPanelHejiBuff;
			mcPanel.txtBuffName.text=jointCfgData.des+" Lv."+jointData.level;
			if(jointData.type==HejiSkillDataManager.MAIN_BUFF)
			{
				mcPanel.txtBuffAddRate.text="("+StringConst.JOINT_PANEL_0005+" "+StringConst.ROLE_PROPERTY_PANEL_0023+"+100%)";
			}else
			{
				mcPanel.txtBuffAddRate.text="("+StringConst.JOINT_PANEL_0006+" "+StringConst.ROLE_PROPERTY_PANEL_0023+"+"+int(jointCfgData.vice_halo_add_rate/10)+"%)";
			}
			mcPanel.txtOSLink.htmlText=HtmlUtils.createHtmlStr(0x53b436,"<u>"+StringConst.JOINT_PANEL_0007+StringConst.JOINT_PANEL_0005+"</u>");
			mcPanel.mcBuffer.resUrl="hejiSkill/buff"+jointData.id*2+".png";
			loadNewSource(mcPanel.mcBuffer);
		}
		
		override public function destroy():void
		{
			ToolTipManager.getInstance().detach(_skin.txtLog);
			ToolTipManager.getInstance().detach(_skin.btnSub);
			_mouseHandler&&_mouseHandler.destroy();
			_mouseHandler=null;
			_handler&&_handler.destroy();
			_handler=null;
			while(_bagCells&&_bagCells.length>0)
			{
				var cell:IconCellEx= _bagCells.shift();
				cell.parent&&cell.parent.removeChild(cell);
				ToolTipManager.getInstance().detach(cell);
				cell.destroy();
			}
			
			while(_buffCells&&_buffCells.length>0)
			{
				var cell1:IconCellEx= _buffCells.shift();
				cell1.parent&&cell1.parent.removeChild(cell1);
				ToolTipManager.getInstance().detach(cell1);
				cell1.destroy();
			}
			
			if(_skillCell)
			{
				_skillCell.parent&&_skillCell.parent.removeChild(_skillCell);
				ToolTipManager.getInstance().detach(_skillCell);
			}
			_skillCell=null;
			
			if(bagCellPanel)
			{
				bagCellPanel.parent&&bagCellPanel.parent.removeChild(bagCellPanel);
			}
			bagCellPanel=null;
			// TODO Auto Generated method stub
			super.destroy();
		}

		public function get currentBuffID():int
		{
			return _currentBuffID;
		}

		override protected function attach():void
		{
			// TODO Auto Generated method stub
			BagDataManager.instance.attach(this);
			HejiSkillDataManager.instance.attach(this);
			super.attach();
		}
		
		override protected function detach():void
		{
			// TODO Auto Generated method stub
			BagDataManager.instance.detach(this);
			HejiSkillDataManager.instance.detach(this);
			super.detach();
		}
		
	}
}