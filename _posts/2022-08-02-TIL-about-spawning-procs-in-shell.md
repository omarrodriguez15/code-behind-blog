---
layout: post
title:  "TIL about spawning processes without a shell"
date:   2022-08-02 09:15:00
categories: [post-7, development, dev, til ]
tags: []
comments: false
---
Today I learned about the differences between spawning a process in a shell and without a shell. 

<!--more-->
# The problem

I was helping another dev with troubleshooting some new code. He was using `child_process.spawn()`. Which takes a base command, a string array of arguments, and an options object. This is what the code we were troubleshooting looked like.

{% highlight powershell linenos %}
...
const pidToKill = '12345'
...
child_process.spawnSync('taskkill.exe', [`/pid ${pidToKill}`], { shell: false })
...
{% endhighlight %}

# The breakthrough

After some experimenting with the child_process spawn api, we found out that the shell option set to false was the problem. When the shell option is false it means the arguments are sent directly to the executable. So there is no intermediate processing of the arguments, which means the `taskkill.exe` received the `/pid 12345` argument as a single argument. Where as if we were to open a shell like `cmd.exe` or `powershell.exe` and run `taskkill.exe /pid 12345` the `taskkill.exe` receives two arguments because the shell parses everything after the command and passes them in as separate arguments.

The fix was to split the arguments into separate entries in the arguments array `child_process.spawnSync('taskkill.exe', [ '/pid', pidToKill ], { shell: false })`. An alternative fix could have been to set shell to true. However if the shell option is set to true, we must be very careful to sanitize all arguments being passed. Any arguments containing shell metacharacters may be used to trigger arbitrary command execution.
