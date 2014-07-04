---
title: Folding Websites
collection: posts
date: 2012-02-06
template: post.jade
---

I've been seeing a lot cool experiments with CSS3 transformations in the browser lately and it's inspired me to do some experimenting of my own. That and I've been trying to think of something interesting to present on my blog...

And where better to find some cool effects to rip off than in OSX? In particular, I think the way the Lion version of Mail expands blocks of quoted text looks pretty nifty and I was wondering if it would be possible to pull off the effect in HTML/CSS.

![](http://media.tumblr.com/tumblr_lywgh5j6aw1qzx9nu.png)

<small>*The effect in Mail*</small>

Well it turns out that, thanks to CSS3 Transforms, it is! After a bit of hacking and slicing I wound up creating something that I'm quite happy with. And I figured creating a jQuery plug-in would be a great way to share the love.

### jQuery Unfold

[GitHub project page](https://github.com/mikejholly/jquery-unfold)

The result is *jQuery Unfold*. Now you can do fancy Mail app style unfold effects in your browser! It looks really good in Webkit (Safari and Chrome) and pretty good in Firefox (more info below).

![](http://media.tumblr.com/tumblr_lz0duto1Zw1qzx9nu.png)

<small>*Tada!*</small>

Basically the effect works by slicing up a chunk of content and animating the height and rotation of each slice independently. Each slice has multiple wrappers that control the vertical offset of the content relative to that slice. Overall the code isn't that complex and it only took a touch of math (some basic trig to get the correct wrapper height based on the rotation angle). The browser does almost everything for you.

### Usage

To use the effect, just add ```$(this).unfold()``` to your click handler after including the script. To customize the animation a bit, pass in custom duration and easing options. You can also chop the content into as many slices as you want.

Here are some more options:

<pre class="prettyprint">
$('article').unfold({
  easing: 'easingFunction',
  duration: 1000,
  slices: 10,
  perspective: 600,
  shadow: true
});
</pre>

[Check out the demo](http://mikejholly.github.com/jquery-unfold/)

### A Couple of Tweaks

After replaying the animation 1,000 times in Mail, I noticed that they make clever use of perspective to enhance effect. Luckily, the CSS3 ```perspective``` and ```perspective-origin``` properties provide exactly what we need to achieve the same look.

Another challenge was creating a nice shadow on each slide. Given that the background could be a solid color or an image, I needed a solution that would work in all cases. I ended up duplicating the rotated container and using a CSS3 linear gradient that fades from black to transparent. The shadow layer is then stacked on top of the content. This gives the slice a nice shadow that should look good in most cases (except when the background is a dark solid color).

It seems like Webkit is outpacing Firefox where CSS transformations are concerned. I ran into a couple of small annoyances while working on this script. I'm not sure if the fix for [this bug](https://bugzilla.mozilla.org/show_bug.cgi?id=704469) has been included in the most recent version (10), but it seems that Firefox has trouble maintaining the perspective of elements when ```overflow: hidden``` is used. Also, the animation just seems clunkier overall on Firefox.

### &lt;P&gt; Soup

Because of the way vertical margins collapse, there is a bit of difficulty with slicing up the segments. It should work as expected in most cases, but if you run into double margins or weird popping (when the animation finished) try fiddling with the ```collapse``` option (it's a boolean).

### Achievement Unlocked

So there you go, it's now possible to do awesome OSX style effects in the browser thanks to CSS3 transforms.
