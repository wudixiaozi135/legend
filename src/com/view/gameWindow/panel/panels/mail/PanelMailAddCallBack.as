package com.view.gameWindow.panel.panels.mail
{
	import com.model.consts.StringConst;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.mail.data.MailData;
	import com.view.gameWindow.panel.panels.mail.data.MailState;
	import com.view.gameWindow.panel.panels.mail.data.PanelMailDataManager;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class PanelMailAddCallBack
	{
		public function PanelMailAddCallBack()
		{
		}
		
		public function addCallBack(rsrLoader:RsrLoader,mcMail:McMail):void
		{
			rsrLoader.addCallBack(mcMail.btnDeleteAll,function(mc:MovieClip):void
			{
				(mc.txt as TextField).text = StringConst.MAIL_PANEL_0004;
			});
			rsrLoader.addCallBack(mcMail.btnGetAll,function(mc:MovieClip):void
			{
				(mc.txt as TextField).text = StringConst.MAIL_PANEL_0005;
			});
			//
			rsrLoader.addCallBack(mcMail.mcItem0.mcSign,function(mc:MovieClip):void
			{
				var mailDatas:Vector.<MailData> = PanelMailDataManager.instance.mailDatas;
				if(mailDatas.length <= 0)
				{
					return;
				}
				var mailData:MailData = mailDatas[0];
				if(!mailData)
				{
					return;
				}
				var state:int = mailData.state
				if(state == MailState.UNREAD)
				{
					mc.gotoAndStop(1);
				}
				else
				{
					mc.gotoAndStop(2);
				}
				mc.mouseEnabled = false;
			});
			rsrLoader.addCallBack(mcMail.mcItem1.mcSign,function(mc:MovieClip):void
			{
				var mailDatas:Vector.<MailData> = PanelMailDataManager.instance.mailDatas;
				if(mailDatas.length <= 1)
				{
					return;
				}
				var mailData:MailData = mailDatas[1];
				if(!mailData)
				{
					return;
				}
				var state:int = mailData.state;
				if(state == MailState.UNREAD)
				{
					mc.gotoAndStop(1);
				}
				else
				{
					mc.gotoAndStop(2);
				}
			});
			rsrLoader.addCallBack(mcMail.mcItem2.mcSign,function(mc:MovieClip):void
			{
				var mailDatas:Vector.<MailData> = PanelMailDataManager.instance.mailDatas;
				if(mailDatas.length <= 2)
				{
					return;
				}
				var mailData:MailData = mailDatas[2];
				if(!mailData)
				{
					return;
				}
				var state:int = mailData.state;
				if(state == MailState.UNREAD)
				{
					mc.gotoAndStop(1);
				}
				else
				{
					mc.gotoAndStop(2);
				}
			});
			rsrLoader.addCallBack(mcMail.mcItem3.mcSign,function(mc:MovieClip):void
			{
				var mailDatas:Vector.<MailData> = PanelMailDataManager.instance.mailDatas;
				if(mailDatas.length <= 3)
				{
					return;
				}
				var mailData:MailData = mailDatas[3];
				if(!mailData)
				{
					return;
				}
				var state:int = mailData.state;
				if(state == MailState.UNREAD)
				{
					mc.gotoAndStop(1);
				}
				else
				{
					mc.gotoAndStop(2);
				}
			});
			rsrLoader.addCallBack(mcMail.mcItem4.mcSign,function(mc:MovieClip):void
			{
				var mailDatas:Vector.<MailData> = PanelMailDataManager.instance.mailDatas;
				if(mailDatas.length <= 4)
				{
					return;
				}
				var mailData:MailData = mailDatas[4];
				if(!mailData)
				{
					return;
				}
				var state:int = mailData.state;
				if(state == MailState.UNREAD)
				{
					mc.gotoAndStop(1);
				}
				else
				{
					mc.gotoAndStop(2);
				}
			});
			//
			rsrLoader.addCallBack(mcMail.mcItem0.btnFunc,function(mc:MovieClip):void
			{
				var mailDatas:Vector.<MailData> = PanelMailDataManager.instance.mailDatas;
				if(mailDatas.length <= 0)
				{
					return;
				}
				var mailData:MailData = PanelMailDataManager.instance.mailDatas[0];
				if(!mailData)
				{
					return;
				}
				var state:int = mailData.state;
				if(state == MailState.GET)
				{
					mc.gotoAndStop(2);
				}
				else
				{
					mc.gotoAndStop(1);
				}
			});
			rsrLoader.addCallBack(mcMail.mcItem1.btnFunc,function(mc:MovieClip):void
			{
				var mailDatas:Vector.<MailData> = PanelMailDataManager.instance.mailDatas;
				if(mailDatas.length <= 1)
				{
					return;
				}
				var mailData:MailData = mailDatas[1];
				if(!mailData)
				{
					return;
				}
				var state:int = mailData.state;
				if(state == MailState.GET)
				{
					mc.gotoAndStop(2);
				}
				else
				{
					mc.gotoAndStop(1);
				}
			});
			rsrLoader.addCallBack(mcMail.mcItem2.btnFunc,function(mc:MovieClip):void
			{
				var mailDatas:Vector.<MailData> = PanelMailDataManager.instance.mailDatas;
				if(mailDatas.length <= 2)
				{
					return;
				}
				var mailData:MailData = mailDatas[2];
				if(!mailData)
				{
					return;
				}
				var state:int = mailData.state;
				if(state == MailState.GET)
				{
					mc.gotoAndStop(2);
				}
				else
				{
					mc.gotoAndStop(1);
				}
			});
			rsrLoader.addCallBack(mcMail.mcItem3.btnFunc,function(mc:MovieClip):void
			{
				var mailDatas:Vector.<MailData> = PanelMailDataManager.instance.mailDatas;
				if(mailDatas.length <= 3)
				{
					return;
				}
				var mailData:MailData = mailDatas[3];
				if(!mailData)
				{
					return;
				}
				var state:int = mailData.state;
				if(state == MailState.GET)
				{
					mc.gotoAndStop(2);
				}
				else
				{
					mc.gotoAndStop(1);
				}
			});
			rsrLoader.addCallBack(mcMail.mcItem4.btnFunc,function(mc:MovieClip):void
			{
				var mailDatas:Vector.<MailData> = PanelMailDataManager.instance.mailDatas;
				if(mailDatas.length <= 4)
				{
					return;
				}
				var mailData:MailData = mailDatas[4];
				if(!mailData)
				{
					return;
				}
				var state:int = mailData.state;
				if(state == MailState.GET)
				{
					mc.gotoAndStop(2);
				}
				else
				{
					mc.gotoAndStop(1);
				}
			});
		}
	}
}