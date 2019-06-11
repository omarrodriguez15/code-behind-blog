---
layout: post
title:  "Git the most edited files in a project"
date:   2019-06-10 22:02:00
categories: [post-3, software, programming, git, clean code]
tags: [software, programming, git, clean code]
comments: false
---

This post was inspired from seeing multiple bugs coming from the same file in a project in a short period of time. I could easily see all types of code smells in this particular file. So I had a hypothesis, if I could find the most edited files in the repo I would likely find the files with the most technical debt i.e. most code smells. So I created a very simple powershell script to test my hypothesis.  

<!--more-->

<A href="#solution">Skip to the solution section below if you just want to see code.</A>

## Why do the most edited files matter ?  
Why do files change? In most cases files change for two reasons, there is a bug or there are changes that are needed to support a new feature. Lots of changes in a file due to bugs is obviously a good reason to take a closer look at a file.  

Lots of changes to a file in order to support new features is also a good reason to take a closer look at a file since it could mean that the rest of your project may be too tightly coupled to things in this file or maybe the file has too many responsibilities.  

## Different approaches to the problem
The solution below can easily be converted into some other scripting language if needed but since powershell is cross-platform you should be able to run this on any some what modern computer. Tested both on windows and OSX

## Solution ##
This is the pretty script version you can just copy paste this into a `.ps1` file and  run it. 
* Notice that the last command argument `-First 10` can be changed to control the top results you want displayed.  
* Add a `-#` to the git command to control how many commits you want to run the script on. For example `git log --pretty=format: --name-only -50` will only run the analysis on the last 50 commits.    
{% highlight powershell linenos %}
git log --pretty=format: --name-only | 
Where-Object { ![string]::IsNullOrEmpty($_) }  | 
Group-Object  | 
Sort-Object -Property Count -Descending | 
Select-Object -Property Count, Name -First 10
{% endhighlight %}  

Here is a shortened dirty one-liner version  
{% highlight powershell linenos %}
git log --pretty=format: --name-only | ? { ![string]::IsNullOrEmpty($_) } | group  | Sort-Object -Property Count -Descending | select -Property Count, Name -First 10 
{% endhighlight %}

## Code breakdown  
Using some built-in powershell cmdlets and pipelining we transform some git text output into some useful statistics about a repository. 
1. `git log --pretty=format: --name-only` gives you the list of files changed per commit.
2. `Where-Object { ![string]::IsNullOrEmpty($_) }` filters out all empty lines that are used by the git output from the first command to separate commits.
3. `Group-Object` groups all the lines that are the same together and gives you the number of objects in each group.
4. `Sort-Object -Property Count -Descending` sorts the groups by the `count` which is number of same files from highest to lowest.
5. `Select-Object -Property Count, Name -First 10` selects the first 10 objects and displays the `Count` and `Name` properties. (The properties are from the objects that `Group-Object` has passed down the pipeline)

### Some notes on the "Dirty one-liner"
This one-liner is essentially the same thing as the pretty version except that it is all on one-line and uses the aliases for `Where-Object`, `Group-Object`, and `Select-Object`.

## Example output  
Output after running the code should be something like this :  
```
Count Name                            
----- ----                            
   33 _config.yml                     
   16 _layouts/post.html              
   15 README.md                       
   13 _includes/sidebar.html   
```

## Room for improvement  
* Instead of just sorting by the number of times a file has changed sort by the number of lines in aggregate that has changed in a file.  
* Maybe as a part 2 complementary type script, have a way to determine the most changed section of code maybe even narrow it down to functions or class names.  
* Filter out certain projects in a repository to target analysis to a specific project.  
* Filter out non bug-fix changes.  
* Filter out bug-fix changes.  

