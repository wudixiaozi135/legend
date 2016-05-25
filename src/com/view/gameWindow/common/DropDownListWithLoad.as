package com.view.gameWindow.common
{
	import com.model.gameWindow.rsr.RsrLoader;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	
	/**
	 * @author wqhk
	 * 2014-10-15
	 */
	public class DropDownListWithLoad extends DropDownList
	{
		private var callback:CountCallback;
		private var owner:MovieClip;
		private var labelDisplayName:String;
		private var btnDisplayName:String;
		
		override public function destroy():void
		{
			owner = null;
			
			if(callback)
			{
				callback.destroy();
				callback = null;
			}
			
			super.destroy();
		}
		
		public function DropDownListWithLoad(data:Array, 
											 label:TextField, 
											 width:int, 
											 loader:RsrLoader,
											 owner:MovieClip,
											 labelDisplayName:String = null, 
											 btnDisplayName:String=null, 
											 prompt:String="")
		{
			super(data, label, width, null, null, prompt);
			label.mouseEnabled = false;
			this.owner = owner;
			this.labelDisplayName = labelDisplayName;
			this.btnDisplayName = btnDisplayName;
			var num:int = 0;
			
			if(labelDisplayName)
			{
				++num;
			}
			if(btnDisplayName)
			{
				++num
			}
			
			if(num>0)
			{
				callback = new CountCallback(initBtn,num);
				if(labelDisplayName)
				{
					loader.addCallBack(owner[labelDisplayName],function():void{
						callback.call()
					});
				}
				if(btnDisplayName)
				{
					loader.addCallBack(owner[btnDisplayName],function():void{
						callback.call()});
				}
			}
		}
		
		private function initBtn():void
		{
			if(labelDisplayName)
			{
				labelDisplay = owner[labelDisplayName];
				
				if(labelDisplay is MovieClip)
				{
					MovieClip(labelDisplay).buttonMode = true;
					MovieClip(labelDisplay).useHandCursor = true;
				}
			}
			if(btnDisplayName)
			{	
				btnDisplay = owner[btnDisplayName];
			}
			
			init();
		}
	}
}