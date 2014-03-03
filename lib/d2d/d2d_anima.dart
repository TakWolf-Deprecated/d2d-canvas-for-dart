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
 * D2D动画类
 */
class D2DAnima extends D2DSprite {
  
  num _rectX;
  num _rectY;
  num _rectWidth;
  num _rectHeight;
  int _clipX;
  int _clipY;
  
  List<int> _index;
  int _current;
  
  num _fps;
  num _timeCounter; //时间积累，单位秒
  
  D2DAnima._(D2DDrawable drawable, num srcX, num srcY, num srcWidth, num srcHeight) : super(drawable, srcX, srcY, srcWidth, srcHeight);
  
  /**
   * 构造函数
   */
  factory D2DAnima(D2DDrawable drawable, num fps, num rectX, num rectY, num rectWidth, num rectHeight, int clipX, int clipY, [List<int> index]) {
    //计算当前src
    int frameIndex;
    if (index == null) frameIndex = 0;
    else frameIndex = index[0];
    int nX = frameIndex%clipX;
    int nY = (frameIndex - nX)~/clipX;
    num srcWidth =  rectWidth/clipX;
    num srcHeight = rectHeight/clipY;
    num srcX = rectX + nX * srcWidth;
    num srcY = rectY + nY * srcHeight;
    D2DAnima anima = new D2DAnima._(drawable, srcX, srcY, srcWidth, srcHeight);
    //赋值
    anima._rectX = rectX;
    anima._rectY = rectY;
    anima._rectWidth = rectWidth;
    anima._rectHeight = rectHeight;
    anima._clipX = clipX;
    anima._clipY = clipY;
    anima._fps = fps;
    anima._timeCounter = 0;
    anima._index = index;
    anima._current = 0;
    //返回
    return anima;
  }
  
  /**
   * 获取帧率
   */
  num getFps() {
    return _fps;
  }
  
  /**
   * 设置帧率
   */
  void setFps(num fps) {
    _fps = fps;
  }
  
  /**
   * 重置动画
   */
  void reset() {
    _timeCounter = 0;
    setCurrentFrame(0);
  }

  /**
   * 更新
   */
  void update(num deltaTime, [int start, int end]) {
    _timeCounter += deltaTime;
    if (_timeCounter >= 1/_fps) {
      _timeCounter = 0;
      //取当前帧
      if (start == null || start < 0) start = 0;
      if (end == null || end > getLength() - 1) end = getLength() - 1;
      _current ++;
      if (_current > end || _current < start) _current = start;
      //更新src矩形位置
      int frameIndex;
      if (_index == null) frameIndex = _current;
      else frameIndex = _index[_current];
      int nX = frameIndex%_clipX;
      int nY = (frameIndex - nX)~/_clipX;
      num srcWidth =  _rectWidth/_clipX;
      num srcHeight = _rectHeight/_clipY;
      num srcX = _rectX + nX * srcWidth;
      num srcY = _rectY + nY * srcHeight;
      setDrawableRect(srcX, srcY, srcWidth, srcHeight);
    }
  }
  
  /**
   * 设置当前帧
   */
  void setCurrentFrame(int n) {
    _timeCounter = 0;
    _current = n;    
    int frameIndex;
    if (_index == null) frameIndex = _current;
    else frameIndex = _index[_current];
    int nX = frameIndex%_clipX;
    int nY = (frameIndex - nX)~/_clipX;
    num srcWidth =  _rectWidth/_clipX;
    num srcHeight = _rectHeight/_clipY;
    num srcX = _rectX + nX * srcWidth;
    num srcY = _rectY + nY * srcHeight;
    setDrawableRect(srcX, srcY, srcWidth, srcHeight);
  }
  
  /**
   * 获取当前帧
   */
  int getCurrentFrame() {
    return _current;
  }
  
  /**
   * 获取当前帧索引
   */
  int getCurrentFrameIndex() {
    if (_index == null) return _current;
    else return _index[_current];
  }
  
  /**
   * 获取总帧数
   */
  int getLength() {
    if (_index == null) return _clipX * _clipY;
    else return _index.length;
  }

}

