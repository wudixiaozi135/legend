package com.view.gameWindow.panel.panels.storage
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.ErrorMessageManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.consts.ConstStorage;
	import com.model.consts.StringConst;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.panel.panels.prompt.Panel1BtnPrompt;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.MD5;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class StorageDataMannager extends DataManagerBase
	{
		private static var _instance:StorageDataMannager;
		public static function get instance():StorageDataMannager
		{
			return _instance ||= new StorageDataMannager(new PrivateClass());
		}
		public var codeSelectTab:int;
		public var storageId:int = 0;
		public var goldUnbind:int;
		public var coinUnbind:int;
		public var isHavePassWord:int; //1字节有符号整形，是否有密码 0没有 1有
		public var remainCellNum:int;
		private var _storageCellDatas:Vector.<StorageData>;
		
		public var goldOrCoin:int;  //1：元宝 2：金币
		public function get storageCellDatas():Vector.<StorageData>
		{
			return _storageCellDatas;
		}
		
		private var _usedCellData:StorageData;
		
		public function get usedCellData():StorageData
		{
			var _usedCellData2:StorageData = _usedCellData;
			_usedCellData = null;
			return _usedCellData2;
		}
		public function setUsedCellData(cellId:int):void
		{
			_usedCellData = _storageCellDatas[cellId];
		}
		public function getStorageCellData(cellId:int):StorageData
		{
			return _storageCellDatas[cellId];
		}
		
		public function getBagCellDataById(id:int):StorageData
		{
			for each(var cellData:StorageData in _storageCellDatas)
			{
				if(cellData && cellData.id == id)
				{
					return cellData;
				}
			}
			return null;
		}
		
		public var passWordParam:int;
		public var codeState:int;
		public static const codeStateZero:int = -1;   // 未设置密锁
		public static const codeStateOne:int = 0;   // 未锁定
		public static const codeStateTwo:int = 1;   // 已锁定
		public static const codeStateThree:int = 2;	// 临时解锁
		
		public function StorageDataMannager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			DistributionManager.getInstance().register(GameServiceConstants.SM_STORE_ITEMS,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_STORE_GOLD_COIN,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_PASSWORD_PARAM,this);
			
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_QUERY_STORE_ITEMS,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_MOVE_STORE_ITEM,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_SET_STORE_PASSWORD,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_UPDATE_STORE_PASSWORD,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_DELETE_STORE_PASSWORD,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_RESTORE_LOCK,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_UNLOCK_STORE,this);
			
			
 			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_PASSWARD_EXIST,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_PASSWARD_ERROR,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_PASSWARD_NOT_EXIST,this);
			ErrorMessageManager.getInstance().register(GameServiceConstants.ERR_NEED_LOCK,this);
			
		 
		}
		
		
		override public function resolveData(proc:int, data:ByteArray):void
		{ 
			switch(proc)
			{
				case GameServiceConstants.CM_QUERY_STORE_ITEMS:
				{
					//dealNeedCodePage(data);
					PanelMediator.instance.openPanel(PanelConst.TYPE_STORAGE_CODE);
					break;
				}	
				case GameServiceConstants.SM_STORE_ITEMS:
				{
					dealNoCodeCodePage(data);
					break;
				}
				case GameServiceConstants.CM_UNLOCK_STORE:
				{
					dealUnloackStore(data);
					break;
				}
					
				case GameServiceConstants.ERR_NEED_LOCK:
				{
					//修改密码
					//dealNeedCode(data);
					dealNeedCodePage(data);
					break; 
				}
				case GameServiceConstants.CM_MOVE_STORE_ITEM:
				{
					dealMoveItem(data);
					break;
				}
			   case  GameServiceConstants.SM_STORE_GOLD_COIN:
			   {
			   		dealGoldCoin(data);
					break;
			   }
			   case GameServiceConstants.SM_PASSWORD_PARAM:
			   {
				    // 密码参数
				    dealPassWordParam(data);	
				    break;
			   }
			   case  GameServiceConstants.CM_SET_STORE_PASSWORD:
			   {
				   //设置密码锁  
				   dealSetStorePassWord(data);
				   break; 
			   }
			   case GameServiceConstants.ERR_PASSWARD_ERROR:
			   {
				   // 密码错误
				   dealErrPassWardError(data); 	
				   break; 
			   }
			   case GameServiceConstants.ERR_PASSWARD_EXIST:
			   {
			   	   //已经设置过密码	
				   dealErrPassWardExist(data);
				   break; 
			   }
			   case GameServiceConstants.CM_RESTORE_LOCK:
			   {
			   	   //恢复保护
				   dealRestoreLock(data);
				   break; 
			   }
			   case GameServiceConstants.CM_DELETE_STORE_PASSWORD:
			   {
				     //取消密码
			   	   dealDeleteStorePassWord(data);
				   break; 
			   }
			   case GameServiceConstants.CM_UPDATE_STORE_PASSWORD:
			   {
			   		//修改密码
				   dealUpdateStorePassWord(data);
				   break; 
			   }
			   case GameServiceConstants.ERR_PASSWARD_NOT_EXIST:
			   {
				   //修改密码
				   dealErrPassWardNotExist(data);
				   break; 
			   }
			  
			}
			super.resolveData(proc, data);
		}
		
		public function queryStoreitems(storage:int):void
		{
			var byte:ByteArray = new ByteArray(); 
			byte.endian = Endian.LITTLE_ENDIAN;
			byte.writeByte(ConstStorage.ST_STORAGE[storageId]);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_QUERY_STORE_ITEMS,byte);
		}
		
		
		public function moveStorageItem(oldStorage:int,oldSlot:int,newStorage:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(oldStorage);
			byteArray.writeByte(oldSlot);
			byteArray.writeByte(newStorage);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_MOVE_STORE_ITEM,byteArray);
		}
		
		public function arrangeStorage():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(ConstStorage.ST_STORAGE[storageId]);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SORT_BAG,byteArray);
		}
		
		public function dropStorageItem(cellId:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(ConstStorage.ST_STORAGE[storageId]);
			byteArray.writeByte(cellId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DROP_ITEM,byteArray);
		}
		
		public function destoryStorageItem(cellId:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(ConstStorage.ST_STORAGE[storageId]);
			byteArray.writeByte(cellId);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DESTORY_ITEM,byteArray);
		}
		public function accessGoldCoin(type:int,action:int,num:int):void
		{
			if(num == 0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.STORAGE_006);
				return;
			}
					
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeByte(type);
			byteArray.writeByte(action);
			byteArray.writeInt(num);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_STORE_GOLD_COIN,byteArray);
		}
		
		private function dealMoveItem(data:ByteArray):void
		{
			if(BagDataManager.instance.remainCellNum == 0)
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.BAG_PANEL_0024);	
			if(remainCellNum == 0)
				RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.STORAGE_004);		
		}
		
		private function dealGoldCoin(data:ByteArray):void
		{
			goldUnbind = data.readInt();
			coinUnbind = data.readInt();
			
		}
		
		
		
		//////////////////////////////////////////////
		
		//获取密码参数
		public function getPassWordParam():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_GET_PASSWORD_PARAM,byteArray);
		}
		//设置密码锁
		public function setStorePassWord(codeStr:String):void
		{
			 var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN; 
			//codeStr = codeStr+passWordParam.toString();
			//
			//var md5:MD5 = new MD5;
			codeStr = MD5.hash(codeStr);
			byteArray.writeUTF(codeStr);
			//trace("codeStr>>>>>>>>>>>>>",codeStr);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_SET_STORE_PASSWORD,byteArray);
		}	
		
		// 解锁
		public function JieChuMiSuo(codeStr:String):void
		{
			if(codeState == -1)
			{
				//"当前未设置密锁,不能进行操作!"
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_040);
				return;
			}
			else if(codeState == 2)
			{
				//"你的仓库仍未锁定"	
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_041);
			}
			
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			codeStr = MD5.hash(codeStr);
			//trace("codeStr>>>>>>>>>>>>>",codeStr);
			codeStr = codeStr + passWordParam.toString(); 
			codeStr = MD5.hash(codeStr);
			byteArray.writeUTF(codeStr);	 
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_UNLOCK_STORE,byteArray);
		}
		
		// 修改密码
		public function savePassWord(oldstr:String,newstr:String):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			oldstr = MD5.hash(oldstr);
			//trace("codeStr>>>>>>>>>>>>>",codeStr);
			oldstr = oldstr + passWordParam.toString(); 
			oldstr = MD5.hash(oldstr);
			byteArray.writeUTF(oldstr);
			newstr = MD5.hash(newstr);	
			byteArray.writeUTF(newstr);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_UPDATE_STORE_PASSWORD,byteArray);
		}
		// 取消密码 (取消保护)
		public function cancleProtect(codeStr:String):void
		{
			if(codeState == -1)
			{
				//"当前未设置密锁,不能进行操作!"
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_042);
				return;
			}
			
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;			 
			codeStr = MD5.hash(codeStr);
			codeStr = codeStr + passWordParam.toString(); 
			codeStr = MD5.hash(codeStr);
			byteArray.writeUTF(codeStr);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_DELETE_STORE_PASSWORD,byteArray);
		}
		//恢复保护
		public function recoverProtect():void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_RESTORE_LOCK,byteArray);
		}
		
		private function dealPassWordParam(data:ByteArray):void
		{
			passWordParam = data.readInt();			
		}
		
		private function dealUnloackStore(data:ByteArray):void
		{
			codeState = 2;
			//"你已临时解除仓库密锁"
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_043);
			PanelMediator.instance.closePanel(PanelConst.TYPE_STORAGE_CODE);
			//PanelMediator.instance.openPanel(PanelConst.TYPE_STORAGE);
			queryStoreitems(0);
			getPassWordParam();
		}	
		
		// 设置密锁      仓库关闭     //  临时解锁是 仓库打开
		private function dealSetStorePassWord(data:ByteArray):void
		{
			var panel:IPanelBase = 	PanelMediator.instance.openedPanel(PanelConst.TYPE_STORAGE);
			if(codeState == 1)
			{				
				
				if(!panel)
				{
					codeState = 2;
					//"你已临时解除仓库密锁"
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_044);
					//PanelMediator.instance.openPanel(PanelConst.TYPE_STORAGE);
					queryStoreitems(0);
				}
				else
				{
					//当前已经设置了密锁,请到‘修改密锁’页面修改密锁
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_045);
				}
				
			}
			else if(codeState == -1)
			{
				codeState = 1;
				if(panel)
				{
					PanelMediator.instance.closePanel(PanelConst.TYPE_STORAGE);
					//"设置仓库密锁成功!"
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_046);
				}
			}
			else if(codeState == 2)
			{
				
				codeState = 1;
				if(panel)
				{
					PanelMediator.instance.closePanel(PanelConst.TYPE_STORAGE);
					//"你已经恢复仓库保护功能!"
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_047);
				}
			}
			else if(codeState == 0)
			{
				
				codeState = 1;
				if(panel)
				{
					PanelMediator.instance.closePanel(PanelConst.TYPE_STORAGE);
					//"设置仓库密锁成功!"
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_048);
				}
			}
 
		}
		//密码错误
		private function dealErrPassWardError(data:ByteArray):void
		{
			//"密码错误!" 
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_049);
		}
		
		
		//恢复保护   仓库关闭     已锁定   1
		private function dealRestoreLock(data:ByteArray):void
		{
			codeState = 1;
			var panel:IPanelBase = 	PanelMediator.instance.openedPanel(PanelConst.TYPE_STORAGE);
			if(panel)
				PanelMediator.instance.closePanel(PanelConst.TYPE_STORAGE);
			//"你已经恢复仓库保护功能!"
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_050); 
		}
		//取消密码    显示仓库    未锁定
		private function dealDeleteStorePassWord(data:ByteArray):void
		{
			codeState = -1;
			//var panel:IPanelBase = 	PanelMediator.instance.openedPanel(PanelConst.TYPE_STORAGE);
			
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_051); 
		}	
		
		//修改密码 
		private function dealUpdateStorePassWord(data:ByteArray):void
		{
			//"密码更新成功!"
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_052);
		}
		
		private function dealErrPassWardNotExist(data:ByteArray):void
		{
			codeState = -1;
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_053);
		}
		
		private function dealErrPassWardExist(data:ByteArray):void
		{
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_054);
		}
		
		private function dealNeedCodePage(data:ByteArray):void
		{
			codeState = 1;
			PanelMediator.instance.openPanel(PanelConst.TYPE_STORAGE_CODE);
		}
		
		
		private function dealNoCodeCodePage(data:ByteArray):void
		{
			codeState = 0;
			PanelMediator.instance.openPanel(PanelConst.TYPE_STORAGE);
					
			goldUnbind = data.readInt();
			coinUnbind = data.readInt();
			isHavePassWord = data.readByte();
			var size:int = data.readByte();
			remainCellNum = StorageData.totalCellNum - size; 
			_storageCellDatas = new Vector.<StorageData>(StorageData.totalCellNum,true);
			var cellData:StorageData; 
			while(size--)
			{
				cellData = new StorageData();
				cellData.slot = data.readByte();
				cellData.id = data.readInt();
				cellData.bornSid = data.readInt();
				cellData.type = data.readByte();
				cellData.count = data.readInt();
				cellData.bind = data.readByte();
				cellData.storageType = ConstStorage.ST_STORAGE[storageId];
				_storageCellDatas[cellData.slot] = cellData;
			} 			
		}
 		 
		private function dealNeedCode(data:ByteArray):void
		{
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.STORAGE_055);
		}
	}
}
class PrivateClass{}