---
title: react-native android状态栏
tags: [react-native]
categories: ReactNative
date: 2018-06-12
---

react-native 开发App的时候难免会遇到状态栏的背景颜色和字体颜色与App内容页面色调适配，间言之就是将状态栏颜色与App颜色一致，使用户界面更加整体。

## react-native android状态栏
  
### 1.android设备系统元素
- 导航栏：就是设备顶部的网络、时间、电量等信息栏
- ActionBar: 返回按钮以及系统默认的header区域，RN开发中一般不会用到，RN中在navigation中进行定制 
- 导航栏: 设备下方的物理返回、回桌面、选择应用程序等系统导航栏

### 2.状态栏的呈现形式

- 默认展示，一直显示手机系统的状态栏
- 透明状态栏，状态栏背景颜色透明，状态栏颜色与App颜色一致，用户界面更加整体。
- 隐藏状态栏(沉浸式)，状态栏完全隐藏，类似于全屏游戏、视频播放器的效果

#### 2.1 默认展示

系统默认状态栏样式，无法改变

#### 2.2 透明状态栏

透明状态栏很常见，大多数的App都是使用这种模式，使得状态栏颜色与App颜色一致，使用户界面更加整体，整个应用看起来更加美观。

实现透明的状态栏的方式很多：

> 一、使用App的主题进行配置,在app/main/res/values/styles.xml中设置主题

```javascript
<resources>

    <!-- Base application theme. -->
    <style name="AppTheme" parent="Theme.AppCompat.Light.NoActionBar">
        <item name="android:windowTranslucentStatus">true</item> // 设置状态栏不占据空间
        // <item name="android:windowLightStatusBar">true</item> // 设置状态栏字体颜色
    </style>

</resources>

```
这种方式支持api19, 即Android4.4及以上，会在App启动的时候就生效, 在App启动时有权限确认、系统弹窗等也不受影响，在弹出modal之类的深色蒙层时状态栏字体会变成成浅色

只设置`<item name="android:windowTranslucentStatus">true</item> `这种方式设置的透明状态栏，状态栏字体默认白色，无法再动态通过StatusBar改变状态栏的背景颜色,在做需要改变状态栏背景颜色的时候就比较尴尬了

再加一个`<item name="android:windowLightStatusBar">true</item>`这样设置状态栏字体颜色之后，在深色modal弹出的时候字体不会动态改变成白色，但可以通过StatusBar设置barStyle来改变，实际上也不是很方便


> 二、android原生设置,在MainActivity的onCreate中进行设置

```javascript
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    // 设置透明状态栏
    if (Build.VERSION.SDK_INT >= 21) {
        View decorView = getWindow().getDecorView();
        int option = View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                | View.SYSTEM_UI_FLAG_LAYOUT_STABLE;
        decorView.setSystemUiVisibility(option);
        getWindow().setStatusBarColor(Color.TRANSPARENT);
    }
    
    // 设置透明状态栏和透明导航栏
    if (Build.VERSION.SDK_INT >= 21) {
	    View decorView = getWindow().getDecorView();
	    int option = View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
	            | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
	            | View.SYSTEM_UI_FLAG_LAYOUT_STABLE;
	    decorView.setSystemUiVisibility(option);
	    getWindow().setNavigationBarColor(Color.TRANSPARENT);
	    getWindow().setStatusBarColor(Color.TRANSPARENT);
	}
}
```

透明式状态栏，只有5.0及以上系统才支持，因此这里先进行了一层if判断，只有系统版本大于或等于5.0的时候才会执行下面的代码。
接下来我们使用了`SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN`和`SYSTEM_UI_FLAG_LAYOUT_STABLE`，注意两个Flag必须要结合在一起使用，表示会让应用的主体内容占用系统状态栏的空间，也就是说状态栏不再占据空间。最后再调用Window的setStatusBarColor()方法将状态栏设置成透明色就可以了。

> 三、使用RN的StatusBar来设置，在App首次加载的页面中对状态栏进行设置

```javascript
<StatusBar backgroundColor='transparent' translucent barStyle={'dark-content'} />
```

这种方式，会在App刚启动的时候和App启动时有权限确认、系统弹窗等会先试用系统的默认状态栏，加载App页面之后再改变成上面设置的样式。
好处在于可以动态进行设置状态栏的样式。

StatusBar属性简介：

- animated: bool 指定状态栏的变化是否应以动画形式呈现。目前支持这几种样式：backgroundColor, barStyle和hidden
- hidden: bool 是否隐藏状态栏。
- backgroundColor: 状态栏的背景色。
- translucent: bool 指定状态栏是否透明。设置为true时，应用会在状态栏之下绘制（即所谓“沉浸式”——被状态栏遮住一部分）。常和带有半透明背景色的状态栏搭配使用。
- barStyle: enum('default', 'light-content', 'dark-content') 设置状态栏文本的颜色。


以上几种方式都会有一个问题，状态栏不再占据空间，因此在页面布局的时候需要加 paddingTop 值为状态栏的高度。

纯前端就可以实现，这也是适配目前主流刘海屏的一种方式，利用StatusBar.currentHeight可以获取到设备状态栏的高度。

#### 2.3 隐藏 状态栏 和 导航栏

```javascript
	super.onCreate(savedInstanceState);
	setContentView(R.layout.activity_main);
	View decorView = getWindow().getDecorView();
	int option = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION | View.SYSTEM_UI_FLAG_FULLSCREEN;
	decorView.setSystemUiVisibility(option);
	ActionBar actionBar = getSupportActionBar();
	actionBar.hide();

```


### 3. 浅色状态栏的兼容性配置

目前市面上的浅色状态栏基本都是 白底黑字, 支持这种设置的有Android6.0及其以上; MIUI v6及以上, Flyme 4.0及以上

具体兼容方案如下：

> Flyme 4.0及以上

```javascript
 public static boolean FlymeSetStatusBarLightMode(Window window, boolean dark) {
    boolean result = false;
    if (window != null) {
        try {
            WindowManager.LayoutParams lp = window.getAttributes();
            Field darkFlag = WindowManager.LayoutParams.class
                    .getDeclaredField("MEIZU_FLAG_DARK_STATUS_BAR_ICON");
            Field meizuFlags = WindowManager.LayoutParams.class
                    .getDeclaredField("meizuFlags");
            darkFlag.setAccessible(true);
            meizuFlags.setAccessible(true);
            int bit = darkFlag.getInt(null);
            int value = meizuFlags.getInt(lp);
            if (dark) {
                value |= bit;
            } else {
                value &= ~bit;
            }
            meizuFlags.setInt(lp, value);
            window.setAttributes(lp);
            result = true;
        } catch (Exception e) {

        }
    }
    return result;
}
```

> Android6.0及以上

```javascript
 public static void setAndroidNativeLightStatusBar(Activity activity, boolean dark) {
    //状态栏字体图标颜色
    View decor = activity.getWindow().getDecorView();
    if (dark) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            decor.setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR //浅色状态栏(字体图标白色)
                    | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN //contentView 全屏(置于statusbar之下)
                    | View.SYSTEM_UI_FLAG_LAYOUT_STABLE);
        }
    } else {
        decor.setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE);
    }
}
```

> MIUI v6及以上

```javascript
public static boolean MIUISetStatusBarLightMode(Activity activity, boolean dark) {
    if(Build.VERSION.SDK_INT >= 24){
        return false;
    }
    boolean result = false;
    Window window=activity.getWindow();
    if (window != null) {
        Class clazz = window.getClass();
        try {
            int darkModeFlag = 0;
            Class layoutParams = Class.forName("android.view.MiuiWindowManager$LayoutParams");
            Field field = layoutParams.getField("EXTRA_FLAG_STATUS_BAR_DARK_MODE");
            darkModeFlag = field.getInt(layoutParams);
            Method extraFlagField = clazz.getMethod("setExtraFlags", int.class, int.class);
            if(dark){
                extraFlagField.invoke(window,darkModeFlag,darkModeFlag);//状态栏透明且黑色字体
            }else{
                extraFlagField.invoke(window, 0, darkModeFlag);//清除黑色字体
            }
            result=true;

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                //开发版 7.7.13 及以后版本采用了系统API，旧方法无效但不会报错，所以两个方式都要加上
                if(dark){
                    activity.getWindow().getDecorView().setSystemUiVisibility( View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN| View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
                }else {
                    activity.getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE);
                }
            }
        }catch (Exception e){

        }
    }
    return result;
}
    
```


在MainActivity的onCreate中调用

```javascript
    LightStatusBarUtil.FlymeSetStatusBarLightMode(this.getWindow(), false);
    LightStatusBarUtil.MIUISetStatusBarLightMode(this, false);   
    LightStatusBarUtil.setAndroidNativeLightStatusBar(this, true);
```


### 总结

实现透明状态栏，以上方案都没有完全兼容android 4.4以下版本，个人觉得比较合适的做法是 android设置透明状态栏 + 浅色状态栏的兼容性配置 + StatusBar 来配合控制