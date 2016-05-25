package com.view.gameWindow.panel.panels.vip.vipOpen
{
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.PeerageCfgData;
    import com.model.configData.cfgdata.VipCfgData;
    import com.model.consts.StringConst;
    import com.pattern.Observer.IObserver;
    import com.view.gameWindow.flyEffect.FlyEffectMediator;
    import com.view.gameWindow.panel.panels.vip.VipDataManager;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.NumPic;
    import com.view.gameWindow.util.ObjectUtils;
    import com.view.gameWindow.util.UtilItemParse;
    import com.view.gameWindow.util.cell.IconCellEx;
    import com.view.gameWindow.util.cell.ThingsData;
    import com.view.gameWindow.util.propertyParse.CfgDataParse;

    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.utils.Dictionary;

    /**
	 * 开通vip页显示处理类
	 * @author Administrator
	 */
    internal class TabVipOpenViewHandle implements IObserver
	{
		private var _tab:TabVipOpen;
		private var _skin:McVipOpen;
		private var _cells:Vector.<IconCellEx>;
		internal var isRewardCanGet:Boolean;
		/**显示可领奖励的vip等级*/
		internal var lv:String;
        private var _flyDatas:Array = [];
        private var _bmpsDic:Dictionary;
		public function TabVipOpenViewHandle(tab:TabVipOpen)
		{
			_tab = tab;
			_skin = _tab.skin as McVipOpen;
			init();
            _bmpsDic = new Dictionary(true);
            VipDataManager.instance.attach(this);
		}
		
		private function init():void
		{
			_cells = new Vector.<IconCellEx>(VipDataManager.TOTAL_REWARDS,true);
			var i:int,l:int = VipDataManager.TOTAL_REWARDS;
			for(i=0;i<l;i++) 
			{
				var mcReward:MovieClip = _skin["mcReward"+i] as MovieClip;
				var cell:IconCellEx = new IconCellEx(mcReward.parent,mcReward.x,mcReward.y,mcReward.width,mcReward.height);
				_cells[i] = cell;
				ToolTipManager.getInstance().attach(cell);
			}
		}
		/**刷新展示爵位相关信息*/
		internal function refreshPeerageShow():void
		{
			var peerage:int = _tab.mouseHandle.peerage;
			_skin.mcSign.gotoAndStop(peerage);
			_skin.mcWord.gotoAndStop(peerage);
			var desc:String = VipDataManager.instance.getPeerageDesc(peerage);
			var i:int,l:int;
			var htmlText:String = '';
			var descs:Array = CfgDataParse.pareseDes(desc,0xffe1aa,12);
			l = descs.length;
			for(i=0;i<l;i++)
			{
				htmlText += i != l-1 ? descs[i] + "\n" : descs[i];
			}
			var txtDesc:TextField = _skin.txtDesc;
			txtDesc.htmlText = htmlText;
			l = VipDataManager.TOTAL_WORDS;
			for (i = 0; i < l; i++) 
			{
				_skin["mcWordSign"+i].visible = i < txtDesc.numLines ? true : false;
			}
			//
			refreshBtnLR();
			//
			refreshBtnOpen();
		}
		
		internal function refreshBtnLR():void
		{
			var peerage:int = _tab.mouseHandle.peerage;
			var total:int = _tab.mouseHandle.total;
			if(peerage <= 1)
			{
				_skin.btnRight.visible = false;
			}
			else if(peerage >= total)
			{
				_skin.btnLeft.visible = false;
			}
			else
			{
				_skin.btnRight.visible = true;
				_skin.btnLeft.visible = true;
			}
		}
		/**刷新vip等级相关信息*/
		internal function refreshVipShow():void
		{
			_skin.btnGet.btnEnabled = true;
			var manager:VipDataManager = VipDataManager.instance;
			if(manager.lv == 0)
			{
				lv = (manager.lv+1)+"";
				isRewardCanGet = false;
			}
			else if(manager.lv == VipDataManager.MAX_LV)
			{
				lv = manager.lv+"";
				var isRewardGetted:Boolean = manager.isRewardGetted(manager.lv);
				if(isRewardGetted)
				{
					_skin.btnGet.btnEnabled = false;
					isRewardCanGet = false;
					var textField:TextField = _skin.btnGet.txt as TextField;
					if(textField)
					{
						textField.text = StringConst.VIP_PANEL_0010;
						textField.textColor = 0xd4a460;
					}
				}
				else
				{
					isRewardCanGet = true;
				}
			}
			else
			{
				var i:int,l:int = manager.lv;
				for(i=1;i<=l;i++)
				{
					isRewardGetted = manager.isRewardGetted(i);
					if(isRewardGetted && i == l)
					{
						lv = (i+1)+"";
						isRewardCanGet = false;
					}
					else if(!isRewardGetted)
					{
						lv = i+"";
						isRewardCanGet = true;
						break;
					}
				}
			}
			var numPic:NumPic = new NumPic();
			numPic.init("yellow_",lv,_skin.mcNumLayer);
			//
			var vipCfgData:VipCfgData = ConfigDataManager.instance.vipCfgData(int(lv));
			var gift:String = vipCfgData.gift;
			var rewards:Array = gift.split("|");
			l = VipDataManager.TOTAL_REWARDS;
			for(i=0;i<l;i++)
			{
				if(i < rewards.length)
				{
					var itemStrs:Array = UtilItemParse.getItemString(rewards[i]);
					var dt:ThingsData = new ThingsData();
					dt.id = itemStrs[3];
					dt.type = itemStrs[4];
					dt.count = itemStrs[2];
					IconCellEx.setItemByThingsData(_cells[i],dt);
				}
				else
				{
					_cells[i].setNull();
				}
			}
			//
			refreshBtnOpen();
		}
		
		internal function refreshBtnOpen():void
		{
			var manager:VipDataManager = VipDataManager.instance;
			var peerageCfgData:PeerageCfgData = manager.peerageCfgData;
			var peerage:int = _tab.mouseHandle.peerage;
			if(peerageCfgData && peerageCfgData.order >= peerage)
			{
				_skin.btnOpen.gotoAndStop(2);
			}
			else
			{
				_skin.btnOpen.gotoAndStop(1);
			}
		}

        public function storeBmps():void
		{
			var cell:IconCellEx;
            var bmp:Bitmap;
            for each(cell in _cells)
			{
                bmp = cell.getBitmap();
                if (bmp)
				{
                    bmp.width = bmp.height = 40;
                    bmp.visible = false;
                    bmp.name = cell.id.toString();
                    if (!_bmpsDic[bmp.name])
                    {
                        _bmpsDic[bmp.name] = bmp;
                        cell.addChild(bmp);
                    }
				}
			}
		}

        private function destroyBmp():void
        {
            if (_flyDatas && _flyDatas.length)
            {
                _flyDatas.forEach(function (element:Bitmap, index:int, arrar:Array):void
                {
                    if (element && element.parent)
                    {
                        element.parent.removeChild(element);
                        element = null;
                    }
                });
                _flyDatas.length = 0;
            }
            if (_bmpsDic)
            {
                ObjectUtils.forEach(_bmpsDic, function (bmp:Bitmap):void
                {
                    delete _bmpsDic[bmp.name];
                    bmp = null;
                });
            }
        }

        public function update(proc:int = 0):void
        {
            if (proc == GameServiceConstants.CM_VIP_GIFT_GET)
            {
                ObjectUtils.forEach(_bmpsDic, function (item:Bitmap):void
                {
                    _flyDatas.push(item);
                });

                if (_flyDatas && _flyDatas.length)
                {
                    FlyEffectMediator.instance.doFlyReceiveThings2(_flyDatas);
                    destroyBmp();
                }
            }
        }
		internal function destroy():void
		{
            if (_flyDatas)
            {
                destroyBmp();
                _flyDatas = null;
            }
            _bmpsDic = null;
            VipDataManager.instance.detach(this);
			var cell:IconCellEx;
			for each(cell in _cells) 
			{
				ToolTipManager.getInstance().detach(cell);
				cell.destroy();
			}
			_cells = null;
			_skin = null;
			_tab = null;
		}
    }
}