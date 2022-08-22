---
layout: post
title:  "TIL about powershell event handlers"
date:   2022-07-30 09:15:00
categories: [post-6, development, dev, til ]
tags: []
comments: false
image:
  feature: pwsh.jpeg
  credit: Omar Rodriguez
---
Today I learned how to recognize event handlers in powershell code. I learned how to recognize it by helping a coworker troubleshoot a memory usage issue.

<!--more-->
# The problem
We had a pretty simple powershell script to display an image, with a background gradient, full screen while some other work happened. It was pretty straight forward and simple, so it was very odd when we noticed every time we ran the script the memory kept rising and falling in a sawtooth pattern. 

A sawtooth pattern is where the memory climbs then suddenly drops and continues to repeat this pattern. When viewing the pattern on a graph it looks like a row of shark teeth or sawtooths. The pattern is well known but the cause of it varies widely and could be because of many different reasons.

If you were to recreate this issue on a laptop with plenty of memory, you likely wouldn't even notice the issue, especially if you use a small enough image. The system we were needing to use this script on had limited resources and this little spike in memory usage was causing OOM (OutOfMemory) errors.

# The problematic code
Here is a snippet of the code, and what it originally looked like with the bug in it.

{% highlight powershell linenos %}
...
$form.add_paint({
  $back = [System.Drawing.Bitmap]::new($pictureBox.Width, $pictureBox.Height)
  $myBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
      [System.Drawing.Point]::new(0, 10),
      [System.Drawing.Point]::new($pictureBox.Width, 10),
      [System.Drawing.Color]::FromArgb(166, 206, 57),
      [System.Drawing.Color]::FromArgb(49, 169, 224)
  )
  $graphics = [System.Drawing.Graphics]::FromImage($back)
  $graphics.FillRectangle($myBrush, $pictureBox.DisplayRectangle)
  $pictureBox.BackgroundImage = $back
})
$form.controls.add($pictureBox)
[System.Windows.Forms.Application]::Run($form)
...
{% endhighlight %}

# Initial troubleshooting
Something that initially stood out in the code was the `$form.add_paint(...)` call. It was odd seeing a code block in a method call like that. .NET has pretty decent api documentation, so that was my first stop. I could not find anything that referenced this add_paint call on the windows form api.

# The breakthrough
After some digging, and lots of head scratching, I found that this call is actually an event handler on the form object for the Paint event. It makes sense that the event handlers are named and used differently in powershell. Powershell doesn't have the `+=` syntax to subscribe to event handlers like C#.

If the object has an event handler than the powershell equivalent is add_eventName(..), where eventName is the name of the original event in the .NET api. [Here is a much more detailed explanation I found on SO about powershell events](https://stackoverflow.com/a/64232782/4172545)

# Understanding the problem
So now once we understood what this code was doing it was more obvious what the problem was. The paint event is fired any time the control needs to redraw due to changes to the control. In the paint event handler we had, it was modifying one of the controls on our form by adding a background, which caused the paint event to fire. So basically we had an infinite loop of the paint event firing, us modifying the form, which caused the paint event to fire again and start the loop all over. 

Speculating as to why this caused the memory to spike and then drop is that we were loading multiple bitmaps into memory on each loop and causing the memory to spike. Then likely the .NET runtime ran GC (garbage collection) and cleaned up unused bitmaps.

# The fix
The fix was to use the `Shown` event, or `.add_shown(...)` in powershell, and not the `Paint` event. The shown event only fires once when the form initially is shown. We have to wait for the form to be shown so that we can use its dimensions to set a custom gradient background behind the image we want to show. 


If you have any comments or questions reach out on Twitter [@Omarr2d2](https://twitter.com/omarr2d2).