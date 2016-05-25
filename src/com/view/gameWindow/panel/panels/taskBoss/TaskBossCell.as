package com.view.gameWindow.panel.panels.taskBoss
{
	import com.model.business.fileService.UrlBitmapDataLoader;
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.business.fileService.interf.IUrlBitmapDataLoaderReceiver;
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.task.constants.TaskStates;
	import com.view.gameWindow.util.UrlPic;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	
	import mx.utils.StringUtil;
	
	/**
	 * @author wqhk
	 * 2014-8-20
	 */
	public class TaskBossCell extends McTaskBossCell implements IUrlBitmapDataLoaderReceiver
	{
		private var icon:Bitmap;
		private var _data:TaskBossData;
		private var colorFilter:ColorMatrixFilter;
		private var lightFilter:GlowFilter;
		private var redFilter:GlowFilter;
		private var _selected:Boolean;
		public function TaskBossCell()
		{
			super();
			
			addEventListener(MouseEvent.ROLL_OUT,rollOutHandler,false,0,false);
			addEventListener(MouseEvent.ROLL_OVER,rollOverHandler,false,0,false);
			
			colorFilter = new ColorMatrixFilter();
			colorFilter.matrix = [1,0,0,0,50,
									0,1,0,0,50,
									0,0,1,0,50,
									0,0,0,1,0];
			
			lightFilter = new GlowFilter(0xffffff,0.5,8,8,2,1,true);
			redFilter =  new GlowFilter(0x996100,1,8,8,2,1,true);
		}
		
		public function initView():void
		{
			var loader:RsrLoader = new RsrLoader();
			loader.load(this,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD);
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			
			filters = _selected ? [redFilter] : null;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		private function rollOutHandler(e:MouseEvent):void
		{
			if(_selected)
			{
				return;
			}
			
			filters = null;
		}
		
		private function rollOverHandler(e:MouseEvent):void
		{
			if(_selected)
			{
				return;
			}
			
			filters = [lightFilter];
		}
		
		public function set data(value:TaskBossData):void
		{
			lvTxt.text = StringUtil.substitute(StringConst.TASK_WANT_PANEL_0006,value.costCfgData.reward_point); //value.level.toString();
			var load:UrlBitmapDataLoader = new UrlBitmapDataLoader(this);
			load.loadBitmap(ResourcePathConstants.IMAGE_TASK_BOSS_LOAD+value.iconId+ResourcePathConstants.POSTFIX_PNG);
			_data = value;
			if(value.costCfgData.vip)
			{
				vipSign.visible = true;
			}
			else
			{
				vipSign.visible = false;
			}
		}
		
		public function setStateBitmap(state:int = 0):void
		{
			var urlPic:UrlPic = new UrlPic(this.state);
			if(state == TaskStates.TS_UNKNOWN)
			{
				this.state.visible = false;
			}
			else if(state == TaskStates.TS_DOING || state == TaskStates.TS_CAN_SUBMIT)
			{
				this.state.visible = true;
				if(this.state.numChildren)
				{
					this.state.removeChildAt(0);
					urlPic.load(ResourcePathConstants.IMAGE_TASK_BOSS_LOAD+"doing"+ResourcePathConstants.POSTFIX_PNG);
				}
			}
			else if(state == TaskStates.TS_DONE)
			{
				this.state.visible = true;
				if(this.state.numChildren)
				{
					this.state.removeChildAt(0);
					urlPic.load(ResourcePathConstants.IMAGE_TASK_BOSS_LOAD+"done"+ResourcePathConstants.POSTFIX_PNG);
				}
			}
		}
		
		public function get data():TaskBossData
		{
			return _data;
		}
		
		public function urlBitmapDataReceive(url:String, bitmapData:BitmapData, info:Object):void
		{			
			if(!icon)
			{
				icon = new Bitmap();
			}
			
			icon.bitmapData = bitmapData;
			bg.addChild(icon);			
		}
		
		public function urlBitmapDataProgress(url:String, progress:Number, info:Object):void
		{
			
		}
		
		public function urlBitmapDataError(url:String, info:Object):void
		{
			
		}
	}
}