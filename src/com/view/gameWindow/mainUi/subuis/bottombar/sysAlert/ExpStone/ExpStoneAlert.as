package com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.ExpStone
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.AlertCellBase;
	
	public class ExpStoneAlert extends AlertCellBase
	{
//		private var _item:ExpStoneItem;
		public function ExpStoneAlert()
		{
			super();
//			_item = new ExpStoneItem();
//			skin.addChild(_item);
		}
		
		override protected function getIconUrl():String
		{
			// TODO Auto Generated method stub
			var url:String="mainUiBottom/expStone.png";
			return url;
		}
		
		public function refreshNum(count:int):void
		{
//			if (_item)
//			{
//				_item.refreshNum(count);
//			}
		}
		
		
		override protected function getTipStr():String
		{
			return StringConst.SYSTEM_ALERT_21;
		}
		
//		override public function destroy():void
//		{
////			if (_item && contains(_item))
//			{
//				skin.removeChild(_item);
//				_item.destroy();
//				_item = null;
//			}
//		}
	}
}
import com.view.gameWindow.mainUi.subuis.bottombar.sysAlert.team.iconAlert.IconAlertBase;

class ExpStoneItem extends IconAlertBase
{
	public function ExpStoneItem()
	{
		initView();
	}
	
}