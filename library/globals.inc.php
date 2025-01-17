<?php
// Copyright (C) 2010-2018 Rod Roark <rod@sunsetsystems.com>
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.

// $GLOBALS['print_command'] is the
// Print command for spooling to printers, used by statements.inc.php
// This is the command to be used for printing (without the filename).
// The word following "-P" should be the name of your printer.  This
// example is designed for 8.5x11-inch paper with 1-inch margins,
// 10 CPI, 6 LPI, 65 columns, 54 lines per page.
//
// IF lpr services are installed on Windows this setting will be similar
// Otherwise configure it as needed (print /d:PRN) might be an option for Windows parallel printers

//  Current supported languages:    // Allow capture of term for translation:
//   Albanian                       // xl('Albanian')
//   Amharic                        // xl('Amharic')
//   Arabic                         // xl('Arabic')
//   Armenian                       // xl('Armenian')
//   Bahasa Indonesia               // xl('Bahasa Indonesia')
//   Bengali                        // xl('Bengali')
//   Chinese (Simplified)           // xl('Chinese (Simplified)')
//   Chinese (Traditional)          // xl('Chinese (Traditional)')
//   Czech                          // xl('Czech')
//   Danish                         // xl('Danish')
//   Dutch                          // xl('Dutch')
//   English (Indian)               // xl('English (Indian)')
//   English (Standard)             // xl('English (Standard)')
//   Estonian                       // xl('Estonian')
//   French                         // xl('French (Standard)')
//   French                         // xl('French (Canadian)')
//   German                         // xl('German')
//   Greek                          // xl('Greek')
//   Hebrew                         // xl('Hebrew')
//   Hindi                          // xl('Hindi')
//   Hungarian                      // xl('Hungarian')
//   Italian                        // xl('Italian')
//   Lithuanian                     // xl('Lithuanian')
//   Norwegian                      // xl('Norwegian')
//   Persian                        // xl('Persian')
//   Polish                         // xl('Polish')
//   Portuguese (Brazilian)         // xl('Portuguese (Brazilian)')
//   Portuguese (European)          // xl('Portuguese (European)')
//   Romanian                       // xl('Romanian')
//   Russian                        // xl('Russian')
//   Sinhala                        // xl('Sinhala')
//   Slovak                         // xl('Slovak')
//   Spanish (Latin American)       // xl('Spanish (Latin American)')
//   Spanish (Spain)                // xl('Spanish (Spain)')
//   Swedish                        // xl('Swedish')
//   Turkish                        // xl('Turkish')
//   Ukrainian                      // xl('Ukrainian')
//   Vietnamese                     // xl('Vietnamese')

// OS-dependent stuff.
if (stristr(PHP_OS, 'WIN')) {
  // MS Windows
  $mysql_bin_dir       = 'C:/xampp/mysql/bin';
  $perl_bin_dir        = 'C:/xampp/perl/bin';
  $temporary_files_dir = 'C:/windows/temp';
  $backup_log_dir      = 'C:/windows/temp';
}
else {
  // Everything else
  $mysql_bin_dir       = '/usr/bin';
  $perl_bin_dir        = '/usr/bin';
  $temporary_files_dir = '/tmp';
  $backup_log_dir      = '/tmp';
}

// Language constant declarations:
// xl('Appearance')
// xl('Locale')
// xl('Features')
// xl('Calendar')
// xl('Security')
// xl('Notifications')
// xl('Miscellaneous')

// List of user specific tabs and globals
$USER_SPECIFIC_TABS = array('Appearance',
                            'Locale',
                            'Calendar',
                            'Connectors');
$USER_SPECIFIC_GLOBALS = array('default_top_pane',
                               'concurrent_layout',
                               'css_header',
                               'gbl_pt_list_page_size',
                               'gbl_pt_list_new_window',
                               'drop_bottom',
                               'units_of_measurement',
                               'us_weight_format',
                               'date_display_format',
                               'time_display_format',
                               'event_color',
                               'pat_trkr_timer',
                               'ptkr_visit_reason',
                               'checkout_roll_off',
                               'erx_import_status_message');

function gblTimeZones() {
  $zones = timezone_identifiers_list();
  $arr = array('' => xl('Unassigned'));
  foreach ($zones as $zone) {
    $arr[$zone] = str_replace('_', ' ', $zone);
  }
  return $arr;
}

$GLOBALS_METADATA = array(

  // Appearance Tab
  //
  'Appearance' => array(

    'default_top_pane' => array(
      xl('Main Top Pane Screen'),       // descriptive name
      array(
        'main_info.php' => xl('Calendar Screen'),
        '../new/new.php' => xl('Patient Search/Add Screen'),
        '../../interface/patient_tracker/patient_tracker.php?skip_timeout_reset=1' => xl('Patient Flow Board'),		
      ),
      'main_info.php',                  // default = calendar
      xl('Type of screen layout')
    ),

    'concurrent_layout' => array(
      xl('Layout Style'),               // descriptive name
      array(
        '0' => xl('Old style layout with no left menu'),
        '1' => xl('Navigation menu consists of pairs of radio buttons'),
        '2' => xl('Navigation menu is a tree view'),
        '3' => xl('Navigation uses a sliding menu'),
      ),
      '3',                              // default = tree menu
      xl('Type of screen layout')
    ),

    'css_header' => array(
      xl('Theme'),
      'css',
      'style_oemr.css',
      xl('Pick a CSS theme.')
    ),

    'gbl_nav_area_width' => array(
      xl('Navigation Area Width'),
      'num',
      '150',
      xl('Width in pixels of the left navigation frame.')
    ),

    'openemr_name' => array(
      xl('Application Title'),
      'text',
      'OpenEMR',
      xl('Application name for login page and main window title.')
    ),

    'full_new_patient_form' => array(
      xl('New Patient Form'),
      array(
        '0' => xl('Old-style static form without search or duplication check'),
        '1' => xl('All demographics fields, with search and duplication check'),
        '2' => xl('Mandatory or specified fields only, search and dup check'),
        '3' => xl('Mandatory or specified fields only, dup check, no search'),
      ),
      '1',                              // default
      xl('Style of form used for adding new patients')
    ),

    'patient_search_results_style' => array(
      xl('Patient Search Results Style'),
      array(
        '0' => xl('Encounter statistics'),
        '1' => xl('Mandatory and specified fields'),
      ),
      '0',                              // default
      xl('Type of columns displayed for patient search results')
    ),

    'gbl_tall_nav_area' => array(
      xl('Tall Navigation Area'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Navigation area uses full height of frameset')
    ),

    'gbl_nav_visit_forms' => array(
      xl('Navigation Area Visit Forms'),
      'bool',                           // data type
      '1',                              // default = true
      xl('Navigation area includes encounter forms')
    ),

    'simplified_demographics' => array(
      xl('Simplified Demographics'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Omit insurance and some other things from the demographics form')
    ),

    'simplified_prescriptions' => array(
      xl('Simplified Prescriptions'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Omit form, route and interval which then become part of dosage')
    ),

    'simplified_copay' => array(
      xl('Simplified Co-Pay'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Omit method of payment from the co-pay panel')
    ),

    'use_charges_panel' => array(
      xl('Use Charges Panel'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Enables the old Charges panel for entering billing codes and payments. Not recommended, use the Fee Sheet instead.')
    ),

    // TajEmo Work BY CB 2012/06/21 10:42:31 AM added option to Hide Fees
    'enable_fees_in_left_menu' => array(
      xl('Enable Fees In Left Menu'),
      'bool',                           // data type
      '1',                              // default = true
      xl('Enable Fees In Left Menu')
    ),
    // EDI history  2012-09-13 
    'enable_edihistory_in_left_menu' => array(
      xl('Enable EDI History In Left Menu'),
      'bool',                           // data type
      '1',                              // default = true
      xl('EDI History (under Fees) for storing and interpreting EDI claim response files')
    ),
    //
    'online_support_link' => array(
      xl('Online Support Link'),
      'text',                           // data type
      'http://open-emr.org/',
      xl('URL for OpenEMR support.')
    ),

   'drop_bottom' => array(
      xl('Remove Bottom Pane'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Removes the bottom pane by default on start up.')
    ),
	
    'encounter_page_size' => array(
      xl('Encounter Page Size'),
      array(
        '0' => xl('Show All'),
        '5' => '5',
        '10' => '10',
        '15' => '15',
        '20' => '20',
        '25' => '25',
        '50' => '50',
      ),
      '20',
      xl('Number of encounters to display per page.')
    ),

    'gbl_pt_list_page_size' => array(
      xl('Patient List Page Size'),
      array(
        '10'  =>  '10',
        '25'  =>  '25',
        '50'  =>  '50',
        '100' => '100',
      ),
      '10',
      xl('Number of patients to display per page in the patient list.')
    ),

    'gbl_pt_list_new_window' => array(
      xl('Patient List New Window'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Default state of New Window checkbox in the patient list.')
    ),

    'gbl_vitals_options' => array(
      xl('Vitals Form Options'),
      array(
        '0' => xl('Standard'),
        '1' => xl('Omit circumferences'),
      ),
      '0',                              // default
      xl('Special treatment for the Vitals form')
    ),

  ),

  // Locale Tab
  //
  'Locale' => array(

    'language_default' => array(
      xl('Default Language'),
      'lang',                           // data type
      'English (Standard)',             // default = english
      xl('Default language if no other is allowed or chosen.')
    ),

    'language_menu_showall' => array(
      xl('All Languages Allowed'),
      'bool',                           // data type
      '1',                              // default = true
      xl('Allow all available languages as choices on menu at login.')			     				     
    ),
			
    'language_menu_other' => array(
      xl('Allowed Languages'),
      'm_lang',                         // data type
      '',                               // default = none
      xl('Select which languages, if any, may be chosen at login. (only pertinent if above All Languages Allowed is turned off)')
    ),

    'allow_debug_language' => array(
      xl('Allow Debugging Language'),
      'bool',                           // data type
      '1',                              // default = true during development and false for production releases
      xl('This will allow selection of the debugging (\'dummy\') language.')
    ),

    'translate_layout' => array(
      xl('Translate Layouts'),
      'bool',                           // data type
      '1',                              // default = true
      xl('Is text from form layouts to be translated?')
    ),

    'translate_lists' => array(
      xl('Translate Lists'),
      'bool',                           // data type
      '1',                              // default = true
      xl('Is text from lists to be translated?')
    ),

    'translate_gacl_groups' => array(
      xl('Translate Access Control Groups'),
      'bool',                           // data type
      '1',                              // default = true
      xl('Are access control group names to be translated?')
    ),

    'translate_form_titles' => array(
      xl('Translate Patient Note Titles'),
      'bool',                           // data type
      '1',                              // default = true
      xl('Are patient note titles to be translated?')
    ),

    'translate_document_categories' => array(
      xl('Translate Document Categories'),
      'bool',                           // data type
      '1',                              // default = true
      xl('Are document category names to be translated?')
    ),

    'translate_appt_categories' => array(
      xl('Translate Appointment Categories'),
      'bool',                           // data type
      '1',                              // default = true
      xl('Are appointment category names to be translated?')
    ),

    'units_of_measurement' => array(
      xl('Units for Visit Forms'),
      array(
        '1' => xl('Show both US and metric (main unit is US)'),
        '2' => xl('Show both US and metric (main unit is metric)'),
        '3' => xl('Show US only'),
        '4' => xl('Show metric only'),
      ),
      '1',                              // default = Both/US
      xl('Applies to the Vitals form and Growth Chart')
    ),
    
    'us_weight_format' => array(
        xl('Display Format for US Weights'),
        array(
            '1'=>xl('Show pounds as decimal value'),
            '2'=>xl('Show pounds and ounces')
        ),
        '1',
        xl('Applies to Vitals form')
    )
      ,
    'disable_deprecated_metrics_form' => array(
      xl('Disable Old Metric Vitals Form'),
      'bool',                           // data type
      '1',                              // default = true
      xl('This was the older metric-only Vitals form, now deprecated.')
    ),

    'phone_country_code' => array(
      xl('Telephone Country Code'),
      'num',
      '1',                              // default = North America
      xl('1 = North America. See http://www.wtng.info/ for a list of other country codes.')
    ),

    'date_display_format' => array(
      xl('Date Display Format'),
      array(
        '0' => xl('YYYY-MM-DD'),
        '1' => xl('MM/DD/YYYY'),
        '2' => xl('DD/MM/YYYY'),
      ),
      '0',
      xl('Format used to display most dates.')
    ),
    
    'time_display_format' => array(
      xl('Time Display Format'),
      array(
        '0' => xl('24 hr'),
        '1' => xl('12 hr'),
      ),
      '0',
      xl('Format used to display most times.')
    ),
    
    'gbl_time_zone' => array(
      xl('Time Zone'),
      gblTimeZones(),
      '',
      xl('If unassigned will default to php.ini setting for date.timezone.')
    ),

    'currency_decimals' => array(
      xl('Currency Decimal Places'),
      array(
        '0' => xl('0'),
        '1' => xl('1'),
        '2' => xl('2'),
      ),
      '2',
      xl('Number of digits after decimal point for currency, usually 0 or 2.')
    ),

    'currency_dec_point' => array(
      xl('Currency Decimal Point Symbol'),
      array(
        '.' => xl('Period'),
        ',' => xl('Comma'),
      ),
      '.',
      xl('Symbol used as the decimal point for currency. Not used if Decimal Places is 0.')
    ),

    'currency_thousands_sep' => array(
      xl('Currency Thousands Separator'),
      array(
        ',' => xl('Comma'),
        '.' => xl('Period'),
        ' ' => xl('Space'),
        ''  => xl('None'),
      ),
      ',',
      xl('Symbol used to separate thousands for currency.')
    ),

    'gbl_currency_symbol' => array(
      xl('Currency Designator'),
      'text',                           // data type
      '$',                              // default
      xl('Code or symbol to indicate currency')
    ),
    'age_display_format'=>array(xl('Age Display Format'),
        array(
            '0'=>xl('Years or months'),
            '1'=>xl('Years, months and days')
            ),
            '0',
            xl('Format for age display')
    ),
    'age_display_limit' => array(
      xl('Age in Years for Display Format Change'),
      'num',
      '3',
      xl('If YMD is selected for age display, switch to just Years when patients older than this value in years')
    ),      
  ),

  // Features Tab
  //
  'Features' => array(

    'specific_application' => array(
      xl('Specific Application'),
      array(
        '0' => xl('None'),
        '1' => xl('Athletic team'),
        '2' => xl('IPPF'),
        '3' => xl('Weight loss clinic'),
      ),
      '0',                              // default
      xl('Indicator for specialized usage')
    ),

    'inhouse_pharmacy' => array(
      xl('Drugs and Products'),
      array(
        '0' => xl('Do not inventory and sell any products'),
        '1' => xl('Inventory and sell drugs only'),
        '2' => xl('Inventory and sell both drugs and non-drug products'),
        '3' => xl('Products but no prescription drugs and no templates'),
      ),
      '0',                              // default
      xl('Option to support inventory and sales of products')
    ),

    'disable_chart_tracker' => array(
      xl('Disable Chart Tracker'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Removes the Chart Tracker feature')
    ),

    'disable_phpmyadmin_link' => array(
     xl('Disable phpMyAdmin'),
     'bool',                            // data type
     '0',                               // default = false
     xl('Removes support for phpMyAdmin')
    ),

    'disable_immunizations' => array(
      xl('Disable Immunizations'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Removes support for immunizations')
    ),

    'disable_prescriptions' => array(
      xl('Disable Prescriptions'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Removes support for prescriptions')
    ),

    'omit_employers' => array(
      xl('Omit Employers'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Omit employer information in patient demographics')
    ),

    'select_multi_providers' => array(
      xl('Support Multi-Provider Events'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Support calendar events that apply to multiple providers')
    ),

    'disable_non_default_groups' => array(
      xl('Disable User Groups'),
      'bool',                           // data type
      '1',                              // default = true
      xl('Normally this should be checked. Not related to access control.')
    ),

    'ignore_pnotes_authorization' => array(
      xl('Skip Authorization of Patient Notes'),
      'bool',                           // data type
      '1',                              // default = true
      xl('Do not require patient notes to be authorized')
    ),

    'support_encounter_claims' => array(
      xl('Allow Encounter Claims'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Allow creation of claims containing diagnoses but not procedures or charges. Most clinics do not want this.')
    ),

    'advance_directives_warning' => array(
      xl('Advance Directives Warning'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Display advance directives in the demographics page.')
    ),

    'configuration_import_export' => array(
      xl('Configuration Export/Import'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Support export/import of configuration data via the Backup page.')
    ),

    'restrict_user_facility' => array(
      xl('Restrict Users to Facilities'),
      'bool',                           // data type
      '0',                              // default
      xl('Restrict non-authorized users to the Schedule Facilities set in User admin.')
    ),

    'set_facility_cookie' => array(
      xl('Remember Selected Facility'),
      'bool',                           // data type
      '0',                              // default
      xl('Set a facility cookie to remember the selected facility between logins.')
    ),
    
    'receipts_by_provider' => array(
      xl('Print Receipts by Provider'),
      'bool',
      '0',                              // default
      xl('Causes Receipts to Print Encounter/Primary Provider Info')
    ),

    'discount_by_money' => array(
      xl('Discounts as Monetary Amounts'),
      'bool',                           // data type
      '1',                              // default = true
      xl('Discounts at checkout time are entered as money amounts, as opposed to percentage.')
    ),

    'gbl_visit_referral_source' => array(
      xl('Display Referral Source for Encounters'),
      'bool',                           // data type
      '0',                              // default = false
      xl('A referral source may be specified for each visit.')
    ),

    'gbl_visit_sensitivity' => array(
      xl('Display Sensitivity for Encounters'),
      'bool',                           // data type
      '1',                              // default = true
      xl('A sensitivity may be specified for each visit.')
    ),

    'gbl_visit_voucher_number' => array(
      xl('Display Voucher Number for Encounters'),
      'bool',                           // data type
      '1',                              // default = true
      xl('A voucher number may be specified for each visit.')
    ),

    'gbl_visit_shift' => array(
      xl('Display Shift for Encounters'),
      'bool',                           // data type
      '0',                              // default = true
      xl('A shift may be specified for each visit.')
    ),

    'gbl_form_save_close' => array(
      xl('Display Save and Close Visit button in LBFs'),
      'bool',                           // data type
      '0',                              // default = false
      xl('This is helpful if visits usually do not have charges.')
    ),

    'gbl_mask_patient_id' => array(
      xl('Mask for Patient IDs'),
      'text',                           // data type
      '',                               // default
      xl('Specifies formatting for the external patient ID.  # = digit, @ = alpha, * = any character.  Empty if not used.')
    ),

    'gbl_mask_invoice_number' => array(
      xl('Mask for Invoice Numbers'),
      'text',                           // data type
      '',                               // default
      xl('Specifies formatting for invoice reference numbers.  # = digit, @ = alpha, * = any character.  Empty if not used.')
    ),

    'gbl_mask_product_id' => array(
      xl('Mask for Product IDs'),
      'text',                           // data type
      '',                               // default
      xl('Specifies formatting for product NDC fields.  # = digit, @ = alpha, * = any character.  Empty if not used.')
    ),

    'force_billing_widget_open' => array(
      xl('Force Billing Widget Open'),
      'bool',                           // data type
      '0',                              // default = false
      xl('This will force the Billing Widget in the Patient Summary screen to always be open.')
    ),
      
    'num_past_appointments_to_show' => array(
      xl('Past Appointment Display Widget'),
      'num',                           // data type
      '0',                             // default = false
      xl('A positive number will show that many past appointments on a Widget in the Patient Summary screen.')
    ),      

    'activate_ccr_ccd_report' => array(
      xl('Activate CCR/CCD Reporting'),
      'bool',                           // data type
      '1',                              // default = true
      xl('This will activate the CCR(Continuity of Care Record) and CCD(Continuity of Care Document) reporting.')
    ),
    
    'hide_document_encryption' => array(
      xl('Hide Encryption/Decryption Options In Document Management'),
      'bool',                           // data type
      '1',                              // default = true
      xl('This will deactivate document the encryption and decryption features, and hide them in the UI.')
    ),

    'use_custom_immun_list' => array(
      xl('Use Custom Immunization List'),
      'bool',                           // data type
      '0',                              // default = true
      xl('This will use the custom immunizations list rather than the standard CVX immunization list.')
    ),
    
      'cms_1500' => array(
      xl('CMS 1500 Paper Form Format'),
      array(
        '0' => xl('08/05'),
        '1' => xl('02/12'),
      ),
      '0',                              // default
      xl('This specifies which revision of the form the billing module should generate')
    ),
     
      'cms_1500_box_31_format' => array(
      xl('CMS 1500: Box 31 Format'),
      array(
        '0' => xl('Signature on File'),
        '1' => xl('Firstname Lastname'),
        '2' => xl('None'),
      ),
      '0',                              // default
      xl('This specifies whether to include date in Box 31.')
    ),

      
     'cms_1500_box_31_date' => array(
      xl('CMS 1500: Date in Box 31 (Signature)'),
      array(
        '0' => xl('None'),
        '1' => xl('Date of Service'),
        '2' => xl('Today'),
      ),
      '0',                              // default
      xl('This specifies whether to include date in Box 31.')
    ),

  ),
    // E-Sign Tab
    //
    'E-Sign' => array(
            
    'esign_all' => array(
      xl('Allows E-Sign on the entire encounter'),
      'bool',                           // data type
      '0',                              // default = false
      xl('This will enable signing an entire encounter, rather than individual forms')
    ),

    'lock_esign_all' => array(
      xl('Lock e-signed encounters and their forms'),
      'bool',                           // data type
      '0',                              // default = false
      xl('This will disable the Edit button on all forms whose parent encounter is e-signed')
    ),
            
    'esign_individual' => array(
      xl('Allows E-Signing Individual Forms'),
      'bool',                           // data type
      '1',                              // default = false
      xl('This will enable signing individual forms separately')
    ),

    'lock_esign_individual' => array(
      xl('Lock an e-signed form individually'),
      'bool',                           // data type
      '1',                              // default = false
      xl('This will disable the Edit button on any form that is e-signed')
    ),
            
    'esign_lock_toggle' => array(
      xl('Enable lock toggle'),
      'bool',                           // data type
      '0',                              // default = false
      xl('This will give the user the option to lock (separate locking and signing)')
    ),

    'esign_report_hide_empty_sig' => array(
      xl('Hide Empty E-Sign Logs On Report'),
      'bool',                           // data type
      '1',                              // default = false
      xl('This will hide empty e-sign logs on the patient report')
    ),

  ),
    //Documents Tab
    'Documents' => array(
        'document_storage_method' => array(
            xl('Document Storage Method'),
            array(
                '0' => xl('Hard Disk'),
                '1' => xl('CouchDB')
            ),
            '0',                              // default
            xl('Option to save method of document storage.')
        ),
        'couchdb_host' => array(
            xl('CouchDB HostName'),
            'text',
            'localhost',
            xl('CouchDB host'),
        ),
        'couchdb_user' => array(
            xl('CouchDB UserName'),
            'text',
            '',
            xl('Username to connect to CouchDB'),
        ),
        'couchdb_pass' => array(
            xl('CouchDB Password'),
            'text',
            '',
            xl('Password to connect to CouchDB'),
        ),
        'couchdb_port' => array(
            xl('CouchDB Port'),
            'text',
            '5984',
            xl('CouchDB port'),
        ),
        'couchdb_dbase' => array(
            xl('CouchDB Database'),
            'text',
            '',
            xl('CouchDB database name'),
        ),
        'couchdb_log' => array(
            xl('CouchDB Log Enable'),
            'bool',
            '0',
            xl('Enable log for document uploads/downloads to CouchDB'),
        ),

    'patient_id_category_name' => array(
      xl('Patient ID Category Name'),
      'text',                           // data type
      'Patient ID card',                // default
      xl('Optional category name for an ID Card image that can be viewed from the patient summary page.')
    ),

    'patient_photo_category_name' => array(
      xl('Patient Photo Category Name'),
      'text',                           // data type
      'Patient Photograph',             // default
      xl('Optional category name for photo images that can be viewed from the patient summary page.')
    ),

    'lab_results_category_name' => array(
      xl('Lab Results Category Name'),
      'text',                           // data type
      'Lab Report',                     // default
      xl('Document category name for storage of electronically received lab results.')
    ),

  ),

  // Calendar Tab
  //
  'Calendar' => array(

    'disable_calendar' => array(
      xl('Disable Calendar'),
      'bool',                           // data type
      '0',                              // default
      xl('Do not display the calendar.')
    ),

    'schedule_start' => array(
      xl('Calendar Starting Hour'),
      'hour',
      '8',                              // default
      xl('Beginning hour of day for calendar events.')
    ),

    'schedule_end' => array(
      xl('Calendar Ending Hour'),
      'hour',
      '17',                             // default
      xl('Ending hour of day for calendar events.')
    ),

    'calendar_interval' => array(
      xl('Calendar Interval'),
      array(
        '5' => '5',
       '10' => '10',
       '15' => '15',
       '20' => '20',
       '30' => '30',
       '60' => '60',
      ),
      '15',                              // default
      xl('The time granularity of the calendar and the smallest interval in minutes for an appointment slot.')
    ),

    'calendar_appt_style' => array(
      xl('Appointment Display Style'),
      array(
        '1' => 'Last name',
        '2' => 'Last name, first name',
        '3' => 'Last name, first name (title)',
        '4' => 'Last name, first name (title: description)',
      ),
      '2',                               // default
      xl('This determines how appointments display on the calendar.')
    ),

    'docs_see_entire_calendar' => array(
      xl('Providers See Entire Calendar'),
      'bool',                           // data type
      '0',                              // default
      xl('Check this if you want providers to see all appointments by default and not just their own.')
    ),

    'auto_create_new_encounters' => array(
      xl('Auto-Create New Encounters'),
      'bool',                           // data type
      '1',                              // default
      xl('Automatically create a new encounter when an appointment check in status is selected.')
    ),
    
    'event_color' => array(
      xl('Appointment/Event Color'),
      array(
        '1' => 'Category Color Schema',
        '2' => 'Facility Color Schema',
      ),                           // data type
      '1',                              // default
      xl('This determines which color schema used for appointment')
    ),

    'disable_pat_trkr' => array(
      xl('Disable Patient Flow Board'),
      'bool',                           // data type
      '0',                              // default
      xl('Do not display the patient flow board.')
    ),

    'ptkr_visit_reason' => array(
      xl('Show Visit Reason in Patient Flow Board'),
      'bool',                           // data type
      '0',                              // default = false
      xl('When Checked, Visit Reason Will Show in Patient Flow Board.')
    ),  

    'ptkr_show_pid' => array(
      xl('Show Patient ID in Patient Flow Board'),
      'bool',                           // data type
      '1',                              // default = true
      xl('When Checked, Patient ID Will Show in Patient Flow Board.')
    ),  
	
    'ptkr_show_encounter' => array(
      xl('Show Patient Encounter Number in Patient Flow Board'),
      'bool',                           // data type
      '1',                              // default = true
      xl('When Checked, Patient Encounter Number Will Show in Patient Flow Board.')
    ),  
	
    'pat_trkr_timer' => array(
      xl('Patient Flow Board Timer Interval'),
      array(
       '0' => 'No automatic refresh',
       '0:10' => '10',
       '0:20' => '20',
       '0:30' => '30',
       '0:40' => '40',
       '0:50' => '50',
       '0:59' => '60',
      ),
      '0:20',                              // default
      xl('The screen refresh time in Seconds for the Patient Flow Board Screen.')
    ),
	
    'checkout_roll_off' => array(
      xl('Number of Minutes to display completed checkouts'),
      'num',
      '0',                       // default
      xl('Number of Minutes to display completed checkouts. Zero is continuous display')
    ),
    
    'drug_screen' => array(
      xl('Enable Random Drug Testing'),
     'bool',                           // data type
      '0',                              // default
      xl('Allow Patient Flow Board to Select Patients for Drug Testing.')
    ),
	
    'drug_testing_percentage' => array(
      xl('Percentage of Patients to Drug Test'),
      'num',
      '33',                       // default
      xl('Percentage of Patients to select for Random Drug Testing.')
    ),
	
    'maximum_drug_test_yearly' => array(
      xl('Maximum number of times a Patient can be tested in a year'),
      'num',
      '0',                       // default
      xl('Maximum number of times a Patient can be tested in a year. Zero is no limit.')
    ),
    
  ),

  // Security Tab
  //
  'Security' => array(

    'timeout' => array(
      xl('Idle Session Timeout Seconds'),
      'num',                            // data type
      '7200',                           // default
      xl('Maximum idle time in seconds before logout. Default is 7200 (2 hours).')
    ),

    'secure_password' => array(
      xl('Require Strong Passwords'),
      'bool',                           // data type
      '0',                              // default
      xl('Strong password means at least 8 characters, and at least three of: a number, a lowercase letter, an uppercase letter, a special character.')
    ),

    'password_history' => array(
      xl('Require Unique Passwords'),
      'bool',                           // data type
      '0',                              // default
      xl('Means none of last three passwords are allowed when changing a password.')
    ),
    'password_compatibility' => array(
      xl('Permit unsalted passwords'),
      'bool',                           // data type
      '1',                              // default
      xl('After migration from the old password mechanisms where passwords are stored in the users table without salt is complete, this flag should be set to false so that only authentication by the new method is possible')
    ),
      
    'password_expiration_days' => array(
      xl('Default Password Expiration Days'),
      'num',                            // data type
      '0',                              // default
      xl('Default password expiration period in days. 0 means this feature is disabled.')
    ),

    'password_grace_time' => array(
      xl('Password Expiration Grace Period'),
      'num',                            // data type
      '0',                              // default
      xl('Period in days where a user may login with an expired password.')
    ),

    'is_client_ssl_enabled' => array(
      xl('Enable Client SSL'),
      'bool',                           // data type
      '0',                              // default
      xl('Enable client SSL certificate authentication.')
    ),

    'gbl_fac_warehouse_restrictions' => array(
      xl('Enable Facility/Warehouse Permissions'),
      'bool',                           // data type
      '0',                              // default
      xl('Enable facility/warehouse restrictions in the user administration form.')
    ),

    'certificate_authority_crt' => array(
      xl('Path to CA Certificate File'),
      'text',                           // data type
      '',                               // default
      xl('Set this to the full absolute path. For creating client SSL certificates for HTTPS.')
    ),

    'certificate_authority_key' => array(
      xl('Path to CA Key File'),
      'text',                           // data type
      '',                               // default
      xl('Set this to the full absolute path. For creating client SSL certificates for HTTPS.')
    ),

    'client_certificate_valid_in_days' => array(
      xl('Client Certificate Expiration Days'),
      'num',                            // data type
      '365',                            // default
      xl('Number of days that the client certificate is valid.')
    ),

    'Emergency_Login_email_id' => array(
      xl('Emergency Login Email Address'),
      'text',                           // data type
      '',                               // default
      xl('Email address, if any, to receive emergency login user activation messages.')
    ),

    'gbl_num_challenge_questions_stored' => array(
      xl('Number of challenge questions to store per user'),
      'num',                            // data type
      '0',                              // default
      xl('How many challenge questions per user can we select from. 0 means this feature is disabled.')
    ),

    'gbl_num_challenge_questions_asked' => array(
      xl('Number of challenge questions to ask at login'),
      'num',                            // data type
      '0',                              // default
      xl('How many challenge questions must the user answer on login. Must be <= the number stored.')
    ),

    'gbl_days_between_challenges' => array(
      xl('How many days before repeating challenge'),
      'num',                            // data type
      '1',                              // default
      xl('How many days is the challenge good for; 0 to ask at every login.')
    ),

    /***************************** TBD ********************************
    'gbl_max_failed_logins' => array(
      xl('How many consecutive failed logins allowed'),
      'num',                            // data type
      '1',                              // default
      xl('Maximum number of consecutive failed logins.')
    ),
    ******************************************************************/

  ),

  // Notifications Tab
  //
  'Notifications' => array(

    'patient_reminder_sender_name' => array(
      xl('Patient Reminder Sender Name'),
      'text',                           // data type
      '',                               // default
      xl('Name of the sender for patient reminders.')
    ),
    
    'patient_reminder_sender_email' => array(
      xl('Patient Reminder Sender Email'),
      'text',                           // data type
      '',                               // default
      xl('Email address of the sender for patient reminders. Replies to patient reminders will be directed to this address. It is important to use an address from your clinic\'s domain to avoid help prevent patient reminders from going to junk mail folders.')
    ),
    
    'practice_return_email_path' => array(
      xl('Notification Email Address'),
      'text',                           // data type
      '',                               // default
      xl('Email address, if any, to receive administrative notifications.')
    ),

    'EMAIL_METHOD' => array(
      xl('Email Transport Method'),
      array(
        'PHPMAIL'  => 'PHPMAIL',
        'SENDMAIL' => 'SENDMAIL',
        'SMTP'     => 'SMTP',
      ),
      'SMTP',                             // default
      xl('Method for sending outgoing email.')
    ),

    'SMTP_HOST' => array(
      xl('SMTP Server Hostname'),
      'text',                           // data type
      'localhost',                      // default
      xl('If SMTP is used, the server`s hostname or IP address.')
    ),

    'SMTP_PORT' => array(
      xl('SMTP Server Port Number'),
      'num',                            // data type
      '25',                             // default
      xl('If SMTP is used, the server`s TCP port number (usually 25).')
    ),

    'SMTP_USER' => array(
      xl('SMTP User for Authentication'),
      'text',                           // data type
      '',                               // default
      xl('Must be empty if SMTP authentication is not used.')
    ),

    'SMTP_PASS' => array(
      xl('SMTP Password for Authentication'),
      'text',                           // data type
      '',                               // default
      xl('Must be empty if SMTP authentication is not used.')
    ),

    'EMAIL_NOTIFICATION_HOUR' => array(
      xl('Email Notification Hours'),
      'num',                            // data type
      '50',                             // default
      xl('Number of hours in advance to send email notifications.')
    ),

    'SMS_NOTIFICATION_HOUR' => array(
      xl('SMS Notification Hours'),
      'num',                            // data type
      '50',                             // default
      xl('Number of hours in advance to send SMS notifications.')
    ),

    'SMS_GATEWAY_USENAME' => array(
      xl('SMS Gateway Username'),
      'text',                           // data type
      '',                               // default
      xl('Username for SMS Gateway.')
    ),

    'SMS_GATEWAY_PASSWORD' => array(
      xl('SMS Gateway Password'),
      'text',                           // data type
      '',                               // default
      xl('Password for SMS Gateway.')
    ),

    'SMS_GATEWAY_APIKEY' => array(
      xl('SMS Gateway API Key'),
      'text',                           // data type
      '',                               // default
      xl('API key for SMS Gateway.')
    ),

    'phone_notification_hour' => array(
      xl('Phone Notification Hour'),
      'num',                            // data type
      '50',                             // default
      xl('Number of hours in advance to send Phone notification.')
    ),
    
    'phone_gateway_username' => array(
      xl('Phone Gateway Username'),
      'text',                           // data type
      '',                               // default
      xl('Username for Phone Gateway. Automated VOIP service provided by Maviq. Please visit http://signup.maviq.com for more information.')
    ),
    
    'phone_gateway_password' => array(
      xl('Phone Gateway Password'),
      'text',                           // data type
      '',                               // default
      xl('Password for Phone Gateway. Automated VOIP service provided by Maviq. Please visit http://signup.maviq.com for more information.')
    ),
    
    'phone_gateway_url' => array(
      xl('Phone Gateway URL'),
      'text',                           // data type
      '',                               // default
      xl('URL for Phone Gateway. Automated VOIP service provided by Maviq. Please visit http://signup.maviq.com for more information.')
    ),

  ),
  
  // CDR (Clinical Decision Rules)
  //
  'CDR' => array(

    'enable_cdr' => array(
      xl('Enable Clinical Decisions Rules (CDR)'),
      'bool',                           // data type
      '1',                               // default
      xl('Enable Clinical Decisions Rules (CDR)')
    ),
    
    'enable_cdr_crw' => array(
      xl('Enable Clinical Reminder Widget'),
      'bool',                           // data type
      '1',                               // default
      xl('Enable Clinical Reminder Widget')
    ),

    'enable_cdr_crp' => array(
      xl('Enable Clinical Reminder Popup'),
      'bool',                           // data type
      '1',                               // default
      xl('Enable Clinical Reminder Popup')
    ),

    'enable_cdr_prw' => array(
      xl('Enable Patient Reminder Widget'),
      'bool',                           // data type
      '1',                               // default
      xl('Enable Patient Reminder Widget')
    ),

    'enable_cqm' => array(
      xl('Enable CQM Reporting'),
      'bool',                           // data type
      '1',                               // default
      xl('Enable Clinical Quality Measure (CQM) Reporting')
    ),

    'pqri_registry_name' => array(
      xl('PQRI Registry Name'),
      'text',                           // data type
      'Model Registry',                               // default
      xl('PQRI Registry Name')
    ),

    'pqri_registry_id' => array(
      xl('PQRI Registry ID'),
      'text',                           // data type
      '125789123',                               // default
      xl('PQRI Registry ID')
    ),

    'enable_amc' => array(
      xl('Enable AMC Reporting'),
      'bool',                           // data type
      '1',                               // default
      xl('Enable Automated Measure Calculations (AMC) Reporting')
    ),

    'enable_amc_prompting' => array(
      xl('Enable AMC Prompting'),
      'bool',                           // data type
      '1',                               // default
      xl('Enable Prompting For Automated Measure Calculations (AMC) Required Data')
    ),

    'enable_amc_tracking' => array(
      xl('Enable AMC Tracking'),
      'bool',                           // data type
      '1',                               // default
      xl('Enable Reporting of Tracking Date For Automated Measure Calculations (AMC)')
    ),

    'cdr_report_nice' => array(
      xl('CDR Reports Processing Priority'),
      array(
        '' => xl('Default Priority'),
        '5' => xl('Moderate Priority'),
        '10' => xl('Moderate/Low Priority'),
        '15' => xl('Low Priority'),
        '20' => xl('Lowest Priority')
      ),
      '',                               // default
      xl('Set processing priority for CDR engine based reports.')
    ),

    'pat_rem_clin_nice' => array(
      xl('Patient Reminder Creation Processing Priority'),
      array(
        '' => xl('Default Priority'),
        '5' => xl('Moderate Priority'),
        '10' => xl('Moderate/Low Priority'),
        '15' => xl('Low Priority'),
        '20' => xl('Lowest Priority')
      ),
      '',                               // default
      xl('Set processing priority for creation of Patient Reminders (in full clinic mode).')
    ),
 
  ),

  // Logging
  //
  'Logging' => array(

    'enable_auditlog' => array(
      xl('Enable Audit Logging'),
      'bool',                           // data type
      '1',                              // default
      xl('Enable Audit Logging')
    ),

    'audit_events_patient-record' => array(
      xl('Audit Logging Patient Record'),
      'bool',                           // data type
      '1',                              // default
      xl('Enable logging of patient record modifications.').' ('.xl('Note that Audit Logging needs to be enabled above').')'
    ),

    'audit_events_scheduling' => array(
      xl('Audit Logging Scheduling'),
      'bool',                           // data type
      '1',                              // default
      xl('Enable logging of scheduling activities.').' ('.xl('Note that Audit Logging needs to be enabled above').')'
    ),

    'audit_events_order' => array(
      xl('Audit Logging Order'),
      'bool',                           // data type
      '1',                              // default
      xl('Enable logging of ordering activities.').' ('.xl('Note that Audit Logging needs to be enabled above').')'
    ),

    'audit_events_security-administration' => array(
      xl('Audit Logging Security Administration'),
      'bool',                           // data type
      '1',                              // default
      xl('Enable logging of security and administration activities.').' ('.xl('Note that Audit Logging needs to be enabled above').')'
    ),

    'audit_events_backup' => array(
      xl('Audit Logging Backups'),
      'bool',                           // data type
      '1',                              // default
      xl('Enable logging of backup related activities.').' ('.xl('Note that Audit Logging needs to be enabled above').')'
    ),

    'audit_events_other' => array(
      xl('Audit Logging Miscellaneous'),
      'bool',                           // data type
      '1',                              // default
      xl('Enable logging of miscellaneous activities.').' ('.xl('Note that Audit Logging needs to be enabled above').')'
    ),

    'audit_events_query' => array(
      xl('Audit Logging SELECT Query'),
      'bool',                           // data type
      '0',                              // default
      xl('Enable logging of all SQL SELECT queries.').' ('.xl('Note that Audit Logging needs to be enabled above').')'
    ),

    'audit_events_cdr' => array(
      xl('Audit CDR Engine Queries'),
      'bool',                           // data type
      '0',                              // default
      xl('Enable logging of CDR Engine Queries.').' ('.xl('Note that Audit Logging needs to be enabled above').')'
    ),

    'enable_atna_audit' => array(
      xl('Enable ATNA Auditing'),
      'bool',                           // data type
      '0',                              // default
      xl('Enable Audit Trail and Node Authentication (ATNA).')
    ),

    'atna_audit_host' => array(
      xl('ATNA audit host'),
      'text',                           // data type
      '',                               // default
      xl('The hostname of the ATNA audit repository machine.')
    ),

    'atna_audit_port' => array(
      xl('ATNA audit port'),
      'text',                           // data type
      '6514',                           // default
      xl('Listening port of the RFC 5425 TLS syslog server.')
    ),

    'atna_audit_localcert' => array(
      xl('ATNA audit local certificate'),
      'text',                           // data type
      '',                               // default
      xl('Certificate to send to RFC 5425 TLS syslog server.')
    ),

    'atna_audit_cacert' => array(
      xl('ATNA audit CA certificate'),
      'text',                           // data type
      '',                               // default
      xl('CA Certificate for verifying the RFC 5425 TLS syslog server.')
    ),

  ),

  // Miscellaneous Tab
  //
  'Miscellaneous' => array(

    'mysql_bin_dir' => array(
      xl('Path to MySQL Binaries'),
      'text',                           // data type
      $mysql_bin_dir,                   // default
      xl('Full path to directory containing MySQL executables.')
    ),

    'perl_bin_dir' => array(
      xl('Path to Perl Binaries'),
      'text',                           // data type
      $perl_bin_dir,                    // default
      xl('Full path to directory containing Perl executables.')
    ),

    'temporary_files_dir' => array(
      xl('Path to Temporary Files'),
      'text',                           // data type
      $temporary_files_dir,             // default
      xl('Full path to directory used for temporary files.')
    ),

    'backup_log_dir' => array(
      xl('Path for Event Log Backup'),
      'text',                           // data type
      $backup_log_dir,                  // default
      xl('Full path to directory for event log backup.')
    ),

    'state_data_type' => array(
      xl('State Data Type'),
      array(
        '2' => xl('Text field'),
        '1' => xl('Single-selection list'),
       '26' => xl('Single-selection list with ability to add to the list'),
      ),
      '26',                             // default
      xl('Field type to use for employer or subscriber state in demographics.')
    ),

    'state_list' => array(
      xl('State list'),
      'text',                           // data type
      'state',                          // default
      xl('List used by above State Data Type option.')
    ),

    'state_custom_addlist_widget' => array(
      xl('State List Widget Custom Fields'),
      'bool',                           // data type
      '1',                              // default
      xl('Show the custom state form for the add list widget (will ask for title and abbreviation).')
    ),

    'country_data_type' => array(
      xl('Country Data Type'),
      array(
        '2' => xl('Text field'),
        '1' => xl('Single-selection list'),
       '26' => xl('Single-selection list with ability to add to the list'),
      ),
      '26',                             // default
      xl('Field type to use for employer or subscriber country in demographics.')
    ),

    'country_list' => array(
      xl('Country list'),
      'text',                           // data type
      'country',                          // default
      xl('List used by above Country Data Type option.')
    ),

    'print_command' => array(
      xl('Print Command'),
      'text',                           // data type
      'lpr -P HPLaserjet6P -o cpi=10 -o lpi=6 -o page-left=72 -o page-top=72',
      xl('Shell command for printing from the server.')
    ),

    'default_chief_complaint' => array(
      xl('Default Reason for Visit'),
      'text',                           // data type
      '',
      xl('You may put text here as the default complaint in the New Patient Encounter form.')
    ),

    'default_new_encounter_form' => array(
      xl('Default Encounter Form ID'),
      'text',                           // data type
      '',
      xl('To automatically open the specified form. Some sports teams use football_injury_audit here.')
    ),

    'MedicareReferrerIsRenderer' => array(
      xl('Medicare Referrer Is Renderer'),
      'bool',                           // data type
      '0',                              // default = true
      xl('For Medicare only, forces the referring provider to be the same as the rendering provider.')
    ),

    'post_to_date_benchmark' => array(
      xl('Financial Close Date (yyyy-mm-dd)'),
      'text',                           // data type
      date('Y-m-d',time() - (10 * 24 * 60 * 60)),                // default
      xl('The payments posted cannot go below this date.This ensures that after taking the final report nobody post for previous dates.')
    ),

    'gbl_auto_destroy_lots' => array(
      xl('Automatically Destroy Lots'),
      'bool',                           // data type
      '0',                              // default
      xl('When a sale exhausts lot QOH, automatically mark the lot as destroyed.')
    ),

    'gbl_expired_lot_warning_days' => array(
      xl('Expired Lot Warning Days'),
      'text',                           // data type
      30,                               // default
      xl('A warning first appears in the Inventory List report when a lot expires in this many days.')
    ),

    'enable_hylafax' => array(
      xl('Enable Hylafax Support'),
      'bool',                           // data type
      '0',                              // default
      xl('Enable Hylafax Support')
    ),

    'hylafax_server' => array(
      xl('Hylafax Server'),
      'text',                           // data type
      'localhost',                      // default
      xl('Hylafax server hostname.')
    ),

    'hylafax_basedir' => array(
      xl('Hylafax Directory'),
      'text',                           // data type
      '/var/spool/fax',                 // default
      xl('Location where Hylafax stores faxes.')
    ),

    'hylafax_enscript' => array(
      xl('Hylafax Enscript Command'),
      'text',                           // data type
      'enscript -M Letter -B -e^ --margins=36:36:36:36', // default
      xl('Enscript command used by Hylafax.')
    ),

    'enable_scanner' => array(
      xl('Enable Scanner Support'),
      'bool',                           // data type
      '0',                              // default
      xl('Enable Scanner Support')
    ),

    'scanner_output_directory' => array(
      xl('Scanner Directory'),
      'text',                           // data type
      '/mnt/scan_docs',                 // default
      xl('Location where scans are stored.')
    ),

  ),

  // Portal Tab
  //
  'Portal' => array(

    'portal_onsite_enable' => array(
      xl('Enable Onsite Patient Portal'),
      'bool',                           // data type
      '0',
      xl('Enable Onsite Patient Portal.')
    ),

    'portal_onsite_address' => array(
      xl('Onsite Patient Portal Site Address'),
      'text',                           // data type
      'https://your_web_site.com/openemr/patients',
      xl('Website link for the Onsite Patient Portal.')
    ),
    
    'portal_offsite_enable' => array(
      xl('Enable Offsite Patient Portal'),
      'bool',                           // data type
      '0',
      xl('Enable Offsite Patient Portal.')
    ),

    'portal_offsite_providerid' => array(
      xl('Offsite Patient Portal Provider ID'),
      'text',                           // data type
      '',
      xl('Offsite Patient Portal Provider ID(Put Blank If not Registered).')
    ),    

    'portal_offsite_username' => array(
      xl('Offsite Patient Portal Username'),
      'text',                           // data type
      '',
      xl('Offsite Patient Portal Username(Put Blank If not Registered).')
    ),

    'portal_offsite_password' => array(
      xl('Offsite Patient Portal Password'),
      'pwd',                           // data type
      '',
      xl('Offsite Patient Portal Password(Put Blank If not Registered).')
    ),

    'portal_offsite_address' => array(
      xl('Offsite Patient Portal Site Address'),
      'text',                           // data type
      'https://ssh.mydocsportal.com/provider.php',
      xl('Offsite Https link for the Patient Portal.')
    ),
    'portal_offsite_address_patient_link' => array(
      xl('Offsite Patient Portal Site Address (Patient Link)'),
      'text',                           // data type
      'https://ssh.mydocsportal.com',
      xl('Offsite Https link for the Patient Portal.(Patient Link)')
    ),

  ),

  // Connectors Tab
  //
  'Connectors' => array(

    'lab_exchange_enable' => array(
      xl('Enable Lab Exchange'),
      'bool',                           // data type
      '0',
      xl('Enable the Medical Information Integration, LLC Lab Exchange Service.')
    ),

    'lab_exchange_siteid' => array(
      xl('Lab Exchange Site ID'),
      'text',                           // data type
      '3',
      xl('Site ID for the Medical Information Integration, LLC Lab Exchange Service.')
    ),

    'lab_exchange_token' => array(
      xl('Lab Exchange Token ID'),
      'text',                           // data type
      '12345',
      xl('Token ID for the Medical Information Integration, LLC Lab Exchange Service.')
    ),

    'lab_exchange_endpoint' => array(
      xl('Lab Exchange Site Address'),
      'text',                           // data type
      'https://len.mi-squared.com:29443/len/api',
      xl('Contact Medical Information Integration, LLC at http://mi-squared.com for Lab Exchange Service.')
    ),
    
    'erx_enable' => array(
      xl('Enable NewCrop eRx Service'),
      'bool',                           // data type
      '0',
      xl('Enable NewCrop eRx Service')
    ),    
    
    'erx_path_production' => array(
      xl('NewCrop eRx Site Address'),
      'text',                           // data type
      'https://secure.newcropaccounts.com/InterfaceV7/RxEntry.aspx',
      xl('Contact Medical Information Integration, LLC at http://mi-squared.com or ZH Healthcare at http://zhservices.com for subscribing the eRx service')
    ),
    
    'erx_path_soap_production' => array(
      xl('NewCrop eRx Web Service Address'),
      'text',                           // data type
      'https://secure.newcropaccounts.com/v7/WebServices/Update1.asmx?WSDL;https://secure.newcropaccounts.com/v7/WebServices/Patient.asmx?WSDL',
      xl('Contact Medical Information Integration, LLC at http://mi-squared.com or ZH Healthcare at http://zhservices.com for subscribing the eRx service')
    ),
    
    'erx_soap_ttl_allergies' => array(
      xl('NewCrop eRx SOAP Request Time-To-Live for Allergies'),
      'num',
      '21600',
      xl('Time-To-Live for Allergies SOAP Request in seconds')
    ),
    
    'erx_soap_ttl_medications' => array(
      xl('NewCrop eRx SOAP Request Time-To-Live for Medications'),
      'num',
      '21600',
      xl('Time-To-Live for Medications SOAP Request in seconds')
    ),
    
    'partner_name_production' => array(
      xl('NewCrop eRx Partner Name'),
      'text',                           // data type
      '',
      xl('Contact Medical Information Integration, LLC at http://mi-squared.com or ZH Healthcare at http://zhservices.com for subscribing the eRx service')
    ),
    
    'erx_name_production' => array(
      xl('NewCrop eRx Name'),
      'text',                           // data type
      '',
      xl('Contact Medical Information Integration, LLC at http://mi-squared.com or ZH Healthcare at http://zhservices.com for subscribing the eRx service')
    ),
    
    'erx_password_production' => array(
      xl('NewCrop eRx Password'),
      'pass',                           // data type
      '',
      xl('Contact Medical Information Integration, LLC at http://mi-squared.com or ZH Healthcare at http://zhservices.com for subscribing the eRx service')
    ),
    
    'erx_account_id' => array(
      xl('NewCrop eRx Account Id'),
      'text',                           // data type
      '1',
      xl('Contact Medical Information Integration, LLC at http://mi-squared.com or ZH Healthcare at http://zhservices.com for subscribing the eRx service')
    ),
    
    'erx_upload_active' => array(
      xl('Only upload active prescriptions'),
      'bool',                           // data type
      '0',
      xl('Only upload active prescriptions')
    ),
    
    'erx_import_status_message' => array(
      xl('Enable import status message for NewCrop erx'),
      'bool',                           // data type
      '0',
      xl('Enable import status message for NewCrop erx')
    ),
    
    'erx_medication_display' => array(
      xl('Do not display Medications uploaded to NewCrop'),
      'bool',                           // data type
      '0',
      xl('Do not display Medications uploaded to NewCrop')
    ),
	
	'erx_allergy_display' => array(
      xl('Do not display Allergy uploaded to NewCrop'),
      'bool',                           // data type
      '0',
      xl('Do not display Allergy uploaded to NewCrop')
    ),
        
    'erx_default_patient_country' => array(
        xl('Default Patient Country'),
        array(
            '' => '',
            'US' => 'USA',
            'CA' => 'Canada',
            'MX' => 'Mexico'
        ),
        '',
        xl('Default Patient Country'),
    ),

    'phimail_enable' => array(
      xl('Enable phiMail Direct Messaging Service'),
      'bool',                           // data type
      '0',
      xl('Enable phiMail Direct Messaging Service')
    ),

    'phimail_server_address' => array(
      xl('phiMail Server Address'),
      'text',                           // data type
      'https://phimail.example.com:32541',
      xl('Contact EMR Direct to subscribe to the phiMail Direct messaging service')
    ),

    'phimail_username' => array(
      xl('phiMail Username'),
      'text',                           // data type
      '',
      xl('Contact EMR Direct to subscribe to the phiMail Direct messaging service')
    ),

    'phimail_password' => array(
      xl('phiMail Password'),
      'pass',                           // data type
      '',
      xl('Contact EMR Direct to subscribe to the phiMail Direct messaging service')
    ),

    'phimail_notify' => array(
      xl('phiMail notification user'),
      'text',                           // data type
      'admin',
      xl('This user will receive notification of new incoming Direct messages')
    ),

    'phimail_interval' => array(
      xl('phiMail Message Check Interval (minutes)'),
      'num',                           // data type
      '5',
      xl('Interval between message checks (set to zero for manual checks only)')
    ),

    'phimail_ccd_enable' => array(
      xl('phiMail Allow CCD Send'),
      'bool',                           // data type
      '0',
      xl('phiMail Allow CCD Send')
    ),

    'phimail_ccr_enable' => array(
      xl('phiMail Allow CCR Send'),
      'bool',                           // data type
      '0',
      xl('phiMail Allow CCR Send')
    )

  ),
  
  'Rx' => array(
    'rx_enable_DEA' => array(
      xl('Rx Enable DEA #'),
      'bool',                           // data type
      '1',
      xl('Rx Enable DEA #')
    ),
    'rx_show_DEA' => array(
      xl('Rx Show DEA #'),
      'bool',                           // data type
      '0',
      xl('Rx Show DEA #')
    ),
    'rx_enable_NPI' => array(
      xl('Rx Enable NPI'),
      'bool',                           // data type
      '0',
      xl('Rx Enable NPI')
    ),
    'rx_show_NPI' => array(
      xl('Rx Show NPI'),
      'bool',                           // data type
      '0',
      xl('Rx Show NPI')
    ),
    'rx_enable_SLN' => array(
      xl('Rx Enable State Lic. #'),
      'bool',                           // data type
      '0',
      xl('Rx Enable State Lic. #')
    ),
    'rx_show_SLN' => array(
      xl('Rx Show State Lic. #'),
      'bool',                           // data type
      '0',
      xl('Rx Show State Lic. #')
    ),
    'rx_paper_size' => array(
      xl('Rx Paper Size'),               // descriptive name
      array(
        'LETTER' => xl('Letter Paper Size'),
        'LEGAL' => xl('Legal Paper Size'),
        'FOLIO' => xl('Folio Paper Size'),
        'EXECUTIVE' => xl('Executive Paper Size'),
        '4A0' => ('4A0' . " " . xl('Paper Size')),
        '2A0' => ('2A0' . " " . xl('Paper Size')),
        'A0' => ('A0' . " " . xl('Paper Size')),
        'A1' => ('A1' . " " . xl('Paper Size')),
        'A2' => ('A2' . " " . xl('Paper Size')),
        'A3' => ('A3' . " " . xl('Paper Size')),
        'A4' => ('A4' . " " . xl('Paper Size')),
        'A5' => ('A5' . " " . xl('Paper Size')),
        'A6' => ('A6' . " " . xl('Paper Size')),
        'A7' => ('A7' . " " . xl('Paper Size')),
        'A8' => ('A8' . " " . xl('Paper Size')),
        'A9' => ('A9' . " " . xl('Paper Size')),
        'A10' => ('A10' . " " . xl('Paper Size')),
        'B0' => ('B0' . " " . xl('Paper Size')),
        'B1' => ('B1' . " " . xl('Paper Size')),
        'B2' => ('B2' . " " . xl('Paper Size')),
        'B3' => ('B3' . " " . xl('Paper Size')),
        'B4' => ('B4' . " " . xl('Paper Size')),
        'B5' => ('B5' . " " . xl('Paper Size')),
        'B6' => ('B6' . " " . xl('Paper Size')),
        'B7' => ('B7' . " " . xl('Paper Size')),
        'B8' => ('B8' . " " . xl('Paper Size')),
        'B9' => ('B9' . " " . xl('Paper Size')),
        'B10' => ('B10' . " " . xl('Paper Size')),
        'C0' => ('C0' . " " . xl('Paper Size')),
        'C1' => ('C1' . " " . xl('Paper Size')),
        'C2' => ('C2' . " " . xl('Paper Size')),
        'C3' => ('C3' . " " . xl('Paper Size')),
        'C4' => ('C4' . " " . xl('Paper Size')),
        'C5' => ('C5' . " " . xl('Paper Size')),
        'C6' => ('C6' . " " . xl('Paper Size')),
        'C7' => ('C7' . " " . xl('Paper Size')),
        'C8' => ('C8' . " " . xl('Paper Size')),
        'C9' => ('C9' . " " . xl('Paper Size')),
        'C10' => ('C10' . " " . xl('Paper Size')),
        'RA0' => ('RA0' . " " . xl('Paper Size')),
        'RA1' => ('RA1' . " " . xl('Paper Size')),
        'RA2' => ('RA2' . " " . xl('Paper Size')),
        'RA3' => ('RA3' . " " . xl('Paper Size')),
        'RA4' => ('RA4' . " " . xl('Paper Size')),
        'SRA0' => ('SRA0' . " " . xl('Paper Size')),
        'SRA1' => ('SRA1' . " " . xl('Paper Size')),
        'SRA2' => ('SRA2' . " " . xl('Paper Size')),
        'SRA3' => ('SRA3' . " " . xl('Paper Size')),
        'SRA4' => ('SRA4' . " " . xl('Paper Size')),
      ),
      'LETTER',                              // default = tree menu
      xl('Rx Paper Size')
    ),
    'rx_left_margin' => array(
      xl('Rx Left Margin (px)'),
      'num',
      '30',
      xl('Rx Left Margin (px)')
    ),
    'rx_right_margin' => array(
      xl('Rx Right Margin (px)'),
      'num',
      '30',
      xl('Rx Right Margin (px)')
    ),
    'rx_top_margin' => array(
      xl('Rx Top Margin (px)'),
      'num',
      '72',
      xl('Rx Top Margin (px)')
    ),
    'rx_bottom_margin' => array(
      xl('Rx Bottom Margin (px)'),
      'num',
      '30',
      xl('Rx Bottom Margin (px)')
    ),
  ),    
);

// A bit of a mess here. The installer includes globals.inc.php inside a function, so in that
// case $GLOBALS_METADATA is not global and the included code below fails.
if (!empty($GLOBALS['GLOBALS_METADATA'])) {
  require_once(dirname(dirname(__FILE__)) . "/ippf/globals_metadata/ippf_global_metadata.php");
}
?>
