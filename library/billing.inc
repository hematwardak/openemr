<?php

// require_once("{$GLOBALS['srcdir']}/sql.inc");
require_once(dirname(__FILE__) . "/sql.inc");

function getBillingById ($id, $cols = "*")
{
    return sqlQuery("select $cols from billing where id='$id' and activity=1 order by date DESC limit 0,1");
}

function getBillingByPid ($pid, $cols = "*")
{
    return  sqlQuery("select $cols from billing where pid ='$pid' and activity=1 order by date DESC limit 0,1");
}

function getBillingByEncounter ($pid,$encounter, $cols = "code_type, code, code_text")
{
    $res = sqlStatement("select $cols from billing where encounter = ? and pid=? and activity=1 order by code_type, date ASC", array($encounter,$pid) );

    $all=array();
    for($iter=0; $row=sqlFetchArray($res); $iter++)
    {
        $all[$iter] = $row;
    }
    return $all;
}

function addBilling($encounter_id, $code_type, $code, $code_text, $pid,
  $authorized="0", $provider, $modifier="", $units="", $fee="0.00",
  $ndc_info='', $justify='', $billed=0, $notecodes='', $pricelevel='')
{
  $sql = "insert into billing (date, encounter, code_type, code, code_text, " .
    "pid, authorized, user, groupname, activity, billed, provider_id, " .
    "modifier, units, fee, ndc_info, justify, notecodes, pricelevel) values (" .
    "NOW(), ?, ?, ?, ?, ?, ?, ?, ?, 1, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
  return sqlInsert($sql, array($encounter_id,$code_type,$code,$code_text,$pid,$authorized,
    $_SESSION['authId'],$_SESSION['authProvider'],$billed,$provider,$modifier,$units,$fee,
    $ndc_info,$justify,$notecodes,$pricelevel));
}

function authorizeBilling($id, $authorized = "1")
{
    sqlQuery("update billing set authorized = '$authorized' where id = '$id'");
}

function deleteBilling($id)
{
    sqlStatement("update billing set activity = 0 where id = '$id'");
}

function clearBilling($id)
{
    sqlStatement("update billing set justify = '' where id = '$id'");
}

// This function supports the Billing page (billing_process.php), freeb
// processing (process_bills.php), and initiation of secondary processing
// (sl_eob.inc.php).  It is called in the following situations:
//
// * billing_process.php sets bill_time, bill_process, payer and target on
//   queueing a claim for freeb processing.  Create claims row.
// * billing_process.php sets claim status to 2, and payer, on marking a
//   claim as billed without actually generating any billing.  Create a
//   claims row.  In this case bill_process will remain at 0 and process_time
//   and process_file will not be set.
// * billing_process.php sets bill_process, payer, target and x12 partner
//   before calling gen_x12_837.  Create a claims row.
// * billing_process.php sets claim status to 2 (billed), bill_process to 2,
//   process_time and process_file after calling gen_x12_837.  Claims row
//   already exists.
// * process_bills.php sets bill_process to 2, process_time, and process_file
//   after invoking freeb to process a claim.  Claims row already exists.
// * billing_process.php sets claim status to 2 (billed) after creating
//   an electronic freeb batch (hcfa-only with recent changes).  Claims
//   row already exists.
// * EOB posting updates claim status to mark a payer as done.  Claims row
//   already exists.
// * EOB posting reopens an encounter for billing a secondary payer.  Create
//   a claims row.
//
// $newversion should be passed to us to indicate if a new claims row
// is to be generated, otherwise one must already exist.  The payer, if
// passed in for the latter case, must match the existing claim.
//
// Currently on the billing page the user can select any of the patient's
// payers.  That logic will tailor the payer choices to the encounter date.
//
function updateClaim($newversion, $patient_id, $encounter_id, $payer_id=-1, $payer_type=-1,
  $status=-1, $bill_process=-1, $process_file='', $target='', $partner_id=-1,$crossover=0)
{
  if (!$newversion) {
        $sql = "SELECT * FROM claims WHERE patient_id = ? AND " .
        "encounter_id = ? AND status > 0 AND status < 4 ";
        array_push($sqlBindArray, $patient_id, $encounter_id);
        if ($payer_id >= 0) {
            $sql .= "AND payer_id = ? ";
            $sqlBindArray[] = $payer_id;
        }
        $sql .= "ORDER BY version DESC LIMIT 1";
        $row = sqlQuery($sql, $sqlBindArray);

    if (!$row) return 0;
    if ($payer_id     < 0) $payer_id     = $row['payer_id'];
    if ($status       < 0) $status       = $row['status'];
    if ($bill_process < 0) $bill_process = $row['bill_process'];
    if ($partner_id   < 0) $partner_id   = $row['x12_partner_id'];
    if (!$process_file   ) $process_file = $row['process_file'];
    if (!$target         ) $target       = $row['target'];
  }

    $claimset = "";
    $sqlBindClaimset = array();
    $billset = "";
    $sqlBindBillset = array();
    if (empty($payer_id) || $payer_id < 0) {
        $payer_id = 0;
    }
     if ($status==7) {//$status==7 is the claim denial case.
        $claimset .= ", status = ?";
        $sqlBindClaimset[] = $status;
    } elseif ($status >= 0) {
        $claimset .= ", status = ?";
        $sqlBindClaimset[] = $status;
        if ($status > 1) {
          $billset .= ", billed = 1";
          if ($status == 2) $billset  .= ", bill_date = NOW()";
        } else {
          $billset .= ", billed = 0";
        }
    }

    if ($status==7) {//$status==7 is the claim denial case.
        $billset  .= ", bill_process = ?";
        $sqlBindBillset[] = $status;
    } elseif ($bill_process >= 0) {
        $claimset .= ", bill_process = ?";
        $sqlBindClaimset[] = $bill_process;
        $billset  .= ", bill_process = ?";
        $sqlBindBillset[] = $bill_process;
    }
    if ($status==7) {//$status==7 is the claim denial case.
        $claimset  .= ", process_file = ?";//Denial reason code is stored here
        $sqlBindClaimset[] = $process_file;
    } elseif ($process_file) {
        $claimset .= ", process_file = ?, process_time = NOW()";
        $sqlBindClaimset[] = $process_file;
        $billset  .= ", process_file = ?, process_date = NOW()";
        $sqlBindBillset[] = $process_file;
    }
    if ($target) {
        $claimset .= ", target = ?";
        $sqlBindClaimset[] = $target;
        $billset  .= ", target = ?";
        $sqlBindBillset[] = $target;
    }
    if ($payer_id >= 0) {
        $claimset .= ", payer_id = ?, payer_type = ?";
        $sqlBindClaimset[] = $payer_id;
        $sqlBindClaimset[] = $payer_type;
        $billset  .= ", payer_id = ?";
        $sqlBindBillset[] = $payer_id;
    }
    if ($partner_id >= 0) {
        $claimset .= ", x12_partner_id = ?";
        $sqlBindClaimset[] = $partner_id;
        $billset  .= ", x12_partner_id = ?";
        $sqlBindBillset[] = $partner_id;
    }
    if ($billset) {
        $billset = substr($billset, 2);
        $sqlBindArray = $sqlBindBillset;
        array_push($sqlBindArray, $encounter_id, $patient_id);
        sqlStatement("UPDATE billing SET $billset WHERE " .
        "encounter = ? AND pid= ? AND activity = 1", $sqlBindArray);
    }

  // If a new claim version is requested, insert its row.
  //
  if ($newversion) {
    /****
    $payer_id = ($payer_id < 0) ? $row['payer_id'] : $payer_id;
    $bill_process = ($bill_process < 0) ? $row['bill_process'] : $bill_process;
    $process_file = ($process_file) ? $row['process_file'] : $process_file;
    $target = ($target) ? $row['target'] : $target;
    $partner_id = ($partner_id < 0) ? $row['x12_partner_id'] : $partner_id;
    $sql = "INSERT INTO claims SET " .
      "patient_id = '$patient_id', " .
      "encounter_id = '$encounter_id', " .
      "bill_time = UNIX_TIMESTAMP(NOW()), " .
      "payer_id = '$payer_id', " .
      "status = '$status', " .
      "payer_type = '" . $row['payer_type'] . "', " .
      "bill_process = '$bill_process', " .
      "process_time = '" . $row['process_time'] . "', " .
      "process_file = '$process_file', " .
      "target = '$target', " .
      "x12_partner_id = '$partner_id'";
    ****/

    $sqlBindArray = array();
    array_push($sqlBindArray, $patient_id, $encounter_id);
    if($crossover<>1)
    {
    $sql = "INSERT INTO claims SET " .
        "patient_id = ?, " .
        "encounter_id = ?, " .
        "bill_time = NOW() $claimset";
     $sqlBindArray = array_merge($sqlBindArray, $sqlBindClaimset);
     }
     else
     {//Claim automatic forward case.
     $sql = "INSERT INTO claims SET " .
       "patient_id = ?, " .
       "encounter_id = ?, " .
       "bill_time = NOW(), status = ?";
     array_push($sqlBindArray, $status);
     }

    sqlStatement($sql, $sqlBindArray);
  }

  // Otherwise update the existing claim row.
  //
  else if ($claimset) {
        $sqlBindArray = $sqlBindClaimset;
        array_push($sqlBindArray, $patient_id, $encounter_id, $row['version']);
        $claimset = substr($claimset, 2);
        sqlStatement("UPDATE claims SET $claimset WHERE " .
        "patient_id = ? AND encounter_id = ? AND " .
        // "payer_id = '" . $row['payer_id'] . "' AND " .
        "version = ?", $sqlBindArray);
  }

  // Whenever a claim is marked billed, update A/R accordingly.
  //
  if ($status == 2) {
    if ($GLOBALS['oer_config']['ws_accounting']['enabled'] === 2) {
      if ($payer_type > 0) {
        sqlStatement("UPDATE form_encounter SET " .
            "last_level_billed = ? WHERE " .
            "pid = ? AND encounter = ?", array($payer_type, $patient_id, $encounter_id));
      }
    }
    else {
      $ws = new WSClaim($patient_id, $encounter_id);
    }
  }

  return 1;
}

// Determine if the encounter is billed.  It is considered billed if it
// has at least one chargeable item, and all of them are billed.
//
function isEncounterBilled($pid, $encounter) {
  $billed = -1; // no chargeable services yet

  $bres = sqlStatement("SELECT " .
    "billing.billed FROM billing, code_types WHERE " .
    "billing.pid = '$pid' AND " .
    "billing.encounter = '$encounter' AND " .
    "billing.activity = 1 AND " .
    "code_types.ct_key = billing.code_type AND " .
    "code_types.ct_fee = 1 " .
    "UNION " .
    "SELECT billed FROM drug_sales WHERE " .
    "pid = '$pid' AND " .
    "encounter = '$encounter'");

  while ($brow = sqlFetchArray($bres)) {
    if ($brow['billed'] == 0) {
      $billed = 0;
    }
    else {
      if ($billed < 0) $billed = 1;
    }
  }

  return $billed > 0;
}

// Get the co-pay amount that is effective on the given date.
// Or if no insurance on that date, return -1.
//
function getCopay($patient_id, $encdate) {
 $tmp = sqlQuery("SELECT provider, copay FROM insurance_data " .
   "WHERE pid = '$patient_id' AND type = 'primary' " .
   "AND date <= '$encdate' ORDER BY date DESC LIMIT 1");
 if ($tmp['provider']) return sprintf('%01.2f', 0 + $tmp['copay']);
 return 0;
}

// Get the total co-pay amount paid by the patient for an encounter
function getPatientCopay($patient_id, $encounter) {
        $resMoneyGot = sqlStatement("SELECT sum(pay_amount) as PatientPay FROM ar_activity where ".
          "deleted IS NULL AND pid = ? and encounter = ? and payer_type=0 and account_code='PCP'",
          array($patient_id,$encounter));
         //new fees screen copay gives account_code='PCP'
        $rowMoneyGot = sqlFetchArray($resMoneyGot);
        $Copay=$rowMoneyGot['PatientPay'];
        return $Copay*-1;
}

// Get the "next invoice reference number" from this user's pool of reference numbers.
//
function getInvoiceRefNumber() {
  $trow = sqlQuery("SELECT lo.notes " .
    "FROM users AS u, list_options AS lo " .
    "WHERE u.username = '" . $_SESSION['authUser'] . "' AND " .
    "lo.list_id = 'irnpool' AND lo.option_id = u.irnpool AND lo.activity = 1 LIMIT 1");
  return empty($trow['notes']) ? '' : $trow['notes'];
}

// Increment the "next invoice reference number" of this user's pool.
// This identifies the "digits" portion of that number and adds 1 to it.
// If it contains more than one string of digits, the last is used.
//
function updateInvoiceRefNumber() {
  $irnumber = getInvoiceRefNumber();
  // Here "?" specifies a minimal match, to get the most digits possible:
  if (preg_match('/^(.*?)(\d+)(\D*)$/', $irnumber, $matches)) {
    $newdigs = sprintf('%0' . strlen($matches[2]) . 'd', $matches[2] + 1);
    $newnumber = add_escape_custom($matches[1] . $newdigs . $matches[3]);
    sqlStatement("UPDATE users AS u, list_options AS lo " .
      "SET lo.notes = '$newnumber' WHERE " .
      "u.username = '" . $_SESSION['authUser'] . "' AND " .
      "lo.list_id = 'irnpool' AND lo.option_id = u.irnpool");
  }
  return $irnumber;
}

// Common function for voiding a receipt or checkout.  When voiding a checkout you can specify
// $time as a timestamp (yyyy-mm-dd hh:mm:ss) or 'all'; default means void the last checkout.
// $purge is 0 (or false) for receipt, 2 for visit delete, 1 (or otherwise true) for checkout.
// Nothing is purged on a visit delete because deleter.php does all that.
//
function doVoid($patient_id, $encounter_id, $purge=0, $time='', $reason='', $notes='') {
  $what_voided = $purge ? ($purge === 2 ? 'delete' : 'checkout') : 'receipt';

  $date_original = '';
  $adjustments = 0;
  $payments = 0;

  if (!$time) {
    // Get last checkout timestamp.
    $corow = sqlQuery("(SELECT bill_date FROM billing WHERE " .
      "pid = ? AND encounter = ? AND activity = 1 AND bill_date IS NOT NULL) " .
      "UNION " .
      "(SELECT bill_date FROM drug_sales WHERE " .
      "pid = ? AND encounter = ? AND bill_date IS NOT NULL) " .
      "ORDER BY bill_date DESC LIMIT 1",
      array($patient_id, $encounter_id, $patient_id, $encounter_id));
    if (!empty($corow['bill_date'])) {
      $date_original = $corow['bill_date'];
    }
  }
  else if ($time == 'all') {
    $row = sqlQuery("SELECT SUM(pay_amount) AS payments, " .
      "SUM(adj_amount) AS adjustments FROM ar_activity WHERE " .
      "deleted IS NULL AND pid = ? AND encounter = ?",
      array($patient_id, $encounter_id));
    $adjustments = $row['adjustments'];
    $payments = $row['payments'];
  }
  else {
    $date_original = $time;
  }
  // Get its charges and adjustments.
  if ($date_original) {
    $row = sqlQuery("SELECT SUM(pay_amount) AS payments, " .
      "SUM(adj_amount) AS adjustments FROM ar_activity WHERE " .
      "deleted IS NULL AND pid = ? AND encounter = ? AND post_time = ?",
      array($patient_id, $encounter_id, $date_original));
    $adjustments = $row['adjustments'];
    $payments = $row['payments'];
  }

  // Get old invoice reference number and encounter date.
  $encrow = sqlQuery("SELECT invoice_refno, date FROM form_encounter WHERE " .
    "pid = '$patient_id' AND encounter = '$encounter_id' LIMIT 1");
  $old_invoice_refno = $encrow['invoice_refno'];
  // For a deleted visit we preserve the visit date for voids reporting.
  if ($purge === 2) $date_original = $encrow['date'];
  //
  $usingirnpools = getInvoiceRefNumber();
  // If not (undoing a checkout or using IRN pools), nothing is done.
  if ($purge || $usingirnpools) {
    sqlStatement("INSERT INTO voids SET " .
      "patient_id = '" . add_escape_custom($patient_id) . "', " .
      "encounter_id = '" . add_escape_custom($encounter_id) . "', " .
      "what_voided = '$what_voided', " .
      ($date_original ?  "date_original = '$date_original', " : "") .
      "date_voided = NOW(), " .
      "user_id = '" . add_escape_custom($_SESSION['authUserID']) . "', " .
      "amount1 = '" . $row['adjustments'] . "', " .
      "amount2 = '" . $row['payments'] . "', " .
      "other_info = '" . add_escape_custom($old_invoice_refno) . "', " .
      "reason = '" . add_escape_custom($reason) . "', " .
      "notes = '" . add_escape_custom($notes) . "'");
  }
  if ($purge && $purge !== 2) {
    // Purge means delete adjustments and payments from the last checkout
    // and re-open the visit.
    if ($date_original) {
      sqlStatement("UPDATE ar_activity SET deleted = NOW() WHERE " .
        "pid = '$patient_id' AND encounter = '$encounter_id' AND " .
        "deleted IS NULL AND post_time = '$date_original'");
      sqlStatement("UPDATE billing SET billed = 0, bill_date = NULL WHERE " .
        "pid = '$patient_id' AND encounter = '$encounter_id' AND activity = 1 AND " .
        "bill_date IS NOT NULL AND bill_date = '$date_original'");
      sqlStatement("update drug_sales SET billed = 0, bill_date = NULL WHERE " .
        "pid = '$patient_id' AND encounter = '$encounter_id' AND " .
        "bill_date IS NOT NULL AND bill_date = '$date_original'");
    }
    else {
      if ($time == 'all') {
        sqlStatement("UPDATE ar_activity SET deleted = NOW() WHERE " .
          "deleted IS NULL AND pid = '$patient_id' AND encounter = '$encounter_id'");
      }
      sqlStatement("UPDATE billing SET billed = 0, bill_date = NULL WHERE " .
        "pid = '$patient_id' AND encounter = '$encounter_id' AND activity = 1");
      sqlStatement("update drug_sales SET billed = 0, bill_date = NULL WHERE " .
        "pid = '$patient_id' AND encounter = '$encounter_id'");
    }
    sqlStatement("UPDATE form_encounter SET last_level_billed = 0, " .
      "last_level_closed = 0, stmt_count = 0, last_stmt_date = NULL " .
      "WHERE pid = '$patient_id' AND encounter = '$encounter_id'");
  }
  else if ($usingirnpools && $purge !== 2) {
    // Just assign a new invoice reference number.
    $new_invoice_refno = add_escape_custom(updateInvoiceRefNumber());
    sqlStatement("UPDATE form_encounter " .
      "SET invoice_refno = '$new_invoice_refno' " .
      "WHERE pid = '$patient_id' AND encounter = '$encounter_id'");
  }
}
?>