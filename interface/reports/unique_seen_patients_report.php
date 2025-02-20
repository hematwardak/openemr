<?php
/**
 * This report lists patients that were seen within a given date
 * range.
 *
 * @package   OpenEMR
 * @link      http://www.open-emr.org
 * @author    Rod Roark <rod@sunsetsystems.com>
 * @author    Brady Miller <brady.g.miller@gmail.com>
 * @copyright Copyright (c) 2006-2016 Rod Roark <rod@sunsetsystems.com>
 * @copyright Copyright (c) 2017 Brady Miller <brady.g.miller@gmail.com>
 * @license   https://github.com/openemr/openemr/blob/master/LICENSE GNU General Public License 3
 */

require_once("../globals.php");
require_once("$srcdir/patient.inc");
require_once("$srcdir/formatting.inc.php");

if (!acl_check('patients', 'demo')) die(xl("Unauthorized access."));

 $from_date = fixDate($_POST['form_from_date'], date('Y-01-01'));
 $to_date   = fixDate($_POST['form_to_date'], date('Y-12-31'));

 if ($_POST['form_labels']) {
  header("Pragma: public");
  header("Expires: 0");
  header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
  header("Content-Type: application/force-download");
  header("Content-Disposition: attachment; filename=labels.txt");
  header("Content-Description: File Transfer");
 }
 else {
?>
<html>
<head>
<?php html_header_show();?>
<style type="text/css">
/* specifically include & exclude from printing */
@media print {
    #report_parameters {
        visibility: hidden;
        display: none;
    }
    #report_parameters_daterange {
        visibility: visible;
        display: inline;
    }
    #report_results {
       margin-top: 30px;
    }
}

/* specifically exclude some from the screen */
@media screen {
    #report_parameters_daterange {
        visibility: hidden;
        display: none;
    }
}
</style>
<title><?php echo xlt('Front Office Receipts'); ?></title>

<script type="text/javascript" src="../../library/overlib_mini.js"></script>
<script type="text/javascript" src="../../library/textformat.js"></script>
<script type="text/javascript" src="../../library/dialog.js"></script>
<script type="text/javascript" src="../../library/js/jquery.1.3.2.js"></script>

<script language="JavaScript">
 var mypcc = '<?php echo $GLOBALS['phone_country_code'] ?>';
</script>

<link rel=stylesheet href="<?php echo $css_header;?>" type="text/css">
<style type="text/css">

/* specifically include & exclude from printing */
@media print {
    #report_parameters {
        visibility: hidden;
        display: none;
    }
    #report_parameters_daterange {
        visibility: visible;
        display: inline;
    }
}

/* specifically exclude some from the screen */
@media screen {
    #report_parameters_daterange {
        visibility: hidden;
        display: none;
    }
}

</style>
</head>

<body class="body_top">

<!-- Required for the popup date selectors -->
<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>

<span class='title'><?php echo xlt('Report'); ?> - <?php echo xlt('Unique Seen Patients'); ?></span>

<div id="report_parameters_daterange">
<?php echo oeFormatShortDate($form_from_date) ." &nbsp; " . xlt("to") . " &nbsp; ". oeFormatShortDate($form_to_date); ?>
</div>

<form name='theform' method='post' action='unique_seen_patients_report.php' id='theform' onsubmit='return top.restoreSession()'>

<div id="report_parameters">
<input type='hidden' name='form_refresh' id='form_refresh' value=''/>
<input type='hidden' name='form_labels' id='form_labels' value=''/>

<table>
 <tr>
  <td width='410px'>
	<div style='float:left'>

	<table class='text'>
		<tr>
			<td class='label'>
			   <?php echo xlt('Visits From'); ?>:
			</td>
			<td>
			   <input type='text' name='form_from_date' id="form_from_date" size='10' value='<?php echo $form_from_date ?>'
				onkeyup='datekeyup(this,mypcc)' onblur='dateblur(this,mypcc)' title='yyyy-mm-dd'>
			   <img src='../pic/show_calendar.gif' align='absbottom' width='24' height='22'
				id='img_from_date' border='0' alt='[?]' style='cursor:pointer'
				title='<?php echo xlt('Click here to choose a date'); ?>'>
			</td>
			<td class='label'>
			   <?php echo xlt('To'); ?>:
			</td>
			<td>
			   <input type='text' name='form_to_date' id="form_to_date" size='10' value='<?php echo $form_to_date ?>'
				onkeyup='datekeyup(this,mypcc)' onblur='dateblur(this,mypcc)' title='yyyy-mm-dd'>
			   <img src='../pic/show_calendar.gif' align='absbottom' width='24' height='22'
				id='img_to_date' border='0' alt='[?]' style='cursor:pointer'
				title='<?php echo xlt('Click here to choose a date'); ?>'>
			</td>
		</tr>
	</table>

	</div>

  </td>
  <td align='left' valign='middle' height="100%">
	<table style='border-left:1px solid; width:100%; height:100%' >
		<tr>
			<td>
				<div style='margin-left:15px'>
					<a href='#' class='css_button' onclick='$("#form_refresh").attr("value","true"); $("#theform").submit();'>
					<span>
						<?php echo xlt('Submit'); ?>
					</span>
					</a>

					<?php if ($_POST['form_refresh']) { ?>
					<a href='#' class='css_button' onclick='window.print()'>
						<span>
							<?php echo xlt('Print'); ?>
						</span>
					</a>
					<a href='#' class='css_button' onclick='$("#form_labels").attr("value","true"); $("#theform").submit();'>
					<span>
						<?php echo xlt('Labels'); ?>
					</span>
					</a>
					<?php } ?>
				</div>
			</td>
		</tr>
	</table>
  </td>
 </tr>
</table>
</div> <!-- end of parameters -->

<div id="report_results">
<table>

 <thead>
  <th> <?php echo xlt('Last Visit'); ?> </th>
  <th> <?php echo xlt('Patient'); ?> </th>
  <th align='right'> <?php echo xlt('Visits'); ?> </th>
  <th align='right'> <?php echo xlt('Age'); ?> </th>
  <th> <?php echo xlt('Sex'); ?> </th>
  <th> <?php echo xlt('Race'); ?> </th>
  <th> <?php echo xlt('Primary Insurance'); ?> </th>
  <th> <?php echo xlt('Secondary Insurance'); ?> </th>
 </thead>
 <tbody>
<?php
 } // end not generating labels

 if ($_POST['form_refresh'] || $_POST['form_labels']) {
  $totalpts = 0;

  $query = "SELECT " .
   "p.pid, p.fname, p.mname, p.lname, p.DOB, p.sex, p.ethnoracial, " .
   "p.street, p.city, p.state, p.postal_code, " .
   "count(e.date) AS ecount, max(e.date) AS edate, " .
   "i1.date AS idate1, i2.date AS idate2, " .
   "c1.name AS cname1, c2.name AS cname2 " .
   "FROM patient_data AS p " .
   "JOIN form_encounter AS e ON " .
   "e.pid = p.pid AND " .
   "e.date >= '$from_date 00:00:00' AND " .
   "e.date <= '$to_date 23:59:59' " .
   "LEFT OUTER JOIN insurance_data AS i1 ON " .
   "i1.pid = p.pid AND i1.type = 'primary' " .
   "LEFT OUTER JOIN insurance_companies AS c1 ON " .
   "c1.id = i1.provider " .
   "LEFT OUTER JOIN insurance_data AS i2 ON " .
   "i2.pid = p.pid AND i2.type = 'secondary' " .
   "LEFT OUTER JOIN insurance_companies AS c2 ON " .
   "c2.id = i2.provider " .
   "GROUP BY p.lname, p.fname, p.mname, p.pid, i1.date, i2.date " .
   "ORDER BY p.lname, p.fname, p.mname, p.pid, i1.date DESC, i2.date DESC";
  $res = sqlStatement($query);

  $prevpid = 0;
  while ($row = sqlFetchArray($res)) {
   if ($row['pid'] == $prevpid) continue;
   $prevpid = $row['pid'];

   $age = '';
   if ($row['DOB']) {
    $dob = $row['DOB'];
    $tdy = $row['edate'];
    $ageInMonths = (substr($tdy,0,4)*12) + substr($tdy,5,2) -
                   (substr($dob,0,4)*12) - substr($dob,5,2);
    $dayDiff = substr($tdy,8,2) - substr($dob,8,2);
    if ($dayDiff < 0) --$ageInMonths;
    $age = intval($ageInMonths/12);
   }

   if ($_POST['form_labels']) {
    echo '"' . $row['lname'] . ', ' . $row['fname'] . ' ' . $row['mname'] . '","' .
      $row['street'] . '","' . $row['city'] . '","' . $row['state'] . '","' .
      $row['postal_code'] . '"' . "\n";
   }
   else { // not labels
?>
 <tr>
  <td>
   <?php echo oeFormatShortDate(substr($row['edate'], 0, 10)) ?>
  </td>
  <td>
   <?php echo $row['lname'] . ', ' . $row['fname'] . ' ' . $row['mname'] ?>
  </td>
  <td style="text-align:center">
   <?php echo $row['ecount'] ?>
  </td>
  <td>
   <?php echo $age ?>
  </td>
  <td>
   <?php echo $row['sex'] ?>
  </td>
  <td>
   <?php echo $row['ethnoracial'] ?>
  </td>
  <td>
   <?php echo $row['cname1'] ?>
  </td>
  <td>
   <?php echo $row['cname2'] ?>
  </td>
 </tr>
<?php
   } // end not labels
   ++$totalpts;
  }

  if (!$_POST['form_labels']) {
?>
 <tr class='report_totals'>
  <td colspan='2'>
   <?php echo xlt('Total Number of Patients'); ?>
  </td>
  <td style="padding-left: 20px;">
   <?php echo $totalpts ?>
  </td>
  <td colspan='5'>&nbsp;</td>
 </tr>

<?php
  } // end not labels
 } // end refresh or labels

 if (!$_POST['form_labels']) {
?>
</tbody>
</table>
</div>
</form>
</body>

<!-- stuff for the popup calendar -->
<style type="text/css">@import url(../../library/dynarch_calendar.css);</style>
<script type="text/javascript" src="../../library/dynarch_calendar.js"></script>
<?php include_once("{$GLOBALS['srcdir']}/dynarch_calendar_en.inc.php"); ?>
<script type="text/javascript" src="../../library/dynarch_calendar_setup.js"></script>
<script language="Javascript">
 Calendar.setup({inputField:"form_from_date", ifFormat:"%Y-%m-%d", button:"img_from_date"});
 Calendar.setup({inputField:"form_to_date", ifFormat:"%Y-%m-%d", button:"img_to_date"});
</script>
</html>
<?php
 } // end not labels
?>
