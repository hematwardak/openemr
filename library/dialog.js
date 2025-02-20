// Copyright (C) 2005 Rod Roark <rod@sunsetsystems.com>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// open a new cascaded window
function cascwin(url, winname, width, height, options) {
 var mywin = window.parent ? window.parent : window;
 var newx = 25, newy = 25;
 if (!isNaN(mywin.screenX)) {
  newx += mywin.screenX;
  newy += mywin.screenY;
 } else if (!isNaN(mywin.screenLeft)) {
  newx += mywin.screenLeft;
  newy += mywin.screenTop;
 }
 if ((newx + width) > screen.width || (newy + height) > screen.height) {
  newx = 0;
  newy = 0;
 }
 top.restoreSession();

 // MS IE version detection taken from
 // http://msdn2.microsoft.com/en-us/library/ms537509.aspx
 // to adjust the height of this box for IE only -- JRM
 if (navigator.appName == 'Microsoft Internet Explorer')
 {
    var ua = navigator.userAgent;
    var re  = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
    if (re.exec(ua) != null)
    rv = parseFloat( RegExp.$1 ); // this holds the version number
    height = height + 28;
 }

retval=window.open(url, winname, options +
 ",width="   + width + ",height="  + height +
 ",left="    + newx  + ",top="     + newy   +
 ",screenX=" + newx  + ",screenY=" + newy);
  
return retval;
}
// recursive window focus-event grabber
function grabfocus(w) {
 for (var i = 0; i < w.frames.length; ++i) grabfocus(w.frames[i]);
 w.onfocus = top.imfocused;

 // the following was tried and discarded because it's too invasive and
 // does not help anyway, but i left it here for the curious.
 //
 // for (var i = 0; i < w.document.forms.length; ++i) {
 //  var e = w.document.forms[i].elements;
 //  for (var j = 0; j < e.length; ++j) {
 //   e[j].onfocus = top.imfocused;
 //  }
 // }
}

// call this when a "modal" dialog is desired
function dlgopen(url, winname, width, height) {
 if (top.modaldialog && ! top.modaldialog.closed) {
  if (window.focus) top.modaldialog.focus();
  if (top.modaldialog.confirm(top.oemr_dialog_close_msg)) {
   top.modaldialog.close();
   top.modaldialog = null;
  } else {
   return false;
  }
 }
 top.modaldialog = cascwin(url, winname, width, height,
  "resizable=1,scrollbars=1,location=0,toolbar=0");
 grabfocus(top);
 return false;
}

 // This is called from del_related() which in turn is invoked by find_code_dynamic.php.
 // Deletes the specified codetype:code from the indicated input text element.
 function my_del_related(s, elem, usetitle) {
  if (!s) {
   // Deleting everything.
   elem.value = '';
   if (usetitle) elem.title = '';
   return;
  }
  // Convert the codes and their descriptions to arrays for easy manipulation.
  var acodes  = elem.value.split(';');
  var i = acodes.indexOf(s);
  if (i < 0) return; // not found, should not happen
  // Delete the indicated code and description and convert back to strings.
  acodes.splice(i, 1);
  elem.value = acodes.join(';');
  if (usetitle) {
   var atitles = elem.title.split(';');
   atitles.splice(i, 1);
   elem.title = atitles.join(';');
  }
 }
