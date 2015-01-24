package GGM.panel
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.filters.ShaderFilter;
	import flash.text.TextField;
	
	import GGM.skin.GameSkin;
	
	import morn.core.components.Label;

	/**
	 * 用户信息面板 
	 * @author LionelZhangz
	 * 
	 */	
	public class PlayerInfoView extends Sprite
	{
		public function PlayerInfoView()
		{
			
			_bg = new Bitmap(GameSkin.playerinfoBg_bitmapdata);
			_bg.width = 800;
			_bg.height = 50;
			this.addChild(_bg);
			
			avatar = new Bitmap(GameSkin.avatar_bitmapdata);
			this.addChild(avatar);
			avatar.width = 25;
			avatar.height = 50;
			
			hpBar = new ProcessBar(100);
			this.addChild(hpBar);
			
			hpBar.x = avatar.width;
			hpBar.y = 3;
			
			hpBar.setNowVal(50);
			
			noticePanel = new NoticePanel();
			
			noticePanel.x = 400;
			this.addChild(noticePanel);
			
			leftPlayerTxt = new TextField();
			this.addChild(leftPlayerTxt);
			leftPlayerTxt.x = hpBar.x + hpBar.width + 10;
			leftPlayerTxt.filters = [new GlowFilter(0)]
			leftPlayerTxt.y = 3;
		}
		
		/**
		 * 头像 
		 */		
		private var avatar:Bitmap;
		
		/**
		 * 背景条 
		 */		
		private var _bg:Bitmap;
		
		/**
		 * 信息面板 
		 */		
		public var noticePanel:NoticePanel;
		
		/**
		 * 血条 
		 */		
		private var hpBar:ProcessBar;
		
		/**
		 * 剩下玩家的数量文字 
		 */		
		private var leftPlayerTxt:TextField;
		
		override public function get height():Number
		{
			return _bg.height;
		}
		
		public function setNowHp(val:int):void
		{
//			trace(val);
			this.hpBar.setNowVal(val < 0?0:val);
		}
		
		public function refreshMaxHp():void
		{
			this.hpBar.refreshMaxVal();
		}
		
		/**
		 * 设置剩余人数 
		 * @param val
		 * 
		 */		
		public function setLeftPerson(val:int):void
		{
			leftPlayerTxt.htmlText = "<font size='12' color='#ffffff'>left:</font><font size='12' color='#00ff00'>" + val + "</font>"
		}
	}
}