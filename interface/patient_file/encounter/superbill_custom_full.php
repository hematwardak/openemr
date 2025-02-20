<?php
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

$fake_register_globals=false;
$sanitize_all_escapes=true;

require_once("../../globals.php");
require_once("../../../custom/code_types.inc.php");
require_once("$srcdir/sql.inc");
require_once("$srcdir/options.inc.php");
require_once("$srcdir/formatting.inc.php");
require_once("$srcdir/formdata.inc.php");

// Translation for form fields.
function ffescape($field) {
  $field = add_escape_custom($field);
  return trim($field);
}

// Format dollars for display.
//
function bucks($amount) {
  if ($amount) {
    $amount = oeFormatMoney($amount);
    return $amount;
  }
  return '';
}

$alertmsg = '';
$pagesize = 100;
$mode = $_POST['mode'];
$code_id = 0;
$related_code = '';
$active = 1;
$reportable = 0;
$financial_reporting = 0;

if (isset($mode)) {
  $code_id    = empty($_POST['code_id']) ? '' : $_POST['code_id'] + 0;
  $code       = $_POST['code'];
  $code_type  = $_POST['code_type'];
  $code_text  = $_POST['code_text'];
  $modifier   = $_POST['modifier'];
  $superbill  = $_POST['form_superbill'];
  $related_code = $_POST['related_code'];
  $cyp_factor = $_POST['cyp_factor'] + 0;
  $sex        = empty($_POST['sex']) ? 4 : ($_POST['sex'] + 0);
  $active     = empty($_POST['active']) ? 0 : 1;
  $reportable = empty($_POST['reportable']) ? 0 : 1; // dx reporting
  $financial_reporting = empty($_POST['financial_reporting']) ? 0 : 1; // financial service reporting

  $taxrates = "";
  if (!empty($_POST['taxrate'])) {
    foreach ($_POST['taxrate'] as $key => $value) {
      $taxrates .= "$key:";
    }
  }

  if ($mode == "delete") {
    sqlStatement("DELETE FROM codes WHERE id = ?", array($code_id) );
    $code_id = 0;
  }
  else if ($mode == "add" || $mode == "modify_complete") { // this covers both adding and modifying
    $crow = sqlQuery("SELECT COUNT(*) AS count FROM codes WHERE " .
      "code_type = '"    . ffescape($code_type)    . "' AND " .
      "code = '"         . ffescape($code)         . "' AND " .
      "modifier = '"     . ffescape($modifier)     . "' AND " .
      "id != '"          . add_escape_custom($code_id) . "'");
    if ($crow['count']) {
      $alertmsg = xl('Cannot add/update this entry because a duplicate already exists!');
    }
    else {
      if (!empty($_POST['initial_consult_used'])) {
        $cyp_factor = empty($_POST['initial_consult']) ? 0 : 1;
      }        
      $sql =
        "code = '"         . ffescape($code)         . "', " .
        "code_type = '"    . ffescape($code_type)    . "', " .
        "code_text = '"    . ffescape($code_text)    . "', " .
        "modifier = '"     . ffescape($modifier)     . "', " .
        "superbill = '"    . ffescape($superbill)    . "', " .
        "related_code = '" . ffescape($related_code) . "', " .
        "cyp_factor = '"   . ffescape($cyp_factor)   . "', " .
        "sex = '"          . ffescape($sex)          . "', " .
        "taxrates = '"     . ffescape($taxrates)     . "', " .
        "active = "        . add_escape_custom($active) . ", " .
        "financial_reporting = " . add_escape_custom($financial_reporting) . ", " .
        "reportable = "    . add_escape_custom($reportable);
      if (isset($_POST['code_text_short'])) {
        $sql .= ", code_text_short = '" . ffescape($_POST['code_text_short']) . "'";
      }      
      else if (isset($_POST['contra_method'])) {
        $sql .= ", code_text_short = '" . ffescape($_POST['contra_method']) . "'";
      }      
      if ($code_id) {
        $query = "UPDATE codes SET $sql WHERE id = ?";
        sqlStatement($query, array($code_id) );
        sqlStatement("DELETE FROM prices WHERE pr_id = ? AND " .
          "pr_selector = ''", array($code_id) );
      }
      else {
        $code_id = sqlInsert("INSERT INTO codes SET $sql");
      }
      if (!$alertmsg) {
        foreach ($_POST['fee'] as $key => $value) {
          $value = $value + 0;
          if ($value) {
            sqlStatement("INSERT INTO prices ( " .
              "pr_id, pr_selector, pr_level, pr_price ) VALUES ( " .
              "?, '', ?, ?)", array($code_id,$key,$value) );
          }
        }
        $code = $code_type = $code_text = $code_text_short = $modifier = $superbill = "";
        $code_id = 0;
        $related_code = '';
        $cyp_factor = 0;
        $sex = 4;
        $taxrates = '';
        $active = 1;
        $reportable = 0;
      }
    }
  }
  else if ($mode == "edit") { // someone clicked [Edit]
    $sql = "SELECT * FROM codes WHERE id = ?";
    $results = sqlStatement($sql, array($code_id) );
    while ($row = sqlFetchArray($results)) {
      $code         = $row['code'];
      $code_text    = $row['code_text'];
      $code_text_short = $row['code_text_short'];      
      $code_type    = $row['code_type'];
      $modifier     = $row['modifier'];
      // $units        = $row['units'];
      $superbill    = $row['superbill'];
      $related_code = $row['related_code'];
      $cyp_factor   = $row['cyp_factor'];
      $sex          = $row['sex'];
      $taxrates     = $row['taxrates'];
      $active       = 0 + $row['active'];
      $reportable   = 0 + $row['reportable'];
      $financial_reporting  = 0 + $row['financial_reporting'];
    }
  }
  else if ($mode == "modify") { // someone clicked [Modify]
    // this is to modify external code types, of which the modifications
    // are stored in the codes table
    $code_type_name_external = $_POST['code_type_name_external'];
    $code_external = $_POST['code_external'];
    $code_id = $_POST['code_id'];
    $results = return_code_information($code_type_name_external,$code_external,false); // only will return one item
    while ($row = sqlFetchArray($results)) {
      $code         = $row['code'];
      $code_text    = $row['code_text'];
      $code_type    = $code_types[$code_type_name_external]['id'];
      $modifier     = $row['modifier'];
      // $units        = $row['units'];
      $superbill    = $row['superbill'];
      $related_code = $row['related_code'];
      $cyp_factor   = $row['cyp_factor'];
      $sex          = $row['sex'];
      $taxrates     = $row['taxrates'];
      $active       = $row['active'];
      $reportable   = $row['reportable'];
      $financial_reporting  = $row['financial_reporting'];
    }
  }
}

$related_desc = '';
if (!empty($related_code)) {
  $related_desc = $related_code;
}

$fstart = $_REQUEST['fstart'] + 0;
if (isset($_REQUEST['filter'])) {
  $filter = array();
  $filter_key = array();
  foreach ($_REQUEST['filter'] as $var) {
    $var = $var+0;
    array_push($filter,$var);
    $var_key = convert_type_id_to_key($var);
    array_push($filter_key,$var_key);
  }
}
$search = $_REQUEST['search'];
$search_reportable = $_REQUEST['search_reportable'];
$search_financial_reporting = $_REQUEST['search_financial_reporting'];

//Build the filter_elements array
$filter_elements = array();
if (!empty($search_reportable)) {
 $filter_elements['reportable'] = $search_reportable;
}
if (!empty($search_financial_reporting)) {
 $filter_elements['financial_reporting'] = $search_financial_reporting;
}

// Determine if we are listing only active entries. Default is yes.
$activeonly = 1;
if (isset($_REQUEST['fstart'])) {
  $activeonly = empty($_REQUEST['activeonly']) ? 0 : 1;
}
if($activeonly)
{
    // Then add a filter element 
    $filter_elements['active']=1;
}
if (isset($_REQUEST['filter'])) {
 $count = main_code_set_search($filter_key,$search,NULL,NULL,false,NULL,true,NULL,NULL,$filter_elements);
}

if ($fstart >= $count) $fstart -= $pagesize;
if ($fstart < 0) $fstart = 0;
$fend = $fstart + $pagesize;
if ($fend > $count) $fend = $count;
?>

<html>
<head>
<?php html_header_show(); ?>
<link rel="stylesheet" href="<?php echo attr($css_header);?>" type="text/css">
<script type="text/javascript" src="../../../library/dialog.js?v=<?php echo $v_js_includes; ?>"></script>
<script type="text/javascript" src="../../../library/textformat.js?v=<?php echo $v_js_includes; ?>"></script>

<script language="JavaScript">

// This is for callback by the find-code popup.
// Appends to or erases the current list of related codes.
function set_related(codetype, code, selector, codedesc) {
 var f = document.forms[0];
 var s = f.related_code.value;
 if (code) {
  if (codetype != 'PROD') {
   if (s.indexOf(codetype + ':') == 0 || s.indexOf(';' + codetype + ':') > 0) {
    return '<?php echo xl('A code of this type is already selected. Erase the field first if you need to replace it.') ?>';
   }
  }     
  if (s.length > 0) s += ';';
  s += codetype + ':' + code;
 } else {
  s = '';
 }
 f.related_code.value = s;
 f.related_desc.value = s;
 return '';
}

// This is for callback by the find-code popup.
// Returns the array of currently selected codes with each element in codetype:code format.
function get_related() {
 return document.forms[0].related_code.value.split(';');
}

// This is for callback by the find-code popup.
// Deletes the specified codetype:code from the currently selected list.
function del_related(s) {
 my_del_related(s, document.forms[0].related_code, false);
 my_del_related(s, document.forms[0].related_desc, false);
}

// This invokes the find-code popup.
function sel_related() {
 var f = document.forms[0];
 var i = f.code_type.selectedIndex;
 var codetype = '';
 if (i >= 0) {
  var myid = f.code_type.options[i].value;
<?php
foreach ($code_types as $key => $value) {
  $codeid = $value['id'];
  $coderel = $value['rel'];
  if (!$coderel) continue;
  echo "  if (myid == $codeid) codetype = '$coderel';";
}
?>
 }
 if (!codetype) {
  alert('<?php echo addslashes( xl('This code type does not accept relations.') ); ?>');
  return;
 }
 dlgopen('find_code_dynamic.php', '_blank', 900, 600);
}

// Some validation for saving a new code entry.
function validEntry(f) {
 if (!f.code.value) {
  alert('<?php echo addslashes( xl('No code was specified!') ); ?>');
  return false;
 }
<?php if ($GLOBALS['ippf_specific']) { ?>
/* 
 * Code_type 12 for IPPF is an MA(Member association code
 * These codes are required to have one and only one related IPPF codes
 */
 if (f.code_type.value == 12) {
    // Count related IPPF2 codes. Must be 1.
    var icount = 0;
    var i = 0;
    while (i >= 0) {
        i = f.related_code.value.indexOf('IPPF2:',i);
        if (i >= 0) {
        ++icount;
        ++i;
        }
    }
    if (icount < 1) {
        alert('<?php echo xla('A related IPPF2 code is required!'); ?>');
        return false;
    }
    
    <?php if(!$GLOBALS['gbl_ma_ippf_code_restriction'])
    { ?>        
        if (icount > 1) {
            alert('<?php echo xla('Only one related IPPF code is allowed!'); ?>');
            return false;
        }
    <?php } ?>
}
<?php } ?>
 return true;
}

function submitAdd() {
 var f = document.forms[0];
 if (!validEntry(f)) return;
 f.mode.value = 'add';
 f.code_id.value = '';
 f.submit();
}

function submitUpdate() {
 var f = document.forms[0];
 if (! parseInt(f.code_id.value)) {
  alert('<?php echo addslashes( xl('Cannot update because you are not editing an existing entry!') ); ?>');
  return;
 }
 if (!validEntry(f)) return;
 f.mode.value = 'add';
 f.submit();
}

function submitModifyComplete() {
 var f = document.forms[0];
 f.mode.value = 'modify_complete';
 f.submit();
}

function submitList(offset) {
 var f = document.forms[0];
 var i = parseInt(f.fstart.value) + offset;
 if (i < 0) i = 0;
 f.fstart.value = i;
 f.submit();
}

function submitEdit(id) {
 var f = document.forms[0];
 f.mode.value = 'edit';
 f.code_id.value = id;
 f.submit();
}

function submitModify(code_type_name,code,id) {
 var f = document.forms[0];
 f.mode.value = 'modify';
 f.code_external.value = code;
 f.code_id.value = id;
 f.code_type_name_external.value = code_type_name;
 f.submit();
}



function submitDelete(id, code, text) {
    if (!confirm('<?php echo addslashes(xl('Do you really want to delete service')); ?> ' + code + ' "' + text + '"?')) return;
    var f = document.forms[0];
    f.mode.value = 'delete';
    f.code_id.value = id;
    f.submit();
}

function getCTMask() {
 var ctid = document.forms[0].code_type.value;
<?php
foreach ($code_types as $key => $value) {
  $ctid   = attr($value['id']);
  $ctmask = attr($value['mask']);
  echo " if (ctid == '$ctid') return '$ctmask';\n";
}
?>
 return '';
}

function code_type_changed() {
 var f = document.forms[0];
 var sel = f.code_type;
 var type = sel.value;
 var showConsult = false;
 var showMethod  = false;
 var showCYP     = false;
 var showSex     = false;
<?php if ($GLOBALS['ippf_specific']) { ?>
 if (type == '12')      { // MA
  showConsult = true;
  showSex     = true;
 }
 else if (type == '32') { // IPPFCM
  showMethod  = true;
  showCYP     = true;
 }
 else if (type == '11') { // IPPF (obsolete)
  showCYP     = true;
 }
<?php } ?>
 document.getElementById('id_cyp_factor').style.display      = showCYP     ? '' : 'none';
 document.getElementById('id_initial_consult').style.display = showConsult ? '' : 'none';
 document.getElementById('id_contra_method').style.display   = showMethod  ? '' : 'none';
 document.getElementById('id_code_text_short').style.display = showMethod  ? 'none' : '';
 document.getElementById('id_sex').style.display             = showSex     ? '' : 'none';
 f.contra_method.disabled = !showMethod;
 f.code_text_short.disabled = showMethod;
 f.initial_consult_used.value = showConsult ? '1' : '0';
}

</script>

</head>
<body class="body_top" >

<?php if ($GLOBALS['concurrent_layout']) {
} else { ?>
<a href='patient_encounter.php?codefrom=superbill' target='Main'>
<span class='title'><?php echo xlt('Superbill Codes'); ?></span>
<font class='more'><?php echo text($tback);?></font></a>
<?php } ?>

<form method='post' action='superbill_custom_full.php' name='theform'>

<input type='hidden' name='mode' value=''>

<br>

<center>
<table border='0' cellpadding='0' cellspacing='0'>

 <tr>
  <td colspan="4"> <?php xl('Not all fields are required for all codes or code types.','e'); ?><br><br></td>
 </tr>

 <tr>
  <td nowrap><?php echo xlt('Type'); ?>:&nbsp;</td>
  <td width="5">
  </td>
  <td nowrap>

   <?php if ($mode != "modify") { ?>
    <select name='code_type' onchange='code_type_changed()'>
   <?php } ?>

   <?php $external_sets = array(); ?>
   <?php foreach ($code_types as $key => $value) { ?>
     <?php if ( !($value['external']) ) { ?>
       <?php if ($mode != "modify") { ?>
         <option value="<?php  echo attr($value['id']) ?>"<?php if ($code_type == $value['id']) echo " selected" ?>><?php echo xlt($value['label']) ?></option>
       <?php } ?>
     <?php } ?>
     <?php if ($value['external']) {
       array_push($external_sets,$key);
     } ?>
   <?php } // end foreach ?>

   <?php if ($mode != "modify") { ?>
   </select>
   <?php } ?>

   <?php if ($mode == "modify") { ?>
      <input type='text' size='4' name='code_type' readonly='readonly' style='display:none' value='<?php echo attr($code_type) ?>' />
      <?php echo attr($code_type_name_external) ?>
   <?php } ?>

   &nbsp;&nbsp;
   <?php echo xlt('Code'); ?>:

   <?php if ($mode == "modify") { ?>
     <input type='text' size='10' maxlength='31' name='code' readonly='readonly' value='<?php echo attr($code) ?>' />
   <?php } else { ?>
     <input type='text' size='10' maxlength='31' name='code' value='<?php echo attr($code) ?>'
      onkeyup='maskkeyup(this,getCTMask())'
      onblur='maskblur(this,getCTMask())'
     />
   <?php } ?>

<?php if (modifiers_are_used()) { ?>
   &nbsp;&nbsp;<?php echo xlt('Modifier'); ?>:
   <?php if ($mode == "modify") { ?>
     <input type='text' size='3' maxlength='5' name='modifier' readonly='readonly' value='<?php echo attr($modifier) ?>'>
   <?php } else { ?>
     <input type='text' size='3' maxlength='5' name='modifier' value='<?php echo attr($modifier) ?>'>
   <?php } ?>
<?php } else { ?>
   <input type='hidden' name='modifier' value=''>
<?php } ?>
   &nbsp;
  </td>
  <td nowrap>
   &nbsp;&nbsp;
   <input type='checkbox' name='active' value='1'<?php if (!empty($active) || ($mode == 'modify' && $active == NULL) ) echo ' checked'; ?> />
   <?php echo xlt('Active'); ?>
  </td>
 </tr>

 <tr>
  <td nowrap><?php echo xlt('Description'); ?>:&nbsp;</td>
  <td></td>
  <td nowrap>
   <?php if ($mode == "modify") { ?>
     <input type='text' size='60'  maxlength='255' name="code_text" readonly="readonly" value='<?php echo attr($code_text) ?>'>
   <?php } else { ?>
     <input type='text' size='60'  maxlength='255' name="code_text" value='<?php echo attr($code_text) ?>'>
   <?php } ?>
  </td>
  <td id='id_initial_consult' nowrap>
   &nbsp;&nbsp;
   <input type='checkbox' name="initial_consult" value='1' <?php echo $cyp_factor ? 'checked' : ''; ?> />
   <input type='hidden' name='initial_consult_used' value='1' />
   <?php xl('Initial Consult','e'); ?>
  </td>
 </tr>

 <tr id='id_code_text_short'>
  <td nowrap><?php xl('Short Description','e'); ?>:&nbsp;</td>
  <td></td>
  <td colspan='2'>
   <input type='text' size='24'  maxlength='24' name='code_text_short' value='<?php echo $code_text_short ?>' />
  </td>
 </tr>

 <tr>
  <td nowrap><?php echo xlt('Category'); ?>:&nbsp;</td>
  <td></td>
  <td nowrap>
<?php
generate_form_field(array('data_type'=>1,'field_id'=>'superbill','list_id'=>'superbill'), $superbill);
?>
   &nbsp;&nbsp;
   <input type='checkbox' title='<?php echo xlt("Syndromic Surveillance Report") ?>' name='reportable' value='1'<?php if (!empty($reportable)) echo ' checked'; ?> />
   <?php echo xlt('Diagnosis Reporting'); ?>
  </td>
  <td nowrap>
   &nbsp;&nbsp;
   <input type='checkbox' title='<?php echo xlt("Service Code Finance Reporting") ?>' name='financial_reporting' value='1'<?php if (!empty($financial_reporting)) echo ' checked'; ?> />
   <?php echo xlt('Service Reporting'); ?>
  </td>
 </tr>

 <tr id='id_contra_method'>
  <td nowrap><?php xl('Contraceptive Method','e'); ?>:&nbsp;</td>
  <td></td>
  <td colspan='2'>
   <?php echo generate_select_list('contra_method', 'contrameth', $code_text_short); ?>
  </td>
 </tr>

 <tr id='id_cyp_factor'>
  <td nowrap><?php echo xl('CYP Factor'); ?>:&nbsp;</td>
  <td></td>
  <td colspan='2' nowrap>
   <input type='text' size='10' maxlength='20' name="cyp_factor" value='<?php echo $cyp_factor ?>'>
  </td>
 </tr>

 <tr id='id_sex'>
  <td nowrap><?php echo xlt('Sex Specific'); ?>:&nbsp;</td>
  <td></td>
  <td colspan='2' nowrap>
<?php
  foreach (array(4 => xl('All'), 1 => xl('Women Only'), 2 => xl('Men Only')) as $key => $value) {
    echo "   <input type='radio' name='sex' value='$key'";
    if ($key == $sex) echo " checked";
    echo " />$value&nbsp;";
  }
?>
  </td>
 </tr>

 <tr<?php if (!related_codes_are_used()) echo " style='display:none'"; ?>>
  <td nowrap><?php echo xlt('Relate To'); ?>:&nbsp;</td>
  <td></td>
  <td colspan='2'>
   <input type='text' size='60' name='related_desc'
    value='<?php echo attr($related_desc) ?>' onclick="sel_related()"
    title='<?php echo xla('Click to select related code'); ?>' readonly />
   <input type='hidden' name='related_code' value='<?php echo attr($related_code) ?>' />
  </td>
 </tr>

 <tr>
  <td nowrap><?php echo xlt('Fees'); ?>:&nbsp;</td>
  <td></td>
  <td colspan='2'>
<?php
$pres = sqlStatement("SELECT lo.option_id, lo.title, p.pr_price " .
  "FROM list_options AS lo LEFT OUTER JOIN prices AS p ON " .
  "p.pr_id = ? AND p.pr_selector = '' AND p.pr_level = lo.option_id " .
  "WHERE lo.list_id = 'pricelevel' AND lo.activity = 1 ORDER BY lo.seq, lo.title", array($code_id) );
for ($i = 0; $prow = sqlFetchArray($pres); ++$i) {
  echo "<span style='white-space: nowrap'>";
  echo text(xl_list_label($prow['title'])) . "&nbsp;";
  echo "<input type='text' size='6' name='fee[" . attr($prow['option_id']) . "]' " .
    "value='" . attr($prow['pr_price']) . "' />";
  echo "</span>&nbsp; ";
}
?>
  </td>
 </tr>

<?php
$taxline = '';
$pres = sqlStatement("SELECT option_id, title FROM list_options " .
  "WHERE list_id = 'taxrate' AND activity = 1 ORDER BY seq");
while ($prow = sqlFetchArray($pres)) {
  if ($taxline) $taxline .= "&nbsp;&nbsp;";
  $taxline .= "<input type='checkbox' name='taxrate[" . attr($prow['option_id']) . "]' value='1'";
  if (strpos(":$taxrates", $prow['option_id']) !== false) $taxline .= " checked";
  $taxline .= " />\n";
  $taxline .=  text(xl_list_label($prow['title'])) . "\n";
}
if ($taxline) {
?>
 <tr>
  <td><?php echo xlt('Taxes'); ?>:&nbsp;</td>
  <td></td>
  <td colspan='2'>
   <?php echo $taxline ?>
  </td>
 </tr>
<?php } ?>

 <tr>
  <td colspan="4" align="center">
   <input type="hidden" name="code_id" value="<?php echo attr($code_id) ?>"><br>
   <input type="hidden" name="code_type_name_external" value="<?php echo attr($code_type_name_external) ?>">
   <input type="hidden" name="code_external" value="<?php echo attr($code_external) ?>">
   <?php if ($mode == "modify") { ?>
     <a href='javascript:submitModifyComplete();' class='link'>[<?php echo xlt('Update'); ?>]</a>
   <?php } else { ?>
     <a href='javascript:submitUpdate();' class='link'>[<?php echo xlt('Update'); ?>]</a>
     &nbsp;&nbsp;
     <a href='javascript:submitAdd();' class='link'>[<?php echo xlt('Add as New'); ?>]</a>
   <?php } ?>
  </td>
 </tr>

</table>
<br>
<table border='0' cellpadding='5' cellspacing='0' width='96%'>
 <tr>

  <td class='text'>
   <select name='filter[]' multiple='multiple'>
<?php
foreach ($code_types as $key => $value) {
  echo "<option value='" . attr($value['id']) . "'";
  if (isset($filter) && in_array($value['id'],$filter)) echo " selected";
  echo ">" . xlt($value['label']) . "</option>\n";
}
?>
   </select>
   &nbsp;&nbsp;&nbsp;&nbsp;

   <input type="text" name="search" size="5" value="<?php echo attr($search) ?>">&nbsp;
   <input type="submit" name="go" value='<?php echo xla('Search'); ?>'>&nbsp;&nbsp;
   <input type="checkbox" name="activeonly" value="1"
    onclick="submitList(0)" <?php echo $activeonly ? 'checked' : ''; ?> />
   <?php echo xl('Active Only'); ?>   
   <input type='checkbox' title='<?php echo xlt("Only Show Diagnosis Reporting Codes") ?>' name='search_reportable' value='1'<?php if (!empty($search_reportable)) echo ' checked'; ?> />
   <?php echo xlt('Diagnosis Reporting Only'); ?>
   &nbsp;&nbsp;&nbsp;&nbsp;
   <input type='checkbox' title='<?php echo xlt("Only Show Service Code Finance Reporting Codes") ?>' name='search_financial_reporting' value='1'<?php if (!empty($search_financial_reporting)) echo ' checked'; ?> />
   <?php echo xlt('Service Reporting Only'); ?>
   <input type='hidden' name='fstart' value='<?php echo attr($fstart) ?>'>
  </td>

  <td class='text' align='right'>
<?php if ($fstart) { ?>
   <a href="javascript:submitList(-<?php echo attr($pagesize) ?>)">
    &lt;&lt;
   </a>
   &nbsp;&nbsp;
<?php } ?>
   <?php echo ($fstart + 1) . " - $fend of $count" ?>
   &nbsp;&nbsp;
   <a href="javascript:submitList(<?php echo attr($pagesize) ?>)">
    &gt;&gt;
   </a>
  </td>

 </tr>
</table>

</form>

<table border='0' cellpadding='5' cellspacing='0' width='96%'>
 <tr>
  <td><span class='bold'><?php echo xlt('Code'); ?></span></td>
  <td><span class='bold'><?php echo xlt('Mod'); ?></span></td>
  <td><span class='bold' title='<?php echo xl('Active'); ?>'><?php echo xlt('Act'); ?></span></td>
  <?php if ($GLOBALS['ippf_specific']) { ?>
      <td class='bold' title='<?php echo xl('Initial Consult'); ?>'><?php echo xl('IC'); ?></td>
  <?php } ?>  
  <td><span class='bold'><?php echo xlt('Dx Rep'); ?></span></td>
  <td><span class='bold'><?php echo xlt('Serv Rep'); ?></span></td>
  <td><span class='bold'><?php echo xlt('Type'); ?></span></td>
  <td><span class='bold'><?php echo xlt('Description'); ?></span></td>
  <td><span class='bold'><?php echo xlt('Short Description'); ?></span></td>
<?php if (related_codes_are_used()) { ?>
  <td><span class='bold'><?php echo xlt('Related'); ?></span></td>
<?php } ?>
<?php
$pres = sqlStatement("SELECT title FROM list_options " .
  "WHERE list_id = 'pricelevel' AND activity = 1 ORDER BY seq, title");
while ($prow = sqlFetchArray($pres)) {
  echo "  <td class='bold' align='right' nowrap>" . text(xl_list_label($prow['title'])) . "</td>\n";
}
?>
  <td></td>
  <td></td>
 </tr>
<?php

if (isset($_REQUEST['filter'])) {
  $res = main_code_set_search($filter_key,$search,NULL,NULL,false,NULL,false,$fstart,($fend - $fstart),$filter_elements);
}

for ($i = 0; $row = sqlFetchArray($res); $i++) $all[$i] = $row;

if (!empty($all)) {
  $count = 0;
  foreach($all as $iter) {
    $count++;

    $has_fees = false;
    foreach ($code_types as $key => $value) {
      if ($value['id'] == $iter['code_type']) {
        $has_fees = $value['fee'];
        break;
      }
    }

    echo " <tr>\n";
    echo "  <td class='text'>" . text($iter["code"]) . "</td>\n";
    echo "  <td class='text'>" . text($iter["modifier"]) . "</td>\n";
    if ($iter["code_external"] > 0) {
      // If there is no entry in codes sql table, then default to active
      //  (this is reason for including NULL below)
      echo "  <td class='text'>" . ( ($iter["active"] || $iter["active"]==NULL) ? xlt('Yes') : xlt('No')) . "</td>\n";
    }
    else {
      echo "  <td class='text'>" . ( ($iter["active"]) ? xlt('Yes') : xlt('No')) . "</td>\n";
    }
    if ($GLOBALS['ippf_specific']) {
      // IC (Initial Consult) column. Yes, No, or blank if not applicable.
      echo "  <td class='text'>";
      if ('12' == $iter['code_type']) {
        echo $iter['cyp_factor'] == 0.00 ? xl('No') : xl('Yes');
      }
      else {
        echo '&nbsp;';
      }
      echo "</td>\n";
    }    
    echo "  <td class='text'>" . ($iter["reportable"] ? xlt('Yes') : xlt('No')) . "</td>\n";
    echo "  <td class='text'>" . ($iter["financial_reporting"] ? xlt('Yes') : xlt('No')) . "</td>\n";
    echo "  <td class='text'>" . text($iter['code_type_name']) . "</td>\n";
    echo "  <td class='text'>" . text($iter['code_text']) . "</td>\n";
    echo "  <td class='text'>" . text($iter['code_text_short']) . "</td>\n";

    if (related_codes_are_used()) {
      // Show related codes.
      echo "  <td class='text'>";
      $arel = explode(';', $iter['related_code']);
      foreach ($arel as $tmp) {
        list($reltype, $relcode) = explode(':', $tmp);
        $code_description = lookup_code_descriptions($reltype.":".$relcode);        
        echo text($relcode) . ' ' . text(trim($code_description)) . '<br />';
      }
      echo "</td>\n";
    }

    $pres = sqlStatement("SELECT p.pr_price " .
      "FROM list_options AS lo LEFT OUTER JOIN prices AS p ON " .
      "p.pr_id = ? AND p.pr_selector = '' AND p.pr_level = lo.option_id " .
      "WHERE lo.list_id = 'pricelevel' AND lo.activity = 1 ORDER BY lo.seq", array($iter['id']));
    while ($prow = sqlFetchArray($pres)) {
      echo "<td class='text' align='right'>" . text(bucks($prow['pr_price'])) . "</td>\n";
    }

    if ($iter["code_external"] > 0) {
      echo "  <td align='right'><a class='link' href='javascript:submitModify(\"" . attr($iter['code_type_name']) . "\",\"" . attr($iter['code']) . "\",\"" . attr($iter['id']) . "\")'>[" . xlt('Modify') . "]</a></td>\n";
    }
    else {
      echo " <td align='right'><a class='link' href='javascript:submitDelete(" .
             $iter['id'] .
             ", \"" . attr($iter['code' ]) . "\"" .
             ", \"" . attr($iter['code_text']) . "\"" .
             ")'>[" . xlt('Delete') . "]</a></td>\n";
      echo "  <td align='right'><a class='link' href='javascript:submitEdit("   . attr($iter['id']) . ")'>[" . xlt('Edit') . "]</a></td>\n";
    }

    echo " </tr>\n";

  }
}

?>

</table>

</center>

<script language="JavaScript">
code_type_changed();
<?php
 if ($alertmsg) {
  echo "alert('" . addslashes($alertmsg) . "');\n";
 }
?>
</script>

</body>
</html>
