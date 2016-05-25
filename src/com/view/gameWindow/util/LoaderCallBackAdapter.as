package com.view.gameWindow.util
{
	import com.model.gameWindow.rsr.RsrLoader;

	import flash.display.MovieClip;

	public class LoaderCallBackAdapter
	{
		public function LoaderCallBackAdapter()
		{
		}
		private var count:int;
		
		/**
		 * 
		 * 
		 */
		public function addCallBack(rsrLoader:RsrLoader,callback:Function,...args):void
		{
			var items:Array;
			if (args.length == 1 && args[0] is Array)
			{
				count = args[0].length;
				items = args[0];
			} else
			{
				count = args.length;
				items = args;
			}

			for (var i:int = 0; i < items.length; i++)
			{
				rsrLoader.addCallBack(items[i], function (mc:MovieClip):void
				{
					count--;
					if(count==0)
					{
						callback();
					}
				});
			}
		}
	}
}