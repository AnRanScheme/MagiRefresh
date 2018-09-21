<p align="center">
  <a href=#>
    <img src="https://github.com/AnRanScheme/MagiRefresh/blob/master/Assets/titleView.png" alt="" width=60 height=60>
  </a>

  <h3 align="center">MagiRefresh</h3> 
  <p align="center">
     内置多种动画、可自定义和灵活的iOS下拉刷新框架(Swift实现)
    <br> 
    <br>
    <a href="https://github.com/AnRanScheme/MagiRefresh/issues/new">Bug提交</a>
    ·
    <a href="https://github.com/AnRanScheme/MagiRefresh/issues/new">需求提交</a>  
  </p>
</p> 
<br>

****

### Screenshots
<table>
<tr height="60px" align="center">
  <td width="20%"><strong>MagiRefreshStyle</strong></td>
  <td width="40%"><strong>Top Screenshots</strong></td>
  <td width="40%"><strong>Bottom Screenshots</strong></td>
</tr>
<tr align="center" height="120px">
  <td width="300px">native</td>
  <td><img src="Assets/Gif/native.gif"></img></td>
  <td><img src="Assets/Gif/_native.gif"></img></td>
</tr>
<tr align="center" height="120px">
  <td>replicatorWoody</td>
  <td><img src="Assets/Gif/woody.gif"></img></td>
  <td><img src="Assets/Gif/_woody.gif"></img></td>
</tr>
<tr align="center" height="120px">
  <td>replicatorAllen</td>
  <td><img src="Assets/Gif/allen.gif"></img></td>
  <td><img src="Assets/Gif/_allen.gif"></img></td>
</tr>
<tr align="center" height="120px">
  <td>replicatorCircle</td>
  <td><img src="Assets/Gif/circle.gif"></img></td>
  <td><img src="Assets/Gif/_circle.gif"></img></td>
</tr>
<tr align="center" height="120px">
  <td>replicatorDot</td>
  <td><img src="Assets/Gif/dot.gif"></img></td>
  <td><img src="Assets/Gif/_dot.gif"></img></td>
</tr>
<tr align="center" height="120px">
  <td>replicatorArc</td>
  <td><img src="Assets/Gif/arc.gif"></img></td>
  <td><img src="Assets/Gif/_arc.gif"></img></td>
</tr>
<tr align="center" height="120px">
  <td>replicatorTriangle</td>
  <td><img src="Assets/Gif/triangle.gif"></img></td>
  <td><img src="Assets/Gif/_triangle.gif"></img></td>
</tr>
<tr align="center" height="120px">
  <td>animatableRing</td>
  <td><img src="Assets/Gif/ring.gif"></img></td>
  <td><img src="Assets/Gif/_ring.gif"></img></td>
</tr>
<tr align="center" height="120px">
  <td>animatableArrow</td>
  <td><img src="Assets/Gif/arrow.gif"></img></td>
  <td><img src="Assets/Gif/_arrow.gif"></img></td>
</tr>
</table> 

### 特点
* 支持多样式选择与自定义

> 总共有9种动画样式

* 非刷新状态自动隐藏

> 即使手动调整过contentInset，依然能够在非刷新状态自动隐藏影。最常见的情况是：当数据量过少，UITableView停止刷新后，用户依旧能看到刷新控件的存在，从而影响的视觉体验。

* 刷新结束时抗抖动

> 当UIScrollView处于刷新状态，且用户滑动UIScrollView，当刷新结束时，MagiRefresh不会调整UIScrollView的内容，从而导致页面跳动；

* 支持设置控件高度

> `stretchOffsetYAxisThreshold`是根据刷新控件的高度进行的比例调整。如：当设置`stretchOffsetYAxisThreshold`为1.5时，触发刷新的偏移距离将调整为原来的1.5倍。(设置时请大于1)

* 支持全局配置

> `MagiRefreshDefaults`类似一个配置表，通过该配置表配置全局的刷新样式，而无需在每一个页面初始化或者绑定刷新控件。

* 支持进度回调

> 实时回调拖拽的偏移比例，对于扩展接口，可根据进度调整动画。该接口的开放可用于扩展更多的刷新样式。

* 自适应contentInset系统调整与手动调整

> 自适应iOS7以后UINavigationController自动调整scrollview contentOffset，MagiRefresh也对iOS 11进行了适配；当您手动设置了contentInset的值，也无需担心MagiRefresh会影响到视觉效果。

* 解决刷新状态分组视图悬停问题

> 即使在列表滑动时，分组视图都将跟随ScrollView滑动（即使处于高速滑动状态下！）。

* 支持预加载

  当用户滑动scrollview接近至底部时，将会自动触发刷新，无需用户再滑至底部后拉起scrollview。该功能默认不开启，因为多数人不查看文档便欣然使用改功能，不正确使用极容易引发刷新无法停止。

  使用预加载功能，请严格按照下面要求使用:

  * ```tableView.magiRefresh.footer?.isAutoRefreshOnFoot = true``` 请手动将刷新该属性至为False；

  * 在刷新调用的block块中，严格按下列逻辑编写：

    ```Swift
     if (没有数据需要拼接了) {
         self?.tableView.magiRefresh.footer?.endRefreshingAndNoLongerRefreshingWithAlertText("no more")
     } else {
         self?.tableView.magiRefresh.footer?.endRefreshingWithAlertText( "Did load successfully", completion:nil)
     }
    ```

* 文档覆盖率100%、支持横竖屏切换自适应、iOS 7+。

### 使用

##### 1.初始化控件
* 方式一
```Swift
// MARK: - head

tableView.magiRefresh.bindStyleForHeaderRefresh(themeColor: UIColor.red,
                                                         refreshStyle: MagiRefreshStyle.animatableArrow,
                                                         completion: {
                                                            print("加载完成处理逻辑")
         })

// MARK: - foot

tableView.magiRefresh.bindStyleForFooterRefresh(themeColor: UIColor.red,
                                                 refreshStyle: MagiRefreshStyle.animatableArrow,
                                                 completion: {
                                                            print("加载完成处理逻辑")
})

// MARK: - auto refresh

tableView.magiRefresh.footer?.isAutoRefreshOnFoot = true
```
* 方式二
```Swift
   let header = MagiArrowHeader()
   header.refreshClosure = { [weak self] in
            
   }
 tableView.magiRefresh.header = header
```

* 方式三 全局配置
```Swift
 func application(_ application: UIApplication, didFinishLaunchingWithOptions 
                  launchOptions: [UIApplicationLaunchOptionsKey:    Any]?) -> Bool {
        MagiRefreshDefaults.shared.headerDefaultStyle = .replicatorAllen
	
        return true
  }

// MARK: - global

tableView.magiRefresh.bindStyleForHeaderRefresh {
          
}

```
##### 3.手动触发刷新
```Swift
 tableView.magiRefresh.header?.beginRefreshing()
 tableView.magiRefresh.footer?.beginRefreshing()
```

##### 4.结束刷新
```Swift

/*
	一般方式结束刷新
*/
func endRefreshing()
 
/*
	结束刷新且需要提示文字
*/
func endRefreshingWithAlertText(_ text: String = "", completion: (()->())?)

/*
	结束刷新且不再需要刷新功能
*/
func endRefreshingAndNoLongerRefreshingWithAlertText(_ text: String)
```

##### 5.重新恢复刷新

```Swift
/**
 当调用过 ‘endRefreshingAndNoLongerRefreshingWithAlertText’,
 且重新需要恢复刷新功能室，调用下面方法
 */
 func resumeRefreshAvailable()
```

### 自定义

以MagiRefreshHeaderConrol为例：

 ```Swift

 override func setupProperties() {
       super.setupProperties()
       //初始化属性
 }
	
 
 override func magiDidScrollWithProgress(progress: CGFloat, max: CGFloat) {
       //进度回调
 }

 override func magiRefreshStateDidChange(_ status: MagiRefreshStatus) {
        super.magiRefreshStateDidChange(status)
	     switch status {
        case .none:
            break
        case .scrolling:
            break
        case .ready:
            break
        case .refreshing:
            break
        case .willEndRefresh:
            break
        }
  }
 ```
 
 ### 小记
 这个框架呢,是我最近在写一个新的项目Swift,因为是新的所以说有的东西动用比较新的技术,但是我看到了MJRefresh这个OC框架不能忍,我看了挺多的Swift的下拉刷新框架都觉得不是很好,但是不久之前看到了一个OC的框架KafkaRefresh,我决定修改一下架构然后重写了一个Swift板的,当然架构还是有所不同的但是样式是一样的
