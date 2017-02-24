<?php
// Copyright (C) 2017 Rod Roark <rod@sunsetsystems.com>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

require_once("../globals.php");
require_once("$srcdir/patient.inc");
require_once("$srcdir/acl.inc");
require_once("$srcdir/formatting.inc.php");
require_once("$srcdir/options.inc.php");

$firsttime = true;

function displayRow($row, $pid='') {
  global $firsttime;

  $bgcolor = '#ffdddd';
  $myscore = '';
  $options = '';

  if (empty($pid)) $pid = $row['pid'];

  if (isset($row['myscore'])) {
    $myscore = $row['myscore'];
    $options = "<option value=''></option>" .
      "<option value='MK'>" . xlt('Merge and Keep') . "</option>" .
      "<option value='MD'>" . xlt('Merge and Discard') . "</option>";
  }
  else {
    $myscore = $row['dupscore'];
    $options = "<option value=''></option>" .
      "<option value='U'>" . xlt('Mark as Unique') . "</option>" .
      "<option value='R'>" . xlt('Recompute Score') . "</option>";
    if (!$firsttime) {
     echo " <tr bgcolor='#dddddd'><td class='detail' colspan='12'>&nbsp;</td></tr>\n";
    }
  }

  $firsttime = false;
  $ptname = $row['lname'] . ', ' . $row['fname'] . ' ' . $row['mname'];
  $phones = array();
  if (trim($row['phone_home'])) $phones[] = trim($row['phone_home']);
  if (trim($row['phone_biz' ])) $phones[] = trim($row['phone_biz' ]);
  if (trim($row['phone_cell'])) $phones[] = trim($row['phone_cell']);
  $phones = implode(', ', $phones);

  $facname = '';
  if ($row['home_facility']) {
    $facrow = getFacility($row['home_facility']);
    if (!empty($facrow['name'])) $facname = $facrow['name'];
  }
?>
 <tr bgcolor='<?php echo $bgcolor ?>'>
  <td class="detail" bgcolor="#dddddd">
   <select onchange='selchange(this, <?php echo "$pid, " . $row['pid']; ?>)' style='width:100%'>
    <?php echo $options; ?>
   </select>
  </td>
  <td class="detail" align="right">
   <?php echo $myscore; ?>
  </td>
  <td class="detail" align="right" onclick="openNewTopWindow(<?php echo $row['pid']; ?>)"
    title="Click to open in a new window or tab" style="color:blue;cursor:pointer">
   <?php echo $row['pid']; ?>
  </td>
  <td class="detail">
   <?php echo text($row['pubpid']); ?>
  </td>
  <td class="detail">
   <?php echo text($ptname); ?>
  </td>
  <td class="detail">
   <?php echo oeFormatShortDate($row['DOB']); ?>
  </td>
  <td class="detail">
   <?php echo text($row['ss']); ?>
  </td>
  <td class="detail">
   <?php echo text($row['email']); ?>
  </td>
  <td class="detail">
   <?php echo text($phones); ?>
  </td>
  <td class="detail">
   <?php echo oeFormatShortDate($row['regdate']); ?>
  </td>
  <td class="detail">
   <?php echo text($facname); ?>
  </td>
  <td class="detail">
   <?php echo text($row['street']); ?>
  </td>
 </tr>
<?php
}

if (!acl_check('acct', 'rep_a')) die(xl("Unauthorized access."));

$scorecalc = getDupScoreSQL();
?>
<html>
<head>
<?php html_header_show();?>
<title><?php echo xlt('Duplicate Patient Management') ?></title>
<link rel='stylesheet' href='<?php echo $css_header ?>' type='text/css'>

<style type="text/css">

 .dehead { color:#000000; font-family:sans-serif; font-size:10pt; font-weight:bold }
 .detail { color:#000000; font-family:sans-serif; font-size:10pt; font-weight:normal }
 .delink { color:#0000cc; font-family:sans-serif; font-size:10pt; font-weight:normal; cursor:pointer }

table.mymaintable, table.mymaintable td {
 border: 1px solid #aaaaaa;
 border-collapse: collapse;
}
table.mymaintable td {
 padding: 1pt 4pt 1pt 4pt;
}

</style>

<script type="text/javascript" src="../../library/textformat.js?v=<?php echo $v_js_includes; ?>"></script>
<script type="text/javascript" src="../../library/topdialog.js?v=<?php echo $v_js_includes; ?>"></script>
<script type="text/javascript" src="../../library/dialog.js?v=<?php echo $v_js_includes; ?>"></script>
<script type="text/javascript" src="../../library/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../../library/js/report_helper.js?v=<?php echo $v_js_includes; ?>"></script>

<script language="JavaScript">

var mypcc = '<?php echo $GLOBALS['phone_country_code'] ?>';

$(document).ready(function() {
  oeFixedHeaderSetup(document.getElementById('mymaintable'));
});

function openNewTopWindow(pid) {
 document.fnew.patientID.value = pid;
 top.restoreSession();
 document.fnew.submit();
}

function selchange(sel, toppid, rowpid) {
  var f = document.forms[0];
  if (sel.value == '') return;
  top.restoreSession();
  if (sel.value == 'MK') {
    window.location = 'merge_patients.php?pid1=' + rowpid + '&pid2=' + toppid;
  }
  else if (sel.value == 'MD') {
    window.location = 'merge_patients.php?pid1=' + toppid + '&pid2=' + rowpid;
  }
  else {
    // Currently 'U' and 'R' actions are supported and rowpid is meaningless.
    f.form_action.value = sel.value;
    f.form_toppid.value = toppid;
    f.form_rowpid.value = rowpid;
    f.submit();
  }
}

</script>

</head>

<body leftmargin='0' topmargin='0' marginwidth='0' marginheight='0' bgcolor="#dddddd">
<center>

<h2><?php echo xlt('Duplicate Patient Management')?></h2>

<form method='post' action='manage_dup_patients.php'>

<table border='0' cellpadding='3'>
 <tr>
  <td align='center'>
   <input type='submit' name='form_refresh' value="<?php echo xla('Refresh') ?>">
   &nbsp;
   <input type='button' value='<?php echo xla('Print'); ?>' onclick='window.print()' />
  </td>
 </tr>
 <tr>
  <td height="1">
  </td>
 </tr>
</table>

<table id='mymaintable' class='mymaintable'>
 <thead>
  <tr bgcolor="#dddddd">
   <td class="dehead">
    <?php echo xlt('Actions'); ?>
   </td>
   <td class="dehead" align="right">
    <?php echo xlt('Score'); ?>
   </td>
   <td class="dehead" align="right">
    <?php echo xlt('Pid'); ?>
   </td>
   <td class="dehead">
    <?php echo xlt('ID'); ?>
   </td>
   <td class="dehead">
    <?php echo xlt('Name'); ?>
   </td>
   <td class="dehead">
    <?php echo xlt('DOB'); ?>
   </td>
   <td class="dehead">
    <?php echo xlt('SSN'); ?>
   </td>
   <td class="dehead">
    <?php echo xlt('Email'); ?>
   </td>
   <td class="dehead">
    <?php echo xlt('Telephone'); ?>
   </td>
   <td class="dehead">
    <?php echo xlt('Registered'); ?>
   </td>
   <td class="dehead">
    <?php echo xlt('Home Facility'); ?>
   </td>
   <td class="dehead">
    <?php echo xlt('Address'); ?>
   </td>
  </tr>
 </thead>
 <tbody>
<?php

if ($_POST['form_action'] == 'U') {
  sqlStatement("UPDATE patient_data SET dupscore = -1 WHERE pid = ?",
    array($_POST['form_toppid']));
}
else if ($_POST['form_action'] == 'R') {
  updateDupScore($_POST['form_toppid']);
}

$query = "SELECT * FROM patient_data WHERE dupscore > 7 " .
  "ORDER BY dupscore DESC, pid DESC LIMIT 100";
$res1 = sqlStatement($query);
while ($row1 = sqlFetchArray($res1)) {
  displayRow($row1);
  $query = "SELECT p2.*, ($scorecalc) AS myscore " .
    "FROM patient_data AS p1, patient_data AS p2 WHERE " .
    "p1.pid = ? AND p2.pid < p1.pid AND ($scorecalc) > 7 " .
    "ORDER BY myscore DESC, p2.pid DESC";
  $res2 = sqlStatement($query, array($row1['pid']));
  while ($row2 = sqlFetchArray($res2)) {
    displayRow($row2, $row1['pid']);
  }
}
?>
</tbody>
</table>
<input type='hidden' name='form_action' value='' />
<input type='hidden' name='form_toppid' value='0' />
<input type='hidden' name='form_rowpid' value='0' />
</form>
</center>

<!-- form used to open a new top level window when a patient row is clicked -->
<form name='fnew' method='post' target='_blank'
 action='../main/main_screen.php?auth=login&site=<?php echo attr($_SESSION['site_id']); ?>'>
<input type='hidden' name='patientID' value='0' />
</form>

</body>
</html>
