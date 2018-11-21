---
title: React Hooks
subtitle: react-hooks
tags: [react, react-hooks]
date: 2018-11-21
categories: React
---

React v16.7.0-alpha 版本中发布了新的提案hook，什么是hook？ 官方给出如下说法。

> *Hooks* are a new feature proposal that lets you use state and other React features without writing a class.
>
> Hook是一项新功能提案，可让您在不编写类的情况下使用状态和其他React功能。

在之前的react版本中，组件大多以Class的方式进行声明，以便处理组件的状态和一些功能特性，其中也有很多坑，很多繁琐的写法，在新的提案中将会简化很多。
<!--more-->

新的提案中提出了好多Hook

- Basic Hooks
  - useState
  - useEffect
  - useContext
- Additondal Hooks
  - useReducer
  - useCallback
  - useMemo
  - useRef
  - useImperativeMethods
  - useMutationEffect
  - useLayoutEffect



Hooks 使用的前提是 必须在函数中使用，因此使用hooks进行开发意味着所有的组件都将以函数的方式呈现。在函数外使用hooks会报错

> Uncaught Error: Hooks can only be called inside the body of a function component.

### Basic Hooks

#### useState

基础用法

```javascript
const [state, setState] = useState(initialState)
```

setState是一个函数，接受一个初始状态，返回一个数组，第一项是state的值，第二项是改变这个state值的方法

初始状态一般是一个普通的值，但是如果初始的值需要经过复杂的计算得来的话，可以传递函数给它

```javascript
const [state, setState] = useState(() => {
    const initState = Math.round(Math.random() * 10)
    return initState
})
```

setState方法用来更新state的，一般情况下传入新的state值即可

```
setState(5) 
```

如果使用先前状态计算新状态，则可以将函数传递给setState。 该函数将接收先前的值，并返回更新的值。

```javascript
setState(prevState => prevState + 1)
```

更新状态方法的使用和class方式的组件中的 this.setState 很相似，但是Hooks 中只能更新单一的状态，不支持合并更新状态对象，也就是说，每一个state 都需要通过 useState 进行初始化，每一个状态对应一个值和一个状态更新的方法，一个组件中有多个状态多次调用即可。

```JavaScript
const [count, setCount] = useState(0)
const [name, setName] = useState('sqb')
```

如果想更新多个状态，可以给 useState 传入对象， 更新状态的时候根据函数和扩展语法相结合来实现。

```javascript
import React, { useState } from 'react'

const initialState = {
  name: 'undo',
  age: 26
}

export default ({initialCount = 0}) => {
  const [count, setCount] = useState(initialCount)
  const [option, setOption] = useState(initialState)
  return (
    <div>
      <p>Name: { option.name } Age: {option.age} Count: { count }</p>
      <button onClick={() => setOption(preState => {
        return {...preState, ...{name: 'sqb'}}
      })}>setName</button>
      <button onClick={() => setCount(0)}>Reset</button>
      <button onClick={() => setCount(prevCount => prevCount + 1)}>+</button>
      <button onClick={() => setCount(prevCount => prevCount - 1)}>-</button>
    </div>
  )
}
```

后续可以通过 useReducer 来实现，后面再讲。

#### useEffect

函数中可以避免之前在 componentDidMount 、 componentDidUpdate 中的订阅，计时器等一些与副作用的操作，这些操作之前都需要在 componentWillUnmount 中取消订阅或者清理定时器，那么这个hook，将可以减少一些重复繁琐的操作。


相反，使用useEffect。传递给useEffect的函数将在渲染提交到屏幕后运行。将效果视为从React的纯粹功能性世界进入命令式世界的逃脱舱。

默认情况下，效果在每次完成渲染后运行，但您可以选择仅在某些值发生更改时触发它。

```javascript
import React, { useState, useEffect } from 'react'

export default () => {
  const [num, setCount] = useState(0)
  useEffect(() => {
    setInterval(() => {
      setCount(num + 1)
    }, 2000)
  })
  return (
    <div>
      <p>Interval Count: { num }</p>
    </div>
  )
}
```

这样就实现了一个组件挂载即开启定时器的功能，但是仅仅是这样并不完整，当组件卸载的时候并不会清除定时器，控制台会报错。

通常，效果会创建在组件离开屏幕之前需要清理的资源，例如订阅或计时器ID。为此，传递给useEffect的函数可能会返回一个清理函数。

```javascript
  useEffect(() => {
    let timer = setInterval(() => {
      setCount(num + 1)
    }, 2000)
    return () => {
      clearInterval(timer)
    }
  })
```

这样在组件卸载的时候就就会清理掉定时器。清除功能在从UI中删除组件之前运行，以防止内存泄漏。此外，如果组件呈现多次（通常如此），则在执行下一个效果之前会清除先前的效果。在示例中，这意味着每次更新都会清理之前的定时器再创建新的定时器，哪怕是一些不相关的state发生变化也会做上面的事。

但是，在某些情况下，这样做是没必要的，性能是浪费的，例如我们有别的state数据发生更新与这个定时器毫无关系，那么这时候就没必要清理定时器再去重新开启。

要实现此功能，请将第二个参数传递给useEffect，它是效果所依赖的值数组。只有当数组中的值发生变化了才会使useEffect再次执行。

```javascript
import React, { useState, useEffect } from 'react'

export default () => {
  const [num, setCount] = useState(0)
  const [name, setName] = useState('undo')
  useEffect(() => {
    let timer = setInterval(() => {
      setCount(num + 1)
    }, 5000)
    return () => {
      console.log('timer', timer)
      clearInterval(timer)
    }
  }, [num])
  return (
    <div>
      <p>Interval Count: { num }</p>
      <p onClick={()=> {setName(name === 'undo' ? 'sqb' : 'undo')}}>Name: { name }</p>
    </div>
  )
}
```

这样只有num值发生变化的时候才会重置定时器，当操作那么的时候Effect并不会不行，就可以避免一些不必要的清理，订阅和日志等同理。

那如果想要只在组件挂载的时候调用，也就是 componentDidMount 相同的功能也非常简单，给useEffect 第二个参数传一个空数组即可，表示告诉React这个效果不依赖于组件中的任何值，因此这个效果只会在组件挂载的时候运行。

也可以把它作为一个工具函数，在组件挂载和卸载的时候做一些操作的时候能够用到，例如在组件挂载的时候改变页面的标题，卸载的时候再重置到默认标题

```javascript
// 工具函数
import { useEffect } from 'react'
export function useDocumentTitle(title) {
  useEffect(
    () => {
      document.title = title;
      return () => (document.title = "React App")
    },
    [title]
  )
}
```

```javascript
// 工具函数在组件中的使用
import React from 'react'
import { useDocumentTitle } from '../utils/index'

export default () => {
  useDocumentTitle('Interval')
  return (
    <div>
      <p>Interval Count</p>
    </div>
  )
}
```

这个组件挂载的时候将页面标题设置为 'Interval', 这个组件 销毁的时候将页面的标题重置回"React App"。

### useContext

接受上下文对象（从React.createContext返回的值）并返回当前上下文值，由给定上下文的最近上下文提供程序给出。有点类似Provider组件的功能。

```javascript
// 外层组件
import React from 'react'
import DeepChild from './DeepChild'
export const Context = React.createContext(null)
const someVal = { a: 'Context-a', b: 'Context-b' }
export default () => {

  return (
    <Context.Provider value={someVal}>
      <DeepChild></DeepChild>
    </Context.Provider>
  )
}
```

```javascript
// DeepChild.js 子组件
import React, { useContext } from 'react'
import { Context } from './index'
export default () => {
  const aa = useContext(Context)
  console.log(aa) // { a: 'Context-a', b: 'Context-b' }
  return (
    <div>{aa.a}</div>
  )
}
```

在子组件中可以通过 useContext 拿到外层组件中通过上下文定义的数据，后续结合 `useReducer` 几乎就可以实现 react-redux 的功能了。

## Additondal Hooks

### useReducer

它是useState的替代方案，和redux的作用几乎一样，用来集中管理状态，而且基本流程和常用语法也是和redux一致的。它是一个函数 接受一个reducer，reducer我们也很熟悉了 （state，action）=> newState ，一个接受当前状态和action指令返回新的状态的函数。

所以使用起来也是很顺手的，下面就是一个简单的todo的例子。

```javascript
// reducer.js
import { useReducer } from 'react'
const initState = {
  name: 'undo',
  list: []
}

const reducer = (state, action) => {
  const { type } = action
  switch(type) {
    case 'change_name':
      return Object.assign({}, state, {name: action.name})
    case 'add':
      return Object.assign({}, state, {list: [...state.list, action.data]})
    default:
      return state
  }
}

export default () => useReducer(reducer, initState)
```

```javascript
// todo.js
import React from 'react'
import todoReducer from './reducer'
export default () => {
  const [state, dispatch] = todoReducer()
  const {name, list} = state
  return (
    <div>
      {
        list && list.length > 0 && list.map((item, index) => (
          <p key={index}>待办事项 {item}</p>
        ))
      }
      <p>{name}</p>
      <button onClick={() => {
        dispatch({type: 'add', data: list.length + 1})
      }}>
        Add todo
      </button>
      <button onClick={() => {
        dispatch({type: 'change_name', name: name === 'songqibin' ? 'undo' : 'songqibin'})
      }}>
        Change name
      </button>
    </div>
  )
}
```

很简单，和redux的用法几乎一样，useReducer 还支持第三个参数，可以进行一些初始化的操作。就像redux在初始化的时候会先执行一个 init 的action一样。

```javascript
export default () => useReducer(reducer, initState, {type: 'add', data: 3})
```

其实如果再写一个合并reducer的函数，那么几乎可以完全实现redux的功能了。

### useRef

useRef返回一个可变的ref对象，其.current属性被初始化为传递的参数（initialValue）。返回的对象将持续整个组件的生命周期。

初始化传递的参数赋值给了ref对象的current属性，组件挂载完成之后current将指向指定的dom元素。

```javascript
import React, { useRef } from 'react'
export default () => {
  const inputEle = useRef(null)
  console.log(inputEle.current) // null
  const onButtonClick = () => {
    console.log(inputEle) // input
    inputEle.current.focus()
  }
  const onHandleChange = () => {
    console.log(inputEle.current.value) 
  }
  return (
    <div>
      <input ref={inputEle} type="text" onChange={onHandleChange} />
      <button onClick={onButtonClick}>Focus the input</button>
    </div>
  )
}
```

useRef 可以赋值初始值，可以避免直接使用ref方式造成的ref丢失的现象，以后的开发可能需要尽可能的使用它。

### useImperativeMethods

useImperativeMethods自定义使用ref时公开给父组件的实例值，也就是说通过这个函数可以将子组件的实例提供给父组件访问调用。useImperativeMethods应与forwardRef一起使用。

```javascript
// 子组件
import React, { useRef, useImperativeMethods, forwardRef } from 'react'
const FancyInput = (props, ref) => {
  const inputEle = useRef(null)
  useImperativeMethods(ref, () => ({
    focus: () => {
      inputEle.current.focus()
    }
  }))
  const onHandleChange = () => {
    console.log(inputEle.current.value)
  }
  return <input ref={inputEle} type="text" onChange={onHandleChange} />
}

export default forwardRef(FancyInput)
```

```javascript
// 父组件的使用， 在父组件中操作子组件让其聚焦
import React, { useState, useRef } from 'react';
import UseImperativeMethods from './UseImperativeMethods'
export default () => {
  const fancyInputRef = useRef()
  return (
    <div className="App">
          <UseImperativeMethods ref={fancyInputRef}></UseImperativeMethods>
          <button onClick={() => {fancyInputRef.current.focus()}}>Focus child input</button>
       
    </div>
  )
}
```

### useCallback


返回一个memoized回调。

传递内联回调和一组输入。 useCallback将返回一个回忆的memoized版本，该版本仅在其中一个输入发生更改时才会更改。当将回调传递给依赖于引用相等性的优化子组件以防止不必要的渲染（例如，shouldComponentUpdate）时，这非常有用。

输入数组不作为参数传递给回调。但从概念上讲，这就是它们所代表的内容：回调中引用的每个值也应出现在输入数组中。将来，一个足够先进的编译器可以自动创建这个数组。

```javascript
const memoizedCallback = useCallback(
    () => {
        console.log('useCallback', count)
        return count % 3 === 0 ? true : false
    },
    [count],
)
```

### useMemo


返回一个memoized值。和useCallback用法类似。

传递“创建”功能和输入数组。 useMemo只会在其中一个输入发生更改时重新计算memoized值。此优化有助于避免在每个渲染上进行昂贵的计算。

如果未提供数组，则只要将新函数实例作为第一个参数传递，就会计算新值。

输入数组不作为参数传递给函数。但从概念上讲，这就是它们所代表的内容：函数内部引用的每个值也应出现在输入数组中。将来，一个足够先进的编译器可以自动创建这个数组。

### useMutationEffect

签名与useEffect相同，但在更新兄弟组件之前，它在React执行其DOM突变的同一阶段同步触发。使用它来执行自定义DOM突变。

在可能的情况下首选标准useEffect以避免阻止视觉更新。

避免在useMutationEffect中读取DOM。如果这样做，您可以通过引入布局thrash来导致性能问题。在读取计算样式或布局信息时，useLayoutEffect更合适。

### useLayoutEffect


签名与useEffect相同，但在所有DOM突变后同步触发。使用它来从DOM读取布局并同步重新渲染。在浏览器有机会绘制之前，将在useLayoutEffect内部计划的更新将同步刷新。

在可能的情况下首选标准useEffect以避免阻止视觉更新。

如果您正在从类组件迁移代码，则useLayoutEffect会在与componentDidMount和componentDidUpdate相同的阶段触发，因此如果您不确定Hook要使用哪种效果，则可能风险最小。
