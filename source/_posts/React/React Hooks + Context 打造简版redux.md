---
title: React Hooks + Context 打造简版redux
subtitle: react-hooks-redux
tags: [react, react-hooks-redux]
date: 2019-09-05
categories: React
---

React Hooks 在 react@10.8 中已经发布，刚发布的时候自己也进行了简单的学习，之前也写过一篇[学习 hooks 基础用法](https://www.songqibin.cn/react-hooks/)的文章。学习之后用到的场景并不多，最近再次学习并在项目中应用起来，真正体会到它的强大之处。

本文呢不再是介绍基础的 hooks API 的应用，而是基于hooks如何实现类似 `redux` 这样的状态管理。
<!--more-->

### 实现思路

做 `react` 项目，一般按照正常的流程写组件就能满足业务场景，随着业务复杂度的增加，数据交互会变的复杂，会逐渐考虑到使用工具或者库来管理数据，常见的就是 redux、mbox、dva 等。

使用 `react hooks` 的时候，我们发现它提供了很多的 api 供我们操作数据，那么如何才能利用这些 api 实现类似 redux 这样的数据管理呢。

`redux` 集中管理数据，通过 `Provider` 组件将数据共享给子组件，然后再通过 `connect` 将 store 与组件进行连接，这是 redux 最核心的功能。

这里的核心就是实现数据共享，这时我们可以使用 Context 来实现。`Context` 本意是上下文，它提供一个 `Provider` 和一个 `Consumer`，也就是生产者/消费者模式，在某个顶层提供一个 `Provider` ，下面的子元素通过 `Consumer` 来消费 `Provider` 里的数据和方法。 

通过这个概念，我们把不同层级里的组件共享同一个顶层 `Provider`，并且组件内部使用 `Consumer` 来消费共享数据。

当我们能共享数据后，还剩一个问题就是如何更改 `Provider` 里的数据呢？答案是：`useReducer`。

有了这样的思路，我们一步步来实现它。

### 实现过程 

#### 1. props传递

如果我们有一个场景，两个字组件需要共享父组件的状态，我们通常的做法是在父组件中定义状态，再通过 `props`  传递给子组件，实现状态共享。

```javascript
import React from 'react'
function Parent() {
    const colors = ['red', 'blue']
    return (
        <>
            <Child1 color={colors[0]} />
            <Child2 color={colors[1]} />
        </>
    )
}

function Child1(props) {
    return (
        <div style={{ background: props.color }}>I am {props.color}</div>
    )
}
  
function Child2(props) {
    return (
        <div style={{ background: props.color }}>I am {props.color}</div>
    )
}
```

这是最简单的实现方式，子组件可以共享到父组件的状态。但是如果子组件层级加深被嵌套在很深的组件层级中，那么这个状态也需要一层层往下传递，这可能也是我们经常遇到的问题，这也是为什么我们会使用 `redux` 这种状态管理库的原因。

#### 2. 使用Context

接下来使用 `Context` ，通过 `createContext` 创建需要的 `Context` ，再在子组件中通过 `useContext` 拿到共享数据。

```javascript
import React from 'react'

const Context = React.createContext(null)
function Parent() {
    const initState = {
        colors: ["red", "blue"]
    }
    return (
        <Context.Provider value={initState}>
            <Child1 />
            <Child2 />
        </Context.Provider>
    )
}

function Child1() {
    const { colors } = React.useContext(Context)
    return (
        <div style={{ background: colors[0] }}>I am {colors[0]}</div>
    )
}
  
function Child2() {
    const { colors } = React.useContext(Context)
    return (
        <div style={{ background: colors[1] }}>I am {colors[1]}</div>
    )
}
```

这样我们就摆脱使用 `props` 传递状态也同样实现共享状态。

#### 3. 更新状态

上面已经能拿到数据，进一步实现点击元素修改颜色，这里就需要使用到 `useReducer` 来模拟触发改变。

```javascript
function reducer(state, action) {
    const { type, colors } = action
    if (type === 'CHANGE_COLOR') {
        return { colors }
    } else {
        throw new Error()
    }
}
```

定义一个 `reducer`，是不是很熟悉，和 `redux` 中的 `reducer` 几乎一样，这里对 `action` 做了简化处理。

`useReducer` 方法会接受一个 `reducer` 和 `state`，返回 `state` 和 `dispatch` ，我们再把 `state` 和 `dispatch` 通过 `Provider` 共享给子组件使用。

```javascript
function Parent() {
    const initState = {
        colors: ["red", "blue"]
    }
    const [state, dispatch] = React.useReducer(reducer, initState)
    return (
        <Context.Provider value={{ colors: state.colors, dispatch}}>
            <Child1 />
            <Child2 />
        </Context.Provider>
    )
}
```

子组件中拿到 `dispatch` 并改变 `colors`

```javascript
function Child1() {
    console.log(React.useContext(Context)) // {colors: Array(2), dispatch: ƒ}
    const { colors, dispatch } = React.useContext(Context)
    return (
        <div style={{ background: colors[0] }} onClick={() => {
            dispatch({
                type: "CHANGE_COLOR",
                colors: ["yellow", "blue"]
              })
        }}>I am {colors[0]}</div>
    )
}
```

这样就基本实现了共享状态，基本实现了不使用 `redux` 实现状态共享。

#### 4. 抽离Provider 和 获取状态的自定义hook

假如我们是个小型项目，可能会把这个 `Provider` 放在顶层，也就是进行全局的状态管理，我们将 `Provider` 抽离出来。

```javascript
// state.js
import React, { useContext, useReducer } from 'react'

function reducer(state, action) {
    const { type, colors } = action
    if (type === 'CHANGE_COLOR') {
        return { colors }
    } else {
        throw new Error()
    }
}

const initState = {
    colors: ["red", "blue"]
}

export const AppContext = React.createContext(null)

export function AppProvider ({ children }) {
    return (
        <AppContext.Provider value={useReducer(reducer, initState)}>
            {children}
        </AppContext.Provider>
    )
} 


```

最后添加一个自定义hook来获取 `AppContext` 里的状态和方法。

```javascript
import React, { useContext, useReducer } from 'react'
export const AppContext = React.createContext(null)
export const useAppState = () => useContext(AppContext)
```

组件中使用

```javascript
import React from 'react'
import { AppProvider, useAppState } from './state'

function Parent() {
    return (
        <AppProvider>
            <Child1 />
            <Child2 />
        </AppProvider>
    )
}

function Child1() {
    const [state, dispatch] = useAppState()
    return (
        <div style={{ background: state.colors[0] }} onClick={() => {
            dispatch({
                type: "CHANGE_COLOR",
                colors: ["yellow", "blue"]
              })
        }}>I am {state.colors[0]}</div>
    )
}
```

这样基本就实现了状态的共享。但是和我们常用的 `redux` 还差了点，熟悉 `redux` 的都知道稍微复杂点的项目都会按模块拆分，拆分成小的 `reducer` 和 `state` 最终再通过 `combineReducers` 合并 `reducer` 形成一个全局的 `store` ，那么如何通过 hooks 来实现 `reducer` 的拆分和合并呢？ 

#### 5. 合并reducer

在复杂的业务场景中会按功能模块拆分成多个小的 `reducer` 最终再进行整合，按照 redux 的思维，我们页可以实现一个  `combineReducers` 函数来合并它们。

```javascript
export default function combineReducers(reducers) {
    const reducersKey = Object.keys(reducers)
    const finalReducers = {}
    for(let i = 0; i < reducersKey.length; i++) {
        const key = reducersKey[i]
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
            if (typeof nextStateForKey === 'undefined') {
                throw new Error()
            }
            nextState[key] = nextStateForKey
            hasChanged = hasChanged || nextStateForKey !== previousStateForKey
        }
        return hasChanged ? nextState : state
    }
}
```

然后再拆分写 `action` 和 `reducer` ，这里稍微有些不同，需要将 `reducer` 中的 `state` 导出以便进行整合。

例如：

home 模块的 `action` 和 `reducer`

```javascript
// actions/home.js
export const CHANGE_COLOR = 'CHANGE_COLOR'
export const changeColor = (dispatch, colors) => {
    dispatch({
        type: "CHANGE_COLOR",
        colors
    })
}

// reducers/home.js
import { CHANGE_COLOR } from '../actions/home'
export const homeState = {
    colors: ["red", "blue"]
}
export const homeReducer = (state = homeState, action) => {
    const { type, colors } = action
    switch (type) {
        case CHANGE_COLOR: 
            return {colors}
        default:
            return state
    }
}
```

user 模块的 `action` 和 `reducer` 

```javascript
// actions/user.js
export const CHANGE_USER_NAME = 'CHANGE_USER_NAME'
export const changeUserName = async (dispatch, userName) => {
    let finalName = await new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve(userName === 'sqb' ? 'Undo' : 'sqb')
        }, 1000)
    })
    dispatch({
        type: CHANGE_USER_NAME,
        name: finalName
    })
}

// reducers/user.js
import { CHANGE_USER_NAME } from '../actions/user'
export const userState = {
    name: 'sqb',
    age: 27
}
export const userReducer = (state = userState, action) => {
    const { type } = action
    switch (type) {
        case CHANGE_USER_NAME:
            return { ...state, name: action.name }
        default:
            return state
    }
}
```

因为 `useReducer` 需要传入 `reducer` 和初始的 `state` ，那么需要把小的 `reducer` 中的状态也进行合并。

整合，同时到处合并后的 `reducer` 和 初始化的 `initState` 。

```javascript
import combineReducers from './combineReducers'
import { homeState, homeReducer } from './home'
import { userState, userReducer } from './user'
export const reducer =  combineReducers({
    home: homeReducer,
    user: userReducer
})

export const initState = {
    home: homeState,
    user: userState
}
```

#### 6. 构建store

使用 `createContext` 创建 `Context` 对象得到 `Provider` ，通过 `useContext` 得到全局状态和更新状态的方法。

```javascript
import React, { useContext, useReducer } from 'react'
import { reducer, initState } from './reducer'
export const AppContext = React.createContext(null)
export function AppProvider ({ children }) {
    return (
        <AppContext.Provider value={useReducer(reducer, initState)}>
            {children}
        </AppContext.Provider>
    )
} 
export const useAppState = () => useContext(AppContext)
```

子组件中获取 `state` 和 修改 `state`

```javascript
import React from 'react';
import { useAppState } from '../store'
import { changeColor } from '../store/actions/home'

function Child1(props) {
  const [state, dispatch] = useAppState()
  const { home: { colors } } = state
  const onClick = () => {
    changeColor(dispatch, ["yellow", "blue"])
  }
  return (
    <div style={{ background: colors[0] }} onClick={onClick} >
    	I am {colors[0]} 
		</div>
	)
}

export default Child1;

```

这样基本上就实现了 `redux` 的雏形，`action 、reducer 、store` 也保持了基本一致的风格。

#### 7. 优化

我们实现状态共享，在各个组件中打印日志，发现一个问题，该组件不想关的状态更新也会导致组件重新渲染。

原因是 调用了 `useContext` 的组件总会在 `context` 值变化时重新渲染。也就是说只要组件中使用了共享状态，那么 `context` 中的任何状态发生改变都会触发使用共享状态的组件重新渲染，这会导致很多没必要的性能开销。

还好 hooks 提供了 `useMemo` ，可以利用它来优化性能。

> 把“创建”函数和依赖项数组作为参数传入 `useMemo`，它仅会在某个依赖项改变时才重新计算 `memoized` 值。这种优化有助于避免在每次渲染时都进行高开销的计算。

因此改造我们的子组件

```javascript
import { useAppState } from '../store'
import { changeColor } from '../store/actions/home'

function Child1(props) {
  const [state, dispatch] = useAppState()
  const { home: { colors } } = state
  return React.useMemo(() => {
    console.log('Child1 render')
    const onClick = () => {
      changeColor(dispatch, ["yellow", "blue"])
    }
    return (
      <div style={{ background: colors[0] }} onClick={onClick}>
        I am {colors[0]} 
      </div>
    )
  }, [colors, dispatch]);
}

export default Child1;
```

这样改造之后只会在组件的依赖项发生改变的时候才会重新渲染。

### 总结

这只是利用 react hooks 简单实现了类似 `redux` 的数据管理，可以不依赖任何库实现状态管理和共享，当然也可以嵌套，可以拆分，可以按模块拆分状态共享，可以在小项目中进行尝试和运用，它会让我们的编码更加的灵活。  