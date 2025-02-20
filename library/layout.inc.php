<?php
/**
* Sql functions/classes for OpenEMR.
*
* Things related to layout based forms in general.
* 
* Copyright (C) 2017 Rod Roark <rod@sunsetsystems.com> 
*
* LICENSE: This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://opensource.org/licenses/gpl-license.php>.
* 
* @package   OpenEMR
* @link      http://www.open-emr.org
*/

// array of the data_types of the fields
$datatypes = array(
    "1"  => xl("List box"), 
    "2"  => xl("Textbox"),
    "3"  => xl("Textarea"),
    "4"  => xl("Text-date"),
    "10" => xl("Providers"),
    "11" => xl("Providers NPI"),
    "12" => xl("Pharmacies"),
    "13" => xl("Squads"),
    "14" => xl("Organizations"),
    "15" => xl("Billing codes"),
    "18" => xl("Visit Categories"),
    "21" => xl("Checkbox(es)"),
    "22" => xl("Textbox list"),
    "23" => xl("Exam results"),
    "24" => xl("Patient allergies"),
    "25" => xl("Checkboxes w/text"),
    "26" => xl("List box w/add"),
    "27" => xl("Radio buttons"),
    "28" => xl("Lifestyle status"),
    "31" => xl("Static Text"),
    "32" => xl("Smoking Status"),
    "33" => xl("Race/Ethnicity"),
    "34" => xl("NationNotes"),
    "35" => xl("Facilities"),
    "40" => xl("Image canvas"),
);

$sources = array(
    'F' => xl('Form'),
    'D' => xl('Patient'),
    'H' => xl('History'),
    'E' => xl('Visit'),
    'V' => xl('VisForm'),
);

$UOR = array(
    0 => xl('Unused'),
    1 => xl('Optional'),
    2 => xl('Required'),
);
