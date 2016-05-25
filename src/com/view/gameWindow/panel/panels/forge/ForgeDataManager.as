package com.view.gameWindow.panel.panels.forge
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.business.gameService.serverMessageManager.subManages.SuccessMessageManager;
    import com.model.dataManager.DataManagerBase;
    import com.view.gameWindow.panel.PanelConst;
    import com.view.gameWindow.panel.PanelMediator;
    import com.view.gameWindow.panel.panels.bag.BagData;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.forge.strengthen.SendStrengthenVO;
    import com.view.gameWindow.panel.panels.forge.strengthen.StrengthenHandle;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    
    import flash.utils.ByteArray;
    import flash.utils.clearInterval;

    /**
	 * 锻造相关面板数据类
	 * @author jhj
	 */
	public class ForgeDataManager extends DataManagerBase
	{
		private static var _instance:ForgeDataManager;
		public static function get instance():ForgeDataManager
		{
			return _instance ||= new ForgeDataManager(new PrivateClass());
		}
		
		public static const typeStrengthen:int = 0;
		public static const typeDegree:int = 1;
		public static const typeCompound:int = 2;
		public static const typeExtend:int = 3;
		public static const typeResolve:int = 4;
		public static const typeRefined:int = 5;
		public static const typeTotal:int = 6;
		public var openedTab:int = -1;

        public var isSuccess:int;
		public var continueStrengthenVO:SendStrengthenVO;
		public var continuePolishTimeId:int;
        public var isPolishSuccess:int = -1;//是否打磨成功  0失败  1成功
		public var equipResolveDatas:Vector.<BagData>;
		private var _selectResolveData:BagData;
		
		public var dtTabSecondSelect:DataTabSecondSelect;
		
		public function ForgeDataManager(cls:PrivateClass)
		{
			super();
			if(!cls)
			{
				throw new Error("该类使用单例模式");
			}
			dtTabSecondSelect = new DataTabSecondSelect();
			//
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_EQUIP_STRENGTHEN,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_EQUIP_UPGRADE,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_EQUIP_DISASSEMBLE,this);
			SuccessMessageManager.getInstance().register(GameServiceConstants.CM_COMBINE,this);
            SuccessMessageManager.getInstance().register(GameServiceConstants.CM_EQUIP_POLISH, this);//打磨
		}
		/**
		 * 刷新二级分页及选中
		 * @param type 使用ConstStorage中的常量
		 * @param id 装备唯一id
		 * @param sid 装备服务器sid
		 */		
		public function updateTabSecond(type:int,id:int,sid:int):void
		{
			dtTabSecondSelect._typeSecond = type;
			dtTabSecondSelect._selectId = id;
			dtTabSecondSelect._selectSid = sid;
			dtTabSecondSelect.isNotifyUpdateTabSecond = true;
			notify(DataTabSecondSelect.NOTIFY_UPDATE_TAB_SECOND);
		}
		/**底部按钮开启关闭面板*/
		public function dealSwitchPanel(openTab:int = typeStrengthen):void
		{
			openedTab = openedTab == -1 ? openTab : -1;
			PanelMediator.instance.switchPanel(PanelConst.TYPE_FORGE);
		}
		/**开关面板，若面板开启且页不同则切换*/
		public function dealSwitchPanel1(type:int):void
		{
			var panel:PanelForge = PanelMediator.instance.openedPanel(PanelConst.TYPE_FORGE) as PanelForge;
			if (panel)
			{
				panel.setTabIndex(type);
			}
			else
			{
				PanelMediator.instance.openPanel(PanelConst.TYPE_FORGE);
				panel = PanelMediator.instance.openedPanel(PanelConst.TYPE_FORGE) as PanelForge;
				panel.setTabIndex(type);
			}
		}
		
		override public function resolveData(proc:int, data:ByteArray):void
		{
			switch(proc)
			{
				case GameServiceConstants.CM_EQUIP_STRENGTHEN:
					dealStrengthen(data);
					break;
				case GameServiceConstants.CM_EQUIP_UPGRADE:
					dealDegree();
					break;
				case GameServiceConstants.CM_EQUIP_DISASSEMBLE:
					dealResolve();
					break;
				case GameServiceConstants.CM_COMBINE:
					dealCombine();
					break;
                case GameServiceConstants.CM_EQUIP_POLISH:
                    dealPolish(data);
                    break;
				default:
					break;
			}
			super.resolveData(proc, data);
		}

        private function dealPolish(data:ByteArray):void
        {
            isPolishSuccess = data.readInt();
        }
		
		private function dealStrengthen(data:ByteArray):void
		{
			//强化成功与否
			isSuccess = data.readInt();
			trace("ForgeDataManager.dealStrengthen 强化结果:"+isSuccess);
		}
		
		private function dealDegree():void
		{
			trace("ForgeDataManager.dealDegree 升阶成功");


        }

		private function dealResolve():void
		{
			trace("ForgeDataManager.dealResolve 分解成功");
		}
		
		private function dealCombine():void
		{
			trace("合成成功");
		}
		
		public function stopIntervalPolishRequest():void
		{
			if(continuePolishTimeId > 0)
			{
				clearInterval(continuePolishTimeId);
				continuePolishTimeId = 0;
				if(StrengthenHandle.instance)
				{
					StrengthenHandle.instance.destoryAccruePolish();
				}
			}
		}
		
		public function getResolveEquipDatas():void
		{
			equipResolveDatas = BagDataManager.instance.getResolveEquipDatas();
			var getRecycleEquipDatas:Vector.<BagData> = HeroDataManager.instance.getResolveEquipDatas();
			equipResolveDatas = equipResolveDatas.concat(getRecycleEquipDatas);
			if(equipResolveDatas.length)
			{
				_selectResolveData = equipResolveDatas[0];
			}
			else
			{
				_selectResolveData = null;
			}
		}
		
		public function get selectResolveData():BagData
		{
			return _selectResolveData;
		}
		
		public function setSelectResolveData(id:int):void
		{
			var bagData:BagData;
			for each(bagData in equipResolveDatas)
			{
				if(bagData.id == id)
				{
					_selectResolveData = bagData;
					break;
				}
			}
		}
		/**重置二级选中信息*/
		public function resetTabSecondInfo():void
		{
			dtTabSecondSelect._typeSecond = 0;
			dtTabSecondSelect._selectId = 0;
		}
	}
}
class PrivateClass{}