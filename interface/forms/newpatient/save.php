<?php
/**
 * Encounter form save script.
 *
 * LICENSE: This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://opensource.org/licenses/gpl-license.php>;.
 *
 * @package OpenEMR
 * @author  Brady Miller <brady@sparmy.com>
 * @link    http://www.open-emr.org
 */

$fake_register_globals=false;
$sanitize_all_escapes=true;

require_once("../../globals.php");
require_once("$srcdir/forms.inc");
require_once("$srcdir/sql.inc");
require_once("$srcdir/encounter.inc");
require_once("$srcdir/acl.inc");
require_once("$srcdir/formatting.inc.php");
require_once("$srcdir/formdata.inc.php");

$date             = (isset($_POST['form_date']))            ? $_POST['form_date'] : '';
$onset_date       = (isset($_POST['form_onset_date']))      ? $_POST['form_onset_date'] : '';
$sensitivity      = (isset($_POST['form_sensitivity']))     ? $_POST['form_sensitivity'] : '';
$pc_catid         = (isset($_POST['pc_catid']))             ? $_POST['pc_catid'] : '';
$facility_id      = (isset($_POST['facility_id']))          ? $_POST['facility_id'] : '';
$billing_facility = (isset($_POST['billing_facility']))     ? $_POST['billing_facility'] : '';
$reason           = (isset($_POST['reason']))               ? $_POST['reason'] : '';
$mode             = (isset($_POST['mode']))                 ? $_POST['mode'] : '';
$referral_source  = (isset($_POST['form_referral_source'])) ? $_POST['form_referral_source'] : '';
$shift            = (isset($_POST['form_shift']))           ? $_POST['form_shift'] : '';
$voucher_number   = (isset($_POST['form_voucher_number']))  ? $_POST['form_voucher_number'] : '';

$facilityresult = sqlQuery("select name FROM facility WHERE id = ?", array($facility_id));
$facility = $facilityresult['name'];

if ($GLOBALS['concurrent_layout'])
  $normalurl = "patient_file/encounter/encounter_top.php";
else
  $normalurl = "$rootdir/patient_file/encounter/patient_encounter.php";

$nexturl = $normalurl;

if ($mode == 'new')
{
  $provider_id = $userauthorized ? $_SESSION['authUserID'] : 0;
  $encounter = generate_id();
  addForm($encounter, "New Patient Encounter",
    sqlInsert("INSERT INTO form_encounter SET " .
      "date = '" . add_escape_custom($date) . "', " .
      "onset_date = '" . add_escape_custom($onset_date) . "', " .
      "reason = '" . add_escape_custom($reason) . "', " .
      "facility = '" . add_escape_custom($facility) . "', " .
      "pc_catid = '" . add_escape_custom($pc_catid) . "', " .
      "facility_id = '" . add_escape_custom($facility_id) . "', " .
      "billing_facility = '" . add_escape_custom($billing_facility) . "', " .
      "sensitivity = '" . add_escape_custom($sensitivity) . "', " .
      "referral_source = '" . add_escape_custom($referral_source) . "', " .
      "shift = '" . add_escape_custom($shift) . "', " .            
      "voucher_number = '" . add_escape_custom($voucher_number) . "', " .            
      "pid = '" . add_escape_custom($pid) . "', " .
      "encounter = '" . add_escape_custom($encounter) . "', " .
      "provider_id = '" . add_escape_custom($provider_id) . "'"),
    "newpatient", $pid, $userauthorized, $date);
}
else if ($mode == 'update')
{
  $id = $_POST["id"];
  $result = sqlQuery("SELECT encounter, sensitivity FROM form_encounter WHERE id = ?", array($id));
  if ($result['sensitivity'] && !acl_check('sensitivities', $result['sensitivity'])) {
   die(xlt("You are not authorized to see this encounter."));
  }
  $encounter = $result['encounter'];
  // See view.php to allow or disallow updates of the encounter date.
  $datepart = acl_check('encounters', 'date_a') ? "date = '" . add_escape_custom($date) . "', " : "";
  sqlStatement("UPDATE form_encounter SET " .
    $datepart .
    "onset_date = '" . add_escape_custom($onset_date) . "', " .
    "reason = '" . add_escape_custom($reason) . "', " .
    "facility = '" . add_escape_custom($facility) . "', " .
    "pc_catid = '" . add_escape_custom($pc_catid) . "', " .
    "facility_id = '" . add_escape_custom($facility_id) . "', " .
    "billing_facility = '" . add_escape_custom($billing_facility) . "', " .
    "sensitivity = '" . add_escape_custom($sensitivity) . "', " .
    "shift = '" . add_escape_custom($shift) . "', " .            
    "voucher_number = '" . add_escape_custom($voucher_number) . "', " .     
    "referral_source = '" . add_escape_custom($referral_source) . "' " .
    "WHERE id = '" . add_escape_custom($id) . "'");
}
else {
  die("Unknown mode '" . text($mode) . "'");
}

setencounter($encounter);

// Update the list of issues associated with this encounter.
sqlStatement("DELETE FROM issue_encounter WHERE " .
  "pid = ? AND encounter = ?", array($pid,$encounter) );
if (is_array($_POST['issues'])) {
  foreach ($_POST['issues'] as $issue) {
    $query = "INSERT INTO issue_encounter ( pid, list_id, encounter ) VALUES (?,?,?)";
    sqlStatement($query, array($pid,$issue,$encounter));
  }
}

// Custom for Chelsea FC.
//
if ($mode == 'new' && $GLOBALS['default_new_encounter_form'] == 'football_injury_audit') {

  // If there are any "football injury" issues (medical problems without
  // "illness" in the title) linked to this encounter, but no encounter linked
  // to such an issue has the injury form in it, then present that form.

  $lres = sqlStatement("SELECT list_id " .
    "FROM issue_encounter, lists WHERE " .
    "issue_encounter.pid = ? AND " .
    "issue_encounter.encounter = ? AND " .
    "lists.id = issue_encounter.list_id AND " .
    "lists.type = 'medical_problem' AND " .
    "lists.title NOT LIKE '%Illness%'", array($pid,$encounter));

  if (sqlNumRows($lres) > 0) {
    $nexturl = "patient_file/encounter/load_form.php?formname=" .
      $GLOBALS['default_new_encounter_form'];
    while ($lrow = sqlFetchArray($lres)) {
      $frow = sqlQuery("SELECT count(*) AS count " .
         "FROM issue_encounter, forms WHERE " .
         "issue_encounter.list_id = ? AND " .
         "forms.pid = issue_encounter.pid AND " .
         "forms.encounter = issue_encounter.encounter AND " .
         "forms.formdir = ?", array($lrow['list_id'],$GLOBALS['default_new_encounter_form']));
      if ($frow['count']) $nexturl = $normalurl;
    }
  }
}
$result4 = sqlStatement("SELECT fe.encounter,fe.date,openemr_postcalendar_categories.pc_catname FROM form_encounter AS fe ".
	" left join openemr_postcalendar_categories on fe.pc_catid=openemr_postcalendar_categories.pc_catid  WHERE fe.pid = ? order by fe.date desc", array($pid));
?>
<html>
<body>
<script language='JavaScript'>
<?php if ($GLOBALS['concurrent_layout'])
 {//Encounter details are stored to javacript as array.
?>
	EncounterDateArray=new Array;
	CalendarCategoryArray=new Array;
	EncounterIdArray=new Array;
	Count=0;
	 <?php
			   if(sqlNumRows($result4)>0)
				while($rowresult4 = sqlFetchArray($result4))
				 {
	?>
					EncounterIdArray[Count]='<?php echo attr($rowresult4['encounter']); ?>';
					EncounterDateArray[Count]='<?php echo attr(oeFormatShortDate(date("Y-m-d", strtotime($rowresult4['date'])))); ?>';
					CalendarCategoryArray[Count]='<?php echo attr(xl_appt_category($rowresult4['pc_catname'])); ?>';
					Count++;
	 <?php
				 }
	 ?>

 // Get the left_nav window, and the name of its sibling (top or bottom) frame that this form is in.
 // This works no matter how deeply we are nested.
 var my_left_nav = top.left_nav;
 var w = window;
 for (; w.parent != top; w = w.parent);
 var my_win_name = w.name;
 my_left_nav.setPatientEncounter(EncounterIdArray,EncounterDateArray,CalendarCategoryArray);
<?php } // end concurrent layout ?>

 top.restoreSession();
<?php if ($GLOBALS['concurrent_layout']) { ?>
<?php if ($mode == 'new') { ?>
 my_left_nav.setEncounter(<?php echo "'" . oeFormatShortDate($date) . "', " . attr($encounter) . ", window.name"; ?>);
 my_left_nav.setRadio(window.name, 'enc');
 // Load the tab set for the new encounter, w is usually the RBot frame.
 w.location.href = '<?php echo "$rootdir/patient_file/encounter/encounter_top.php"; ?>';
<?php } else { // not new encounter ?>
 // my_left_nav.loadFrame('enc2', my_win_name, '<?php echo $nexturl; ?>');
 // Always return to encounter summary page.
 window.location.href = '<?php echo "$rootdir/patient_file/encounter/forms.php"; ?>';
<?php } // end if not new encounter ?>
<?php } else { // end if concurrent layout ?>
 window.location.href = "<?php echo $nexturl; ?>";
<?php } // end not concurrent layout ?>

</script>

</body>
</html>
