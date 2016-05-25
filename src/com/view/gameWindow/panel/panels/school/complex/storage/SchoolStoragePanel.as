package com.view.gameWindow.panel.panels.school.complex.storage
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.ConstStorage;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.bag.cell.BagCell;
	import com.view.gameWindow.panel.panels.school.McStorage;
	import com.view.gameWindow.panel.panels.school.complex.SchoolElseDataManager;
	import com.view.gameWindow.panel.panels.school.simpleness.SchoolDataManager;
	import com.view.gameWindow.scene.GameSceneManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.tabsSwitch.TabBase;
	
	public class SchoolStoragePanel extends TabBase
	{
		private var _handler:SchoolStorageHandler;
		private var _mouseHandler:SchoolStorageMouseHandler;
		public var bagCells:Vector.<BagCell>;
		public var schoolBagCells:Vector.<BagCell>;
		public var schoolBagIndex:int;
		public var selectCell:BagCell;

		private var schoolBagCellDragHandle:SchoolBagCellDragHandle;
		
		public function SchoolStoragePanel()
		{
			super();
			isSingleton=true;
		}
		
		override protected function initSkin():void
		{
			var skin:McStorage = new McStorage();
			_skin = skin;
			addChild(_skin);
			_handler=new SchoolStorageHandler(this);
			_mouseHandler=new SchoolStorageMouseHandler(this);
			schoolBagCellDragHandle = new SchoolBagCellDragHandle();
			schoolBagCellDragHandle.stage=GameSceneManager.getInstance().stage;
			schoolBagCellDragHandle.addEvent(this);
			initText();
			initBagCells();
			initSchoolBagCells();
		}
		
		private function initSchoolBagCells():void
		{
			var jl:int = 6,il:int = 6,i:int,j:int,vector:Vector.<BagCell>;
			schoolBagCells = new Vector.<BagCell>(36,true);
			for(j=0;j<jl;j++)
			{
				for(i=0;i<il;i++)
				{
					var bagCell:BagCell = new BagCell();
					bagCell.storageType = ConstStorage.ST_SCHOOL_BAG;
					bagCell.cellId = j*il+i;
					bagCell.initView();
					bagCell.refreshLockState(false);
					bagCell.x =380+ 46*(i);
					bagCell.y = 26+46*(j);
					ToolTipManager.getInstance().attach(bagCell);
					_skin.addChild(bagCell);
					schoolBagCells[j*il+i] = bagCell;
				}
			}
		}
		
		private function initText():void
		{
			var panel:McStorage = _skin as McStorage;

			panel.txt1.text=StringConst.SCHOOL_PANEL_6000;
			panel.txt2.text=StringConst.SCHOOL_PANEL_6001;
			panel.txt3.text=StringConst.SCHOOL_PANEL_6002;
			panel.txt4.text=StringConst.SCHOOL_PANEL_6003;
			panel.txtb1.text=StringConst.SCHOOL_PANEL_6004;
			panel.txtb2.text=StringConst.SCHOOL_PANEL_6007;
			panel.txtb4.text=StringConst.SCHOOL_PANEL_6008;
			panel.txtb5.text=StringConst.SCHOOL_PANEL_6005;
			panel.txtb6.text=StringConst.SCHOOL_PANEL_6006;
			panel.txtb1.mouseEnabled=false;
			panel.txtb2.mouseEnabled=false;
			panel.txtb4.mouseEnabled=false;
			panel.txt7.text=StringConst.SCHOOL_PANEL_6009;
		}
		
		public function setSelect(cell:BagCell):void
		{
			if(cell==null||cell.bagData==null)
			{
				_skin.selectCellEfc.visible=false;
				selectCell=null;
			}
			else
			{
				_skin.setChildIndex(_skin.selectCellEfc,_skin.numChildren-1);
				_skin.selectCellEfc.x=cell.x+5;
				_skin.selectCellEfc.y=cell.y+5;
				_skin.selectCellEfc.visible=true;
				_skin.selectCellEfc.mouseEnabled=false;
				selectCell=cell;
			}
		}
		
		/**初始化背包单元格*/
		private function initBagCells():void
		{
			var jl:int = 7,il:int = 6,i:int,j:int,vector:Vector.<BagCell>;
			bagCells = new Vector.<BagCell>(42,true);
			for(j=0;j<jl;j++)
			{
				for(i=0;i<il;i++)
				{
					var bagCell:BagCell = new BagCell();
					bagCell.storageType = ConstStorage.ST_SCHOOL_MY_BAG;
					bagCell.cellId = j*il+i;
					bagCell.initView();
					bagCell.refreshLockState(false);
					bagCell.x =23+ 46*(i);
					bagCell.y = 24+46*(j);
					_skin.addChild(bagCell);
					ToolTipManager.getInstance().attach(bagCell);
					bagCells[j*il+i] = bagCell;
				}
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			super.addCallBack(rsrLoader);
		}
		
		override public function destroy():void
		{
			schoolBagCellDragHandle&&schoolBagCellDragHandle.removeEvent(this);
			schoolBagCellDragHandle=null;
			_mouseHandler&&_mouseHandler.destroy();
			_mouseHandler=null;
			_handler&&_handler.destroy();
			_handler=null;
			clearMyBagCell();
			clearSchoolBagCell();
			super.destroy();
		}
		
		private function clearSchoolBagCell():void
		{
			// TODO Auto Generated method stub
			for (var i:int=0;i<schoolBagCells.length;i++)
			{
				ToolTipManager.getInstance().detach(schoolBagCells[i]);
				schoolBagCells[i].destory();
				schoolBagCells[i]=null;
			}
		}
		
		private function clearMyBagCell():void
		{
			// TODO Auto Generated method stub
			for (var i:int=0;i<bagCells.length;i++)
			{
				ToolTipManager.getInstance().detach(bagCells[i]);
				bagCells[i].destory();
				bagCells[i]=null;
			}
		}
		
		override protected function initData():void
		{
			SchoolElseDataManager.getInstance().getSchoolBagsRequest();
			_handler.updateBags();
		}		
		override public function update(proc:int=0):void
		{
			if(proc==GameServiceConstants.SM_FAMILY_STORAGE_INFO)
			{
				_handler.updateSchoolBags();
			}else
			{
				_handler.updateBags();
			}
			_handler.updatePanel();
			super.update(proc);
		}
		
		override protected function attach():void
		{
			super.attach();
			SchoolElseDataManager.getInstance().attach(this);
			SchoolDataManager.getInstance().attach(this);
			BagDataManager.instance.attach(this);
		}
		
		override protected function detach():void
		{
			super.detach();
			SchoolElseDataManager.getInstance().detach(this);
			SchoolDataManager.getInstance().detach(this);
			BagDataManager.instance.detach(this);
		}
		
		public function updateSchoolBag():void
		{
			_handler.updateSchoolBags();
		}
	}
}