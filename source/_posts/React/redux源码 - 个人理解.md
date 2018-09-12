---
title: redux源码 - 个人理解
subtitle: redux_understanding
tags: [redux]
date: 2018-09-12
categories: React
---

最近项目中常用到`redux`，闲暇时间阅读了以下`redux`源码，结合自己使用的经验和习惯再去看源码以及设计者的设计思想，使得自己对`redux`的理解更加清晰，同时也对阅读源码有了一定的经验。

为什么想写这篇文章？

本来是在新的团队中参与项目开发，但是项目中的`redux`使用的流程和文件目录划分相对混乱，想结合自己的经验做一些改善，但是发现要做到这一点，需要先对`redux`有个清晰的认识，才能更好的完成这个目标。

<!--more-->

首先看看`redux`库的`index.js`文件的导出

```javascript
export {
  createStore,
  combineReducers,
  bindActionCreators,
  applyMiddleware,
  compose
}
```

其实这样看是很简单的，`redux`提供的API就这么几个，创建store、合并redudcer、action创造器、应用中间件工具函数compose。

下面一一来看，先来看一下`redux`的核心API `createStore`

## 1. createStore

先来说一下这个函数，接受参数是`reducer`，`preloadedState`，`enhancer`。

`reducer`，是一个函数，传入当前的`state`和`action`，返回新的`state`，后面`combineReducers`的时候细说。

`preloadedState`，可以理解为初始化的`state`。

`enhancer`是中间件函数，`applyMiddleware`函数的返回值。

```javascript
export default function createStore(reducer, preloadedState, enhancer) {
    // 一堆的逻辑
    return {
        dispatch,
        subscribe,
        getState,
        replaceReducer,
        [$$observable]: observable
    }
}
```

其实这个函数导出的就是我们要用的`store`对象，常用的API是`dispatch`、`subscribe`、`getState`。

下面再继续深挖各个函数 

### 1.1 getState

这个函数很简单，作用就是返回当前的状态

```javascript
  function getState() {
    return currentState
  }
```

### 1.2 dispatch

先来简单看一下这个函数的骨架

```javascript
function dispatch(action) {
    // 很多的错误检测和逻辑优化
    // currentListeners、nextListeners是局部的变量，监听着
    try {
      isDispatching = true
      currentState = currentReducer(currentState, action)
    } finally {
      isDispatching = false
    }

    const listeners = currentListeners = nextListeners
    for (let i = 0; i < listeners.length; i++) {
      const listener = listeners[i]
      listener()
    }

    return action
  }
```

这个函数接受一个`action`，然后执行`reducer`更新`state`，然后让每个订阅者执行。

### 1.3 subscribe

```javascript
 function subscribe(listener) {
    if (typeof listener !== 'function') {
      throw new Error('Expected listener to be a function.')
    }

    let isSubscribed = true

    ensureCanMutateNextListeners()
    nextListeners.push(listener)

    return function unsubscribe() {
      if (!isSubscribed) {
        return
      }

      isSubscribed = false

      ensureCanMutateNextListeners()
      const index = nextListeners.indexOf(listener)
      nextListeners.splice(index, 1)
    }
  }
```

这个函数是用来订阅`state`变化的， 接受一个订阅者，然后将该订阅者加入到订阅者列表中。订阅完成后返回一个取消订阅的函数，一般在组件销毁的时候调用，可提高性能。

### 1.4 replaceReducer

```javascript
  function replaceReducer(nextReducer) {
    if (typeof nextReducer !== 'function') {
      throw new Error('Expected the nextReducer to be a function.')
    }

    currentReducer = nextReducer
    dispatch({ type: ActionTypes.INIT })
  }
```

用来更行`reducer`的，开发中很少用到这个API。

所以综合以上几个函数，可以将`createStore`函数的核心简化理解为以下这样：

```javascript
// 初始化store的action
export const ActionTypes = {
  INIT: '@@redux/INIT'
}

export default function createStore(reducer, preloadedState, enhancer) {
    
  let currentReducer = reducer // 当前的执行者currentReducer
  let currentState = preloadedState // 当前的state
  let currentListeners = []  // 订阅者列表
  let nextListeners = currentListeners  // 新的订阅者列表
  let isDispatching = false // action派发状态，可以优化性能

  // 更新订阅者列表
  function ensureCanMutateNextListeners() {
    if (nextListeners === currentListeners) {
      nextListeners = currentListeners.slice()
    }
  }
    
  // 获取当前state
  function getState() {
    return currentState
  }
    
  // 订阅
  function subscribe(listener) {
    if (typeof listener !== 'function') {
      throw new Error('Expected listener to be a function.')
    }

    let isSubscribed = true

    ensureCanMutateNextListeners()
    nextListeners.push(listener)

    return function unsubscribe() {
      if (!isSubscribed) {
        return
      }

      isSubscribed = false

      ensureCanMutateNextListeners()
      const index = nextListeners.indexOf(listener)
      nextListeners.splice(index, 1)
    }
  }
    
  // 派发action
  function dispatch(action) {
    try {
      isDispatching = true
      currentState = currentReducer(currentState, action)
    } finally {
      isDispatching = false
    }

    const listeners = currentListeners = nextListeners
    for (let i = 0; i < listeners.length; i++) {
      const listener = listeners[i]
      listener()
    }

    return action
  }
    
  // 更新reducer
  function replaceReducer(nextReducer) {
    if (typeof nextReducer !== 'function') {
      throw new Error('Expected the nextReducer to be a function.')
    }

    currentReducer = nextReducer
    dispatch({ type: ActionTypes.INIT })
  }
    
  // 初始化store
  dispatch({ type: ActionTypes.INIT })

  return {
    dispatch,
    subscribe,
    getState,
    replaceReducer
  }
}
```

函数最终返回了一个对象，通常我们会命名为` store `，`store.dispatch()`这样去使用。

## 2. combineReducers

开发中统通常我们会把reducer按功能或按模块进行拆分成多个简单的`reducer`，`combineReducers` 的功能很简单，把多个简单的`reducer`进行合并，合并成一个大的`reducer`，一般的应用中都会用到。

单一的`reducer`一般是这样的：

```javascript

import { GET_TASK_LIST } from '../actions/taskList'

let initState = {
    taskList: []
}

export default (state = initState, action = {}) => {
    const { type } = action;
    switch (type) {
        case GET_TASK_LIST:
            return {...state, taskList: action.list }; 
        default:
            return state;
    }
} 
```

`combineReducers` 的功能就是把多个这样的`reducer`进行合并，进行统一管理。

`combineReducers` 实现的核心代码如下：

```javascript
export default function combineReducers(reducers) {
  const reducerKeys = Object.keys(reducers)
  const finalReducers = {}
  for (let i = 0; i < reducerKeys.length; i++) {
    const key = reducerKeys[i]
    if (typeof reducers[key] === 'function') {
      finalReducers[key] = reducers[key]
    }
  }
  const finalReducerKeys = Object.keys(finalReducers)

  return function combination(state = {}, action) {
    let hasChanged = false
    const nextState = {}
    for (let i = 0; i < finalReducerKeys.length; i++) {
      const key = finalReducerKeys[i]
      const reducer = finalReducers[key]
      const previousStateForKey = state[key]
      const nextStateForKey = reducer(previousStateForKey, action)
      nextState[key] = nextStateForKey
      hasChanged = hasChanged || nextStateForKey !== previousStateForKey
    }
    return hasChanged ? nextState : state
  }
}

```

可以看出函数接受的是一个`reducers`对象，每个`key`代表的是一个小的`reducer`，`combineReducers`返回一个新的`reducer`，每次这个新的`reducer`执行会遍历key组成的数组，并执行每个`key`对应的`reducer`，并将返回的新的`state`按照`key`进行合并组装成新的`state`对象。

```javascript
combineReducers({
    tranning,
    taskList
})

// 返回的state将会是
{
    tranning: {},
    taskList: {} 
}

// 要取得对应的state值需要向这样取
state.taskList.xxx
state.tranning.xxx
```
注意：一般开发的时候会将`action`和`reducer`进行对应拆分，这样合并之后就可能会出现`action.type`重复的现象，导致`reducer`执行混乱。所以在写`action`的时候需要按模块名或者功能进行区分

## 3. bindActionCreators

这个API运用场景很少，以至于我也不怎么理解它，官方是这样实现的：

```javascript
function bindActionCreator(actionCreator, dispatch) {
  return (...args) => dispatch(actionCreator(...args))
}
export default function bindActionCreators(actionCreators, dispatch) {
  const keys = Object.keys(actionCreators)
  const boundActionCreators = {}
  for (let i = 0; i < keys.length; i++) {
    const key = keys[i]
    const actionCreator = actionCreators[key]
    if (typeof actionCreator === 'function') {
      boundActionCreators[key] = bindActionCreator(actionCreator, dispatch)
    }
  }
  return boundActionCreators
}

```

把` action creators `转成拥有同名 `keys` 的对象，使用 `dispatch` 把每个 `action creator` 包围起来，这样可以直接调用它们。唯一使用 `bindActionCreators` 的场景是当你需要把 `action creator `往下传到一个组件上，却不想让这个组件觉察到 `Redux` 的存在，而且不希望把 `Redux store` 或 `dispatch `传给它。为方便起见，你可以传入一个函数作为第一个参数，它会返回一个函数。

## 4.  applyMiddleware

这个函数是使用中间件使`dispatch`函数更加强大，一般在需要在派发墙厚做一些额外操作的时候会用到它，比如`dispatch`一个函数等。

```javascript
export default function applyMiddleware(...middlewares) {
  return (createStore) => (reducer, preloadedState, enhancer) => {
    const store = createStore(reducer, preloadedState, enhancer)
    let dispatch = store.dispatch
    let chain = []

    const middlewareAPI = {
      getState: store.getState,
      dispatch: (action) => dispatch(action)
    }
    chain = middlewares.map(middleware => middleware(middlewareAPI))
    dispatch = compose(...chain)(store.dispatch)

    return {
      ...store,
      dispatch
    }
  }
}
```

它将所有的中间件进行合并，并重写了`createStore`返回的`dispatch`函数，然后覆盖掉`store`的`dispatch`。

返回的函数也就是`enhancer`，传给`createStore`。

```javascript
const store = createStore(reducer, preloadedState, enhancer)
```

## 5. compose

工具函数，将多个相互依赖的函数进行合并，在applyMiddleware函数中有用到。

```javascript
export default function compose(...funcs) {
  if (funcs.length === 0) {
    return arg => arg
  }

  if (funcs.length === 1) {
    return funcs[0]
  }

  return funcs.reduce((a, b) => (...args) => a(b(...args)))
}

```

这是`redux`的核心实现方式，也都是源码中的代码片段，源码中有很多的工具函数和错误类型的判断，以及各种参数类型的兼容，可以在源码中进行查看。