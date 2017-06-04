# EasyScreen
简单的屏幕适配方法。使用脚本生成最小宽度限定符的 **dimen.xml** 文件，如 **values-sw320dp** 这样的资源目录。

## 说明
我们知道，Android碎片化十分严重，各种屏幕分辨率充斥市场。为了让用户有一致性的体验，对Android手机进行适配势在必行。适配方法也有许多种，以下进行简单的说明。

## 常规适配方法
* 能使用 `match_parent`，`wrap_content`，`android:layout_weight` 的地方尽量使用。
* 如要写具体长度或字体大小，使用 **dp** 和 **sp** 作为单位（能适配绝大部分情况）
* 使用相对布局

## 以最小宽度限定符进行适配
在 Android3.2 (api 13) 之后支持用最小宽度限定符来进行适配，最小宽度的单位是 **dp**.</br>
### 适配方法举例：
如果要使用最小宽度为320dp，360dp，411dp 作为限定符，在 `res` 目录下建立 **values-sw320dp**，**values-sw360dp**，**values-sw411dp** 这三个目录，并在里面新建 dimens.xml
假如以 360dp 作为基准，以 100dp 举例，那么这3个dimens.xml里面设置的大小分别为以下3个：
```xml
<dimen name="xdp_100.0">88.00dp</dimen>
<dimen name="xdp_100.0">100.0dp</dimen> <!-- base -->
<dimen name="xdp_100.0">114.00dp</dimen>
```
在引用的时候使用 `@dimen/xdp_100.0` 则会在最小宽度为 320dp，360dp，411dp 以上分别转换为相应的值（88.00dp, 100.0dp, 114.00dp）。

**本项目就是围绕这种方式，通过脚本生成几套这样的适配文件。**

## 使用方法
### shell方式
将 `shell` 目录下的 `auto_res_tool.sh` 拷贝到项目的主 module 目录下（比如app目录），用文本编辑器，比如 NotePad++ 打开这个文件。我们需要修改一下配置来生成我们想要的 dimens.xml 文件。
```shell
DIMEN_VALUE=("360" "320" "411")

#dp属性名
DIMEN_ATTRIBUTE_NAME="xdp"
#生成的dimen的个数
DIMEN_NUM=1000
#dimen的间隔
DIMEN_STEP=0.5

#sp属性名
SP_ATTRIBUTE_NAME="xsp"
#sp个数
SP_NUM=40
#sp步进
SP_STEP=1
```
这个 `DIMEN_VALUE` 是个数组，里面装了需要生成的 value-swXXXdp 目录及其 dimens.xml 的依据，第一个值作为基准，后面依次放需要生成的目录。按照上述代码的配置将会生成 **values-sw320dp**，**values-sw360dp**，**values-sw411dp** 这三个目录，生成的形式如下（values-sw360dp/dimens.xml里的）
```xml
<!-- dp -->
<dimen name="xdp_0">0dp</dimen>
<dimen name="xdp_0.5">0.5dp</dimen>
<dimen name="xdp_1.0">1.0dp</dimen>
...
<dimen name="xdp_499.5">499.5dp</dimen> <!-- 共计 1000 条 -->

<!-- sp -->
<dimen name="xsp_0">0sp</dimen>
<dimen name="xsp_1">1sp</dimen>
<dimen name="xsp_2">2sp</dimen>
...
<dimen name="xsp_39">39sp</dimen> <!-- 共计 40 条 -->
```
修改妥当之后，打开 shell 终端（如果在windows上没有，推荐使用 [babun](https://github.com/babun/babun) 这个bash终端），运行
```shell
./auto_res_tool.sh
```
然后就等待它自动生成这几套文件吧</br>

**Note：**生成完成之后，别忘了把你的最小的限定符里面的 dimen 资源拷贝一份到最原始的 `values/` 目录下的 dimens.xml ，因为如果某个机型比你设置的最小的限定符的宽度还要小（比如小于上述的 320dp），则会因为在默认的 dimens.xml 里找不到该资源而抛出异常并crash掉。

### python方式
暂没加入，等待后续更新...

## 效果一览
现有两个实验对象
* 手机1号，4英寸，480 * 800 分辨率，最小宽度 320dp
* 手机2号，5.2英寸，1080 * 1920 分辨率，最小宽度 411dp

现在用一个 ListView 作为测试，它的每个 Item 高度为 100dp，测试如下图：</br>
![1号](http://github.com/paulyung541/EasyScreen/raw/master/img/s.png)
![2号](http://github.com/paulyung541/EasyScreen/raw/master/img/l.png)

可以看到，1号只显示了3.5个item，而2号显示了4.5个item

现在将刚刚的 100dp 替换为我们生成的 dimen 资源 `@dimen/xdp_100.0`，测试如下图：</br>
![1号](http://github.com/paulyung541/EasyScreen/raw/master/img/s-e.png)
![2号](http://github.com/paulyung541/EasyScreen/raw/master/img/l-e.png)

可以看到，显示的item数几乎是一模一样的了，其中图片的宽高，字体的大小没有替换，这里只测试item的高度，如果其它写死的长度也替换了，那么两部手机的体验将会一模一样。