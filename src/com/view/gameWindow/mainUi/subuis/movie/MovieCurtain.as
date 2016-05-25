package com.view.gameWindow.mainUi.subuis.movie
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.model.consts.FontFamily;
	import com.view.gameWindow.util.HtmlUtils;
	
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import flashx.textLayout.formats.TextAlign;
	
	
	/**
	 * @author wqhk
	 * 2014-12-5
	 */
	public class MovieCurtain extends Sprite
	{
		public static const H:int = 100;
		private var topPart:Sprite;
		private var bottomPart:Sprite;
		private var coverPart:Sprite;
		private var subtitle:TextField;
		
		private var showAnimTop:TweenLite;
		private var showAnimBottom:TweenLite;
		private var hideAnimTop:TweenLite;
		private var hideAnimBottom:TweenLite;
		private var showCoverAnim:TweenLite;
		private var _height:int;
		private var _width:int;
		private var clearSubtitleTime:int = 0;
		private var _tf:TextFormat;
		
		private var leftTalk:MovieTalk;
		private var rightTalk:MovieTalk;
		
		public function MovieCurtain()
		{
			super();
			
			topPart = new Sprite();
			topPart.graphics.beginFill(0);
			topPart.graphics.drawRect(0,0,10,H);
			topPart.graphics.endFill();
			
			bottomPart = new Sprite();
			bottomPart.graphics.beginFill(0);
			bottomPart.graphics.drawRect(0,0,10,H);
			bottomPart.graphics.endFill();
			
			topPart.height = 0;
			bottomPart.height = 0;
			
			coverPart = new Sprite();
			coverPart.graphics.beginFill(0);
			coverPart.graphics.drawRect(0,0,10,10);
			coverPart.graphics.endFill();
			
			subtitle = new TextField();
			_tf = new TextFormat(FontFamily.FONT_NAME,24,0xffffff,true);
			_tf.align = TextFormatAlign.CENTER;
			subtitle.defaultTextFormat = _tf;
			subtitle.mouseEnabled = false;
			subtitle.visible = false;
			subtitle.filters = [new GlowFilter(0x0,1,3,3,5)];
			
			leftTalk = new MovieTalk();
			rightTalk = new MovieTalk();
			
			addChild(topPart);
			addChild(bottomPart);
			addChild(coverPart);
			subtitle.mouseEnabled = false;
			addChild(subtitle);
			addChild(leftTalk);
			addChild(rightTalk);
			
			topPart.visible = false;
			bottomPart.visible = false;
			coverPart.visible = false;
		}
		
		public function resize(width:int,height:int):void
		{
			topPart.width = width;
			bottomPart.width = width;
			bottomPart.y = height - bottomPart.height;
			_height = height;
			_width = width;
			coverPart.width = width;
			coverPart.height = height;
			
			subtitle.x = int(width/4);
			subtitle.width = int(width*1/2);
			subtitle.y = int(height*2/5);
			
//			var talkPos:int = int(width/5);
//			
//			leftTalk.x = talkPos;
//			leftTalk.y = height - leftTalk.height - 200;
//			
//			rightTalk.x = width - talkPos - rightTalk.width;
//			rightTalk.y = height - rightTalk.height - 180;
			
			leftTalk.y = height - leftTalk.height - 385;
			rightTalk.y = height - rightTalk.height - 281;
			
			leftTalk.x = int(width/2) - leftTalk.width - 15;
			rightTalk.x = int(width/2) + 15;
		}
		
		public function addTalk(txt:String,position:int,icon:String,time:Number):void
		{
			var talk:MovieTalk = null;
			
			if(position == 0)
			{
				talk = leftTalk;
			}
			else if(position == 1)
			{
				talk = rightTalk;
			}
			
			if(talk)
			{
				talk.pos = position;
				talk.icon = icon;
				talk.text = txt;
				talk.show(time);
			}
		}
		
		public function addSubtitle(txt:String,time:int,color:int):void
		{
			if(clearSubtitleTime != 0)
			{
				clearTimeout(clearSubtitleTime);
				clearSubtitleTime = 0;
			}
//			subtitle.htmlText = HtmlUtils.createHtmlStr(color,txt,18,true,2,FontFamily.FONT_NAME,false,"","center");
			subtitle.textColor = color;
			subtitle.text = txt;
			clearSubtitleTime = setTimeout(clearSubtitle,time*1000);
			subtitle.visible = true;
		}
		
		public function clearSubtitle():void
		{
			subtitle.text = "";
			subtitle.visible = false;
		}
		
		public function showCover(color:int,time:Number,percent:int):void
		{
			if(showCoverAnim)
			{
				showCoverAnim.kill();
			}
			
			coverPart.graphics.clear();
			coverPart.graphics.beginFill(color);
			coverPart.graphics.drawRect(0,0,_width,_height);
			coverPart.graphics.endFill();
			coverPart.alpha = 0;
			coverPart.visible = true;
			
			var a:Number = Number(percent/100);
			showCoverAnim = TweenLite.to(coverPart,time,{alpha:a});
		}
		
		public function hideCover():void
		{
			if(showCoverAnim)
			{
				showCoverAnim.kill();
				showCoverAnim = null;
			}
			coverPart.visible = false;
		}
		
		
		public function open(time:Number):void
		{
			topPart.visible = true;
			bottomPart.visible = true;
			stopAnim();
			startShowAnim(time);
		}
		
		public function close(time:Number):void
		{
			stopAnim();
			startCloseAnim(time);
		}
		
		private function startShowAnim(time:Number):void
		{
			showAnimTop = TweenLite.to(topPart,time,{height:H});
			showAnimBottom = TweenLite.to(bottomPart,time,{height:H,onUpdate:bottomHeightChange});
		}
		
		private function bottomHeightChange():void
		{
			bottomPart.y = _height - bottomPart.height;
		}
		
		private function stopAnim():void
		{
			if(showAnimTop)
			{
				showAnimTop.kill();
				showAnimTop = null;
			}
			if(showAnimBottom)
			{
				showAnimBottom.kill();
				showAnimBottom = null;
			}
			
			if(hideAnimTop)
			{
				hideAnimTop.kill();
				hideAnimTop = null;
			}
			
			if(hideAnimBottom)
			{
				hideAnimBottom.kill();
				hideAnimBottom = null;
			}
		}
		
		private function startCloseAnim(time:Number):void
		{
			if(topPart.visible || bottomPart.visible)
			{
				hideAnimTop = TweenLite.to(topPart,time,{height:0});
				hideAnimBottom = TweenLite.to(bottomPart,time,{height:0,onUpdate:bottomHeightChange,onComplete:closeAnimComplete});
			}
		}
		
		private function closeAnimComplete():void
		{
			topPart.visible = false;
			bottomPart.visible = false;
		}
		
	}
}