<?php
// Copyright (C) 2014-2017 Rod Roark <rod@sunsetsystems.com>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This is the place to put JavaScript functions that are needed to support
// options.inc.php. Include this in the <head> section of relevant modules.
// It's a .php module so that translation can be supported.
?>
<script type="text/javascript">

// JavaScript support for date types when the A or B edit option is used.
// Called to recompute displayed age dynamically when the corresponding date is
// changed. Must generate the same age formats as the oeFormatAge() function.
//
function updateAgeString(fieldid, asof, format, description) {
  var datefld = document.getElementById('form_' + fieldid);
  var f = datefld.form;
  var age = '';
  var date1 = new Date(datefld.value);
  var date2 = asof ? new Date(asof) : new Date();
  if (format == 3) {
    // Gestational age.
    var msecs = date2.getTime() - date1.getTime();
    var days  = Math.round(msecs / (24 * 60 * 60 * 1000));
    var weeks = Math.floor(days / 7);
    days = days % 7;
    if (description == '') description = '<?php echo xls('Gest age') ?>';
    age = description + ' ' +
      weeks + (weeks == 1 ? ' <?php echo xls('week') ?>' : ' <?php echo xls('weeks') ?>') + ' ' +
      days  + (days  == 1 ? ' <?php echo xls('day' ) ?>' : ' <?php echo xls('days' ) ?>');
  }
  else {
    // Years or months.
    var dayDiff   = date2.getDate()     - date1.getDate();
    var monthDiff = date2.getMonth()    - date1.getMonth();
    var yearDiff  = date2.getFullYear() - date1.getFullYear();
    var ageInMonths = yearDiff * 12 + monthDiff;
    if (dayDiff < 0) --ageInMonths;
    if (format == 1 || (format == 0 && ageInMonths >= 24)) {
      age = yearDiff;
      if (monthDiff < 0 || (monthDiff == 0 && dayDiff < 0)) --age;
      age = '' + age;
    }
    else {
      age = '' + ageInMonths;
      if (format == 0) {
        age = age + ' ' + (ageInMonths == 1 ? '<?php echo xls('month') ?>' : '<?php echo xls('months') ?>'); 
      }
    }
    if (description == '') description = '<?php echo xls('Age') ?>';
    if (age != '') age = description + ' ' + age;
  }
  document.getElementById('span_' + fieldid).innerHTML = age;
}

// Function to show or hide form fields (and their labels) depending on "skip conditions"
// defined in the layout.
//
var cskerror = false; // to avoid repeating error messages
function checkSkipConditions() {
  var myerror = cskerror;
  var prevandor = '';
  var prevcond = false;
  for (var i = 0; i < skipArray.length; ++i) {
    var target   = skipArray[i].target;
    var id       = skipArray[i].id;
    var itemid   = skipArray[i].itemid;
    var operator = skipArray[i].operator;
    var value    = skipArray[i].value;
    var action   = skipArray[i].action;

    var tofind = id;
    if (itemid) tofind += '[' + itemid + ']';
    // Some different source IDs are possible depending on the data type.
    var srcelem = document.getElementById('check_' + tofind);
    if (srcelem == null) srcelem = document.getElementById('radio_' + tofind);
    if (srcelem == null) srcelem = document.getElementById('form_' + tofind);
    if (srcelem == null) {
      if (!cskerror) alert('Cannot find a skip source field for "' + tofind + '"');
      myerror = true;
      continue;
    }

    var condition = false;
    if (operator == 'eq') condition = srcelem.value == value; else
    if (operator == 'ne') condition = srcelem.value != value; else
    if (operator == 'se') condition = srcelem.checked       ; else
    if (operator == 'ns') condition = !srcelem.checked;

    // Logic to accumulate multiple conditions for the same target.
    // alert('target = ' + target + ' prevandor = ' + prevandor + ' prevcond = ' + prevcond); // debugging
    if (prevandor == 'and') condition = condition && prevcond; else
    if (prevandor == 'or' ) condition = condition || prevcond;
    prevandor = skipArray[i].andor;
    prevcond = condition;
    var j = i + 1;
    if (j < skipArray.length && skipArray[j].target == target) continue;

    // At this point condition indicates the target should be hidden or have its value set.

    var skip = condition;

    if (action.substring(0, 5) == 'value') {
      skip = false;
    }
    else if (action.substring(0, 5) == 'hsval') {
      // This action means hide if true, set value if false.
      if (!condition) {
        action = 'value=' + action.substring(6);
        skip = false;
      }
    }

    var trgelem1 = document.getElementById('label_id_' + target);
    var trgelem2 = document.getElementById('value_id_' + target);
    if (trgelem1 == null && trgelem2 == null) {
      if (!cskerror) alert('Cannot find a skip target field for "' + target + '"');
      myerror = true;
      continue;
    }

    // Find the target row and count its cells, accounting for colspans.
    var trgrow = trgelem1 ? trgelem1.parentNode : trgelem2.parentNode;
    var rowcells = 0;
    for (var itmp = 0; itmp < trgrow.cells.length; ++itmp) {
      rowcells += trgrow.cells[itmp].colSpan;
    }

    // If the item occupies the whole row then undisplay its row, otherwise hide its cells.
    var colspan = 0;
    if (trgelem1) colspan += trgelem1.colSpan;
    if (trgelem2) colspan += trgelem2.colSpan;
    if (colspan < rowcells) {
      if (trgelem1) trgelem1.style.visibility = skip ? 'hidden' : 'visible';
      if (trgelem2) trgelem2.style.visibility = skip ? 'hidden' : 'visible';
    }
    else {
      trgrow.style.display = skip ? 'none' : '';
    }

    // if ((condition && action.substring(0, 5) == 'value') ||
    //     (!condition && action.substring(0, 5) == 'hsval'))
    if (action.substring(0, 5) == 'value')
    {
      // alert(target + ' / ' + action); // debugging
      // var trgelem = document.getElementById('form_' + target);
      var trgelem = document.forms[0]['form_' + target];
      if (trgelem == null) {
        if (!cskerror) alert('Cannot find a value target field for "' + target + '"');
        myerror = true;
        continue;
      }
      var action_value = action.substring(6);
      if (trgelem.type == 'checkbox') {
        trgelem.checked = !(action_value == '0' || action_value == '');
      }
      else {
        trgelem.value = action_value;
        // alert(trgelem.name + ' / ' + action_value); // debugging
        // Handle billing code descriptions.
        var valelem = document.forms[0]['form_' + target + '__desc'];
        if (skipArray[i].valdesc && valelem) {
          // alert('Setting ' + valelem.name + ' value to: ' + skipArray[i].valdesc); // debugging
          valelem.value = skipArray[i].valdesc;
        }
      }
    }
  }
  // If any errors, all show in the first pass and none in subsequent passes.
  cskerror = cskerror || myerror;
}

///////////////////////////////////////////////////////////////////////
// Image canvas support starts here.
///////////////////////////////////////////////////////////////////////

var lbfCanvases = {}; // contains the LC instance for each canvas.

// Initialize the drawing widget.
// canid is the id of the div that will contain the canvas, and the image
// element used for initialization should have an id of canid + '_img'.
//
function lbfCanvasSetup(canid, canWidth, canHeight) {
  LC.localize({
    "stroke"    : "<?php echo xls('stroke'    ); ?>",
    "fill"      : "<?php echo xls('fill'      ); ?>",
    "bg"        : "<?php echo xls('bg'        ); ?>",
    "Clear"     : "<?php echo xls('Clear'     ); ?>",
    // The following are tooltip translations, however they do not work due to
    // a bug in LiterallyCanvas 0.4.13.  We'll leave them here pending a fix.
    "Eraser"    : "<?php echo xls('Eraser'    ); ?>",
    "Pencil"    : "<?php echo xls('Pencil'    ); ?>",
    "Line"      : "<?php echo xls('Line'      ); ?>",
    "Rectangle" : "<?php echo xls('Rectangle' ); ?>",
    "Ellipse"   : "<?php echo xls('Ellipse'   ); ?>",
    "Text"      : "<?php echo xls('Text'      ); ?>",
    "Polygon"   : "<?php echo xls('Polygon'   ); ?>",
    "Pan"       : "<?php echo xls('Pan'       ); ?>",
    "Eyedropper": "<?php echo xls('Eyedropper'); ?>",
    "Undo"      : "<?php echo xls('Undo'      ); ?>",
    "Redo"      : "<?php echo xls('Redo'      ); ?>",
    "Zoom out"  : "<?php echo xls('Zoom out'  ); ?>",
    "Zoom in"   : "<?php echo xls('Zoom in'   ); ?>",
  });
  var tmpImage = document.getElementById(canid + '_img');
  var shape = LC.createShape('Image', {x: 0, y: 0, image: tmpImage});
  var lc = LC.init(document.getElementById(canid), {
    imageSize: {width: canWidth, height: canHeight},
    strokeWidths: [1, 2, 3, 5, 8, 12],
    defaultStrokeWidth: 2,
    backgroundShapes: [shape],
    imageURLPrefix: '<?php echo $GLOBALS['webroot'] ?>/library/js/literallycanvas/img'
  });
  // lc.saveShape(shape);       // alternative to the above backgroundShapes
  lbfCanvases[canid] = lc;
}

// This returns a standard "Data URL" string representing the image data.
// It will typically be a few kilobytes. Here's a truncated example:
// data:image/png;base64,iVBORw0K ...
//
function lbfCanvasGetData(canid) {
  return lbfCanvases[canid].getImage().toDataURL();
}

</script>
