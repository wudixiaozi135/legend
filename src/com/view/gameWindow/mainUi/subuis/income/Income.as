package com.view.gameWindow.mainUi.subuis.income
{
	import com.greensock.TweenLite;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.pattern.Observer.IObserver;
	import com.view.gameWindow.mainUi.MainUi;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Income extends MainUi implements IIncome,IObserver
	{
		private const _numLines:int = 7;
		private var _layer:Sprite;
		private var _txts:Vector.<TextField>;
		private var _isOver:Boolean;
		
		public function Income()
		{
			super();
			IncomeDataManager.instance.attach(this);
		}
		
		override public function initView():void
		{
			_skin = new McIncome();
			addChild(_skin);
			super.initView();
			var mc:McIncome = _skin as McIncome;
			mc.txt.visible = false;
			addEventListener(MouseEvent.ROLL_OVER,onOver);
			addEventListener(MouseEvent.ROLL_OUT,onOut);
			_layer = new Sprite;
			addChild(_layer);
			//
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0,0);
			sprite.graphics.drawRect(6,6,188,136);
			sprite.graphics.endFill();
			_layer.addChild(sprite);
			_layer.mask = sprite;
			//
			_txts = new Vector.<TextField>();
		}
		
		override protected function addCallBack(rsrLoader:RsrLoader):void
		{
			var mc:McIncome = _skin as McIncome;
			rsrLoader.addCallBack(mc.btn,function (mc:MovieClip):void
			{
				mc.addEventListener(MouseEvent.CLICK,onClick);
			});
		}
		
		protected function onClick(event:MouseEvent):void
		{
			PanelMediator.instance.switchPanel(PanelConst.TYPE_INCOME);
		}
		
		protected function onOver(event:MouseEvent):void
		{
			_isOver = true;
			var txt:TextField;
			for each(txt in _txts)
			{
				TweenLite.killTweensOf(txt)
				TweenLite.to(txt,.5,{alpha:1});
			}
		}
		
		protected function onOut(event:MouseEvent):void
		{
			_isOver = false;
			var txt:TextField;
			for each(txt in _txts)
			{
				TweenLite.killTweensOf(txt)
				TweenLite.to(txt,.5,{alpha:0});
			}
		}
		
		public function update(proc:int=0):void
		{
			var txt:TextField;
			if(_txts.length >= _numLines)
			{
				txt = _txts.shift();
				if(txt.parent)
				{
					txt.parent.removeChild(txt);
				}
			}
			var manager:IncomeDataManager = IncomeDataManager.instance;
			var infos:Vector.<String> = manager.infos;
			if(manager.isAddOne && infos.length)
			{
				for(var i:int = 1;i<manager.lineNum;i++)
				{
					if(i > infos.length)
					{
						return;
					}
					var string:String = infos[infos.length-i];
					txt = cloneTxt();
					_layer.addChild(txt);
					txt.htmlText = string;
					txt.height = 18+(txt.numLines-1)*18;
					_txts.push(txt);
					if(!_isOver)
					{
						TweenLite.to(txt,.5,{alpha:0,delay:3});
					}
					refreshTxtPos();
				}
			}
		}
		
		private function refreshTxtPos():void
		{
			var i:int,l:int = _numLines,yPos:int = 146;
			for(i=0;i<l;i++)
			{
				var index:int = _txts.length-1-i;
				if(index >= 0)
				{
					var txt:TextField = _txts[index];
					txt.y = yPos - txt.height - 4;
					yPos = txt.y;
				}
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
			txt.x = mc.txt.x;
			txt.width = 188;
			return txt;
		}
	}
}