/*
 * D2D Canvas for Dart
 * 
 * By TakWolf - takgdx@gmail.com
 * http://www.takwolf.com/d2dcanvas
 * 
 * Released under Apache License 2.0
 * 
 */
part of d2d;

/**
 * 光标样式
 */
const String CURSOR_DEFAULT = 'default';     //默认光标（通常是一个箭头）
const String CURSOR_AUTO = 'auto';           //默认。浏览器设置的光标
const String CURSOR_CROSSHAIR = 'crosshair'; //光标呈现为十字线
const String CURSOR_POINTER = 'pointer';     //光标呈现为指示链接的指针（一只手）
const String CURSOR_MOVE = 'move';           //此光标指示某对象可被移动
const String CURSOR_E_RESIZE = 'e-resize';   //此光标指示矩形框的边缘可被向右（东）移动
const String CURSOR_NE_RESIZE = 'ne-resize'; //此光标指示矩形框的边缘可被向上及向右移动（北/东）
const String CURSOR_NW_RESIZE = 'nw-resize'; //此光标指示矩形框的边缘可被向上及向左移动（北/西）
const String CURSOR_N_RESIZE = 'n-resize';   //此光标指示矩形框的边缘可被向上（北）移动
const String CURSOR_SE_RESIZE = 'se-resize'; //此光标指示矩形框的边缘可被向下及向右移动（南/东）
const String CURSOR_SW_RESIZE = 'sw-resize'; //此光标指示矩形框的边缘可被向下及向左移动（南/西）
const String CURSOR_S_RESIZE = 's-resize';   //此光标指示矩形框的边缘可被向下移动（北/西）
const String CURSOR_W_RESIZE = 'w-resize';   //此光标指示矩形框的边缘可被向左移动（西）
const String CURSOR_TEXT = 'text';           //此光标指示文本
const String CURSOR_WAIT = 'wait';           //此光标指示程序正忙（通常是一只表或沙漏）
const String CURSOR_HELP = 'help';           //此光标指示可用的帮助（通常是一个问号或一个气球）
const String CURSOR_NONE = 'none';           //隐藏鼠标

/**
 * 回调类型
 */
typedef FrameCallback();

/**
 * D2D引擎类
 */
class D2DEngine extends D2DGraphics {
  
  //canvas和缓冲区
  CanvasElement _canvas = null;
  CanvasRenderingContext2D _ctx = null;
  CanvasElement _canvasBuffer = null;
  CanvasRenderingContext2D _ctxBuffer = null;
  //帧率相关-单位毫秒
  num _fps = 80; //默认80-引擎创建时赋值
  num _lastTime = 0;
  num _deltaTime = 0;
  int _currentFps = 0;
  int _frameCounter = 0;
  num _timeCounter = 0;  
  //帧回调
  FrameCallback _updateCallback = null;
  FrameCallback _drawCallback = null;
  //事件状态
  _MouseStates _mouseStates = new _MouseStates();
  _TouchStates _touchStates = new _TouchStates();
  _KeyboardStates _keyboardStates = new _KeyboardStates();
  //屏幕适配
  bool _enableGfxScaleAdjust = false;//使用矩阵变换方式适配屏幕-此时canvas和缓冲区大小不同
  num _screenScaleX = 1;
  num _screenScaleY = 1;
  
  /**
   * 创建
   */
  D2DEngine(String canvasId, num fps, int width, int height) {
    //绑定canvas并创建缓冲区
    _canvas = querySelector(canvasId);
    _canvas.width = width;
    _canvas.height = height;
    _ctx = _canvas.context2D;
    _canvasBuffer = new CanvasElement(width: width, height: height);
    _ctxBuffer = _canvasBuffer.context2D;
    //帧率
    _fps = fps;
  }
  
  /**
   * 创建引擎-普通
   */
  factory D2DEngine.normal(String canvasId, num fps, int width, int height) {
    return new D2DEngine(canvasId, fps, width, height);
  }
  
  /**
   * 创建引擎-绑定
   */
  D2DEngine.bind(String canvasId, num fps) {
    //绑定canvas并创建缓冲区
    _canvas = querySelector(canvasId);
    _ctx = _canvas.context2D;
    _canvasBuffer = new CanvasElement(width: _canvas.width, height: _canvas.height);
    _ctxBuffer = _canvasBuffer.context2D;
    //帧率
    _fps = fps;
  }

  /**
   * 创建引擎-填充全屏
   */
  factory D2DEngine.fullScreen(String canvasId, num fps) {
    //清除body样式
    document.body.style.margin = '0';
    document.body.style.padding = '0';
    //创建引擎
    D2DEngine engine =  new D2DEngine(canvasId, fps, window.innerWidth, window.innerHeight);
    //设置画布布局方式为固定
    engine._canvas.style.position = 'fixed';//absolute fixed
    engine._canvas.style.top = '0';
    engine._canvas.style.left = '0';
    //注册重置尺寸事件
    window.onResize.listen((Event event) {
      engine.setSize(window.innerWidth, window.innerHeight);
    });
    //返回实例
    return engine;
  }
  
  /**
   * 创建引擎-横向自适应
   */
  factory D2DEngine.adaptHorizontal(String canvasId, num fps, int width) {
    //清除body样式
    document.body.style.margin = '0';
    document.body.style.padding = '0';
    //计算高度
    int height = 0;
    if (window.innerWidth > 0) { //防止除0
      height = (window.innerHeight/window.innerWidth * width).toInt();
    }
    //创建引擎
    D2DEngine engine =  new D2DEngine(canvasId, fps, width, height);    
    //设置画布属性
    engine._canvas.style.width = '100%';
    engine._canvas.style.position = 'fixed';//absolute fixed
    engine._canvas.style.top = '0';
    engine._canvas.style.left = '0';
    //计算比例
    engine._screenScaleX = window.innerWidth/width; //使用宽度计算比例
    engine._screenScaleY = engine._screenScaleX; //Y与X相同，比例不变
    //注册重置尺寸事件
    window.onResize.listen((Event event) {
      int height = 0; //每次回调计算高度
      if (window.innerWidth > 0) { //防止除0
        height = (window.innerHeight/window.innerWidth * engine.getWidth()).toInt();
      }
      engine.setHeight(height);
      //计算比例
      engine._screenScaleX = window.innerWidth/engine.getWidth();
      engine._screenScaleY = engine._screenScaleX;
    });
    //返回实例
    return engine;
  }
  
  /**
   * 创建引擎-纵向自适应
   */
  factory D2DEngine.adaptVertical(String canvasId, num fps, int height) {
    //清除body样式
    document.body.style.margin = '0';
    document.body.style.padding = '0';
    //计算宽度
    int width = 0;
    if (window.innerHeight > 0) { //防止除0
      width = (window.innerWidth/window.innerHeight * height).toInt();
    }
    //创建引擎
    D2DEngine engine =  new D2DEngine(canvasId, fps, width, height);
    //设置画布属性
    engine._canvas.style.width = '100%';
    engine._canvas.style.position = 'fixed';//absolute fixed
    engine._canvas.style.top = '0';
    engine._canvas.style.left = '0';
    //计算比例
    engine._screenScaleX = window.innerWidth/width; //使用宽度计算比例
    engine._screenScaleY = engine._screenScaleX; //Y与X相同，比例不变
    //注册重置尺寸事件
    window.onResize.listen((Event event) {
      int width = 0; //每次回调计算高度
      if (window.innerHeight > 0) { //防止除0
        width = (window.innerWidth/window.innerHeight * engine.getHeight()).toInt();
      }
      engine.setWidth(width);
      //计算比例
      engine._screenScaleX = window.innerWidth/engine.getWidth();
      engine._screenScaleY = engine._screenScaleX;
    });
    //返回实例
    return engine;
  }
  
  /**
   * 创建引擎-自适应屏幕
   */
  D2DEngine.adaptScreen(String canvasId, num fps, int width, int height) { 
    //绑定canvas并创建缓冲区
    _canvas = querySelector(canvasId);
    _ctx = _canvas.context2D;
    _enableGfxScaleAdjust = true; //启用gfx调整-缓冲区与画布大小不同
    //判断长宽情况
    if ((height/width) > (window.innerHeight/window.innerWidth)) { //适应纵向
      //高度为窗口高-宽度按比例
      _canvas.height = window.innerHeight;
      _canvas.width = ((width/height) * window.innerHeight).toInt();      
    } else { //适应横向
      //宽度为窗口宽-高度按比例
      _canvas.width = window.innerWidth; 
      _canvas.height = ((height/width) * window.innerWidth).toInt();
    }
    //居中
    _canvas.style.position = 'fixed';
    _canvas.style.left = '${(window.innerWidth - _canvas.width)/2}px';
    _canvas.style.top = '${(window.innerHeight - _canvas.height)/2}px';
    //计算比例
    _screenScaleX = _canvas.width/width;
    _screenScaleY = _screenScaleX;
    //缓冲区
    _canvasBuffer = new CanvasElement(width: width, height: height);
    _ctxBuffer = _canvasBuffer.context2D;
    //帧率
    _fps = fps;
    //清除body样式
    document.body.style.margin = '0';
    document.body.style.padding = '0';
    //注册重置尺寸事件
    window.onResize.listen((Event event) {
      //判断长宽情况
      if ((getHeight()/getWidth()) > (window.innerHeight/window.innerWidth)) { //适应纵向
        //高度为窗口高-宽度按比例
        _canvas.height = window.innerHeight;
        _canvas.width = ((getWidth()/getHeight()) * window.innerHeight).toInt();
      } else { //适应横向
        //宽度为窗口宽-高度按比例
        _canvas.width = window.innerWidth; 
        _canvas.height = ((getHeight()/getWidth()) * window.innerWidth).toInt();        
      }
      //居中
      _canvas.style.left = '${(window.innerWidth - _canvas.width)/2}px';
      _canvas.style.top = '${(window.innerHeight - _canvas.height)/2}px';
      //计算比例
      _screenScaleX = _canvas.width/getWidth();
      _screenScaleY = _screenScaleX;
    });
  }

  /**
   * 创建引擎-拉伸全屏
   */
  D2DEngine.scaleScreen(String canvasId, num fps, int width, int height) {
    //绑定canvas并创建缓冲区
    _canvas = querySelector(canvasId);
    _canvas.width = window.innerWidth;   //canvas尺寸同屏幕
    _canvas.height = window.innerHeight;
    _canvas.style.position = 'fixed'; //设置样式为固定
    _canvas.style.top = '0';
    _canvas.style.left = '0';
    _ctx = _canvas.context2D;
    _canvasBuffer = new CanvasElement(width: width, height: height); //缓冲区尺寸固定
    _ctxBuffer = _canvasBuffer.context2D;
    //帧率
    _fps = fps;
    //清除body样式
    document.body.style.margin = '0';
    document.body.style.padding = '0';
    //启用矩阵调整
    _enableGfxScaleAdjust = true;
    _screenScaleX = window.innerWidth/width;
    _screenScaleY = window.innerHeight/height;
    //注册重置尺寸事件
    window.onResize.listen((Event event) {
      //手动调整canvas大小，缓冲区不动
      _canvas.width = window.innerWidth;
      _canvas.height = window.innerHeight;
      //计算比例
      _screenScaleX = window.innerWidth/getWidth();
      _screenScaleY = window.innerHeight/getHeight();
    }); 
  }

  /**
   * 创建引擎-居中
   */
  factory D2DEngine.center(String canvasId, num fps, int width, int height, [bool centerHorizontal = true, bool centerVertical = true]) {
    //清除body样式
    document.body.style.margin = '0';
    document.body.style.padding = '0';
    //创建引擎
    D2DEngine engine =  new D2DEngine(canvasId, fps, width, height);
    //设置画布属性
    engine._canvas.style.position = 'fixed';//absolute fixed
    if (centerHorizontal == true) {
      engine._canvas.style.left = '${(window.innerWidth - engine._canvas.width)/2}px';
    }
    if (centerVertical == true) {
      engine._canvas.style.top = '${(window.innerHeight - engine._canvas.height)/2}px';
    }
    //注册重置尺寸事件
    window.onResize.listen((Event event) {
      if (centerHorizontal == true) {
        engine._canvas.style.left = '${(window.innerWidth - engine._canvas.width)/2}px';
      }
      if (centerVertical == true) {
        engine._canvas.style.top = '${(window.innerHeight - engine._canvas.height)/2}px';
      }
    });
    //返回实例
    return engine;
  }

  /**
   * 获取canvas绘图源
   */
  CanvasImageSource getCanvasImageSource() {
    return _canvas;
  }
  
  /**
   * 获取Canvas
   */
  CanvasElement getCanvas() {
    return _canvas;
  }
  
  /**
   * 获取渲染上下文
   */
  CanvasRenderingContext2D getContext() {
    return _ctxBuffer;
  }

  /**
   * 取宽度
   */
  int getWidth() {
    return _canvasBuffer.width;
  }
  
  /**
   * 取高度
   */
  int getHeight() {
    return _canvasBuffer.height;
  }
  
  /**
   * 置宽度
   */
  void setWidth(int width) {
    _canvasBuffer.width = width;
    if (_enableGfxScaleAdjust != true) {
      _canvas.width = width;
    }
  }
  
  /**
   * 置高度
   */
  void setHeight(int height) {
    _canvasBuffer.height = height;
    if (_enableGfxScaleAdjust != true) {
      _canvas.height = height;
    }
  }

  /**
   * 设置鼠标样式
   */
  void setCursor(String style) {
    _canvas.style.cursor = style;
  }
  
  void setMouseStyle(String style) => setCursor(style);
  
  /**
   * 获取鼠标样式
   */
  String getCursor() {
    return _canvas.style.cursor;
  }
  
  String getMouseStyle() => getCursor();
  
  /**
   * 设置光标可视
   */
  void setCursorVisible(bool visible) {
    if (visible == true) _canvas.style.cursor = ""; 
    else _canvas.style.cursor = CURSOR_NONE;
  }
  
  void setMouseVisible(bool visible) => setCursorVisible(visible);
  
  /**
   * 是否光标可视
   */
  bool isCursorVisible() {
    if (_canvas.style.cursor == CURSOR_NONE) return false;
    else return true;
  }
  
  bool isMouseVisible() => isCursorVisible();

  /**
   * 取设定帧率
   */
  num getFps() {
    return _fps;
  }
  
  /**
   * 置设定帧率
   */
  void setFps(num fps) {
    _fps = fps;
  }
  
  /**
   * 取实时帧率
   * 该参数在引擎运行后每秒刷新一次
   */
  int getCurrentFps() {
    return _currentFps;
  }
  
  /**
   * 取帧延时时间-单位秒
   */
  num getDeltaTime() {
    return _deltaTime/1000;
  }
  
  /**
   * 申请全屏
   */
  void requestFullscreen() {
    _canvas.requestFullscreen();
  }

  /**
   * 绘制开始
   */
  void beginDraw() {
    resetTransform(); //重置矩阵
  }
  
  /**
   * 绘制结束
   */
  void endDraw() {
    if (_canvasBuffer.width <= 0 || _canvasBuffer.height <= 0) { //缓冲区尺寸参数不能<=0
      return;
    } else {
      _ctx.clearRect(0, 0, getWidth(), getHeight());
      _ctx.drawImageScaled(_canvasBuffer, 0, 0, _canvas.width, _canvas.height);
    }
  }

  /**
   * 置更新回调
   */
  void setUpdateCallback(FrameCallback callback) {
    _updateCallback = callback;
  }
  
  /**
   * 置绘制回调
   */
  void setDrawCallback(FrameCallback callback) {
    _drawCallback = callback;
  }
  
  /**
   * 游戏循环
   */
  void _loop(num nowTime) {
    _deltaTime = nowTime - _lastTime;
    if (_deltaTime >= 1000/_fps) {
      _lastTime = nowTime;
      //计算实时帧率
      _timeCounter += _deltaTime;
      if (_timeCounter >= 1000) {
        _timeCounter = 0;
        _currentFps = _frameCounter;
        _frameCounter = 0;
      } else {
        _frameCounter ++;
      }
      //绘制管线
      if (_updateCallback != null) {
        _updateCallback();
      }
      if (_drawCallback != null) {
        _drawCallback();
      }
      //清除事件状态
      _mouseStates.clear();
      _touchStates.clear();  
      _keyboardStates.clear();
    }
    //回调
    window.requestAnimationFrame(_loop);
  }

  /**
   * 启动引擎
   */
  void start() {
    //注册事件
    _mouseStates.listen(_canvas);
    _touchStates.listen(_canvas);  
    _keyboardStates.listen();
    //开始回调
    window.requestAnimationFrame(_loop);
  }

  /**
   * 取鼠标坐标x
   */
  num getMousePosX() {
    if (_screenScaleX == 0) {
      return 0;
    } else {
      return (_mouseStates.position.x/_screenScaleX).toInt(); //鼠标坐标采用int型
    }
  }

  /**
   * 取鼠标坐标y
   */
  num getMousePosY() {
    if (_screenScaleY == 0) {
      return 0;
    } else {
      return (_mouseStates.position.y/_screenScaleY).toInt();
    }
  }

  /**
   * 取鼠标坐标
   */
  Point getMousePos() {
    if (_screenScaleX == 1 && _screenScaleY == 1) {
      return _mouseStates.position;  
    } else {
      return new Point(getMousePosX(), getMousePosY());
    }
  }

  /**
   * 鼠标是否按下-持续
   */
  bool isMouseDown([int which]) {
    if (which == null) { //任意键
      if (_mouseStates.leftButton.down || _mouseStates.middleButton.down || _mouseStates.rightButton.down) {
        return true;
      } else {
        return false;
      }
    }
    else if (which == MOUSE_LEFT) { //左键
      return _mouseStates.leftButton.down;
    }
    else if (which == MOUSE_MIDDLE) { //中键
      return _mouseStates.middleButton.down;
    }
    else if (which == MOUSE_RIGHT) { //右键
      return _mouseStates.rightButton.down;
    }
    else { //其他未知
      return false; 
    }
  }
  
  /**
   * 鼠标是否弹起-瞬时
   */
  bool isMouseUp([int which]) {
    if (which == null) { //任意键
      if (_mouseStates.leftButton.up || _mouseStates.middleButton.up || _mouseStates.rightButton.up) {
        return true;
      } else {
        return false;
      }
    }
    else if (which == MOUSE_LEFT) { //左键
      return _mouseStates.leftButton.up;
    }
    else if (which == MOUSE_MIDDLE) { //中键
      return _mouseStates.middleButton.up;
    }
    else if (which == MOUSE_RIGHT) { //右键
      return _mouseStates.rightButton.up;
    }
    else { //其他未知
      return false;
    }
  }

  /**
   * 鼠标是否单击-瞬时
   */
  bool isMouseClick([int which]) {
    if (which == null) { //任意键
      if (_mouseStates.leftButton.click || _mouseStates.middleButton.click || _mouseStates.rightButton.click) {
        return true;
      } else {
        return false;
      }
    }
    else if (which == MOUSE_LEFT) { //左键
      return _mouseStates.leftButton.click;
    }
    else if (which == MOUSE_MIDDLE) { //中键
      return _mouseStates.middleButton.click;
    }
    else if (which == MOUSE_RIGHT) { //右键
      return _mouseStates.rightButton.click;
    }
    else { //其他未知
      return false;
    }
  }

  /**
   * 鼠标是否双击-瞬时
   */
  bool isMouseDblclick([int which]) {
    if (which == null) { //任意键
      if (_mouseStates.leftButton.dblclick || _mouseStates.middleButton.dblclick || _mouseStates.rightButton.dblclick) {
        return true;
      } else {
        return false;
      }
    }
    else if (which == MOUSE_LEFT) { //左键
      return _mouseStates.leftButton.dblclick;
    }
    else if(which == MOUSE_MIDDLE) { //中键
      return _mouseStates.middleButton.dblclick;
    }
    else if (which == MOUSE_RIGHT) { //右键
      return _mouseStates.rightButton.dblclick;
    }
    else { //其他未知
      return false;
    }
  }
  
  bool isMouseDoubleClick([int which]) => isMouseDblclick(which);

  /**
   * 鼠标是否移动-持续
   */
  bool isMouseMove() {
    return _mouseStates.move;
  }

  /**
   * 鼠标是否滚动-持续
   */
  bool isMouseWheel() {
    return _mouseStates.wheel;
  }

  /**
   * 鼠标是否离开画布-瞬时
   */
  bool isMouseLeave() {
    return _mouseStates.leave;
  }
  
  bool isMouseOut() => isMouseLeave();

  /**
   * 鼠标是否进入画布-瞬时
   */
  bool isMouseEnter() {
    return _mouseStates.enter;
  }
  
  bool isMouseOver() => isMouseEnter();

  /**
   * 获取鼠标滚动方向
   * 1为向下
   * -1为向上
   * 0为不动
   */
  num getMouseWheelDelta() {
    return _mouseStates.wheelDelta;
  }

  num getMouseWheel() => getMouseWheelDelta();

  /**
   * 持续触摸
   */
  bool isTouchDown([int identifier]) {
    if (_touchStates.touchDown == null || identifier >= 10) {
      return false;
    } else {
      if (identifier == null) { //任意触摸点
        return _touchStates.anyTouchDownCount > 0;
      }
      else if (_touchStates.touchDown[identifier] == true) { //检测特定点
        return true;
      } else {
        return false;
      }
    }
  }
  
  /**
   * 触摸按下-瞬时
   */
  bool isTouchJust([int identifier]) {
    if (_touchStates.touchJust == null || identifier >= 10) {
      return false;
    } else {
      if (identifier == null) {
        return true;
      }
      else if (_touchStates.touchJust[identifier] == true) {
        return true;
      } else {
        return false;
      }
    }
  }
  
  /**
   * 按键是否抬起-瞬时
   */
  bool isTouchUp([int identifier]) {
    if (_touchStates.touchUp == null || identifier >= 10) {
      return false;
    } else {
      if (identifier == null) {
        return true;
      }
      else if (_touchStates.touchUp[identifier] == true) {
        return true;
      } else {
        return false;
      }
    }
  }
  
  /**
   * 取触摸点x
   */
  num getTouchX(int identifier) {
    if (_touchStates.touchPosition[identifier] == null) return 0;
    if (_screenScaleX == 0) {
      return 0;
    } else {   
      return (_touchStates.touchPosition[identifier].x/_screenScaleX).toInt();
    }
  }

  /**
   * 取触摸点y
   */
  num getTouchY(int identifier) {
    if (_touchStates.touchPosition[identifier] == null) return 0;
    if (_screenScaleY == 0) {
      return 0;
    } else {
      return (_touchStates.touchPosition[identifier].y/_screenScaleY).toInt();
    }
  }

  /**
   * 取触摸位置
   */
  Point getTouchPos(int identifier) {
    if (_touchStates.touchPosition[identifier] == null) return new Point(0, 0);
    if (_screenScaleX == 1 && _screenScaleY == 1) {
      return _touchStates.touchPosition[identifier];
    } else {
      return new Point(getTouchX(identifier), getTouchY(identifier));
    }
  }

  /**
   * 按键是否按住-持续
   */
  bool isKeyDown([int keyCode]) {
    if (_keyboardStates.keysDown == null) {
      return false;
    } else {
      if (keyCode == null) { //检测任意键
        return _keyboardStates.anyKeyDownCount > 0;
      }
      else if (_keyboardStates.keysDown[keyCode] == true) { //检测特定键
        return true;
      } else {
        return false;
      }
    }
  }
  
  /**
   * 按键是否按下-瞬时
   */
  bool isKeyPress([int keyCode]) {
    if (_keyboardStates.keysPress == null) {
      return false;
    } else {
      if (keyCode == null) {
        return true;
      }
      else if (_keyboardStates.keysPress[keyCode] == true) {
        return true;
      } else {
        return false;
      }
    }
  }
  
  /**
   * 按键是否抬起-瞬时
   */
  bool isKeyUp([int keyCode]) {
    if (_keyboardStates.keysUp == null) {
      return false;
    } else {
      if (keyCode == null) {
        return true;
      }
      else if (_keyboardStates.keysUp[keyCode] == true) {
        return true;
      } else {
        return false;
      }
    }
  }

}

