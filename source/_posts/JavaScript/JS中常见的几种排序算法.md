---
title: JS中常见的几种排序算法
subtitle: js_sorting_algorithm
tags: [JS, JS基础, 排序算法]
date: 2017-06-20
categories: JavaScript
description:
---

JS中常见的排序算法有很多,这里简单介绍几种最常见的三种排序算法: `冒泡排序`, `快速排序`, `插入排序`

以下排序算法的实现都是基于数组的, 且都是数字.

<!--more-->

### 1. 冒泡排序

`冒泡排序` 是一种交换排序，它的基本思想是：两两比较相邻记录的关键字，如果反序则交换，直到没有反序的记录为止.它重复地走访过要排序的数列，一次比较两个元素，如果它们的顺序错误就把它们交换过来。走访数列的工作是重复地进行直到没有再需要交换，也就是说该数列已经排序完成。这个算法的名字由来是因为越小的元素会经由交换慢慢“浮”到数列的顶端。

```javascript
function bubbleSort(ary) {
    var len = ary.length, flag = null;
    if (len > 1) {
        for (var i = 0; i < len - 1; i++) {
            flag = false;
            for (var j = 0; j < len - 1 - i; j++) {
                if (ary[j] > ary[j + 1]) {
                    var temp = ary[j];
                    ary[j] = ary[j + 1];
                    ary[j + 1] = temp;
                    flag = true;
                }
            }
            if (!flag) {
                break;
            }
        }
    }
    return ary;
}
```

算法中利用 `flag` 进行排序次数的优化, 如果本轮中出现当前项不大于后一项的时候说明本轮排序已经结束.

**时间复杂度**
最佳情况：`T(n) = O(n)` 
最差情况：`T(n) = O(n^2) `
平均情况：`T(n) = O(n^2)`

### 2. 快速排序

1. 在数据集之中，选择一个元素作为”基准”（pivot）。 
2. 所有小于”基准”的元素，都移到”基准”的左边；所有大于”基准”的元素，都移到”基准”的右边。 
3. 对”基准”左边和右边的两个子集，不断重复第一步和第二步，直到所有子集只剩下一个元素为止。

```javascript
function quickSort(ary) {
    var len = ary.length;
    if (len <= 1) {
        return ary;
    }
    var leftArr = [], rightArr = [], tar = ary[0];
    for (var i = 1; i < len; i++) {
        var cur = ary[i];
        cur < tar ? leftArr.push(cur) : rightArr.push(cur);
    }
    return quickSort(leftArr).concat(tar, quickSort(rightArr));
}
```

**时间复杂度**

最佳情况：`T(n) = O(nlogn) `
最差情况：`T(n) = O(n^2) `
平均情况：`T(n) = O(nlogn)`

### 3. 插入排序

插入排序的基本操作是将一个记录插入到已经排好序的有序表中，从而得到一个新的、记录数增1的有序表

1. 从第一个元素开始，该元素可以认为已经被排序
2. 取出下一个元素，在已经排序的元素序列中从后向前扫描 
3. 如果该元素（已排序）大于新元素，将该元素移到下一位置 
4. 重复步骤3，直到找到已排序的元素小于或者等于新元素的位置 
5. 将新元素插入到该位置后
6. 重复步骤2~5

```javascript
function inertSort(ary) {
    var len = ary.length;
    if (len > 1) {
        for (var i = 1; i < len; i++) {
            if (ary[i] < ary[i - 1]) {
                var cur = ary[i], j = i - 1;
                while (j >= 0 && cur < ary[j]) {
                    ary[j + 1] = ary[j];
                    j--;
                }
                ary[j + 1] = cur;
            }
        }
    }
    return ary;
}
```

**时间复杂度**

最佳情况：输入数组按升序排列 `T(n) = O(n)` 
最坏情况：输入数组按降序排列 `T(n) = O(n^2) `
平均情况：`T(n) = O(n^2)`