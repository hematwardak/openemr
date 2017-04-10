<?php
// Copyright (C) 2017 Rod Roark <rod@sunsetsystems.com>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// This is a dump of sales, payments and adjustments by line item.

require_once("../globals.php");
require_once("$srcdir/patient.inc");
require_once("$srcdir/sql-ledger.inc");
require_once("$srcdir/acl.inc");
require_once("$srcdir/formatting.inc.php");
require_once("$srcdir/options.inc.php");
require_once("../../custom/code_types.inc.php");

// For each sorting option, specify the ORDER BY argument.
$ORDERHASH = array(
  'item'    => 'itemcode, svcdate, invoiceno, pid, encounter',
  'svcdate' => 'svcdate, invoiceno, itemcode, pid, encounter',
  'paydate' => 'paydate, svcdate, invoiceno, itemcode, pid, encounter',
  'invoice' => 'invoiceno, svcdate, itemcode, pid, encounter',
  'payor'   => 'payor, svcdate, invoiceno, itemcode, pid, encounter',
  'project' => 'proj_name, svcdate, invoiceno, itemcode, pid, encounter',
);

function bucks($amount) {
  if ($amount) echo oeFormatMoney($amount);
}

function display_desc($desc) {
  if (preg_match('/^\S*?:(.+)$/', $desc, $matches)) {
    $desc = $matches[1];
  }
  return $desc;
}

// Initialize the $aItems entry for this line item if it does not yet exist.
function ensureItems($invno, $codekey) {
  global $aItems, $aTaxNames;
  if (!isset($aItems[$invno][$codekey])) {
    // Charges, Adjustments, Payments
    $aItems[$invno][$codekey] = array(0, 0, 0);
    // Then a cell for each tax type.
    for ($i = 0; $i < count($aTaxNames); ++$i) {
      $aItems[$invno][$codekey][3 + $i] = 0;
    }
  }
}

// Get taxes matching this line item and store them in their proper $aItems array slots.
function getItemTaxes($patient_id, $encounter_id, $codekey, $id) {
  global $aItems, $aTaxNames;
  $invno = "$patient_id.$encounter_id";
  $total = 0;
  $taxres = sqlStatement("SELECT code, fee FROM billing WHERE " .
    "pid = '$patient_id' AND encounter = '$encounter_id' AND " .
    "code_type = 'TAX' AND activity = 1 AND ndc_info = '$id' " .
    "ORDER BY id");
  while ($taxrow = sqlFetchArray($taxres)) {
    $i = 0;
    $matchcount = 0;
    foreach ($aTaxNames as $tmpcode => $dummy) {
      if ($tmpcode == $taxrow['code']) {
        ++$matchcount;
        $aItems[$invno][$codekey][3 + $i] += $taxrow['fee'];
      }
      if ($matchcount != 1) {
        // TBD: This is an error.
        echo "ERROR: invno = '$invno' codekey = '$codekey' matchcount = '$matchcount'\n";
      }
      ++$i;
    }
    $total += $taxrow['fee'];
  }
  return $total;
}

// For a given encounter, this gets all charges and taxes and allocates payments
// and adjustments among them, if that has not already been done.
// Any invoice-level adjustments and payments are allocated among the line
// items in proportion to their line-level remaining balances.
//
function ensureLineAmounts($patient_id, $encounter_id) {
  global $aItems, $overpayments, $aTaxNames;

  $invno = "$patient_id.$encounter_id";
  if (isset($aItems[$invno])) return $invno;

  $adjusts = 0;  // sum of invoice level adjustments
  $payments = 0; // sum of invoice level payments
  $denom = 0;    // sum of adjusted line item charges
  $aItems[$invno] = array();

  // Get charges and copays from billing table and associated taxes.
  $tres = sqlStatement("SELECT b.code_type, b.code, b.fee, b.id " .
    "FROM billing AS b WHERE " .
    "b.pid = '$patient_id' AND b.encounter = '$encounter_id' AND b.activity = 1 AND " .
    "b.fee != 0 AND (b.code_type != 'TAX' OR b.ndc_info = '')");
  while ($trow = sqlFetchArray($tres)) {
    if ($trow['code_type'] == 'COPAY') {
      $payments -= $trow['fee'];
    }
    else {
      $codekey = $trow['code_type'] . ':' . $trow['code'];
      ensureItems($invno, $codekey);
      $aItems[$invno][$codekey][0] += $trow['fee'];
      $denom += $trow['fee'];
      $denom += getItemTaxes($patient_id, $encounter_id, $codekey, 'S:' . $trow['id']);
    }
  }

  // Get charges from drug_sales table and associated taxes.
  $tres = sqlStatement("SELECT s.drug_id, s.fee, s.sale_id " .
    "FROM drug_sales AS s WHERE " .
    "s.pid = '$patient_id' AND s.encounter = '$encounter_id' AND s.fee != 0");
  while ($trow = sqlFetchArray($tres)) {
    $codekey = 'PROD:' . $trow['drug_id'];
    ensureItems($invno, $codekey);
    $aItems[$invno][$codekey][0] += $trow['fee'];
    $denom += $trow['fee'];
    $denom += getItemTaxes($patient_id, $encounter_id, $codekey, 'P:' . $trow['sale_id']);
  }

  // Get adjustments and other payments from ar_activity table.
  $tres = sqlStatement("SELECT " .
    "a.code_type, a.code, a.adj_amount, a.pay_amount " .
    "FROM ar_activity AS a WHERE " .
    "a.pid = '$patient_id' AND a.encounter = '$encounter_id' AND a.deleted IS NULL");
  while ($trow = sqlFetchArray($tres)) {
    $codekey = $trow['code_type'] . ':' . $trow['code'];
    if (isset($aItems[$invno][$codekey])) {
      $aItems[$invno][$codekey][1] += $trow['adj_amount'];
      $aItems[$invno][$codekey][2] += $trow['pay_amount'];
      $denom -= $trow['adj_amount'];
      $denom -= $trow['pay_amount'];
    }
    else {
      $adjusts  += $trow['adj_amount'];
      $payments += $trow['pay_amount'];
    }
  }

  // Allocate all unmatched payments and adjustments among the line items.
  $adjrem = $adjusts;  // remaining unallocated adjustments
  $payrem = $payments; // remaining unallocated payments
  $nlines = count($aItems[$invno]);
  foreach ($aItems[$invno] AS $codekey => $dummy) {
    if (--$nlines > 0) {
      // Avoid dividing by zero!
      if ($denom) {
        $bal = $aItems[$invno][$codekey][0] - $aItems[$invno][$codekey][1] - $aItems[$invno][$codekey][2];
        for ($i = 0; $i < count($aTaxNames); ++$i) $bal += $aItems[$invno][$codekey][3 + $i];
        $factor = $bal / $denom;
        $tmp = sprintf('%01.2f', $adjusts * $factor);
        $aItems[$invno][$codekey][1] += $tmp;
        $adjrem -= $tmp;
        $tmp = sprintf('%01.2f', $payments * $factor);
        $aItems[$invno][$codekey][2] += $tmp;
        $payrem -= $tmp;
        // echo "<!-- invno = '$invno' codekey = '$codekey' denom = '$denom' bal='$bal' payments='$payments' tmp = '$tmp' -->\n"; // debugging
      }
    }
    else {
      // Last line gets what's left to avoid rounding errors.
      $aItems[$invno][$codekey][1] += $adjrem;
      $aItems[$invno][$codekey][2] += $payrem;
      // echo "<!-- invno = '$invno' codekey = '$codekey' payrem = '$payrem' -->\n"; // debugging
    }
  }

  // For each line item having (payment > charge + tax - adjustment), move the
  // overpayment amount to a global variable $overpayments.
  foreach ($aItems[$invno] AS $codekey => $dummy) {
    $diff = $aItems[$invno][$codekey][2] + $aItems[$invno][$codekey][1] - $aItems[$invno][$codekey][0];
    for ($i = 0; $i < count($aTaxNames); ++$i) $diff -= $aItems[$invno][$codekey][3 + $i];
    $diff = sprintf('%01.2f', $diff);
    if ($diff > 0.00) {
      $overpayments += $diff;
      $aItems[$invno][$codekey][2] -= $diff;
    }
  }

  return $invno;
}

$previous_invno = array();

function thisLineItem($patient_id, $encounter_id, $code_type, $code,
  $description, $svcdate, $paydate, $qty, $amount, $irnumber='',
  $payor, $sitecode, $project)
{
  global $aItems, $aTaxNames, $overpayments, $previous_invno;

  if (empty($qty)) $qty = 1;
  $invnumber = $irnumber ? $irnumber : "$patient_id.$encounter_id";
  $rowamount = sprintf('%01.2f', $amount);

  $disp_code = $code;
  if ($code_type == 'PROD') {
    $disp_code = $description;
    $description = '';
  }

  $tmp = $overpayments;
  $invno = ensureLineAmounts($patient_id, $encounter_id);
  $overpaid = $overpayments == $tmp ? '' : '* ';

  $codekey = $code_type . ':' . $code;
  $rowadj = $aItems[$invno][$codekey][1];
  $rowpay = $aItems[$invno][$codekey][2];
  $memo = "OpenEMR Inv " . $invnumber;

  // Compute Discount Rate which is the negative sum of adjustments for the invoice.
  // Do this only for the first item of each invoice.
  $discount_rate = 0.00;
  if (!isset($previous_invno[$invno])) {
    $previous_invno[$invno] = true;
    foreach ($aItems[$invno] AS $tmpcodekey => $dummy) {
      $discount_rate -= $aItems[$invno][$tmpcodekey][1];
      // $memo .= " $tmpcodekey:" . $aItems[$invno][$tmpcodekey][1]; // debugging
    }
  }
  $discount_item = $discount_rate == 0.00 ? '' : xl('Discount Item');

  if ($_POST['form_csvexport']) {
    echo '"' . oeFormatShortDate(display_desc($svcdate)) . '",';
    echo '"' . oeFormatShortDate(display_desc($paydate)) . '",';
    echo '"' . display_desc($invnumber) . '",';
    echo '"' . display_desc($disp_code) . '",';
    echo '"' . display_desc($description) . '",';
    echo '"' . display_desc($qty      ) . '",';
    // echo '"'; bucks($rowamount); echo '",';
    echo '"'; bucks($amount / $qty); echo '",';
    echo '"' . display_desc($discount_item) . '",';
    echo '"'; bucks($discount_rate);    echo '",';
    echo '"'; bucks($rowadj);    echo '",';
    // for ($i = 0; $i < count($aTaxNames); ++$i) {
    //   echo '"'; bucks($aItems[$invno][$codekey][3 + $i]); echo '",';
    // }
    echo '"'; bucks($rowpay);    echo '",';
    echo '"' . display_desc($payor) . '",';
    echo '"' . display_desc($memo) . '",';
    echo '"",'; // Program Strategy
    echo '"' . display_desc($sitecode) . '",';
    echo '"",'; // Fund
    echo '"' . display_desc($project) . '",';
    echo '"",'; // Budget Activity
    echo '"",'; // Department
    echo "\n";
  }
  else {
?>

 <tr>
  <td class="detail">
   <?php echo oeFormatShortDate($svcdate); ?>
  </td>
  <td class="detail">
   <?php echo oeFormatShortDate($paydate); ?>
  </td>
  <td class='delink' onclick='doinvopen(<?php echo "$patient_id,$encounter_id"; ?>)'>
   <?php echo $invnumber; ?>
  </td>
  <td class="detail">
   <?php echo display_desc($disp_code); ?>
  </td>
  <td class="detail">
   <?php echo display_desc($description); ?>
  </td>
  <td class="detail" align="right">
   <?php echo $qty; ?>
  </td>
  <!--
  <td class="detail" align="right">
   <?php bucks($rowamount); ?>
  </td>
  -->
  <td class="detail" align="right">
   <?php echo $overpaid; bucks($amount / $qty); ?>
  </td>
  <td class="detail">
   <?php echo display_desc($discount_item); ?>
  </td>
  <td class="detail" align="right">
   <?php bucks($discount_rate); ?>
  </td>
  <td class="detail" align="right">
   <?php bucks($rowadj); ?>
  </td>
<?php
  //    for ($i = 0; $i < count($aTaxNames); ++$i) {
  //      echo "  <td class='detail' align='right'>\n";
  //      echo "   "; bucks($aItems[$invno][$codekey][3 + $i]); echo "\n";
  //      echo "  </td>\n";
  //    }
?>
  <td class="detail" align="right">
   <?php echo $overpaid; bucks($rowpay); ?>
  </td>
  <td class="detail">
   <?php echo display_desc($payor); ?>
  </td>
  <td class="detail">
   <?php echo display_desc($memo); ?>
  </td>
  <td class="detail">
   &nbsp;
  </td>
  <td class="detail">
   <?php echo display_desc($sitecode); ?>
  </td>
  <td class="detail">
   &nbsp;
  </td>
  <td class="detail">
   <?php echo display_desc($project); ?>
  </td>
  <td class="detail">
   &nbsp;
  </td>
  <td class="detail">
   &nbsp;
  </td>
 </tr>
<?php
  } // End not csv export

  // Clear out this line item's numbers in case the same code appears again.
  for ($i = 1; $i < count($aItems[$invno][$codekey]); ++$i) {
    $aItems[$invno][$codekey][$i] = 0;
  }
} // end function thisLineItem

// Get the adjustment type, if any, associated with a service or product sale.
// Invoice-level adjustments are considered to match all items in the invoice.
//
function get_adjustment_type($patient_id, $encounter_id, $code_type, $code) {
  $adjreason = '';
  $row = sqlQuery("SELECT a.memo FROM ar_activity AS a " .
    "JOIN list_options AS lo ON lo.list_id = 'adjreason' AND lo.option_id = a.memo AND lo.notes LIKE '%=Ins%' AND lo.activity = 1 " .
    "WHERE " .
    "a.pid = '$patient_id' AND a.encounter = '$encounter_id' AND a.deleted IS NULL AND " .
    "(a.code_type = '' OR (a.code_type = '$code_type' AND a.code = '$code')) AND " .
    "(a.adj_amount != 0.00 OR a.pay_amount = 0.00) AND a.memo != '' " .
    "ORDER BY a.code DESC, a.adj_amount DESC LIMIT 1");
  if (isset($row['memo'])) $adjreason = $row['memo'];
  return $adjreason;
}

if (!acl_check('acct', 'rep_a')) die(xl("Unauthorized access."));

$form_from_date = fixDate($_POST['form_from_date'], date('Y-m-01'));
$form_to_date   = fixDate($_POST['form_to_date']  , date('Y-m-d'));
$form_facility  = isset($_POST['form_facility']) ? $_POST['form_facility'] : '';
$form_payor     = isset($_POST['form_payor']) ? $_POST['form_payor'] : '';

$form_orderby = $ORDERHASH[$_REQUEST['form_orderby']] ? $_REQUEST['form_orderby'] : 'svcdate';
$orderby = $ORDERHASH[$form_orderby];

// Get the tax types applicable to this report's date range.
$aTaxNames = array();
$tnres = sqlStatement("SELECT DISTINCT b.code, b.code_text " .
  "FROM billing AS b " .
  "JOIN form_encounter AS fe ON fe.pid = b.pid AND fe.encounter = b.encounter " .
  "WHERE " .
  "b.code_type = 'TAX' AND b.activity = '1' AND " .
  "fe.date >= '$form_from_date 00:00:00' AND fe.date <= '$form_to_date 23:59:59' " .
  "ORDER BY b.code, b.code_text");
while ($tnrow = sqlFetchArray($tnres)) {
  $aTaxNames[$tnrow['code']] = $tnrow['code_text'];
}

if ($_POST['form_csvexport']) {
  header("Pragma: public");
  header("Expires: 0");
  header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
  header("Content-Type: application/force-download; charset=utf-8");
  header("Content-Disposition: attachment; filename=netsuite_export.csv");
  header("Content-Description: File Transfer");
  // Prepend a BOM (Byte Order Mark) header to mark the data as UTF-8.  This is
  // said to work for Excel 2007 pl3 and up and perhaps also Excel 2003 pl3.  See:
  // http://stackoverflow.com/questions/155097/microsoft-excel-mangles-diacritics-in-csv-files
  // http://crashcoursing.blogspot.com/2011/05/exporting-csv-with-special-characters.html
  echo "\xEF\xBB\xBF";
  // CSV headers:
  echo '"' . xl('Service Date'    ) . '",';
  echo '"' . xl('Payment Date'    ) . '",';
  echo '"' . xl('Invoice'         ) . '",';
  echo '"' . xl('Item'            ) . '",';
  echo '"' . xl('Description'     ) . '",';
  echo '"' . xl('Qty'             ) . '",';
  // echo '"' . xl('Price'           ) . '",';
  echo '"' . xl('Each'            ) . '",';
  echo '"' . xl('Discount Item'   ) . '",';
  echo '"' . xl('Discount Rate'   ) . '",';
  echo '"' . xl('Adj'             ) . '",';
  // foreach ($aTaxNames as $taxname) {
  //   echo '"' . addslashes($taxname) . '",';
  // }
  echo '"' . xl('Payment'         ) . '",';
  echo '"' . xl('Payor'           ) . '",';
  echo '"' . xl('Memo'            ) . '",';
  echo '"' . xl('Program Strategy') . '",';
  echo '"' . xl('Site'            ) . '",';
  echo '"' . xl('Fund'            ) . '",';
  echo '"' . xl('Project'         ) . '",';
  echo '"' . xl('Budget Activity' ) . '",';
  echo '"' . xl('Department'      ) . '"';
  echo "\n";
} // end export
else {
?>
<html>
<head>
<?php html_header_show();?>
<title><?php echo xlt('NetSuite Export') ?></title>
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

<?php // require($GLOBALS['srcdir'] . "/restoreSession.php"); ?>

var mypcc = '<?php echo $GLOBALS['phone_country_code'] ?>';

function dosort(orderby) {
 var f = document.forms[0];
 f.form_orderby.value = orderby;
 top.restoreSession();
 f.submit();
 return false;
}

// Process click to pop up the add/edit window.
function doinvopen(ptid,encid) {
 dlgopen('../patient_file/pos_checkout.php?ptid=' + ptid + '&enc=' + encid, '_blank', 750, 550);
}

$(document).ready(function() {
  oeFixedHeaderSetup(document.getElementById('mymaintable'));
});

</script>

</head>

<body leftmargin='0' topmargin='0' marginwidth='0' marginheight='0'>
<center>

<h2><?php echo xlt('NetSuite Export')?></h2>

<form method='post' action='netsuite_export.php'>

<table border='0' cellpadding='3'>

 <tr>
  <td align='center'>
<?php

// Build a drop-down for payor type.
echo "   <select name='form_payor'>\n";
echo "    <option value=''"  . ($form_payor == ''  ? ' selected' : '') . ">-- " . xl('All Payors') . " --\n";
echo "    <option value='c'" . ($form_payor == 'c' ? ' selected' : '') . ">"    . xl('Cash'   ) . "\n";
echo "    <option value='i'" . ($form_payor == 'i' ? ' selected' : '') . ">"    . xl('Insurer') . "\n";
echo "   </select>&nbsp;\n";

// Build a drop-down list of facilities.
//
$query = "SELECT id, name FROM facility ORDER BY name";
$fres = sqlStatement($query);
echo "   <select name='form_facility'>\n";
echo "    <option value=''>-- " . xl('All Facilities') . " --\n";
while ($frow = sqlFetchArray($fres)) {
  $facid = $frow['id'];
  echo "    <option value='$facid'";
  if ($facid == $form_facility) echo " selected";
  echo ">" . $frow['name'] . "\n";
}
echo "   </select>\n";
?>
  &nbsp;
   <?php echo xlt('From'); ?>:
   <input type='text' name='form_from_date' id="form_from_date" size='10' value='<?php echo $form_from_date ?>'
    onkeyup='datekeyup(this,mypcc)' onblur='dateblur(this,mypcc)' title='yyyy-mm-dd'>
   <img src='../pic/show_calendar.gif' align='absbottom' width='24' height='22'
    id='img_from_date' border='0' alt='[?]' style='cursor:pointer'
    title='<?php echo xlt('Click here to choose a date'); ?>'>
   &nbsp;<?php echo xlt('To'); ?>:
   <input type='text' name='form_to_date' id="form_to_date" size='10' value='<?php echo $form_to_date ?>'
    onkeyup='datekeyup(this,mypcc)' onblur='dateblur(this,mypcc)' title='yyyy-mm-dd'>
   <img src='../pic/show_calendar.gif' align='absbottom' width='24' height='22'
    id='img_to_date' border='0' alt='[?]' style='cursor:pointer'
    title='<?php echo xlt('Click here to choose a date'); ?>'>
   &nbsp;
   <input type='submit' name='form_refresh' value="<?php echo xlt('Refresh') ?>">
   &nbsp;
   <input type='submit' name='form_csvexport' value="<?php echo xlt('Export to CSV') ?>">
   &nbsp;
   <input type='button' value='<?php echo xlt('Print'); ?>' onclick='window.print()' />
  </td>
 </tr>

 <tr>
  <td height="1">
  </td>
 </tr>

</table>

<table width='98%' id='mymaintable' class='mymaintable'>
 <thead>
 <tr bgcolor="#dddddd">
  <td class="dehead">
   <a href="#" onclick="return dosort('svcdate')"
   <?php if ($form_orderby == "svcdate") echo " style=\"color:#00cc00\""; ?>
   ><?php echo xlt('Service Date'); ?></a>
  </td>
  <td class="dehead">
   <a href="#" onclick="return dosort('paydate')"
   <?php if ($form_orderby == "paydate") echo " style=\"color:#00cc00\""; ?>
   ><?php echo xlt('Payment Date'); ?></a>
  </td>
  <td class="dehead">
   <a href="#" onclick="return dosort('invoice')"
   <?php if ($form_orderby == "invoice") echo " style=\"color:#00cc00\""; ?>
   ><?php echo xlt('Invoice'); ?></a>
  </td>
  <td class="dehead">
   <a href="#" onclick="return dosort('item')"
   <?php if ($form_orderby == "item") echo " style=\"color:#00cc00\""; ?>
   ><?php echo xlt('Item'); ?></a>
  </td>
  <td class="dehead">
   <?php echo xlt('Description'); ?>
  </td>
  <td class="dehead" align="right">
   <?php echo xlt('Qty'); ?>
  </td>
  <!--
  <td class="dehead" align="right">
   <?php echo xlt('Price'); ?>
  </td>
  -->
  <td class="dehead" align="right">
   <?php echo xlt('Each'); ?>
  </td>
  <td class="dehead">
   <?php echo xlt('Discount Item'); ?>
  </td>
  <td class="dehead" align="right">
   <?php echo xlt('Discount Rate'); ?>
  </td>
  <td class="dehead" align="right">
   <?php echo xlt('Adj'); ?>
  </td>
<?php
  // foreach ($aTaxNames as $taxname) {
  //   echo "  <td class='dehead' align='right'>\n";
  //   echo "   " . htmlspecialchars($taxname) . "\n";
  //   echo "  </td>\n";
  // }
?>
  <td class="dehead" align="right">
   <?php echo xlt('Payment'); ?>
  </td>
  <td class="dehead">
   <a href="#" onclick="return dosort('payor')"
   <?php if ($form_orderby == "payor") echo " style=\"color:#00cc00\""; ?>
   ><?php echo xlt('Payor'); ?></a>
  </td>
  <td class="dehead">
   <?php echo xlt('Memo'); ?>
  </td>
  <td class="dehead">
   <?php echo xlt('Program Strategy'); ?>
  </td>
  <td class="dehead">
   <?php echo xlt('Site'); ?>
  </td>
  <td class="dehead">
   <?php echo xlt('Fund'); ?>
  </td>
  <td class="dehead">
   <a href="#" onclick="return dosort('project')"
   <?php if ($form_orderby == "project") echo " style=\"color:#00cc00\""; ?>
   ><?php echo xlt('Project'); ?></a>
  </td>
  <td class="dehead">
   <?php echo xlt('Budget Activity'); ?>
  </td>
  <td class="dehead">
   <?php echo xlt('Department'); ?>
  </td>
 </tr>
 </thead>
 <tbody>
<?php
} // end not export

if ($_POST['form_orderby']) {
  $from_date = $form_from_date;
  $to_date   = $form_to_date;
  $overpayments = 0;
  $aItems = array();
  $projcodelen = 10; // Length of PROJ codes

  // If a facility was specified.
  $factest = $form_facility ? "AND fe.facility_id = '$form_facility'" : "";

  $query = "( " .
    "SELECT " .
    "b.pid, b.encounter, b.code_type, b.code AS itemcode, b.code_text AS description, b.units, b.fee, " .
    "b.bill_date AS paydate, fe.date AS svcdate, f.facility_npi, fe.invoice_refno AS invoiceno, " .
    "pd.userlist4 AS payor, cp.code_text AS proj_name " .
    "FROM billing AS b " .
    "JOIN form_encounter AS fe ON fe.pid = b.pid AND fe.encounter = b.encounter AND " .
    "fe.date >= ? AND fe.date <= ? $factest " .
    "JOIN patient_data AS pd ON pd.pid = fe.pid " .
    "JOIN code_types AS ct ON ct.ct_key = b.code_type " .
    "LEFT JOIN facility AS f ON f.id = fe.facility_id " .
    "LEFT JOIN codes AS c ON c.code_type = ct.ct_id AND c.code = b.code AND c.modifier = b.modifier " .
    "LEFT JOIN codes AS cp ON cp.code_type = ? AND c.related_code LIKE '%PROJ:%' AND " .
    "cp.code = SUBSTR(c.related_code, LOCATE('PROJ:', c.related_code) + 5, $projcodelen) " .
    "WHERE b.code_type != 'COPAY' AND b.activity = 1 AND b.fee != 0 AND " .
    "(b.code_type != 'TAX' OR b.ndc_info = '') " . // why the ndc_info test?
    ") UNION ALL ( " .
    "SELECT " .
    "s.pid, s.encounter, 'PROD' AS code_type, s.drug_id AS itemcode, d.name AS description, " .
    "s.quantity AS units, s.fee, " .
    "s.bill_date AS paydate, fe.date AS svcdate, f.facility_npi, fe.invoice_refno AS invoiceno, " .
    "pd.userlist4 AS payor, cp.code_text AS proj_name " .
    "FROM drug_sales AS s " .
    "JOIN form_encounter AS fe ON fe.pid = s.pid AND fe.encounter = s.encounter AND " .
    "fe.date >= ? AND fe.date <= ? $factest " .
    "JOIN patient_data AS pd ON pd.pid = fe.pid " .
    "LEFT JOIN facility AS f ON f.id = fe.facility_id " .
    "LEFT JOIN drugs AS d ON d.drug_id = s.drug_id " .
    "LEFT JOIN codes AS cp ON cp.code_type = ? AND d.related_code LIKE '%PROJ:%' AND " .
    "cp.code = SUBSTR(d.related_code, LOCATE('PROJ:', d.related_code) + 5, $projcodelen) " .
    "WHERE s.fee != 0 " .
    ") ORDER BY $orderby";

  $dt1 = "$from_date 00:00:00";
  $dt2 = "$to_date 23:59:59";
  $tmp = empty($code_types['PROJ']) ? 0 : $code_types['PROJ']['id'];

  // if (! $_POST['form_csvexport']) echo "<!-- $query\n $dt1 $dt2 $tmp -->\n"; // debugging

  $res = sqlStatement($query, array($dt1, $dt2, $tmp, $dt1, $dt2, $tmp));

  while ($row = sqlFetchArray($res)) {
    // Determine if this is an insurance adjustment type.
    // Set payor and apply form_payor filter accordingly.
    $payor = 'CASH';
    if (get_adjustment_type($row['pid'], $row['encounter'], $row['code_type'], $row['itemcode'])) {
      $payor = $row['payor'];
    }
    if ($form_payor == 'c' && $payor != 'CASH') continue;
    if ($form_payor == 'i' && $payor == 'CASH') continue;

    thisLineItem($row['pid'], $row['encounter'], $row['code_type'], $row['itemcode'],
      $row['description'], substr($row['svcdate'], 0, 10), substr($row['paydate'], 0, 10),
      $row['units'], $row['fee'], $row['invoiceno'],
      $payor, $row['facility_npi'], $row['proj_name']);
  }

} // end refresh or export

if (! $_POST['form_csvexport']) {
?>

</tbody>
</table>
<input type="hidden" name="form_orderby" value="<?php echo $form_orderby ?>" />
</form>
</center>
</body>

<!-- stuff for the popup calendar -->
<style type="text/css">@import url(../../library/dynarch_calendar.css);</style>
<script type="text/javascript" src="../../library/dynarch_calendar.js"></script>
<script type="text/javascript" src="../../library/dynarch_calendar_en.js"></script>
<script type="text/javascript" src="../../library/dynarch_calendar_setup.js"></script>
<script language="Javascript">
 Calendar.setup({inputField:"form_from_date", ifFormat:"%Y-%m-%d", button:"img_from_date"});
 Calendar.setup({inputField:"form_to_date", ifFormat:"%Y-%m-%d", button:"img_to_date"});
</script>

</html>
<?php
} // End not csv export
?>