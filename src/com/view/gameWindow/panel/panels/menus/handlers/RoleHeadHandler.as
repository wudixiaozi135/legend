package com.view.gameWindow.panel.panels.menus.handlers
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	
	
	/**
	 * 挺不好的, 有空再想想
	 * @author wqhk
	 * 2014-11-10
	 */
	public class RoleHeadHandler extends MenuHandler
	{
		private var _sid:int;
		private var _cid:int;
		private var _name:String;
		private var _type:int;
		
		public function RoleHeadHandler(sid:int,cid:int,name:String)
		{
			_sid = sid;
			_cid = cid;
			_name=name;
			super();
		}
		
		override public function selected(index:int):void
		{
			switch(index)
			{
				case 0:
					MenuFuncs.toPrivateTalk(_sid,_cid,_name);
					break;
				case 1:
					MenuFuncs.inviteToTeam(_sid,_cid);
					break;
				case 2:
					MenuFuncs.applyToTeam(_sid,_cid);
					break;
				case 3:
//					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.HERO_PANEL_005);
					MenuFuncs.inviteToSchool(_sid,_cid);
					break;
			}
		}
	}
}