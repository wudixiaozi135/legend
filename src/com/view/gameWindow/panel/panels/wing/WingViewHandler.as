package com.view.gameWindow.panel.panels.wing
{
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.configData.cfgdata.WingUpgradeCfgData;
    import com.model.consts.EffectConst;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.mainUi.subuis.onlineReward.OnlineRewardDataManager;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.guideSystem.GuideSystem;
    import com.view.gameWindow.panel.panels.guideSystem.action.GuideAction;
    import com.view.gameWindow.panel.panels.guideSystem.constants.GuidesID;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.cell.ConstEquipCell;
    import com.view.gameWindow.panel.panels.roleProperty.cell.EquipData;
    import com.view.gameWindow.tips.rollTip.RollTipMediator;
    import com.view.gameWindow.tips.rollTip.RollTipType;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.ObjectUtils;
    import com.view.gameWindow.util.UIEffectLoader;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;
    import com.view.gameWindow.util.propertyParse.PropertyData;

    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    import mx.utils.StringUtil;

    /**
     * Created by Administrator on 2015/3/19.
     */
    public class WingViewHandler implements IObserver
    {
        private var _skin:McPanelWing;
        private var _panel:PanelWing;
//        private var _leftWingModel:WingModel;
//        private var _rightWingModel:WingModel;

        private var _leftWingModel:UIEffectLoader;
        private var _rightWingModel:UIEffectLoader;


        private var _currentCfg:WingUpgradeCfgData;
        private var _currentId:int;

        private var _timeId:uint = 0;
        private var _delay:int = 500;
		
		private var guide:GuideAction;
		private var closeGuide:GuideAction;

        public function WingViewHandler(panel:PanelWing)
        {
            _panel = panel;
            _skin = _panel.skin as McPanelWing;
//            _leftWingModel = new WingModel(_skin.leftContainer);
//            _rightWingModel = new WingModel(_skin.rightContainer);


            _skin.progressFg.mask = _skin.mcMask;
            _skin.mcMask.width = 0;

            initCfg();
            init();

            RoleDataManager.instance.attach(this);
            OnlineRewardDataManager.instance.attach(this);
            PanelWingDataManager.instance.attach(this);
            BagDataManager.instance.attach(this);
            updateBtnState();
        }

        private function initCfg():void
        {
            var bodyPart:int = ConstEquipCell.getRoleEquipSlot(ConstEquipCell.TYPE_CHIBANG);
            var equipCfg:EquipCfgData = RoleDataManager.instance.getEquipCfgBySlot(bodyPart);
            var currentId:int = equipCfg ? equipCfg.id : PanelWingDataManager.WING_MIN_ID;
            _currentCfg = ConfigDataManager.instance.wingUpgradeCfg(currentId);
            if (_currentCfg)
            {
                _currentId = _currentCfg.id;
            } else
            {
                _currentId = -1;
                _panel.setHight(false);
            }
        }

        public function refresh():void
        {
            var equipCfg:EquipCfgData;
            if (_currentCfg)
            {
                equipCfg = ConfigDataManager.instance.equipCfgData(_currentCfg.id);
            }

            if (equipCfg)
            {
                var attrs:Vector.<String> = new Vector.<String>();
                attrs.push(equipCfg.attr);
                var property:PropertyData;
                if (equipCfg && attrs.length > 0)
                {
                    var propertys:Vector.<PropertyData> = CfgDataParse.getTAttrStringArray(attrs, true);
                    property = propertys[0];
                    _skin.txtAttack.text = property.name + ":";
                    _skin.txtAttackValue.text = property.value + "-" + property.value1;

                    property = propertys[1];
                    _skin.txtPattack.text = property.name + ":";
                    _skin.txtPattackValue.text = property.value + "-" + property.value1;

                    property = propertys[2];
                    _skin.txtMdefend.text = property.name + ":";
                    _skin.txtMdefendValue.text = property.value + "-" + property.value1;

                    updateItemCount();
                    var equipData:EquipData = RoleDataManager.instance.getEquipCellDataById(equipCfg.id);
                    if (equipData && equipData.memEquipData)
                    {
                        _skin.txtProgressValue.text = equipData.memEquipData.blessValue.toString();
                    }
                    updateProgress();
                }

                var currentFrame:int = 0;
                if (_currentCfg)
                {
                    currentFrame = _currentCfg.upgrade <= 0 ? 1 : _currentCfg.upgrade;
                    _skin.txtCoinCost.text = _currentCfg.cost_coin.toString();
                    _skin.leftName.gotoAndStop(currentFrame);
                    _skin.leftTitle.gotoAndStop(currentFrame);
                    destroyLeftModel();
                    _leftWingModel = new UIEffectLoader(_skin.leftContainer, 0, 0, 1, 1, EffectConst.RES_WING_EFFECT + currentFrame + ResourcePathConstants.POSTFIX_SWF);
                } else
                {
                    currentFrame = PanelWingDataManager.WING_MAX_UPGRADE;
                    _skin.txtCoinCost.text = "0";
                    _skin.leftName.gotoAndStop(currentFrame);
                    _skin.leftTitle.gotoAndStop(currentFrame);
                }
            }

            if (_currentCfg)
            {
                var nextWing:WingUpgradeCfgData = ConfigDataManager.instance.wingUpgradeCfg(_currentCfg.next_id);
                var nextCfg:EquipCfgData = ConfigDataManager.instance.equipCfgData(_currentCfg.next_id);
                updateTips(nextCfg);
                if (nextCfg)
                {
                    if (nextWing && nextWing.upgrade > 0)
                    {
                        destroyRightModel();
                        _rightWingModel = new UIEffectLoader(_skin.rightContainer, 0, 0, 1, 1, EffectConst.RES_WING_EFFECT + nextWing.upgrade + ResourcePathConstants.POSTFIX_SWF);
                        _skin.rightName.gotoAndStop(nextWing.upgrade);
                        _skin.rightTitle.gotoAndStop(nextWing.upgrade);
                    } else
                    {
                        _skin.rightName.visible = false;
                        _skin.rightTitle.visible = false;
                    }
                    ObjectUtils.gray(_skin.btnStart, false);
                    ObjectUtils.gray(_skin.btnAuto, false);
                    ObjectUtils.gray(_skin.btnCheck, false);
                    _skin.btnStart.mouseEnabled = true;
                    _skin.btnAuto.mouseEnabled = true;
                    _skin.btnCheck.mouseEnabled = true;
                } else
                {
                    _skin.rightName.visible = false;
                    _skin.rightTitle.visible = false;
                    destroyRightModel();

                    ObjectUtils.gray(_skin.btnStart);
                    ObjectUtils.gray(_skin.btnAuto);
                    ObjectUtils.gray(_skin.btnCheck);
                    _skin.btnStart.mouseEnabled = false;
                    _skin.btnAuto.mouseEnabled = false;
                    _skin.btnCheck.mouseEnabled = false;
                }
            }
        }

        private function destroyRightModel():void
        {
            if (_rightWingModel)
            {
                _rightWingModel.destroy();
                _rightWingModel = null;
            }
        }

        private function destroyLeftModel():void
        {
            if (_leftWingModel)
            {
                _leftWingModel.destroy();
                _leftWingModel = null;
            }
        }
        private function updateTips(equipCfg:EquipCfgData):void
        {
            if (_skin.mcTip)
            {
                ToolTipManager.getInstance().detach(_skin.mcTip);
                if (equipCfg)
                {
                    var msg:String = "";
                    var space:String = "    ";
                    var title:String = HtmlUtils.createHtmlStr(0xd6802b, space + StringConst.WING_020, 14, true, 8, 'SimSun', false) + "\n";
                    var attrs:Vector.<String> = new Vector.<String>();
                    attrs.push(equipCfg.attr);
                    if (equipCfg && attrs.length > 0)
                    {
                        var property:PropertyData;
                        var propertys:Vector.<PropertyData> = CfgDataParse.getTAttrStringArray(attrs, true);
                        for (var i:int = 0, len:int = propertys.length; i < len; i++)
                        {
                            property = propertys[i];
                            msg += HtmlUtils.createHtmlStr(0xd6802b, property.name + "：   ", 13, false, 5, 'SimSun', false);
                            msg += HtmlUtils.createHtmlStr(0xffffff, property.value + "-" + property.value1 + space, 13, false, 5, 'SimSun', false) + "<br>";
                        }
                        ToolTipManager.getInstance().attachByTipVO(_skin.mcTip, ToolTipConst.TEXT_TIP, title + msg);
                    }
                } else
                {
                    ToolTipManager.getInstance().detach(_skin.mcTip);
                }
            }
        }
        
        private function updateProgress():void
        {
            var bless:int = 0;
            if (_currentCfg)
            {
                var equipData:EquipData = RoleDataManager.instance.getEquipCellDataById(_currentCfg.id);
                if (equipData && equipData.memEquipData)
                {
                    var blessValue:int = equipData.memEquipData.blessValue;
//                    _skin.txtProgressValue.text = blessValue.toString() + "/" + _currentCfg.max_bless.toString();
                    _skin.txtProgressValue.text = blessValue.toString();
                    _skin.mcMask.scaleX = (blessValue / _currentCfg.max_bless);
                    bless = blessValue;
                }
            } else
            {
                _skin.txtProgressValue.text = "0";
                _skin.mcMask.scaleX = 0;
                bless = 0;
            }
            ToolTipManager.getInstance().detach(_skin.mcProgressTip);
            ToolTipManager.getInstance().attachByTipVO(_skin.mcProgressTip, ToolTipConst.TEXT_TIP, createTips(bless));
        }

        private function createTips(value:int):String
        {
            var msg:String;
            var htmlStr:String = HtmlUtils.createHtmlStr(0xe5892e, StringConst.WING_TIP_001) + HtmlUtils.createHtmlStr(0x00ff00, value.toString());
            msg = htmlStr;
            msg += "\n";

            htmlStr = HtmlUtils.createHtmlStr(0xff0000, StringConst.WING_TIP_002);
            msg += htmlStr;
            msg += "\n";

            htmlStr = HtmlUtils.createHtmlStr(0xe5892e, StringConst.WING_TIP_003);
            msg += htmlStr;
            msg += "\n";

            htmlStr = HtmlUtils.createHtmlStr(0x7b6856, StringConst.WING_TIP_004);
            msg += htmlStr;
            msg += "\n";

            htmlStr = HtmlUtils.createHtmlStr(0xff0000, StringConst.WING_TIP_005);
            msg += htmlStr;
            msg += "\n";

            htmlStr = HtmlUtils.createHtmlStr(0x7b6856, StringConst.WING_TIP_006);
            msg += htmlStr;
            return msg;
        }


        private function init():void
        {
            var color:uint = 0xffe1aa;
            _skin.txtName.mouseEnabled = false;
            _skin.txtName.textColor = color;
            _skin.txtName.text = StringConst.WING_001;


            ///攻击 物防 魔防
            color = 0xa56238;
            _skin.txtAttack.mouseEnabled = false;
            _skin.txtAttack.textColor = color;
            _skin.txtAttack.text = StringConst.WING_007;

            _skin.txtPattack.mouseEnabled = false;
            _skin.txtPattack.textColor = color;
            _skin.txtPattack.text = StringConst.WING_008;

            _skin.txtMdefend.mouseEnabled = false;
            _skin.txtMdefend.textColor = color;
            _skin.txtMdefend.text = StringConst.WING_009;

            color = 0xffffff;
            _skin.txtAttackValue.mouseEnabled = false;
            _skin.txtAttackValue.textColor = color;

            _skin.txtPattackValue.mouseEnabled = false;
            _skin.txtPattackValue.textColor = color;

            _skin.txtMdefendValue.mouseEnabled = false;
            _skin.txtMdefendValue.textColor = color;

            color = 0xffcc00;
            _skin.txtBless.mouseEnabled = false;
            _skin.txtBless.textColor = color;
            _skin.txtBless.text = StringConst.WING_002;

            _skin.txtProgressValue.textColor = color;
            _skin.txtProgressValue.text = "0";
            _skin.txtProgressValue.mouseEnabled = false;

            color = 0xd4a460;
            _skin.txtMaterial.textColor = color;
            _skin.txtMaterial.text = StringConst.WING_004;
            var cfg:WingUpgradeCfgData = ConfigDataManager.instance.wingUpgradeCfg(PanelWingDataManager.WING_MIN_ID);
            var name:String = ConfigDataManager.instance.itemCfgData(cfg.cost_item_id).name;
            var msg:String = HtmlUtils.createHtmlStr(0xebab5c, StringUtil.substitute(StringConst.WING_013, name, cfg.cost_gold));
            ToolTipManager.getInstance().attachByTipVO(_skin.txtMaterial, ToolTipConst.TEXT_TIP, msg);

            _skin.txtLabel.mouseEnabled = false;
            _skin.txtLabel.textColor = color;
            _skin.txtLabel.text = StringConst.WING_003;

            color = 0xffe1aa;
            _skin.txtStart.mouseEnabled = false;
            _skin.txtStart.textColor = color;
            _skin.txtStart.text = StringConst.WING_005;

            _skin.txtAuto.mouseEnabled = false;
            _skin.txtAuto.textColor = color;
            _skin.txtAuto.text = StringConst.WING_006;

            _skin.mcMask.mouseEnabled = false;
            _skin.mcMask.mouseChildren = false;

            var vo:TipVO = new TipVO();
            vo.tipType = ToolTipConst.ITEM_BASE_TIP;
            vo.tipData = ConfigDataManager.instance.itemCfgData(cfg.cost_item_id);
            ToolTipManager.getInstance().hashTipInfo(_skin.mcWing, vo);
            ToolTipManager.getInstance().attach(_skin.mcWing);
            vo = null;
            msg = null;
            cfg = null;
            name = null;
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.SM_CHR_INFO)
            {
                updateProgress();
                updateBtnState();
            } else if (proc == GameServiceConstants.CM_WING_UPGRADE)
            {
                checkIsAuto();
                updateCfg();
            }
            else if (proc == GameServiceConstants.SM_ACTIVATE_REWARD_GET)
            {
                updateBtnState();
            } else if (proc == GameServiceConstants.SM_BAG_ITEMS)
            {
                updateItemCount();
            }
        }

        private function checkIsAuto():void
        {
            if (_panel.mouseHandler)
            {
                if (PanelWingDataManager.isAuto)
                {
                    var nextCurrent:int = PanelWingDataManager.instance.nextWingId;
                    if (_currentCfg)
                    {
                        if (nextCurrent != _currentCfg.id)
                        {
                            clearTimeout(_timeId);
                            PanelWingDataManager.isAuto = false;
                            _skin.txtAuto.text = StringConst.WING_006;
                            return;
                        }

                        _timeId = setTimeout(function ():void
                        {
                            _panel.mouseHandler.startHandler();
                            clearTimeout(_timeId);
                        }, _delay);
                    } else
                    {
                        clearTimeout(_timeId);
                    }
                }
            }
        }

        private function updateItemCount():void
        {
            if (_currentCfg)
            {
                var color:uint = 0;
                var itemCount:int = BagDataManager.instance.getItemNumById(_currentCfg.cost_item_id, -1);
                color = itemCount < _currentCfg.cost_item_num ? 0xff0000 : 0xffffff;
                _skin.txtWingCost.htmlText = HtmlUtils.createHtmlStr(color, itemCount.toString()).concat(HtmlUtils.createHtmlStr(0xffffff, "/" + _currentCfg.cost_item_num));

                var moneyNum:int = BagDataManager.instance.coinBind + BagDataManager.instance.coinUnBind;
                color = moneyNum < _currentCfg.cost_coin ? 0xff0000 : 0x00ff00;
                _skin.txtCoinCost.textColor = color;
                if (itemCount > _currentCfg.cost_item_num && moneyNum > _currentCfg.cost_coin)
                {
                    _panel.setStartHight(true);
                } else
                {
                    _panel.setStartHight(false);
                }
            } else
            {
                _skin.txtWingCost.text = "0/0";
                _panel.setStartHight(false);
            }
        }

        private function updateCfg():void
        {
            var nextCurrent:int = PanelWingDataManager.instance.nextWingId;
            if (_currentCfg)
            {
                RollTipMediator.instance.showRollTip(RollTipType.PROPERTY_WING_BLESS, HtmlUtils.createHtmlStr(0xffcc00, "+" + _currentCfg.add_bless, 20));
                if (nextCurrent > 0 && nextCurrent != _currentCfg.id)
                {
                    var currentName:String = _currentCfg.name;
                    var currentGrade:int = _currentCfg.upgrade;
                    RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, StringUtil.substitute(StringConst.WING_016, currentName));

                    _currentCfg = ConfigDataManager.instance.wingUpgradeCfg(nextCurrent);
                    _currentId = _currentCfg ? _currentCfg.id : -1;
                    refresh();
                }
            } else
            {
                _currentId = -1;
            }
        }

		private function showGuide(value:Boolean):void
		{
			if(value)
			{
				if(!guide)
				{
					guide = GuideSystem.instance.createAction(GuidesID.WING);
					if(guide)
					{
						guide.init();
						guide.act();
						guide.check();
					}
				}
			}
			else
			{
				if(guide)
				{
					guide.destroy();
					guide = null;
				}
			}
		}
		
		public function showCloseGuide(value:Boolean):void
		{
			if(value)
			{
				if(guide)
				{
					guide.destroy();
					guide = null;
				}
				
				if(!closeGuide)
				{
					closeGuide = GuideSystem.instance.createAction(GuidesID.WING_CLOSE);
					if(closeGuide)
					{
						closeGuide.init();
						closeGuide.act();
						closeGuide.check();
					}
				}
			}
			else
			{
				if(closeGuide)
				{
					closeGuide.destroy();
					closeGuide = null;
				}
			}
		}
		
        private function updateBtnState():void
        {
            var activeWing:int = OnlineRewardDataManager.instance.activeWing;
            if (activeWing == 0)
            {
                _skin.btnActive.visible = false;
				showGuide(false);
                var bodyPart:int = ConstEquipCell.getRoleEquipSlot(ConstEquipCell.TYPE_CHIBANG);
                var equipCfg:EquipCfgData = RoleDataManager.instance.getEquipCfgBySlot(bodyPart);
                if (equipCfg)
                {//如果角色身上有翅膀已经激活
                    setVisible(true);
                    activeState(true);
                } else
                {
                    setVisible(false);
                    activeState(false);
                }
            } else
            {
                _skin.btnActive.visible = true;
				showGuide(true);
                setVisible(false);
                activeState(false);
            }
        }

        private function activeState(bool:Boolean):void
        {
            if (_skin.leftContainer)
            {
                ObjectUtils.gray(_skin.leftContainer, !bool);
            }
        }
        private function setVisible(bool:Boolean):void
        {
            _skin.txtStart.visible = bool;
            _skin.btnStart.visible = bool;

            _skin.txtAuto.visible = bool;
            _skin.btnAuto.visible = bool;

            _skin.btnCheck.visible = bool;
            _skin.txtMaterial.visible = bool;
        }

        public function destroy():void
        {
			showGuide(false);
			showCloseGuide(false);
            BagDataManager.instance.detach(this);
            PanelWingDataManager.instance.detach(this);
            OnlineRewardDataManager.instance.detach(this);
            RoleDataManager.instance.detach(this);
            PanelWingDataManager.isAuto = false;
            if (_skin.mcProgressTip)
            {
                ToolTipManager.getInstance().detach(_skin.mcProgressTip);
            }
            if (_skin.mcTip)
            {
                ToolTipManager.getInstance().detach(_skin.mcTip);
            }
            if (_timeId)
            {
                clearTimeout(_timeId);
            }
            if (_skin.txtMaterial)
            {
                ToolTipManager.getInstance().detach(_skin.txtMaterial);
            }
            destroyLeftModel();
            destroyRightModel();
            if (_skin)
            {
                ToolTipManager.getInstance().detach(_skin.mcWing);
                _skin = null;
            }
            if (_panel)
            {
                _panel = null;
            }
        }

        public function get currentCfg():WingUpgradeCfgData
        {
            return _currentCfg;
        }

        public function get currentId():int
        {
            return _currentId;
        }
    }
}
