package  com.view.gameWindow.util
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 
	 * @author xiaoyu
	 * 
	 */
	public class TimerManager
	{
		private static var _instance:TimerManager=null;
				
		private var timerDic:Dictionary;
		private var funcToTimerDic:Dictionary;
		private var funcListDic:Dictionary
		public function TimerManager()
		{
			timerDic=new Dictionary();//存储new的timer   
			funcToTimerDic=new Dictionary();//存储new的timer   
			funcListDic=new Dictionary();//存储要调用的方法
		}
		public static function  getInstance():TimerManager
		{
			if(_instance==null)
			{
				_instance=new TimerManager();
				
			}
			return _instance;
		}
		public function add(delay:int,func:Function):void
		{
			if(funcToTimerDic[func]!=undefined)return;
			funcToTimerDic[func]=createTimer(delay);
			funcListDic[delay].push(func); 
		}
		public function remove(func:Function):void
		{
			if(funcToTimerDic[func]==undefined)return;
			var timer:Timer=funcToTimerDic[func];
			delete funcToTimerDic[func];
			
			var list:Array=funcListDic[timer.delay];
			if(list.indexOf(func)>-1)
			{
				list.splice(list.indexOf(func),1);
			}
			
			if(list.length==0)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER,timerHandler);
				delete funcListDic[timer.delay];
				delete timerDic[timer.delay];
			}
		}
		private function createTimer(delay:int):Timer
		{
			if(timerDic[delay]==undefined)
			{
				var timer:Timer=new Timer(delay);
				timer.addEventListener(TimerEvent.TIMER,timerHandler);
				timer.start();
				timerDic[delay]=timer;
				
			}
			if(funcListDic[delay]==undefined)
			{
				funcListDic[delay]=new Array();
			}
			return timerDic[delay];
		}
		private function timerHandler(e:TimerEvent):void
		{
			var list:Array=funcListDic[Timer(e.target).delay];
			for(var i:* in list)
			{
				list[i]();
			}
		}
	}
}