package com.view.gameWindow.panel.panels.lasting
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.lasting.LastingHandler;
	import com.view.gameWindow.scene.entity.constants.EntityTypes;

	public class LastingViewHandler
	{
		private var _panel:PanelLasting;
		private var _skin:McLasting;
		public function LastingViewHandler(panel:PanelLasting)
		{
			_panel = panel;
			_skin = _panel.skin as McLasting;
			initialize();
		}
		
		private function initialize():void
		{
//			_iconCells = new Vector.<IconCellEx>();
//			_dataThings = new Vector.<ThingsData>();
//			var index:int = LevelRewardDataManager.instance.rewardIndex;
//			var datas:Vector.<LevelRewardVo> = LevelRewardDataManager.instance.getLimitRewards(index);
//			var len:int = 6;
//			for (var i:int = 0; i < len; i++)
//			{
//				var ex:IconCellEx = new IconCellEx(_skin["item" + i], 0, 0, 39, 39);
//				_iconCells.push(ex);
//				var dt:ThingsData = new ThingsData();
//				_dataThings.push(dt);
//			}
			_skin.btnNpc.alpha = 0;
			_skin.btnShop.alpha = 0;
			_skin.btnNpc.buttonMode = true;
			_skin.btnShop.buttonMode = true;
			refresh();
		}
		
		private function refresh():void
		{
			var str1:String = "";
			var str2:String = "";
			_skin.txtOwner.text = _skin.txtOwner2.text = _skin.txtEquipInfo.text = _skin.txtEquipInfo2.text = "";
			var arr1:Array = LastingHandler.lastingArrRole;
			var arr2:Array = LastingHandler.lastingArrHero;
			if(arr1.length)
			{
				var obj:Object = arr1[0] as Object;
				str1 = obj.name+"  "+"("+obj.num1+"/"+obj.num2/100+")";
				if(arr1.length>1)
					str1 = str1+" 等";
				var str:String = StringConst.SKILL_PANEL_0002;
				_skin.txtOwner.textColor = 0x00a2ff;
				_skin.txtOwner.text = StringConst.PANEL_LAST_OWNER.replace("xx",str);
				_skin.txtEquipInfo.htmlText = str1;
				if(arr2.length)
				{
					obj = arr2[0] as Object;
					str2 = obj.name+"  "+"("+obj.num1+"/"+obj.num2/100+")";
					if(arr2.length>1)
						str2 = str2+" 等";
					str = StringConst.SKILL_PANEL_0003;
					_skin.txtOwner2.textColor = 0x00ff00;
					_skin.txtOwner2.text = StringConst.PANEL_LAST_OWNER.replace("xx",str);
					_skin.txtEquipInfo2.htmlText = str2;
				}
			}
			else
			{
				obj = arr2[0] as Object;
				str2 = obj.name+"  "+"("+obj.num1+"/"+obj.num2/100+")";
				if(arr2.length>1)
					str2 = str2+" 等";
				str = StringConst.SKILL_PANEL_0003;
				_skin.txtOwner.textColor = 0x00ff00;
				_skin.txtOwner.text = StringConst.PANEL_LAST_OWNER.replace("xx",str);
				_skin.txtEquipInfo.htmlText = str2;	
			}
			_skin.txtTip.text = StringConst.PANEL_LAST_TIP;
			
//			str = StringConst.SKILL_PANEL_0003;
//			_skin.txtOwner2.textColor = 0x00ff00;
//			_skin.txtOwner2.text = StringConst.PANEL_LAST_OWNER.replace("xx",str);
//			_skin.txtEquipInfo1.htmlText = ;
			_skin.txtNpc.htmlText = StringConst.PANEL_LAST_NPC;
			_skin.txtShop.htmlText = StringConst.PANEL_LAST_SHOP;
		}
		
		public function destroy():void
		{
		}
		
	}
}