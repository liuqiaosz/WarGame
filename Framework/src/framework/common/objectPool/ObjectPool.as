package framework.common.objectPool
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	
	import framework.helper.HelpUtils;
	

	/**
	 * 对象池，目的是为了复用对象，避免昂贵的创建对象开销
	 */

	final public class ObjectPool
	{
		//存放复用对象实例的容器
		private var _objectInstances:Vector.<Object>;//:Array = null;

		//对象池中存储的对象类型
		private var _definition:Class = null;

		//容量
		private var _capability:uint = 0;

		//池溢出警告
		private var _overflowExceptionTurnOn:Boolean = false;

		//空池警告
		private var _emptyExceptionTurnOn:Boolean = false;
		
		private var _newCreateCount:int = 0;

		/**
		 * 因为对象池空（没有现成的对象）而导致需要新创建的对象数 
		 * @return 
		 * 
		 */		
		public function get newCreateCount():int
		{
			return _newCreateCount;
		}

		private var _reusedObjectCount:int = 0;

		/**
		 * 合计重用过的次数 
		 * @return 
		 * 
		 */		
		public function get reusedObjectCount():int
		{
			return _reusedObjectCount;
		}

		private var _purgedObjectCount:int = 0;

		/**
		 * 因为对象池满而扔掉的对象数 
		 * @return 
		 * 
		 */		
		public function get purgedObjectCount():int
		{
			return _purgedObjectCount;
		}


		/**
		 * 构造函数，创建一个对象池
		 *
		 * @param c 对象池存储的对象类型
		 * @param capability 容量，最大可复用对象的个数
		 * @param overflowExceptionTurnOn 是否开启对象池溢出警告，
		 * 开启此设置后，当向池中放入超过池容量的可重用对象时，会抛出异常
		 * @param emptyExceptionTurnOn 是否开启空池异常，
		 * 开启此设置后，如果池中没有可重用对象，将抛出异常，
		 * 未开启此设置时，如果池中没有可重用对象，则会创建一个新的对象返回
		 *
		 * @throws NullPointerException
		 * 指定的池存储类型是null
		 * @throws ArgumentError
		 * 指定的对象池容量小于0
		 */
		public function ObjectPool(c:Class, capability:int,
								   overflowExceptionTurnOn:Boolean = false,
								   emptyExceptionTurnOn:Boolean = false)
		{
			var pool:ObjectPool = classPools[ c ] as ObjectPool;
			if( pool ){
				//已经存在该池
				//Tracer.logch( c, "已经存在该池:" + c  )
				throw new Error("this class' object pool is already created. you cann't create it again.Please use getObjectPool() method." );
			}
			if(c == null)
			{
				throw new Error("Null definition");
			}

			if(capability < 0)
			{
				throw new ArgumentError("Object pool's Capability is \"" + capability + "\", less than 0");
			}

			//放到全局池中， 这里可能会有多线程时的操作隐患！！！
			classPools[ c ] = this;

			_capability = capability;
			_definition = c;
			_overflowExceptionTurnOn = overflowExceptionTurnOn;
			_emptyExceptionTurnOn = emptyExceptionTurnOn;
			_objectInstances = new Vector.<Object>;//[];

//			initializeObjects( GROWTH_VALUE );
		}
		
//		private static const GROWTH_VALUE:uint = 20;
		
		/**
		 * 要往池中新初始化多少个对象 
		 * @param createCount
		 * 
		 */		
		public function initializeObjects( createCount:uint ):void 
		{ 
			var i:uint = createCount; 
			
			while( --i >= 0 ) 
				_objectInstances.push( new _definition() );
		} 


		/**
		 * 获得对象池的容量
		 *
		 * @return
		 */
		public function get capacity():int
		{
			return _capability;
		}
		
		public function set capacity( value:int ):void
		{
			_capability = value;
		}

		/**
		 * 获得当对象池中可复用对象的数量
		 *
		 * @return
		 */
		public function get count():int
		{
			if ( !_objectInstances) return 0;

			return _objectInstances.length;
		}

		/**
		 * 判断对象池是否开启了溢出异常
		 *
		 * @return
		 */
		public function get overflowExceptionTurnOn():Boolean
		{
			return _overflowExceptionTurnOn;
		}

		/**
		 * 判断对象池是否开启了空池异常
		 *
		 * @return
		 */
		public function get emptyExceptionTurnOn():Boolean
		{
			return _emptyExceptionTurnOn;
		}

//		/**
//		 * 获得对象池中所有的对象
//		 *
//		 * @return
//		 */
//		public function reuseableIterator():IIterator
//		{
//			return new ArrayIterator(_objectInstances);
//		}

		
		/**
		 * 创建对象，
		 * 如果池中有可复用的，直接返回可复用的对象，
		 * 否则创建一个新的。
		 * 注意： 如果打开了空池警告，则当池中没有可重用对象时抛出异常!
		 *
		 * @param arguments 创建对象构造函数的参数列表，
		 * null表示构造对象不需要参数列表
		 *
		 * @throws IllegalOperationError
		 * 开启了空池异常，并且池中没有可以重用的对象
		 *
		 * @return
		 */
		public function getInstance(arguments:Array = null):*
		{
			if(_objectInstances.length > 0)
			{
				_reusedObjectCount++;
//				Tracer.debugch( "ObjectPool" , this._definition + "-直接获取一个对象，剩余总数为："+ (this.count-1)
//					+ "，已重用次数：" + _reusedObjectCount);
				return _objectInstances.pop();
			}
			else
			{
				if(_emptyExceptionTurnOn)
				{
					throw new IllegalOperationError("Objects pool is empty");
					return null;
				}
				else
				{
					_newCreateCount++;
//					Tracer.debugch( "ObjectPool" , this._definition + "-创建一个新对象，池中总数为：" + this.count
//						+  "，共新创建的对象数：" + _newCreateCount);
					var obj:Object = HelpUtils.newApply(_definition, arguments);

					return obj;
				}
			}
		}

		/**
		 * 将一个可重用对象放入池中，
		 * 如果对象实现了IReuseable接口，将调用其reuse方法
		 *
		 * @param object 指定的重用对象
		 *
		 * @throws NullPointerException
		 * 指定的可重用对象是null
		 * @throws UnknownTypeException
		 * 当前池不容纳该类型的对象
		 * @throws IllegalOperationError
		 * 开启了池溢出异常并且池已经满了
		 *
		 * @return 是否成功向池中添加了一个重用对象，
		 * 如果未成功并且没有异常，则表明对象池已经满了，无法继续添加
		 */
		public function returnInstance(obj:Object):Boolean
		{
			if(obj == null)
			{
				throw new Error("Null object");
			}

			if(!(obj is _definition))
			{
				throw new Error("Reuse object is not the type of:" + _definition)
			}

			reuseObject( obj );//不管是不是真回收，先做好重置的准备
			
//			return false;//测试!!!!!!!!
			
			var addSuccess:Boolean = false;

			//池满了
			if(_objectInstances.length >= this.capacity)
			{
				_purgedObjectCount++;
//				Tracer.warnch("ObjectPool", this._definition + "已满，不再回收对象。池中总数为:"+ _objectInstances.length 
//					+ " ,已扔掉对象数：" + _purgedObjectCount  );
				if(_overflowExceptionTurnOn)
				{
					throw new IllegalOperationError("The objects pool is full");
				}
			}
			else
			{
				_objectInstances.push(obj);
//				Tracer.debugch( "ObjectPool" , this._definition + "-回收了一个对象，池中总数为："+ _objectInstances.length );
				
				addSuccess = true;
			}

			return addSuccess;
		}

		/**
		 * 把对象重置，以便重用
		 * @param obj
		 *
		 */
		internal static function reuseObject(obj:*):void
		{
			if(obj is IReuseable)
			{
				IReuseable(obj).reuse();
//				return;//不能直接返回，因为可能要回收的对象是常用的显示类型(Sprite/Bitmap/etc)，
			}
			
			//重置常用的显示类型
			if(obj is Sprite) {
				obj.graphics.clear();
				obj.mouseEnabled = true;//要重置鼠标事件，以免使用者假定是可接受鼠标事件的
				obj.mouseChildren = true;
				obj.focusRect = obj.hitArea = null;
				obj.filters = [];
//				obj.name = "";
//				obj.rotationX = obj.rotationY = obj.rotationZ = 0;
//				obj.useHandCursor = true;
//				obj.buttonMode = false;
			}else if( obj is Bitmap )
			{
				obj.bitmapData = null;
			}else if(obj is MovieClip) {
				obj.gotoAndStop(1);
			}else if(obj is Shape) {
				obj.graphics.clear();
			}
			
			if(obj is DisplayObject) {
				HelpUtils.removeSelf(obj,false);
				obj.x = obj.y = obj.rotation = 0;;
				obj.alpha = obj.scaleX= obj.scaleY = 1;
				obj.blendMode = BlendMode.NORMAL;
				obj.cacheAsBitmap = false;
				obj.filters= [];
				obj.scrollRect =  obj.mask = obj.opaqueBackground = null;
				obj.transform.matrix = new Matrix();
				obj.visible = true;
				obj.scale9Grid = null;
				//obj.transform.colorTransform = new ColorTransform();
			}
			if( obj is DisplayObjectContainer )
			{
				(obj as DisplayObjectContainer).removeChildren();
			}
		}

		/** Use this method delete stored instances and free some memory
		 */
		public function destroy():void
		{
			delete ObjectPool.classPools[ _definition ] ;

			if(_objectInstances.length > 0)
			{
				HelpUtils.breakArray(_objectInstances);
			}

			_objectInstances = null;
			_definition = null;
		}

		private static var _classPools:Dictionary;
		/** @private */
		protected static function get classPools():Dictionary
		{
			if( !_classPools ) _classPools = new Dictionary(false);
			return _classPools;
		}

		/**
		 * 获取指定类的对象池，如果不存在，则自动创建该类的对象池
		 * @param c
		 * @return
		 *
		 */
		public static function getObjectPoolOf( c:Class ):ObjectPool
		{
			var pool:ObjectPool = classPools[c] as ObjectPool;
			if( !pool ){
				//Tracer.logch( c, " 不存在该池，新创建该池"  )
				pool = buildDefaultPool( c );
			}
			return pool ;
		}
		
		/**
		 * 初始化某个类的对象池 
		 * @param c
		 * @param createCount 初始化池时，要先创建多少个该对象
		 * @param capacity 容器。如果不指定，则使用全局默认容量
		 */		
		public static function initializePoolOf( c:Class, createCount:uint, capacity:int = 0 ):void 
		{ 
			var pool:ObjectPool = getObjectPoolOf(c);
			pool.initializeObjects(createCount);
			if( capacity <=0  ) capacity = defaultCapacity; 
			pool.capacity = capacity;
		} 

		/**
		 * 获取对象池中的对象。
		 * 如果池中有现在的对象，则获取对象的性能基本稳定在，平均获取100000次耗时：150ms(Firefox FlashPlayerV11)。
		 * 对于轻量级的对象，不建议使用对象池来获取，因为直接new更快。当然，如果不想有过多的对象被垃圾回收，还是可以考虑采用本方法来获取对象的。
		 * @param c The Class that is to be instantiated
		 * @param parameters An array of up to ten parameters to pass to the constructor. 最大参数数量不能超过10个
		 * @return An instance of the given class. You will need to cast it into the appropiate type
		 */
		public static function getInstanceOf(c:Class, ...parameters ):* {

			// Retrieve list of available objects for this class
			var pool:ObjectPool = ObjectPool.getObjectPoolOf( c );

			/*// Is it empty ? Then add one
			if(pool.length==0) {
			pool.push(new c());
			}

			// Return
			var r:Object = pool.pop()*/
			var obj:Object = parameters.length > 0 ? pool.getInstance( parameters ) : pool.getInstance( null ) ;

			return obj ;

		}

		private static var _defaultCapacity:int = 50;

		/**
		 * 获取对象池的默认最大容量
		 * @return
		 *
		 */
		public static function get defaultCapacity():int
		{
			return _defaultCapacity;
		}

		public static function set defaultCapacity(value:int):void
		{
			_defaultCapacity = value;
		}

		private static function buildDefaultPool( c:Class ):ObjectPool{
			return new ObjectPool(c, defaultCapacity );
		}

		/**
		 * Use this method to return unused objects to the pool and make them available to be used again later. Make sure you remove old
		 * references to this object or you will get all sorts of weird results.
		 *
		 * <p>For convenience, if the instance is a DisplayObject, its coordinates, transform values, filters, etc. are reset.</p>
		 *
		 * @param object The object you are returning to the pool
		 */
		public static function returnInstance(object:Object):Boolean {

			if(!object) return false;
			var c:Class = object.constructor;

			var pool:ObjectPool = getObjectPoolOf( c );
			return pool.returnInstance( object );

		}

		/** 释放某个类的对象池
		 * Use this method delete stored instances and free some memory
		 *
		 * @param c The Class whose stored instances are to be flushed.
		 */
		public static function destroy( c:Class ):void {
			if( !c ) return ;

			var pool:ObjectPool = ObjectPool.classPools[c];
			if( ! pool ){
				return;
			}

			//Tracer.logch( c, "销毁对象池，共 " + pool.count + " 个")

			pool.destroy();
			//ObjectPool.classPools[c] = null;
			delete ObjectPool.classPools[c];

			//for(var i:* in ObjectPool.classPools) ObjectPool.classPools[i] = null

			// This is really not needed and causes a very annoying player freeze.
			//objectPool.garbageCollect()
		}

		/** 释放所有的对象池
		 * Use this method delete stored instances and free some memory of all classes' pools
		 *
		 */
		public static function destroyAll():void {
			//Tracer.logch( "ObjectPool", "销毁全部对象池，共 " + totalCount + " 个")
			for(var c:* in ObjectPool.classPools){
				var pool:ObjectPool = ObjectPool.classPools[c];
				pool.destroy();
				//ObjectPool.classPools[c] = null;
				delete ObjectPool.classPools[c];

			}

			// This is really not needed and causes a very annoying player freeze.
			//objectPool.garbageCollect()
		}

		/**
		 * 获得所有对象池中可复用对象的总数量
		 * 注意，如果数量太多，可能会越界?
		 *
		 * @return
		 */
		public static function get totalCount():uint
		{
			var count:Number  = 0 ;
			for( var i:* in  classPools )
			{
				count += ( classPools[i] as ObjectPool ).count;

			}
			return count;
		}

//		/**@warnning 不建议调用此方法
//		 * Explicitly invokes the garbage collector
//		 * This is really not needed and causes a very annoying player freeze.
//		 * @private
//		 */
//		public static function garbageCollect():void {
//			try	{
//				var hlcp:LocalConnection = new LocalConnection()
//				var hlcs:LocalConnection = new LocalConnection()
//				hlcp.connect('name')
//				hlcs.connect('name')
//			}	catch (e:Error)	{
//				System.gc()
//				System.gc()
//			}
//		}
	}
}