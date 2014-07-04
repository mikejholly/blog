---
title: Making Software Translation Easier
collection: posts
date: 2012-02-18
template: post.jade
---

If you've ever had to translate an application into multiple languages, you're probably familiar with [Poedit](http://www.poedit.net/). It's a free cross platform Gettext catalog file editor. We've been using the tool for translations at [Strutta](http://www.strutta.com) for a while. It's the best tool for the job (that I know of) but it, unfortunately, suffers from freeware-itis: the interface is clunky; and the error messages are cryptic and frequent. That being said, it's not a terrible program. I just wanted to make PO editing fun again (just kidding--it was never fun :P)!

### Introducing EasyPO

[Video demo](http://youtu.be/ZeCZBt2Qgm0)

And so I made [EasyPO](http://easypo.com). It's a lightweight app for editing and composing Gettext translations in the browser. You can upload a PO file, make changes, share the URL with others and even watch as they make changes (it uses [Socket.IO](http://socket.io/) for this piece)! The URL lives on, and the changes are automatically committed as you make them, so there's never a need to click *Save*.

![](http://media.tumblr.com/tumblr_lzm3jpUF3U1qzx9nu.png)

<small>http://easypo.com/edit/4f4065907b351e0127001071</small>

Overall, I found the process of designing and building a lightweight web app like this very rewarding. The project was an exercise in simplicity: how simple can I make the interface while keeping things usable? I wrote down the features I wanted the app to have, drew a few sketches, and built it in a few evenings. I had a number of goals from the get-go: I wanted it to be easy; I wanted it to make the overall translation workflow less painful; and, I wanted to be able to keep track of translator progress. I think the app does a good job on all these fronts.

### How it Works

If you load up [EasyPO.com](http://easypo.com), you'll see there's nothing but a drop target (unless you're on IE :P) asking you to drag and drop your PO (or POT) file. After doing so, the app will immediately open the edit view from which you can CRUD any of the PO document strings.

There are only a few buttons exposed in the edit UI: the *Info* button opens the PO file headers (basically language settings and plural-forms); the *Download* button generates and downloads (duh) the PO file that you've edited/created; and, the *Add* button let's you add a new string to the document.

I've also added a support for machine translations via the Google Translate API (the translation quality is pretty good for simple phrases). There's also a search feature which allows for quick filtering of strings as you type.

### Technical Notes

Building the app was a nice diversion and a chance to play with new tools. I've been eager to build a complete (albeit small) app using [Express](http://expressjs.com/) and [Backbone.js](http://documentcloud.github.com/backbone/) for a while. Using these new tools was a lot of fun. I especially enjoyed using Backbone, which does an exceptional job of keeping your Javascript code tidy and terse. I liked the flexibility it offers--you're not stuck with one particular way of doing things. The approach to event handling was particularly smart.

I used [FormData](https://developer.mozilla.org/en/XMLHttpRequest/FormData) for file uploads. It's a great next-generation addition to the browser that abstracts away the manual worked you'd normally have to do when posting multipart data with ajax.

Here's how it works:

<pre class="prettyprint">
var files = e.originalEvent.dataTransfer.files;
if (files.length &gt; 0) {
  var data = new FormData();
  data.append('file', files[0]);
  $.ajax({
    url: '/upload',
    type: 'POST',
    data: data,
    dataType: 'json',
    processData: false,
    contentType: false,
    success: function(data) {
      AppRouter.navigate('edit/' + data._id, true);
    }
  });
}
</pre>

I also created a couple of Node modules for the project. One is a Gettext PO file library ([node-po](https://github.com/mikejholly/node-po)) and the other is a Google Translate API client ([node-google-translate](https://github.com/mikejholly/node-google-translate)). They're both available to npm if anyone is interested in using them.

As I mentioned, the app uses Socket.IO to alert you of edits, as they're being made.

### Improvements

[EasyPO](http://easypo.com) should work flawlessly (aka "it works for me") in Chrome/Safari/FF/IE9 and pretty well in IE8.

I'm currently working on integrating the [myGengo](http://mygengo.com) API. I'm pretty excited about this as it will allow for quick translations of your strings by *actual human translators*. Their service isn't free so I'll probably have to charge a nominal fee for human translation.

The largest PO file I've tested was about 6,000 lines. The interface becomes a little sluggish when editing files with so many entries, but it's still usable. I'm probably going to implement smarter paging soon--the app will only display so many entries at once and then intelligently load in subsequent sets.

### All Done

This project was a small side-project that I enjoyed building. If you've ever been frustrated editing PO files, I hope this app makes your job easier!
