package com.model.business.gameService.serverMessageManager.subManages
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;
	import com.view.newMir.NewMirMediator;
	import com.view.newMir.prompt.PanelPromptData;

	public class ErrorDealManages
	{
		private static var _instance:ErrorDealManages;

		public static function getInstance():ErrorDealManages
		{
			return _instance ||= new ErrorDealManages(new PrivateClass());
		}

		public function ErrorDealManages(cls:PrivateClass)
		{
		}
		
		public function dealError(errorId:int):void
		{
			switch(errorId)
			{
				case GameServiceConstants.ERR_NAME_EXIST:
					NewMirMediator.getInstance().createRole.dealName();
					break;
				case GameServiceConstants.ERR_BAG_FULL:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.BAG_PANEL_0024);
					break;
				case GameServiceConstants.ERR_HERO_BAG_FULL:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.BAG_PANEL_0031);
					break;
				case GameServiceConstants.ERR_FAMILY_WANG_NOT_DELETE:
					PanelPromptData.txtName = StringConst.PROMPT_PANEL_0009;
					PanelPromptData.txtContent = StringConst.PROMPT_PANEL_0034;
					PanelPromptData.txtBtn = StringConst.PROMPT_PANEL_0003;
					NewMirMediator.getInstance().showOffLine(true);
					break;
				case GameServiceConstants.ERR_ALREADY_HAVE_CHANGE:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TRADE_0030);
					break;
				case GameServiceConstants.ERR_NOT_PICK_DROP_ITEM:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.PROMPT_PANEL_0037);
					break;
				case GameServiceConstants.ERR_TIME_IS_NOT_RIGHT:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PROMPT_PANEL_0038);
					break;
				case GameServiceConstants.ERR_LEAGUE_TIME:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PROMPT_PANEL_0039);
					break;
				case GameServiceConstants.ERR_TARGET_LEAGUE_TIME:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PROMPT_PANEL_0040);
					break;
				case GameServiceConstants.ERR_LEAGUE_ALREADY:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PROMPT_PANEL_0041);
					break;
				case GameServiceConstants.ERR_APPOINT_TIME_IS_NOT_RIGHT:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PROMPT_PANEL_0042);
					break;
				case GameServiceConstants.ERR_IS_CITY_LEADER:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.PROMPT_PANEL_0043);
					break;
				case GameServiceConstants.ERR_NOT_CAN_SELL:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.STALL_PANEL_0036);
					break;
				case GameServiceConstants.ERR_PLAYER_DIFF_SERVER_OR_OFFLINE:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TEAM_ERROR_00023);
					break;
				case GameServiceConstants.ERR_ALREADY_HAVE_TEAM:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TEAM_ERROR_00010);
					break;
				case GameServiceConstants.ERR_TEAM_FULL:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TEAM_ERROR_00015);
					break;
				case GameServiceConstants.ERR_NO_TEAM:
					RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TEAM_ERROR_00024);
					break;
				case GameServiceConstants.ERR_ALREADY_TEAM_LEADER://对方已成功设置了队长
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TEAM_ERROR_00012);
					break;
				case GameServiceConstants.ERR_NO_LONGCHENG_LEADER:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TEAM_ERROR_00026);
					break;
				case GameServiceConstants.ERR_NO_LONGCHENG_MEMBER:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TEAM_ERROR_00027);
					break;
				case GameServiceConstants.ERR_LONGCHENG_AWARD_IS_RECEIVE:
					RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringConst.TEAM_ERROR_00028);
					break;
				default:
					break;
			}
		}
	}
}
class PrivateClass{}