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
 * D2D资源加载器
 */
class D2DLoader {
  
  List<D2DResource> _resFinished;
  List<D2DResource> _resLoading;
  
  bool _enableCache;   
  static Map<String, D2DResource> _resCache = new Map<String, D2DResource>();

  /**
   * 创建
   */
  D2DLoader([bool enableCache = false]) {
    _resFinished = new List<D2DResource>();
    _resLoading = new List<D2DResource>();
    _enableCache = enableCache;
  }
  
  /**
   * 载入资源
   */
  D2DResource load(Type type, String url) {
    D2DResource res = null;
    if (_enableCache == true) {
      res = _resCache[url];
    }
    if (res == null) {
      ClassMirror cm = reflectClass(type);
      InstanceMirror im = cm.newInstance(const Symbol(''), [url]);
      res = im.reflectee;
      if (_enableCache == true) {
        _resCache[url] = res;
      }
    }
    _resLoading.add(res);
    return res;
  }
  
  /**
   * 添加一个资源到等待队列
   */
  void add(D2DResource res) {
    _resLoading.add(res);
  }
  
  /**
   * 获取当前加载器资源总数
   */
  int getResourcesCount() {
    return _resLoading.length + _resFinished.length;
  }
  
  /**
   * 获取加载中资源数目
   */
  int getLoadingResourcesCount() {
    return _resLoading.length;
  }
  
  /**
   * 获取完成资源数目
   */
  int getFinishedResourcesCount() {
    return _resFinished.length;
  }
  
  /**
   * 获取缓存资源数目
   */
  int getCacheResourcesCount() {
    return _resCache.length;
  }
  
  /**
   * 通过url获取缓存资源
   */
  static D2DResource getCacheResourceByUrl(String url) {
    return _resCache[url];
  }
  
  /**
   * 更新进度
   */
  void update() {
    if (_resLoading.length > 0) { //检查是否有等待资源
      //不为空则遍历
      for (int n = 0; n < _resLoading.length; n++) {
        //如果资源加载完成
        if (_resLoading[n].isReady()) {
          _resFinished.add(_resLoading[n]);
          _resLoading.removeAt(n);
          break; //跳出循环
        }
      }
    }
  }
  
  /**
   * 获取进度
   */
  num getProgress([num max = 1]) {
    if ((_resFinished.length + _resLoading.length) == 0) return max;
    else return (_resFinished.length/(_resFinished.length + _resLoading.length)) * max;
  }
  
  /**
   * 卸载所有资源
   */
  void clear() {
    _resFinished.clear();
    _resLoading.clear();
  }
  
  /**
   * 清除缓存
   */
  void clearCache() {
    _resCache.clear();
  }

}

