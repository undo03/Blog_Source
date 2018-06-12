---
title: react-native开发常见问题
tags: [react-native]
categories: ReactNative
---

## react-native开发常见问题

### 1. 监听网状连接状态的变化  
```javascript 

  componentDidMount () {
    NetInfo.addEventListener('change', this.handleConnectivityChange);
  }

  componentWillUnmount() {
    NetInfo.removeEventListener('change', this.handleConnectivityChange);
  }

  handleConnectivityChange() {
    NetInfo.isConnected.fetch().then(netConnected => {
      if (netConnected) {
        ToastAndroid.show('网络已连接', ToastAndroid.SHORT, ToastAndroid.BOTTOM)
      } else {
        ToastAndroid.show('请检查网络连接', ToastAndroid.SHORT, ToastAndroid.BOTTOM)
      }
    })
  }
```

### 2. 处理特殊页面的回退按钮和物理回退事件 
 
```javascript 
 // navigation 的 didFocus willBlur事件
 // BackHandler 的 hardwareBackPress 事件
 // this.props.navigation.replace(RouterName) 路由替换
 // this.props.navigation.isFocused() 路由激活状态
  _didFocusSubscription;
  _willBlurSubscription;
  
  constructor (props) {
    super(props)
      this._didFocusSubscription = props.navigation.addListener('didFocus', payload =>
      BackHandler.addEventListener('hardwareBackPress', this.onBackButtonPressAndroid))
  }
  
  componentDidMount () {
      this._willBlurSubscription = this.props.navigation.addListener('willBlur', payload => {
      BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid)
    })
  }

  componentWillUnmount () {
    this._didFocusSubscription && this._didFocusSubscription.remove()
    this._willBlurSubscription && this._willBlurSubscription.remove()
    BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid)
  }
  
  onBackButtonPressAndroid = () => {
    if (this.toRouterName) {
      this.props.navigation.replace(this.toRouterName)
      return true
    } else {
      return false
    }
  };
  
```


### 3. createStackNavigator, createBottomTabNavigator 路由嵌套 StackNavigator的跳转问题
```javascript 
// 需要给TabNavigator 重新传navigation属性 重新定义TabNavigator容器组件的router为TabNavigator的router
class MainView extends Component {
  static navigationOptions = {
    header: null
  };

  render () {
    let { isMask } = this.props.global
    const { cartCount } = this.props
    return (
      <View>
        <AppTabNavigator navigation={this.props.navigation}/>
      </View>
    )
  }
}
MainView.router = AppTabNavigator.router
```

### 4. tabBarOnPress 拦截tab导航的tab点击事件
```javascript 
  navigationOptions: ({navigation, screenProps}) => ({
	  title: '我的',
	  tabBarIcon: ({focused}) => (
	    <Image
	      source={focused ? require('../images/ic_mine_checked.png') : require('../images/ic_mine.png')}
	      style={styles.tabIcon}
	    />
	  ),
	  tabBarOnPress: () => {
	    if (!screenProps.netConnected) {
	      navigation.navigate('Home')
	    }
	  }
	})
```

### 5. 解决锁定屏幕方向 还有键盘顶起tab导航等问题
```javascript      
<activity
    android:name=".MainActivity"
    android:label="@string/app_name"
    android:configChanges="keyboard|keyboardHidden|orientation|screenSize">
    
    添加一行：android:screenOrientation="portrait"
    设置为portrait是锁定竖向，landscape是锁定横向
    
    
// screenProps  tab导航中动态渲染数据 对象中的值可以绑定redux中的值
<AppTabNavigator screenProps={{cartCount: cartCount}} navigation={this.props.navigation}/>

```

### 6. 监听路由事件，可以用来做双击物理回退按钮退出App等其他功能
```javascript 
import { createStackNavigator, NavigationActions } from 'react-navigation'
import { ToastAndroid, BackHandler } from 'react-native'
const AppNavigator = createStackNavigator(routes, stackConfig)const defaultStateAction = AppNavigator.router.getStateForAction
let lastBackPressed = 0
AppNavigator.router.getStateForAction = (action, state) => {
  const backRouteName = state && state.routes[state.routes.length - 1].routeName
  if (state && (action.type === NavigationActions.BACK) && (backRouteName === 'MainView')) {
    if ((lastBackPressed + 2000) < Date.now()) {
      ToastAndroid.show('再按一次退出', ToastAndroid.SHORT)
      lastBackPressed = Date.now()
      return { ...state }
    }
    BackHandler.exitApp()
  }
  return defaultStateAction(action, state)
}

```

### 7. 解决 isMounted(...) is deprecated warning
```javascript 
import { YellowBox } from 'react-native'
YellowBox.ignoreWarnings(['Warning: isMounted(...) is deprecated', 'Module RCTImageLoader'])

```

### 8. 合理使用 componentWillReceiveProps， shouldComponentUpdate
```javascript 
  componentWillReceiveProps (nextProps) {
    if (!nextProps.xxx) {
      dosomething
    }
  }
  
   shouldComponentUpdate (newProps, newState) {
    if (this.props.navigation.isFocused()) {
      return true // render
    } else {
      return false // not render
    }
  }
  
```

### 9. 工具类logger 和 创建store  
```javascript 
	import { createStore, applyMiddleware, compose } from 'redux'
	import screenTracking from './screenTrackingMiddleware'
	import reducer from '../reducers'
	import logger from 'redux-logger'
	
	const middlewares = []
	
	if (__DEV__) {
	  middlewares.push(logger)
	}
	
	middlewares.push(screenTracking)	
	const store = compose(applyMiddleware(...middlewares))(createStore)(reducer)
	
	export default store
```

### 10. 比较好用的第三方组件
```javascript 
	react-native-swiper 				swiper组件
	react-native-linear-gradient        渐变组件
	react-native-swipe-list-view		侧滑组件
	react-native-image-crop-picker   图片裁剪、调用相机和手机相册
	react-native-cookies				管理Cookie
    
```

### 11. ScrollView 组件监听滚动到底部

```javascript 
  _contentViewScroll (e) {
    let offsetY = e.nativeEvent.contentOffset.y // 滑动距离
    let contentSizeHeight = e.nativeEvent.contentSize.height // scrollView contentSize高度
    let oriageScrollHeight = e.nativeEvent.layoutMeasurement.height // scrollView高度
    if (offsetY + oriageScrollHeight >= contentSizeHeight) {
    	// do something  
    }
  }
  
  <ScrollView 
        onMomentumScrollEnd={this._contentViewScroll.bind(this)}
        showsVerticalScrollIndicator={false}> 
  </ScrollView>
    
```

### 12. Image 使图片按宽度或者高度自适应
```javascript 
	class ImageAdaptive extends Component {
	  state = {
	    width: 0,
	    height: 0
	  }
	
	  componentDidMount () {
	    Image.getSize(this.props.uri, (width, height) => {
	      let h = 330 * height / width
	      this.setState({height: h})
	    })
	  }
	
	  render () {
	    return (
	      <Image source={{uri: this.props.uri}} style={[{width: D(330), height: D(this.state.height)}, this.props.style]} />
	    )
	  }
	}
    
```

### 13. 根据Swiper组件改装的图片预览组件
```javascript 
  <Swiper
    loop={false}
    index={initialSlide}
    renderPagination={(index, total) => (
      <View style={styles.paginationStyle}>
        <Text style={styles.paginationText}>{index + 1}/{total}</Text>
        {
          delImage
            ? <TouchableOpacity onPress={() => { delImage && delImage(index) }} style={styles.del}>
              <Image source={require('../../images/personal/ic_preview_delete.png')} style={styles.imageDel} />
            </TouchableOpacity> : null
        }
      </View>
    )}>
    {
      images && images.map((image, index) => (
        <TouchableOpacity style={styles.imagesItemWrapper} key={index} activeOpacity={1} onPress={this.closeModal}>
          <Image resizeMode='contain' style={styles.imagesItem} source={{ uri: image }} />
        </TouchableOpacity>
      ))
    }
  </Swiper>    
```

### 14. StatusBar.currentHeight 可以从纯前端的角度兼容刘海屏沉浸式状态栏