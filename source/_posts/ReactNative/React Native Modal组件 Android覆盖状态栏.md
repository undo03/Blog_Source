
---
title: React Native Modal组件 Android覆盖状态栏
tags: [react-native]
categories: ReactNative
date: 2018-06-14
---

在App开发中经常需要做模态框，我们第一时间就会想到 React Native 的 Modal 组件，确实Modal组件很方便。但也有一些不尽人意的地方，在安卓App开发的过程中发现，Modal不会覆盖状态栏，就会导致Modal的背景色和状态栏的颜色不一致，即使是设置了沉浸式状态栏，这样破坏了App的整体性和美观。

<!--more-->

### Modal组件基本用法

> 属性介绍

 - animationType: ['none', 'slide', 'fade'] Modal展示和收起时的动画效果
 - onRequestClose: Platform.OS === 'android' ? PropTypes.func.isRequired : PropTypes.func 安卓物理返回回调，安卓必传
 - onShow: func Modal组件展开完成时调用
 - transparent: bool Modal背景色是否透明
 - visible: bool 控制Modal的展开与收起

> 基本用法

```javascript
class ModalDemo extends Component {

    state = {visible: false}
    
    close() {
        this.setState({visible: false})
    }

    render() {
        return (
            <View style={{flex: 1}}>
                <Modal
                    animationType='slide'
                    transparent
                    visible={this.state.visible}
                    onRequestClose={() => { this.close() }}>

                    <Text>Modal Demo</Text>
                </Modal>
                <TouchableOpacity onPress={()=>{this.setState({visible: true})}}>
                    <Text>show</Text>
                </TouchableOpacity>
            </View>
        )
    }
}

```

### 简单实现Modal覆盖状态栏

其实实现很简单，在Modal组件外面包一层View，设置View绝对定位，宽高‘100%’，这样View会占据整个屏幕，再设置背景，Modal透明就可以了，这个View的渲染和Modal的visible属性用同一个state来控制即可。

```javascript
{
    this.state.visible ?
        <View style={{position: 'absolute', width: '100%', height: '100%', backgroundColor: 'rgba(0,0,0,0.5)'}}>
            <Modal
                animationType='slide'
                transparent
                visible={this.state.visible}
                onRequestClose={() => { this.close() }}>

                <Text>Modal Demo</Text>
            </Modal>
        </View> : null
}
```

这样只是实现了覆盖状态栏，还需要对各个View层的点击事件作处理，以至于达到与原始Modal组件相同的效果。

### 基于Modal封装覆盖状态栏的Modal

```javascript
<TouchableOpacity activeOpacity={1} onPress={() => {this.close()}} style={{ position: 'absolute',width: '100%',zIndex: 999,height: '100%',backgroundColor: 'rgba(0, 0, 0, 0.5)'}}>
    <Modal
        animationType='slide'
        transparent
        visible={this.state.visible}
        onRequestClose={() => { this.close() }}>
        <TouchableOpacity onPress={() => {this.close()}} activeOpacity={1}>
            <TouchableWithoutFeedback onPress={() => {}}>
    				<Text>内容</Text>
            </TouchableWithoutFeedback>
        </TouchableOpacity>
    </Modal>
</TouchableOpacity>
```

这是我在开发中使用的一种实现方式，原理简单，实现比较啰嗦。

当然也可以使用大神们的组件，也有大神从安卓底层做了封装

比如这个：[react native modal android实现全屏](https://blog.csdn.net/u014041033/article/details/79322866)