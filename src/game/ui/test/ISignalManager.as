/*
   Copyright (c) 2012, DarkMist Corporation
   All rights reserved.
   @author: Jian. @modification: 2012/10/01.
 */
package game.ui.test
{
	/**
	 * 控制台命令接口
	 */
	public interface ISignalManager
	{
		// --------------------------------
		//{ 公共方法
		
		/**
		 * 执行命令
		 *
		 * @param	command		命令
		 * @param	...args		参数
		 */
		function executeCommand(command:String, ...args):void;
		
		/**
		 * 注册命令
		 *
		 * @param	key		关键字
		 * @param	point	类实例
		 * @param	handle	命令函数
		 */
		function registerCommandHandler(key:String, point:Object, handler:Function):void
		/**
		 * 注销系列指令 
		 * @param key
		 * 
		 */			
		function unregisterAllCommandHandler(key:String):void;
		/**
		 * 注销单个指令 
		 * @param key
		 * @param point
		 * @param handler
		 * 
		 */		
		function unregisterSingleCommandHandler(key:String,point:Object,handler:Function):void;
		
		//}
		// --------------------------------
	}
}