package com.view.gameWindow.panel.panels.equipRecycle.common
{
    import flash.display.MovieClip;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;

    /**
     * Created by Administrator on 2015/1/12.
     */
    public class McPlayUtil
    {
        public function McPlayUtil()
        {
        }

        public static function toNum(swf:MovieClip, num:int, interval:int, callBack:Function = null):void
        {
            var frame:int = 1;
			if(num==0)
			{
				frame=Math.random()*10;
			}
            var timeId:uint = setInterval(function ():void
            {
				if(frame>10)frame=1;
				swf.gotoAndStop(frame);
                if (frame != num + 1)
                {
                    frame++;
                } else
                {
                    clearInterval(timeId);
                    if (callBack != null)
                    {
                        callBack();
                    }
                }

            }, interval);
        }
    }
}
