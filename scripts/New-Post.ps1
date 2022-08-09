[cmdletbinding()]
param(
   [Parameter(Mandatory=$true)]
   [string]$PostTitle
)

$postNumber = (Get-ChildItem .\_posts\ | Measure-Object).Count + 1
$templateStr = @'
---
layout: post
title:  "%%POST_TITLE%%"
date:   %%DATE_TIME%%
categories: [post-%%POST_NUMBER%%, development, dev ]
tags: []
comments: false
---
Summary here 

<!--more-->
# Intro
'@

$postContent = $templateStr.Replace('%%DATE_TIME%%', (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
$postContent = $postContent.Replace('%%POST_NUMBER%%', $postNumber)
$postContent = $postContent.Replace('%%POST_TITLE%%', $PostTitle)

$newPostFileName = Join-Path '_posts' "$(Get-Date -Format 'yyyy-MM-dd')-$PostTitle.md"
$postContent | Out-File -Encoding ascii -FilePath $newPostFileName