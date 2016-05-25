package com.view.gameWindow.panel.panels.mail
{
	import com.model.consts.StringConst;
	import com.view.gameWindow.panel.PanelConst;
	import com.view.gameWindow.panel.PanelMediator;
	import com.view.gameWindow.panel.panelbase.IPanelBase;
	import com.view.gameWindow.panel.panels.mail.data.MailData;
	import com.view.gameWindow.panel.panels.mail.data.MailState;
	import com.view.gameWindow.panel.panels.mail.data.PanelMailDataManager;
	import com.view.gameWindow.util.HtmlUtils;
	import com.view.gameWindow.util.UtilItemParse;
	
	import flash.events.MouseEvent;

	/**
	 * 邮件面板项目处理类
	 * @author Administrator
	 */	
	public class PanelMailItemsHandle
	{
		private var _panel:PanelMail;
		private var _mc:McMail;
		
		private var _page:int = 1,_totalPage:int = 0,_numPage:int = 5;
		
		public function PanelMailItemsHandle(panel:PanelMail)
		{
			_panel = panel;
			_mc = _panel.skin as McMail;
			init();
		}
		
		private function init():void
		{
			_mc.addEventListener(MouseEvent.CLICK,onClick,false,1);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			if(event.target == _mc.btnPrev)
			{
				dealPrev();
				return;
			}
			else if(event.target == _mc.btnNext)
			{
				dealNext();
				return;
			}
			var i:int;
			for(i=0;i<_numPage;i++)
			{
				var mcMailItem:McMailItem = _mc["mcItem"+i] as McMailItem;
				if(event.target == mcMailItem.mcClick)
				{
					dealReadMail(i);
					break;
				}
				else if(event.target.parent && event.target.parent == mcMailItem.btnFunc)
				{
					dealMailFunc(i);
					break;
				}
			}
		}
		
		private function dealPrev():void
		{
			if(_page > 1)
			{
				_page--;
				refresh();
			}
		}
		
		private function dealNext():void
		{
			if(_page < _totalPage)
			{
				_page++;
				refresh();
			}
		}
		
		private function dealReadMail(i:int):void
		{
			var index:int = ((_page - 1)*_numPage)+i;
			PanelMailDataManager.instance.readMail(index);
			var openedPanel:IPanelBase = PanelMediator.instance.openedPanel(PanelConst.TYPE_MAIL_CONTENT);
			if(openedPanel)
			{
				PanelMediator.instance.closePanel(PanelConst.TYPE_MAIL_CONTENT);
			}
			PanelMediator.instance.openPanel(PanelConst.TYPE_MAIL_CONTENT);
		}
		/**处理提取附件或删除邮件*/
		private function dealMailFunc(i:int):void
		{
			var index:int = ((_page - 1)*_numPage)+i;
			var mailData:MailData = PanelMailDataManager.instance.mailDatas[index];
			if(mailData.state != MailState.GET)
			{
				/*PanelMailDataManager.instance.getMailAttachment(index);*/
				dealReadMail(i);
			}
			else
			{
				PanelMailDataManager.instance.delMail(index);
			}
		}
		
		public function refresh():void
		{
			var emailDatas:Vector.<MailData> = PanelMailDataManager.instance.mailDatas;
			var numTotal:uint = emailDatas.length;
			_totalPage = int((numTotal+_numPage-1)/_numPage);
			var i:int;
			for(i=0;i<_numPage;i++)
			{
				var index:int = (_page-1)*_numPage+i;
				if(index < emailDatas.length)
				{
					setItemVisible(true,i);
					var mailData:MailData = emailDatas[index];
					doRefresh(mailData,i);
				}
				else
				{
					setItemVisible(false,i);
					_mc["mcItem"+i].txt.text = "";
				}
			}
			//
			if(_totalPage == 0)
			{
				_mc.txtPage.text = "1/1";
			}
			else
			{
				_mc.txtPage.text = _page+"/"+_totalPage;
			}
		}
		
		private function setItemVisible(value:Boolean,i:int):void
		{
			_mc["mcItem"+i].visible = value;
		}
		
		private function doRefresh(mailData:MailData,i:int):void
		{
			var mcMailItem:McMailItem = _mc["mcItem"+i] as McMailItem;
			var string:String = StringConst.MAIL_PANEL_0002 + HtmlUtils.createHtmlStr(0xffe1aa,mailData.title) + "\n" + StringConst.MAIL_PANEL_0003;
			//
			var attachment:String = mailData.attachment;
			if(attachment)
			{
				var reward:String,rewards:Array;
				reward = "";
				rewards = attachment.split("|");
				var i:int,l:int = Math.min(3,rewards.length);
				for(i=0;i<l;i++)
				{
					var itemStrs:Array = UtilItemParse.getItemString(rewards[i]);
					reward += HtmlUtils.createHtmlStr(itemStrs[0],itemStrs[1]+"*"+itemStrs[2],12,false,2,"SimSun",true) + (i!=l-1 ? "，" : StringConst.MAIL_PANEL_0013);
				}
				string += mailData.state == MailState.GET ? StringConst.MAIL_PANEL_0012 : reward;
				mcMailItem.txt.htmlText = string;
			}
			else
			{
				mcMailItem.txt.htmlText = "";
			}
			//
			if(mailData.state == MailState.UNREAD)
			{
				mcMailItem.mcSign.gotoAndStop(1);
			}
			else
			{
				mcMailItem.mcSign.gotoAndStop(2);
			}
			//
			if(mailData.state == MailState.GET)
			{
				mcMailItem.btnFunc.gotoAndStop(2);
			}
			else
			{
				mcMailItem.btnFunc.gotoAndStop(1);
			}
		}
		
		public function destroy():void
		{
			if(_mc)
			{
				_mc.removeEventListener(MouseEvent.CLICK,onClick);
				_mc = null;
			}
			_panel = null;
		}
	}
}