/**
 * Created by Administrator on 2014/11/6.
 */
package com.view.gameWindow.panel.panels.team.tabHandle.myTeam
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.panel.panels.roleProperty.otherRole.OtherPlayerDataManager;
	import com.view.gameWindow.panel.panels.team.TeamDataManager;
	import com.view.gameWindow.panel.panels.team.TeamItemModel;
	import com.view.gameWindow.panel.panels.team.data.TeamInfoVo;
	import com.view.gameWindow.panel.panels.team.tab.McTabMySub;
	import com.view.gameWindow.panel.panels.team.tab.TabMyTeam;
	import com.view.gameWindow.scene.entity.EntityLayerManager;
	import com.view.gameWindow.scene.entity.entityItem.interf.IFirstPlayer;
	import com.view.gameWindow.tips.toolTip.TipVO;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.LoaderCallBackAdapter;
	import com.view.gameWindow.util.NumPic;
	import com.view.gameWindow.util.ObjectUtils;

	import flash.display.MovieClip;
	import flash.text.TextField;

	import mx.utils.StringUtil;

	public class TabMyTeamViewHandle implements IObserver
	{
		private var _tabMy:TabMyTeam;
		private var _teamModel:TeamItemModel;
		private var _skin:McTabMySub;
		private var _rsrLoader:RsrLoader;
		private var _attackNum:NumPic;
		private var _expNum:NumPic;

		/**监听队伍的长度发生变化*/
		private var _oldLen:int = 0;
		private var _selectIndex:int = 0;//当前选中的队项

		public function TabMyTeamViewHandle(tab:TabMyTeam, rsrLoader:RsrLoader)
		{
			this._tabMy = tab;
			this._rsrLoader = rsrLoader;
			_skin = _tabMy.skin as McTabMySub;
			ToolTipManager.getInstance().attach(_skin.attackAdd);
			ToolTipManager.getInstance().attach(_skin.expAdd);
			OtherPlayerDataManager.instance.attach(this);
			dealTip();

			init(rsrLoader);
			refresh();
		}

		/**更新组队信息列表*/
		public function refresh():void
		{
			var dataManager:TeamDataManager = TeamDataManager.instance;
			displayByTeam(dataManager.hasTeam, dataManager.isHeader);
			var vecLen:int = dataManager.teamInfoVec.length;
			var i:int = 0, len:int = dataManager.subItems.length;
			if (dataManager.hasTeam)
			{//有队伍
				for (i = 0; i < len; i++)
				{
					var subItem:SubItemInfo = dataManager.subItems[i];
					if (i < vecLen)//组队列表
					{
						subItem.data = dataManager.teamInfoVec[i];//需要根据要求进行排序
						_skin["item" + (i + 1)].visible = true;
					} else
					{
						subItem.data = null;
						_skin["item" + (i + 1)].visible = false;
					}
				}

				if (dataManager.teamInfoVec && vecLen != 0)
				{
					if (_oldLen != vecLen)
					{
						ObjectUtils.clearAllChild(_skin.attackAddIcon);
						_attackNum = new NumPic();
						_attackNum.init("yellow_", (vecLen - 1).toString(), _skin.attackAddIcon);

						ObjectUtils.clearAllChild(_skin.expAddIcon);
						_expNum = new NumPic();
						_expNum.init("yellow_", ((vecLen - 1) * 2).toString(), _skin.expAddIcon);
						_oldLen = vecLen;
					}
				} else
				{
					ObjectUtils.clearAllChild(_skin.attackAddIcon);
					ObjectUtils.clearAllChild(_skin.expAddIcon);
					TeamDataManager.instance.selectTeamInfo = null;
				}
				if (dataManager.selectTeamInfo && dataManager.teamInfoVec)
				{
					if (_selectIndex < dataManager.teamInfoVec.length)
					{
						var tempVo:TeamInfoVo = dataManager.teamInfoVec[_selectIndex];
						if (tempVo)
						{
							if (tempVo.cid != dataManager.selectTeamInfo.cid && tempVo.sid != dataManager.selectTeamInfo.sid)
							{
								handlerFirstData();
							}
						}
					} else
					{
						handlerFirstData();
					}
				} else
				{
					handlerFirstData();
				}
			} else
			{
				for (i = 0; i < len; i++)
				{
					var subItem1:SubItemInfo = dataManager.subItems[i];
					subItem1.data = null;
					_skin["item" + (i + 1)].visible = false;
				}
				ObjectUtils.clearAllChild(_skin.attackAddIcon);
				ObjectUtils.clearAllChild(_skin.expAddIcon);
				_oldLen = 0;
				TeamDataManager.instance.selectTeamInfo = null;
			}
			refreshSetting();
		}

		/**离开队伍刷新*/
		public function leaveTeamRefresh():void
		{
			var dataManager:TeamDataManager = TeamDataManager.instance;
			dataManager.teamInfoVec.length = 0;
			refresh();
		}

		public function dismissRefresh():void
		{
			var dataManager:TeamDataManager = TeamDataManager.instance;
			dataManager.teamInfoVec.length = 0;
			refresh();
		}

		/**刷新组队相关设置*/
		public function refreshSetting():void
		{
			var dataManager:TeamDataManager = TeamDataManager.instance;
			if (_skin && dataManager)
			{
				_skin.check1.selected = Boolean(dataManager.allow_team_invite);
				_skin.check2.selected = Boolean(dataManager.allow_team_apply);
			}
		}

		/**根据是否有队和队长进行面板显示*/
		public function displayByTeam(hasTeam:Boolean = false, isHeader:Boolean = false):void
		{
			var skin:McTabMySub = _tabMy.skin as McTabMySub;
			skin.btnCreate.visible = !hasTeam;
			skin.bg.visible = !hasTeam;
			skin.sign.visible = !hasTeam;
			skin.rolePreview.visible = hasTeam;
			skin.btnRemove.visible = hasTeam;
			skin.btnPromote.visible = hasTeam;
			skin.btnAdd.visible = hasTeam;
			skin.btnLeave.visible = hasTeam;
			skin.expAdd.visible = hasTeam;
			skin.attackAdd.visible = hasTeam;

			if (hasTeam == false) return;

			skin.btnRemove.visible = isHeader;
			skin.btnPromote.visible = isHeader;

			skin.btnAdd.visible = isHeader;
			skin.btnLeave.visible = isHeader;

			if (isHeader == false)
			{//不是队长
				skin.btnAdd.visible = !isHeader;
				skin.btnLeave.visible = !isHeader;
				skin.btnAdd.x = 377;
			} else
			{
				skin.btnAdd.x = 187;
			}
		}

		public function destroy():void
		{
			_selectIndex = 0;
			OtherPlayerDataManager.instance.detach(this);
			TeamDataManager.instance.subItems.length = 0;
			TeamDataManager.instance.subItemSelect = -1;
			TeamDataManager.instance.selectTeamInfo = null;

			ToolTipManager.getInstance().detach(_skin.attackAdd);
			ToolTipManager.getInstance().detach(_skin.expAdd);
			if (_teamModel)
			{
				_teamModel.destroy();
				_teamModel = null;
			}
			if (_skin)
			{
				ToolTipManager.getInstance().detach(_skin.check1);
				ToolTipManager.getInstance().detach(_skin.check2);
				_skin = null;
			}
			if (_tabMy)
			{
				_tabMy = null;
			}
		}

		private function handlerFirstData():void
		{
			var data:TeamInfoVo;
			var vec:Vector.<TeamInfoVo> = TeamDataManager.instance.teamInfoVec;
			if (vec && vec.length)
			{
				data = vec[0];
				var dataManager:TeamDataManager = TeamDataManager.instance;
				if (dataManager.subItemSelect == -1)
				{
					dealClick(data);
				}
			}
		}

		private function init(rsrLoader:RsrLoader):void
		{
			var skin:McTabMySub = _tabMy.skin as McTabMySub;
			var check1Loaded:Boolean = false, check2Loaded:Boolean = false;
			var txt:TextField, i:int = 0;
			txt = skin.checkTxt1 as TextField;
			txt.text = StringConst.TEAM_PANEL_0005;
			txt.textColor = 0xd4a460;

			txt = skin.checkTxt2 as TextField;
			txt.text = StringConst.TEAM_PANEL_0006;
			txt.textColor = 0xd4a460;
			skin.rolePreview.mouseChildren = false;
			skin.rolePreview.mouseEnabled = false;
			rsrLoader.addCallBack(skin.attackAdd, function (mc:MovieClip):void
			{
				mc.mouseEnabled = true;
			});
			rsrLoader.addCallBack(skin.expAdd, function (mc:MovieClip):void
			{
				mc.mouseEnabled = true;
			});

			rsrLoader.addCallBack(skin.btnCreate, function (mc:MovieClip):void
			{
				txt = mc.txt as TextField;
				txt.textColor = 0xd4a460;
				txt.text = StringConst.TEAM_PANEL_00011;
			});

			rsrLoader.addCallBack(skin.btnAdd, function (mc:MovieClip):void
			{
				txt = mc.txt as TextField;
				txt.textColor = 0xd4a460;
				txt.text = StringConst.TEAM_PANEL_0007;
			});

			rsrLoader.addCallBack(skin.btnRemove, function (mc:MovieClip):void
			{
				txt = mc.txt as TextField;
				txt.textColor = 0xd4a460;
				txt.text = StringConst.TEAM_PANEL_0008;
			});

			rsrLoader.addCallBack(skin.btnPromote, function (mc:MovieClip):void
			{
				txt = mc.txt as TextField;
				txt.textColor = 0xd4a460;
				txt.text = StringConst.TEAM_PANEL_0009;
			});

			rsrLoader.addCallBack(skin.btnLeave, function (mc:MovieClip):void
			{
				txt = mc.txt as TextField;
				txt.textColor = 0xd4a460;
				txt.text = StringConst.TEAM_PANEL_00010;
			});
			_teamModel = new TeamItemModel(_skin.rolePreview.roleModel);


			TeamDataManager.instance.subItems.length = 0;
			var mcItem:MovieClip;
			for (i = 1; i < 6; i++)
			{
				mcItem = _skin["item" + i] as MovieClip;
				mcItem.mouseEnabled = false;
				mcItem.subItem.mouseEnabled = false;

				var item:SubItemInfo = new SubItemInfo(_skin["item" + i]);
				TeamDataManager.instance.subItems.push(item);
				item.callBack = dealClick;
				skin["item" + i].visible = false;
			}
			var adapt:LoaderCallBackAdapter = new LoaderCallBackAdapter();
			adapt.addCallBack(rsrLoader, function ():void
			{
				handlerFirstData();
				adapt = null;
			}, _skin.item1.subItem, _skin.item2.subItem, _skin.item3.subItem, _skin.item4.subItem, _skin.item5.subItem);

			rsrLoader.addCallBack(_skin.check1, function (mc:MovieClip):void
			{
				check1Loaded = true;
				if (check1Loaded && check2Loaded)
				{
					refreshSetting();
				}
				var tipVo:TipVO = new TipVO();
				tipVo.tipType = ToolTipConst.TEXT_TIP;
				tipVo.tipData = HtmlUtils.createHtmlStr(0xd4a460, StringConst.TEAM_TIP_0006);
				ToolTipManager.getInstance().hashTipInfo(mc, tipVo);
				ToolTipManager.getInstance().attach(mc);
			});

			rsrLoader.addCallBack(_skin.check2, function (mc:MovieClip):void
			{
				check2Loaded = true;
				if (check1Loaded && check2Loaded)
				{
					refreshSetting();
				}
				var tipVo1:TipVO = new TipVO();
				tipVo1.tipType = ToolTipConst.TEXT_TIP;
				tipVo1.tipData = HtmlUtils.createHtmlStr(0xd4a460, StringConst.TEAM_TIP_0007);
				ToolTipManager.getInstance().hashTipInfo(mc, tipVo1);
				ToolTipManager.getInstance().attach(mc);
			});

		}

		private function dealClick(data:TeamInfoVo):void
		{
			var dataManager:TeamDataManager = TeamDataManager.instance;
			dataManager.selectTeamInfo = data;

			var subsItem:Vector.<SubItemInfo> = dataManager.subItems;
			for (var i:int = 0, len:int = subsItem.length; i < len; i++)
			{
				subsItem[i].item.subItem.selected = false;
				if (data == subsItem[i].data)
				{
					subsItem[i].item.subItem.selected = true;
					_selectIndex = i;
				}
			}

			if (_skin && data)
			{
				_skin.rolePreview.nameTxt.text = data.name;
				_skin.rolePreview.factionTxt.text = data.factionName;

				if (_teamModel)
				{
					_teamModel.cid = data.cid;
					_teamModel.sid = data.sid;
					var self:IFirstPlayer = EntityLayerManager.getInstance().firstPlayer;
					if (data.cid == self.cid && data.sid == self.sid)
					{
						_teamModel.changeModel();
						return;
					}
					TeamDataManager.instance.sendOtherPlayerInfo(data.cid, data.sid);
				}
			}
		}

		private function dealTip():void
		{
			var tipVO:TipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			tipVO.tipData = getTipExp;
			ToolTipManager.getInstance().hashTipInfo(_skin.attackAdd, tipVO);
			ToolTipManager.getInstance().attach(_skin.attackAdd);

			tipVO = new TipVO();
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			tipVO.tipData = getTipAttack;
			ToolTipManager.getInstance().hashTipInfo(_skin.expAdd, tipVO);
			ToolTipManager.getInstance().attach(_skin.expAdd);
		}

		/**攻击加成*/
		private function getTipAttack():String
		{
			var teamVec:Vector.<TeamInfoVo> = TeamDataManager.instance.teamInfoVec;
			var html:String = "";
			html = HtmlUtils.createHtmlStr(0xffcc00, StringConst.TEAM_TIP_0001, 12, false, 5) + "<br>";
			html += HtmlUtils.createHtmlStr(0xd4a460, StringConst.TEAM_TIP_0002, 12, false, 5) + "<br>";
			html += HtmlUtils.createHtmlStr(0x00ffe5, StringUtil.substitute(StringConst.TEAM_TIP_0003, (teamVec.length - 1), teamVec.length), 12, false, 5);
			return html;
		}

		/**经验加成*/
		private function getTipExp():String
		{
			var teamVec:Vector.<TeamInfoVo> = TeamDataManager.instance.teamInfoVec;
			var html:String = "";
			html = HtmlUtils.createHtmlStr(0xffcc00, StringConst.TEAM_TIP_0004, 12, false, 5) + "<br>";
			html += HtmlUtils.createHtmlStr(0xd4a460, StringConst.TEAM_TIP_0005, 12, false, 5) + "<br>";
			html += HtmlUtils.createHtmlStr(0x00ffe5, StringUtil.substitute(StringConst.TEAM_TIP_0003, ((teamVec.length - 1) * 2), teamVec.length), 12, false, 5);
			return html;
		}

		public function update(proc:int = 0):void
		{
			switch (proc)
			{
				case GameServiceConstants.SM_QUERY_OTHER_PLAYER_INFO:
					changeModel();
					break;
				default :
					break;
			}
		}

		private function changeModel():void
		{
			if (_teamModel)
			{
				_teamModel.changeModel();
			}
		}
	}
}
