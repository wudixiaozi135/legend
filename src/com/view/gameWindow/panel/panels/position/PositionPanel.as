package com.view.gameWindow.panel.panels.position
{
    import com.greensock.TweenLite;
    import com.model.business.fileService.constants.ResourcePathConstants;
    import com.model.business.gameService.constants.GameServiceConstants;
    import com.model.configData.ConfigDataManager;
    import com.model.configData.cfgdata.EquipCfgData;
    import com.model.configData.cfgdata.PositionCfgData;
    import com.model.configData.cfgdata.PositionChopCfgData;
    import com.model.consts.StringConst;
    import com.model.consts.ToolTipConst;
    import com.model.gameWindow.rsr.RsrLoader;
    import com.view.gameWindow.common.HighlightEffectManager;
    import com.view.gameWindow.mainUi.MainUiMediator;
    import com.view.gameWindow.mainUi.subclass.McMainUIBottom;
    import com.view.gameWindow.mainUi.subuis.bottombar.BottomBar;
    import com.view.gameWindow.panel.panelbase.PanelBase;
    import com.view.gameWindow.panel.panels.bag.BagDataManager;
    import com.view.gameWindow.panel.panels.dungeon.TextFormatManager;
    import com.view.gameWindow.panel.panels.hero.HeroDataManager;
    import com.view.gameWindow.panel.panels.roleProperty.RoleDataManager;
    import com.view.gameWindow.tips.toolTip.TipVO;
    import com.view.gameWindow.tips.toolTip.ToolTipManager;
    import com.view.gameWindow.util.HtmlUtils;
    import com.view.gameWindow.util.LoaderCallBackAdapter;
    import com.view.gameWindow.util.UrlPic;
    import com.view.gameWindow.util.UtilItemParse;
    import com.view.gameWindow.util.UtilNumChange;
    import com.view.gameWindow.util.css.GameStyleSheet;
    
    import flash.display.MovieClip;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextFieldAutoSize;
    
    import mx.utils.StringUtil;

    public class PositionPanel extends PanelBase implements IPositionPanel
	{
		internal var _mcPosition:McPosition;
		internal var _mouseEvent:PositionPanelMouseEvent;
		internal var _page:int = 0;
		internal const DEALACHIEVE:String = "dealAchieve";
		internal const DEALJINGJICHANG:String = "dealJingjichang";
		internal const DEALTUCHENGZHENGBA:String = "dealTuchengzhengba";
		internal const DEALLIQUANSHANGCHENG:String = "dealLiquanshangcheng";
		private var _iconAnim:TweenLite;
		private var urlPic:UrlPic;
		private var _highlightEffect:HighlightEffectManager;
		private var _loadBtnJobOk:Boolean;
		private var _loadBtnGetOk:Boolean;
		private var _loadBtnGet2Ok:Boolean;
		private var _loadBtnDoubleOk:Boolean;
		private var _loadBtnFreeOk:Boolean;
        private var _effectHandler:RolePositionEffectHandler;

        private var heroPositionLevel:int=-1;
        private var oldUrl:String;
		
		public function PositionPanel()
		{
			RoleDataManager.instance.attach(this);
			PositionDataManager.instance.attach(this);
			BagDataManager.instance.attach(this);
			HeroDataManager.instance.attach(this);
			super();
		}
		
		override protected function initSkin():void
		{
			_skin = new McPosition();
			addChild(_skin);
			_mcPosition = _skin as McPosition;
			setTitleBar(_mcPosition.mcTitleBar);
			_highlightEffect = new HighlightEffectManager();
			_mouseEvent = new PositionPanelMouseEvent(this);
			_mouseEvent.init();
			_effectHandler = new RolePositionEffectHandler(this);
			_mcPosition.chop.visible = false;
			urlPic = new UrlPic(skin.icon.contain);
			_skin.txtValue_04.autoSize = TextFieldAutoSize.CENTER;
			_iconAnim = TweenLite.to(_mcPosition.icon,1,{y:_mcPosition.y + _mcPosition.icon.y - 8,repeat:-1,onComplete:reverseTween, onReverseComplete:restartTween});
		}
		
		override protected function initData():void
		{
			initText();
			update(GameServiceConstants.SM_POSITION_INFO);
		}
		
		private function reverseTween():void
		{
			if(_iconAnim)
			{
				_iconAnim.reverse();
			}
		}
		private function restartTween():void 
		{
			if(_iconAnim)
			{
				_iconAnim.restart();
			}
		}
		
		override public function update(proc:int=0):void
		{
			var _nextPositionChopCfg:PositionChopCfgData=ConfigDataManager.instance.positionChopCfgData(PositionDataManager.instance.rolePositionLevel+1);
			if(_nextPositionChopCfg && _nextPositionChopCfg.position_level <= RoleDataManager.instance.position)
			{
				_mcPosition.btnMc.btnPositionChop.btnEnabled = true;
				_mcPosition.txt_03.textColor = 0xd4a460;
			}
			showTxtTips(_nextPositionChopCfg);
			
			refreshChopTxt();
			
			refreshContent();
			
			refreshBottom();
			
			refreshBtn();
		}
		
		private function refreshBtn():void
		{
			// TODO Auto Generated method stub
			if(RoleDataManager.instance.position>=12)
			{
				_mcPosition.btnMc.visible = _mcPosition.txt_03.visible = true;
			}else
			{
				_mcPosition.btnMc.visible = _mcPosition.txt_03.visible = false;
			}
		}
		
		public function refreshBottom():void
		{
			refreshAwardState();
			refreshSalaryTxt();
		}
		
		public function refreshContent():void
		{
			var config:PositionCfgData =getCfg();
			if(config==null)return;
			showTips(config);
			refreshIcon(config);
			refreshPositionValue(config);
			refreshPageBtnSate(config);
			setBtnGetState(config);
		}
		
		public function getCfg():PositionCfgData
		{
			var position:int = PositionDataManager.instance.position
			var curCfg:PositionCfgData = ConfigDataManager.instance.positionCfgData(position);
			var nextCfg:PositionCfgData = ConfigDataManager.instance.positionCfgData(position+1);
			var config:PositionCfgData ;
			if(curCfg&&PositionDataManager.instance.hero_chopid == curCfg.hero_chopid
				&&PositionDataManager.instance.role_chopid==curCfg.chopid&&nextCfg)
			{
				config = ConfigDataManager.instance.positionCfgData(position+_page+1);
			}else
			{
				config = ConfigDataManager.instance.positionCfgData(position+_page);
			}
			config=config||ConfigDataManager.instance.positionCfgData(position  +1);
			return config;
		}
		
		private function refreshIcon(curPagePositionCfgData:PositionCfgData):void
		{
			var url:String = curPagePositionCfgData.icon;
			if(url!=oldUrl)
			{
				oldUrl=curPagePositionCfgData.icon;
				while(skin.icon.contain.numChildren > 0)
				{
					skin.icon.contain.removeChildAt(0);
				}
				url=ResourcePathConstants.IMAGE_POSITION_FOLDER_LOAD + 	url + ResourcePathConstants.POSTFIX_PNG;
				urlPic.load(url);
			}
		}
		
		private function refreshPageBtnSate(cfg:PositionCfgData):void
		{
			var positionCfg:PositionCfgData;
			positionCfg = ConfigDataManager.instance.positionCfgData(cfg.level-1);
			if(!positionCfg)
			{
				_mcPosition.btnLeft.btnEnabled = false;
			}else
			{
				_mcPosition.btnLeft.btnEnabled = true;
			}
			positionCfg = ConfigDataManager.instance.positionCfgData(cfg.level+1);
			if(!positionCfg || positionCfg.level - PositionDataManager.instance.position > 1)
			{
				_mcPosition.btnRight.btnEnabled = false;
			}else
			{
				_mcPosition.btnRight.btnEnabled = true;
			}
		}
		
		public function refreshAwardState():void
		{
			if(_loadBtnJobOk==false||_loadBtnDoubleOk==false||_loadBtnFreeOk==false)
			{
				return ;
			}
			var position:int = PositionDataManager.instance.position;
			var positionCfgData:PositionCfgData = ConfigDataManager.instance.positionCfgData(position);
			var _nextPositionCfg:PositionCfgData = ConfigDataManager.instance.positionCfgData(position+1);
			
			if(_nextPositionCfg&&PositionDataManager.instance.position == 0)
			{
				if(RoleDataManager.instance.merit >= _nextPositionCfg.exploit_cost)
				{
					_mcPosition.BtnJob.visible=true;
					_mcPosition.txt_11.visible=true;
					_highlightEffect.show(_mcPosition.BtnJob.parent,_mcPosition.BtnJob);
				}
			}
			else if( positionCfgData.chopid == PositionDataManager.instance.role_chopid && 
				positionCfgData.hero_chopid == PositionDataManager.instance.hero_chopid && 
				_nextPositionCfg && RoleDataManager.instance.merit >= _nextPositionCfg.exploit_cost)
			{
				_mcPosition.BtnJob.visible=true;
				_mcPosition.txt_11.visible=true;
				_highlightEffect.show(_mcPosition.BtnJob.parent,_mcPosition.BtnJob);
			}
			else
			{
				_mcPosition.BtnJob.visible=false;
				_mcPosition.txt_11.visible=false;
				_highlightEffect.hide(_mcPosition.BtnJob);
			}
			
			if(positionCfgData&&PositionDataManager.instance.isget == PositionType.NOGET)
			{
				if(positionCfgData.gift_item!="" &&BagDataManager.instance.goldUnBind>=positionCfgData.double_cost_gold )
				{
					_mcPosition.btnDouble.visible=true;
					_mcPosition.txt_09.visible = true;
//					_mcPosition.btnFree.visible=false;
//					_mcPosition.txt_10.visible = false;
					_highlightEffect.show(_mcPosition.btnDouble.parent,_mcPosition.btnDouble);
//					_highlightEffect.hide(_mcPosition.btnFree);
				}
				else
				{
					_mcPosition.btnDouble.visible=false;
					_mcPosition.txt_09.visible = false;
					_highlightEffect.hide(_mcPosition.btnDouble);
				}
				
				if(_mcPosition.btnDouble.visible==false)
				{
					_highlightEffect.show(_mcPosition.btnFree.parent,_mcPosition.btnFree);
				}
				
				if(positionCfgData.gift_bind_coin>0)
				{
					_mcPosition.btnFree.visible=true;
					_mcPosition.txt_10.visible = true;
				}else
				{
					_mcPosition.btnFree.visible=false;
					_mcPosition.txt_10.visible = false;
				}
					

//					_highlightEffect.hide(_mcPosition.btnDouble);
//					_mcPosition.btnDouble.visible=false;
//					_mcPosition.txt_09.visible = false;
//				}
			}
			else
			{
				_highlightEffect.hide(_mcPosition.btnDouble);
				_highlightEffect.hide(_mcPosition.btnFree);
				_mcPosition.btnDouble.visible=false;
				_mcPosition.txt_09.visible = false;
				_mcPosition.btnFree.visible=false;
				_mcPosition.txt_10.visible = false;
			}
		}
		
		private function setBtnGetState(curPagePositionCfgData:PositionCfgData):void
		{
			if(_loadBtnGetOk==false||_loadBtnGet2Ok==false)
			{
				return ;
			}
			var position:int = PositionDataManager.instance.position;
			var curPositionCfg:PositionCfgData = ConfigDataManager.instance.positionCfgData(position);
			var nextPositionCfg:PositionCfgData = ConfigDataManager.instance.positionCfgData(curPagePositionCfgData.level+1);
			
			if(curPagePositionCfgData )
			{
				if(curPositionCfg&&curPositionCfg.level == curPagePositionCfgData.level)
				{
					if(PositionDataManager.instance.role_chopid == curPagePositionCfgData.chopid)
					{
						setBtnGet(true);
					}
					else
					{
						setBtnGet(false);
					}
					if(PositionDataManager.instance.hero_chopid == curPagePositionCfgData.hero_chopid)
					{
						setBtnGet2(true);
//						return;
					}
					else
					{
						setBtnGet2(false);
					}
				}
				else if(curPositionCfg&&curPagePositionCfgData.level < curPositionCfg.level)
				{
					setBtnGet(true);
					setBtnGet2(true);
//					return;
				}
				else
				{
					setBtnGet(false);
					setBtnGet2(false);
				}
				
				if( _mcPosition.btnGet.selected == false &&
					position>=curPagePositionCfgData.level&&
					(RoleDataManager.instance.reincarn > curPagePositionCfgData.change_count || (RoleDataManager.instance.reincarn == curPagePositionCfgData.change_count && RoleDataManager.instance.lv >= curPagePositionCfgData.chr_level)))
				{
					//_highlightEffect.show(_mcPosition.btnGet.parent,_mcPosition.btnGet);
					_mcPosition.btnGetEffect.visible = true;
					_mcPosition.btnGetEffect.play();
				}
				else
				{
					_mcPosition.btnGetEffect.visible = false;
					_mcPosition.btnGetEffect.stop();
					//_highlightEffect.hide(_mcPosition.btnGet);
				}
				if(_mcPosition.btnGet2.selected == false &&
					position>=curPagePositionCfgData.level&&
					(HeroDataManager.instance.grade > curPagePositionCfgData.hero_groude || (HeroDataManager.instance.grade == curPagePositionCfgData.hero_groude && HeroDataManager.instance.lv >= curPagePositionCfgData.hero_level)))
				{
					//_highlightEffect.show(_mcPosition.btnGet2.parent,_mcPosition.btnGet2);
					_mcPosition.btnGet2Effect.visible = true;
					_mcPosition.btnGet2Effect.play();
				}
				else
				{
					//_highlightEffect.hide(_mcPosition.btnGet2);
					_mcPosition.btnGet2Effect.visible = false;
					_mcPosition.btnGet2Effect.stop();
				}
			}	
		}
		
		private function setBtnGet(value:Boolean):void
		{
			_mcPosition.btnGet.selected = value;
			_mcPosition.btnGet.mouseEnabled = value?false:true;
		}
		
		private function setBtnGet2(value:Boolean):void
		{
			_mcPosition.btnGet2.selected = value;
			_mcPosition.btnGet2.mouseEnabled = value?false:true;
		}
		
		private function destroyEffect():void
		{
			_highlightEffect.hide(_mcPosition.BtnJob);
			_highlightEffect.hide(_mcPosition.btnGet);
			_highlightEffect.hide(_mcPosition.btnGet2);
			_highlightEffect.hide(_mcPosition.btnDouble);
			_highlightEffect.hide(_mcPosition.btnFree);
			_highlightEffect = null;
		}
		
		override public function setPostion():void
		{
            var mc:McMainUIBottom = (MainUiMediator.getInstance().bottomBar as BottomBar).skin as McMainUIBottom;
            if (mc)
            {
                var popPoint:Point = mc.localToGlobal(new Point(mc.btnCloset.x, mc.btnCloset.y));
                isMount(true, popPoint.x, popPoint.y);
            } 
			else
            {
                isMount(true);
            }
		}
		
		
		private function initText():void
		{
			_mcPosition.txt_00.text = StringConst.POSITION_PANEL_0001;
			TextFormatManager.instance.setTextFormat(_mcPosition.txt_00,0xffe1aa,false,true);
			_mcPosition.txt_01.htmlText =HtmlUtils.createHtmlStr(0x00ff00,StringConst.POSITION_PANEL_0002,12,false,2,"SimSun",true,"this");
			_mcPosition.txt_01.styleSheet=GameStyleSheet.linkStyle;
			_mcPosition.txt_02.htmlText = StringConst.POSITION_PANEL_0007;
			_mcPosition.txt_03.text = StringConst.POSITION_PANEL_0008;
			_mcPosition.txt_03.mouseEnabled = false;
			_mcPosition.txt_04.htmlText =HtmlUtils.createHtmlStr(0xffcc00,StringConst.POSITION_PANEL_0009,12,true);
			_mcPosition.txt_05.htmlText =HtmlUtils.createHtmlStr(0xffcc00,StringConst.POSITION_PANEL_0010,12,true);
			_mcPosition.txt_06.text = StringConst.POSITION_PANEL_0011;
			_mcPosition.txt_07.text = StringConst.POSITION_PANEL_0012;
			_mcPosition.txt_08.text = StringConst.POSITION_PANEL_0013;
			_mcPosition.txt_09.text = StringConst.POSITION_PANEL_0014;
			_mcPosition.txt_09.mouseEnabled = false;
			_mcPosition.txt_10.text = StringConst.POSITION_PANEL_0015;
			_mcPosition.txt_10.mouseEnabled = false;
			_mcPosition.txt_11.text = StringConst.POSITION_PANEL_0052;
			_mcPosition.txt_11.mouseEnabled = false;
			_mcPosition.chop.txt_11.text = StringConst.POSITION_PANEL_0016;
			_mcPosition.chop.txt_12.text = StringConst.POSITION_PANEL_0017;
			_mcPosition.chop.txt_13.text = StringConst.POSITION_PANEL_0018;
			_mcPosition.chop.txt_14.text = StringConst.POSITION_PANEL_0019;
			_mcPosition.chop.txt_15.text = StringConst.POSITION_PANEL_0020;
			_mcPosition.chop.txt_15.mouseEnabled = false;
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var loaderCallBackAdapter:LoaderCallBackAdapter = new LoaderCallBackAdapter();
			loaderCallBackAdapter.addCallBack(rsrLoader,function ():void
			{			
				_loadBtnGetOk = true;
				_loadBtnGet2Ok = true;
				refreshContent();
			},_mcPosition.btnLeft,_mcPosition.btnRight,_mcPosition.btnGet,_mcPosition.btnGet2);
		
			rsrLoader.addCallBack(_mcPosition.BtnJob,function(mc:MovieClip):void
			{
				_loadBtnJobOk = true;
				refreshAwardState();
			});
			rsrLoader.addCallBack(_mcPosition.btnMc.btnPositionChop,function(mc:MovieClip):void
			{
				var _nextPositionChopCfg:PositionChopCfgData=ConfigDataManager.instance.positionChopCfgData(PositionDataManager.instance.rolePositionLevel+1);
				if(!_nextPositionChopCfg || _nextPositionChopCfg.position_level > RoleDataManager.instance.position)
				{
					_mcPosition.btnMc.btnPositionChop.btnEnabled = false;
					_mcPosition.txt_03.textColor = 0x6a6a6a;
				}
			});
			rsrLoader.addCallBack(_mcPosition.btnDouble,function(mc:MovieClip):void
			{
				_loadBtnDoubleOk = true;
				refreshAwardState();
			});
			rsrLoader.addCallBack(_mcPosition.btnFree,function(mc:MovieClip):void
			{
				_loadBtnFreeOk = true;
				refreshAwardState();
			});
			_mcPosition.btnGetEffect.mouseChildren = false;
			_mcPosition.btnGet2Effect.mouseChildren = false;
			_mcPosition.btnGetEffect.mouseEnabled = false;
			_mcPosition.btnGet2Effect.mouseEnabled = false;
//			rsrLoader.addCallBack(_mcPosition.btnGetEffect.mc,function(mc:MovieClip):void
//			{
//				 mc.mouseChildren = false;
//				 mc.mouseEnabled = false;
//			});
//			
//			rsrLoader.addCallBack(_mcPosition.btnGet2Effect.mc,function(mc:MovieClip):void
//			{
//				mc.mouseChildren = false;
//				mc.mouseEnabled = false;
//			});
			
		}
		
		public function showTips(positionCfg:PositionCfgData):void
		{
			ToolTipManager.getInstance().detach(_mcPosition.icon);
			ToolTipManager.getInstance().detach(_mcPosition.txt_02);
			var tipVO:TipVO = new TipVO();
			tipVO.tipData = ConfigDataManager.instance.equipCfgData(positionCfg.chopid);
			tipVO.tipType = ToolTipConst.EQUIP_BASE_TIP;
			ToolTipManager.getInstance().hashTipInfo(_mcPosition.icon,tipVO);
			ToolTipManager.getInstance().attach(_mcPosition.icon);
			var tipVOs:TipVO = new TipVO();
			tipVOs.tipData = StringConst.POSITION_PANEL_0047;
			tipVOs.tipType = ToolTipConst.TEXT_TIP;
			ToolTipManager.getInstance().hashTipInfo(_mcPosition.txt_02,tipVOs);
			ToolTipManager.getInstance().attach(_mcPosition.txt_02);			
		}
		
		private function showTxtTips(nextPositionChopCfg:PositionChopCfgData):void
		{
			if(heroPositionLevel==PositionDataManager.instance.heroPositionLevel)return;
			heroPositionLevel = PositionDataManager.instance.heroPositionLevel;
			var _currentPositionChopCfg:PositionChopCfgData = ConfigDataManager.instance.positionChopCfgData(heroPositionLevel);
			ToolTipManager.getInstance().detach(_mcPosition.btnMc);
			var tipVO:TipVO = new TipVO();
			if(nextPositionChopCfg)
			{
				tipVO.tipData = StringConst.POSITION_PANEL_0045.replace("X",nextPositionChopCfg.level).replace("XX",ConfigDataManager.instance.positionCfgData(nextPositionChopCfg.position_level).name).replace("XXX",nextPositionChopCfg.exploit_cost).replace
					("Y",UtilItemParse.getThingsData(nextPositionChopCfg.item_cost).itemCfgData.name + "：" + (UtilItemParse.getThingsData(nextPositionChopCfg.item_cost).count)).replace
					("YY",nextPositionChopCfg.chr_attr_rate);
			}
			else
			{
				tipVO.tipData = StringConst.POSITION_PANEL_0046.replace("X",_currentPositionChopCfg.level).replace("Y",_currentPositionChopCfg.chr_attr_rate);
			}	
			tipVO.tipType = ToolTipConst.TEXT_TIP;
			ToolTipManager.getInstance().hashTipInfo(_mcPosition.btnMc,tipVO);
			ToolTipManager.getInstance().attach(_mcPosition.btnMc);
			ToolTipManager.getInstance().detach(_mcPosition.chop.icon2);
			var tipVOs:TipVO = new TipVO();
			if(!_currentPositionChopCfg)
			{
				tipVOs.tipData = StringConst.POSITION_PANEL_0048.replace("X",0).replace("Y",0).replace("YY",0);
			}
			else
			{
				tipVOs.tipData = StringConst.POSITION_PANEL_0048.replace("X",_currentPositionChopCfg.level).replace("Y",_currentPositionChopCfg.chr_attr_rate).replace("YY",_currentPositionChopCfg.hero_attr_rate);
			}	
			tipVOs.tipType = ToolTipConst.TEXT_TIP;
			ToolTipManager.getInstance().hashTipInfo(_mcPosition.chop.icon2,tipVOs);
			ToolTipManager.getInstance().attach(_mcPosition.chop.icon2);
		}
		
		private function refreshPositionValue(positionCfg:PositionCfgData):void
		{		
			if(!positionCfg)
			{
				return
			}
			var equipCfgData:EquipCfgData = ConfigDataManager.instance.equipCfgData(positionCfg.chopid);
			_mcPosition.txtValue_01.htmlText =HtmlUtils.createHtmlStr(0xffcc00,equipCfgData.name,14,true);
			
			var positionName:String = StringUtil.substitute(StringConst.POSITION_PANEL_0057,"<font color='#00ff00'>"+positionCfg.name+"</font>");
			if(RoleDataManager.instance.position<positionCfg.level)
			{
				positionName = StringUtil.substitute(StringConst.POSITION_PANEL_0057,"<font color='#ff0000'>"+positionCfg.name+"</font>");
			}
			_mcPosition.txtValue_06.htmlText=HtmlUtils.createHtmlStr(0xffe1aa,positionName);
			_mcPosition.txtValue_08.htmlText=HtmlUtils.createHtmlStr(0xffe1aa,positionName);
			
			var color:int=0x00ff00;
			if(RoleDataManager.instance.reincarn < positionCfg.change_count)
			{
				color=0xff0000;
			}
			else
			{
				if(RoleDataManager.instance.reincarn == positionCfg.change_count)
				{
					if(RoleDataManager.instance.lv < positionCfg.chr_level)
					{
						color = 0xff0000;
					}
				}
			}
			
			var lev:String = StringConst.POSITION_PANEL_0022.replace("X",positionCfg.change_count).replace("XX",positionCfg.chr_level)
				+"("+HtmlUtils.createHtmlStr(color,RoleDataManager.instance.lv+"/"+positionCfg.chr_level)+")";
			_mcPosition.txtValue_05.htmlText =HtmlUtils.createHtmlStr(0xffe1aa,lev);
			
			color=0x00ff00;
			if(HeroDataManager.instance.grade < positionCfg.hero_groude)
			{
				color = 0xff0000;
			}
			else
			{
				if(HeroDataManager.instance.grade == positionCfg.hero_groude)
				{
					if(HeroDataManager.instance.lv < positionCfg.hero_level)
					{
						color = 0xff0000;
					}
				}
			}
		
			lev = StringConst.POSITION_PANEL_0024.replace("X",positionCfg.hero_groude).replace("XX",positionCfg.hero_level)
				+"("+HtmlUtils.createHtmlStr(color,HeroDataManager.instance.lv+"/"+positionCfg.hero_level)+")";
			_mcPosition.txtValue_07.htmlText =HtmlUtils.createHtmlStr(0xffe1aa,lev);
		}
		
		public function refreshChopTxt():void
		{
			var _nextPositionChopCfg:PositionChopCfgData=ConfigDataManager.instance.positionChopCfgData(PositionDataManager.instance.rolePositionLevel+1);
			if(!_nextPositionChopCfg)
			{
				return;
			}
			_mcPosition.chop.txtValue_10.text = _nextPositionChopCfg.level + StringConst.POSITION_PANEL_0039;
			_mcPosition.chop.txtValue_11.text = StringConst.POSITION_PANEL_0040.replace("X",_nextPositionChopCfg.chr_attr_rate);
			_mcPosition.chop.txtValue_12.text =  StringConst.POSITION_PANEL_0040.replace("X",_nextPositionChopCfg.hero_attr_rate);
			_mcPosition.chop.txtValue_13.htmlText = StringConst.POSITION_PANEL_0041.replace("X",_nextPositionChopCfg.exploit_cost>RoleDataManager.instance.merit?HtmlUtils.createHtmlStr(0xff0000,String(_nextPositionChopCfg.exploit_cost)):HtmlUtils.createHtmlStr(0x53b436,String(_nextPositionChopCfg.exploit_cost)));
			_mcPosition.chop.txtValue_14.htmlText = UtilItemParse.getThingsData(_nextPositionChopCfg.item_cost).itemCfgData.name + "：" + (UtilItemParse.getThingsData(_nextPositionChopCfg.item_cost).count >BagDataManager.instance.getItemNumById(UtilItemParse.getThingsData(_nextPositionChopCfg.item_cost).itemCfgData.id)?
				HtmlUtils.createHtmlStr(0xff0000,String(UtilItemParse.getThingsData(_nextPositionChopCfg.item_cost).count)):HtmlUtils.createHtmlStr(0x53b436,String(UtilItemParse.getThingsData(_nextPositionChopCfg.item_cost).count)));
		}
		
		private function refreshSalaryTxt():void
		{
			var positionDataManager:PositionDataManager = PositionDataManager.instance;
			var currentPositionCfg:PositionCfgData = ConfigDataManager.instance.positionCfgData(positionDataManager.position);
			var nextPositionCfg:PositionCfgData = ConfigDataManager.instance.positionCfgData(positionDataManager.position+1);
			if(nextPositionCfg!=null)
			{
				var utilNumChange:UtilNumChange = new UtilNumChange();
				_mcPosition.txtValue_02.htmlText = RoleDataManager.instance.merit < nextPositionCfg.exploit_cost ?
					HtmlUtils.createHtmlStr(0xff0000,utilNumChange.changeNum(RoleDataManager.instance.merit)+"/"+utilNumChange.changeNum(nextPositionCfg.exploit_cost)):
					HtmlUtils.createHtmlStr(0x00ff00,utilNumChange.changeNum(RoleDataManager.instance.merit)+"/"+utilNumChange.changeNum(nextPositionCfg.exploit_cost));
			}else
			{
				_mcPosition.txtValue_02.text="";
			}
			_mcPosition.txtValue_00.text = RoleDataManager.instance.merit.toString();
			if(currentPositionCfg)
			{
				_mcPosition.txtValue_03.text = currentPositionCfg.name;
				if(currentPositionCfg.gift_item != "")
				{
					_mcPosition.txtValue_04.text = StringConst.POSITION_PANEL_0021.replace("Y",currentPositionCfg.gift_exp).replace("YY",currentPositionCfg.gift_bind_coin).replace("N",UtilItemParse.getThingsData(currentPositionCfg.gift_item).itemCfgData.name).replace(
						"YYY",UtilItemParse.getThingsData(currentPositionCfg.gift_item).count);
				}
				else
				{
					_mcPosition.txtValue_04.text = StringConst.POSITION_PANEL_0021.replace("Y",currentPositionCfg.gift_exp).replace("YY",currentPositionCfg.gift_bind_coin).replace("、NxYYY个","");
				}
			}
			else
			{
				_mcPosition.txtValue_03.text =StringConst.POSITION_PANEL_0026;
				_mcPosition.txtValue_04.text = StringConst.POSITION_PANEL_0058;
			}
		}
		
		override public function destroy():void
		{
            if (_effectHandler)
            {
                _effectHandler.destroy();
                _effectHandler = null;
            }
			destroyEffect();
			RoleDataManager.instance.detach(this);
			PositionDataManager.instance.detach(this);
			BagDataManager.instance.detach(this);
			HeroDataManager.instance.detach(this);
			ToolTipManager.getInstance().detach(_mcPosition.icon);
			ToolTipManager.getInstance().detach(_mcPosition.txt_02);
			ToolTipManager.getInstance().detach(_mcPosition.btnMc);
			_page = 1;
			oldUrl="";
			if(urlPic)
			{
				urlPic.destroy();
				urlPic = null;
			}
			if(_mouseEvent)
			{
				_mouseEvent.destory();
				_mouseEvent = null;
			}
			if(_iconAnim)
			{
				_iconAnim.kill();
			}
			_mcPosition = null;
			super.destroy();
		}
			
		override public function getPanelRect():Rectangle
		{
			return new Rectangle(0,0,650,506);//由子类继承实现
		}
		
	}
}