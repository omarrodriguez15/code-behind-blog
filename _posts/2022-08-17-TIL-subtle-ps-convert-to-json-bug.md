---
layout: post
title:  "TIL about an unexpected behavior in powershell's ConvertTo-Json"
date:   2022-08-17 21:32:35
categories: [post-10, development, dev, til ]
tags: []
comments: false
---
Today I learned about an unexpected behavior in powershell's `ConvertTo-Json`. When you pipe more than one object to the `ConvertTo-Json` cmdlet the output is an array of objects, as expected. When one object, or an array with a single object, is piped to it a single object is outputted.

<!--more-->
# Discovering the behavior
This behavior was discovered while looking into a bug where some code that was querying some objects in powershell behaved unexpectedly. The results of the query were converted to JSON and written to a JSON file. That JSON file was then read and parsed with the expectation that the contents was an array. Which was the result in most cases, since in most cases the query returned more than one object. 

However in one case we kept seeing a parsing error when reading the JSON. The parsing error was because we were expecting the JSON file to contain an array of objects. But in some cases it was getting an object or an empty string.

# Expected behavior
What I was expecting powershell to output, given the output of a cmdlet that outputs arrays of objects, is to always output an array regardless of number of objects given. However instead what we get is the following.

{% highlight powershell linenos %}
@('foo', 'bar') | ConvertTo-Json
{% endhighlight %} 
**Expected: ['foo', 'bar']**  
**Actual: ['foo', 'bar']**  

{% highlight powershell linenos %}
@('foo') | ConvertTo-Json
{% endhighlight %} 
**Expected: ['foo']**  
**Actual: 'foo'**  

{% highlight powershell linenos %}
@() | ConvertTo-Json
{% endhighlight %} 
**Expected: []**  
**Actual:**  

# Conclusion
It makes sense why `ConvertTo-Json` behaves like this even though it is not immediately obvious. The cmdlet needs to be able to turn input from any source into `JSON`. The input could come from a web API or could come from a cmdlet that normally outputs an array of objects. In both scenarios it need to behave consistently without any knowledge of the source. A bit of an inconvenient behavior in the scenario of the bug we found, however the behavior makes complete sense.