<?php
/* $Id$ */
// Copyright (C) 2008-2018 Rod Roark <rod@sunsetsystems.com>
// Adapted for cross-platform operation by Bill Cernansky (www.mi-squared.com)
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// This script creates a backup tarball and sends it to the users's
// browser for download.  The tarball includes:
//
// * an OpenEMR database dump (gzipped)
// * a phpGACL database dump (gzipped), if phpGACL is used and has
//   its own database
// * a SQL-Ledger database dump (gzipped), if SQL-Ledger is used
//   (currently skipped on Windows servers)
// * the OpenEMR web directory (.tar.gz)
// * the phpGACL web directory (.tar.gz), if phpGACL is used
// * the SQL-Ledger web directory (.tar.gz), if SQL-Ledger is used
//   and its web directory exists as a sister of the openemr directory
//   and has the name "sql-ledger" (otherwise we do not have enough
//   information to find it)
//
// The OpenEMR web directory is important because it includes config-
// uration files, patient documents, and possible customizations, and
// also because the database structure is dependent on the installed
// OpenEMR version.
//
// This script depends on execution of some external programs:
// mysqldump & pg_dump.  It has been tested with Debian and Ubuntu
// Linux and with Windows XP.
// Do not assume that it works for you until you have successfully
// tested a restore!
set_time_limit(0);
require_once("../globals.php");
require_once("$srcdir/acl.inc");
require_once("$srcdir/log.inc");
require_once("$srcdir/layout.inc.php");

if (!acl_check('admin', 'super')) die(xl('Not authorized','','','!'));

include_once("Archive/Tar.php");

function csvtext($s) {
  return str_replace('"', '""', $s);
}

// Set up method, which will depend on OS and if pear tar.php is installed
if (class_exists('Archive_Tar')) {
 # pear tar.php is installed so can use os independent method
 $newBackupMethod = true;
}
elseif (IS_WINDOWS) {
 # without the tar.php module, can't run backup in windows
 die(xl("Error. You need to install the Archive/Tar.php php module."));
}
else {
 # without the tar.php module, can run via system commands in non-windows
 $newBackupMethod = false;   
}

$BTN_TEXT_CREATE = xl('Create Backup');
$BTN_TEXT_EXPORT = xl('Export Configuration');
$BTN_TEXT_IMPORT = xl('Import Configuration');
// ViSolve: Create Log  Backup button
$BTN_TEXT_CREATE_EVENTLOG = xl('Create Eventlog Backup');

$form_step   = isset($_POST['form_step']) ? trim($_POST['form_step']) : '0';
$form_status = isset($_POST['form_status' ]) ? trim($_POST['form_status' ]) : '';

if (!empty($_POST['form_export'])) $form_step = 101;
if (!empty($_POST['form_import'])) $form_step = 201;
//ViSolve: Assign Unique Number for the Log Creation
if (!empty($_POST['form_backup'])) $form_step = 301;
// When true the current form will submit itself after a brief pause.
$auto_continue = false;

# set up main paths
$backup_file_prefix = "emr_backup";
$backup_file_suffix = ".tar";
$TMP_BASE = $GLOBALS['temporary_files_dir'] . "/openemr_web_backup";
$BACKUP_DIR = $TMP_BASE . "/emr_backup";
$TAR_FILE_PATH = $TMP_BASE . DIRECTORY_SEPARATOR . $backup_file_prefix . $backup_file_suffix;
$EXPORT_FILE = $GLOBALS['temporary_files_dir'] . "/openemr_config.sql";
$MYSQL_PATH = $GLOBALS['mysql_bin_dir'];
$PERL_PATH = $GLOBALS['perl_bin_dir'];

if ($form_step == 8) {
  header("Pragma: public");
  header("Expires: 0");
  header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
  header("Content-Type: application/force-download");
  header("Content-Length: " . filesize($TAR_FILE_PATH));
  header("Content-Disposition: attachment; filename=" . basename($TAR_FILE_PATH));
  header("Content-Description: File Transfer");
  readfile($TAR_FILE_PATH);
  unlink($TAR_FILE_PATH);
  obliterate_dir($BACKUP_DIR);
  exit(0);
}

if ($form_step == 104) {
  header("Pragma: public");
  header("Expires: 0");
  header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
  header("Content-Type: application/force-download");
  header("Content-Length: " . filesize($EXPORT_FILE));
  header("Content-Disposition: attachment; filename=" . basename($EXPORT_FILE));
  header("Content-Description: File Transfer");
  readfile($EXPORT_FILE);
  unlink($EXPORT_FILE);
  exit(0);
}

// CSV export of lists.
//
if ($form_step == 102.1) {
  if (is_array($_POST['form_sel_lists'])) {
    header("Pragma: public");
    header("Expires: 0");
    header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
    header("Content-Type: application/force-download; charset=utf-8");
    header("Content-Disposition: attachment; filename=lists.csv");
    header("Content-Description: File Transfer");
    // Prepend a BOM (Byte Order Mark) header to mark the data as UTF-8.  See:
    // http://stackoverflow.com/questions/155097/microsoft-excel-mangles-diacritics-in-csv-files
    // http://crashcoursing.blogspot.com/2011/05/exporting-csv-with-special-characters.html
    echo "\xEF\xBB\xBF";
    // CSV headers:
    echo '"' . xl('List'     ) . '",';
    echo '"' . xl('ID'       ) . '",';
    echo '"' . xl('Title'    ) . '",';
    echo '"' . xl('Translated') . '",';
    echo '"' . xl('Order'    ) . '",';
    echo '"' . xl('Default'  ) . '",';
    echo '"' . xl('Active'   ) . '",';
    echo '"' . xl('Global ID') . '",';
    echo '"' . xl('Notes'    ) . '",';
    echo '"' . xl('Codes'    ) . '"';
    echo "\n";
    foreach ($_POST['form_sel_lists'] as $listid) {
      $res = sqlStatement("SELECT * FROM list_options WHERE list_id = ? ORDER BY seq, title",
        array($listid));
      while ($row = sqlFetchArray($res)) {
        $xtitle = xl_list_label($row['title']);
        if ($xtitle === $row['title']) $xtitle = '';
        echo '"' . csvtext($row['list_id']) . '",';
        echo '"' . csvtext($row['option_id']) . '",';
        echo '"' . csvtext($row['title']) . '",';
        echo '"' . csvtext($xtitle) . '",';
        echo '"' . csvtext($row['seq']) . '",';
        echo '"' . csvtext($row['is_default']) . '",';
        echo '"' . csvtext($row['activity']) . '",';
        echo '"' . csvtext($row['mapping']) . '",';
        echo '"' . csvtext($row['notes']) . '",';
        echo '"' . csvtext($row['codes']) . '"';
        echo "\n";
      }
    }
  }
  exit(0);
}

// CSV export of layouts.
//
if ($form_step == 102.2) {
  if (is_array($_POST['form_sel_layouts'])) {
    header("Pragma: public");
    header("Expires: 0");
    header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
    header("Content-Type: application/force-download; charset=utf-8");
    header("Content-Disposition: attachment; filename=layouts.csv");
    header("Content-Description: File Transfer");
    // Prepend a BOM (Byte Order Mark) header to mark the data as UTF-8.  See:
    // http://stackoverflow.com/questions/155097/microsoft-excel-mangles-diacritics-in-csv-files
    // http://crashcoursing.blogspot.com/2011/05/exporting-csv-with-special-characters.html
    echo "\xEF\xBB\xBF";
    // CSV headers:
    echo '"' . xl('Form'       ) . '",';
    echo '"' . xl('Order'      ) . '",';
    echo '"' . xl('Source'     ) . '",';
    echo '"' . xl('Group'      ) . '",';
    echo '"' . xl('ID'         ) . '",';
    echo '"' . xl('Label'      ) . '",';
    echo '"' . xl('Translated' ) . '",';
    echo '"' . xl('UOR'        ) . '",';
    echo '"' . xl('Type'       ) . '",';
    echo '"' . xl('Width'      ) . '",';
    echo '"' . xl('Height'     ) . '",';
    echo '"' . xl('Max'        ) . '",';
    echo '"' . xl('List'       ) . '",';
    echo '"' . xl('Label Cols' ) . '",';
    echo '"' . xl('Data Cols'  ) . '",';
    echo '"' . xl('Options'    ) . '",';
    echo '"' . xl('Description') . '",';
    echo '"' . xl('Translated' ) . '",';
    echo '"' . xl('Conditions' ) . '"';
    echo "\n";
    foreach ($_POST['form_sel_layouts'] as $layoutid) {
      $res = sqlStatement("SELECT l.*, p.grp_title FROM layout_options AS l " .
        "JOIN layout_group_properties AS p ON p.grp_form_id = l.form_id AND p.grp_group_id = l.group_id AND p.grp_activity = 1 " .
        "WHERE l.form_id = ? ORDER BY l.group_id, l.seq, l.title",
        array($layoutid));
      while ($row = sqlFetchArray($res)) {
        $xtitle = xl_layout_label($row['title']);
        if ($xtitle === $row['title']) $xtitle = '';
        $xdesc = $row['description'];
        if (substr($xdesc, 0, 1) != '<') {
          $xdesc = xl_layout_label($xdesc);
        }
        if ($xdesc === $row['description']) $xdesc = '';
        echo '"' . csvtext($row['form_id'     ]) . '",';
        echo '"' . csvtext($row['seq'         ]) . '",';
        echo '"' . csvtext($sources[$row['source']]) . '",';
        echo '"' . csvtext($row['grp_title'   ]) . '",';
        echo '"' . csvtext($row['field_id'    ]) . '",';
        echo '"' . csvtext($row['title'       ]) . '",';
        echo '"' . csvtext($xtitle             ) . '",';
        echo '"' . csvtext($UOR[$row['uor']]   ) . '",';
        echo '"' . csvtext($datatypes[$row['data_type']]) . '",';
        echo '"' . csvtext($row['fld_length'  ]) . '",';
        echo '"' . csvtext($row['fld_rows'    ]) . '",';
        echo '"' . csvtext($row['max_length'  ]) . '",';
        echo '"' . csvtext($row['list_id'     ]) . '",';
        echo '"' . csvtext($row['titlecols'   ]) . '",';
        echo '"' . csvtext($row['datacols'    ]) . '",';
        echo '"' . csvtext($row['edit_options']) . '",';
        echo '"' . csvtext($row['description' ]) . '",';
        echo '"' . csvtext($xdesc              ) . '",';
        echo '"' . csvtext($row['conditions'  ]) . '"';
        echo "\n";
      }
    }
  }
  exit(0);
}
?>
<html>

<head>
<link rel="stylesheet" href='<?php echo $css_header ?>' type='text/css'>
<title><?php xl('Backup','e'); ?></title>

<script language="JavaScript">

// Called from export page to specify what it will do.
//   102   = SQL export of selected tables, lists and layouts
//   102.1 = Download selected lists as CSV
//   102.2 = download selected layouts as CSV
//
function export_submit(step) {
 var f = document.forms[0];
 f.form_step.value = step;
 top.restoreSession();
 f.submit();
}

</script>

</head>

<body class="body_top">
<center>
&nbsp;<br />
<form method='post' action='backup.php' enctype='multipart/form-data'>

<table style='width:50em'>
 <tr>
  <td>

<?php
$cmd = '';
$mysql_cmd = $MYSQL_PATH . DIRECTORY_SEPARATOR . 'mysql';
$mysql_dump_cmd = $mysql_cmd . 'dump';
$file_to_compress = '';  // if named, this iteration's file will be gzipped after it is created 
$eventlog=0;  // Eventlog Flag

if ($form_step == 0) {
  echo "<table>\n";
  echo " <tr>\n";
  echo "  <td><input type='submit' name='form_create' value='$BTN_TEXT_CREATE' /></td>\n";
  echo "  <td>" . xl('Create and download a full backup') . "</td>\n";
  echo " </tr>\n";
  // The config import/export feature is optional.
  if (!empty($GLOBALS['configuration_import_export'])) {
    echo " <tr>\n";
    echo "  <td><input type='submit' name='form_export' value='$BTN_TEXT_EXPORT' /></td>\n";
    echo "  <td>" . xl('Download configuration data') . "</td>\n";
    echo " </tr>\n";
    echo " <tr>\n";
    echo "  <td><input type='submit' name='form_import' value='$BTN_TEXT_IMPORT' /></td>\n";
    echo "  <td>" . xl('Upload configuration data') . "</td>\n";
    echo " </tr>\n";
    }
// ViSolve : Add ' Create Log table backup Button'
   echo " <tr>\n";
   echo "  <td><input type='submit' name='form_backup' value='$BTN_TEXT_CREATE_EVENTLOG' /></td>\n";
   echo "  <td>" . xl('Create Eventlog Backup') . "</td>\n";
   echo " </tr>\n";
   echo " <tr>\n";
   echo "  <td></td><td class='text'><b>" . xl('Note')."</b>&nbsp;" . xl('Please refer to').'&nbsp;README-Log-Backup.txt&nbsp;'.xl('file in the Documentation directory to learn how to automate the process of creating log backups') . "</td>\n";
   echo " </tr>\n";
  echo "</table>\n";
}

if ($form_step == 1) {
  $form_status .= xl('Dumping OpenEMR database') . "...<br />";
  echo nl2br($form_status);
  if (file_exists($TAR_FILE_PATH))
    if (! unlink($TAR_FILE_PATH)) die(xl("Couldn't remove old backup file:") . " " . $TAR_FILE_PATH);
  if (! obliterate_dir($TMP_BASE)) die(xl("Couldn't remove dir:"). " " . $TMP_BASE);
  if (! mkdir($BACKUP_DIR, 0777, true)) die(xl("Couldn't create backup dir:") . " " . $BACKUP_DIR);
  $file_to_compress = "$BACKUP_DIR/openemr.sql";   // gzip this file after creation
  
  if($GLOBALS['include_de_identification']==1)
  {
    //include routines during backup when de-identification is enabled
    $cmd = "$mysql_dump_cmd -u " . escapeshellarg($sqlconf["login"]) .
    " -p" . escapeshellarg($sqlconf["pass"]) .
    " -h" . escapeshellarg($sqlconf["host"]) .
    " --port=".escapeshellarg($sqlconf["port"]) .
    " --routines".
    " --opt --quote-names -r $file_to_compress " .
    escapeshellarg($sqlconf["dbase"]);
  }
  else
  { 
    $cmd = "$mysql_dump_cmd -u " . escapeshellarg($sqlconf["login"]) .
    " -p" . escapeshellarg($sqlconf["pass"]) .
    " -h" . escapeshellarg($sqlconf["host"]) .
    " --port=".escapeshellarg($sqlconf["port"]) .
    " --opt --quote-names -r $file_to_compress " .
    escapeshellarg($sqlconf["dbase"]);
  } 
  $auto_continue = true;
}

if ($form_step == 2) {
  if (!empty($phpgacl_location) && $gacl_object->_db_name != $sqlconf["dbase"]) {
    $form_status .= xl('Dumping phpGACL database') . "...<br />";
    echo nl2br($form_status);
    $file_to_compress = "$BACKUP_DIR/phpgacl.sql";   // gzip this file after creation
    $cmd = "$mysql_dump_cmd -u " . escapeshellarg($gacl_object->_db_user) .
      " -p" . escapeshellarg($gacl_object->_db_password) .
      " --opt --quote-names -r $file_to_compress " .
      escapeshellarg($gacl_object->_db_name);
    $auto_continue = true;
  }
  else {
    ++$form_step;
  }
}

if ($form_step == 3) {
  if ($GLOBALS['oer_config']['ws_accounting']['enabled'] &&
      $GLOBALS['oer_config']['ws_accounting']['enabled'] !== 2) {
    if (IS_WINDOWS) {
      // Somebody may want to make this work in Windows, if they have SQL-Ledger set up.
      $form_status .= xl('Skipping SQL-Ledger dump - not implemented for Windows server') . "...<br />";
      echo nl2br($form_status);
      ++$form_step;
    }
    else {
      $form_status .= xl('Dumping SQL-Ledger database') . "...<br />";
      echo nl2br($form_status);
      $file_to_compress = "$BACKUP_DIR/sql-ledger.sql";   // gzip this file after creation
      $cmd = "PGPASSWORD=" . escapeshellarg($sl_dbpass) . " pg_dump -U " .
        escapeshellarg($sl_dbuser) . " -h localhost --format=c -f " .
        "$file_to_compress " . escapeshellarg($sl_dbname);
      $auto_continue = true;
    }
  }
  else {
    ++$form_step;
  }
}

if ($form_step == 4) {
  $form_status .= xl('Dumping OpenEMR web directory tree') . "...<br />";
  echo nl2br($form_status);
  $cur_dir = getcwd();
  chdir($webserver_root);

  // Select the files and directories to archive.  Basically everything
  // except site-specific data for other sites.
  $file_list = array();
  $dh = opendir($webserver_root);
  if (!$dh) die("Cannot read directory '$webserver_root'.");
  while (false !== ($filename = readdir($dh))) {
    if ($filename == '.' || $filename == '..') continue;
    if ($filename == 'sites') {
      // Omit other sites.
      $file_list[] = "$filename/" . $_SESSION['site_id'];
    }
    else {
      $file_list[] = $filename;
    }
  }
  closedir($dh);

  $arch_file = $BACKUP_DIR . DIRECTORY_SEPARATOR . "openemr.tar.gz";
  if (!create_tar_archive($arch_file, "gz", $file_list))
    die(xl("An error occurred while dumping OpenEMR web directory tree"));
  chdir($cur_dir);
  $auto_continue = true;
}

if ($form_step == 5) {
  if ((!empty($phpgacl_location)) && ($phpgacl_location != $srcdir."/../gacl") ) {
    $form_status .= xl('Dumping phpGACL web directory tree') . "...<br />";
    echo nl2br($form_status);
    $cur_dir = getcwd();
    chdir($phpgacl_location);
    $file_list = array('.');    // archive entire directory
    $arch_file = $BACKUP_DIR . DIRECTORY_SEPARATOR . "phpgacl.tar.gz";
    if (!create_tar_archive($arch_file, "gz", $file_list))
      die (xl("An error occurred while dumping phpGACL web directory tree"));
    chdir($cur_dir);
    $auto_continue = true;
  }
  else {
    ++$form_step;
  }
}

if ($form_step == 6) {
  if ($GLOBALS['oer_config']['ws_accounting']['enabled'] &&
    $GLOBALS['oer_config']['ws_accounting']['enabled'] !== 2 &&
    is_dir("$webserver_root/../sql-ledger"))
  {
    $form_status .= xl('Dumping SQL-Ledger web directory tree') . "...<br />";
    echo nl2br($form_status);
    $cur_dir = getcwd();
    $arch_dir = $webserver_root . DIRECTORY_SEPARATOR . ".." . DIRECTORY_SEPARATOR . "sql-ledger";
    chdir($arch_dir);
    $file_list = array('.');    // archive entire directory
    $arch_file = $BACKUP_DIR . DIRECTORY_SEPARATOR . "sql-ledger.tar.gz";
    if (!create_tar_archive($arch_file, "gz", $file_list))
      die(xl("An error occurred while dumping SQL-Ledger web directory tree"));
    chdir($cur_dir);
    $auto_continue = true;
  }
  else {
    ++$form_step;
  }
}
if ($form_step == 7) {   // create the final compressed tar containing all files
  $form_status .= xl('Backup file has been created. Will now send download.') . "<br />";
  echo nl2br($form_status);
  $cur_dir = getcwd();
  chdir($BACKUP_DIR);
  $file_list = array('.');
  if (!create_tar_archive($TAR_FILE_PATH, '', $file_list))
    die(xl("Error: Unable to create downloadable archive"));
  chdir($cur_dir);
   /* To log the backup event */
  if ($GLOBALS['audit_events_backup']){
  newEvent("backup", $_SESSION['authUser'], $_SESSION['authProvider'], 0,"Backup is completed");
}
  $auto_continue = true;
}

if ($form_step == 101) {
  echo "<p><b>&nbsp;" . xl('Select the configuration items to export') . ":</b></p>";

  echo "<table cellspacing='10' cellpadding='0'>\n<tr>\n<td valign='top' nowrap>\n";

  echo "<b>" . xlt('Tables') . "</b><br />\n";
  echo "<input type='checkbox' name='form_cb_services' value='1' />\n";
  echo " " . xl('Services') . "<br />\n";
  echo "<input type='checkbox' name='form_cb_products' value='1' />\n";
  echo " " . xl('Products') . "<br />\n";
  echo "<input type='checkbox' name='form_cb_prices' value='1' />\n";
  echo " " . xl('Prices') . "<br />\n";
  echo "<input type='checkbox' name='form_cb_categories' value='1' />\n";
  echo " " . xl('Document Categories') . "<br />\n";
  echo "<input type='checkbox' name='form_cb_feesheet' value='1' />\n";
  echo " " . xl('Fee Sheet Options') . "<br />\n";
  echo "<input type='checkbox' name='form_cb_lang' value='1' />\n";
  echo " " . xl('Translations') . "<br />\n";

  // Multi-select for lists.
  echo "</td><td valign='top'>\n";
  echo "<b>" . xlt('Lists') . "</b><br />\n";
  echo "<select multiple name='form_sel_lists[]' size='15'>";
  $lres = sqlStatement("SELECT option_id, title FROM list_options WHERE " .
    "list_id = 'lists' AND activity = 1 ORDER BY title, seq");
  while ($lrow = sqlFetchArray($lres)) {
    $key = $lrow['option_id'];
    echo "<option value='$key'";
    echo ">" . text(xl_list_label($lrow['title'])) . "</option>\n";
  }
  echo "</select>\n";
  echo "<br /><a href='#' onclick='export_submit(102.1)'>" . xlt('Download CSV') . "</a>";

  // Multi-select for layouts.
  echo "</td><td valign='top'>\n";
  echo "<b>" . xlt('Layouts') . "</b><br />\n";
  echo "<select multiple name='form_sel_layouts[]' size='15'>";
  $lres = sqlStatement("SELECT grp_form_id, grp_title FROM layout_group_properties WHERE " .
    "grp_group_id = '' AND grp_activity = 1 ORDER BY grp_form_id");
  while ($lrow = sqlFetchArray($lres)) {
    $key = $lrow['grp_form_id'];
    echo "<option value='" . attr($key) . "'";
    echo ">" . text($key) . ": " . text(xl_layout_label($lrow['grp_title'])) . "</option>\n";
  }
  echo "</select>\n";
  echo "<br /><a href='#' onclick='export_submit(102.2)'>" . xlt('Download CSV') . "</a>";

  echo "</td>\n</tr>\n</table>\n";
  echo "&nbsp;<br /><input type='button' onclick='export_submit(102)' value='" . xla('Continue') . "' />\n";
}

if ($form_step == 102) {
  $tables = '';
  if ($_POST['form_cb_services'  ]) $tables .= ' codes';
  if ($_POST['form_cb_products'  ]) $tables .= ' drugs drug_templates';
  if ($_POST['form_cb_prices'    ]) $tables .= ' prices';
  if ($_POST['form_cb_categories']) $tables .= ' categories categories_seq';
  if ($_POST['form_cb_feesheet'  ]) $tables .= ' fee_sheet_options';
  if ($_POST['form_cb_lang'      ]) $tables .= ' lang_languages lang_constants lang_definitions';
  if ($tables || is_array($_POST['form_sel_lists']) || is_array($_POST['form_sel_layouts'])) {
    $form_status .= xl('Creating export file') . "...<br />";
    echo nl2br($form_status);
    if (file_exists($EXPORT_FILE)) {
      if (! unlink($EXPORT_FILE)) die(xl("Couldn't remove old export file: ") . $EXPORT_FILE);
    }
    $cmd = "echo 'SET character_set_client = utf8;' > $EXPORT_FILE;";
    // The substitutions below use perl because sed's not usually on windows systems.
    $perl = $PERL_PATH . DIRECTORY_SEPARATOR . 'perl';
    if ($tables) {
      $cmd .= "$mysql_dump_cmd -u " . escapeshellarg($sqlconf["login"]) .
        " -p" . escapeshellarg($sqlconf["pass"]) .
        " --opt --quote-names " .
        escapeshellarg($sqlconf["dbase"]) . " $tables" .
        " | $perl -pe 's/ DEFAULT CHARSET=utf8//i; s/ collate[ =][^ ;,]*//i;'" .
        " >> $EXPORT_FILE;";
    }
    $dumppfx = "$mysql_dump_cmd -u " . escapeshellarg($sqlconf["login"]) .
      " -p" . escapeshellarg($sqlconf["pass"]) .
      " --skip-opt --quote-names --complete-insert --no-create-info";
    // Individual lists.
    if (is_array($_POST['form_sel_lists'])) {
      foreach ($_POST['form_sel_lists'] as $listid) {
        $cmd .= "echo \"DELETE FROM list_options WHERE list_id = '$listid';\" >> $EXPORT_FILE;";
        $cmd .= "echo \"DELETE FROM list_options WHERE list_id = 'lists' AND option_id = '$listid';\" >> $EXPORT_FILE;";
        $cmd .= $dumppfx .
          " --where=\"list_id = 'lists' AND option_id = '$listid' OR list_id = '$listid' " .
          "ORDER BY list_id != 'lists', seq, title\" " .
          escapeshellarg($sqlconf["dbase"]) . " list_options" .
          " >> $EXPORT_FILE;";
      }
    }
    // Individual layouts.
    if (is_array($_POST['form_sel_layouts'])) {
      foreach ($_POST['form_sel_layouts'] as $layoutid) {
        $cmd .= "echo \"DELETE FROM layout_options WHERE form_id = '$layoutid';\" >> $EXPORT_FILE;";
        $cmd .= "echo \"DELETE FROM layout_group_properties WHERE grp_form_id = '$layoutid';\" >> $EXPORT_FILE;";
        $cmd .= $dumppfx .
          " --where=\"grp_form_id = '$layoutid'\" " .
          escapeshellarg($sqlconf["dbase"]) . " layout_group_properties" .
          " >> $EXPORT_FILE;";
        $cmd .= $dumppfx .
          " --where=\"form_id = '$layoutid' ORDER BY group_id, seq, title\" " .
          escapeshellarg($sqlconf["dbase"]) . " layout_options" .
          " >> $EXPORT_FILE;";

        if (substr($layoutid, 0, 3) == 'HIS') {
          $cres = sqlStatement("select field_id from layout_options " .
            "where form_id = '$layoutid' and uor > 0");
          while ($crow = sqlFetchArray($cres)) {
            $fldid = $crow['field_id'];
            $cmd .= "echo \"ALTER TABLE history_data ADD \`$fldid\` TEXT NOT NULL;\" >> $EXPORT_FILE;";
          }
        }

      }
    }
  }
  else {
    echo xl('No items were selected!');
    $form_step = -1;
  }
  $auto_continue = true;
}

if ($form_step == 103) {
  $form_status .= xl('Done.  Will now send download.') . "<br />";
  echo nl2br($form_status);
  $auto_continue = true;
}

if ($form_step == 201) {
  echo xl('WARNING: This will overwrite configuration information with data from the uploaded file!') . " \n";
  echo xl('Use this feature only with newly installed sites, ');
  echo xl('otherwise you will destroy references to/from existing data.') . "\n";
  echo "<br />&nbsp;<br />\n";
  echo xl('File to upload') . ":\n";
  echo "<input type='hidden' name='MAX_FILE_SIZE' value='16000000' />\n";
  echo "<input type='file' name='userfile' /><br />&nbsp;<br />\n";
  echo "<input type='submit' value='" . xl('Continue') . "' />\n";
}

if ($form_step == 202) {
  // Process uploaded config file.
  if (is_uploaded_file($_FILES['userfile']['tmp_name'])) {
    if (move_uploaded_file($_FILES['userfile']['tmp_name'], $EXPORT_FILE)) {
      $form_status .= xl('Applying') . "...<br />";
      echo nl2br($form_status);
      $cmd = "$mysql_cmd -u" . escapeshellarg($sqlconf["login"]) .
        // "-f" is used to ignore errors. This is a kludge for adding columns that may already exist.
        " -f -p" . escapeshellarg($sqlconf["pass"]) . " " .
        escapeshellarg($sqlconf["dbase"]) .
        " < $EXPORT_FILE";
    }
    else {
      echo xl('Internal error accessing uploaded file!');
      $form_step = -1;
    }
  }
  else {
    echo xl('Upload failed!');
    $form_step = -1;
  }
  $auto_continue = true;
}

if ($form_step == 203) {
  $form_status .= xl('Done') . ".";
  echo nl2br($form_status);
}

/// ViSolve : EventLog Backup
if ($form_step == 301) {
# Get the Current Timestamp, to attach with the log backup file
  $backuptime=date("Ymd_His");
# Eventlog backup directory
$BACKUP_EVENTLOG_DIR = $GLOBALS['backup_log_dir'] . "/emr_eventlog_backup";

# Check if Eventlog Backup directory exists, if not create it with Write permission
  if (!file_exists($BACKUP_EVENTLOG_DIR))
  {
  mkdir($BACKUP_EVENTLOG_DIR);
  chmod($BACKUP_EVENTLOG_DIR,0777);
}
# Frame the Eventlog Backup File Name
$BACKUP_EVENTLOG_FILE=$BACKUP_EVENTLOG_DIR.'/eventlog_'.$backuptime.'.sql';
# Create a new table similar to event table, rename the existing table as backup table, and rename the new table to event log table.  Then export the contents of the table into a text file and drop the table.
$res=sqlStatement("create table if not exists log_new like log");
$res=sqlStatement("rename table log to log_backup,log_new to log");
echo "<br>";
  $cmd = "$mysql_dump_cmd -u " . escapeshellarg($sqlconf["login"]) .
    " -p" . escapeshellarg($sqlconf["pass"]) .
    " --opt --quote-names -r $BACKUP_EVENTLOG_FILE " .
    escapeshellarg($sqlconf["dbase"]) ." --tables log_backup";
# Set Eventlog Flag when it is done
$eventlog=1;
// 301 If ends here.
}

++$form_step;
?>

  </td>
 </tr>
</table>

<input type='hidden' name='form_step' value='<?php echo $form_step; ?>' />
<input type='hidden' name='form_status' value='<?php echo $form_status; ?>' />

</form>

<?php
ob_flush();
flush();
if ($cmd) {
  $tmp0 = exec($cmd, $tmp1, $tmp2);

  if ($tmp2) 
  {
    if ($eventlog==1)
     {
	// ViSolve : Restore previous state, if backup fails.
         $res=sqlStatement("drop table if exists log");
         $res=sqlStatement("rename table log_backup to log");
     }
    die("\"$cmd\" returned $tmp2: $tmp0");
  }
  //  ViSolve:  If the Eventlog is set, then clear the temporary table  -- Start here
  if ($eventlog==1)       {
        $res=sqlStatement("drop table if exists log_backup");
        echo "<br><b>";
        echo xl('Backup Successfully taken in')." ";
        echo  $BACKUP_EVENTLOG_DIR; 
		echo "</b>";
     }
 //  ViSolve:  If the Eventlog is set, then clear the temporary table  -- Ends here
}
// If a file was flagged to be gzip-compressed after this cmd, do it.
if ($file_to_compress) {
  if (!gz_compress_file($file_to_compress))
    die (xl("Error in gzip compression of file: ") . $file_to_compress);  
}
?>

</center>

<?php if ($auto_continue) { ?>
<script language="JavaScript">
 setTimeout("document.forms[0].submit();", 500);
</script>
<?php }

// Recursive directory remove (like an O/S insensitive "rm -rf dirname")
function obliterate_dir($dir) {
  if (!file_exists($dir)) return true;
  if (!is_dir($dir) || is_link($dir)) return unlink($dir);
  foreach (scandir($dir) as $item) {
    if ($item == '.' || $item == '..') continue;
    if (!obliterate_dir($dir . DIRECTORY_SEPARATOR . $item)) {
      chmod($dir . DIRECTORY_SEPARATOR . $item, 0777);
      if (!obliterate_dir($dir . DIRECTORY_SEPARATOR . $item)) return false;
    };
  }
  return rmdir($dir);
}

// Create a tar archive given the archive file name, compression method if any, and the
// array of file/directory names to archive
function create_tar_archive($archiveName, $compressMethod, $itemArray) {  
  global $newBackupMethod;
    
  if ($newBackupMethod) {
   // Create a tar object using the pear library
   //  (this is the preferred method)
   $tar = new Archive_Tar($archiveName, $compressMethod);
   if ($tar->create($itemArray)) return true;
  }
  else {
   // Create the tar files via command line tools
   //  (this method used when the tar pear library is not available)  
   $files = '"' . implode('" "', $itemArray) . '"';
   if ($compressMethod == "gz") {
    $command = "tar --same-owner --ignore-failed-read -zcphf $archiveName $files";
   }
   else {
    $command = "tar -cpf $archiveName $files";
   }
   $temp0 = exec($command, $temp1, $temp2);
   if ($temp2) die("\"$command\" returned $temp2: $temp0");
   return true;
  }
  return false;
}

// Compress a file using gzip. Source file removed, leaving only the compressed
// *.gz file, just like gzip command line would behave.
function gz_compress_file($source) {
  $dest=$source.'.gz';
  $error=false;
  if ($fp_in=fopen($source,'rb')) {
    if ($fp_out=gzopen($dest,'wb')) {
      while(!feof($fp_in))
        gzwrite($fp_out,fread($fp_in,1024*512));
      gzclose($fp_out);
      fclose($fp_in);
      unlink($source);
    }
    else $error=true;
  }
  else $error=true;
  if($error)
    return false;
  else
    return $dest;
}
?>

</body>
</html>
