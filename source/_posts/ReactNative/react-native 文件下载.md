---
title: react-native 文件下载
subtitle: rn_simple_download_manager
tags: [react-native]
categories: ReactNative
date: 2018-07-11
---

在做安卓App的时候，遇到一个需求下载pdf，下载完成在通知栏提示，并且能够打开下载的文件。

其实这个需求是很常见和普通的需求，但是刚做 RN 项目不久，遇到的这类问题也不是很会处理，特此记录一下。

本次是使用了一个 `react-native` 包, **react-native-simple-download-manager**

<!--more-->

### 1. 安装

用以下命令进行包安装

```bash
yarn add react-native-simple-download-manager
// or 
npm i react-native-simple-download-manager --save
```

link 一下

```bash
react-native link react-native-simple-download-manager
```

### 2. android 文件的修改

link 之后 android 下的文件会做以下改动

#### 1. android/app/src/main/java/[...]/MainApplication.java

添加 `import com.masteratul.downloadmanager.ReactNativeDownloadManagerPackage;`

添加 `new ReactNativeDownloadManagerPackage()` 到 `getPackages()` 中

#### 2. android/settings.gradle

```javascript
include ':react-native-simple-download-manager'
project(':react-native-simple-download-manager').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-simple-download-manager/android')
```

#### 3. android/app/build.gradle

```javascript
compile project(':react-native-simple-download-manager')
```

### 3. 使用

文件下载使用的是 `downloadManager.download` 方法

```javascript
import downloadManager from 'react-native-simple-download-manager'

download = async (orderId) => {
  const url = 'https://p.upyun.com/docs/cloud/demo.jpg'
  const headers = {'Authorization': 'Bearer abcsdsjkdjskjdkskjd'};
  const config = {
    downloadTitle: '图片下载',
    downloadDescription: '图片下载完成',
    saveAsName: orderId + '.pdf',
    allowedInRoaming: true,
    allowedInMetered: true,
    showInDownloads: true,
    external: false, // when false basically means use the default Download path (version ^1.3)
    path: 'Download/' // if "external" is true then use this path (version ^1.3)
  }
  downloadManager.download(url, headers, config).then((response) => {
    console.log(url)
    console.log('Download success!')
    ToastAndroid.showWithGravity('图片下载成功', ToastAndroid.SHORT, ToastAndroid.CENTER)
  }).catch(err => {
    console.log(err)
    ToastAndroid.showWithGravity('图片下载失败，请重新下载', ToastAndroid.SHORT, ToastAndroid.CENTER)
  })
}
```

以上是简单使用，config 中 external 为 false 时，只会下载，并在通知栏进行通知。

效果图如下

![](https://github.com/undo03/undo03.github.io/blob/master/article_images/Reactnative/20180712.gif?raw=true)

配置项解析：

+ url： 文件下载地址
+ headers： 请求头信息，需要身份认证的可以设置 Cookie
+ config： 配置信息
  - downloadTitle： 通知栏通知标题
  - downloadDescription： 描述信息
  - saveAsName： 文件保存的名字
  - external： 是否保存到SD卡
  - path： 文件保存的路径，external 为 true 才有效

如果要保存到设备文件管理中，需要添加权限文件读写权限

需要在 `android/app/src/main/AndroidManifest.xml` 中添加权限

```javascript
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

使用 PermissionsAndroid 检测是否开启权限

```javascript
import {PermissionsAndroid} from 'react-native'
let authorizedWriteSD = await PermissionsAndroid.request(PermissionsAndroid.PERMISSIONS.WRITE_EXTERNAL_STORAGE).then(authorized => authorized)
if (authorizedWriteSD !== 'granted') {
  ToastAndroid.showWithGravity('请开启访问设备上照片、媒体内容和文件权限，否则无法保存文件', ToastAndroid.SHORT, ToastAndroid.CENTER)
  return
}
const config = {
    downloadTitle: '电子发票下载',
    downloadDescription: '电子发票下载完成',
    saveAsName: orderId + '.pdf',
    allowedInRoaming: true,
    allowedInMetered: true,
    showInDownloads: true,
    external: true, // when false basically means use the default Download path (version ^1.3)
    path: 'Download/' // if "external" is true then use this path (version ^1.3)
  }
```

设置带身份验证的下载

```javascript
const url = CONFIG.PREFIX + `order/download_pdf?order_id=${orderId}`
let userInfoToken = await localStorage.getItem('userInfoToken')
const headers = {'Cookie': userInfoToken}
...
```

### 4. 其他API

+ download
+ queueDownload
+ attachOnCompleteListener
+ cancel
+ checkStatus

具体可以查看 [https://github.com/master-atul/react-native-simple-download-manager/blob/master/index.js](https://github.com/master-atul/react-native-simple-download-manager/blob/master/index.js)
  
