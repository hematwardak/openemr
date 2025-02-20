<?php
use ESign\Api;
/* Copyright (C) 2006-2017 Rod Roark <rod@sunsetsystems.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 */

 // This provides the left navigation frame when $GLOBALS['concurrent_layout']
 // is true.  Following are notes as to what else was changed for this feature:
 //
 // * interface/main/main_screen.php: the top-level frameset.
 // * interface/main/finder/patient_select.php: loads stuff when a new patient
 //   is selected.
 // * interface/patient_file/summary/demographics.php: this is the first frame
 //   loaded when a new patient is chosen, and in turn sets the current pid and
 //   then loads the initial bottom frame.
 // * interface/patient_file/summary/demographics_full.php: added support for
 //   setting a new pid, needed for going to demographics from billing.
 // * interface/patient_file/summary/demographics_save.php: redisplay
 //   demographics.php and not the frameset.
 // * interface/patient_file/summary/summary_bottom.php: new frameset for the
 //   summary, prescriptions and notes for a selected patient, cloned from
 //   patient_summary.php.
 // * interface/patient_file/encounter/encounter_bottom.php: new frameset for
 //   the selected encounter, mosting coding/billing stuff, cloned from
 //   patient_encounter.php.  This will also self-load the superbill pages
 //   as requested.
 // * interface/usergroup/user_info.php: removed Back link.
 // * interface/usergroup/admin_frameset.php: new frameset for Admin pages,
 //   cloned from usergroup.php.
 // * interface/main/onotes/office_comments.php: removed Back link target.
 // * interface/main/onotes/office_comments_full.php: changed Back link.
 // * interface/billing/billing_report.php: removed Back link; added logic
 //   to properly go to demographics or to an encounter when requested.
 // * interface/new/new.php: removed Back link and revised form target.
 // * interface/new/new_patient_save.php: modified to load the demographics
 //   page to the current frame instead of loading a new frameset.
 // * interface/patient_file/history/history.php: target change.
 // * interface/patient_file/history/history_full.php: target changes.
 // * interface/patient_file/history/history_save.php: target change.
 // * interface/patient_file/history/encounters.php: link/target changes.
 // * interface/patient_file/encounter/encounter_top.php: another new frameset
 //   cloned from patient_encounter.php.
 // * interface/patient_file/encounter/forms.php: link target removal.
 // * interface/patient_file/encounter/new_form.php: target change.
 // * interface/forms/newpatient/new.php, view.php, save.php: link/target
 //   changes.
 // * interface/patient_file/summary/immunizations.php: removed back link.
 // * interface/patient_file/summary/pnotes.php: changed link targets.
 // * interface/patient_file/summary/pnotes_full.php: changed back link and
 //   added set_pid logic.
 // * interface/patient_file/transaction/transactions.php: various changes.
 // * interface/patient_file/transaction/add_transaction.php: new return js.
 // * interface/patient_file/encounter/superbill_codes.php: target and link
 //   changes.
 // * interface/patient_file/encounter/superbill_custom_full.php: target and
 //   link changes.
 // * interface/patient_file/encounter/diagnosis.php: target changes.
 // * interface/patient_file/encounter/diagnosis_full.php: target and link
 //   changes.
 // * interface/main/authorizations/authorizations.php: link and target changes.
 // * library/api.inc: url change.
 // * interface/patient_file/summary/rx_frameset.php: new frameset.
 // * interface/patient_file/summary/rx_left.php: new for prescriptions.
 // * all encounter forms: remove all instances of "target=Main" and change
 //   all instances of "patient_encounter.php" to "encounter_top.php".

 // Our find_patient form, when submitted, invokes patient_select.php in the
 // upper frame. When the patient is selected, demographics.php is invoked
 // with the set_pid parameter, which establishes the new session pid and also
 // calls the setPatient() function (below).  In this case demographics.php
 // will also load the summary frameset into the bottom frame, invoking our
 // loadFrame() and setRadio() functions.
 //
 // Similarly, we have the concept of selecting an encounter from the
 // Encounters list, and then having that "stick" until some other encounter
 // or a new encounter is chosen.  We also have a navigation item for creating
 // a new encounter.  interface/patient_file/encounter/encounter_top.php
 // supports set_encounter to establish an encounter.
 //
 // TBD: Include active_pid and/or active_encounter in relevant submitted
 // form data, and add logic to the save routines to make sure they match
 // the corresponding session values.

 require_once("../globals.php");
 require_once($GLOBALS['fileroot']."/library/acl.inc");
 require_once($GLOBALS['fileroot']."/custom/code_types.inc.php");
 require_once($GLOBALS['fileroot']."/library/patient.inc");
 require_once($GLOBALS['fileroot']."/library/lists.inc");
 require_once($GLOBALS['fileroot']."/library/registry.inc");
 require_once $GLOBALS['srcdir'].'/ESign/Api.php';

 // This array defines the list of primary documents that may be
 // chosen.  Each element value is an array of 3 values:
 //
 // * Name to appear in the navigation table
 // * Usage: 0 = global, 1 = patient-specific, 2 = encounter-specific
 // * The URL relative to the interface directory
 //

 $primary_docs = array(
  'ros' => array(xl('Roster')    , 0, 'reports/players_report.php?embed=1'),
  'cal' => array(xl('Calendar')  , 0, 'main/main_info.php'),
  'pfb' => array(xl('Patient Flow Board')  , 0, '../interface/patient_tracker/patient_tracker.php?skip_timeout_reset=1'),
  'app' => array(xl('Portal Activity')  , 0, '../myportal/index.php'),
  'msg' => array(xl('Messages')  , 0, 'main/messages/messages.php?form_active=1'),
  'pwd' => array(xl('Password')  , 0, 'usergroup/user_info.php'),
  'seq' => array(xl('MFA Management'), 0, 'usergroup/mfa_registrations.php'),
  'prf' => array(xl('Preferences')  , 0, 'super/edit_globals.php?mode=user'),
  'adm' => array(xl('Admin')     , 0, 'usergroup/admin_frameset.php'),
  'rep' => array(xl('Reports')   , 0, 'reports/index.php'),
  'ono' => array(xl('Ofc Notes') , 0, 'main/onotes/office_comments.php'),
  'fax' => array(xl('Fax/Scan')  , 0, 'fax/faxq.php'),
  'adb' => array(xl('Addr Bk')   , 0, 'usergroup/addrbook_list.php'),
  'orl' => array(xl('Proc Prov') , 0, 'orders/procedure_provider_list.php'),
  'ort' => array(xl('Proc Cat')  , 0, 'orders/types.php'),
  'orc' => array(xl('Proc Load') , 0, 'orders/load_compendium.php'),
  'orb' => array(xl('Proc Bat')  , 0, 'orders/orders_results.php?batch=1'),
  'ore' => array(xl('E-Reports') , 0, 'orders/list_reports.php'),
  'cht' => array(xl('Chart Trk') , 0, '../custom/chart_tracker.php'),
  'imp' => array(xl('Import')    , 0, '../custom/import.php'),
  'bil' => array(xl('Billing')   , 0, 'billing/billing_report.php'),
  'sup' => array(xl('Superbill') , 0, 'patient_file/encounter/superbill_custom_full.php'),
  'aun' => array(xl('Authorizations'), 0, 'main/authorizations/authorizations.php'),
  'new' => array(xl('New Pt')    , 0, 'new/new.php'),
  'ped' => array(xl('Patient Education'), 0, 'reports/patient_edu_web_lookup.php'),
  'lab' => array(xl('Check Lab Results')  , 0, 'orders/lab_exchange.php'),
  'dem' => array(xl('Patient')   , 1,  "patient_file/summary/demographics.php"),
  'his' => array(xl('History')   , 1, 'patient_file/history/history.php'),
  'ens' => array(xl('Visit History'), 1, 'patient_file/history/encounters.php'),
  'ref' => array(xl('Referrals')    , 1, 'reports/referrals_report.php?patient_id={PID}'),
  'nen' => array(xl('Create Visit'), 1, 'forms/newpatient/new.php?autoloaded=1&calenc='),
  'pre' => array(xl('Rx')        , 1, 'patient_file/summary/rx_frameset.php'),
  'iss' => array(xl('Issues')    , 1, 'patient_file/summary/stats_full.php?active=all'),
  'imm' => array(xl('Immunize')  , 1, 'patient_file/summary/immunizations.php'),
  'doc' => array(xl('Documents') , 1, '../controller.php?document&list&patient_id={PID}'),
  'orp' => array(xl('Proc Pending Rev'), 1, 'orders/orders_results.php?review=1'),
  'orr' => array(xl('Proc Res')  , 1, 'orders/orders_results.php'),
  'prp' => array(xl('Pt Report') , 1, 'patient_file/report/patient_report.php'),
  'prq' => array(xl('Pt Rec Request') , 1, 'patient_file/transaction/record_request.php'),
  'pno' => array(xl('Pt Notes')  , 1, 'patient_file/summary/pnotes.php'),
  'tra' => array(xl('Transact')  , 1, 'patient_file/transaction/transactions.php'),
  'sum' => array(xl('Summary')   , 1, 'patient_file/summary/summary_bottom.php'),
  'enc' => array(xl('Encounter') , 2, 'patient_file/encounter/encounter_top.php'),
  'erx' => array(xl('e-Rx') , 1, 'eRx.php'),
  'err' => array(xl('e-Rx Renewal') , 1, 'eRx.php?page=status'),
  'pay' => array(xl('Payment') , 1, '../patient_file/front_payment.php'),
  'edi' => array(xl('EDI History') , 0, 'billing/edih_view.php')
 );
 $primary_docs['npa']=array(xl('Batch Payments')   , 0, 'billing/new_payment.php');
 if ($GLOBALS['use_charges_panel'] || $GLOBALS['concurrent_layout'] == 2) {
  $primary_docs['cod'] = array(xl('Charges'), 2, 'patient_file/encounter/encounter_bottom.php');
 }

 $esignApi = new Api();

$auth_drug_management = $GLOBALS['inhouse_pharmacy'] && (
  acl_check('admin'    , 'drugs'      ) ||
  acl_check('inventory', 'lots'       ) ||
  acl_check('inventory', 'purchases'  ) ||
  acl_check('inventory', 'transfers'  ) ||
  acl_check('inventory', 'adjustments') ||
  acl_check('inventory', 'consumption') ||
  acl_check('inventory', 'destruction') ||
  acl_check('inventory', 'sales'      ) ||
  acl_check('inventory', 'reporting'  ));

$auth_drug_reports = $GLOBALS['inhouse_pharmacy'] && (
  acl_check('admin'    , 'drugs'      ) ||
  acl_check('inventory', 'reporting'  ));

 // This section decides which navigation items will not appear.
 $disallowed = array();
 $disallowed['edi'] = !($GLOBALS['enable_edihistory_in_left_menu'] || acl_check('acct', 'eob'));
 $disallowed['adm'] = !(acl_check('admin', 'calendar') ||
  acl_check('admin', 'database') || acl_check('admin', 'forms') ||
  acl_check('admin', 'practice') || acl_check('admin', 'users') ||
  acl_check('admin', 'acl')      || acl_check('admin', 'super') ||
  acl_check('admin', 'superbill') || $auth_drug_management);

 $disallowed['bil'] = !(acl_check('acct', 'rep') || acl_check('acct', 'eob') ||
  acl_check('acct', 'bill'));

 $disallowed['new'] = !(acl_check('patients','demo','',array('write','addonly') ));

 $disallowed['fax'] = !($GLOBALS['enable_hylafax'] || $GLOBALS['enable_scanner']);

 $disallowed['ros'] = !$GLOBALS['athletic_team'];

 $disallowed['iss'] = !((acl_check('encounters','notes','','write') ||
  acl_check('encounters','notes_a','','write') ) &&
  acl_check('patients','med','','write') );

 $disallowed['imp'] = $disallowed['new'] ||
  !is_readable("$webserver_root/custom/import.php");

 $disallowed['cht'] = !is_readable("$webserver_root/custom/chart_tracker.php");

 $disallowed['pre'] = !(acl_check('patients', 'med'));

 // Helper functions for treeview generation.
 function genTreeLink($frame, $name, $title, $mono=false) {
  global $primary_docs, $disallowed;
  if (empty($disallowed[$name])) {
   $id = $name . $primary_docs[$name][1];
   echo "<li><a href='' id='$id' onclick=\"";
   if ($mono) {
    if ($frame == 'RTop')
     echo "forceSpec(true,false);";
    else
     echo "forceSpec(false,true);";
   }
   echo "return loadFrame2('$id','$frame','" .
        $primary_docs[$name][2] . "')\">" . $title . ($name == 'msg' ? ' <span id="reminderCountSpan" class="bold"></span>' : '')."</a></li>";
  }
 }

function genMiscLink($frame, $name, $level, $title, $url, $mono=false, $encform=false) {
    global $disallowed;
    if (empty($disallowed[$name])) {
        $id = $name . $level;
        echo "<li><a href='' id='$id' onclick=\"";
        if ($mono) {
            if ($frame == 'RTop') {
                echo "forceSpec(true,false);";
            }
            else {
                echo "forceSpec(false,true);";
            }
        }
        if ($encform) {
            // In this case $url is an encounter form name, not a URL.
            echo "loadNewForm('" . addslashes(trim($url)) . "', '" . addslashes(trim($title)) . "');";
        }
        else {
            echo "loadFrame2('$id','$frame','" . $url . "');";
        }
        echo "return false;\">" . text($title) . "</a></li>";
    }
}

 function genPopLink($title, $url, $linkid='') {
  echo "<li><a href='' ";
  if ($linkid) echo "id='$linkid' ";
  echo "onclick=\"return repPopup('$url')\"" .
       ">" . $title . "</a></li>";
 }
 function genDualLink($topname, $botname, $title) {
  global $primary_docs, $disallowed;
  if (empty($disallowed[$topname]) && empty($disallowed[$botname])) {
   $topid = $topname . $primary_docs[$topname][1];
   $botid = $botname . $primary_docs[$botname][1];
   echo "<li><a href='' id='$topid' " .
        "onclick=\"return loadFrameDual('$topid','$botid','" .
        $primary_docs[$topname][2] . "','" .
        $primary_docs[$botname][2] . "')\">" . $title . "</a></li>";
  }
 }

function genPopupsList($style='') {
  global $disallowed, $webserver_root;
?>
<select name='popups' onchange='selpopup(this)' style='background-color:transparent;font-size:9pt;<?php echo $style; ?>'>
 <option value=''><?php xl('Popups','e'); ?></option>
<?php if (!$disallowed['iss']) { ?>
 <option value='../patient_file/problem_encounter.php'><?php xl('Issues','e'); ?></option>
<?php } ?>
<?php if (!$GLOBALS['ippf_specific']) { ?>
 <option value='../../custom/export_xml.php'><?php xl('Export','e'); ?></option>
 <option value='../../custom/import_xml.php'><?php xl('Import','e'); ?></option>
<?php } ?>
<?php if ($GLOBALS['athletic_team']) { ?>
 <option value='../reports/players_report.php'><?php xl('Roster','e'); ?></option>
<?php } ;
 if (!$GLOBALS['disable_calendar']) { ?>
 <option value='../reports/appointments_report.php?patient=<?php if(isset($pid)) {echo $pid;} ?>'><?php xl('Appts','e'); ?></option>
<?php } ;
 if (file_exists("$webserver_root/custom/refer.php")) { ?>
 <option value='../../custom/refer.php'><?php xl('Refer','e'); ?></option>
<?php } ?>
 <option value='../patient_file/printed_fee_sheet.php?fill=1'><?php xl('Superbill','e'); ?></option>
 <option value='../patient_file/front_payment.php?feat=1'><?php echo xla('Payment'); ?></option>
 <option value='../patient_file/front_payment.php?feat=2'><?php echo xla('Adjustment'); ?></option>
<?php if ($GLOBALS['inhouse_pharmacy'] && (acl_check('admin', 'super') || acl_check('acct', 'bill') || acl_check('acct', 'disc'))) { ?>
 <option value='../patient_file/pos_checkout.php'><?php xl('Checkout','e'); ?></option>
<?php } ?>
<?php if (is_dir($GLOBALS['OE_SITE_DIR'] . "/letter_templates")) { ?>
 <option value='../patient_file/letter.php'><?php xl('Letter','e'); ?></option>
<?php } ?>
</select>
<?php
}

function genFindBlock() {
?>
<table cellpadding='0' cellspacing='0' border='0'>
 <tr>
  <td class='smalltext'><?php xl('Find','e') ?>:&nbsp;</td>
  <td class='smalltext' colspan='2'>
   <input type="entry" size="7" name="patient" class='inputtext' style='width:65px;' />
  </td>
 </tr>
 <tr>
  <td class='smalltext'><?php xl('by','e') ?>:</td>
  <td class='smalltext'>
   <a href="javascript:findPatient('Last');" class="navitem"><?php xl('Name','e'); ?></a>
  </td>
  <td class='smalltext' align='right'>
   <a href="javascript:findPatient('ID');"   class="navitem"><?php xl('ID','e'); ?></a>
  </td>
 </tr>
 <tr>
  <td class='smalltext'>&nbsp;</td>
  <td class='smalltext'>
   <a href="javascript:findPatient('SSN');"  class="navitem"><?php xl('SSN','e'); ?></a>
  </td>
  <td class='smalltext' align='right'>
   <a href="javascript:findPatient('DOB');"  class="navitem"><?php xl('DOB','e'); ?></a>
  </td>
 </tr>
 <tr>
  <td class='smalltext'>&nbsp;</td>
  <td class='smalltext'>
   <a href="javascript:findPatient('Any');"  class="navitem"><?php xl('Any', 'e'); ?></a>
  </td>
  <td class='smalltext' align='right'>
   <a href="javascript:initFilter();"  class="navitem"><?php xl('Filter', 'e'); ?></a>
  </td>
 </tr>
</table>
<?php
} // End function genFindBlock()

?>
<html>
<head>
<title>Navigation</title>
  
<link rel="stylesheet" href="<?php echo $css_header;?>" type="text/css">

<style type="text/css">
 body {
  font-size:8pt;
  font-weight:normal;
  padding: 5px 3px 5px 3px;
 }
 .smalltext {
  font-family:sans-serif;
  font-size:8pt;
  font-weight:normal;
 }
 a.navitem, a.navitem:visited {
  color:#0000ff;
  font-family:sans-serif;
  font-size:8pt;
  font-weight:bold;
 }
.inputtext {
 font-size:9pt;
 font-weight:normal;
 border-style:solid;
 border-width:1px;
 padding-left:2px;
 padding-right:2px;
 border-color: #000000;
 background-color:transparent;
}

#navigation ul {
 background-color:transparent;
}
#navigation-slide ul {
 background-color:transparent;
}
#navigation-slide a{
 width: 92%;
}
.nav-menu-img{
  width:25px;
  height:25px;
  border:none;
  margin-right:5px;
  vertical-align:middle;
}
</style>

<link rel="stylesheet" href="../../library/js/jquery.treeview-1.4.1/jquery.treeview.css" />
<script src="../../library/js/jquery-1.6.4.min.js" type="text/javascript"></script>
<script src="../../library/js/jquery.treeview-1.4.1/jquery.treeview.js" type="text/javascript"></script>

<script type="text/javascript" src="../../library/dialog.js"></script>

<script language='JavaScript'>
 
 // tajemo work by CB 2012/01/31 12:32:57 PM dated reminders counter
 function getReminderCount(){ 
   top.restoreSession();
   // Send the skip_timeout_reset parameter to not count this as a manual entry in the
   //  timing out mechanism in OpenEMR.
   $.post("<?php echo $GLOBALS['webroot']; ?>/library/ajax/dated_reminders_counter.php",
     { skip_timeout_reset: "1" }, 
     function(data) {
       $("#reminderCountSpan").html(data);
    // run updater every 60 seconds 
     var repeater = setTimeout("getReminderCount()", 60000); 
   });
   //piggy-back on this repeater to run other background-services
   //this is a silent task manager that returns no output
   $.post("<?php echo $GLOBALS['webroot']; ?>/library/ajax/execute_background_services.php",
      { skip_timeout_reset: "1", ajax: "1" });
 }   
 
 $(document).ready(function (){
   getReminderCount();//
   parent.loadedFrameCount += 1;
   <?php if ($GLOBALS['drop_bottom'] ==1) { ?>   
   $("input[name=cb_bot]").trigger('click');
   toggleFrame(2);
   <?php } ?>
 }) 
 // end of tajemo work dated reminders counter
 
 // Master values for current pid and encounter.
 var active_pid = 0;
 var active_encounter = 0;
 var encounter_locked = false;

 // Current selections in the top and bottom frames.
 var topName = '';
 var botName = '';

 // Expand and/or collapse frames in response to checkbox clicks.
 // fnum indicates which checkbox was clicked (1=left, 2=right).
 function toggleFrame(fnum) {
  var f = document.forms[0];
  var fset = top.document.getElementById('fsright');
  if (!f.cb_top.checked && !f.cb_bot.checked) {
   if (fnum == 1) f.cb_bot.checked = true;
   else f.cb_top.checked = true;
  }
  var rows = f.cb_top.checked ? '*' :  '0';
  rows += f.cb_bot.checked ? ',*' : ',0';
  fset.rows = rows;
  fset.rows = rows;
 }

 // Load the specified url into the specified frame (RTop or RBot).
 // The URL provided must be relative to interface.
 function loadFrame(fname, frame, url) {
  top.restoreSession();
  var i = url.indexOf('{PID}');
  if (i >= 0) url = url.substring(0,i) + active_pid + url.substring(i+5);
  top.frames[frame].location = '<?php echo "$web_root/interface/" ?>' + url;
  if (frame == 'RTop') topName = fname; else botName = fname;
 }

 // Load the specified url into a frame to be determined, with the specified
 // frame as the default; the url must be relative to interface.
 function loadFrame2(fname, frame, url) {
  var usage = fname.substring(3);
  if (active_pid == 0 && usage > '0') {
   alert('<?php xl('You must first select or add a patient.','e') ?>');
   return false;
  }
  if (active_encounter == 0 && usage > '1') {
   alert('<?php xl('You must first select or create an encounter.','e') ?>');
   return false;
  }
  if (encounter_locked && usage > '1') {
   alert('<?php echo xls('This encounter is locked. No new forms can be added.') ?>');
   return false;
  }
  var f = document.forms[0];
  top.restoreSession();
  var i = url.indexOf('{PID}');
  if (i >= 0) url = url.substring(0,i) + active_pid + url.substring(i+5);
  if(f.sel_frame)
   {
	  var fi = f.sel_frame.selectedIndex;
	  if (fi == 1) frame = 'RTop'; else if (fi == 2) frame = 'RBot';
   }
  if (!f.cb_bot.checked) frame = 'RTop'; else if (!f.cb_top.checked) frame = 'RBot';
  top.frames[frame].location = '<?php echo "$web_root/interface/" ?>' + url;
  if (frame == 'RTop') topName = fname; else botName = fname;
  return false;
 }

// Special handling to load a new encounter form into an existing encounter.
function loadNewForm(formname, formdesc) {
  var url = '<?php echo "$rootdir/patient_file/encounter/load_form.php?formname=" ?>' + formname;
  if (parent.RBot.twAddFrameTab) {
    parent.RBot.twAddFrameTab('enctabs', formdesc, url);
  }
  else if (parent.RTop.twAddFrameTab) {
    parent.RTop.twAddFrameTab('enctabs', formdesc, url);
  }
  else {
    loadFrame2('enc2','RBot','patient_file/encounter/encounter_top.php' +
      '?formname=' + formname + '&formdesc=' + formdesc);
  }
}

 // Make sure the the top and bottom frames are open or closed, as specified.
 function forceSpec(istop, isbot) {
  var f = document.forms[0];
  if (f.cb_top.checked != istop) {
   f.cb_top.checked = istop;
   toggleFrame(1);
  }
  if (f.cb_bot.checked != isbot) {
   f.cb_bot.checked = isbot;
   toggleFrame(2);
  }
 }

 // Make sure both frames are open.
 function forceDual() {
  forceSpec(true, true);
 }

 // Load the specified url into a frame to be determined, with the specified
 // frame as the default; the url must be relative to interface.
 function loadFrameDual(tname, bname, topurl, boturl) {
  var topusage = tname.substring(3);
  var botusage = bname.substring(3);
  if (active_pid == 0 && (topusage > '0' || botusage > '0')) {
   alert('<?php xl('You must first select or add a patient.','e') ?>');
   return false;
  }
  if (active_encounter == 0 && (topusage > '1' || botusage > '1')) {
   alert('<?php xl('You must first select or create an encounter.','e') ?>');
   return false;
  }
  if (encounter_locked  && (topusage > '1' || botusage > '1')) {
   alert('<?php echo xls('This encounter is locked. No new forms can be added.') ?>');
   return false;
  }
  var f = document.forms[0];
  forceDual();
  top.restoreSession();
  var i = topurl.indexOf('{PID}');
  if (i >= 0) topurl = topurl.substring(0,i) + active_pid + topurl.substring(i+5);
  i = boturl.indexOf('{PID}');
  if (i >= 0) boturl = boturl.substring(0,i) + active_pid + boturl.substring(i+5);
  top.frames.RTop.location = '<?php echo "$web_root/interface/" ?>' + topurl;
  top.frames.RBot.location = '<?php echo "$web_root/interface/" ?>' + boturl;
  topName = tname;
  botName = bname;
  return false;
 }

 // Select a designated radio button. raname may be either the radio button
 // array name (rb_top or rb_bot), or the frame name (RTop or RBot).
 // You should call this if you directly load a document that does not
 // correspond to the current radio button setting.
 function setRadio(raname, rbid) {
<?php if ($GLOBALS['concurrent_layout'] < 2) { ?>
  var f = document.forms[0];
  if (raname == 'RTop') raname = 'rb_top';
  if (raname == 'RBot') raname = 'rb_bot';
  for (var i = 0; i < f[raname].length; ++i) {
   if (f[raname][i].value.substring(0,3) == rbid) {
    f[raname][i].checked = true;
    return true;
   }
  }
<?php } ?>
  return false;
 }

 // Set disabled/enabled state of radio buttons and associated labels
 // depending on whether there is an active patient or encounter.
 function syncRadios() {
  var f = document.forms[0];
  encounter_locked = isEncounterLocked(active_encounter);
<?php if (($GLOBALS['concurrent_layout'] == 2)||($GLOBALS['concurrent_layout'] == 3)) { ?>
  var nlinks = document.links.length;
  for (var i = 0; i < nlinks; ++i) {
   var lnk = document.links[i];
   if (lnk.id.length != 4) continue;
   var usage = lnk.id.substring(3);
   if (usage == '1' || usage == '2') {
    var da = false;
    if (active_pid == 0) da = true;
    if (active_encounter == 0 && usage > '1') da = true;
    if (encounter_locked && usage > '1') da = true;
    <?php
    if ($GLOBALS['concurrent_layout'] == 2){
      $color = "'#0000ff'";
    }else{
      $color = "'#000000'";
    }
    ?>
    lnk.style.color = da ? '#888888' : <?php echo $color; ?>;
   }
  }
<?php } else if ($GLOBALS['concurrent_layout'] < 2) { ?>
  for (var i = 0; i < f.rb_top.length; ++i) {
   var da = false;
   var rb1 = f.rb_top[i];
   var rb2 = f.rb_bot[i];
   var rbid = rb1.value.substring(0,3);
   var usage = rb1.value.substring(3);
   if (active_pid == 0 && usage > '0') da = true;
   if (active_encounter == 0 && usage > '1') da = true;
   if (encounter_locked && usage > '1') da = true;
   // daemon_frame can also set special label colors, so don't mess with
   // them unless we have to.
   if (rb1.disabled != da) {
    rb1.disabled = da;
    rb2.disabled = da;
    document.getElementById('lbl_' + rbid).style.color = da ? '#888888' : '#000000';
   }
  }
<?php } ?>
  f.popups.disabled = (active_pid == 0);
 }

function goHome() {
    top.frames['RTop'].location='<?php echo $GLOBALS['default_top_pane']?>';
    top.frames['RBot'].location='messages/messages.php?form_active=1';
}

//Function to clear active patient and encounter in the server side
function clearactive() {
	top.restoreSession();
	//Ajax call to clear active patient in session
	$.ajax({
	  type: "POST",
	  url: "<?php echo $GLOBALS['webroot'] ?>/library/ajax/unset_session_ajax.php",
	  data: { func: "unset_pid"},
	  success:function( msg ) {
		clearPatient();
		top.frames['RTop'].location='<?php echo $GLOBALS['default_top_pane']?>';
		top.frames['RBot'].location='messages/messages.php?form_active=1';
	  }
	});
    
	$(parent.Title.document.getElementById('clear_active')).hide();
}
 // Reference to the search.php window.
 var my_window;

 // Open the search.php window.
 function initFilter() {
    my_window = window.open("../../custom/search.php", "mywindow","status=1");
 }

 // This is called by the search.php (Filter) window.
 function processFilter(fieldString, serviceCode) {
  var f = document.forms[0];
  document.getElementById('searchFields').value = fieldString;
  f.search_service_code.value = serviceCode;
  findPatient("Filter");
  f.search_service_code.value = '';
  my_window.close();
 }

 // Process the click to find a patient by name, id, ssn or dob.
 function findPatient(findby) {
  var f = document.forms[0];
  if (! f.cb_top.checked) {
   f.cb_top.checked = true;
   toggleFrame(1);
  }
  f.findBy.value = findby;
  setRadio('rb_top', 'dem');
  top.restoreSession();
  document.find_patient.submit();
 }

 // Helper function to set the contents of a div.
 function setSomeContent(id, content, doc) {
  if (doc.getElementById) {
   var x = doc.getElementById(id);
   x.innerHTML = '';
   x.innerHTML = content;
  }
  else if (doc.all) {
   var x = doc.all[id];
   x.innerHTML = content;
  }
 }
 function setDivContent(id, content) {
  setSomeContent(id, content, document);
 }
 function setTitleContent(id, content) {
  setSomeContent(id, content, parent.Title.document);
 }

 // This is called automatically when a new patient is set, to make sure
 // there are no patient-specific documents showing stale data.  If a frame
 // was just loaded with data for the correct patient, its name is passed so
 // that it will not be zapped.  At this point the new server-side pid is not
 // assumed to be set, so this function will only load global data.
 function reloadPatient(frname) {
  var f = document.forms[0];
  if (topName.length > 3 && topName.substring(3) > '0' && frname != 'RTop') {
   loadFrame('cal0','RTop', '<?php echo $primary_docs['cal'][2]; ?>');
   setRadio('rb_top', 'cal');
  }
  if (botName.length > 3 && botName.substring(3) > '0' && frname != 'RBot') {
   loadFrame('ens1','RBot', '<?php echo $primary_docs['ens'][2]; ?>');
   setRadio('rb_bot', 'ens');
  }
 }

 // Reload encounter-specific frames, excluding a specified frame.  At this
 // point the new server-side encounter ID may not be set and loading the same
 // document for the new encounter will not work, so load patient info instead.
 function reloadEncounter(frname) {
  var f = document.forms[0];
  if (topName.length > 3 && topName.substring(3) > '1' && frname != 'RTop') {
   loadFrame('dem1','RTop', '<?php echo $primary_docs['dem'][2]; ?>');
   setRadio('rb_top', 'dem');
  }
  if (botName.length > 3 && botName.substring(3) > '1' && frname != 'RBot') {
   loadFrame('ens1','RBot', '<?php echo $primary_docs['ens'][2]; ?>');
   setRadio('rb_bot', 'ens');
  }
 }

 // Clear and reload issue-related menu items for active_pid.
 // Currently this only applies to athletic teams, but might be implemented
 // in the general menu at some future time.
 //
 function reloadIssues() {
<?php
  if ($GLOBALS['athletic_team']) {
    // Generates a menu item for each active issue that this patient
    // has of each issue type.  Each one looks like this:
    //   Onset-Date [Add] Issue-Title
    // where the first part is a link to open the issue dialog,
    // [Add] is a link that auto-creates and opens a new encounter, and
    // Issue-Title is a link that shows related encounters.
    foreach ($ISSUE_TYPES as $key => $value) {
?>
  $('#icontainer_<?php echo $key ?>').empty();
  if (active_pid != 0) {
   $('#icontainer_<?php echo $key ?>').append("<li>" +
    "<a href='' id='xxx1' onclick='return repPopup(" +
    "\"../patient_file/summary/add_edit_issue.php?thistype=" +
    "<?php echo $key; ?>\")' " +
    "title='<?php echo xl('Create new issue'); ?>'>" +
    "<?php echo xl('New') . " " . $value[1]; ?></a></li>");
   top.restoreSession();
   $.getScript('../../library/ajax/left_nav_issues_ajax.php?type=<?php echo $key; ?>');
  }
<?php
    }
  }
?>
 } // end function reloadIssues

 // This is referenced in left_nav_issues_ajax.php and is called when [Add]
 // is clicked for an issue menu item to add a new encounter for the issue.
 // So far this only applies to the Athletic Team version of the menu.
 //
 function addEncNotes(issue) {

  // top.restoreSession();
  // $.getScript('../../library/ajax/left_nav_encounter_ajax.php?createvisit=1&issue=' + issue);

  // The above AJAX call was to create the encounter right away, but we later
  // (2012-07-03) decided it's better to present the New Encounter form instead.
  // Note the issue ID is passed so it will be pre-selected in that form.
  loadFrame2('nen1','RBot','forms/newpatient/new.php?autoloaded=1&calenc=&issue=' + issue);

  return false;
 }

 // Call this to announce that the patient has changed.  You must call this
 // if you change the session PID, so that the navigation frame will show the
 // correct patient and so that the other frame will be reloaded if it contains
 // patient-specific information from the previous patient.  frname is the name
 // of the frame that the call came from, so we know to only reload content
 // from the *other* frame if it is patient-specific.
 function setPatient(pname, pid, pubpid, frname, str_dob) {
  var str = '<a href=\'javascript:;\' onclick="parent.left_nav.loadCurrentPatientFromTitle()" title="PID = ' + pid + '"><b>' + pname + ' (' + pubpid + ')<br /></b></a>';
  setDivContent('current_patient', str);
  setTitleContent('current_patient', str + str_dob);
  if (pid == active_pid) return;
  setDivContent('current_encounter', '<b><?php xl('None','e'); ?></b>');
  active_pid = pid;
  active_encounter = 0;
  encounter_locked = false;
  if (frname) reloadPatient(frname);
  syncRadios();
  $(parent.Title.document.getElementById('current_patient_block')).show();
  var encounter_block = $(parent.Title.document.getElementById('current_encounter_block'));
  $(encounter_block).hide();

  // zero out the encounter frame, replace it with the encounter list frame
  // but only if top and bottom frames are both open
  var f = document.forms[0];
  if ( f.cb_top.checked && f.cb_bot.checked ) {
   var encounter_frame = getEncounterTargetFrame('enc');
   if ( encounter_frame != undefined )  {
    loadFrame('ens1',encounter_frame, '<?php echo $primary_docs['ens'][2]; ?>');
    setRadio(encounter_frame, 'ens');
   }
  }

  reloadIssues(pid);
  $(parent.Title.document.getElementById('clear_active')).show();//To display Clear Active Patient button on selecting a patient
 }
 function setPatientEncounter(EncounterIdArray,EncounterDateArray,CalendarCategoryArray) {
 //This function lists all encounters of the patient.
 //This function writes the drop down in the top frame.
 //It is called when a new patient is create/selected from the search menu.
  var str = '<Select class="text" id="EncounterHistory" onchange="{top.restoreSession();toencounter(this.options[this.selectedIndex].value)}">';
  str+='<option value=""><?php echo htmlspecialchars( xl('Encounter History'), ENT_QUOTES) ?></option>';
  str+='<option value="New Encounter"><?php echo htmlspecialchars( xl('New Encounter'), ENT_QUOTES) ?></option>';
  str+='<option value="Past Encounter List"><?php echo htmlspecialchars( xl('Past Encounter List'), ENT_QUOTES) ?></option>';
  for(CountEncounter=0;CountEncounter<EncounterDateArray.length;CountEncounter++)
   {
    str+='<option value="'+EncounterIdArray[CountEncounter]+'~'+EncounterDateArray[CountEncounter]+'">'+EncounterDateArray[CountEncounter]+'-'+CalendarCategoryArray[CountEncounter]+'</option>';
   }
  str+='</Select>';
  $(parent.Title.document.getElementById('past_encounter_block')).show();
  top.window.parent.Title.document.getElementById('past_encounter').innerHTML=str;
 }

function loadCurrentPatientFromTitle() {
    top.restoreSession();
    top.frames['RTop'].location='../patient_file/summary/demographics.php';
}

function getEncounterTargetFrame( name ) {
    var bias = <?php echo $primary_docs[ 'enc'  ][ 1 ]?>;
    var f = document.forms[0];
    var r = 'RTop';
    if (f.cb_top.checked && f.cb_bot.checked) {
        if ( bias == 2 ) {
            r = 'RBot';
        } else {
            r = 'RTop';
        }
    } else {
        if ( f.cb_top.checked ) {
            r = 'RTop';
        } else if ( f.cb_bot.checked )  {
            r = 'RBot';
        }
    }
    return r;
}
function isEncounterLocked( encounterId ) {
	<?php if ( $esignApi->lockEncounters() ) { ?>
	// If encounter locking is enabled, make a syncronous call (async=false) to check the
	// DB to see if the encounter is locked.
	// Call restore session, just in case
	top.restoreSession();
    $.ajax({
        type: 'POST',
        url: '<?php echo $GLOBALS['webroot']?>/interface/esign/index.php?module=encounter&method=esign_is_encounter_locked',
        data: { encounterId : encounterId },
        success: function( data ) {
            encounter_locked = data;
        },
        dataType: 'json',
        async:false
	});	    
	return encounter_locked;
	<?php } else { ?>
	// If encounter locking isn't enabled, just tell the left_nav that the encounter 
    // isn't locked.
	return false;
	<?php } ?>
 }
 // Call this to announce that the encounter has changed.  You must call this
 // if you change the session encounter, so that the navigation frame will
 // show the correct encounter and so that the other frame will be reloaded if
 // it contains encounter-specific information from the previous encounter.
 // frname is the name of the frame that the call came from, so we know to only
 // reload encounter-specific content from the *other* frame.
 function setEncounter(edate, eid, frname) {
  if (eid == active_encounter) return;
  if (!eid) edate = '<?php xl('None','e'); ?>';
  var str = '<b>' + edate + '</b>';
  setDivContent('current_encounter', str);
  active_encounter = eid;
  encounter_locked=isEncounterLocked(active_encounter);
  reloadEncounter(frname);
  syncRadios();
  var encounter_block = $(parent.Title.document.getElementById('current_encounter_block'));
  var encounter = $(parent.Title.document.getElementById('current_encounter'));
  var estr = '<a href=\'javascript:;\' onclick="parent.left_nav.loadCurrentEncounterFromTitle()"><b>' + edate + ' (' + eid + ')</b></a>';
  encounter.html( estr );
  encounter_block.show();
 }

 function loadCurrentEncounterFromTitle() {
      top.restoreSession();
      top.frames[ parent.left_nav.getEncounterTargetFrame('enc') ].location='../patient_file/encounter/encounter_top.php';
 }

 // You must call this if you delete the active patient (or if for any other
 // reason you "close" the active patient without opening a new one), so that
 // the appearance of the navigation frame will be correct and so that any
 // stale content will be reloaded.
 function clearPatient() {
  if (active_pid == 0) return;
  var f = document.forms[0];
  active_pid = 0;
  active_encounter = 0;
  encounter_locked = false;
  setDivContent('current_patient', '<b><?php xl('None','e'); ?></b>');
  $(parent.Title.document.getElementById('current_patient_block')).hide();
  top.window.parent.Title.document.getElementById('past_encounter').innerHTML='';
  $(parent.Title.document.getElementById('current_encounter_block')).hide();
  reloadPatient('');
  syncRadios();
 }

 // You must call this if you delete the active encounter (or if for any other
 // reason you "close" the active encounter without opening a new one), so that
 // the appearance of the navigation frame will be correct and so that any
 // stale content will be reloaded.
 function clearEncounter() {
  if (active_encounter == 0) return;
  top.window.parent.Title.document.getElementById('current_encounter').innerHTML="<b><?php echo htmlspecialchars( xl('None'), ENT_QUOTES) ?></b>";
  active_encounter = 0;
  encounter_locked = false;
  reloadEncounter('');
  syncRadios();
 }
function removeOptionSelected(EncounterId)
{//Removes an item from the Encounter drop down.
	var elSel = top.window.parent.Title.document.getElementById('EncounterHistory');
	var i;
	for (i = elSel.length - 1; i>=2; i--) {
	 EncounterHistoryValue=elSel.options[i].value;
	 EncounterHistoryValueArray=EncounterHistoryValue.split('~');
		if (EncounterHistoryValueArray[0]==EncounterId) {
			elSel.remove(i);
		}
	}
}

 // You can call this to make sure the session pid is what we expect.
 function pidSanityCheck(pid) {
  if (pid != active_pid) {
   alert('Session patient ID is ' + pid + ', expecting ' + active_pid +
    '. This session is unstable and should be abandoned. Do not use ' +
    'OpenEMR in multiple browser windows!');
   return false;
  }
  return true;
 }

 // You can call this to make sure the session encounter is what we expect.
 function encounterSanityCheck(eid) {
  if (eid != active_encounter) {
   alert('Session encounter ID is ' + eid + ', expecting ' + active_encounter +
    '. This session is unstable and should be abandoned. Do not use ' +
    'OpenEMR in multiple browser windows!');
   return false;
  }
  return true;
 }

 // Pop up a report.
 function repPopup(aurl) {
  top.restoreSession();
  window.open('<?php echo "$web_root/interface/reports/" ?>' + aurl, '_blank', 'width=900,height=650,resizable=1,scrollbars=1');
  return false;
 }

 // This is invoked to pop up some window when a popup item is selected.
 function selpopup(selobj) {
  var i = selobj.selectedIndex;
  var opt = selobj.options[i];
  if (i > 0) {
   var width  = 750;
   var height = 550;
   if (opt.text == 'Export' || opt.text == 'Import') {
    width  = 500;
    height = 400;
   }
   else if (opt.text == 'Refer') {
    width  = 700;
    height = 500;
   }
   dlgopen(opt.value, '_blank', width, height);
  }
  selobj.selectedIndex = 0;
 }
 <?php require_once($webserver_root."/ippf/menu/ippf_menu_additions.php"); ?>
// Treeview activation stuff:
$(document).ready(function(){
  if (typeof(setup_ippf_custom) == 'function') setup_ippf_custom();
  if(3 == <?php echo $GLOBALS['concurrent_layout'] ?>){
    $("#navigation-slide > li > a.collapsed + ul").slideToggle("medium");
    $("#navigation-slide > li > ul > li > a.collapsed_lv2 + ul").slideToggle("medium");
    $("#navigation-slide > li > ul > li > ul > li > a.collapsed_lv3 + ul").slideToggle("medium");
    $("#navigation-slide > li > a.expanded").click(function() {
      $("#navigation-slide > li > a.expanded").not(this).toggleClass("expanded").toggleClass("collapsed").parent().find('> ul').slideToggle("medium");
      $(this).toggleClass("expanded").toggleClass("collapsed").parent().find('> ul').slideToggle("medium");
    });
    $("#navigation-slide > li > a.collapsed").click(function() {
      $("#navigation-slide > li > a.expanded").not(this).toggleClass("expanded").toggleClass("collapsed").parent().find('> ul').slideToggle("medium");
      $(this).toggleClass("expanded").toggleClass("collapsed").parent().find('> ul').slideToggle("medium");
    });
    $("#navigation-slide > li  > ul > li > a.expanded_lv2").click(function() {
      $("#navigation-slide > li > a.expanded").next("ul").find("li > a.expanded_lv2").not(this).toggleClass("expanded_lv2").toggleClass("collapsed_lv2").parent().find('> ul').slideToggle("medium");
      $(this).toggleClass("expanded_lv2").toggleClass("collapsed_lv2").parent().find('> ul').slideToggle("medium");
    });
    $("#navigation-slide > li  > ul > li  > ul > li > a.expanded_lv3").click(function() {
      $("#navigation-slide > li > ul > li > a.expanded").next("ul").find("li > a.expanded_lv3").not(this).toggleClass("expanded_lv3").toggleClass("collapsed_lv3").parent().find('> ul').slideToggle("medium");
      $(this).toggleClass("expanded_lv3").toggleClass("collapsed_lv3").parent().find('> ul').slideToggle("medium");
    });
    $("#navigation-slide > li  > ul > li > a.collapsed_lv2").click(function() {
      $("#navigation-slide > li > a.expanded").next("ul").find("li > a.expanded_lv2").not(this).toggleClass("expanded_lv2").toggleClass("collapsed_lv2").parent().find('> ul').slideToggle("medium");
      $(this).toggleClass("expanded_lv2").toggleClass("collapsed_lv2").parent().find('> ul').slideToggle("medium");
    });
    $("#navigation-slide > li  > ul > li  > ul > li > a.collapsed_lv3").click(function() {
      $("#navigation-slide > li  > ul > li > a.expanded").next("ul").find("li > a.expanded_lv3").not(this).toggleClass("expanded_lv3").toggleClass("collapsed_lv3").parent().find('> ul').slideToggle("medium");
      $(this).toggleClass("expanded_lv2").toggleClass("collapsed_lv2").parent().find('> ul').slideToggle("medium");
    });
    $("#navigation-slide > li > ul > li > ul > li> a.collapsed_lv2 + ul").slideToggle("medium");    
    $("#navigation-slide > li > ul > li > ul > li> a.collapsed_lv2").click(function() {
      //$("#navigation-slide > li > a.expanded").next("ul").find("li > a.expanded_lv2").not(this).toggleClass("expanded_lv2").toggleClass("collapsed_lv2").parent().find('> ul').slideToggle("medium");
      // Need to figure out how to toggle 3rd level siblings correctly, but this works for now.
      $(this).toggleClass("expanded_lv2").toggleClass("collapsed_lv2").parent().find('> ul').slideToggle("medium");
    });    
    $("#navigation-slide > li > ul > li > ul > li > ul > li > a.collapsed_lv3 + ul").slideToggle("medium");    
    $("#navigation-slide > li > ul > li > ul > li > ul > li > a.collapsed_lv3").click(function() {
      $(this).toggleClass("expanded_lv3").toggleClass("collapsed_lv3").parent().find('> ul').slideToggle("medium");
    });    
    $("#navigation-slide > li  > a#cal0").prepend('<img src="../../images/calendar.png" class="nav-menu-img" />');
    $("#navigation-slide > li  > a#pfb0").prepend('<img src="../../images/pfb.png" class="nav-menu-img" />');
    $("#navigation-slide > li  > a#msg0").prepend('<img src="../../images/messages.png" class="nav-menu-img" />');
    $("#navigation-slide > li  > a#patimg").prepend('<img src="../../images/patient.png" class="nav-menu-img" />');
    $("#navigation-slide > li  > a#app0").prepend('<img src="../../images/patient.png" class="nav-menu-img" />');
    $("#navigation-slide > li  > a#repimg").prepend('<img src="../../images/reports.png" class="nav-menu-img" />');
    $("#navigation-slide > li  > a#feeimg").prepend('<img src="../../images/fee.png" class="nav-menu-img" />');
    $("#navigation-slide > li  > a#adm0").prepend('<img src="../../images/inventory.png" class="nav-menu-img" />');
    $("#navigation-slide > li  > a#invimg").prepend('<img src="../../images/inventory.png" class="nav-menu-img" />');
    $("#navigation-slide > li  > a#admimg").prepend('<img src="../../images/admin.png" class="nav-menu-img" />');
    $("#navigation-slide > li  > a#misimg").prepend('<img src="../../images/misc.png" class="nav-menu-img" />');
    $("#navigation-slide > li  > a#proimg").prepend('<img src="../../images/procedures.png" class="nav-menu-img" />');
    $("#navigation-slide > li").each(function(index) {
      if($(" > ul > li", this).size() == 0){
        $(" > a", this).addClass("collapsed");
      }
    });
  }else if(2 == <?php echo $GLOBALS['concurrent_layout'] ?>){

    //Remove the links (used by the sliding menu) that will break treeview
    $('a.collapsed').each(function() { $(this).replaceWith('<span>'+$(this).text()+'</span>'); });
    $('a.collapsed_lv2').each(function() { $(this).replaceWith('<span>'+$(this).text()+'</span>'); });
    $('a.collapsed_lv3').each(function() { $(this).replaceWith('<span>'+$(this).text()+'</span>'); });
    $('a.expanded').each(function() { $(this).replaceWith('<span>'+$(this).text()+'</span>'); });
    $('a.expanded_lv2').each(function() { $(this).replaceWith('<span>'+$(this).text()+'</span>'); });
    $('a.expanded_lv3').each(function() { $(this).replaceWith('<span>'+$(this).text()+'</span>'); });

    // Initiate treeview
    $("#navigation").treeview({
     animated: "fast",
     collapsed: true,
     unique: <?php echo $GLOBALS['athletic_team'] ? 'false' : 'true' ?>,
     toggle: function() {
      window.console && console.log("%o was toggled", this);
     }
    });
  }
});

</script>

</head>

<body class="body_nav">

<form method='post' name='find_patient' target='RTop'
 action='<?php echo $rootdir ?>/main/finder/patient_select.php'>

<?php
// Find widget is at the top for the athletic team layout.
if ($GLOBALS['athletic_team']) {
  genFindBlock();
  echo "<hr />\n";
}
?>

<?php if ( ( $GLOBALS['concurrent_layout'] == 2) || ($GLOBALS['concurrent_layout'] == 3) ) { ?>
<center>
<select name='sel_frame' style='background-color:transparent;font-size:9pt;width:<?php echo $GLOBALS['athletic_team'] ? 47 : 100; ?>%;'>
 <option value='0'><?php xl('Default','e'); ?></option>
 <option value='1'><?php xl('Top','e'); ?></option>
 <option value='2'><?php xl('Bottom','e'); ?></option>
</select>
<?php if ($GLOBALS['athletic_team']) genPopupsList('width:47%'); ?>
</center>

<table cellpadding='0' cellspacing='0' border='0' width='100%'>
 <tr>
  <td class='smalltext' nowrap>
   <input type='checkbox' name='cb_top' onclick='toggleFrame(1)' checked />
   <b><?php xl('Top','e') ?></b>
  </td>
  <td class='smalltext' align='right' nowrap>
   <b><?php xl('Bot','e') ?></b>
   <input type='checkbox' name='cb_bot' onclick='toggleFrame(2)' <?php if (empty($GLOBALS['athletic_team'])) echo 'checked '; ?>/>
  </td>
 </tr>
</table>

<?php if ( $GLOBALS['concurrent_layout'] == 3) { ?>
  <ul id="navigation-slide">
<?php } else { // ($GLOBALS['concurrent_layout'] == 2) ?>
  <ul id="navigation">
<?php } ?>

  <?php if (!$GLOBALS['disable_calendar'] && !$GLOBALS['ippf_specific']) genTreeLink('RTop','cal',xl('Calendar')); ?>
  <?php if (!$GLOBALS['disable_pat_trkr'] && !$GLOBALS['disable_calendar']) genTreeLink('RTop','pfb',xl('Flow Board')); ?>
  <?php genTreeLink('RBot','msg',xl('Messages')); ?> 
  <?php if ($GLOBALS['lab_exchange_enable']) genTreeLink('RTop', 'lab', xl('Check Lab Results'));?>
  <?php if($GLOBALS['portal_offsite_enable'] && $GLOBALS['portal_offsite_address'] && acl_check('patientportal','portal'))  genTreeLink('RTop','app',xl('Portal Activity')); ?>
  <li class="open"><a class="expanded" id="patimg" ><span><?php xl('Patient/Client','e') ?></span></a>
    <ul>
      <?php genMiscLink('RTop','fin','0',xl('Patients'),'main/finder/dynamic_finder.php'); ?>
      <?php genTreeLink('RTop','new',($GLOBALS['full_new_patient_form'] ? xl('New/Search') : xl('New'))); ?>
      <?php genTreeLink('RTop','dem',xl('Summary')); ?>
      <li class="open"><a class="expanded_lv2"><span><?php xl('Visits','e') ?></span></a>
        <ul>
          <?php if ($GLOBALS['ippf_specific'] && !$GLOBALS['disable_calendar']) genTreeLink('RTop','cal',xl('Calendar')); ?>
          <?php genTreeLink('RBot','nen',xl('Create Visit')); ?>
          <?php genTreeLink('RBot','enc',xl('Current')); ?>
          <?php genTreeLink('RBot','ens',xl('Visit History')); ?>
          <?php genTreeLink('RBot','ref',xl('Referrals')); ?>
        </ul>
      </li>

      <li><a class="collapsed_lv2"><span><?php xl('Records','e') ?></span></a>
        <ul>
          <?php genTreeLink('RTop','prq',xl('Patient Record Request')); ?>
        </ul>
      </li>

<?php if ($GLOBALS['gbl_nav_visit_forms']) { ?>
      <li><a class="collapsed_lv2"><span><?php xl('Visit Forms','e') ?></span></a>
        <ul>
<?php
  // Generate the items for visit forms, both traditional and LBF.
  //
  $reglastcat = '';
  $regrows = getFormsByCategory(); // defined in register.inc
  foreach ($regrows as $entry) {
    $option_id = $entry['directory'];
    $title = trim($entry['nickname']);
    if ($option_id == 'fee_sheet' ) continue;
    if ($option_id == 'newpatient') continue;
    if (empty($title)) $title = $entry['name'];
    if ($entry['category'] != $reglastcat) {
      if ($reglastcat) echo "        </ul></li>\n";
      echo "        <li><a class='collapsed_lv3'><span>" . xlt($entry['category']) . "</span></a><ul>\n";
      $reglastcat = $entry['category'];
    }
    genMiscLink('RBot','enc','2', xl_form_title($title), $option_id, false, true);
  }
  if ($reglastcat) echo "        </ul></li>\n";
?>
        </ul>
      </li>
      <li class="collapsed" ><a class="collapsed_lv2"><span><?php echo xlt('Import') ?></span></a>
        <ul>
          <?php genMiscLink('RTop','ccr','0',xlt('Upload'),'patient_file/ccr_import.php'); ?>
          <?php genMiscLink('RTop','apr','0',xlt('Pending Approval'),'patient_file/ccr_pending_approval.php'); ?>
        </ul>
      </li>
<?php } // end if gbl_nav_visit_forms ?>

    </ul>
  </li>
  <?php // TajEmo Work by CB 2012/06/21 10:41:15 AM hides fees if disabled in globals ?>
  <?php if(!isset($GLOBALS['enable_fees_in_left_menu']) || $GLOBALS['enable_fees_in_left_menu'] == 1){ ?>
  <li><a class="collapsed" id="feeimg" ><span><?php xl('Fees','e') ?></span></a>
    <ul>
      <?php genMiscLink('RBot', 'cod', '2', xl('Fee Sheet'), 'fee_sheet', false, true); ?>
      <?php if ($GLOBALS['use_charges_panel']) genTreeLink('RBot','cod',xl('Charges')); ?>
      <?php genMiscLink('RBot','pay','1',xl('Payment'   ),'patient_file/front_payment.php?feat=1'); ?>
      <?php genMiscLink('RBot','pay','1',xl('Adjustment'),'patient_file/front_payment.php?feat=2'); ?>
      <?php // genMiscLink('RBot','pay','1',xl('Pay/Adjust'),'patient_file/front_payment.php?feat=3'); ?>
      <?php if (acl_check('admin', 'super') || acl_check('acct', 'bill') || acl_check('acct', 'disc'))
        genMiscLink('RBot','bil','1',xl('Checkout'),'patient_file/pos_checkout.php?framed=1'); ?> 
      <?php if (! $GLOBALS['simplified_demographics']) genTreeLink('RTop','bil',xl('Billing')); ?>
	  <?php genTreeLink('RTop','npa',xl('Batch Payments'),false,2);?>
      <?php if ($GLOBALS['enable_edihistory_in_left_menu'] && acl_check('acct', 'eob')) genTreeLink('RTop','edi',xl('EDI History'),false,2);?>
    </ul>
  </li>
  <?php } ?>
  <?php // if ($GLOBALS['inhouse_pharmacy'] && acl_check('admin', 'drugs')) genMiscLink('RTop','adm','0',xl('Inventory'),'drugs/drug_inventory.php'); ?>
<?php if ($auth_drug_management) { ?>
  <li><a class="collapsed" id="invimg" ><span><?php xl('Inventory','e') ?></span></a>
    <ul>
      <?php genMiscLink('RTop','adm','0',xl('Management'),'drugs/drug_inventory.php'); ?>
    </ul>
  </li>
<?php } ?>
  <li><a class="collapsed" id="proimg" ><span><?php xl('Procedures','e') ?></span></a>
    <ul>
      <?php genTreeLink('RTop','orl',xl('Providers')); ?>
      <?php genTreeLink('RTop','ort',xl('Configuration')); ?>
      <?php genTreeLink('RTop','orc',xl('Load Compendium')); ?>
      <?php genTreeLink('RTop','orp',xl('Pending Review')); ?>
      <?php genTreeLink('RTop','orr',xl('Patient Results')); ?>
      <?php genTreeLink('RTop','orb',xl('Batch Results')); ?>
      <?php genTreeLink('RTop','ore',xl('Electronic Reports')); ?>
    </ul>
  </li>
  <?php
  $newcrop_user_role=sqlQuery("select newcrop_user_role from users where username='".$_SESSION['authUser']."'");
  if($newcrop_user_role['newcrop_user_role'] && $GLOBALS['erx_enable']) { ?>
  <li><a class="collapsed" id="feeimg" ><span><?php xl('New Crop','e') ?></span></a>
    <ul>
      <li><a class="collapsed_lv2"><span><?php xl('Status','e') ?></span></a>
        <ul>
          <?php genTreeLink('RTop','erx',xl('e-Rx')); ?>
          <?php //genTreeLink('RTop','err',xl('e-Rx Renewal')); ?>
          <?php genMiscLink('RTop','err','0',xl('e-Rx Renewal'),'eRx.php?page=status'); ?>
        </ul>
      </li>
    </ul>
  </li>
  <?php } ?>
  <?php if (!$disallowed['adm']) { ?>
  <li><a class="collapsed" id="admimg" ><span><?php xl('Administration','e') ?></span></a>
    <ul>
      <?php if (acl_check('admin', 'super'    )) genMiscLink('RTop','adm','0',xl('Globals'),'super/edit_globals.php'); ?>
      <?php if (acl_check('admin', 'users'    )) genMiscLink('RTop','adm','0',xl('Facilities'),'usergroup/facilities.php'); ?>
      <?php if (acl_check('admin', 'users'    )) genMiscLink('RTop','adm','0',xl('Users'),'usergroup/usergroup_admin.php'); ?>
      <?php if (acl_check('admin', 'practice' )) genTreeLink('RTop','adb',xl('Addr Book')); ?>
      <?php
	  // Changed the target URL from practice settings -> Practice Settings - Pharmacy... Dec 09,09 .. Visolve ... This replaces empty frame with Pharmacy window
	  if (acl_check('admin', 'practice' )) genMiscLink('RTop','adm','0',xl('Practice'),'../controller.php?practice_settings&pharmacy&action=list'); ?>
      <?php if (acl_check('admin', 'superbill')) genTreeLink('RTop','sup',xl('Codes')); ?>
      <?php if (acl_check('admin', 'super'    )) genMiscLink('RTop','adm','0',xl('Layouts'),'super/edit_layout.php'); ?>
      <?php if (acl_check('admin', 'super'    )) genMiscLink('RTop','adm','0',xl('Lists'),'super/edit_list.php'); ?>
      <?php if (acl_check('admin', 'acl'      )) genMiscLink('RTop','adm','0',xl('ACL'),'usergroup/adminacl.php'); ?>
      <?php if (acl_check('admin', 'super'    )) genMiscLink('RTop','adm','0',xl('Files'),'super/manage_site_files.php'); ?>
      <?php if (acl_check('admin', 'super'    )) genMiscLink('RTop','adm','0',xl('Backup'),'main/backup.php'); ?>
      <?php if (acl_check('admin', 'super'    ) && $GLOBALS['enable_cdr']) genMiscLink('RTop','adm','0',xl('Rules'),'super/rules/index.php?action=browse!list'); ?>
      <?php if (acl_check('admin', 'super'    ) && $GLOBALS['enable_cdr']) genMiscLink('RTop','adm','0',xl('Alerts'),'super/rules/index.php?action=alerts!listactmgr'); ?>
      <?php if (acl_check('admin', 'super'    ) && $GLOBALS['enable_cdr']) genMiscLink('RTop','adm','0',xl('Patient Reminders'),'patient_file/reminder/patient_reminders.php?mode=admin&patient_id='); ?>
      <?php if ( ($GLOBALS['include_de_identification']) && (acl_check('admin', 'super'    )) ) genMiscLink('RTop','adm','0',xl('De Identification'),'de_identification_forms/de_identification_screen1.php'); ?>
          <?php if ( ($GLOBALS['include_de_identification']) && (acl_check('admin', 'super'    )) ) genMiscLink('RTop','adm','0',xl('Re Identification'),'de_identification_forms/re_identification_input_screen.php'); ?>
      <?php
        if (acl_check('admin', 'super') && (!empty($GLOBALS['code_types']['IPPF']) || !empty($GLOBALS['code_types']['IPPF2']))) {
          genMiscLink('RTop','adm','0',xl('Legacy Export'),'main/ippf_export.php');
          genMiscLink('RTop','adm','0',xl('Export for data.ippf.org'),'reports/ippf_dhis2_export.php');
          genMiscLink('RTop','adm','0',xl('Export GCACI/CCSPT'),'reports/ippf_indicators_export.php');
        }
      ?>
      <li><a class="collapsed_lv2"><span><?php xl('Other','e') ?></span></a>
        <ul>
          <?php if (acl_check('admin', 'language')) genMiscLink('RTop','adm','0',xl('Language'),'language/language.php'); ?>
          <?php if (acl_check('admin', 'language')) genMiscLink('RTop','adm','0',xl('Translation CSV'),'../ippf/translation/csv/load_csv_file.php'); ?>         
          <?php if (acl_check('admin', 'forms'   )) genMiscLink('RTop','adm','0',xl('Forms'),'forms_admin/forms_admin.php'); ?>
          <?php if (acl_check('admin', 'calendar') && !$GLOBALS['disable_calendar']) genMiscLink('RTop','adm','0',xl('Calendar'),'main/calendar/index.php?module=PostCalendar&type=admin&func=modifyconfig'); ?>
          <?php if (acl_check('admin', 'users'   )) genMiscLink('RTop','adm','0',xl('Logs'),'logview/logview.php'); ?>
          <?php
          if($newcrop_user_role['newcrop_user_role'] || $GLOBALS['erx_enable']) {
            if (acl_check('admin', 'users'   )) genMiscLink('RTop','adm','0',xl('eRx Logs'),'logview/erx_logview.php');
          }
          ?>
          <?php if ( (!$GLOBALS['disable_phpmyadmin_link']) && (acl_check('admin', 'database')) ) genMiscLink('RTop','adm','0',xl('Database'),'../phpmyadmin/index.php'); ?>
          <?php if (acl_check('admin', 'users'   )) genMiscLink('RTop','adm','0',xl('Certificates'),'usergroup/ssl_certificates_admin.php'); ?>
          <?php if (acl_check('admin', 'super'   )) genMiscLink('RTop','adm','0',xl('Native Data Loads'),'../interface/super/load_codes.php'); ?>
          <?php if (acl_check('admin', 'super'   )) genMiscLink('RTop','adm','0',xl('External Data Loads'),'../interface/code_systems/dataloads_ajax.php'); ?>
          <?php if (acl_check('admin', 'super'   )) genMiscLink('RTop','adm','0',xl('Merge Patients'),'patient_file/merge_patients.php'); ?>
          <?php if (acl_check('admin', 'super'   )) genMiscLink('RTop','adm','0',xl('Manage Duplicates'),'patient_file/manage_dup_patients.php'); ?>
          <?php if (acl_check('admin', 'super'   )) genMiscLink('RTop','adm','0',xl('Layout Service Codes'),'super/layout_service_codes.php'); ?>
        </ul>
      </li>
    </ul>
  </li>
  <?php } ?>
  <li><a class="collapsed" id="repimg" ><span><?php xl('Reports','e') ?></span></a>
    <ul>
      <li><a class="collapsed_lv2"><span><?php xl('Clients','e') ?></span></a>
        <ul>
          <?php genMiscLink('RTop','rep','0',xl('List'),'reports/patient_list.php'); ?>
          <?php if (acl_check('patients', 'med') && !$GLOBALS['disable_prescriptions']) genMiscLink('RTop','rep','0',xl('Rx'),'reports/prescriptions_report.php'); ?>
          <?php if (acl_check('patients', 'med')) genMiscLink('RTop','rep','0',xl('Clinical'),'reports/clinical_reports.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Referrals'),'reports/referrals_report.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Immunization Registry'),'reports/immunization_report.php'); ?>
        </ul>
      </li>
      <li><a class="collapsed_lv2"><span><?php xl('Clinic','e') ?></span></a>
        <ul>
          <?php if ($GLOBALS['enable_cdr'] || $GLOBALS['enable_cqm']  || $GLOBALS['enable_amc']) genMiscLink('RTop','rep','0',xl('Report Results'),'reports/report_results.php'); ?>
          <?php if ($GLOBALS['enable_cdr']) genMiscLink('RTop','rep','0',xl('Standard Measures'),'reports/cqm.php?type=standard'); ?>
          <?php if ($GLOBALS['enable_cqm']) genMiscLink('RTop','rep','0',xl('Quality Measures (CQM)'),'reports/cqm.php?type=cqm'); ?>
          <?php if ($GLOBALS['enable_amc']) genMiscLink('RTop','rep','0',xl('Automated Measures (AMC)'),'reports/cqm.php?type=amc'); ?>
          <?php if ($GLOBALS['enable_amc_tracking']) genMiscLink('RTop','rep','0',xl('AMC Tracking'),'reports/amc_tracking.php'); ?>
        </ul>
      </li>
      <li><a class="collapsed_lv2"><span><?php xl('Visits','e') ?></span></a>
        <ul>
          <?php if (!$GLOBALS['disable_calendar']) genMiscLink('RTop','rep','0',xl('Appointments'),'reports/appointments_report.php'); ?>
          <?php if (!$GLOBALS['disable_pat_trkr'] && !$GLOBALS['disable_calendar']) genMiscLink('RTop','rep','0',xl('Patient Flow Board'),'reports/patient_flow_board_report.php'); ?>          
          <?php  genMiscLink('RTop','rep','0',xl('Encounters'),'reports/encounters_report.php'); ?>
          <?php if (!$GLOBALS['disable_calendar'] && acl_check('patients', 'appt') && acl_check('acct', 'rep_a')) {
           genMiscLink('RTop','rep','0',xl('Appt-Enc'),'reports/appt_encounter_report.php');
          } ?>
          <?php if (empty($GLOBALS['code_types']['IPPF']) && empty($GLOBALS['code_types']['IPPF2'])) {
            genMiscLink('RTop','rep','0',xl('Superbill'),'reports/custom_report_range.php');
          } ?>
          <?php genMiscLink('RTop','rep','0',xl('Eligibility'),'reports/edi_270.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Eligibility Response'),'reports/edi_271.php'); ?>
          <?php if (!$GLOBALS['disable_chart_tracker']) genMiscLink('RTop','rep','0',xl('Chart Activity'),'reports/chart_location_activity.php'); ?>
          <?php if (!$GLOBALS['disable_chart_tracker']) genMiscLink('RTop','rep','0',xl('Charts Out'),'reports/charts_checked_out.php'); ?>
          <?php if (acl_check('acct', 'rep_a')) {
            genMiscLink('RTop','rep','0',xl('Services'), 'reports/services_by_category.php');
          } ?>
          <?php genMiscLink('RTop','rep','0',xl('Syndromic Surveillance'),'reports/non_reported.php'); ?>
          <?php if ($GLOBALS['gbl_menu_shifts']) genPopLink(xl('Shifts Report'),'shifts_report.php'); ?>
          <?php if (acl_check('acct', 'rep_a')) {
            genMiscLink('RTop','rep','0',xl('Ad Hoc Services'), 'reports/ad_hoc_services.php');
          } ?>
        </ul>
      </li>
<?php if (acl_check('acct', 'rep_a')) { ?>
      <li><a class="collapsed_lv2"><span><?php xl('Financial','e') ?></span></a>
        <ul>
          <?php genMiscLink('RTop','rep','0',xl('Sales'),'reports/sales_by_item.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Cash Rec'), 'billing/sl_receipts_report.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Svcs by Prov'), 'reports/services_by_provider.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Front Rec'), 'reports/front_receipts_report.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Rec Summary'), 'reports/receipts_by_method_report.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Rec/Inv by Pay Methods'), 'reports/methods_by_invoice.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Collections'), 'reports/collections_report.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Financial Summary by Service Code'),'reports/svc_code_financial_report.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Peachtree Export'),'reports/export_accounting_transactions.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('NetSuite Export'),'reports/netsuite_export.php'); ?>
          <?php if (!empty($GLOBALS['code_types']['SOBJ'])) genMiscLink('RTop','rep','0',xl('NetSuite Mapping'),'reports/netsuite_mapping.php'); ?>
          <?php if ($GLOBALS['gbl_menu_projects']) {
            genMiscLink('RTop','rep','0',xl('Projects'),'reports/restricted_projects_report.php');
          } ?>
          <?php if ($GLOBALS['gbl_menu_surinam_insurance']) {
            genMiscLink('RTop','rep','0',xl('LOBI Insurers Report'),'reports/surinam_insurance_report.php');
          } ?>
          <?php genMiscLink('RTop','rep','0',xl('Visit Voids and Changes'), 'reports/reopened_visits_report.php'); ?>
        </ul>
      </li>
<?php } ?>
<?php if ($auth_drug_reports) { ?>
      <li><a class="collapsed_lv2"><span><?php xl('Inventory','e') ?></span></a>
        <ul>
          <?php genMiscLink('RTop','rep','0',xl('List'),'reports/inventory_list.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Activity'),'reports/inventory_activity.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Transactions'),'reports/inventory_transactions.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Price List'),'reports/inventory_templates.php'); ?>            
          <?php genMiscLink('RTop','rep','0',xl('Destroyed'),'reports/destroyed_drugs_report.php'); ?>            
        </ul>
      </li>
<?php } ?>
      <li><a class="collapsed_lv2"><span><?php xl('Procedures','e') ?></span></a>
        <ul>
          <?php genPopLink(xl('Pending Res'),'../orders/pending_orders.php'); ?>
          <?php if (!empty($GLOBALS['code_types']['IPPF'])) genPopLink(xl('Pending F/U'),'../orders/pending_followup.php'); ?>
          <?php genPopLink(xl('Statistics'),'../orders/procedure_stats.php'); ?>
        </ul>
      </li>
<?php if (! $GLOBALS['simplified_demographics']) { ?>
      <li><a class="collapsed_lv2"><span><?php xl('Insurance','e') ?></span></a>
        <ul>
          <?php genMiscLink('RTop','rep','0',xl('Distribution'),'reports/insurance_allocation_report.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Indigents'),'billing/indigent_patients_report.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Unique SP'),'reports/unique_seen_patients_report.php'); ?>
        </ul>
      </li>
<?php } ?>
<?php if (!empty($GLOBALS['code_types']['IPPF2']) && acl_check('acct', 'rep_a')) { ?>
      <li><a class="collapsed_lv2"><span><?php xl('Statistics','e') ?></span></a>
        <ul>
          <?php if ($GLOBALS['gbl_menu_stats_ippf' ]) genPopLink(xl('IPPF Stats'),'ippf_statistics_2.php?t=i'); ?>
          <?php if ($GLOBALS['gbl_menu_stats_gcac' ]) genPopLink(xl('GCAC Stats'),'ippf_statistics_2.php?t=g'); ?>
          <?php if ($GLOBALS['gbl_menu_stats_ma'   ]) genPopLink(xl('MA Stats'  ),'ippf_statistics_2.php?t=m'); ?>
          <?php if ($GLOBALS['gbl_menu_stats_cc'   ]) genPopLink(xl('CCSPT'     ),'cervical_cancer.php'); ?>
          <?php if ($GLOBALS['gbl_menu_stats_cyp'  ]) genPopLink(xl('CYP'),'ippf_cyp_report.php'); ?>
          <?php if ($GLOBALS['gbl_menu_stats_daily']) genPopLink(xl('Daily Record'),'ippf_daily.php'); ?>
          <?php if ($GLOBALS['gbl_menu_stats_c3'   ]) genPopLink(xl('C3'),'ippf_c3.php'); ?>
          <?php if ($GLOBALS['gbl_menu_stats_sinadi']) genPopLink(xl('SINADI'   ),'uruguay_sinadi.php'); ?>
          <?php if ($GLOBALS['gbl_menu_ive_clients']) genPopLink(xl('IVE Client List'),'ive_client_list.php'); ?>
          <?php if ($GLOBALS['gbl_menu_service_and_client_volume']) genPopLink(xl('Service and Client Volume'),'visits/visits_report.php'); ?>
          <?php if (!empty($GLOBALS['code_types']['REPORT'])) genPopLink(xl('Visits by Item'),'famp_services_products_visits.php'); ?>
<?php if (!empty($GLOBALS['code_types']['IPPF'])) { ?>
            <li><a class="collapsed_lv2"><span><?php xl('Legacy Statistics','e') ?></span></a>
            <ul>
              <?php if ($GLOBALS['gbl_menu_stats_ippf' ]) genPopLink(xl('IPPF Stats'),'ippf_statistics.php?t=i'); ?>
              <?php if ($GLOBALS['gbl_menu_stats_gcac' ]) genPopLink(xl('GCAC Stats'),'ippf_statistics.php?t=g'); ?>
              <?php if ($GLOBALS['gbl_menu_stats_ma'   ]) genPopLink(xl('MA Stats'  ),'ippf_statistics.php?t=m'); ?>
            </ul>
          </li>
<?php } ?>
        </ul>
      </li>
<?php } // end ippf-specific and financial reporting permission ?>
      <li><a class="collapsed_lv2"><span><?php xl('Blank Forms','e') ?></span></a>
        <ul>
<?php
  echo "        <li><a class='collapsed_lv3'><span>" . xlt('Core') . "</span></a><ul>\n";
  genPopLink(xl('Demographics'),'../patient_file/summary/demographics_print.php');
  genPopLink(xl('Superbill/Fee Sheet'),'../patient_file/printed_fee_sheet.php');
  // genPopLink(xl('Referral'),'../patient_file/transaction/print_referral.php');
  echo "        </ul></li>\n";

  // Generate the blank form items for LBF visit forms.
  //
  $reglastcat = '';
  $regrows = getFormsByCategory('1', true); // defined in register.inc
  foreach ($regrows as $entry) {
    $option_id = $entry['directory'];
    $title = trim($entry['nickname']);
    if (empty($title)) $title = $entry['name'];
    if ($entry['category'] != $reglastcat) {
      if ($reglastcat) echo "        </ul></li>\n";
      echo "        <li><a class='collapsed_lv3'><span>" . xlt($entry['category']) . "</span></a><ul>\n";
      $reglastcat = $entry['category'];
    }
    genPopLink(xl_form_title($title), "../forms/LBF/printable.php?formname=" . urlencode($option_id) . "&isform=1");
  }
  if ($reglastcat) echo "        </ul></li>\n";
?>
        </ul>
      </li>
    <?php if (acl_check('admin','super')) { ?>
      <li><a class="collapsed_lv2"><span><?php echo xlt('Services') ?></span></a>
        <ul>
          <?php genMiscLink('RTop','rep','0',xl('Background Services'),'reports/background_services.php'); ?>
          <?php genMiscLink('RTop','rep','0',xl('Direct Message Log'),'reports/direct_message_log.php'); ?>
        </ul>
      </li>
    <?php } ?>

      <?php // genTreeLink('RTop','rep','Other'); ?>
    </ul>
  </li>
  <li><a class="collapsed" id="misimg" ><span><?php xl('Miscellaneous','e') ?></span></a>
    <ul>
      <?php genTreeLink('RTop','ped',xl('Patient Education')); ?> 
      <?php genTreeLink('RBot','aun',xl('Authorizations')); ?>
      <?php genTreeLink('RTop','fax',xl('Fax/Scan')); ?>
      <?php genTreeLink('RTop','adb',xl('Addr Book')); ?>
      <?php genTreeLink('RTop','ort',xl('Order Catalog')); ?>
      <?php if (!$GLOBALS['disable_chart_tracker']) genTreeLink('RTop','cht',xl('Chart Tracker')); ?>
      <?php genTreeLink('RTop','ono',xl('Ofc Notes')); ?>
      <?php genMiscLink('RTop','adm','0',xl('BatchCom'),'batchcom/batchcom.php'); ?>
      <?php genMiscLink('RTop','adm','0',xl('Auto Writeoff'),'billing/auto_writeoff.php'); ?>
      <?php genTreeLink('RTop','pwd',xl('Password')); ?>
      <?php genTreeLink('RTop','seq',xl('MFA Management')); ?>
      <?php genMiscLink('RTop','prf','0',xl('Preferences'),'super/edit_globals.php?mode=user'); ?>
      <?php if(acl_check('patients','docs')) genMiscLink('RTop','adm','0',xl('New Documents'),'../controller.php?document&list&patient_id=00'); ?>
      <?php if (acl_check('patients','docs')) genMiscLink('RTop','adm','0',xl('Document Templates'),'super/manage_document_templates.php'); ?>
    </ul>
  </li>

</ul>

<?php } else { // end ($GLOBALS['concurrent_layout'] == 2 || $GLOBALS['concurrent_layout'] == 3) ?>

<table cellpadding='0' cellspacing='0' border='0'>
 <tr>
  <td colspan='3'>
   <table cellpadding='0' cellspacing='0' border='0' width='100%'>
    <tr>
     <td class='smalltext' nowrap>
      <input type='checkbox' name='cb_top' onclick='toggleFrame(1)' checked /><b><?php xl('Top','e') ?></b>
     </td>
     <td class='smalltext' align='right' nowrap>
      <b><?php xl('Bot','e') ?></b><input type='checkbox' name='cb_bot' onclick='toggleFrame(2)' checked />
     </td>
    </tr>
   </table>
  </td>
 </tr>
<?php
 // Builds the table of radio buttons and their labels.  Radio button values
 // are comprised of the 3-character document id and the 1-digit usage type,
 // so that JavaScript can easily access this information.
 $default_top_rbid = $GLOBALS['athletic_team'] ? 'ros' : 'cal';
 foreach ($primary_docs as $key => $varr) {
  if (!empty($disallowed[$key])) continue;
  $label = $varr[0];
  $usage = $varr[1];
  $url   = $varr[2];
  echo " <tr>\n";
  echo "  <td class='smalltext'><input type='radio' name='rb_top' value='$key$usage' " .
       "onclick=\"loadFrame('$key$usage','RTop','$url')\"";
  if ($key == $default_top_rbid) echo " checked";
  echo " /></td>\n";
  echo "  <td class='smalltext' id='lbl_$key'>$label</td>\n";
  echo "  <td class='smalltext'><input type='radio' name='rb_bot' value='$key$usage' " .
       "onclick=\"loadFrame('$key$usage','RBot','$url')\"";
  if ($key == 'msg') echo " checked";
  echo " /></td>\n";
  echo " </tr>\n";
 }
?>
</table>

<?php } ?>

<br /><hr />

<?php
 // To use RelayHealth, see comments and parameters in includes/config.php.
 if (!empty($GLOBALS['ssi']['rh'])) {
  include_once("../../library/ssi.inc");
  echo getRelayHealthLink() ."<br /><hr />\n";
 }
?>

<div id='current_patient' style = 'display:none'>
<b><?php xl('None','e'); ?></b>
</div>

<div id='current_encounter' style = 'display:none'>
<b><?php xl('None','e'); ?></b>
</div>

<?php
if (!$GLOBALS['athletic_team']) {
  genPopupsList();
  echo "<hr />\n";
  genFindBlock();
  echo "<hr />\n";
}
?>

<?php if (!empty($GLOBALS['online_support_link'])) { ?>
<a href='<?php echo $GLOBALS["online_support_link"]; ?>' target="_blank" id="support_link" class='css_button' onClick="top.restoreSession()"><span><?php xl('Online Support','e'); ?></span></a>
<?php } ?>

<input type='hidden' name='findBy' value='Last' />
<input type="hidden" name="searchFields" id="searchFields"/>
<input type="hidden" name="search_service_code" value='' />

</form>

<script language='JavaScript'>
syncRadios();
</script>

</body>
</html>
