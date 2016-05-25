package com.view.gameWindow.panel.panels.hejiSkill.replace
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.SlotType;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.HejiSkillDataManager;
	import com.view.gameWindow.panel.panels.hejiSkill.McPanelRunes;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	public class ReplacePanel extends PanelBase
	{
		private var _panelHandler:ReplacePanelHandler;
		private var _mouseHandler:RePlaceMouseHandler;
		private var _replaceIcon:IconCellEx;
		
		public function ReplacePanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_skin=new McPanelRunes();
			addChild(_skin);
			setTitleBar(_skin.mcTitleBar);
			
			_replaceIcon=new IconCellEx(_skin,133,164,64,64);
			ToolTipManager.getInstance().attach(_replaceIcon);
			_mouseHandler=new RePlaceMouseHandler(this);
			_panelHandler=new ReplacePanelHandler(this);	
			initText();
		}
		
		private function initText():void
		{
			_skin.txtTitle.text=StringConst.REPLACE_PANEL_0001;
			_skin.txt1.text=StringConst.REPLACE_PANEL_0002;
			_skin.txt2.text=StringConst.REPLACE_PANEL_0002;
			_skin.txt3.text=StringConst.REPLACE_PANEL_0003;
			_skin.txt5.text=StringConst.REPLACE_PANEL_0004;
			_skin.txt6.text=StringConst.REPLACE_PANEL_0006;
			_skin.txt5.mouseEnabled=false;
		}
		
		override protected function initData():void
		{
			BagDataManager.instance.attach(this);
			HejiSkillDataManager.instance.attach(this);
			_panelHandler.updateBag();
		}
		
		override public function update(proc:int=0):void
		{
			switch(proc)
			{
				case GameServiceConstants.SM_BAG_ITEMS:
					updateBag();
					break;
				case GameServiceConstants.SM_RUNE_TRANSFORM:
					runeTransform(HejiSkillDataManager.instance.replaceID);
					break;
			}
			super.update(proc);
		}
		
		public function runeTransform(replaceID:int=0):void
		{
			if(replaceID==0)
			{
				_replaceIcon.setNull();
			}else
			{
				var dt:ThingsData=new ThingsData();
				dt.id=replaceID;
				dt.type=SlotType.IT_ITEM;
				IconCellEx.setItemByThingsData(_replaceIcon,dt);
			}
		}
		
		public function updateBag():void
		{
			_panelHandler.updateBag();
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			// TODO Auto Generated method stub
			rsrLoader.addCallBack(_skin.mcScrollBar,function (mc:MovieClip):void
			{
				_panelHandler.initScrollBar();
			});
			super.addCallBack(rsrLoader);
		}
		
		override public function destroy():void
		{
			// TODO Auto Generated method stub
			ToolTipManager.getInstance().detach(_replaceIcon);
			if(_replaceIcon)
			{
				_replaceIcon.destroy();
				_replaceIcon.parent&&_replaceIcon.parent.removeChild(_replaceIcon);
			}
			_replaceIcon=null;
			HejiSkillDataManager.instance.cellID1=0;
			HejiSkillDataManager.instance.cellID2=0;
			HejiSkillDataManager.instance.replaceID=0;
			_mouseHandler&&_mouseHandler.destroy();
			_mouseHandler=null;
			BagDataManager.instance.detach(this);
			HejiSkillDataManager.instance.detach(this);
			_panelHandler&&_panelHandler.destroy();
			_panelHandler=null;
			super.destroy();
		}
		
		override public function setPostion():void
		{
			isMount(true);
		}
		
		override public function getPanelRect():Rectangle
		{
			// TODO Auto Generated method stub
			return new Rectangle(0,0,546,340);
		}
		
	}
}