<?php
require_once("../globals.php");
require_once("$srcdir/log.inc");
require_once("$srcdir/formdata.inc.php");
require_once("$srcdir/formatting.inc.php");
if ($_REQUEST['form_csvexport']) {
  header("Pragma: public");
  header("Expires: 0");
  header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
  header("Content-Type: application/force-download");
  header("Content-Disposition: attachment; filename=logview.csv");
  header("Content-Description: File Transfer");
} // end export
else {?>

<html>
<head>
<?php html_header_show();?>
<link rel="stylesheet" href='<?php echo $GLOBALS['webroot'] ?>/library/dynarch_calendar.css' type='text/css'>
<script type="text/javascript" src="<?php echo $GLOBALS['webroot'] ?>/library/dialog.js"></script>
<script type="text/javascript" src="<?php echo $GLOBALS['webroot'] ?>/library/dynarch_calendar.js"></script>
<?php include_once("{$GLOBALS['srcdir']}/dynarch_calendar_en.inc.php"); ?>
<script type="text/javascript" src="<?php echo $GLOBALS['webroot'] ?>/library/dynarch_calendar_setup.js"></script>

<script type="text/javascript" src="<?php echo $GLOBALS['webroot'] ?>/library/js/jquery-1.2.2.min.js"></script>
<link rel="stylesheet" href="<?php echo $css_header;?>" type="text/css">
<style>
#logview {
    width: 100%;
}
#logview table {
    width:100%;
    border-collapse: collapse;
}
#logview th {
    background-color: #cccccc;
    cursor: pointer; cursor: hand;
    padding: 5px 5px;
    align: left;
    text-align: left;
}

#logview td {
    background-color: #ffffff;
    border-bottom: 1px solid #808080;
    cursor: default;
    padding: 5px 5px;
    vertical-align: top;
}
.highlight {
    background-color: #336699;
    color: #336699;
}
</style>
<script>
//function to disable the event type field if the event name is disclosure
function eventTypeChange(eventname)
{
         if (eventname == "disclosure") {
            document.theform.type_event.disabled = true;
          }
         else {
            document.theform.type_event.disabled = false;
         }              
}

// VicarePlus :: This invokes the find-patient popup.
 function sel_patient() {
  dlgopen('../main/calendar/find_patient_popup.php?pflag=0', '_blank', 500, 400);
 }

// VicarePlus :: This is for callback by the find-patient popup.
 function setpatient(pid, lname, fname, dob) {
  var f = document.theform;
  f.form_patient.value = lname + ', ' + fname;
  f.form_pid.value = pid;
 }

function submitList(offset) {
 var f = document.forms[0];
 var i = parseInt(f.fstart.value) + offset;
 if (i < 0) i = 0;
 f.fstart.value = i;
 f.submit();
}

</script>
</head>
<body class="body_top">
<font class="title"><?php echo xlt('Logs Viewer'); ?></font>
<br>
<?php 

} // end not export
$err_message=0;
if ($_GET["start_date"])
$start_date = formData('start_date','G');

if ($_GET["end_date"])
$end_date = formData('end_date','G');

if ($_GET["form_patient"])
$form_patient = formData('form_patient','G');

/*
 * Start date should not be greater than end date - Date Validation
 */
if ($start_date && $end_date)
{
	if($start_date > $end_date){
                if (!$_REQUEST['form_csvexport']) {
                    echo "<table><tr class='alert'><td colspan=7>"; echo xlt('Start Date should not be greater than End Date');
                    echo "</td></tr></table>"; 
                }
		$err_message=1;	
	}
}

?>
<?php
$form_user = formData('form_user','R');
$form_facility = formData('form_facility','R');
$form_pid = formData('form_pid','R');
if ($form_patient == '' ) $form_pid = '';

$eventname = formData('eventname','G');

// Get the users list.
$sqlQuery = "SELECT username, fname, lname FROM users " .
  "WHERE active = 1 AND ( info IS NULL OR info NOT LIKE '%Inactive%' ) " .
  "ORDER BY lname, fname, id";

$ures = sqlStatement($sqlQuery); 
$get_sdate=$start_date ? $start_date : date("Y-m-d");
$get_edate=$end_date ? $end_date : date("Y-m-d");

$sortby = formData('sortby','G') ;
if (!$_REQUEST['form_csvexport']) {
?>
<br>
<FORM METHOD="GET" name="theform" id="theform">
<?php
  $count = getEventsCount(array('sdate' => $get_sdate, 'edate' => $get_edate,
    'user' => $form_user, 'facility' => $form_facility, 'levent' => $eventname));
  $fstart = formdata('fstart','R') + 0;
  $pagesize = 500;
  while ($fstart >= $count) $fstart -= $pagesize;
  if ($fstart < 0) $fstart = 0;
  $fend = $fstart + $pagesize;
  if ($fend > $count) $fend = $count;
?>
<input type="hidden" name="sortby" id="sortby" value="<?php echo attr($sortby); ?>">
<input type='hidden' name='csum' value="">
<table>
<tr><td>
<span class="text"><?php echo xlt('Start Date'); ?>: </span>
</td><td>
<input type="text" size="10" name="start_date" id="start_date" value="<?php echo attr($start_date ? substr($start_date, 0, 10) : date('Y-m-d')); ?>" title="<?php echo xla('yyyy-mm-dd Date of service'); ?>" onkeyup="datekeyup(this,mypcc)" onblur="dateblur(this,mypcc)" />
<img src="../pic/show_calendar.gif" align="absbottom" width="24" height="22" id="img_begin_date" border="0" alt="[?]" style="cursor: pointer; cursor: hand" title="<?php echo xla('Click here to choose a date'); ?>">&nbsp;
</td>
<td>
<span class="text"><?php echo xlt('End Date'); ?>: </span>
</td><td>
<input type="text" size="10" name="end_date" id="end_date" value="<?php echo attr($end_date ? substr($end_date, 0, 10) : date('Y-m-d')); ?>" title="<?php echo xla('yyyy-mm-dd Date of service'); ?>" onkeyup="datekeyup(this,mypcc)" onblur="dateblur(this,mypcc)" />
<img src="../pic/show_calendar.gif" align="absbottom" width="24" height="22" id="img_end_date" border="0" alt="[?]" style="cursor: pointer; cursor: hand" title="<?php echo xla('Click here to choose a date'); ?>">&nbsp;
</td>
<!--VicarePlus :: Feature For Generating Log For The Selected Patient -->
<td>
&nbsp;&nbsp;<span class='text'><?php echo xlt('Patient'); ?>: </span>
</td>
<td>
<input type='text' size='20' name='form_patient' style='width:100%;cursor:pointer;cursor:hand' value='<?php echo attr($form_patient ? $form_patient : xla('Click To Select')); ?>' onclick='sel_patient()' title='<?php echo xla('Click to select patient'); ?>' />
<input type='hidden' name='form_pid' value='<?php echo attr($form_pid); ?>' />
</td>
</tr>
<tr><td>
<span class='text'><?php echo xlt('User'); ?>: </span>
</td>
<td>
<?php
echo "<select name='form_user'>\n";
echo " <option value=''>" . xlt('All') . "</option>\n";
while ($urow = sqlFetchArray($ures)) {
  if (!trim($urow['username'])) continue;
  echo " <option value='" . attr($urow['username']) . "'";
  if ($urow['username'] == $form_user) echo " selected";
  echo ">" . text($urow['lname']);
  if ($urow['fname']) echo text(", " . $urow['fname']);
  echo "</option>\n";
}
echo "</select>\n";
?>
</td>
<td>
<!-- list of events name -->
<span class='text'><?php echo xlt('Name of Events'); ?>: </span>
</td>
<td>
<?php 
$res = sqlStatement("select distinct event from log order by event ASC");
$ename_list=array(); $j=0;
while ($erow = sqlFetchArray($res)) {
	 if (!trim($erow['event'])) continue;
	 $data = explode('-', $erow['event']);
	 $data_c = count($data);
	 $ename=$data[0];
	 for($i=1;$i<($data_c-1);$i++)
	 {
	 	$ename.="-".$data[$i];
	}
	$ename_list[$j]=$ename;
	$j=$j+1;
}
$res1 = sqlStatement("select distinct event from  extended_log order by event ASC");
// $j=0; // This can't be right!  -- Rod 2013-08-23
while ($row = sqlFetchArray($res1)) {
         if (!trim($row['event'])) continue;
         $new_event = explode('-', $row['event']);
         $no = count($new_event);
         $events=$new_event[0];
         for($i=1;$i<($no-1);$i++)
         {
                $events.="-".$new_event[$i];
        }
        if ($events=="disclosure")
        $ename_list[$j]=$events;
        $j=$j+1;
}
$ename_list=array_unique($ename_list);
$ename_list=array_merge($ename_list);
$ecount=count($ename_list);
echo "<select name='eventname' onchange='eventTypeChange(this.options[this.selectedIndex].value);'>\n";
echo " <option value=''>" . xlt('All') . "</option>\n";
for($k=0;$k<$ecount;$k++) {
echo " <option value='" . attr($ename_list[$k]) . "'";
  if ($ename_list[$k] == $eventname && $ename_list[$k]!= "") echo " selected";
  echo ">" . text($ename_list[$k]);
  echo "</option>\n";
}
echo "</select>\n"; 
?>
</td>
<!-- type of events ends  -->
<td>
&nbsp;&nbsp;<span class='text'><?php echo xlt('Type of Events'); ?>: </span>
</td><td>
<?php 
$event_types=array("select", "update", "insert", "delete", "replace");
$lcount=count($event_types);
if($eventname=="disclosure"){
 echo "<select name='type_event' disabled='disabled'>\n";
 echo " <option value=''>" . xlt('All') . "</option>\n";
 echo "</option>\n";
}
else{
  echo "<select name='type_event'>\n";}
  echo " <option value=''>" . xlt('All') . "</option>\n";
  for($k=0;$k<$lcount;$k++) {
  echo " <option value='" . attr($event_types[$k]) . "'";
  if ($event_types[$k] == $type_event && $event_types[$k]!= "") echo " selected";
  echo ">" . text($event_types[$k]);
  echo "</option>\n";
}
echo "</select>\n";
?>
</td>
<tr>

  <td>
   <span class='text'><?php echo xlt('User Facility'); ?>: </span>
  </td>
  <td>
<?php
// Build a drop-down list of facilities.
$fres = sqlStatement("SELECT id, name FROM facility ORDER BY name");
echo "   <select name='form_facility'>\n";
echo "    <option value=''>-- " . xlt('All Facilities') . " --</option>\n";
while ($frow = sqlFetchArray($fres)) {
  $facid = $frow['id'];
  echo "    <option value='" . attr($facid) . "'";
  if ($facid == $form_facility) echo " selected";
  echo ">" . text($frow['name']) . "</option>\n";
}
echo "   </select>\n";
?>
  </td>

<td>
<span class='text'><?php echo xlt('Include Checksum'); ?>: </span>
</td><td>
<?php

$check_sum = formData('check_sum','G');
?>
<input type="checkbox" name="check_sum" " <?php if ($check_sum == 'on') echo "checked";  ?>"></input>
</td>
<td>
<input type="hidden" name="event" value="<?php echo attr($event); ?>">
<a href="javascript:document.theform.submit();" class='link_submit'>[<?php echo xlt('Refresh'); ?>]</a>
</td>
<td>
    <input type='submit' name='form_csvexport' value="<?php echo xla('Export to CSV') ?>" />
</td>
</tr>
<tr>
    <td colspan='2'>

<?php if ($start_date && $end_date) { ?>
<?php if ($fstart) { ?>
 <a href="javascript:submitList(-<?php echo $pagesize ?>)">
  &lt;&lt;
 </a>
 &nbsp;&nbsp;
<?php } ?>
 <?php echo text(($fstart + 1) . " - $fend " . xl('of') . " $count"); ?>
 &nbsp;&nbsp;
 <a href="javascript:submitList(<?php echo $pagesize; ?>)">
  &gt;&gt;
 </a>
<?php } ?>
 <input type='hidden' name='fstart' value='<?php echo attr($fstart); ?>'>

</td>
</tr>
</table>
</FORM>
<?php }  // Not doing a CSV export ?>
<?php if ($start_date && $end_date && $err_message!=1) { 
      if ($_REQUEST['form_csvexport']) {
    // CSV headers:
    echo '"' . xla('Date'    ) . '",';
    echo '"' . xla('Event'   ) . '",';
    echo '"' . xla('User'    ) . '",';
    echo '"' . xla('Facility') . '",';
    if (empty($GLOBALS['disable_non_default_groups'])) {
      echo '"' . xla('Group'   ) . '",';
    }
    echo '"' . xla('Comments') . '"' . "\n";
  }
  else { // not export
?>
<div id="logview">
<table>
 <tr>
  <!-- <TH><?php echo xlt('Date'); ?><TD> -->
  <th id="sortby_date"     class="text" title="<?php echo xla('Sort by date/time'); ?>"><?php echo xlt('Date'            ); ?></th>
  <th id="sortby_event"    class="text" title="<?php echo xla('Sort by Event'    ); ?>"><?php echo xlt('Event'           ); ?></th>
  <th id="sortby_user"     class="text" title="<?php echo xla('Sort by User'     ); ?>"><?php echo xlt('User'            ); ?></th>
  <th id="sortby_facility" class="text" title="<?php echo xla('Sort by Facility' ); ?>"><?php echo xlt('Facility'        ); ?></th>
  <th id="sortby_cuser"    class="text" title="<?php echo xla('Sort by Crt User' ); ?>"><?php echo xlt('Certificate User'); ?></th>
  <th id="sortby_group"    class="text" title="<?php echo xla('Sort by Group'    ); ?>"><?php echo xlt('Group'           ); ?></th>
  <th id="sortby_pid"      class="text" title="<?php echo xla('Sort by PatientID'); ?>"><?php echo xlt('PatientID'       ); ?></th>
  <th id="sortby_success"  class="text" title="<?php echo xla('Sort by Success'  ); ?>"><?php echo xlt('Success'         ); ?></th>
  <th id="sortby_comments" class="text" title="<?php echo xla('Sort by Comments' ); ?>"><?php echo xlt('Comments'        ); ?></th>
 <?php  if($check_sum) {?>
  <th id="sortby_checksum" class="text" title="<?php echo xla('Sort by Checksum' ); ?>"><?php echo xlt('Checksum'        ); ?></th>
  <?php } ?>
 </tr>
<input type='hidden' name='event' value=<?php echo attr($eventname . "-" . $type_event); ?>>
<?php
  } // End NOT CSV Export
$eventname = formData('eventname','G');
$type_event = formData('type_event','G');

$tevent=""; $gev="";
if($eventname != "" && $type_event != "")
{
	$getevent=$eventname."-".$type_event;
}
      
	if(($eventname == "") && ($type_event != ""))
    {	$tevent=$type_event;   	
    }
	else if($type_event =="" && $eventname != "")
    {$gev=$eventname;}
    else if ($eventname == "")
 	{$gev = "";}
 else 
    {$gev = $getevent;}

if ($ret = getEvents(array(
  'sdate'    => $get_sdate,
  'edate'    => $get_edate,
  'user'     => $form_user,
  'facility' => $form_facility,
  'patient'  => $form_pid,
  'sortby'   => $_GET['sortby'],
  'levent'   => $gev,
  'tevent'   => $tevent,
  'limit'    => ($_REQUEST['form_csvexport'] ? "" : ("LIMIT $fstart, " . ($fend - $fstart)))
))) {
  foreach ($ret as $iter) {
    /******************************************************************
    //translate comments
    $patterns = array ('/^success/','/^failure/','/ encounter/');
    $replace = array ( xl('success'), xl('failure'), xl('encounter','',' '));
    $trans_comments = preg_replace($patterns, $replace, $iter["comments"]);
    ******************************************************************/
    // Translation is wrong, don't want to mess up column names and such.
    $trans_comments = str_replace('"', '""', $iter['comments']);
    //
    if ($_REQUEST['form_csvexport']) {
      echo '"' . oeFormatShortDate(substr($iter["date"], 0, 10)) . substr($iter["date"], 10) . '",';
      echo '"' . xla($iter["event"]    ) . '",';
      echo '"' . attr($iter["user"]) . '",';
      echo '"' . attr($iter["name"]) . '",'; // facility name
      if (empty($GLOBALS['disable_non_default_groups'])) {
        echo '"' . attr($iter["groupname"]) . '",';
      }
      echo '"' . attr($trans_comments) . '"' . "\n";
    }
    else { // not export
?>
 <TR class="oneresult">
  <TD class="text"><?php echo oeFormatShortDate(substr($iter["date"], 0, 10)) . substr($iter["date"], 10) ?></TD>
  <TD class="text"><?php echo xlt($iter["event"]) ?></TD>
  <TD class="text"><?php echo text($iter["user"]) ?></TD>
  <TD class="text"><?php echo text($iter["name"]) ?></TD>
  <TD class="text"><?php echo text($iter["crt_user"]) ?></TD>
  <TD class="text"><?php echo text($iter["groupname"]) ?></TD>
  <TD class="text"><?php echo text($iter["patient_id"]) ?></TD>
  <TD class="text"><?php echo text($iter["success"]) ?></TD>
  <TD class="text"><?php echo text($trans_comments) ?></TD>
  <?php  if($check_sum) { ?>
  <TD class="text"><?php echo text($iter["checksum"]) ?></TD>
  <?php } ?>
 </TR>

<?php
        }// end NOT CSV Export
    }
  }
if ($eventname == "disclosure" || $gev == "") {
  $eventname = "disclosure";
  if ($ret = getEvents(array(
    'sdate'    => $get_sdate,
    'edate'    => $get_edate,
    'user'     => $form_user,
    'facility' => $form_facility,
    'patient'  => $form_pid,
    'sortby'   => $_GET['sortby'],
    'event'    => $eventname,
    'limit'    => ($_REQUEST['form_csvexport'] ? "" : ("LIMIT $fstart, " . ($fend - $fstart)))
  ))) {
    foreach ($ret as $iter) {
      $comments = xl('Recipient Name') . ":" . $iter["recipient"] . ";" . xl('Disclosure Info') . ":" . $iter["description"];
?>
<TR class="oneresult">
  <TD class="text"><?php echo text(oeFormatShortDate(substr($iter["date"], 0, 10)) . substr($iter["date"], 10),ENT_NOQUOTES); ?></TD>
  <TD class="text"><?php echo xlt($iter["event"]); ?></TD>
  <TD class="text"><?php echo text($iter["user"]); ?></TD>
  <TD class="text"><?php echo text($iter["name"]); ?></TD>
  <TD class="text"><?php echo text($iter["crt_user"]); ?></TD>
  <TD class="text"><?php echo text($iter["groupname"]); ?></TD>
  <TD class="text"><?php echo text($iter["patient_id"]); ?></TD>
  <TD class="text"><?php echo text($iter["success"]); ?></TD>
  <TD class="text"><?php echo text($comments); ?></TD>
  <?php  if($check_sum) { ?>
  <TD class="text"><?php echo text($iter["checksum"],ENT_NOQUOTES);?></TD>
  <?php } ?>
 </TR>
<?php
    }
  }
}
if (!$_REQUEST['form_csvexport']) {
?>
    </table>
    </div>

<?php 
    } // end not export
} // end query results display

if (!$_REQUEST['form_csvexport']) {
?>
</body>

<script language="javascript">

// jQuery stuff to make the page a little easier to use
$(document).ready(function(){
    // funny thing here... good learning experience
    // the TR has TD children which have their own background and text color
    // toggling the TR color doesn't change the TD color
    // so we need to change all the TR's children (the TD's) just as we did the TR
    // thus we have two calls to toggleClass:
    // 1 - for the parent (the TR)
    // 2 - for each of the children (the TDs)
    $(".oneresult").mouseover(function() { $(this).toggleClass("highlight"); $(this).children().toggleClass("highlight"); });
    $(".oneresult").mouseout(function() { $(this).toggleClass("highlight"); $(this).children().toggleClass("highlight"); });

    // click-able column headers to sort the list
    $("#sortby_date").click(function() { $("#sortby").val("date"); $("#theform").submit(); });
    $("#sortby_event").click(function() { $("#sortby").val("event"); $("#theform").submit(); });
    $("#sortby_user").click(function() { $("#sortby").val("user"); $("#theform").submit(); });
    $("#sortby_facility").click(function() { $("#sortby").val("name"); $("#theform").submit(); });
    $("#sortby_cuser").click(function() { $("#sortby").val("user"); $("#theform").submit(); });
    $("#sortby_group").click(function() { $("#sortby").val("groupname"); $("#theform").submit(); });
    $("#sortby_pid").click(function() { $("#sortby").val("patient_id"); $("#theform").submit(); });
    $("#sortby_success").click(function() { $("#sortby").val("success"); $("#theform").submit(); });
    $("#sortby_comments").click(function() { $("#sortby").val("comments"); $("#theform").submit(); });
    $("#sortby_checksum").click(function() { $("#sortby").val("checksum"); $("#theform").submit(); });
});

/* required for popup calendar */
Calendar.setup({inputField:"start_date", ifFormat:"%Y-%m-%d", button:"img_begin_date"});
Calendar.setup({inputField:"end_date", ifFormat:"%Y-%m-%d", button:"img_end_date"});

</script>

</html>
<?php
} // end not export
?>
