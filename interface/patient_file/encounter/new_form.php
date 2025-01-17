<?php
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

include_once("../../globals.php");
require_once $GLOBALS['srcdir'].'/ESign/Api.php';

$esignApi = new Esign\Api();
?>
<html>
<head>
<?php html_header_show();?>
<link rel="stylesheet" href="<?php echo $css_header; ?>" type="text/css">

<script language="JavaScript">

function openNewForm(sel, label) {
 top.restoreSession();
<?php if ($GLOBALS['concurrent_layout']) { ?>
  var FormNameValueArray = sel.split('formname=');
  if (FormNameValueArray[1] == 'newpatient') {
    // TBD: Make this work when it's not the first frame.
    parent.frames[0].location.href = sel;
  }
  else {
    parent.twAddFrameTab('enctabs', label, sel);
  }
<?php } else { ?>
  top.frames['Main'].location.href = sel;
<?php } ?>
}

function toggleFrame1(fnum) {
  top.frames['left_nav'].document.forms[0].cb_top.checked=false;
  top.window.parent.left_nav.toggleFrame(fnum);
}
</script>
<style type="text/css">
#sddm
{	margin: 0;
	padding: 0;
	z-index: 30;
}
#sddm div{
    z-index:30;
}
</style>
<script type="text/javascript" language="javascript">

var timeout	= 500;
var closetimer	= 0;
var ddmenuitem	= 0;
var oldddmenuitem = 0;
var flag = 0;

// open hidden layer
function mopen(id)
{
	// cancel close timer
	//mcancelclosetime();
	
	flag=10;

	// close old layer
	//if(ddmenuitem) ddmenuitem.style.visibility = 'hidden';
	//if(ddmenuitem) ddmenuitem.style.display = 'none';

	// get new layer and show it
        oldddmenuitem = ddmenuitem;
	ddmenuitem = document.getElementById(id);
        if((ddmenuitem.style.visibility == '')||(ddmenuitem.style.visibility == 'hidden')){
            if(oldddmenuitem) oldddmenuitem.style.visibility = 'hidden';
            if(oldddmenuitem) oldddmenuitem.style.display = 'none';
            ddmenuitem.style.visibility = 'visible';
            ddmenuitem.style.display = 'block';
        }else{
            ddmenuitem.style.visibility = 'hidden';
            ddmenuitem.style.display = 'none';
        }
}
// close showed layer
function mclose()
{
	if(flag==10)
	 {
	  flag=11;
	  return;
	 }
	if(ddmenuitem) ddmenuitem.style.visibility = 'hidden';
	if(ddmenuitem) ddmenuitem.style.display = 'none';
}

// close layer when click-out
document.onclick = mclose;
//=================================================
function findPosX(id)
  {
    obj=document.getElementById(id);
	var curleft = 0;
    if(obj.offsetParent)
        while(1)
        {
          curleft += obj.offsetLeft;
          if(!obj.offsetParent)
            break;
          obj = obj.offsetParent;
        }
    else if(obj.x)
        curleft += obj.x;
   PropertyWidth=document.getElementById(id).offsetWidth;
   if(PropertyWidth>curleft)
    {
	 document.getElementById(id).style.left=0;
	}
  }

  function findPosY(obj)
  {
    var curtop = 0;
    if(obj.offsetParent)
        while(1)
        {
          curtop += obj.offsetTop;
          if(!obj.offsetParent)
            break;
          obj = obj.offsetParent;
        }
    else if(obj.y)
        curtop += obj.y;
    return curtop;
  }
</script>

</head>
<body class="bgcolor2">
<dl>
<?php
//DYNAMIC FORM RETREIVAL
include_once("$srcdir/registry.inc");
$reg = getFormsByCategory();
$old_category = '';
$DivId = 1;

// To see if the encounter is locked. If it is, no new forms can be created
$encounterLocked = false;
if ( $esignApi->lockEncounters() &&
isset($GLOBALS['encounter']) &&
!empty($GLOBALS['encounter']) ) {

  $esign = $esignApi->createEncounterESign( $GLOBALS['encounter'] );
  if ( $esign->isLocked() ) {
      $encounterLocked = true;
  }
}
  
if (!empty($reg)) {
  $StringEcho= '<ul id="sddm">';
  if(isset($hide)){
    $StringEcho.= "<li><a id='enc2' >" . htmlspecialchars( xl('Encounter Summary'),ENT_NOQUOTES) . "</a></li>";
  }else{
    $StringEcho.= "<li><a href='JavaScript:void(0);' id='enc2' onclick=\" return top.window.parent.left_nav.loadFrame2('enc2','RBot','patient_file/encounter/encounter_top.php')\">" . htmlspecialchars( xl('Encounter Summary'),ENT_NOQUOTES) . "</a></li>";
  }
  if ( $encounterLocked === false ) {
      foreach ($reg as $entry) {
        $new_category = trim($entry['category']);
        $new_nickname = trim($entry['nickname']);
        if ($new_category == '') {$new_category = 'Miscellaneous';}
        if ($new_nickname != '') {$nickname = $new_nickname;}
        else {$nickname = trim($entry['name']);}
        if ($old_category != $new_category) {
          $new_category_ = $new_category;
          $new_category_ = str_replace(' ','_',$new_category_);
          if ($old_category != '') {$StringEcho.= "</table></div></li>";}
          $StringEcho.= "<li class=\"encounter-form-category-li\"><a href='JavaScript:void(0);' onClick=\"mopen('$DivId');\" >" .
            text(xl_form_title($new_category)) . "</a><div id='$DivId' ><table border='0' cellspacing='0' cellpadding='0'>";
          $old_category = $new_category;
          $DivId++;
        }
        $StringEcho .= "<tr><td style='border-top: 1px solid #000000;padding:0px;'><a onclick=\"openNewForm('" .
          $rootdir . "/patient_file/encounter/load_form.php?formname=" . urlencode($entry['directory']) .
          "', '" . addslashes(xl_form_title($nickname)) . "')\" href='JavaScript:void(0);'>" .
          text(xl_form_title($nickname)) . "</a></td></tr>";
      }
  }
  $StringEcho.= '</table></div></li>';
}
if($StringEcho){
  $StringEcho2= '<div style="clear:both"></div>';
}else{
  $StringEcho2="";
}
?>
<!--<table   style="border:solid 1px black" cellspacing="0" cellpadding="0">
 <tr>
    <td valign="top"><?php //echo $StringEcho; ?></td>
  </tr>
</table>-->
<?php
if ( $encounterLocked === false ) {
      if(!$StringEcho){
        $StringEcho= '<ul id="sddm">';
      }

$fee_sheet_link="<li><a href='#' onclick='gotoFee_sheet()'>".xlt("Fee Sheet")."</a></li>";
if($StringEcho){
  $StringEcho.= $fee_sheet_link."</ul>".$StringEcho2;
}
}
?>
<script>
function gotoFee_sheet() {
  for (var p = window; p && p != p.parent && p.name != 'RTop' && p.name != 'RBot'; p = p.parent);
  var istop = p.window.name == 'RTop';
  p.parent.left_nav.forceSpec(istop, !istop);        
  openNewForm(
    '<?php echo $GLOBALS['webroot'];?>/interface/patient_file/encounter/load_form.php?formname=fee_sheet',
    '<?php echo xls('Fee Sheet'); ?>'
  );
}
</script>
<table cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td valign="top"><?php echo $StringEcho; ?></td>
  </tr>
</table>
</dl>

</body>
</html>
