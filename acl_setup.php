<?php
 // Copyright (C) 2005-2015 Rod Roark <rod@sunsetsystems.com>
 //
 // This program is free software; you can redistribute it and/or
 // modify it under the terms of the GNU General Public License
 // as published by the Free Software Foundation; either version 2
 // of the License, or (at your option) any later version.
 //
 // This program is run by the OpenEMR setup.php script to install phpGACL
 // and creates the Access Control Objects and their sections.
 // See openemr/library/acl.inc file for the list of
 // currently supported Access Control Objects(ACO), which this
 // script will install.  This script also creates several
 // ARO groups, an "admin" ARO, and some reasonable ACL entries for
 // the groups.
 //   ARO groups include:
 //      Administrators
 //      Physicians     (Doctors)
 //      Clinicians     (Nurses, Physician Assistants, etc.)
 //      Front Office   (Receptionist)
 //      Accounting
 //
 // Upgrade Howto
 // When upgrading to a new version of OpenEMR, run the acl_upgrade.php
 // script to update the phpGACL access controls.  This is required to
 // ensure the database includes all the required Access Control 
 // Objects(ACO).
 //
 
 // On 06/2009, added pertinent comments below each entry to allow capture
 //  of these terms by the translation engine.

 require_once(dirname(__FILE__).'/library/acl.inc');

 if (! $phpgacl_location) die("You must first set up library/acl.inc to use phpGACL!");

 require_once("$phpgacl_location/gacl_api.class.php");

 $gacl = new gacl_api();

 // Create the ACO sections.  Every ACO must have a section.
 //
 if ($gacl->add_object_section('Accounting', 'acct', 10, 0, 'ACO') === FALSE) {
  echo "Unable to create the access controls for OpenEMR.  You have likely already run this script (acl_setup.php) successfully.<br>Other possible problems include php-GACL configuration file errors (gacl.ini.php or gacl.class.php).<br>";
  return;
 }
     // xl('Accounting')
 $gacl->add_object_section('Administration', 'admin'        , 10, 0, 'ACO');
     // xl('Administration')
 $gacl->add_object_section('Encounters'    , 'encounters'   , 10, 0, 'ACO');
     // xl('Encounters')
 $gacl->add_object_section('Lists'         , 'lists'        , 10, 0, 'ACO');
     // xl('Lists')
 $gacl->add_object_section('Patients'      , 'patients'     , 10, 0, 'ACO');
     // xl('Patients')
 $gacl->add_object_section('Squads'        , 'squads'       , 10, 0, 'ACO');
     // xl('Squads')
 $gacl->add_object_section('Sensitivities' , 'sensitivities', 10, 0, 'ACO');
     // xl('Sensitivities')
 $gacl->add_object_section('Placeholder'   , 'placeholder'  , 10, 0, 'ACO');
     // xl('Placeholder')
 $gacl->add_object_section('Nation Notes'  , 'nationnotes'  , 10, 0, 'ACO');
     // xl('Nation Notes')
 $gacl->add_object_section('Patient Portal','patientportal' , 10, 0, 'ACO');
     // xl('Patient Portal')
 $gacl->add_object_section('Inventory'     ,'inventory'     , 10, 0, 'ACO');
     // xl('Inventory')
 // Create Accounting ACOs.
 //
 $gacl->add_object('acct', 'Billing (write optional)'           , 'bill' , 10, 0, 'ACO');
     // xl('Billing (write optional)')
 $gacl->add_object('acct', 'Price Discounting'                  , 'disc' , 10, 0, 'ACO');
     // xl('Price Discounting')
 $gacl->add_object('acct', 'EOB Data Entry'                     , 'eob'  , 10, 0, 'ACO');
     // xl('EOB Data Entry')
 $gacl->add_object('acct', 'Financial Reporting - my encounters', 'rep'  , 10, 0, 'ACO');
     // xl('Financial Reporting - my encounters')
 $gacl->add_object('acct', 'Financial Reporting - anything'     , 'rep_a', 10, 0, 'ACO');
     // xl('Financial Reporting - anything')

 // Create Administration ACOs.
 //
 $gacl->add_object('admin', 'Superuser'                       , 'super'    , 10, 0, 'ACO');
     // xl('Superuser')
 $gacl->add_object('admin', 'Calendar Settings'               , 'calendar' , 10, 0, 'ACO');
     // xl('Calendar Settings')
 $gacl->add_object('admin', 'Database Reporting'              , 'database' , 10, 0, 'ACO');
     // xl('Database Reporting')
 $gacl->add_object('admin', 'Forms Administration'            , 'forms'    , 10, 0, 'ACO');
     // xl('Forms Administration')
 $gacl->add_object('admin', 'Practice Settings'               , 'practice' , 10, 0, 'ACO');
     // xl('Practice Settings')
 $gacl->add_object('admin', 'Superbill Codes Administration'  , 'superbill', 10, 0, 'ACO');
     // xl('Superbill Codes Administration')
 $gacl->add_object('admin', 'Users/Groups/Logs Administration', 'users'    , 10, 0, 'ACO');
     // xl('Users/Groups/Logs Administration')
 $gacl->add_object('admin', 'Batch Communication Tool'        , 'batchcom' , 10, 0, 'ACO');
     // xl('Batch Communication Tool')
 $gacl->add_object('admin', 'Language Interface Tool'         , 'language' , 10, 0, 'ACO');
     // xl('Language Interface Tool')
 $gacl->add_object('admin', 'Inventory Administration'        , 'drugs'    , 10, 0, 'ACO');
     // xl('Inventory Administration')
 $gacl->add_object('admin', 'ACL Administration'              , 'acl'      , 10, 0, 'ACO');
     // xl('ACL Administration')

 // Create ACOs for encounters.
 //
 $gacl->add_object('encounters', 'Authorize - my encounters'                        , 'auth'    , 10, 0, 'ACO');
     // xl('Authorize - my encounters')
 $gacl->add_object('encounters', 'Authorize - any encounters'                       , 'auth_a'  , 10, 0, 'ACO');
     // xl('Authorize - any encounters')
 $gacl->add_object('encounters', 'Coding - my encounters (write,wsome optional)'    , 'coding'  , 10, 0, 'ACO');
     // xl('Coding - my encounters (write,wsome optional)')
 $gacl->add_object('encounters', 'Coding - any encounters (write,wsome optional)'   , 'coding_a', 10, 0, 'ACO');
     // xl('Coding - any encounters (write,wsome optional)')
 $gacl->add_object('encounters', 'Notes - my encounters (write,addonly optional)'   , 'notes'   , 10, 0, 'ACO');
     // xl('Notes - my encounters (write,addonly optional)')
 $gacl->add_object('encounters', 'Notes - any encounters (write,addonly optional)'  , 'notes_a' , 10, 0, 'ACO');
     // xl('Notes - any encounters (write,addonly optional)')
 $gacl->add_object('encounters', 'Fix encounter dates - any encounters'             , 'date_a'  , 10, 0, 'ACO');
     // xl('Fix encounter dates - any encounters')
 $gacl->add_object('encounters', 'Less-private information (write,addonly optional)', 'relaxed' , 10, 0, 'ACO');
     // xl('Less-private information (write,addonly optional)')

 // Create ACOs for lists.
 //
 $gacl->add_object('lists', 'Default List (write,addonly optional)'        , 'default'  , 10, 0, 'ACO');
     // xl('Default List (write,addonly optional)')
 $gacl->add_object('lists', 'State List (write,addonly optional)'          , 'state'    , 10, 0, 'ACO');
     // xl('State List (write,addonly optional)')
 $gacl->add_object('lists', 'Country List (write,addonly optional)'        , 'country'  , 10, 0, 'ACO');
     // xl('Country List (write,addonly optional)')
 $gacl->add_object('lists', 'Language List (write,addonly optional)'       , 'language' , 10, 0, 'ACO');
     // xl('Language List (write,addonly optional)')
 $gacl->add_object('lists', 'Ethnicity-Race List (write,addonly optional)' , 'ethrace'  , 10, 0, 'ACO');
     // xl('Ethnicity-Race List (write,addonly optional)')
 
 // Create ACOs for patientportal.
 //
 $gacl->add_object('patientportal', 'Patient Portal' , 'portal'  , 10, 0, 'ACO');
     // xl('Patient Portal')
     
 // Create ACOs for patients.
 //
 $gacl->add_object('patients', 'Appointments (write,wsome optional)'      , 'appt' , 10, 0, 'ACO');
     // xl('Appointments (write,wsome optional)')
 $gacl->add_object('patients', 'Demographics (write,addonly optional)'    , 'demo' , 10, 0, 'ACO');
     // xl('Demographics (write,addonly optional)')
 $gacl->add_object('patients', 'Medical/History (write,addonly optional)' , 'med'  , 10, 0, 'ACO');
     // xl('Medical/History (write,addonly optional)')
 $gacl->add_object('patients', 'Transactions (write optional)'            , 'trans', 10, 0, 'ACO');
     // xl('Transactions (write optional)')
 $gacl->add_object('patients', 'Documents (write,addonly optional)'       , 'docs' , 10, 0, 'ACO');
     // xl('Documents (write,addonly optional)')
 $gacl->add_object('patients', 'Patient Notes (write,addonly optional)'   , 'notes', 10, 0, 'ACO');
     // xl('Patient Notes (write,addonly optional)')
 $gacl->add_object('patients', 'Sign Lab Results (write,addonly optional)', 'sign'  , 10, 0, 'ACO');
     // xl('Sign Lab Results (write,addonly optional)')

 // Create ACOs for sensitivities.
 //
 $gacl->add_object('sensitivities', 'Normal', 'normal', 10, 0, 'ACO');
     // xl('Normal')
 $gacl->add_object('sensitivities', 'High'  , 'high'  , 20, 0, 'ACO');
     // xl('High')

 // Create ACO for placeholder.
 //
 $gacl->add_object('placeholder', 'Placeholder (Maintains empty ACLs)', 'filler', 10, 0, 'ACO');
     // xl('Placeholder (Maintains empty ACLs)')
     
 // Create ACO for nationnotes.
 //
 $gacl->add_object('nationnotes', 'Nation Notes Configure', 'nn_configure', 10, 0, 'ACO');
     // xl('Nation Notes Configure')

 // Create ACOs for Inventory.
 //
 $gacl->add_object('inventory', 'Lots'       , 'lots'       , 10, 0, 'ACO');
     // xl('Lots')
 $gacl->add_object('inventory', 'Sales'      , 'sales'      , 20, 0, 'ACO');
     // xl('Sales')
 $gacl->add_object('inventory', 'Purchases'  , 'purchases'  , 30, 0, 'ACO');
     // xl('Purchases')
 $gacl->add_object('inventory', 'Transfers'  , 'transfers'  , 40, 0, 'ACO');
     // xl('Transfers')
 $gacl->add_object('inventory', 'Adjustments', 'adjustments', 50, 0, 'ACO');
     // xl('Adjustments')
 $gacl->add_object('inventory', 'Consumption', 'consumption', 60, 0, 'ACO');
     // xl('Consumption')
 $gacl->add_object('inventory', 'Destruction', 'destruction', 70, 0, 'ACO');
     // xl('Destruction')
 $gacl->add_object('inventory', 'Reporting'  , 'reporting'  , 80, 0, 'ACO');
     // xl('Reporting')

 // Create ARO groups.
 //
 $users = $gacl->add_group('users', 'OpenEMR Users' , 0     , 'ARO');
     // xl('OpenEMR Users')
 $admin = $gacl->add_group('admin', 'Administrators', $users, 'ARO');
     // xl('Administrators')
 $clin  = $gacl->add_group('clin' , 'Clinicians'    , $users, 'ARO');
     // xl('Clinicians')
 $doc   = $gacl->add_group('doc'  , 'Physicians'    , $users, 'ARO');
     // xl('Physicians')
 $front = $gacl->add_group('front', 'Front Office'  , $users, 'ARO');
     // xl('Front Office')
 $back  = $gacl->add_group('back' , 'Accounting'    , $users, 'ARO');
     // xl('Accounting')
$breakglass  = $gacl->add_group('breakglass' , 'Emergency Login'    , $users, 'ARO');
     // xl('Emergency Login')

 $invclinic      = $gacl->add_group('invclinic'     , 'Inv Clinic'      , $users, 'ARO'); // xl('Inv Clinic')
 $invclinicadmin = $gacl->add_group('invclinicadmin', 'Inv Clinic Admin', $users, 'ARO'); // xl('Inv Clinic Admin')
 $inventoryadmin = $gacl->add_group('inventoryadmin', 'Inventory Admin' , $users, 'ARO'); // xl('Inventory Admin')

 // Create a Users section for the AROs (humans).
 //
 $gacl->add_object_section('Users', 'users', 10, 0, 'ARO');
     // xl('Users')

 // Create the Administrator in the above-created "users" section
 // and add him/her to the above-created "admin" group.
 // If this script is being used by OpenEMR's setup, then will
 //   incorporate the installation values. Otherwise will
//    hardcode the 'admin' user.
 if ( isset($this->iuser) ) {
  $gacl->add_object('users', $this->iuname, $this->iuser, 10, 0, 'ARO');
  $gacl->add_group_object($admin, 'users', $this->iuser, 'ARO');
 }
 else {
  $gacl->add_object('users', 'Administrator', 'admin' ,10, 0, 'ARO');
  $gacl->add_group_object($admin, 'users', 'admin', 'ARO');
 }

 // Declare return terms for language translations
 //  xl('write') xl('wsome') xl('addonly') xl('view')

 // Set permissions for administrators.
 //
 $gacl->add_acl(
  array(
   'acct'=>array('bill', 'disc', 'eob', 'rep', 'rep_a'),
   'admin'=>array('calendar', 'database', 'forms', 'practice', 'superbill', 'users', 'batchcom', 'language', 'super', 'drugs', 'acl'),
   'encounters'=>array('auth_a', 'coding_a', 'notes_a', 'date_a'),
   'lists'=>array('default','state','country','language','ethrace'),
   'patients'=>array('appt', 'demo', 'med', 'trans', 'docs', 'notes'),
   'sensitivities'=>array('normal', 'high'),
   'nationnotes'=>array('nn_configure'),
   'patientportal'=>array('portal')
  ),
  NULL, array($admin), NULL, NULL,
  1, 1, 'write', 'Administrators can do anything'
 );
     // xl('Administrators can do anything')

 // Set permissions for physicians.
 //
 $gacl->add_acl(
  array(
   'placeholder'=>array('filler')
  ),
  NULL, array($doc), NULL, NULL,
  1, 1, 'view', 'Things that physicians can only read'
 );
     // xl('Things that physicians can only read')
 $gacl->add_acl(
  array(
   'placeholder'=>array('filler')
  ),
  NULL, array($doc), NULL, NULL,
  1, 1, 'addonly', 'Things that physicians can read and enter but not modify'
 );
     // xl('Things that physicians can read and enter but not modify')
 $gacl->add_acl(
  array(
   'placeholder'=>array('filler')
  ),
  NULL, array($doc), NULL, NULL,
  1, 1, 'wsome', 'Things that physicians can read and partly modify'
 );
     // xl('Things that physicians can read and partly modify')
 $gacl->add_acl(
  array(
   'acct'=>array('disc', 'rep'),
   'admin'=>array('drugs'),
   'encounters'=>array('auth_a', 'coding_a', 'notes_a', 'date_a'),
   'patients'=>array('appt', 'demo', 'med', 'trans', 'docs', 'notes', 'sign'),
   'sensitivities'=>array('normal', 'high')
  ),
  NULL, array($doc), NULL, NULL,
  1, 1, 'write', 'Things that physicians can read and modify'
 );
     // xl('Things that physicians can read and modify')

 // Set permissions for clinicians.
 //
 $gacl->add_acl(
  array(
   'placeholder'=>array('filler')
  ),
  NULL, array($clin), NULL, NULL,
  1, 1, 'view', 'Things that clinicians can only read'
 );
     // xl('Things that clinicians can only read')
 $gacl->add_acl(
  array(
   'encounters'=>array('notes', 'relaxed'),
   'patients'=>array('demo', 'med', 'docs', 'notes'),
   'sensitivities'=>array('normal')
  ),
  NULL, array($clin), NULL, NULL,
  1, 1, 'addonly', 'Things that clinicians can read and enter but not modify'
 );
     // xl('Things that clinicians can read and enter but not modify')

 $gacl->add_acl(
  array(
   'placeholder'=>array('filler')
  ),
  NULL, array($clin), NULL, NULL,
  1, 1, 'wsome', 'Things that clinicians can read and partly modify'
 );
     // xl('Things that clinicians can read and partly modify')
 $gacl->add_acl(
  array(
   'admin'=>array('drugs'),
   'encounters'=>array('coding'),
   'patients'=>array('appt')
  ),
  NULL, array($clin), NULL, NULL,
  1, 1, 'write', 'Things that clinicians can read and modify'
 );
     // xl('Things that clinicians can read and modify')

 // Set permissions for front office staff.
 //
 $gacl->add_acl(
  array(
   'placeholder'=>array('filler')
  ),
  NULL, array($front), NULL, NULL,
  1, 1, 'view', 'Things that front office can only read'
 );
     // xl('Things that front office can only read')
 $gacl->add_acl(
  array(
   'placeholder'=>array('filler')
  ),
  NULL, array($front), NULL, NULL,
  1, 1, 'addonly', 'Things that front office can read and enter but not modify'
 );
     // xl('Things that front office can read and enter but not modify')
 $gacl->add_acl(
  array(
   'placeholder'=>array('filler')
  ),
  NULL, array($front), NULL, NULL,
  1, 1, 'wsome', 'Things that front office can read and partly modify'
 );
     // xl('Things that front office can read and partly modify')
 $gacl->add_acl(
  array(
   'patients'=>array('appt', 'demo', 'trans', 'notes')
  ),
  NULL, array($front), NULL, NULL,
  1, 1, 'write', 'Things that front office can read and modify'
 );
     // xl('Things that front office can read and modify')

 // Set permissions for back office staff.
 //
 $gacl->add_acl(
  array(
   'placeholder'=>array('filler')
  ),
  NULL, array($back), NULL, NULL,
  1, 1, 'view', 'Things that back office can only read'
 );
     // xl('Things that back office can only read')
 $gacl->add_acl(
  array(
   'placeholder'=>array('filler')
  ),
  NULL, array($back), NULL, NULL,
  1, 1, 'addonly', 'Things that back office can read and enter but not modify'
 );
     // xl('Things that back office can read and enter but not modify')
 $gacl->add_acl(
  array(
   'placeholder'=>array('filler')
  ),
  NULL, array($back), NULL, NULL,
  1, 1, 'wsome', 'Things that back office can read and partly modify'
 );
     // xl('Things that back office can read and partly modify')
 $gacl->add_acl(
  array(
   'acct'=>array('bill', 'disc', 'eob', 'rep', 'rep_a'),
   'admin'=>array('practice', 'superbill', 'drugs'),
   'encounters'=>array('auth_a', 'coding_a', 'date_a'),
   'patients'=>array('appt', 'demo')
  ),
  NULL, array($back), NULL, NULL,
  1, 1, 'write', 'Things that back office can read and modify'
 );
     // xl('Things that back office can read and modify')

 // Set permissions for Emergency Login.
 //
 $gacl->add_acl(
  array(
   'acct'=>array('bill', 'disc', 'eob', 'rep', 'rep_a'),
   'admin'=>array('calendar', 'database', 'forms', 'practice', 'superbill', 'users', 'batchcom', 'language', 'super', 'drugs', 'acl'),
   'encounters'=>array('auth_a', 'coding_a', 'notes_a', 'date_a'),
   'lists'=>array('default','state','country','language','ethrace'),
   'patients'=>array('appt', 'demo', 'med', 'trans', 'docs', 'notes'),
   'sensitivities'=>array('normal', 'high'),
   'nationnotes'=>array('nn_configure'),
   'patientportal'=>array('portal')
  ),
  NULL, array($breakglass), NULL, NULL,
  1, 1, 'write', 'Emergency Login user can do anything'
 );
     // xl('Emergency Login user can do anything')

 // Set permissions for Inv Clinic.
 //
 $gacl->add_acl(array(
   'inventory' => array('reporting'),
  ),
  NULL, array($invclinic), NULL, NULL, 1, 1, 'write',
          'Things that Inv Clinic can read and modify'
 ); // xl('Things that Inv Clinic can read and modify')

 // Set permissions for Inv Clinic Admin.
 //
 $gacl->add_acl(array(
   'inventory' => array('consumption', 'purchases', 'reporting', 'sales', 'transfers'),
  ),
  NULL, array($invclinicadmin), NULL, NULL, 1, 1, 'write',
          'Things that Inv Clinic Admin can read and modify'
 ); // xl('Things that Inv Clinic Admin can read and modify')

 // Set permissions for Inventory Admin.
 //
 $gacl->add_acl(array(
   'admin'=>array('drugs'),
  ),
  NULL, array($inventoryadmin), NULL, NULL, 1, 1, 'write',
          'Things that Inventory Admin can read and modify'
 ); // xl('Things that Inventory Admin can read and modify')

?>
<html>
<head>
<title>OpenEMR ACL Setup</title>
<link rel=STYLESHEET href="interface/themes/style_blue.css">
</head>
<body>
<b>OpenEMR ACL Setup</b>
<br>
All done configuring and installing access controls (php-GACL)!
</body>
</html>
