package com.view.gameWindow.panel.panels.input
{
	/**
	 * Created by Administrator on 2014/12/15.
	 */
	public class InputData
	{
		public static var title:String = null;
		public static var content:String = null;
		public static var warn:String = null;

		public static var btnTxt1:String = null;
		public static var btnOkFunc:Function;

		public static var btnTxt2:String = null;
		public static var isNumber:Boolean;
		public static var maxValue:int;
		public static var btnCancelFuncParam:Object;
		public static var btnCancelFunc:Function;

		public static var warnFunc:Function;

		public function InputData()
		{
		}

		public static function destroy():void
		{
			title = null;
			warn = null;
			btnTxt1 = null;
			btnTxt2 = null;
			btnOkFunc = null;
			btnCancelFunc = null;
			btnCancelFuncParam = null;
			warnFunc = null;
			maxValue = 0;
		}
	}
}
