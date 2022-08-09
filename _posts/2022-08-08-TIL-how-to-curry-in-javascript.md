---
layout: post
title:  "TIL how to curry in javascript"
date:   2022-08-08 21:15:16
categories: [post-9, development, dev ]
tags: []
comments: false
---
Today I learned how to make a very simple currying function in javascript. I was already familiar with the concept of currying, however after seeing this really simply currying function in javascript it really cemented the concept in my head.

<!--more-->
# Currying

Currying is a popular technique in functional programming. Many functional programming languages support currying natively. [Here is a definition of currying directly from Wikipedia](https://en.wikipedia.org/wiki/Currying) :
>In mathematics and computer science, currying is the technique of converting a function that takes multiple arguments into a sequence of functions that each takes a single argument.
Put simply, it is a way to break down a function that takes multiple arguments into smaller functions that only take one argument.

# Currying in javascript

In javascript currying is very simple to implement due to the closure feature. This is from [Mozilla dev documentation on Closure](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures) :
>... a closure gives you access to an outer function's scope from an inner function. In JavaScript, closures are created every time a function is created, at function creation time. 

Here is a very simple implementation of currying in javascript.
{% highlight javascript linenos %}
function curry (func, arg1) {
  return function(arg2) {
    return func(arg1, arg2)
  }
}
{% endhighlight %} 

Here is an example of using the currying function.
{% highlight javascript linenos %}
function add(arg1, arg2) {
  return arg1 + arg2
}

const addThree = curry(add, 3)
console.log(addThree(7)) // This outputs 10
{% endhighlight %} 

# Benefits of currying
The above example is very simple, but there are many benefits to currying functions.
* Composing a specialized version of a function so that you don't have to continue to pass the same parameters and only pass the arguments that change or are important to the caller.
* Composing higher order functions, or functions that take functions, makes code more declarative and easier to read.

# Conclusion 
Implementing a currying function in javascript is very helpful in understanding closures and currying. If you do decide to use currying in your javascript or typescript code base I would recommend first looking into using a functional library. The implementation of currying above is just for example purposes and is an incomplete implementation. 