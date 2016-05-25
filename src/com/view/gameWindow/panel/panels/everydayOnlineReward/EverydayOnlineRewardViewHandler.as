package com.view.gameWindow.panel.panels.everydayOnlineReward
{
	import com.model.configData.ConfigDataManager;
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.panels.everydayOnlineReward.item.EverydayOnlineRewardItem;
	import com.view.gameWindow.panel.panels.onlineTime.McOnlineTimeReward;
	import com.view.gameWindow.panel.panels.roleProperty.UserDataManager;
	import com.view.gameWindow.util.ServerTime;
	import com.view.gameWindow.util.TimeUtils;
	import com.view.gameWindow.util.TimerManager;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class EverydayOnlineRewardViewHandler implements IScrollee
	{
		private var _panel:PanelEverydayOnlineReward;
		private var _skin:McOnlineTimeReward;
		private var _vec:Vector.<EverydayOnlineRewardItem>;
		private var _totalOnlineTime:int;
		private var _scrollBar:ScrollBar;
		private var _scrollRect:Rectangle;
		private var _curTime:int;
		public function EverydayOnlineRewardViewHandler(p:PanelEverydayOnlineReward)
		{
			_panel = p;
			_skin = p.skin as McOnlineTimeReward;
			_skin.txtTips.mouseEnabled = false;
			_skin.txtName.mouseEnabled = false;
			_skin.txtOnlineTime.mouseEnabled = false;
			initData();
		}
		
		private function initData():void
		{
			// TODO Auto Generated method stub
			_skin.txtTips.text = StringConst.EVERYDAY_ONLINE_REWARD_003;
			
			_scrollRect = new Rectangle(0,0,_skin.list.width,_skin.list.height);
			_skin.list.scrollRect = _scrollRect;
			
			_vec = new Vector.<EverydayOnlineRewardItem>();
			var num:int = ConfigDataManager.instance.onlineWelfareVec().length;
			for(var i:int = 0;i<num;i++)
			{
				var item:EverydayOnlineRewardItem = new EverydayOnlineRewardItem(i+1);
				item.showData();
				_skin.list.addChild(item);
				item.y = i*69;
				_vec[i] = item;
			}
			resetScrollBar();
		}
		
		public function refresh():void
		{
			TimerManager.getInstance().remove(ontimer);
			_totalOnlineTime = EverydayOnlineRewardDatamanager.instance.onlineTime+getTimer()/1000;
			var obj:Object =  TimeUtils.calcTime3(_totalOnlineTime);
			var h:int =  obj.hour;
			var m:int =  obj.min;
			var str:String = h>0?(h+StringConst.HOUR_W+m+StringConst.MINIUTE_W):(m+StringConst.MINIUTE_W);
			_skin.txtOnlineTime.text = str;
			var serverDate:Date = ServerTime.date;
			_curTime = serverDate.hours * 3600 + serverDate.minutes * 60 + serverDate.seconds;
			
			for(var i:int = 0;i<_vec.length;i++)
			{
				_vec[i].setTime();
			}
			TimerManager.getInstance().add(1000,ontimer);
		}
		
		public function showSuccess():void
		{
			var index:int = EverydayOnlineRewardDatamanager.instance.curIndex;
			if(_vec[index-1])
				_vec[index-1].handlerSuccess();
			EverydayOnlineRewardDatamanager.instance.curIndex = -1;
		}
		
		public function addScroll(mc:MovieClip):void
		{
			// TODO Auto Generated method stub
			if(!_scrollBar)
			{
				_scrollBar = new ScrollBar(this,mc,0,_skin.list,15);
				_scrollBar.resetHeight(_scrollRect.height);
			}
		}
		
		protected function ontimer():void
		{
			// TODO Auto-generated method stub
			var serverDate:Date = ServerTime.date;
			var time:int = serverDate.hours * 3600 + serverDate.minutes * 60 + serverDate.seconds;
			var total:int = time - _curTime + EverydayOnlineRewardDatamanager.instance.onlineTime;
			var obj:Object =  TimeUtils.calcTime3(total);
			var h:int =  obj.hour;
			var m:int =  obj.min;
			var str:String = h>0?(h+StringConst.HOUR_W+m+StringConst.MINIUTE_W):(m+StringConst.MINIUTE_W);
			if(_skin.txtOnlineTime)
				_skin.txtOnlineTime.text = str;
			if(_vec)
			{
				for(var i:int = 0;i<_vec.length;i++)
				{
					_vec[i].refreshTime();
				}
			}

		}
		
		public function resetScrollBar():void
		{
			if(_scrollBar)
			{
				_scrollBar.resetScroll();
			}
		}
		
		public function scrollTo(pos:int):void
		{
			_scrollRect.y = pos;
			_skin.list.scrollRect = _scrollRect;
		}
		public function get contentHeight():int
		{
			return listContentHeight;
		}
		
		public function get scrollRectHeight():int
		{
			return _scrollRect.height;
		}
		public function get scrollRectY():int
		{
			return _scrollRect.y;
		}
		
		public function get listContentHeight():Number
		{
			if(_vec && _vec.length>0)
			{
				return (_vec.length-1)*69+_vec[0].height;
			}
			return 0;
		}
		
		public function destroy():void
		{
			TimerManager.getInstance().remove(ontimer);
			if(_scrollBar)
			{
				_scrollBar.destroy();
				_scrollBar = null;
			}
			if(_vec.length)
			{
				for(var i:int =0;i<_vec.length;i++)
				{
					_vec[i].destroy();
				}
			}
			_vec = null;
			
		}
		
	}
}