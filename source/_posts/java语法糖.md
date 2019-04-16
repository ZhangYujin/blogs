---
title: java语法糖
date: 2017-09-18 10:31:54
tags: java基础
categories:
- 编程
- java基础
---
> java提供了一些语法糖来方便程序员进行开发，语法糖可以看成是编译器实现的一些“小把戏”，虽然不会提供实质性的功能改进，但却能提高效率或者提升语法的严谨性、或者是能减少编码出错的机会。

## 一、泛型和类型擦除
泛型的基本概念就不再详述，这种思想在C++中也有（模板)。不同的语言实现泛型的方式各不相同，而java实现的泛型技术其实是语法糖，也被称为伪泛型。泛型只是在程序源码中有所体现，但在编译后的字节码文件中，就会被替换成原始类型（object)，并需要在相应的地方插入强制类型转换。比如以下代码：
```java
import java.util.HashMap;
import java.util.Map;

public class Demo {

	public static void main(String[] args) {
		Map<String,String> map=new HashMap<String,String>();
		map.put("1", "zhangyujin");
		map.put("2", "are you ok?");
		System.out.println(map.get("1"));
		System.out.println(map.get("2"));
	}
}
```
在编译过后再用反编译工具，能看到以下代码（原本打算用JD-GUI的，可惜只支持jdk1.7及以下，本人环境是1.8的，无奈换个工具**procyon**）
```java
import java.util.HashMap;

// 
// Decompiled by Procyon v0.5.30
// 

public class Demo
{
    public static void main(final String[] array) {
        final HashMap<Object, String> hashMap = new HashMap<Object, String>();
        hashMap.put("1", "zhangyujin");
        hashMap.put("2", "are you ok?");
        System.out.println((String)hashMap.get("1"));
        System.out.println((String)hashMap.get("2"));
    }
}
```
很显然，在控制台打印中对`hashMap.get()`进行了强制转换。
jdk采用这种方式实现泛型，在一些应用场景中就会出现不足
### 泛型遇到重载

```java
import java.util.List;

public class Demo {
	public static void method(List<String> list){
		System.out.println("invoke method(List<String> list)");
	}
	public static void method(List<Integer> list){
		System.out.println("invoke method(List<Integer> list)");
	}
}
```

如上代码，是否能够正确的编译通过呢？按照一般的思维，参数类型应该不一样，按道理是能够通过的。但事实是，在写这段代码的时候，eclipse直接给出提示了
![泛型重载](https://i.imgur.com/xK91eir.png)
很显然，参数List<String> List<Integer>编译后会被擦除，都变成了List<E>,这也使得两个方法的特征签名是一样的，从而判定这是两个一样的方法。

### 在泛型集合指定参数类型后如何能插入另一种类型的数据
在泛型的集合框架指定具体的参数类型以后，若插入另一种类型的数据就会编译错误。但是从以上所了解的内容可以知道，泛型类在编译过后，集合类的参数会变回原始类型，也就是说应该是可以插入不同的类型的数据。这点需要如何才能做到呢？
要想绕过编译期的代码检查，那就需要在运行期动态的去操作，需要用到java反射的技术，通过反射去执行插入方法，能够实现插入不同类型的数据。

```java
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

public class Demo {
	
	public static void main(String[] args) {
		List<String> list=new ArrayList<String>();
		list.add("zhangyujin");
		
		Method method;
        try {
            method = list.getClass().getMethod("add", Object.class);
            method.invoke(list,1000);
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("list中元素的数量："+list.size());
        for(Object s:list){
        	System.out.println(s);
        }
	}
}
```
执行结果：
```
list中元素的数量：2
zhangyujin
1000
```

## 二、自动装箱、自动拆箱
自动装箱和自动拆箱以及遍历循环是编程中使用最为频繁的语法糖。自动装箱是指原始类型自动转化成相应的对象类型，如int类型自动转成Integer类型。拆箱则是相反的过程。
大家都比较熟悉，就不再举例
但有如下代码：
```java
public class Demo {
	
	public static void main(String[] args) {
		Integer a=1;
		Integer b=2;
		Integer c=3;
		Integer d=3;
		Integer e=321;
		Integer f=321;

		System.out.println(c==d);
		System.out.println(e==f);
		System.out.println(c==(a+b));
		System.out.println(c.equals(a+b));
		
	}
}
```
读者可以先思考下打印出来的具体是什么样的值
给个答案和解释：
1. c==d为true e==f为false 为什么呢？自动装箱过程中，添加值是调用了`Integer.valueOf(int)`方法，方法源码如下：
```java
public static Integer valueOf(int i) {
        if (i >= IntegerCache.low && i <= IntegerCache.high)
            return IntegerCache.cache[i + (-IntegerCache.low)];
        return new Integer(i);
    }
```
代码调用过程中，首先是检查值i是否有在常量池中缓存（默认是-128——127,可通过jvm参数指定范围），若存在则直接返回；若不存在则创建新的。以上可知c和d得到的是同一个地址的值，而e和f由于new重新创建，则内存地址是不一样的。
2. c==(a+b)为true，c.equals(a+b)为true，a+b首先会在编译期间直接转成值3，所以这两个判断打印出来的为true

## 三、遍历循环
```java
import java.util.Arrays;
import java.util.List;

public class PrintList {

	public static void main(String[] args) {
		List<Integer> list=Arrays.asList(1,2,3,4,5);
		int sum=0;
		for(int i:list){
			sum+=i;
		}
		System.out.println(sum);
	}
}
```
以上代码编译后得到class文件再进行反编译，得到如下结果：
```java
import java.util.Iterator;
import java.util.List;
import java.util.Arrays;

// 
// Decompiled by Procyon v0.5.30
// 

public class PrintList
{
    public static void main(final String[] array) {
        final List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
        int n = 0;
        final Iterator<Integer> iterator = list.iterator();
        while (iterator.hasNext()) {
            n += iterator.next();
        }
        System.out.println(n);
    }
}
```
感觉具体没啥好说的，大概知道内部是怎么执行的就好了。

## String “+”操作和StringBuilder字符拼接
java中String是不可变的，StringBuilder是可变的，这点大家都清楚。但是有没有思考过String的“+”字符拼接操作内部是如何实现的呢？简单测试下：
```java
public class Demo {
	
	public static void main(String[] args) {
		System.out.println(combine("a","b"));
	}
	
	public static String combine(String a,String b){
		return a+b;
	}
}
```
使用`javac Demo.java`命令获取到Demo.class文件后，使用`javap -c Demo.class > demo.txt`进行反编译，并将反编译的内容输出到文本，内容如下：
```
Compiled from "Demo.java"
public class Demo {
  public Demo();
    Code:
       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: return

  public static void main(java.lang.String[]);
    Code:
       0: getstatic     #2                  // Field java/lang/System.out:Ljava/io/PrintStream;
       3: ldc           #3                  // String a
       5: ldc           #4                  // String b
       7: invokestatic  #5                  // Method combine:(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
      10: invokevirtual #6                  // Method java/io/PrintStream.println:(Ljava/lang/String;)V
      13: return

  public static java.lang.String combine(java.lang.String, java.lang.String);
    Code:
       0: new           #7                  // class java/lang/StringBuilder
       3: dup
       4: invokespecial #8                  // Method java/lang/StringBuilder."<init>":()V
       7: aload_0
       8: invokevirtual #9                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      11: aload_1
      12: invokevirtual #9                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
      15: invokevirtual #10                 // Method java/lang/StringBuilder.toString:()Ljava/lang/String;
      18: areturn
}
```
从中可以看出，String的“+”操作，在源码编译后其实是生成StringBuilder对象进行字符拼接操作的。

