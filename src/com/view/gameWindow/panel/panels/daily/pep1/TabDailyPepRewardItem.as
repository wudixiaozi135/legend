package com.view.gameWindow.panel.panels.daily.pep1
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.cfgdata.DailyVitRewardCfgData;
	import com.model.consts.StringConst;
	import com.model.consts.ToolTipConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.common.HighlightEffectManager;
	import com.view.gameWindow.flyEffect.FlyEffectMediator;
	import com.view.gameWindow.panel.panels.daily.DailyDataManager;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.text.TextFormat;

	/**
	 * 日常活跃度奖励项
	 * @author Administrator
	 */	
	internal class TabDailyPepRewardItem
	{
		private var _order:int;
		private var _skin:McDailyPepRewardItem;
		private var _rsrLoader:RsrLoader;
		private var hl:HighlightEffectManager;
		private var loadOk:Boolean = false;
		internal function get skin():McDailyPepRewardItem
		{
			return _skin;
		}
		
		public function TabDailyPepRewardItem(order:int)
		{
			_order = order;
			_skin = new McDailyPepRewardItem();
			_skin.mouseEnabled = false;
			_skin.txtAboveBtn.mouseEnabled = false;
			_rsrLoader = new RsrLoader();
			hl = new HighlightEffectManager();
			var theThis:TabDailyPepRewardItem = this;
			_rsrLoader.addCallBack(_skin.btn,function (mc:MovieClip):void
			{
				loadOk = true;
				_skin.btn.rewardItem = theThis;
				refersh();
				var cfgDt:DailyVitRewardCfgData = DailyDataManager.instance.getDailyVitRewardCfgData(order);
				var tipData:String = HtmlUtils.createHtmlStr(0xffe1aa,StringConst.DAILY_PANEL_0040) + "\n";
				tipData += UtilItemParse.getItemStr(cfgDt.item,true,"\n");
				ToolTipManager.getInstance().attachByTipVO(mc,ToolTipConst.TEXT_TIP,tipData);
			});
			_rsrLoader.load(_skin,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
			initialize();
		}
		
		private function initialize():void
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			var cfgDt:DailyVitRewardCfgData = manager.getDailyVitRewardCfgData(_order);
			if(cfgDt)
			{
				_skin.txtPepNeed.text = cfgDt.daily_vit+"";
				var isRewardCanGet:Boolean = manager.isRewardCanGet(_order);
				var isRewardGetted:Boolean = manager.isRewardGetted(_order);
				_skin.txtPepNeed.textColor = isRewardCanGet || isRewardGetted ? 0xffe1aa : 0xff0000;
				var defaultTextFormat:TextFormat = _skin.txtPepNeed.defaultTextFormat;
				defaultTextFormat.bold = true;
				_skin.txtPepNeed.defaultTextFormat = defaultTextFormat;
				_skin.txtPepNeed.setTextFormat(defaultTextFormat);
			}
			else
			{
				trace("TabDailyPepRewardItem.init DailyVitRewardCfgData配置信息不存在");
			}
		}
		
		internal function refersh():void
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			//
			if(!manager.isRewardCanGet(_order))
			{
				_skin.txtAboveBtn.text = StringConst.DAILY_PANEL_0014;
				_skin.btn.btnEnabled = false;
				hl.hide(skin.btn);
			}
			else
			{
				if(manager.isRewardGetted(_order))
				{
					_skin.txtAboveBtn.text = StringConst.DAILY_PANEL_0018;
					_skin.btn.btnEnabled = false;
					hl.hide(skin.btn);
				}
				else
				{
					_skin.txtAboveBtn.text = StringConst.DAILY_PANEL_0017;
					_skin.btn.btnEnabled = true;
					if(loadOk)
						hl.show(_skin,skin.btn);
					
				}
			}
		}
		
		internal function onClick():void
		{
			var manager:DailyDataManager = DailyDataManager.instance;
			if(!manager.isRewardCanGet(_order))
			{
				/*RollTipMediator.instance.showRollTip(RollTipType.ERROR,StringConst.DAILY_PANEL_0001);*/
				trace("TabDailyPepRewardItem onClick 未达成");
				return;
			}
			/*if(BagDataManager.instance.remainCellNum == 0)
			{
				RollTipMediator.instance.showRollTip(RollTipType.SYSTEM,StringConst.BAG_PANEL_0029);	
				return;
			}*/
			var localToGlobal:Point = _skin.btn.parent.localToGlobal(new Point(_skin.btn.x,_skin.btn.y));
			var cfgDt:DailyVitRewardCfgData = DailyDataManager.instance.getDailyVitRewardCfgData(_order);
			var dts:Vector.<ThingsData> = UtilItemParse.getThingsDatas(cfgDt.item);
			var rewardBmpLoad:RewardBmpLoad = new RewardBmpLoad();
			rewardBmpLoad.load(dts,localToGlobal);
			manager.requestGetDailyVitTotalReward(_order);
		}
		
		internal function destroy():void
		{
			_skin.btn.rewardItem = null;
			ToolTipManager.getInstance().detach(_skin.btn);
			if(_rsrLoader)
			{
				_rsrLoader.destroy();
				_rsrLoader = null;
			}
			hl.hide(_skin.btn);
			hl = null;
			_skin = null;
		}
	}
}
import com.model.business.fileService.UrlBitmapDataLoader;
import com.model.business.fileService.constants.ResourcePathConstants;
import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
import com.model.configData.ConfigDataManager;
import com.model.configData.cfgdata.ItemCfgData;
import com.view.gameWindow.flyEffect.FlyEffectMediator;
import com.view.gameWindow.scene.GameSceneManager;
import com.view.gameWindow.util.cell.ThingsData;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.utils.Dictionary;

class RewardBmpLoad implements IUrlBitmapDataLoaderReceiver
{
	private var _data:Array;
	private var _total:int;
	private var _loaders:Dictionary;
	
	public function RewardBmpLoad()
	{
		_data = new Array();
		_loaders = new Dictionary();
	}
	
	public function load(vector:Vector.<ThingsData>,localToGlobal:Point):void
	{
		var i:int;
		_total = vector.length;
		for(i=0;i<_total;i++)
		{
			var itemCfg:ItemCfgData = ConfigDataManager.instance.itemCfgData(vector[i].id);
			var url:String = ResourcePathConstants.IMAGE_ICON_ITEM_FOLDER_LOAD + itemCfg.icon + ResourcePathConstants.POSTFIX_PNG;
			var loader:UrlBitmapDataLoader = new UrlBitmapDataLoader(this);
			loader.loadBitmap(url,{index:i,id:vector[i].id,local:localToGlobal},true);
			_loaders[i] = loader;
		}
	}
	
	public function urlBitmapDataError(url:String, info:Object):void
	{
		destoryLoader(int(info.index));
	}
	
	public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
	{
	}
	
	public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
	{
		var bitmap:Bitmap = new Bitmap(bitmapData);
		bitmap.name = info.id;
		bitmap.x = info.local.x;
		bitmap.y = info.local.y;
		GameSceneManager.getInstance().stage.addChild(bitmap);
		_data.push(bitmap);
		destoryLoader(int(info.index));
		if(_data.length >= _total)
		{
			FlyEffectMediator.instance.doFlyReceiveThings3(_data);
		}
	}
	
	public function destoryLoader(index:int):void
	{
		var loader:UrlBitmapDataLoader = _loaders[index];
		if(loader)
		{
			loader.destroy();
		}
	}
}