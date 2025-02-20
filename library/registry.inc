<?php
//these are the functions used to access the forms registry database
//
//include_once("../../globals.php");
include_once("{$GLOBALS['srcdir']}/sql.inc");

function registerForm ( $directory , $sql_run=0 , $unpackaged=1 , $state=0 )
{
	$check = sqlQuery("select state from registry where directory='$directory'");
	if ($check == false)
	{
		$lines = @file($GLOBALS['srcdir']."/../interface/forms/$directory/info.txt");
		if ($lines)
			$name = $lines[0];
		else
			$name = $directory;
		return sqlInsert("insert into registry set
			name='$name',
			state='$state',
			directory='".add_escape_custom($directory)."',
			sql_run='$sql_run',
			unpackaged='$unpackaged',
			date=NOW()
		");
	}
	return false;
}

function updateRegistered ( $id, $mod )
{
	return sqlInsert("update registry set
		$mod,
		date=NOW() 
	where
		id='$id'
	");
}

function getRegistered ( $state="1", $limit="unlimited", $offset="0")
{
	$sql = "select * from registry where state like \"$state\" order by priority, name";
	if ($limit != "unlimited")
		$sql .= " limit $limit, $offset";
	$res = sqlStatement($sql);
	if ($res)
	for($iter=0; $row=sqlFetchArray($res); $iter++)
	{
		$all[$iter] = $row;
	}
	else
		return false;
	return $all;
}

function getRegistryEntry ( $id, $cols = "*" )
{
    $sql = "select $cols from registry where id=?";
    return sqlQuery($sql, array($id));
}

function installSQL ( $dir )
{
	$sqltext = $dir."/table.sql";
	if ($sqlarray = @file($sqltext))
	{
		$sql = implode("", $sqlarray);
		//echo "<br>$sql<br><br>";
		$sqla = explode(";",$sql);
		foreach ($sqla as $sqlq) {
		  if (strlen($sqlq) > 5) {
		   sqlStatement(rtrim("$sqlq"));
		  }
		}
			
		return true;
	}else
		return false;
}


/* 
 * is a form registered
 *  (optional - and active)
 * in the database?
 * 
 * NOTE - sometimes the Name of a form has a line-break at the end, thus this function might be better
 *
 *  INPUT =   directory => form directory
 *            state => 0=inactive / 1=active
 *  OUTPUT = true or false
 */
function isRegistered ( $directory, $state = 1)
{
    $sql = "select id from registry where ".
            "directory='".$directory.
            "' and state=".$state;
    $result = sqlQuery($sql);
    if ($result['id'] != '') return true;
    return false;
}

// This gets an array including both standard and LBF visit form types,
// one row per form type, sorted by category, priority, is lbf, name.
//
function getFormsByCategory($state='1', $lbfonly=false) {
  $all = array();
  if (!$lbfonly) {
    // First get the traditional form types from the registry table.
    $sql = "SELECT category, nickname, name, state, directory, id, sql_run, " .
      "unpackaged, date, priority FROM registry WHERE " .
      "state LIKE ? ORDER BY category, priority, name";
    $res = sqlStatement($sql, array($state));
    if ($res) {
      while ($row = sqlFetchArray($res)) {
        // Skip fee_sheet from list of registered forms.
        if ($row['directory'] != 'fee_sheet') {
          // Flag this entry as not LBF
          $row['LBF'] = false;
          $all[] = $row;      
        }
      }
    }
  }

  // Merge LBF form types into the registry array of form types.
  // Note that the mapping value is used as the category name.

  $lres = sqlStatement("SELECT * FROM layout_group_properties " .
    "WHERE grp_form_id LIKE 'LBF%' AND grp_group_id = '' AND grp_activity = 1 " .
    "ORDER BY grp_mapping, grp_seq, grp_title");
  while ($lrow = sqlFetchArray($lres)) {
    $rrow = array();
    $rrow['category']  = $lrow['grp_mapping'] ? $lrow['grp_mapping'] : 'Clinical';
    $rrow['name']      = $lrow['grp_title'];
    $rrow['nickname']  = $lrow['grp_title'];
    $rrow['directory'] = $lrow['grp_form_id']; // should start with LBF
    $rrow['priority']  = $lrow['grp_seq'];
    $rrow['LBF']       = true; // Flag this form as LBF
    $all[] = $rrow;
  }

  // Sort by category, priority, is lbf, name.
  usort($all, function ($a, $b) {
    // Anonymous functions supported as of PHP 5.3. Yay!
    if ($a['category'] == $b['category']) {
      if ($a['priority'] == $b['priority']) {
        if($a['LBF'] == $b['LBF']) {
          $name1 = $a['nickname'] ? $a['nickname'] : $a['name'];
          $name2 = $b['nickname'] ? $b['nickname'] : $b['name'];
          if ($name1 == $name2) return 0;
          return $name1 < $name2 ? -1 : 1;        
        }
        else {
          // Sort LBF with the same priority after standard forms
          return $b['LBF'] ? -1 : 1;
        }
      }
      return $a['priority'] < $b['priority'] ? -1 : 1;
    }
    return $a['category'] < $b['category'] ? -1 : 1;
  });
  return $all;
}
?>
