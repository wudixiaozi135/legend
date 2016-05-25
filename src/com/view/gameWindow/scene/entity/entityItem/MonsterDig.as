package com.view.gameWindow.scene.entity.entityItem
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.configData.ConfigDataManager;
	import com.model.configData.cfgdata.MstDigCfgData;
	import com.model.consts.ItemType;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.tips.toolTip.ToolTipManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.UtilItemParse;
	import com.view.gameWindow.util.cell.IconCellEx;
	import com.view.gameWindow.util.cell.ThingsData;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getTimer;

	/**
	 * 挖掘提示类
	 * @author Administrator
	 */	
	internal class MonsterDig
	{
		private var _mst:Monster;
		private var _skin:McMstDig;
		private var _mstId:int;
		private var _lastTime:int;
		private var _cells:Vector.<IconCellEx>;

		private var _results:Vector.<Boolean>;
		
		public function MonsterDig(layer:Monster,mstId:int)
		{
			_mst = layer;
			_mstId = mstId;
			init();
		}
		
		private function init():void
		{
			loadSkin();
			//
			initView();
			//
			updateDigCount();
		}
		
		private function loadSkin():void
		{
			_skin = new McMstDig();
			_mst.digLayer.addChild(_skin);
			var rsrLoader:RsrLoader = new RsrLoader();
			rsrLoader.load(_skin,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
		}
		
		private function initView():void
		{
			var digTime:int = _mst.digCount;
			//
			_skin.txtPrompt.text = StringConst.MST_DIG_0001;
			//
			_skin.txtTime0.text = StringConst.MST_DIG_0003;
			//
			var manager:ConfigDataManager = ConfigDataManager.instance;
			var cfgDt:MstDigCfgData = manager.mstDigCfgData(_mstId,digTime);
			var dts:Vector.<ThingsData>,i:int,l:int;
			dts = UtilItemParse.getThingsDatas(cfgDt.item);
			l = dts.length;
			_cells = new Vector.<IconCellEx>(l,true);
			_results = new Vector.<Boolean>(l,true);
			for(i=0;i<l;i++)
			{
				var dt:ThingsData = dts[i];
				var mc:MovieClip = _skin["mcBg"+i] as MovieClip;
				var cell:IconCellEx = new IconCellEx(mc.parent,mc.x,mc.y,mc.width,mc.height);
				IconCellEx.setItemByThingsData(cell,dt);
				ToolTipManager.getInstance().attach(cell);
				_cells[i] = cell;
				var txt:TextField = _skin["txtItem"+i] as TextField;
				txt.textColor = ItemType.getColorByQuality(dt.cfgData.quality);
				txt.text = dt.cfgData.name;
			}
		}
		/**刷新挖掘次数*/
		internal function updateDigCount():void
		{
			var manager:ConfigDataManager = ConfigDataManager.instance;
			var digTime:int = _mst.digCount;
			var totalCount:int = manager.mstDigNum(_mstId);
			if(digTime >= totalCount)
			{
				_mst.destroyMstDig();
				return;
			}
			var str:String = StringConst.MST_DIG_0002;
			var cfgDt:MstDigCfgData = manager.mstDigCfgData(_mstId,digTime);
			var coin:String = cfgDt.coin ? cfgDt.coin + StringConst.GOLD_COIN : "";
			var bind_gold:String = cfgDt.bind_gold ? cfgDt.bind_gold + StringConst.INCOME_0005 : "";
			var item_cost:String = cfgDt.itemCfgDt ? cfgDt.itemCfgDt.name +"*"+ cfgDt.item_count : "";
			str += coin;
			str += str != StringConst.MST_DIG_0002 && bind_gold ? "、" : "";
			str += bind_gold;
			str += str != StringConst.MST_DIG_0002 && item_cost ? "、" : "";
			str += item_cost;
			str += "("+HtmlUtils.createHtmlStr(0x00ff00,digTime+"/"+totalCount,18)+")";
			_skin.txtCost.htmlText = str;
		}
		/**刷新尸体存在时间*/
		internal function updateDuration():void
		{
			var nowTime:int = getTimer();
			if(nowTime - _lastTime >= 1000)
			{
				_lastTime = nowTime;
				var serTime:int = ServerTime.time;
				var remain:int = _mst.endTime - serTime;
				_skin.txtTime1.text = remain > 0 ? TimeUtils.formatClock1(remain) : "00:00:00";
			}
		}
		
		internal function isMouseOnCell():void
		{
			var i:int,l:int = _cells.length;
			for (i=0;i<l;i++) 
			{
				var cell:IconCellEx = _cells[i];
				var mx:Number = cell.mouseX*cell.scaleX;//返回相对图像的起始点位置
				var my:Number = cell.mouseY*cell.scaleY;
				var result:Boolean = mx > 0 && mx <= cell.width && my > 0 && my <= cell.height;
				if(result)
				{
					cell.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE));
				}
				else
				{
					if(_results[i] != result)
					{
						cell.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
					}
				}
				_results[i] = result;
			}
		}
		
		internal function destroy():void
		{
			var cell:IconCellEx;
			for each (cell in _cells) 
			{
				ToolTipManager.getInstance().detach(cell);
				cell.destroy();
			}
			_cells = null;
			_results = null;
			_mstId = 0;
			if(_skin && _skin.parent)
			{
				_skin.parent.removeChild(_skin);
			}
			_skin = null;
			_mst = null;
		}
	}
}