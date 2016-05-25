package com.view.gameWindow.panel.panels.income
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.mainUi.subuis.income.IncomeDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.PanelBase;
	import com.view.gameWindow.scene.GameSceneManager;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	import com.view.gameWindow.util.scrollBar.ScrollBar;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 详细收益面板类
	 * @author Administrator
	 */	
	public class PanelIncome extends PanelBase implements IPanelIncome,IScrollee
	{
		private var _scrollBar:ScrollBar;
		private var _itemContainer:Sprite;
		private var _contentHeight:int;
		private var _scrollRect:Rectangle;
		private var _txts:Vector.<TextField>;
		private var _isFirst:Boolean;
		
		public function PanelIncome()
		{
			super();
			IncomeDataManager.instance.attach(this);
		}
		
		override protected function initSkin():void
		{
			_skin = new McIncome();
			addChild(_skin);
			var mc:McIncome = _skin as McIncome;
			setTitleBar(mc.mcTitle);
			mc.txtTitle.mouseEnabled = false;
			mc.txtTitle.text = StringConst.INCOME_0009;
			mc.txt.visible = false;
			mc.addEventListener(MouseEvent.CLICK,onCLick);
		}
		
		protected function onCLick(event:MouseEvent):void
		{
			var mc:McIncome = _skin as McIncome;
			if(event.target == mc.btnClose)
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_INCOME);
			}
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mc:McIncome = _skin as McIncome;
			rsrLoader.addCallBack(mc.mcScrollBar,function (mc:MovieClip):void//滚动条资源加载完成后构造滚动条控制类
			{
				if(!_scrollBar)
				{
					_scrollBar = new ScrollBar(_skin.parent as IScrollee,mc,0,_itemContainer);
					_scrollBar.resetHeight(442);
					_scrollBar.resetScroll();
					_scrollBar.scrollTo(_contentHeight - _scrollRect.height);
				}
			});
		}
		
		override protected function initData():void
		{
			_txts = new Vector.<TextField>();
			if(!_itemContainer)
			{
				_itemContainer = new Sprite();
				_itemContainer.x = 27;
				_itemContainer.y = 54;
			}
			if(!_scrollRect)
			{
				_scrollRect = new Rectangle(0,0,344,442);
			}
			_itemContainer.scrollRect = _scrollRect;
			if(!_itemContainer.parent)
			{
				_skin.addChild(_itemContainer);
			}
			initAllTxt();
		}
		
		public function initAllTxt():void
		{
			var infos:Vector.<String> = IncomeDataManager.instance.infos;
			var i:int,l:int = infos.length;
			for(i=0;i<l;i++)
			{
				var txt:TextField = cloneTxt();
				_itemContainer.addChild(txt);
				txt.htmlText = infos[i];
				txt.height = txt.textHeight + 4;
				_txts.push(txt);
			}
			refreshTxtPos();
		}
		
		override public function update(proc:int=0):void
		{
			if(!_isFirst)
			{
				_isFirst = true;
				return;
			}
			var txt:TextField;
			var infos:Vector.<String> = IncomeDataManager.instance.infos;
			if(infos.length)
			{
				for(var i:int = 1;i<IncomeDataManager.instance.lineNum;i++)
				{
					if(i > infos.length)
					{
						return;
					}
					var string:String = infos[infos.length-i];
					txt = cloneTxt();
					_itemContainer.addChild(txt);
					txt.htmlText = string;
					txt.height = txt.textHeight + 4;
					_txts.push(txt);
					if(_txts.length > infos.length)
					{
						var shift:TextField = _txts.shift();
						if(shift.parent)
						{
							shift.parent.removeChild(shift);
						}
					}
					refreshTxtPos();
				}
				
			}
			if(_scrollBar)
			{
				_scrollBar.resetScroll();
				_scrollBar.scrollTo(_contentHeight - _scrollRect.height);
			}
		}
		
		private function refreshTxtPos():void
		{
			var i:int,l:int = _txts.length,yPos:int = 0;
			for(i=0;i<l;i++)
			{
				var txt:TextField = _txts[i];
				txt.y = yPos + (i == 0 ? 0 : _txts[i-1].height)/* + 4*/;
				yPos = txt.y;
			}
			if(txt)
			{
				_contentHeight = yPos + txt.height/* + 4*/;
			}
		}
		
		private function cloneTxt():TextField
		{
			var mc:McIncome = _skin as McIncome;
			var defaultTextFormat:TextFormat = mc.txt.defaultTextFormat;
			var filters:Array = mc.txt.filters;
			var txt:TextField = new TextField();
			txt.defaultTextFormat = defaultTextFormat;
			txt.setTextFormat(defaultTextFormat);
			txt.filters = filters;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.mouseEnabled = false;
			txt.x = 12;
			txt.width = 315;
			return txt;
		}
		
		public function scrollTo(pos:int):void
		{
			_scrollRect.y = pos;
			_itemContainer.scrollRect = _scrollRect;
		}
		
		public function get contentHeight():int
		{
			return _contentHeight;
		}
		
		public function get scrollRectHeight():int
		{
			return _scrollRect.height;
		}
		
		public function get scrollRectY():int
		{
			return _scrollRect.y;
		}
		
		override public function setPostion():void
		{
			var stage:Stage = GameSceneManager.getInstance().stage;
			isMount(true,stage.mouseX,stage.mouseY);
		}
		
		override public function getPanelRect():Rectangle
		{
			return new Rectangle(0,0,_skin.width,508);//由子类继承实现
		}
		
		override public function destroy():void
		{
			IncomeDataManager.instance.detach(this);
			while(_txts && _txts.length)
			{
				var pop:TextField = _txts.pop();
				if(pop.parent)
				{
					pop.parent.removeChild(pop);
				}
			}
			_txts = null;
			if(_scrollBar)
			{
				_scrollBar.destroy();
				_scrollBar = null;
			}
			super.destroy();
		}
	}
}