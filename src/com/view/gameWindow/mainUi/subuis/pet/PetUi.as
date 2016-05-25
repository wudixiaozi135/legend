package com.view.gameWindow.mainUi.subuis.pet
{
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.PetCfgData;
	import com.model.consts.ConstPetMode;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.common.Alert;
	import com.view.gameWindow.mainUi.MainUi;
	import com.view.gameWindow.mainUi.subclass.McDog;
	import com.view.gameWindow.panel.panels.bag.BagData;
	import com.view.gameWindow.panel.panels.bag.BagDataManager;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class PetUi extends MainUi implements IObserver
	{
		private var _pet:McDog;
		private const MONEY:int = 1;
		private const ITEM:int = 2; 
		private const MAX_GRADE:int = 7;
		private var selected:Boolean = false;//是否不再提示
		
		public function PetUi()
		{
			super();
			PetDataManager.instance.attach(this);
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			rsrLoader.addCallBack(_pet.btnAttack,function():void
			{
				setTips(_pet.btnAttack,ToolTipConst.TEXT_TIP,HtmlUtils.createHtmlStr(0xffffff,StringConst.PET_0004));
			});
			rsrLoader.addCallBack(_pet.btnTeleport,function():void
			{
				setTips(_pet.btnTeleport,ToolTipConst.TEXT_TIP,HtmlUtils.createHtmlStr(0xffffff,StringConst.PET_0005));
			});
			rsrLoader.addCallBack(_pet.btnLvUp,function():void
			{
				setTips(_pet.btnLvUp,ToolTipConst.TEXT_TIP,HtmlUtils.createHtmlStr(0xffffff,StringConst.PET_0006));
			});
		}
		
		override public function initView():void
		{
			_skin = new McDog();
			addChild(_skin);
			_pet = _skin as McDog;
			addEventListener(MouseEvent.CLICK,clickHandle);
			super.initView();
		}
		
		private function setTips(layer:MovieClip,tipType:int,tipData:*):void
		{
			var tipVo:TipVO = new TipVO();
			tipVo.tipType = tipType;
			tipVo.tipData = tipData;
			ToolTipManager.getInstance().hashTipInfo(layer,tipVo);
			ToolTipManager.getInstance().attach(layer);
		}
		
		protected function clickHandle(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _pet.btnAttack:
					dealBtnAttack();
					break;
				case _pet.btnTeleport:
					dealBtnTeleport();
					break;
				case _pet.btnLvUp:
					dealBtnLvUp();
					break;
			}
		}		
		
		private function dealBtnLvUp():void
		{
			var group_id:int = PetDataManager.instance.group_id;
			var grade:int = PetDataManager.instance.grade;
			var petCfg:PetCfgData = ConfigDataManager.instance.getPetCfgData(group_id,grade);
			var bagData:BagData;
			if(!petCfg)
			{
				return;
			}
			if((!petCfg.upgrade_item && !petCfg.upgrade_unbind_gold) || petCfg.grade == MAX_GRADE)
			{
				var str:String = StringConst.PET_0001.replace("x",petCfg.grade);
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,str);
				return;
			}
			if(petCfg.upgrade_item)
			{
				bagData = BagDataManager.instance.getItemById(petCfg.upgrade_item);
				if(bagData)
				{
					setPromptBtn(ITEM,bagData.storageType,bagData.slot);
					return;
				}
			}
			if(petCfg.upgrade_unbind_gold)
			{
				if(petCfg.upgrade_unbind_gold > BagDataManager.instance.goldUnBind)
				{
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.PET_0002);
				}
				else
				{
					setPromptBtn(MONEY,0,0);
				}
			}
			
		}
		
		private function setPromptBtn(costType:int,storage:int,slot:int):void
		{
			if (selected == false)
			{
				var msg1:String = StringConst.PET_0007;
				Alert.show3(msg1, function ():void
				{
					PetDataManager.instance.petLvUp(costType,storage,slot);
				}, null, function (bol:Boolean):void
				{
					selected = bol;
				}, null, StringConst.PROMPT_PANEL_0033,"","",null,"left");
			} else
			{
				PetDataManager.instance.petLvUp(costType,storage,slot);
			}
		}
		
		private function dealBtnTeleport():void
		{
			PetDataManager.instance.callPetBack();
		}
		
		private function dealBtnAttack():void
		{
			PetDataManager.instance.changePetModel();
		}
		
		public function update(proc:int=0):void
		{
			if(PetDataManager.instance.mode == ConstPetMode.PM_HIDE)
			{
				_pet.visible = false;
			}
			else if(PetDataManager.instance.mode == ConstPetMode.PM_IDLE)
			{
				_pet.visible = true;
				_pet.btnAttack.selected = true;
			}
			else	
			{
				_pet.visible = true;
				_pet.btnAttack.selected = false;
			}
		}
	}
}