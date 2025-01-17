<?php
/**
 * 
 */
$GLOBALS['GLOBALS_METADATA']['IPPF Features']=
array(
    'gbl_rapid_workflow' => array(
      xl('Rapid Workflow Option'),
      array(
        '0'        => xl('None'),
        'LBFmsivd' => xl('MSI (requires LBFmsivd form)'),
        'fee_sheet' => xl('Fee Sheet and Checkout'),
      ),
      '0',                              // default
      xl('Activates custom work flow logic')
    ),
    
    'gbl_new_acceptor_policy' => array(
      xl('New Acceptor Policy'),
      array(
        '0' => xl('Not applicable'),
        '1' => xl('Simplified; Contraceptive Start Date on Tally Sheet'),
        /*************************************************************
        '2' => xl('Contraception Form; New Users to IPPF/Association'),
        *************************************************************/
        '3' => xl('Contraception Form; Acceptors New to Modern Contraception'),
      ),
      '1',                              // default
      xl('Applicable only for family planning clinics')
    ),
    
    'gbl_min_max_months' => array(
      xl('Min/Max Inventory as Months'),
      'bool',                           // data type
      '1',                              // default = true
      xl('Min/max inventory is expressed as months of supply instead of units')
    ),
    
    'gbl_restrict_provider_facility' => array(
      xl('Restrict Providers by Facility'),
      'bool',                           // data type
      '0',                              // default
      xl('Limit service provider selection according to the facility of the logged-in user.')
    ),

    'gbl_checkout_line_adjustments' => array(
      xl('Adjustments at Checkout'),
      array(
        '0' => xl('Invoice Level Only'),
        '1' => xl('Line Items Only'),
        '2' => xl('Invoice and Line Levels'),
      ),
      '1',                              // default = line items only
      xl('Discounts at checkout time may be entered per invoice or per line item or both.')
    ),

    'gbl_checkout_charges' => array(
      xl('Unit Price in Checkout and Receipt'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Include line item unit price amounts in checkout and receipts.')
    ),

    'gbl_charge_categories' => array(
      xl('Customers in Checkout and Receipt'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Include Customers in checkout and receipts. See the Customers list.')
    ),

    'gbl_auto_create_rx' => array(
      xl('Automatically Create Prescriptions'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Prescriptions may be created from the Fee Sheet.')
    ),

    'gbl_checkout_receipt_note' => array(
      xl('Checkout Receipt Note'),
      'text',                           // data type
      '',
      xl('This note goes on the bottom of every checkout receipt.')
    ),

    'gbl_custom_receipt' => array(
      xl('Custom Checkout Receipt'),
      array(
        '0'                                => xl('None'),
        'checkout_receipt_general.inc.php' => xl('POS Printer'),
        'checkout_receipt_panama.inc.php'  => xl('Panama'),
      ),
      '0',                              // default
      xl('Present an additional PDF custom receipt after checkout.')
    ),

    'gbl_ma_ippf_code_restriction' => array(
      xl('Allow More than one MA/IPPF code mapping'),
      'bool',                           // data type
      '0',                              // default = false
      xl('Disable the restriction of only one IPPF code per MA code in superbill')
    ),
    
    'gbl_uruguay_asse_url' => array(
      xl('Uruguay ASSE URL'),
      'text',                           // data type
      '',
      xl('URL of ASSE SOAP server. Must be blank if not a Uruguay site. Enter "test" for dummy data.')
    ),
    
    'gbl_uruguay_asse_token' => array(
      xl('Uruguay ASSE Token'),
      'text',                           // data type
      '',
      xl('Token for connection to ASSE SOAP server')
    ),

);
?>