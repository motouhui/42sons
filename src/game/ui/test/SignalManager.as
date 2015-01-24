package game.ui.test
{
	import flash.utils.Dictionary;
	
	/**
	 * 重写整个消息机制
	 * @author LionelZhang
	 * 
	 */	
	public class SignalManager implements ISignalManager
	{
		// --------------------------------
		//{ 单件模式
		
		/**
		 * OSGi Instance
		 */
		private static var _sManager:ISignalManager;
		
		/**
		 * Get OSGi Instance
		 *
		 * @return	OSGi Instance
		 */
		public static function get Manager():ISignalManager
		{
			if(SignalManager._sManager == null)
			{
				SignalManager._sManager = new SignalManager();
			}
			
			return SignalManager._sManager;
		}
		
		//}
		// --------------------------------
		
		public function SignalManager()
		{
			this._cmdDic = new Dictionary();
		}
		
		/**
		 * 指针字典
		 */
		private var _cmdDic:Dictionary;
		// --------------------------------
		//{ IConsoleCmd 方法
		
		/**
		 * 执行命令
		 *
		 * @param	command		命令
		 * @param	...args		参数
		 */
		public function executeCommand(command:String, ...args):void
		{
			if (command != null && !command.match(/^\s*$/))
			{
				// 获取命令信息
				var key:String = StringProcess.stringTrim(command);
				var nowList:Vector.<InvokeData> = this._cmdDic[key];
				if(nowList)
				{
					for(var i:int = 0;i < nowList.length ; i++)
					{
						var invokeData:InvokeData = nowList[i];
						if(invokeData == null)
							continue;
						invokeData.params = args;
						invokeData.callback();
					}
				}
				else
				{
					Root.traceInfo("Error: " + command + " is NULL -> Command can not be executed. Type '?' for more information. ");
				}
			}
		}
		
		/**
		 * 注销一个key下的所有指令 
		 * @param key
		 * 
		 */		
		public function unregisterAllCommandHandler(key:String):void
		{
			if (key != null && key != "")
			{
				key = StringProcess.stringTrim(key);
				
				delete this._cmdDic[key];
			}
			else
			{
				throw new ArgumentError("Error: CommandHandler key is null or empty. ");
			}
		}
		
		/**
		 * 注销命令
		 *
		 * @param	key		关键字
		 */
		public function unregisterSingleCommandHandler(key:String,point:Object,handler:Function):void
		{
			if (key != null && key != "")
			{
				var nowList:Vector.<InvokeData> = _cmdDic[key];
				if(nowList&&nowList.length != 0)
				{
					for(var i:int = 0; i < nowList.length ;i++)
					{
						if(nowList[i] != null&&nowList[i].invokeFunc == handler && nowList[i].invokePtr == point)
						{
							nowList[i] = null;
						}
					}
				}
				else
				{
					delete this._cmdDic[key];
				}
			}
			else
			{
				throw new ArgumentError("Error: CommandHandler key is null or empty. ");
			}
		}
		
		/**
		 * 注册命令
		 *
		 * @param	key		关键字
		 * @param	point	类实例
		 * @param	handle	命令函数
		 */
		public function registerCommandHandler(key:String, point:Object, handler:Function):void
		{
			var nowList:Vector.<InvokeData>;
			if (key != null && key != "")
			{
				key = StringProcess.stringTrim(key);
				
				if(_cmdDic[key] == null)
				{
					nowList = Vector.<InvokeData>([]);
					nowList.push(new InvokeData(point,handler));
				}
				else
				{
					nowList = _cmdDic[key];
					
					//是否插入
					var isInsert:Boolean = false;
					for(var i:int = 0 ; i < nowList.length ; i++)
					{
						if(nowList[i] == null)
						{
							nowList[i] = new InvokeData(point,handler);
							isInsert = true;
						}
						
						//如果碰到反复注册的则返回
						if(nowList[i].invokeFunc == handler && nowList[i].invokePtr == point)
						{
							return;
						}
					}
//					for each(var invoke:InvokeData in nowList)
//					{
//						if(invoke == null)
//						{
//							invoke = new InvokeData(point,handler);
//							isInsert = true;
//						}
//						
//						//如果碰到反复注册的则返回
//						if(invoke.invokeFunc == handler && invoke.invokePtr == point)
//						{
//							return;
//						}
//					}
					
					//如果没有填补空白则说明当前是满的，则要添加到最后
					if(!isInsert)
					{
						nowList.push(new InvokeData(point,handler));
					}
				}
				_cmdDic[key] = nowList;
			}
			else
			{
				throw new ArgumentError("Error: CommandHandler key is null or empty. ");
			}
		}
		
		//}
		// --------------------------------
	}
}