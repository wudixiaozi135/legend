package com.view.gameWindow.panel.panels.storage
{
	import com.model.consts.ConstStorage;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.SimpleStateButton;
	
	import flash.display.MovieClip;
	
	import mx.utils.StringUtil;
	
	public class PanelStorageViewHandle
	{
		private var _panel:PanelStorage; 
		private var _skin:McStaorge;		
		public var _storageCells:Vector.<StorageCell>;
		
		 
		public function PanelStorageViewHandle(panel:PanelStorage)
		{
			_panel = panel;
			_skin = panel.skin as McStaorge;
		}
		public function init(rsloader:RsrLoader):void
		{
			rsloader.addCallBack(_skin.selectCellEfc,function (mc:MovieClip):void
			{
				mc.visible = false;
			}
			);
			rsloader.addCallBack(_skin.lockMc,function (mc:MovieClip):void
			{
				mc.visible = false;
				_skin.lockTxt.visible = false;
			}
			);
 
			rsloader.loadItemRes(_skin.mcGold);
			rsloader.loadItemRes(_skin.mcCoin);
			initTips(_skin.mcGold,StringConst.GOLD_COIN);
			initTips(_skin.mcCoin,StringConst.GOLD_COIN);
 			
			initCells();
		}
		
		private function initTips(mc:MovieClip,str:String):void
		{
			var tipsVo:TipVO;
			tipsVo = new TipVO;
			tipsVo.tipType = ToolTipConst.TEXT_TIP; 
			tipsVo.tipData = str;
			ToolTipManager.getInstance().attach(mc);
			ToolTipManager.getInstance().hashTipInfo(mc,tipsVo);
		}
		
		private function initCells():void
		{
			var jl:int = 6,il:int = 8,i:int,j:int,vector:Vector.<StorageCell>;
			_storageCells = new Vector.<StorageCell>(StorageData.totalCellNum,false);
			for(j=0;j<jl;j++)
			{
				for(i=0;i<il;i++)
				{
					var storageCell:StorageCell = new StorageCell();
					storageCell.storageType = ConstStorage.ST_STORAGE[StorageDataMannager.instance.storageId];
					storageCell.cellId = j*il+i;
					storageCell.initView();
					storageCell.refreshLockState(false);
					storageCell.x = 46*(i+1) -5;
					storageCell.y = 38+46*(j+1);
					_skin.addChild(storageCell);
					_storageCells[j*il+i] = storageCell;
				}
			}
		}
		
		
		 
		public function refresh():void
		{
			var storageCellDatas:Vector.<StorageData>,cellDatas:StorageData,i:int;
			storageCellDatas = StorageDataMannager.instance.storageCellDatas;
			_skin.btnLock.selected = Boolean(StorageDataMannager.instance.isHavePassWord);
			/*storageId = StorageDataMannager.instance.storageId; 
			flag = StorageDataMannager.instance.flagVip(storageId);*/
			if(storageCellDatas.length)
			{
				for(i=0;i<StorageData.totalCellNum;i++)
				{
					cellDatas = storageCellDatas[i];
					_storageCells[i].storageType = ConstStorage.ST_STORAGE[StorageDataMannager.instance.storageId];
					_storageCells[i].refreshLockState(false);
					if(cellDatas)
					{
						//_storageCells[i].refreshLockState(false);
						_storageCells[i].refreshData(cellDatas);
						ToolTipManager.getInstance().attach(_storageCells[i]);
						
					}
					else
					{
						ToolTipManager.getInstance().detach(_storageCells[i]);
						_storageCells[i].setNull();
					}
		 
				}
			}
		}
		
		public function clearCells():void
		{
			for(var i:int=0;i<StorageData.totalCellNum;i++)
			{
				_storageCells[i].refreshLockState(true);
				ToolTipManager.getInstance().detach(_storageCells[i]);
				_storageCells[i].setNull();

			}
		}
		public function refreshMoney():void
		{
			_skin.txtCoin.text = StorageDataMannager.instance.coinUnbind.toString();
			_skin.txtGold.text = StorageDataMannager.instance.goldUnbind.toString();
		}
		
		public function showLock(flag:Boolean,needVip:int):void
		{
			_skin.lockMc.visible = flag;
			_skin.lockTxt.visible = flag;
			_skin.lockTxt.text = StringUtil.substitute(StringConst.STORAGE_058,needVip);
			_skin.setChildIndex(_skin.lockMc,_skin.numChildren-1);
			_skin.setChildIndex(_skin.lockTxt,_skin.numChildren-1);
		}
				
		internal function destroy():void
		{
			ToolTipManager.getInstance().detach(_skin.mcGold);
			ToolTipManager.getInstance().detach(_skin.mcCoin);
			for(var i:int=0;i<StorageData.totalCellNum;i++)
			{
				ToolTipManager.getInstance().detach(_storageCells[i]);
				if(_storageCells[i].parent)
				{
					_storageCells[i].parent.removeChild(_storageCells[i]);
				}
				_storageCells[i].destory();
			} 
			_storageCells.length = 0;
			_storageCells = null;
			 
		}
 
	}
}