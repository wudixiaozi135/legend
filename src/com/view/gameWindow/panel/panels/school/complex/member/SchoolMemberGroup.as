package com.view.gameWindow.panel.panels.school.complex.member
{
	import com.model.business.fileService.constants.ResourcePathConstants;
	import com.model.gameWindow.rsr.RsrLoader;
	import com.view.gameWindow.panel.panels.school.complex.member.MCMemberPanel.MCGroup;
	import com.view.gameWindow.panel.panels.school.complex.member.item.SchoolMemberItem;
	import com.view.gameWindow.util.scrollBar.IScrollee;
	import com.view.gameWindow.util.scrollBar.IScrolleeCell;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	public class SchoolMemberGroup extends MCGroup implements IScrollee
	{
		private const scrollRectH:int=352;
		protected var items:Vector.<IScrolleeCell>;
		private var _scrollRect:Rectangle;
		private var rsrLoader:RsrLoader;
		
		public function SchoolMemberGroup()
		{
			this.stop();
			items=new Vector.<IScrolleeCell>();
			_scrollRect=new Rectangle();
			this.scrollRect=_scrollRect;
			rsrLoader=new RsrLoader();
			addCallBack();
			rsrLoader.load(this,ResourcePathConstants.IMAGE_PANEL_FOLDER_LOAD,true);
			this.mouseEnabled=false;
		}
		
		private function addCallBack():void
		{
			rsrLoader.addCallBack(mcSelectBuf,function (mc:MovieClip):void
			{
				mcSelectBuf.mouseEnabled=mcSelectBuf.mouseChildren=false;
				mcSelectBuf.visible=false;
			});
			rsrLoader.addCallBack(mcMouseBuf,function (mc:MovieClip):void
			{
				mcMouseBuf.mouseEnabled=mcMouseBuf.mouseChildren=false;
				mcMouseBuf.visible=false;
			});
		}
		
		public function updateMember(schoolMembers:Vector.<SchoolMemberData>):void
		{
			while(items.length>0)
			{
				var item:SchoolMemberItem = items.pop() as SchoolMemberItem;
				item.destroy();
				item.parent&&item.parent.removeChild(item);
				item=null;
			}
			
			for(var i:int=0;i<schoolMembers.length;i++)
			{
				var schoolMember:SchoolMemberItem;
				schoolMember=new SchoolMemberItem();
				additem(schoolMember);
				schoolMember.y=(items.length-1)*35;
				schoolMember.update(schoolMembers[i]);
			}
		}
		
		public function get contentHeight():int
		{
			return items.length*35;
		}
		
		public function get scrollRectHeight():int
		{
			return scrollRectH;
		}
		
		public function setScrollRectWH(w:Number,h:Number):void
		{	
			_scrollRect.width=w;
			_scrollRect.height=h;
			this.scrollRect=_scrollRect;
		}
		
		public function additem(item:IScrolleeCell):void
		{
			addChild(item as DisplayObject);
			items.push(item);
		}
		
		public function removeAllItem():void
		{
			while(items.length)
			{
				var tmp:IScrolleeCell=items.shift();
				removeChild(tmp as DisplayObject);
				tmp&&tmp.destroy();
				tmp=null;
			}
		}
		
		public function destroy():void
		{
			if(rsrLoader)
			{
				rsrLoader.destroy();
				rsrLoader = null;
			}
			this.parent&&this.parent.removeChild(this);
			removeAllItem();
			destroySkin(this);
			items=null;
			_scrollRect=null;
		}
		
		private function destroySkin(skin:DisplayObjectContainer):void
		{
			while (skin.numChildren > 0)
			{
				var subSkin:DisplayObject = skin.getChildAt(0) as DisplayObject;
				if (subSkin)
				{
					var subSkinContainer:DisplayObjectContainer = subSkin as DisplayObjectContainer;
					if (subSkinContainer)
					{
						destroySkin(subSkinContainer);
					}
					skin.removeChild(subSkin);
					if (skin.hasOwnProperty(subSkin.name))
					{
						skin[subSkin.name] = null;
					}
				}
			}
		}

		
		public function scrollTo(pos:int):void
		{
			_scrollRect.y=pos;
			this.scrollRect=_scrollRect;
		}
		
		public function get scrollRectY():int
		{
			return _scrollRect.y;
		}
	}
}