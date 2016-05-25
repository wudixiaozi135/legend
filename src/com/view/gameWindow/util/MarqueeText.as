package  com.view.gameWindow.util
{
	import com.view.gameWindow.util.css.GameStyleSheet;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	
	/*
	* 1.直接将某TextField转换为跑马灯文本 changeTextFieldToMarqueeText 
	* 2.动态设定显示宽度 width
	* 3.动态设定一次移动间隔时间 delay
	* 4.动态设定一次移动间隔距离 step
	* 5.设定默认文本显示样式 defaultTextFormat
	* 6.动态设定文本显示样式 setTextFormat
	***/
	public class MarqueeText extends Sprite
	{
		private var m_rect:Rectangle;
		private var m_txt:TextField;
		private var m_timer:Timer;
		//每次移动距离
		private var m_step:Number;
		private const _filter:GlowFilter = new GlowFilter(0x000000,0.8,8,8,3,1,false,false);
		//滚动持续时间
		private var m_duration:Number;
		private var m_repeat:int;
		//左移右移tmpflag
		private var m_bleftflag:Boolean = true;
		//
		private var m_delay:Number;
		public var data:Object;
		public var callBackFun:Function;
		private var m_delay_id:uint;
		 
		public function MarqueeText(width:Number=100,height:Number = 20,delay:Number=1000, stepX:Number=4)
		{
			super();
			//m_txt = new TextField();
			m_txt = UtilText.getText();
			
			m_txt.x = 0;
			m_txt.selectable = false;
			m_txt.wordWrap = false;
			m_txt.multiline = false;
			m_txt.autoSize = TextFieldAutoSize.LEFT;
			 
			var textformat:TextFormat = new TextFormat;
			textformat.size = 14;
			textformat.color = 0xd4a460;//0xd4a460;
			m_txt.defaultTextFormat = textformat;
			
			addChild(m_txt);
			m_txt.y = 6;
			m_rect = new Rectangle(0, 0, width, height);
			this.scrollRect = m_rect;
			m_bleftflag = true;
			m_step = stepX;
			
			m_timer = new Timer(delay);
			m_timer.delay = 60;
			m_timer.addEventListener(TimerEvent.TIMER, timerhandler);		
		}
		 
		public  function start():void
		{
			resetPos();
			m_timer.start();
		}
		
		private function onComplete():void
		{
			callBackFun.apply(null,[data]);			
		}
		private function timerhandler(evt:TimerEvent):void
		{
			if(m_repeat > 0)
			{
				if(m_bleftflag)
				{
					m_txt.x += m_step;
					if(m_txt.x > this.width)
					{
						m_repeat--;
						m_timer.stop();
						resetPos();
						delayFun();
					}
				}
				else
				{
					m_txt.x -= m_step; 
					if(m_txt.textWidth*(-1)>m_txt.x)
					{
						m_repeat--;
						m_timer.stop();
						resetPos();
						delayFun();
					}
				}
			}
			else
			{
				onComplete();
				m_timer.stop();
			}
			 
		}
		
		private function delayFun():void
		{
			m_delay_id = setInterval(function():void
			{
				start();
				clearInterval(m_delay_id);
			},m_delay);
		}
		
		private function resetPos():void
		{
			if(m_bleftflag)
			{
				m_txt.x = m_txt.textWidth*(-1);
			}
			else
			{
				m_txt.x = this.width - m_txt.textWidth;
			}
		}
		public function set text(text:String):void
		{
			m_txt.htmlText = text;
			 
		}
		public function get text():String
		{
			return m_txt.text;
		}
		public function set delay(delay:Number):void
		{
 			m_delay = delay;
		}
		
		public function set duration(val:Number):void
		{
			m_duration = val;
		}
		
		public function set repeat(val:int):void
		{
			m_repeat = val;
		}
		
		public function set step(step:Number):void
		{
			m_step = step;
		}
		public override function set width(width:Number):void
		{
			m_rect.width = width; 
		}
		public function set defaultTextFormat(format:TextFormat):void
		{
			m_txt.defaultTextFormat = format;
			setTextFormat(format);
		}
		public function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1):void
		{
			m_txt.setTextFormat(format, beginIndex, endIndex);
			 
		}
		 
	}
}