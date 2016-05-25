package com.view.gameWindow.common
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.mainUi.subuis.chatframe.ChatDataManager;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panels.input.InputData;
	import com.view.gameWindow.panel.panels.mall.mallacquire.data.AcquireCostType;
	import com.view.gameWindow.panel.panels.mall.mallacquire.data.AcquireManager;
	import com.view.gameWindow.panel.panels.prompt.Panel1BtnPromptData;
	import com.view.gameWindow.panel.panels.prompt.Panel2BtnPromptData;
	import com.view.gameWindow.tips.rollTip.RollTipMediator;
	import com.view.gameWindow.tips.rollTip.RollTipType;

	/**
	 * @author wqhk
	 * 2014-9-4
	 */
	public class Alert
	{
		public function Alert()
		{

		}

		/**
		 * 显示一按钮提示面板（大）
		 * @param txt 内容
		 * @param funcBtn 确定按钮回调函数
		 * @param funcBtnParam 确定按钮回调函数参数
		 * @param funcSelect 选择按钮回调函数
		 * @param funcSelectParam 选择按钮回调函数参数
		 * @param strSelect 选择按钮文字
		 * @param align 内容对齐方式<br>left:左对齐<br>right:右对齐<br>center:居中<br>justify:自动
		 * @param title 标题
		 * @param closeFunc 关闭按钮时调用函数
		 * @param closeParam 关闭按钮时调用函数参数
		 */
		public static function show(txt:String, funcBtn:Function = null, funcBtnParam:* = null,
									funcSelect:Function = null, funcSelectParam:* = null, strSelect:String = "",
									align:String = "center", title:String = StringConst.PROMPT_PANEL_0005, closeFunc:Function = null, closeParam:* = null):void
		{
			Panel1BtnPromptData.strName = title;
			Panel1BtnPromptData.strContent = "<p align='" + align + "'>" + txt + "</p>";
			Panel1BtnPromptData.strBtn = StringConst.PROMPT_PANEL_0003;
			Panel1BtnPromptData.funcBtn = funcBtn;
			Panel1BtnPromptData.funcBtnParam = funcBtnParam;
			Panel1BtnPromptData.funcSelect = funcSelect;
			Panel1BtnPromptData.funcSelectParam = funcSelectParam;
			Panel1BtnPromptData.strSelect = strSelect;
			Panel1BtnPromptData.funcCloseBtn = closeFunc;
			Panel1BtnPromptData.funcCloseParam = closeParam;
			PanelMediator.instance.switchPanel(PanelConst.TYPE_1BTN_PROMPT);
		}
		/**显示双按钮提示面板（小）*/
		public static function show2(txt:String, funcBtn:Function = null, funcBtnParam:* = null,
									 funcStr:String="",strCancel:String="",funcCancel:Function=null,align:String = "center",isOpen:Boolean = false):void
		{
			Panel2BtnPromptData.strContent = "\n<p align='" + align + "'>" + txt + "</p>";
			Panel2BtnPromptData.strSureBtn =funcStr==""?StringConst.PROMPT_PANEL_0003:funcStr;
			Panel2BtnPromptData.funcBtn = funcBtn;
			Panel2BtnPromptData.funcBtnParam = funcBtnParam;
			Panel2BtnPromptData.cancelFunc = funcCancel;
			Panel2BtnPromptData.strCancelBtn = strCancel==""?StringConst.PROMPT_PANEL_0013:strCancel;
			if(isOpen)
				PanelMediator.instance.openPanel(PanelConst.TYPE_2BTN_PROMPT);
			else
				PanelMediator.instance.switchPanel(PanelConst.TYPE_2BTN_PROMPT);
			
		}
		/**显示双按钮提示面板（小，带勾选框）*/
		public static function show3(txt:String, funcBtn:Function = null, funcBtnParam:* = null,
									 funcSelect:Function = null, funcSelectParam:* = null, strSelect:String = "",
									 funcStr:String="",strCancel:String="",funcCancel:Function=null,align:String = "center"):void
		{
			
			Panel2BtnPromptData.strContent = "\n<p align='" + align + "'>" + txt + "</p>";
			Panel2BtnPromptData.strSureBtn =funcStr==""?StringConst.PROMPT_PANEL_0003:funcStr;
			Panel2BtnPromptData.funcBtn = funcBtn;
			Panel2BtnPromptData.funcBtnParam = funcBtnParam;
			Panel2BtnPromptData.haveSelected = true;
			Panel2BtnPromptData.funcSelect = funcSelect;
			Panel2BtnPromptData.funcSelectParam = funcSelectParam;
			Panel2BtnPromptData.strSelect = strSelect;
			Panel2BtnPromptData.cancelFunc = funcCancel;
			Panel2BtnPromptData.strCancelBtn = strCancel==""?StringConst.PROMPT_PANEL_0013:strCancel;
			PanelMediator.instance.switchPanel(PanelConst.TYPE_2BTN_PROMPT);
		}
		
		/**RollTipType.ERROR*/
		public static function warning(txt:String):void
		{
			RollTipMediator.instance.showRollTip(RollTipType.ERROR, txt);
		}
		/**RollTipType.SYSTEM*/
		public static function message(txt:String):void
		{
			RollTipMediator.instance.showRollTip(RollTipType.SYSTEM, txt);
		}
		/**RollTipType.REWARD*/
		public static function reward(txt:String):void
		{
			RollTipMediator.instance.showRollTip(RollTipType.REWARD, txt);
		}
		/**聊天框中显示系统消息*/
		public static function mesageChatPanel(txt:String):void
		{
			ChatDataManager.instance.sendSystemNotice(txt);
		}

		/**打开快捷面板
		 *    type是AcquireCostType
		 * */
		public static function showAcquirePanel(type:int):void
		{
			var msg:String = "";
			switch (type)
			{
				case AcquireCostType.TYPE_GOLD:
					msg = StringConst.RESOURCE_LACK_1;
					break;
				case AcquireCostType.TYPE_TICKET:
					msg = StringConst.RESOURCE_LACK_2;
					break;
				case AcquireCostType.TYPE_SCORE:
					msg = StringConst.RESOURCE_LACK_3;
					break;
			}
			RollTipMediator.instance.showRollTip(RollTipType.ERROR, StringConst.TIP_GOLD_NOT_ENOUGH);
			AcquireManager.costType = type;
			PanelMediator.instance.openPanel(PanelConst.TYPE_MALL_ACQUIRE);
		}


		/**
		 * @param content 内容
		 * @param isNumber 输入框文本是否是数字
		 * @param maxValue 仅当输入文本框的是数字时才有效
		 * @param okFunc 确定按钮要执行的函数 有参数 okFunc(string);
		 * @param warnTxt  警告文本 只有当 warnFunc函数满足一条条件才显示
		 * @param warnFunc 返回boolean 触发warnTxt显示的条件函数
		 * @param funcCancel取消函数
		 * @param funcCancelParam 取消函数参数
		 * @param title标题 默认为 温馨提示
		 * @param btnOkTxt 确定按钮的文本
		 * @param btnCancelTxt 取消按钮的文本
		 * */
		public static function showInputPanel(content:String, isNumber:Boolean = false, maxValue:int = int.MAX_VALUE, okFunc:Function = null, warnTxt:String = null, warnFunc:Function = null, funcCancel:Function = null,
											  funcCancelParam:* = null, title:String = StringConst.PROMPT_PANEL_0005, btnOkTxt:String = StringConst.PROMPT_PANEL_0012, btnCancelTxt:String = StringConst.PROMPT_PANEL_0013):void
		{
			InputData.title = title;
			InputData.maxValue = maxValue;
			InputData.btnTxt1 = btnOkTxt;
			InputData.btnTxt2 = btnCancelTxt;
			InputData.content = content;
			InputData.isNumber = isNumber;
			InputData.warn = warnTxt;
			InputData.btnOkFunc = okFunc;
			InputData.warnFunc = warnFunc;
			InputData.btnCancelFunc = funcCancel;
			InputData.btnCancelFuncParam = funcCancelParam;
			PanelMediator.instance.openPanel(PanelConst.TYPE_INPUT);
		}
	}
}