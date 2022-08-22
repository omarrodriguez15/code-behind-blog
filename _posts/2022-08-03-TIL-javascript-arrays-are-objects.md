---
layout: post
title:  "TIL that javascript arrays are objects"
date:   2022-08-03 09:15:00
categories: [post-8, development, dev, til ]
tags: []
comments: false
---
Today I learned that javascript arrays are objects. Typically an array is a contiguous span of memory divided into equal sized slots, where each slot is indexed. This allows for very fast and efficient reading/writing. The javascript array is not this.

<!--more-->
# The javascript array
Arrays are objects that use the Array.prototype instead of the Object.prototype to give them some helpful methods like length, push, and pop, etc. Additionally it has some special behavior where the length property is auto updated. Indexes are converted to strings and used as names for retrieving values.

# Some advantages
No need to provide a length or type when creating an array because the array doesn't need to be initialized with a size when you create an array. You can just say `const a = []`

Very efficient for sparse arrays. However lots of people more commonly use dense arrays.

We don't have to worry about out of bounds errors. This is because it is not really an array, it is more of a hash table with special properties and functions. If the "index" is not in the array you just get an undefined value back.

# Weirdness

Just one example of the weirdness you could see from the javascript array is with the length property. The length property is a special property that is automatically updated to always be 1 larger than the highest integer subscript. Which is not always the same as number of elements in the array.

{% highlight javascript linenos %}
const a = []
a[42] = 'foo'
console.log(a.length) // this will output 43 even thought you would expect 1
{% endhighlight %}

# How I learned this

This is just one of the many things I learned while reading [Javascript: The Good Parts by Douglas Crockford](https://amzn.to/3zWr2k2) . He also has a really good video series on Pluralsight about javascript and he covers somethings he didn't cover in the book.

At the end of the book there is a page about the animal on the cover of the book. It is a Plain Tiger butterfly and here is a little description about it 

>While the Plain Tiger's beauty is part of its charm, its looks can also be deadly. During its larval stages, the butterfly ingests alkaloids that are poisonous to birds—its main predator—which are often attracted to the insect's markings. After ingesting the Plain Tiger, a bird will vomit repeatedly—occasionally fatally. If the bird lives, it will let other birds know to avoid the insect, which can also be recognized by its leisurely, meandering pattern of flying low to the earth. 