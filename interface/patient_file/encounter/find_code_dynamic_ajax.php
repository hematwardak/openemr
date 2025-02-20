<?php
// Copyright (C) 2015-2017 Rod Roark <rod@sunsetsystems.com>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

$sanitize_all_escapes  = true;
$fake_register_globals = false;

require_once("../../globals.php");
require_once("$srcdir/formdata.inc.php");
require_once("$srcdir/formatting.inc.php");
require_once("$srcdir/jsonwrapper/jsonwrapper.php");
require_once("$srcdir/options.inc.php");
require_once($GLOBALS['fileroot'] . '/custom/code_types.inc.php');

// Paging parameters.  -1 means not applicable.
//
$iDisplayStart  = isset($_GET['iDisplayStart' ]) ? 0 + $_GET['iDisplayStart' ] : -1;
$iDisplayLength = isset($_GET['iDisplayLength']) ? 0 + $_GET['iDisplayLength'] : -1;
$limit = '';
if ($iDisplayStart >= 0 && $iDisplayLength >= 0) {
  $limit = "LIMIT " . escape_limit($iDisplayStart) . ", " . escape_limit($iDisplayLength);
}

// What we are picking from: codes, fields, lists or groups
$what = $_GET['what'];
$layout_id = '';

if ($what == 'codes') {
  $codetype = $_GET['codetype'];
  $prod = $codetype == 'PROD';
  $ncodetype = $code_types[$codetype]['id'];
  $include_inactive = !empty($_GET['inactive']);
}
else if ($what == 'fields') {
  $source = empty($_GET['source']) ? 'D' : $_GET['source'];
  if ($source == 'D') $layout_id = 'DEM'; else
  if ($source == 'H') $layout_id = 'HIS%'; else
  if ($source == 'E') $layout_id = 'LBF%';
}
else if ($what == 'groups') {
  if (!empty($_GET['layout_id'])) $layout_id = $_GET['layout_id'];
}

$form_encounter_layout = array(
  array('field_id'     => 'date',
        'title'        => xl('Visit Date'),
        'uor'          => '1',
        'data_type'    => '4',               // Text-date
        'list_id'      => '',
        'edit_options' => '',
       ),
  array('field_id'     => 'facility_id',
        'title'        => xl('Service Facility'),
        'uor'          => '1',
        'data_type'    => '35',              // Facilities
        'list_id'      => '',
        'edit_options' => '',
       ),
  array('field_id'     => 'pc_catid',
        'title'        => xl('Visit Category'),
        'uor'          => '1',
        'data_type'    => '18',              // Visit Category
        'list_id'      => '',
        'edit_options' => '',
       ),
  array('field_id'     => 'reason',
        'title'        => xl('Reason for Visit'),
        'uor'          => '1',
        'data_type'    => '2',               // Text
        'list_id'      => '',
        'edit_options' => '',
       ),
  array('field_id'     => 'onset_date',
        'title'        => xl('Date of Onset'),
        'uor'          => '1',
        'data_type'    => '4',               // Text-date
        'list_id'      => '',
        'edit_options' => '',
       ),
  array('field_id'     => 'referral_source',
        'title'        => xl('Referral Source'),
        'uor'          => '1',
        'data_type'    => '1',               // List
        'list_id'      => 'refsource',
        'edit_options' => '',
       ),
  array('field_id'     => 'shift',
        'title'        => xl('Shift'),
        'uor'          => '1',
        'data_type'    => '1',               // List
        'list_id'      => 'shift',
        'edit_options' => '',
       ),
  array('field_id'     => 'billing_facility',
        'title'        => xl('Billing Facility'),
        'uor'          => '1',
        'data_type'    => '35',              // Facilities
        'list_id'      => '',
        'edit_options' => '',
       ),
  array('field_id'     => 'voucher_number',
        'title'        => xl('Voucher Number'),
        'uor'          => '1',
        'data_type'    => '2',               // Text
        'list_id'      => '',
        'edit_options' => '',
       ),
);

function feSearchSort($search='', $column=0, $reverse=false) {
  global $form_encounter_layout;
  $arr = array();
  foreach ($form_encounter_layout as $feitem) {
    if ($search && stripos($feitem['field_id'], $search) === false &&
      stripos($feitem['title'], $search) === false ) {
      continue;
    }
    $feitem['fld_length' ] = 20;
    $feitem['max_length' ] = 0;
    $feitem['titlecols'  ] = 1;
    $feitem['datacols'   ] = 3;
    $feitem['description'] = '';
    $feitem['fld_rows'   ] = 0;
    $key = $column ? 'title' : 'field_id';
    $arr[$feitem[$key]] = $feitem;
  }
  ksort($arr);
  if ($reverse) $arr = array_reverse($arr);
  return $arr;
}

function genFieldIdString($row) {
  return 'CID|' . json_encode($row);
}

// Column sorting parameters.
//
$orderby = '';
$fe_column = 0;
$fe_reverse = false;
if (isset($_GET['iSortCol_0'])) {
	for ($i = 0; $i < intval($_GET['iSortingCols']); ++$i) {
    $iSortCol = intval($_GET["iSortCol_$i"]);
		if ($_GET["bSortable_$iSortCol"] == "true" ) {
      $sSortDir = escape_sort_order($_GET["sSortDir_$i"]); // ASC or DESC
      // We are to sort on column # $iSortCol in direction $sSortDir.
      $orderby .= $orderby ? ', ' : 'ORDER BY ';

      // Note the primary sort column and direction for later logic.
      if ($i == 0) {
        $fe_column = $iSortCol;
        $fe_reverse = $sSortDir == 'DESC';
      }

      if ($what == 'codes') {
        if ($iSortCol == 0) {
          $orderby .= $prod ? "d.drug_id $sSortDir, t.selector $sSortDir" : "c.code $sSortDir";
        }
        else {
          $orderby .= $prod ? "d.name $sSortDir" : "c.code_text $sSortDir";
        }
      }
      else if ($what == 'fields') {
        if ($source == 'V') {
          // No action needed here.
        }
        else {
          // Remaining sources (D, H, E) come from a layout.
          if ($iSortCol == 0) {
            $orderby .= "lo.field_id $sSortDir";
          }
          else {
            $orderby .= "lo.title $sSortDir";
          }
        }
      }
      else if ($what == 'lists') {
        if ($iSortCol == 0) {
          $orderby .= "li.list_id $sSortDir";
        }
        else {
          $orderby .= "li.option_id $sSortDir";
        }
      }
      else if ($what == 'groups') {
        if ($iSortCol == 0) {
          $orderby .= "code $sSortDir";
        }
        else {
          $orderby .= "description $sSortDir";
        }
      }
		}
	}
}

if ($what == 'codes') {
  $sellist = $prod ?
    "CONCAT(d.drug_id, '|', COALESCE(t.selector, '')) AS code, d.name AS description, '$codetype' AS codetype" :
    "CONCAT(c.code, '|') AS code, c.code_text AS description, '$codetype' AS codetype";
  $where1 = '';
  $where2 = '';
  if ($prod) {
    $from = "drugs AS d LEFT JOIN drug_templates AS t ON t.drug_id = d.drug_id";
    if (!$include_inactive) $where1 = "WHERE d.active = 1";
  }
  else {
    $from = "codes AS c";
    $where1 = "WHERE c.code_type = '$ncodetype'";
    if (!$include_inactive) $where1 .= " AND c.active = 1";
  }
  if (isset($_GET['sSearch']) && $_GET['sSearch'] !== "") {
    $sSearch = add_escape_custom($_GET['sSearch']);
    $where2 = empty($where1) ? "WHERE " : " AND ";
    $where2 .= ($prod ?
      "(d.name LIKE '%$sSearch%' OR t.selector LIKE '%$sSearch%')" :
      "(c.code LIKE '%$sSearch%' OR c.code_text LIKE '%$sSearch%')");
  }
}
else if ($what == 'fields') {
  if ($source == 'V') {
    // No setup needed.
  }
  else if ($source == 'E') {
    $sellist = "lo.field_id, " .
      "MIN(lo.group_id    ) AS group_id, "     .
      "MIN(lo.title       ) AS title, "        .
      "MIN(lo.data_type   ) AS data_type, "    .
      "MIN(lo.uor         ) AS uor, "          .
      "MIN(lo.fld_length  ) AS fld_length, "   .
      "MIN(lo.max_length  ) AS max_length, "   .
      "MIN(lo.list_id     ) AS list_id, "      .
      "MIN(lo.titlecols   ) AS titlecols, "    .
      "MIN(lo.datacols    ) AS datacols, "     .
      "MIN(lo.edit_options) AS edit_options, " .
      "MIN(lo.description ) AS description, "  .
      "MIN(lo.fld_rows    ) AS fld_rows";
    $orderby = "GROUP BY lo.field_id $orderby";
    $from = "layout_options AS lo";
    $where1 = "WHERE lo.form_id LIKE '$layout_id' AND lo.uor > 0 AND lo.source = 'E'";
    if (isset($_GET['sSearch']) && $_GET['sSearch'] !== "") {
      $sSearch = add_escape_custom($_GET['sSearch']);
      $where2 = "AND (lo.field_id LIKE '%$sSearch%' OR lo.title LIKE '%$sSearch%')";
    }
  }
  else if ($source == 'D' || $source == 'H') {
    $sellist = "lo.*";
    $from = "layout_options AS lo";
    $where1 = "WHERE lo.form_id LIKE '$layout_id' AND lo.uor > 0";
    if (isset($_GET['sSearch']) && $_GET['sSearch'] !== "") {
      $sSearch = add_escape_custom($_GET['sSearch']);
      $where2 = "AND (lo.field_id LIKE '%$sSearch%' OR lo.title LIKE '%$sSearch%')";
    }
  }
}
else if ($what == 'lists') {
  $sellist = "li.option_id AS code, li.title AS description";
  $from = "list_options AS li";
  $where1 = "WHERE li.list_id LIKE 'lists' AND li.activity = 1";
  if (isset($_GET['sSearch']) && $_GET['sSearch'] !== "") {
    $sSearch = add_escape_custom($_GET['sSearch']);
    $where2 = "AND (li.list_id LIKE '%$sSearch%' OR li.title LIKE '%$sSearch%')";
  }
}
else if ($what == 'groups') {
  $sellist .= "DISTINCT lp.grp_group_id AS code, lp.grp_title AS description";
  $from = "layout_group_properties AS lp";
  $where1 = "WHERE lp.grp_form_id LIKE '$layout_id' AND lp.grp_group_id != ''";
  if (isset($_GET['sSearch']) && $_GET['sSearch'] !== "") {
    $sSearch = add_escape_custom($_GET['sSearch']);
    $where2 = "AND lp.grp_title LIKE '%$sSearch%'";
  }
}
else {
  error_log(xl('Invalid request to find_code_dynamic_ajax.php'));
  exit();
}

if ($what == 'fields' && $source == 'V') {
  $fe_array = feSearchSort(empty($_GET['sSearch']) ? '' : $_GET['sSearch'], $fe_column, $fe_reverse);
  $iTotal = count($form_encounter_layout);
  $iFilteredTotal = count($fe_array);
}
else {
  // Get total number of rows with no filtering.
  $iTotal = sqlNumRows(sqlStatement("SELECT $sellist FROM $from $where1 $orderby"));
  // Get total number of rows after filtering.
  $iFilteredTotal = sqlNumRows(sqlStatement("SELECT $sellist FROM $from $where1 $where2 $orderby"));
}

// Build the output data array.
//
$out = array(
  "sEcho"                => intval($_GET['sEcho']),
  "iTotalRecords"        => $iTotal,
  "iTotalDisplayRecords" => $iFilteredTotal,
  "aaData"               => array()
);

if ($what == 'fields' && $source == 'V') {
  foreach ($fe_array as $feitem) {
    $arow = array('DT_RowId' => genFieldIdString($feitem));
    $arow[] = $feitem['field_id'];
    $arow[] = $feitem['title'];
    $out['aaData'][] = $arow;
  }
}
else {
  $query = "SELECT $sellist FROM $from $where1 $where2 $orderby $limit";
  $res = sqlStatement($query);
  while ($row = sqlFetchArray($res)) {
    $arow = array('DT_RowId' => genFieldIdString($row));
    if ($what == 'fields') {
      $arow[] = $row['field_id'];
      $arow[] = $row['title'];
    }
    else {
      $arow[] = str_replace('|', ':', rtrim($row['code'], '|'));
      $arow[] = $row['description'];
    }
    $out['aaData'][] = $arow;
  }
}

// error_log($query); // debugging

// Dump the output array as JSON.
//
echo json_encode($out);
