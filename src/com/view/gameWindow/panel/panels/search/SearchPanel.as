package com.view.gameWindow.panel.panels.search
{
	import com.model.business.gameService.constants.GameServiceConstants;
	import com.model.consts.JobConst;
	import com.view.gameWindow.common.List;
	import com.view.gameWindow.common.McScrollBar;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.panel.panels.friend.ContactDataManager;
	import com.view.gameWindow.panel.panels.friend.ContactEntry;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import mx.utils.StringUtil;
	
	
	/**
	 * @author wqhk
	 * 2014-11-10
	 */
	public class SearchPanel extends PanelBase
	{
		protected var _mc:McSearchPanel;
		protected var _name:String;
		protected var _list:List;
		public function SearchPanel()
		{
			super();
		}
		
		override protected function initSkin():void
		{
			_mc = new McSearchPanel();
			_skin = _mc;
			
			addChild(_skin);
			
			setTitleBar(_mc.dragBox);
			
			_mc.txt0.text = "请输入玩家名";
			_mc.label0.text = "玩家名称";
			_mc.label1.text = "玩家职业";
			_mc.label2.text = "玩家等级";
			_mc.titleTxt.htmlText = HtmlUtils.createHtmlStr(_mc.titleTxt.textColor,"查找玩家",12,true);
			
			
			_list = new List(5,McScrollBar,5,315,26);
			_list.setStyle(McSearchItem,itemSetCallback,null);
			_list.selectable = true;
			
			_mc.listCtner.addChild(_list);
			addEventListener(MouseEvent.CLICK,clickHandler,false,0,true);
		}
		
		override public function destroy():void
		{
			ContactDataManager.instance.detach(this);
			removeEventListener(MouseEvent.CLICK,clickHandler);
			
			if(_list)
			{
				_list.destroy();
				_list = null;
			}
			super.destroy();
		}
		
		override protected function initData():void
		{
			super.initData();
			
			ContactDataManager.instance.attach(this);
			ContactDataManager.instance.requestClearSearchResult();
		}
		
		override public function update(proc:int=0):void
		{
			if(proc == GameServiceConstants.SM_SEARCH_RESULT)
			{
				if(_list)
				{
					_list.data = ContactDataManager.instance.searchOutList;
				}
			}
		}
		
		protected function itemSetCallback(index:int,value:Object,target:DisplayObject):void
		{
			MovieClip(target).gotoAndStop((index)%2+1);
			
			var data:ContactEntry = ContactEntry(value);
			var view:* = target;
			view.nameTxt.text = data.name;
			view.lvTxt.text = data.toLvDes();
			
			view.jobTxt.text = JobConst.jobName(data.job);
		}
		
		protected function clickHandler(e:MouseEvent):void
		{
			switch(e.target)
			{
				case _mc.closeBtn:
					PanelMediator.instance.closePanel(_name);
					break;
				case _mc.searchBtn:
					ContactDataManager.instance.requestSearch(StringUtil.trim(_mc.searchTxt.text));
					break;
			}
		}
	}
}