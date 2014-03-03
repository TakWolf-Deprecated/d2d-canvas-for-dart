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
 * 鼠标按键状态
 */
class _MouseButtonStates {
  bool down = false;
  bool up = false;
  bool click = false;
  bool dblclick = false;
}

/**
 * 鼠标状态
 */
class _MouseStates {
  
  _MouseButtonStates leftButton = new _MouseButtonStates();
  _MouseButtonStates rightButton = new _MouseButtonStates();
  _MouseButtonStates middleButton = new _MouseButtonStates();
  Point position = new Point(0, 0);
  bool wheel = false;
  bool move = false;
  bool leave = false;
  bool enter = false;
  num wheelDelta = 0; //0表示未滚动，1表示向下，-1表示向上
  
  void listen(Element element) {
    //鼠标按下事件
    element.onMouseDown.listen((MouseEvent event) {
      switch(event.which) {
        case MOUSE_LEFT: 
          leftButton.down = true;
          break;
        case MOUSE_MIDDLE:
          middleButton.down = true;
          break;
        case MOUSE_RIGHT:
          rightButton.down = true;
          break;
      }
      event.preventDefault();
    });
    //鼠标抬起事件
    element.onMouseUp.listen((MouseEvent event) {
      switch(event.which) {
        case MOUSE_LEFT:
          leftButton.up = true;
          leftButton.down = false;
          break;
        case MOUSE_MIDDLE:
          middleButton.up = true;
          middleButton.down = false;
          break;
        case MOUSE_RIGHT:
          rightButton.up = true;
          rightButton.down = false;
          break;
      }
      event.preventDefault();
    });
    //鼠标单击事件
    element.onClick.listen((MouseEvent event) {  
      switch(event.which) {
        case MOUSE_LEFT:
          leftButton.click = true;
          break;
        case MOUSE_MIDDLE:
          middleButton.click = true;
          break;
        case MOUSE_RIGHT:
          rightButton.click = true;
          break;       
      }
      event.preventDefault();
    });
    //鼠标双击事件
    element.onDoubleClick.listen((MouseEvent event) {
      switch(event.which) {
        case MOUSE_LEFT:
          leftButton.dblclick = true;
          break;
        case MOUSE_MIDDLE:
          middleButton.dblclick = true;
          break;
        case MOUSE_RIGHT:
          rightButton.dblclick = true;
          break;
      }
      event.preventDefault();
    });
    //鼠标滚动
    element.onMouseWheel.listen((WheelEvent event) {
      wheel = true;
      wheelDelta = event.deltaY/100;
      event.preventDefault();
    });
    //--鼠标移动--全局监听
    window.onMouseMove.listen((MouseEvent event) {
      move = true;
      position = new Point(event.page.x - element.offsetLeft, event.page.y - element.offsetTop);
      event.preventDefault();
    });
    //鼠标离开画布
    element.onMouseLeave.listen((MouseEvent event) {
      leave = true;
      leftButton.down = false;//取消所有down事件
      rightButton.down = false;
      middleButton.down = false;
      event.preventDefault();
    });
    //鼠标进入画布
    element.onMouseEnter.listen((MouseEvent event) {
      enter = true;
      event.preventDefault();
    });    
    //鼠标右键菜单
    element.onContextMenu.listen((MouseEvent event) {
      event.preventDefault();
    });
  }

  void clear() {
    leftButton.up = false;
    leftButton.click = false;
    leftButton.dblclick = false;
    rightButton.up = false;
    rightButton.click = false;
    rightButton.dblclick = false;
    middleButton.up = false;
    middleButton.click = false;
    middleButton.dblclick = false;
    wheel = false;
    move = false;
    leave = false;
    enter = false;
    wheelDelta = 0;
  }
  
}

/**
 * 触摸状态
 */
class _TouchStates {
  
  List<Point> touchPosition = new List<Point>(10); //支持10个点触控
  List<bool> touchDown = new List<bool>(10); 
  List<bool> touchJust = null;
  List<bool> touchUp = null;
  int anyTouchDownCount = 0; //任意键按住个数
  
  void listen(Element element) {
    //触摸开始  
    element.onTouchStart.listen((TouchEvent event) {
      for (Touch touch in event.changedTouches) { //遍历改变的触摸点
        if (touch.identifier >= 10) continue; //不支持大于10个触控
        if (!(touchDown[touch.identifier] == true)) {
          if (touchJust == null) touchJust = new List<bool>(10);
          touchJust[touch.identifier] = true;
          anyTouchDownCount ++;
        }
        touchDown[touch.identifier] = true;
        touchPosition[touch.identifier] = new Point(touch.page.x - element.offsetLeft, touch.page.y - element.offsetTop);
      }
      event.preventDefault();
    });
    //触摸移动
    element.onTouchMove.listen((TouchEvent event) {
      for (Touch touch in event.changedTouches) {
        if (touch.identifier >= 10) continue;        
        touchPosition[touch.identifier] = new Point(touch.page.x - element.offsetLeft, touch.page.y - element.offsetTop);
      }      
      event.preventDefault();
    });
    //触摸停止
    element.onTouchEnd.listen((TouchEvent event) {
      for (Touch touch in event.changedTouches) {
        if (touch.identifier >= 10) continue;
        if (touchUp == null) touchUp = new List<bool>(10);
        touchUp[touch.identifier] = true;
        touchDown[touch.identifier] = false;
        anyTouchDownCount --;
        if (anyTouchDownCount < 0) anyTouchDownCount = 0;
        touchPosition[touch.identifier] = new Point(touch.page.x - element.offsetLeft, touch.page.y - element.offsetTop);
      }
      event.preventDefault();
    });
    //浏览器失去焦点-清空所有状态
    window.onBlur.listen((Event event) {
      touchDown = null;
      touchJust = null;
      touchUp = null;
      anyTouchDownCount = 0;
    });
    //浏览器获得焦点-重置所有状态
    window.onFocus.listen((Event event) {
      touchDown = new List<bool>(10);
    });   
  }

  void clear() {
    touchJust = null;
    touchUp = null;
  }
  
}

/**
 * 键盘状态
 */
class _KeyboardStates {
  
  List<bool> keysDown = new List<bool>(151);
  List<bool> keysPress = null;
  List<bool> keysUp = null;
  int anyKeyDownCount = 0; //任意键按住个数

  void listen() {
    //键盘按键按住
    window.onKeyDown.listen((KeyboardEvent event) {
      if (event.keyCode > 150) return;
      if (!(keysDown[event.keyCode] == true)) {
        if (keysPress == null) keysPress = new List<bool>(151);
        keysPress[event.keyCode] = true;
        anyKeyDownCount ++;
      }
      keysDown[event.keyCode] = true;
    });
    //键盘按键弹起
    window.onKeyUp.listen((KeyboardEvent event) {
      if (event.keyCode > 150) return;
      if (keysUp == null) keysUp = new List<bool>(151);
      keysUp[event.keyCode] = true;
      keysDown[event.keyCode] = false;
      anyKeyDownCount --;
      if (anyKeyDownCount < 0) anyKeyDownCount = 0;
    });
    //浏览器失去焦点-清空所有状态
    window.onBlur.listen((Event event) {
      keysDown = null;
      keysPress = null;
      keysUp = null;
      anyKeyDownCount = 0;
    });
    //浏览器获得焦点-重置所有状态
    window.onFocus.listen((Event event) {
      keysDown = new List<bool>(151);
    });
  }

  void clear() {
    keysPress = null;
    keysUp = null;
  }
  
}

