package com.view.gameWindow.panel.panels.npcshop
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.business.gameService.serverMessageManager.subManages.DistributionManager;
	import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
	import com.model.business.gameService.socketManager.ClientSocketManager;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.NpcShopCfgData;
	import com.model.dataManager.DataManagerBase;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.util.UtilCostRollTip;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class NpcShopDataManager extends DataManagerBase
	{
		private static var _instance:NpcShopDataManager;
		public static function get instance():NpcShopDataManager
		{
			return _instance ||= new NpcShopDataManager(new PrivateClass());
		}
		
		public static function clearInstance():void
		{
			_instance = null;
		}
		
		public function NpcShopDataManager(pc:PrivateClass)
		{
			super();
			if(!pc)
			{
				throw new Error("该类使用单例模式");
			}
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_NPC_SHOP_BUY,this);
			DistributionManager.getInstance().register(GameServiceConstants.SM_NPC_SHOP_INFOR,this);
		}
		
		public function cmNpcShopBuy(npcShopId:int,num:int,storage:int):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.endian = Endian.LITTLE_ENDIAN;
			byteArray.writeInt(npcShopId);
			byteArray.writeShort(num);
			byteArray.writeByte(storage);
			ClientSocketManager.getInstance().asyncCall(GameServiceConstants.CM_NPC_SHOP_BUY,byteArray);
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.CM_NPC_SHOP_BUY:
					
					break;
				case GameServiceConstants.SM_NPC_SHOP_INFOR:
					smNpcShopInfo(data);
					break;
			}
			super.resolveData(proc, data);
		}
		
		private function smNpcShopInfo(bytearray:ByteArray):void
		{
			trace("NpcShopDataManager.cmNpcShopBuyDeal(bytearray) 购买物品成功");
			var npcShopId:int = bytearray.readInt();
			var num:int = bytearray.readInt();
			var cfgDt:NpcShopCfgData = ConfigDataManager.instance.npcShopCfgData1(npcShopId);
			if(cfgDt)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,UtilCostRollTip.successShoping(cfgDt,num));
			}
		}
	}
}
class PrivateClass{}
