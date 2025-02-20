--
-- Database: `openemr`
-- 

-- --------------------------------------------------------

-- 
-- Table structure for table `addresses`
-- 

DROP TABLE IF EXISTS `addresses`;
CREATE TABLE `addresses` (
  `id` int(11) NOT NULL default '0',
  `line1` varchar(255) default NULL,
  `line2` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(35) default NULL,
  `zip` varchar(10) default NULL,
  `plus_four` varchar(4) default NULL,
  `country` varchar(255) default NULL,
  `foreign_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `foreign_id` (`foreign_id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `amc_misc_data`
--

DROP TABLE IF EXISTS `amc_misc_data`;
CREATE TABLE `amc_misc_data` (
  `amc_id` varchar(31) NOT NULL DEFAULT '' COMMENT 'Unique and maps to list_options list clinical_rules',
  `pid` bigint(20) default NULL,
  `map_category` varchar(255) NOT NULL default '' COMMENT 'Maps to an object category (such as prescriptions etc.)',
  `map_id` bigint(20) NOT NULL default '0' COMMENT 'Maps to an object id (such as prescription id etc.)',
  `date_created` datetime default NULL,
  `date_completed` datetime default NULL,
  KEY  (`amc_id`,`pid`,`map_id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `array`
-- 

DROP TABLE IF EXISTS `array`;
CREATE TABLE `array` (
  `array_key` varchar(255) default NULL,
  `array_value` longtext
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `audit_master`
--

DROP TABLE IF EXISTS `audit_master`;
CREATE TABLE `audit_master` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `pid` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL COMMENT 'The Id of the user who approves or denies',
  `approval_status` tinyint(4) NOT NULL COMMENT '1-Pending,2-Approved,3-Denied,4-Appointment directly updated to calendar table,5-Cancelled appointment',
  `comments` text NOT NULL,
  `created_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_time` datetime NOT NULL,
  `ip_address` varchar(100) NOT NULL,
  `type` tinyint(4) NOT NULL COMMENT '1-new patient,2-existing patient,3-change is only in the document,4-Patient upload,5-random key,10-Appointment',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1;

--
-- Table structure for table `audit_details`
--

DROP TABLE IF EXISTS `audit_details`;
CREATE TABLE `audit_details` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `table_name` VARCHAR(100) NOT NULL COMMENT 'openemr table name',
  `field_name` VARCHAR(100) NOT NULL COMMENT 'openemr table''s field name',
  `field_value` TEXT NOT NULL COMMENT 'openemr table''s field value',
  `audit_master_id` BIGINT(20) NOT NULL COMMENT 'Id of the audit_master table',
  `entry_identification` VARCHAR(255) NOT NULL DEFAULT '1' COMMENT 'Used when multiple entry occurs from the same table.1 means no multiple entry',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1;

--
-- Table structure for table `background_services`
--

DROP TABLE IF EXISTS `background_services`;
CREATE TABLE `background_services` (
  `name` varchar(31) NOT NULL,
  `title` varchar(127) NOT NULL COMMENT 'name for reports',
  `active` tinyint(1) NOT NULL default '0',
  `running` tinyint(1) NOT NULL default '-1',
  `next_run` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `execute_interval` int(11) NOT NULL default '0' COMMENT 'minimum number of minutes between function calls,0=manual mode',
  `function` varchar(127) NOT NULL COMMENT 'name of background service function',
  `require_once` varchar(255) default NULL COMMENT 'include file (if necessary)',
  `sort_order` int(11) NOT NULL default '100' COMMENT 'lower numbers will be run first',
  PRIMARY KEY  (`name`)
) ENGINE=MyISAM;

-- 
-- Dumping data for table `background_services`
-- 

INSERT INTO `background_services` (`name`, `title`, `execute_interval`, `function`, `require_once`, `sort_order`) VALUES
('phimail', 'phiMail Direct Messaging Service', 5, 'phimail_check', '/library/direct_message_check.inc', 100);

-- --------------------------------------------------------

-- 
-- Table structure for table `batchcom`
-- 

DROP TABLE IF EXISTS `batchcom`;
CREATE TABLE `batchcom` (
  `id` bigint(20) NOT NULL auto_increment,
  `patient_id` int(11) NOT NULL default '0',
  `sent_by` bigint(20) NOT NULL default '0',
  `msg_type` varchar(60) default NULL,
  `msg_subject` varchar(255) default NULL,
  `msg_text` mediumtext,
  `msg_date_sent` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `billing`
-- 

DROP TABLE IF EXISTS `billing`;
CREATE TABLE `billing` (
  `id` int(11) NOT NULL auto_increment,
  `date` datetime default NULL,
  `code_type` varchar(15) default NULL,
  `code` varchar(20) default NULL,
  `pid` int(11) default NULL,
  `provider_id` int(11) default NULL,
  `user` int(11) default NULL,
  `groupname` varchar(255) default NULL,
  `authorized` tinyint(1) default NULL,
  `encounter` int(11) default NULL,
  `code_text` longtext,
  `billed` tinyint(1) default NULL,
  `activity` tinyint(1) default NULL,
  `payer_id` int(11) default NULL,
  `bill_process` tinyint(2) NOT NULL default '0',
  `bill_date` datetime default NULL,
  `process_date` datetime default NULL,
  `process_file` varchar(255) default NULL,
  `modifier` varchar(12) default NULL,
  `units` int(11) DEFAULT NULL,
  `fee` decimal(12,2) default NULL,
  `justify` varchar(255) default NULL,
  `target` varchar(30) default NULL,
  `x12_partner_id` int(11) default NULL,
  `ndc_info` varchar(255) default NULL,
  `notecodes` varchar(25) NOT NULL default '',
  `pricelevel` varchar(31) default '',
  `chargecat` varchar(31) default '',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `categories`
-- 

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(255) default NULL,
  `value` varchar(255) default NULL,
  `parent` int(11) NOT NULL default '0',
  `lft` int(11) NOT NULL default '0',
  `rght` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `parent` (`parent`),
  KEY `lft` (`lft`,`rght`)
) ENGINE=MyISAM;

-- 
-- Dumping data for table `categories`
-- 

INSERT INTO `categories` VALUES (1, 'Categories', '', 0, 0, 23);
INSERT INTO `categories` VALUES (2, 'Lab Report', '', 1, 1, 2);
INSERT INTO `categories` VALUES (3, 'Medical Record', '', 1, 3, 4);
INSERT INTO `categories` VALUES (4, 'Patient Information', '', 1, 5, 10);
INSERT INTO `categories` VALUES (5, 'Patient ID card', '', 4, 6, 7);
INSERT INTO `categories` VALUES (6, 'Advance Directive', '', 1, 11, 18);
INSERT INTO `categories` VALUES (7, 'Do Not Resuscitate Order', '', 6, 12, 13);
INSERT INTO `categories` VALUES (8, 'Durable Power of Attorney', '', 6, 14, 15);
INSERT INTO `categories` VALUES (9, 'Living Will', '', 6, 16, 17);
INSERT INTO `categories` VALUES (10, 'Patient Photograph', '', 4, 8, 9);
INSERT INTO `categories` VALUES (11, 'CCR', '', 1, 19, 20);
INSERT INTO `categories` VALUES (12, 'CCD', '', 1, 21, 22);

-- --------------------------------------------------------

-- 
-- Table structure for table `categories_seq`
-- 

DROP TABLE IF EXISTS `categories_seq`;
CREATE TABLE `categories_seq` (
  `id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

-- 
-- Dumping data for table `categories_seq`
-- 

INSERT INTO `categories_seq` VALUES (12);

-- --------------------------------------------------------

-- 
-- Table structure for table `categories_to_documents`
-- 

DROP TABLE IF EXISTS `categories_to_documents`;
CREATE TABLE `categories_to_documents` (
  `category_id` int(11) NOT NULL default '0',
  `document_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`category_id`,`document_id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `claims`
-- 

DROP TABLE IF EXISTS `claims`;
CREATE TABLE `claims` (
  `patient_id` int(11) NOT NULL,
  `encounter_id` int(11) NOT NULL,
  `version` int(10) unsigned NOT NULL auto_increment,
  `payer_id` int(11) NOT NULL default '0',
  `status` tinyint(2) NOT NULL default '0',
  `payer_type` tinyint(4) NOT NULL default '0',
  `bill_process` tinyint(2) NOT NULL default '0',
  `bill_time` datetime default NULL,
  `process_time` datetime default NULL,
  `process_file` varchar(255) default NULL,
  `target` varchar(30) default NULL,
  `x12_partner_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`patient_id`,`encounter_id`,`version`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `clinical_plans`
--

DROP TABLE IF EXISTS `clinical_plans`;
CREATE TABLE `clinical_plans` (
  `id` varchar(31) NOT NULL DEFAULT '' COMMENT 'Unique and maps to list_options list clinical_plans',
  `pid` bigint(20) NOT NULL DEFAULT '0' COMMENT '0 is default for all patients, while > 0 is id from patient_data table',
  `normal_flag` tinyint(1) COMMENT 'Normal Activation Flag',
  `cqm_flag` tinyint(1) COMMENT 'Clinical Quality Measure flag (unable to customize per patient)',
  `cqm_measure_group` varchar(10) NOT NULL default '' COMMENT 'Clinical Quality Measure Group Identifier',
  PRIMARY KEY  (`id`,`pid`)
) ENGINE=MyISAM ;

--
-- Clinical Quality Measure (CMQ) plans
--
-- Measure Group A: Diabetes Mellitus
INSERT INTO `clinical_plans` ( `id`, `pid`, `normal_flag`, `cqm_flag`, `cqm_measure_group` ) VALUES ('dm_plan_cqm', 0, 0, 1, 'A');
-- Measure Group C: Chronic Kidney Disease (CKD)
INSERT INTO `clinical_plans` ( `id`, `pid`, `normal_flag`, `cqm_flag`, `cqm_measure_group` ) VALUES ('ckd_plan_cqm', 0, 0, 1, 'C');
-- Measure Group D: Preventative Care
INSERT INTO `clinical_plans` ( `id`, `pid`, `normal_flag`, `cqm_flag`, `cqm_measure_group` ) VALUES ('prevent_plan_cqm', 0, 0, 1, 'D');
-- Measure Group E: Perioperative Care
INSERT INTO `clinical_plans` ( `id`, `pid`, `normal_flag`, `cqm_flag`, `cqm_measure_group` ) VALUES ('periop_plan_cqm', 0, 0, 1, 'E');
-- Measure Group F: Rheumatoid Arthritis
INSERT INTO `clinical_plans` ( `id`, `pid`, `normal_flag`, `cqm_flag`, `cqm_measure_group` ) VALUES ('rheum_arth_plan_cqm', 0, 0, 1, 'F');
-- Measure Group G: Back Pain
INSERT INTO `clinical_plans` ( `id`, `pid`, `normal_flag`, `cqm_flag`, `cqm_measure_group` ) VALUES ('back_pain_plan_cqm', 0, 0, 1, 'G');
-- Measure Group H: Coronary Artery Bypass Graft (CABG)
INSERT INTO `clinical_plans` ( `id`, `pid`, `normal_flag`, `cqm_flag`, `cqm_measure_group` ) VALUES ('cabg_plan_cqm', 0, 0, 1, 'H');
--
-- Standard clinical plans
--
-- Diabetes Mellitus
INSERT INTO `clinical_plans` ( `id`, `pid`, `normal_flag`, `cqm_flag`, `cqm_measure_group` ) VALUES ('dm_plan', 0, 1, 0, '');
INSERT INTO `clinical_plans` ( `id`, `pid`, `normal_flag`, `cqm_flag`, `cqm_measure_group` ) VALUES ('prevent_plan', 0, 1, 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `clinical_plans_rules`
--

DROP TABLE IF EXISTS `clinical_plans_rules`;
CREATE TABLE `clinical_plans_rules` (
  `plan_id` varchar(31) NOT NULL DEFAULT '' COMMENT 'Unique and maps to list_options list clinical_plans',
  `rule_id` varchar(31) NOT NULL DEFAULT '' COMMENT 'Unique and maps to list_options list clinical_rules',
  PRIMARY KEY  (`plan_id`,`rule_id`)
) ENGINE=MyISAM ;

--
-- Clinical Quality Measure (CMQ) plans to rules mappings
--
-- Measure Group A: Diabetes Mellitus
--   NQF 0059 (PQRI 1)   Diabetes: HbA1c Poor Control
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('dm_plan_cqm', 'rule_dm_a1c_cqm');
--   NQF 0064 (PQRI 2)   Diabetes: LDL Management & Control
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('dm_plan_cqm', 'rule_dm_ldl_cqm');
--   NQF 0061 (PQRI 3)   Diabetes: Blood Pressure Management
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('dm_plan_cqm', 'rule_dm_bp_control_cqm');
--   NQF 0055 (PQRI 117) Diabetes: Eye Exam
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('dm_plan_cqm', 'rule_dm_eye_cqm');
--   NQF 0056 (PQRI 163) Diabetes: Foot Exam
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('dm_plan_cqm', 'rule_dm_foot_cqm');
-- Measure Group D: Preventative Care
--   NQF 0041 (PQRI 110) Influenza Immunization for Patients >= 50 Years Old
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('prevent_plan_cqm', 'rule_influenza_ge_50_cqm');
--   NQF 0043 (PQRI 111) Pneumonia Vaccination Status for Older Adults
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('prevent_plan_cqm', 'rule_pneumovacc_ge_65_cqm');
--   NQF 0421 (PQRI 128) Adult Weight Screening and Follow-Up
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('prevent_plan_cqm', 'rule_adult_wt_screen_fu_cqm');
--
-- Standard clinical plans to rules mappings
--
-- Diabetes Mellitus
--   Hemoglobin A1C
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('dm_plan', 'rule_dm_hemo_a1c');
--   Urine Microalbumin
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('dm_plan', 'rule_dm_urine_alb');
--   Eye Exam
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('dm_plan', 'rule_dm_eye');
--   Foot Exam
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('dm_plan', 'rule_dm_foot');
-- Preventative Care
--   Hypertension: Blood Pressure Measurement
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('prevent_plan', 'rule_htn_bp_measure');
--   Tobacco Use Assessment
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('prevent_plan', 'rule_tob_use_assess');
--   Tobacco Cessation Intervention
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('prevent_plan', 'rule_tob_cess_inter');
--   Adult Weight Screening and Follow-Up
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('prevent_plan', 'rule_adult_wt_screen_fu');
--   Weight Assessment and Counseling for Children and Adolescents
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('prevent_plan', 'rule_wt_assess_couns_child');
--   Influenza Immunization for Patients >= 50 Years Old
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('prevent_plan', 'rule_influenza_ge_50');
--   Pneumonia Vaccination Status for Older Adults
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('prevent_plan', 'rule_pneumovacc_ge_65');
--   Cancer Screening: Mammogram
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('prevent_plan', 'rule_cs_mammo');
--   Cancer Screening: Pap Smear
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('prevent_plan', 'rule_cs_pap');
--   Cancer Screening: Colon Cancer Screening
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('prevent_plan', 'rule_cs_colon');
--   Cancer Screening: Prostate Cancer Screening
INSERT INTO `clinical_plans_rules` ( `plan_id`, `rule_id` ) VALUES ('prevent_plan', 'rule_cs_prostate');

-- --------------------------------------------------------

--
-- Table structure for table `clinical_rules`
--

DROP TABLE IF EXISTS `clinical_rules`;
CREATE TABLE `clinical_rules` (
  `id` varchar(31) NOT NULL DEFAULT '' COMMENT 'Unique and maps to list_options list clinical_rules',
  `pid` bigint(20) NOT NULL DEFAULT '0' COMMENT '0 is default for all patients, while > 0 is id from patient_data table',
  `active_alert_flag` tinyint(1) COMMENT 'Active Alert Widget Module flag - note not yet utilized',
  `passive_alert_flag` tinyint(1) COMMENT 'Passive Alert Widget Module flag',
  `cqm_flag` tinyint(1) COMMENT 'Clinical Quality Measure flag (unable to customize per patient)',
  `cqm_nqf_code` varchar(10) NOT NULL default '' COMMENT 'Clinical Quality Measure NQF identifier',
  `cqm_pqri_code` varchar(10) NOT NULL default '' COMMENT 'Clinical Quality Measure PQRI identifier',
  `amc_flag` tinyint(1) COMMENT 'Automated Measure Calculation flag (unable to customize per patient)',
  `amc_code` varchar(10) NOT NULL default '' COMMENT 'Automated Measure Calculation indentifier (MU rule)',
  `patient_reminder_flag` tinyint(1) COMMENT 'Clinical Reminder Module flag',
  PRIMARY KEY  (`id`,`pid`)
) ENGINE=MyISAM ;

--
-- Automated Measure Calculation (AMC) rules
--
-- MU 170.302(c) Maintain an up-to-date problem list of current and active diagnoses
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('problem_list_amc', 0, 0, 0, 0, '', '', 1, '170.302(c)', 0);
-- MU 170.302(d) Maintain active medication list
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('med_list_amc', 0, 0, 0, 0, '', '', 1, '170.302(d)', 0);
-- MU 170.302(e) Maintain active medication allergy list
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('med_allergy_list_amc', 0, 0, 0, 0, '', '', 1, '170.302(e)', 0);
-- MU 170.302(f) Record and chart changes in vital signs
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('record_vitals_amc', 0, 0, 0, 0, '', '', 1, '170.302(f)', 0);
-- MU 170.302(g) Record smoking status for patients 13 years old or older
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('record_smoke_amc', 0, 0, 0, 0, '', '', 1, '170.302(g)', 0);
-- MU 170.302(h) Incorporate clinical lab-test results into certified EHR technology as
--               structured data
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('lab_result_amc', 0, 0, 0, 0, '', '', 1, '170.302(h)', 0);
-- MU 170.302(j) The EP, eligible hospital or CAH who receives a patient from another
--               setting of care or provider of care or believes an encounter is relevant
--               should perform medication reconciliation
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('med_reconc_amc', 0, 0, 0, 0, '', '', 1, '170.302(j)', 0);
-- MU 170.302(m) Use certified EHR technology to identify patient-specific education resources
--              and provide those resources to the patient if appropriate
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('patient_edu_amc', 0, 0, 0, 0, '', '', 1, '170.302(m)', 0);
-- MU 170.304(a) Use CPOE for medication orders directly entered by any licensed healthcare
--              professional who can enter orders into the medical record per state, local
--              and professional guidelines
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('cpoe_med_amc', 0, 0, 0, 0, '', '', 1, '170.304(a)', 0);
-- MU 170.304(b) Generate and transmit permissible prescriptions electronically (eRx)
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('e_prescribe_amc', 0, 0, 0, 0, '', '', 1, '170.304(b)', 0);
-- MU 170.304(c) Record demographics
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('record_dem_amc', 0, 0, 0, 0, '', '', 1, '170.304(c)', 0);
-- MU 170.304(d) Send reminders to patients per patient preference for preventive/follow up care
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('send_reminder_amc', 0, 0, 0, 0, '', '', 1, '170.304(d)', 0);
-- MU 170.304(f) Provide patients with an electronic copy of their health information
--               (including diagnostic test results, problem list, medication lists,
--               medication allergies), upon request
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('provide_rec_pat_amc', 0, 0, 0, 0, '', '', 1, '170.304(f)', 0);
-- MU 170.304(g) Provide patients with timely electronic access to their health information
--              (including lab results, problem list, medication lists, medication allergies)
--              within four business days of the information being available to the EP
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('timely_access_amc', 0, 0, 0, 0, '', '', 1, '170.304(g)', 0);
-- MU 170.304(h) Provide clinical summaries for patients for each office visit
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('provide_sum_pat_amc', 0, 0, 0, 0, '', '', 1, '170.304(h)', 0);
-- MU 170.304(i) The EP, eligible hospital or CAH who transitions their patient to
--               another setting of care or provider of care or refers their patient to
--               another provider of care should provide summary of care record for
--               each transition of care or referral
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('send_sum_amc', 0, 0, 0, 0, '', '', 1, '170.304(i)', 0);
--
-- Clinical Quality Measure (CQM) rules
--
-- NQF 0013 Hypertension: Blood Pressure Measurement
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_htn_bp_measure_cqm', 0, 0, 0, 1, '0013', '', 0, '', 0);
-- NQF 0028a Tobacco Use Assessment
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_tob_use_assess_cqm', 0, 0, 0, 1, '0028a', '', 0, '', 0);
-- NQF 0028b Tobacco Cessation Intervention
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_tob_cess_inter_cqm', 0, 0, 0, 1, '0028b', '', 0, '', 0);
-- NQF 0421 (PQRI 128) Adult Weight Screening and Follow-Up
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_adult_wt_screen_fu_cqm', 0, 0, 0, 1, '0421', '128', 0, '', 0);
-- NQF 0024 Weight Assessment and Counseling for Children and Adolescents
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_wt_assess_couns_child_cqm', 0, 0, 0, 1, '0024', '', 0, '', 0);
-- NQF 0041 (PQRI 110) Influenza Immunization for Patients >= 50 Years Old
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_influenza_ge_50_cqm', 0, 0, 0, 1, '0041', '110', 0, '', 0);
-- NQF 0038 Childhood immunization Status
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_child_immun_stat_cqm', 0, 0, 0, 1, '0038', '', 0, '', 0);
-- NQF 0043 (PQRI 111) Pneumonia Vaccination Status for Older Adults
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_pneumovacc_ge_65_cqm', 0, 0, 0, 1, '0043', '111', 0, '', 0);
-- NQF 0055 (PQRI 117) Diabetes: Eye Exam
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_dm_eye_cqm', 0, 0, 0, 1, '0055', '117', 0, '', 0);
-- NQF 0056 (PQRI 163) Diabetes: Foot Exam
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_dm_foot_cqm', 0, 0, 0, 1, '0056', '163', 0, '', 0);
-- NQF 0059 (PQRI 1) Diabetes: HbA1c Poor Control
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_dm_a1c_cqm', 0, 0, 0, 1, '0059', '1', 0, '', 0);
-- NQF 0061 (PQRI 3) Diabetes: Blood Pressure Management
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_dm_bp_control_cqm', 0, 0, 0, 1, '0061', '3', 0, '', 0);
-- NQF 0064 (PQRI 2) Diabetes: LDL Management & Control
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_dm_ldl_cqm', 0, 0, 0, 1, '0064', '2', 0, '', 0);
--
-- Standard clinical rules
--
-- Hypertension: Blood Pressure Measurement
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_htn_bp_measure', 0, 0, 1, 0, '', '', 0, '', 0);
-- Tobacco Use Assessment
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_tob_use_assess', 0, 0, 1, 0, '', '', 0, '', 0);
-- Tobacco Cessation Intervention
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_tob_cess_inter', 0, 0, 1, 0, '', '', 0, '', 0);
-- Adult Weight Screening and Follow-Up
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_adult_wt_screen_fu', 0, 0, 1, 0, '', '', 0, '', 0);
-- Weight Assessment and Counseling for Children and Adolescents
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_wt_assess_couns_child', 0, 0, 1, 0, '', '', 0, '', 0);
-- Influenza Immunization for Patients >= 50 Years Old
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_influenza_ge_50', 0, 0, 1, 0, '', '', 0, '', 0);
-- Pneumonia Vaccination Status for Older Adults
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_pneumovacc_ge_65', 0, 0, 1, 0, '', '', 0, '', 0);
-- Diabetes: Hemoglobin A1C
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_dm_hemo_a1c', 0, 0, 1, 0, '', '', 0, '', 0);
-- Diabetes: Urine Microalbumin
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_dm_urine_alb', 0, 0, 1, 0, '', '', 0, '', 0);
-- Diabetes: Eye Exam
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_dm_eye', 0, 0, 1, 0, '', '', 0, '', 0);
-- Diabetes: Foot Exam
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_dm_foot', 0, 0, 1, 0, '', '', 0, '', 0);
-- Cancer Screening: Mammogram
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_cs_mammo', 0, 0, 1, 0, '', '', 0, '', 0);
-- Cancer Screening: Pap Smear
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_cs_pap', 0, 0, 1, 0, '', '', 0, '', 0);
-- Cancer Screening: Colon Cancer Screening
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_cs_colon', 0, 0, 1, 0, '', '', 0, '', 0);
-- Cancer Screening: Prostate Cancer Screening
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_cs_prostate', 0, 0, 1, 0, '', '', 0, '', 0);
--
-- Rules to specifically demonstrate passing of NIST criteria
--
-- Coumadin Management - INR Monitoring
INSERT INTO `clinical_rules` ( `id`, `pid`, `active_alert_flag`, `passive_alert_flag`, `cqm_flag`, `cqm_nqf_code`, `cqm_pqri_code`, `amc_flag`, `amc_code`, `patient_reminder_flag` ) VALUES ('rule_inr_monitor', 0, 0, 1, 0, '', '', 0, '', 0);

-- --------------------------------------------------------

-- 
-- Table structure for table `codes`
-- 

DROP TABLE IF EXISTS `codes`;
CREATE TABLE `codes` (
  `id` int(11) NOT NULL auto_increment,
  `code_text` varchar(255) NOT NULL default '',
  `code_text_short` varchar(24) NOT NULL default '',
  `code` varchar(31) NOT NULL default '',
  `code_type` smallint(6) default NULL,
  `modifier` varchar(12) NOT NULL default '',
  `units` tinyint(3) default NULL,
  `fee` decimal(12,2) default NULL,
  `superbill` varchar(31) NOT NULL default '',
  `related_code` varchar(255) NOT NULL default '',
  `taxrates` varchar(255) NOT NULL default '',
  `cyp_factor` float NOT NULL DEFAULT 0 COMMENT 'quantity representing a years supply',
  `active` TINYINT(1) DEFAULT 1 COMMENT '0 = inactive, 1 = active',
  `reportable` TINYINT(1) DEFAULT 0 COMMENT '0 = non-reportable, 1 = reportable',
  `financial_reporting` TINYINT(1) DEFAULT 0 COMMENT '0 = negative, 1 = considered important code in financial reporting',
  `sex` TINYINT(1) DEFAULT 4 COMMENT '4 = All, 1 = Women Only, 2 = Men Only, 3 = Other Only',
  PRIMARY KEY  (`id`),
  KEY `code` (`code`),
  KEY `code_type` (`code_type`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;
-- --------------------------------------------------------

-- 
-- Table structure for table `syndromic_surveillance`
-- 

DROP TABLE IF EXISTS `syndromic_surveillance`;
CREATE TABLE `syndromic_surveillance` (
  `id` bigint(20) NOT NULL auto_increment,
  `lists_id` bigint(20) NOT NULL,
  `submission_date` datetime NOT NULL,
  `filename` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY (`lists_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `config`
-- 

DROP TABLE IF EXISTS `config`;
CREATE TABLE `config` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(255) default NULL,
  `value` varchar(255) default NULL,
  `parent` int(11) NOT NULL default '0',
  `lft` int(11) NOT NULL default '0',
  `rght` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `parent` (`parent`),
  KEY `lft` (`lft`,`rght`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `config_seq`
-- 

DROP TABLE IF EXISTS `config_seq`;
CREATE TABLE `config_seq` (
  `id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

-- 
-- Dumping data for table `config_seq`
-- 

INSERT INTO `config_seq` VALUES (0);

-- --------------------------------------------------------

--
-- Table structure for table `dated_reminders`
--

DROP TABLE IF EXISTS `dated_reminders`;
CREATE TABLE `dated_reminders` (
  `dr_id` int(11) NOT NULL AUTO_INCREMENT,
  `dr_from_ID` int(11) NOT NULL,
  `dr_message_text` varchar(160) NOT NULL,
  `dr_message_sent_date` datetime NOT NULL,
  `dr_message_due_date` date NOT NULL,
  `pid` int(11) NOT NULL,
  `message_priority` tinyint(1) NOT NULL,
  `message_processed` tinyint(1) NOT NULL DEFAULT '0',
  `processed_date` timestamp NULL DEFAULT NULL,
  `dr_processed_by` int(11) NOT NULL,
  PRIMARY KEY (`dr_id`),
  KEY `dr_from_ID` (`dr_from_ID`,`dr_message_due_date`)
) ENGINE=MyISAM AUTO_INCREMENT=1;

-- --------------------------------------------------------

--
-- Table structure for table `dated_reminders_link`
--

DROP TABLE IF EXISTS `dated_reminders_link`;
CREATE TABLE `dated_reminders_link` (           
  `dr_link_id` int(11) NOT NULL AUTO_INCREMENT,
  `dr_id` int(11) NOT NULL,
  `to_id` int(11) NOT NULL,
  PRIMARY KEY (`dr_link_id`),
  KEY `to_id` (`to_id`),
  KEY `dr_id` (`dr_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1;

-- --------------------------------------------------------

-- 
-- Table structure for table `direct_message_log`
-- 

DROP TABLE IF EXISTS `direct_message_log`;
CREATE TABLE `direct_message_log` (
  `id` bigint(20) NOT NULL auto_increment,
  `msg_type` char(1) NOT NULL COMMENT 'S=sent,R=received',
  `msg_id` varchar(127) NOT NULL,
  `sender` varchar(255) NOT NULL,
  `recipient` varchar(255) NOT NULL,
  `create_ts` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `status` char(1) NOT NULL COMMENT 'Q=queued,D=dispatched,R=received,F=failed',
  `status_info` varchar(511) default NULL,
  `status_ts` timestamp NULL default NULL,
  `patient_id` bigint(20) default NULL,
  `user_id` bigint(20) default NULL,
  PRIMARY KEY  (`id`),
  KEY `msg_id` (`msg_id`),
  KEY `patient_id` (`patient_id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `documents`
-- 

DROP TABLE IF EXISTS `documents`;
CREATE TABLE `documents` (
  `id` int(11) NOT NULL default '0',
  `type` enum('file_url','blob','web_url') default NULL,
  `size` int(11) default NULL,
  `date` datetime default NULL,
  `url` varchar(255) default NULL,
  `mimetype` varchar(255) default NULL,
  `pages` int(11) default NULL,
  `owner` int(11) default NULL,
  `revision` timestamp NOT NULL,
  `foreign_id` int(11) default NULL,
  `docdate` date default NULL,
  `hash` varchar(40) DEFAULT NULL COMMENT '40-character SHA-1 hash of document',
  `list_id` bigint(20) NOT NULL default '0',
  `couch_docid` VARCHAR(100) DEFAULT NULL,
  `couch_revid` VARCHAR(100) DEFAULT NULL,
  `storagemethod` TINYINT(4) NOT NULL DEFAULT '0' COMMENT '0->Harddisk,1->CouchDB',
  `path_depth` TINYINT DEFAULT '1' COMMENT 'Depth of path to use in url to find document. Not applicable for CouchDB.',
  `imported` TINYINT DEFAULT 0 NULL COMMENT 'Parsing status for CCR/CCD/CCDA importing',
  PRIMARY KEY  (`id`),
  KEY `revision` (`revision`),
  KEY `foreign_id` (`foreign_id`),
  KEY `owner` (`owner`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `documents_legal_detail`
--

DROP TABLE IF EXISTS `documents_legal_detail`;
CREATE TABLE `documents_legal_detail` (
  `dld_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dld_pid` int(10) unsigned DEFAULT NULL,
  `dld_facility` int(10) unsigned DEFAULT NULL,
  `dld_provider` int(10) unsigned DEFAULT NULL,
  `dld_encounter` int(10) unsigned DEFAULT NULL,
  `dld_master_docid` int(10) unsigned NOT NULL,
  `dld_signed` smallint(5) unsigned NOT NULL COMMENT '0-Not Signed or Cannot Sign(Layout),1-Signed,2-Ready to sign,3-Denied(Pat Regi),4-Patient Upload,10-Save(Layout)',
  `dld_signed_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `dld_filepath` varchar(75) DEFAULT NULL,
  `dld_filename` varchar(45) NOT NULL,
  `dld_signing_person` varchar(50) NOT NULL,
  `dld_sign_level` int(11) NOT NULL COMMENT 'Sign flow level',
  `dld_content` varchar(50) NOT NULL COMMENT 'Layout sign position',
  `dld_file_for_pdf_generation` blob NOT NULL COMMENT 'The filled details in the fdf file is stored here.Patient Registration Screen',
  `dld_denial_reason` longtext NOT NULL,
  `dld_moved` tinyint(4) NOT NULL DEFAULT '0',
  `dld_patient_comments` text COMMENT 'Patient comments stored here',
  PRIMARY KEY (`dld_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `documents_legal_master`
--

DROP TABLE IF EXISTS `documents_legal_master`;
CREATE TABLE `documents_legal_master` (
  `dlm_category` int(10) unsigned DEFAULT NULL,
  `dlm_subcategory` int(10) unsigned DEFAULT NULL,
  `dlm_document_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dlm_document_name` varchar(75) NOT NULL,
  `dlm_filepath` varchar(75) NOT NULL,
  `dlm_facility` int(10) unsigned DEFAULT NULL,
  `dlm_provider` int(10) unsigned DEFAULT NULL,
  `dlm_sign_height` double NOT NULL,
  `dlm_sign_width` double NOT NULL,
  `dlm_filename` varchar(45) NOT NULL,
  `dlm_effective_date` datetime NOT NULL,
  `dlm_version` int(10) unsigned NOT NULL,
  `content` varchar(255) NOT NULL,
  `dlm_savedsign` varchar(255) DEFAULT NULL COMMENT '0-Yes 1-No',
  `dlm_review` varchar(255) DEFAULT NULL COMMENT '0-Yes 1-No',
  `dlm_upload_type` tinyint(4) DEFAULT '0' COMMENT '0-Provider Uploaded,1-Patient Uploaded',
  PRIMARY KEY (`dlm_document_id`)
) ENGINE=MyISAM COMMENT='List of Master Docs to be signed' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `documents_legal_categories`
--

DROP TABLE IF EXISTS `documents_legal_categories`;
CREATE TABLE `documents_legal_categories` (
  `dlc_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dlc_category_type` int(10) unsigned NOT NULL COMMENT '1 category 2 subcategory',
  `dlc_category_name` varchar(45) NOT NULL,
  `dlc_category_parent` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`dlc_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 ;

--
-- Dumping data for table `documents_legal_categories`
--

INSERT INTO `documents_legal_categories` (`dlc_id`, `dlc_category_type`, `dlc_category_name`, `dlc_category_parent`) VALUES
(3, 1, 'Category', NULL),
(4, 2, 'Sub Category', 1),
(5, 1, 'Layout Form', 0),
(6, 2, 'Layout Signed', 5);

-- 
-- Table structure for table `drug_inventory`
-- 

DROP TABLE IF EXISTS `drug_inventory`;
CREATE TABLE `drug_inventory` (
  `inventory_id` int(11) NOT NULL auto_increment,
  `drug_id` int(11) NOT NULL,
  `lot_number` varchar(20) default NULL,
  `expiration` date default NULL,
  `manufacturer` varchar(255) default NULL,
  `on_hand` int(11) NOT NULL default '0',
  `warehouse_id` varchar(31) NOT NULL DEFAULT '',
  `vendor_id` bigint(20) NOT NULL DEFAULT 0,
  `last_notify` date default NULL,
  `destroy_date` date default NULL,
  `destroy_method` varchar(255) default NULL,
  `destroy_witness` varchar(255) default NULL,
  `destroy_notes` varchar(255) default NULL,
  PRIMARY KEY  (`inventory_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `drug_sales`
-- 

DROP TABLE IF EXISTS `drug_sales`;
CREATE TABLE `drug_sales` (
  `sale_id` int(11) NOT NULL auto_increment,
  `drug_id` int(11) NOT NULL,
  `inventory_id` int(11) NOT NULL,
  `prescription_id` int(11) NOT NULL default '0',
  `pid` int(11) NOT NULL default '0',
  `encounter` int(11) NOT NULL default '0',
  `user` varchar(255) default NULL,
  `sale_date` date NOT NULL,
  `quantity` int(11) NOT NULL default '0',
  `fee` decimal(12,2) NOT NULL default '0.00',
  `billed` tinyint(1) NOT NULL default '0' COMMENT 'indicates if the sale is posted to accounting',
  `xfer_inventory_id` int(11) NOT NULL DEFAULT 0,
  `distributor_id` bigint(20) NOT NULL DEFAULT 0 COMMENT 'references users.id',
  `notes` varchar(255) NOT NULL DEFAULT '',
  `bill_date` datetime default NULL,
  `pricelevel` varchar(31) default '',
  `selector` varchar(255) default '' comment 'references drug_templates.selector',
  `trans_type` tinyint NOT NULL DEFAULT 1 COMMENT '1=sale, 2=purchase, 3=return, 4=transfer, 5=adjustment',
  `chargecat` varchar(31) default '',
  PRIMARY KEY  (`sale_id`),
  KEY `sale_date` (`sale_date`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `drug_templates`
-- 

DROP TABLE IF EXISTS `drug_templates`;
CREATE TABLE `drug_templates` (
  `drug_id` int(11) NOT NULL,
  `selector` varchar(255) NOT NULL default '',
  `dosage` varchar(10) default NULL,
  `period` int(11) NOT NULL default '0',
  `quantity` int(11) NOT NULL default '0',
  `refills` int(11) NOT NULL default '0',
  `taxrates` varchar(255) default NULL,
  `pkgqty` float NOT NULL DEFAULT 1.0 COMMENT 'Number of product items per template item',
  PRIMARY KEY  (`drug_id`,`selector`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `drugs`
-- 

DROP TABLE IF EXISTS `drugs`;
CREATE TABLE `drugs` (
  `drug_id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL DEFAULT '',
  `ndc_number` varchar(20) NOT NULL DEFAULT '',
  `on_order` int(11) NOT NULL default '0',
  `reorder_point` float NOT NULL DEFAULT 0.0,
  `max_level` float NOT NULL DEFAULT 0.0,
  `last_notify` date default NULL,
  `reactions` text,
  `form` varchar(31) NOT NULL default '0',
  `size` float unsigned NOT NULL default '0',
  `unit` varchar(31) NOT NULL default '0',
  `route` varchar(31) NOT NULL default '0',
  `substitute` int(11) NOT NULL default '0',
  `related_code` varchar(255) NOT NULL DEFAULT '' COMMENT 'may reference a related codes.code',
  `cyp_factor` float NOT NULL DEFAULT 0 COMMENT 'quantity representing a years supply',
  `active` TINYINT(1) DEFAULT 1 COMMENT '0 = inactive, 1 = active',
  `allow_combining` tinyint(1) NOT NULL DEFAULT 0 COMMENT '1 = allow filling an order from multiple lots',
  `allow_multiple`  tinyint(1) NOT NULL DEFAULT 1 COMMENT '1 = allow multiple lots at one warehouse',
  `dispensable` tinyint(1) NOT NULL DEFAULT 1 COMMENT '0 = pharmacy elsewhere, 1 = dispensed here',
  PRIMARY KEY  (`drug_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `eligibility_response`
--

DROP TABLE IF EXISTS `eligibility_response`;
CREATE TABLE `eligibility_response` (
  `response_id` bigint(20) NOT NULL auto_increment,
  `response_description` varchar(255) default NULL,
  `response_status` enum('A','D') NOT NULL default 'A',
  `response_vendor_id` bigint(20) default NULL,
  `response_create_date` date default NULL,
  `response_modify_date` date default NULL,
  PRIMARY KEY  (`response_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1;

-- --------------------------------------------------------

--
-- Table structure for table `eligibility_verification`
--

DROP TABLE IF EXISTS `eligibility_verification`;
CREATE TABLE `eligibility_verification` (
  `verification_id` bigint(20) NOT NULL auto_increment,
  `response_id` bigint(20) default NULL,
  `insurance_id` bigint(20) default NULL,
  `eligibility_check_date` datetime default NULL,
  `copay` int(11) default NULL,
  `deductible` int(11) default NULL,
  `deductiblemet` enum('Y','N') default 'Y',
  `create_date` date default NULL,
  PRIMARY KEY  (`verification_id`),
  KEY `insurance_id` (`insurance_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1;

-- --------------------------------------------------------

-- 
-- Table structure for table `employer_data`
-- 

DROP TABLE IF EXISTS `employer_data`;
CREATE TABLE `employer_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `street` varchar(255) default NULL,
  `postal_code` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `country` varchar(255) default NULL,
  `date` datetime default NULL,
  `pid` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `enc_category_map`
--
-- Mapping of rule encounter categories to category ids from the event category in openemr_postcalendar_categories
--

DROP TABLE IF EXISTS `enc_category_map`;
CREATE TABLE `enc_category_map` (
  `rule_enc_id` varchar(31) NOT NULL DEFAULT '' COMMENT 'encounter id from rule_enc_types list in list_options',
  `main_cat_id` int(11) NOT NULL DEFAULT 0 COMMENT 'category id from event category in openemr_postcalendar_categories',
  KEY  (`rule_enc_id`,`main_cat_id`)
) ENGINE=MyISAM ;

INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_outpatient', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_outpatient', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_outpatient', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_nurs_fac', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_nurs_fac', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_nurs_fac', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_off_vis', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_off_vis', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_off_vis', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_hea_and_beh', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_hea_and_beh', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_hea_and_beh', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_occ_ther', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_occ_ther', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_occ_ther', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_psych_and_psych', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_psych_and_psych', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_psych_and_psych', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_ser_18_older', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_ser_18_older', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_ser_18_older', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_ser_40_older', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_ser_40_older', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_ser_40_older', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_ind_counsel', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_ind_counsel', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_ind_counsel', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_group_counsel', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_group_counsel', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_group_counsel', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_other_serv', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_other_serv', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pre_med_other_serv', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_out_pcp_obgyn', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_out_pcp_obgyn', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_out_pcp_obgyn', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pregnancy', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pregnancy', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_pregnancy', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_nurs_discharge', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_nurs_discharge', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_nurs_discharge', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_acute_inp_or_ed', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_acute_inp_or_ed', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_acute_inp_or_ed', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_nonac_inp_out_or_opth', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_nonac_inp_out_or_opth', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_nonac_inp_out_or_opth', 10);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_influenza', 5);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_influenza', 9);
INSERT INTO `enc_category_map` ( `rule_enc_id`, `main_cat_id` ) VALUES ('enc_influenza', 10);

-- --------------------------------------------------------

--
-- Table structure for table `erx_ttl_touch`
--
-- Store records last update per patient data process
--

DROP TABLE IF EXISTS `erx_ttl_touch`;
CREATE  TABLE `erx_ttl_touch` (
  `patient_id` BIGINT(20) UNSIGNED NOT NULL COMMENT 'Patient record Id' ,
  `process` ENUM('allergies','medications') NOT NULL COMMENT 'NewCrop eRx SOAP process' ,
  `updated` DATETIME NOT NULL COMMENT 'Date and time of last process update for patient' ,
  PRIMARY KEY (`patient_id`, `process`)
) ENGINE = InnoDB COMMENT = 'Store records last update per patient data process' ;

-- --------------------------------------------------------

--
-- Table structure for table `standardized_tables_track`
--

DROP TABLE IF EXISTS `standardized_tables_track`;
CREATE TABLE `standardized_tables_track` (
  `id` int(11) NOT NULL auto_increment,
  `imported_date` datetime default NULL,
  `name` varchar(255) NOT NULL default '' COMMENT 'name of standardized tables such as RXNORM',
  `revision_version` varchar(255) NOT NULL default '' COMMENT 'revision of standardized tables that were imported',
  `revision_date` datetime default NULL COMMENT 'revision of standardized tables that were imported',
  `file_checksum` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `facility`
-- 

DROP TABLE IF EXISTS `facility`;
CREATE TABLE `facility` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `phone` varchar(30) default NULL,
  `fax` varchar(30) default NULL,
  `street` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(50) default NULL,
  `postal_code` varchar(11) default NULL,
  `country_code` varchar(10) default NULL,
  `federal_ein` varchar(15) default NULL,
  `website` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `service_location` tinyint(1) NOT NULL default '1',
  `billing_location` tinyint(1) NOT NULL default '0',
  `accepts_assignment` tinyint(1) NOT NULL default '0',
  `pos_code` tinyint(4) default NULL,
  `x12_sender_id` varchar(25) default NULL,
  `attn` varchar(65) default NULL,
  `domain_identifier` varchar(60) default NULL,
  `facility_npi` varchar(50) NOT NULL DEFAULT '',
  `tax_id_type` VARCHAR(31) NOT NULL DEFAULT '',
  `color` VARCHAR(7) NOT NULL DEFAULT '',
  `primary_business_entity` INT(10) NOT NULL DEFAULT '0' COMMENT '0-Not Set as business entity 1-Set as business entity',
  `latitude` varchar(255) NOT NULL DEFAULT '',
  `longitude` varchar(255) NOT NULL DEFAULT '',
  `extra_validation` tinyint(1) NOT NULL DEFAULT '1',
  `related_code` VARCHAR(255) NOT NULL default '',
  `related_code_2` VARCHAR(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 ;

-- 
-- Dumping data for table `facility`
-- 

INSERT INTO `facility` VALUES (3, 'Your Clinic Name Here', '000-000-0000', '000-000-0000', '', '', '', '', '', '', NULL, NULL, 1, 1, 0, NULL, '', '', '', '', '','#99FFFF','0','');


-- --------------------------------------------------------

-- 
-- Table structure for table `facility_user_ids`
-- 

DROP TABLE IF EXISTS `facility_user_ids`;
CREATE TABLE  `facility_user_ids` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) DEFAULT NULL,
  `facility_id` bigint(20) DEFAULT NULL,
  `field_id`    varchar(31)  NOT NULL COMMENT 'references layout_options.field_id',
  `field_value` TEXT NOT NULL,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`,`facility_id`,`field_id`)
) ENGINE=MyISAM  AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `fee_sheet_options`
-- 

DROP TABLE IF EXISTS `fee_sheet_options`;
CREATE TABLE `fee_sheet_options` (
  `fs_category` varchar(63) default NULL,
  `fs_option` varchar(63) default NULL,
  `fs_codes` varchar(255) default NULL
) ENGINE=MyISAM;

-- 
-- Dumping data for table `fee_sheet_options`
-- 

INSERT INTO `fee_sheet_options` VALUES ('1New Patient', '1Brief', 'CPT4|99201|');
INSERT INTO `fee_sheet_options` VALUES ('1New Patient', '2Limited', 'CPT4|99202|');
INSERT INTO `fee_sheet_options` VALUES ('1New Patient', '3Detailed', 'CPT4|99203|');
INSERT INTO `fee_sheet_options` VALUES ('1New Patient', '4Extended', 'CPT4|99204|');
INSERT INTO `fee_sheet_options` VALUES ('1New Patient', '5Comprehensive', 'CPT4|99205|');
INSERT INTO `fee_sheet_options` VALUES ('2Established Patient', '1Brief', 'CPT4|99211|');
INSERT INTO `fee_sheet_options` VALUES ('2Established Patient', '2Limited', 'CPT4|99212|');
INSERT INTO `fee_sheet_options` VALUES ('2Established Patient', '3Detailed', 'CPT4|99213|');
INSERT INTO `fee_sheet_options` VALUES ('2Established Patient', '4Extended', 'CPT4|99214|');
INSERT INTO `fee_sheet_options` VALUES ('2Established Patient', '5Comprehensive', 'CPT4|99215|');

-- --------------------------------------------------------

-- 
-- Table structure for table `form_dictation`
-- 

DROP TABLE IF EXISTS `form_dictation`;
CREATE TABLE `form_dictation` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `pid` bigint(20) default NULL,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `authorized` tinyint(4) default NULL,
  `activity` tinyint(4) default NULL,
  `dictation` longtext,
  `additional_notes` longtext,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_encounter`
-- 

DROP TABLE IF EXISTS `form_encounter`;
CREATE TABLE `form_encounter` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `reason` longtext,
  `facility` longtext,
  `facility_id` int(11) NOT NULL default '0',
  `pid` bigint(20) default NULL,
  `encounter` bigint(20) default NULL,
  `onset_date` datetime default NULL,
  `sensitivity` varchar(30) default NULL,
  `billing_note` text,
  `pc_catid` int(11) NOT NULL default '5' COMMENT 'event category from openemr_postcalendar_categories',
  `last_level_billed` int  NOT NULL DEFAULT 0 COMMENT '0=none, 1=ins1, 2=ins2, etc',
  `last_level_closed` int  NOT NULL DEFAULT 0 COMMENT '0=none, 1=ins1, 2=ins2, etc',
  `last_stmt_date`    date DEFAULT NULL,
  `stmt_count`        int  NOT NULL DEFAULT 0,
  `provider_id` INT(11) DEFAULT '0' COMMENT 'default and main provider for this visit',
  `supervisor_id` INT(11) DEFAULT '0' COMMENT 'supervising provider, if any, for this visit',
  `invoice_refno` varchar(31) NOT NULL DEFAULT '',
  `referral_source` varchar(31) NOT NULL DEFAULT '',
  `billing_facility` INT(11) NOT NULL DEFAULT 0,
  `shift` varchar(31) NOT NULL DEFAULT '',
  `voucher_number` varchar(255) NOT NULL DEFAULT '' COMMENT 'also called referral number',
  PRIMARY KEY  (`id`),
  KEY `pid_encounter` (`pid`, `encounter`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_misc_billing_options`
-- 

DROP TABLE IF EXISTS `form_misc_billing_options`;
CREATE TABLE `form_misc_billing_options` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `pid` bigint(20) default NULL,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `authorized` tinyint(4) default NULL,
  `activity` tinyint(4) default NULL,
  `employment_related` tinyint(1) default NULL,
  `auto_accident` tinyint(1) default NULL,
  `accident_state` varchar(2) default NULL,
  `other_accident` tinyint(1) default NULL,
  `outside_lab` tinyint(1) default NULL,
  `lab_amount` decimal(5,2) default NULL,
  `is_unable_to_work` tinyint(1) default NULL,
  `date_initial_treatment` date default NULL,
  `off_work_from` date default NULL,
  `off_work_to` date default NULL,
  `is_hospitalized` tinyint(1) default NULL,
  `hospitalization_date_from` date default NULL,
  `hospitalization_date_to` date default NULL,
  `medicaid_resubmission_code` varchar(10) default NULL,
  `medicaid_original_reference` varchar(15) default NULL,
  `prior_auth_number` varchar(20) default NULL,
  `comments` varchar(255) default NULL,
  `replacement_claim` tinyint(1) default 0,
  `box_14_date_qual` char(3) default NULL,
  `box_15_date_qual` char(3) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_reviewofs`
-- 

DROP TABLE IF EXISTS `form_reviewofs`;
CREATE TABLE `form_reviewofs` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `pid` bigint(20) default NULL,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `authorized` tinyint(4) default NULL,
  `activity` tinyint(4) default NULL,
  `fever` varchar(5) default NULL,
  `chills` varchar(5) default NULL,
  `night_sweats` varchar(5) default NULL,
  `weight_loss` varchar(5) default NULL,
  `poor_appetite` varchar(5) default NULL,
  `insomnia` varchar(5) default NULL,
  `fatigued` varchar(5) default NULL,
  `depressed` varchar(5) default NULL,
  `hyperactive` varchar(5) default NULL,
  `exposure_to_foreign_countries` varchar(5) default NULL,
  `cataracts` varchar(5) default NULL,
  `cataract_surgery` varchar(5) default NULL,
  `glaucoma` varchar(5) default NULL,
  `double_vision` varchar(5) default NULL,
  `blurred_vision` varchar(5) default NULL,
  `poor_hearing` varchar(5) default NULL,
  `headaches` varchar(5) default NULL,
  `ringing_in_ears` varchar(5) default NULL,
  `bloody_nose` varchar(5) default NULL,
  `sinusitis` varchar(5) default NULL,
  `sinus_surgery` varchar(5) default NULL,
  `dry_mouth` varchar(5) default NULL,
  `strep_throat` varchar(5) default NULL,
  `tonsillectomy` varchar(5) default NULL,
  `swollen_lymph_nodes` varchar(5) default NULL,
  `throat_cancer` varchar(5) default NULL,
  `throat_cancer_surgery` varchar(5) default NULL,
  `heart_attack` varchar(5) default NULL,
  `irregular_heart_beat` varchar(5) default NULL,
  `chest_pains` varchar(5) default NULL,
  `shortness_of_breath` varchar(5) default NULL,
  `high_blood_pressure` varchar(5) default NULL,
  `heart_failure` varchar(5) default NULL,
  `poor_circulation` varchar(5) default NULL,
  `vascular_surgery` varchar(5) default NULL,
  `cardiac_catheterization` varchar(5) default NULL,
  `coronary_artery_bypass` varchar(5) default NULL,
  `heart_transplant` varchar(5) default NULL,
  `stress_test` varchar(5) default NULL,
  `emphysema` varchar(5) default NULL,
  `chronic_bronchitis` varchar(5) default NULL,
  `interstitial_lung_disease` varchar(5) default NULL,
  `shortness_of_breath_2` varchar(5) default NULL,
  `lung_cancer` varchar(5) default NULL,
  `lung_cancer_surgery` varchar(5) default NULL,
  `pheumothorax` varchar(5) default NULL,
  `stomach_pains` varchar(5) default NULL,
  `peptic_ulcer_disease` varchar(5) default NULL,
  `gastritis` varchar(5) default NULL,
  `endoscopy` varchar(5) default NULL,
  `polyps` varchar(5) default NULL,
  `colonoscopy` varchar(5) default NULL,
  `colon_cancer` varchar(5) default NULL,
  `colon_cancer_surgery` varchar(5) default NULL,
  `ulcerative_colitis` varchar(5) default NULL,
  `crohns_disease` varchar(5) default NULL,
  `appendectomy` varchar(5) default NULL,
  `divirticulitis` varchar(5) default NULL,
  `divirticulitis_surgery` varchar(5) default NULL,
  `gall_stones` varchar(5) default NULL,
  `cholecystectomy` varchar(5) default NULL,
  `hepatitis` varchar(5) default NULL,
  `cirrhosis_of_the_liver` varchar(5) default NULL,
  `splenectomy` varchar(5) default NULL,
  `kidney_failure` varchar(5) default NULL,
  `kidney_stones` varchar(5) default NULL,
  `kidney_cancer` varchar(5) default NULL,
  `kidney_infections` varchar(5) default NULL,
  `bladder_infections` varchar(5) default NULL,
  `bladder_cancer` varchar(5) default NULL,
  `prostate_problems` varchar(5) default NULL,
  `prostate_cancer` varchar(5) default NULL,
  `kidney_transplant` varchar(5) default NULL,
  `sexually_transmitted_disease` varchar(5) default NULL,
  `burning_with_urination` varchar(5) default NULL,
  `discharge_from_urethra` varchar(5) default NULL,
  `rashes` varchar(5) default NULL,
  `infections` varchar(5) default NULL,
  `ulcerations` varchar(5) default NULL,
  `pemphigus` varchar(5) default NULL,
  `herpes` varchar(5) default NULL,
  `osetoarthritis` varchar(5) default NULL,
  `rheumotoid_arthritis` varchar(5) default NULL,
  `lupus` varchar(5) default NULL,
  `ankylosing_sondlilitis` varchar(5) default NULL,
  `swollen_joints` varchar(5) default NULL,
  `stiff_joints` varchar(5) default NULL,
  `broken_bones` varchar(5) default NULL,
  `neck_problems` varchar(5) default NULL,
  `back_problems` varchar(5) default NULL,
  `back_surgery` varchar(5) default NULL,
  `scoliosis` varchar(5) default NULL,
  `herniated_disc` varchar(5) default NULL,
  `shoulder_problems` varchar(5) default NULL,
  `elbow_problems` varchar(5) default NULL,
  `wrist_problems` varchar(5) default NULL,
  `hand_problems` varchar(5) default NULL,
  `hip_problems` varchar(5) default NULL,
  `knee_problems` varchar(5) default NULL,
  `ankle_problems` varchar(5) default NULL,
  `foot_problems` varchar(5) default NULL,
  `insulin_dependent_diabetes` varchar(5) default NULL,
  `noninsulin_dependent_diabetes` varchar(5) default NULL,
  `hypothyroidism` varchar(5) default NULL,
  `hyperthyroidism` varchar(5) default NULL,
  `cushing_syndrom` varchar(5) default NULL,
  `addison_syndrom` varchar(5) default NULL,
  `additional_notes` longtext,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_ros`
-- 

DROP TABLE IF EXISTS `form_ros`;
CREATE TABLE `form_ros` (
  `id` int(11) NOT NULL auto_increment,
  `pid` int(11) NOT NULL,
  `activity` int(11) NOT NULL default '1',
  `date` datetime default NULL,
  `weight_change` varchar(3) default NULL,
  `weakness` varchar(3) default NULL,
  `fatigue` varchar(3) default NULL,
  `anorexia` varchar(3) default NULL,
  `fever` varchar(3) default NULL,
  `chills` varchar(3) default NULL,
  `night_sweats` varchar(3) default NULL,
  `insomnia` varchar(3) default NULL,
  `irritability` varchar(3) default NULL,
  `heat_or_cold` varchar(3) default NULL,
  `intolerance` varchar(3) default NULL,
  `change_in_vision` varchar(3) default NULL,
  `glaucoma_history` varchar(3) default NULL,
  `eye_pain` varchar(3) default NULL,
  `irritation` varchar(3) default NULL,
  `redness` varchar(3) default NULL,
  `excessive_tearing` varchar(3) default NULL,
  `double_vision` varchar(3) default NULL,
  `blind_spots` varchar(3) default NULL,
  `photophobia` varchar(3) default NULL,
  `hearing_loss` varchar(3) default NULL,
  `discharge` varchar(3) default NULL,
  `pain` varchar(3) default NULL,
  `vertigo` varchar(3) default NULL,
  `tinnitus` varchar(3) default NULL,
  `frequent_colds` varchar(3) default NULL,
  `sore_throat` varchar(3) default NULL,
  `sinus_problems` varchar(3) default NULL,
  `post_nasal_drip` varchar(3) default NULL,
  `nosebleed` varchar(3) default NULL,
  `snoring` varchar(3) default NULL,
  `apnea` varchar(3) default NULL,
  `breast_mass` varchar(3) default NULL,
  `breast_discharge` varchar(3) default NULL,
  `biopsy` varchar(3) default NULL,
  `abnormal_mammogram` varchar(3) default NULL,
  `cough` varchar(3) default NULL,
  `sputum` varchar(3) default NULL,
  `shortness_of_breath` varchar(3) default NULL,
  `wheezing` varchar(3) default NULL,
  `hemoptsyis` varchar(3) default NULL,
  `asthma` varchar(3) default NULL,
  `copd` varchar(3) default NULL,
  `chest_pain` varchar(3) default NULL,
  `palpitation` varchar(3) default NULL,
  `syncope` varchar(3) default NULL,
  `pnd` varchar(3) default NULL,
  `doe` varchar(3) default NULL,
  `orthopnea` varchar(3) default NULL,
  `peripheal` varchar(3) default NULL,
  `edema` varchar(3) default NULL,
  `legpain_cramping` varchar(3) default NULL,
  `history_murmur` varchar(3) default NULL,
  `arrythmia` varchar(3) default NULL,
  `heart_problem` varchar(3) default NULL,
  `dysphagia` varchar(3) default NULL,
  `heartburn` varchar(3) default NULL,
  `bloating` varchar(3) default NULL,
  `belching` varchar(3) default NULL,
  `flatulence` varchar(3) default NULL,
  `nausea` varchar(3) default NULL,
  `vomiting` varchar(3) default NULL,
  `hematemesis` varchar(3) default NULL,
  `gastro_pain` varchar(3) default NULL,
  `food_intolerance` varchar(3) default NULL,
  `hepatitis` varchar(3) default NULL,
  `jaundice` varchar(3) default NULL,
  `hematochezia` varchar(3) default NULL,
  `changed_bowel` varchar(3) default NULL,
  `diarrhea` varchar(3) default NULL,
  `constipation` varchar(3) default NULL,
  `polyuria` varchar(3) default NULL,
  `polydypsia` varchar(3) default NULL,
  `dysuria` varchar(3) default NULL,
  `hematuria` varchar(3) default NULL,
  `frequency` varchar(3) default NULL,
  `urgency` varchar(3) default NULL,
  `incontinence` varchar(3) default NULL,
  `renal_stones` varchar(3) default NULL,
  `utis` varchar(3) default NULL,
  `hesitancy` varchar(3) default NULL,
  `dribbling` varchar(3) default NULL,
  `stream` varchar(3) default NULL,
  `nocturia` varchar(3) default NULL,
  `erections` varchar(3) default NULL,
  `ejaculations` varchar(3) default NULL,
  `g` varchar(3) default NULL,
  `p` varchar(3) default NULL,
  `ap` varchar(3) default NULL,
  `lc` varchar(3) default NULL,
  `mearche` varchar(3) default NULL,
  `menopause` varchar(3) default NULL,
  `lmp` varchar(3) default NULL,
  `f_frequency` varchar(3) default NULL,
  `f_flow` varchar(3) default NULL,
  `f_symptoms` varchar(3) default NULL,
  `abnormal_hair_growth` varchar(3) default NULL,
  `f_hirsutism` varchar(3) default NULL,
  `joint_pain` varchar(3) default NULL,
  `swelling` varchar(3) default NULL,
  `m_redness` varchar(3) default NULL,
  `m_warm` varchar(3) default NULL,
  `m_stiffness` varchar(3) default NULL,
  `muscle` varchar(3) default NULL,
  `m_aches` varchar(3) default NULL,
  `fms` varchar(3) default NULL,
  `arthritis` varchar(3) default NULL,
  `loc` varchar(3) default NULL,
  `seizures` varchar(3) default NULL,
  `stroke` varchar(3) default NULL,
  `tia` varchar(3) default NULL,
  `n_numbness` varchar(3) default NULL,
  `n_weakness` varchar(3) default NULL,
  `paralysis` varchar(3) default NULL,
  `intellectual_decline` varchar(3) default NULL,
  `memory_problems` varchar(3) default NULL,
  `dementia` varchar(3) default NULL,
  `n_headache` varchar(3) default NULL,
  `s_cancer` varchar(3) default NULL,
  `psoriasis` varchar(3) default NULL,
  `s_acne` varchar(3) default NULL,
  `s_other` varchar(3) default NULL,
  `s_disease` varchar(3) default NULL,
  `p_diagnosis` varchar(3) default NULL,
  `p_medication` varchar(3) default NULL,
  `depression` varchar(3) default NULL,
  `anxiety` varchar(3) default NULL,
  `social_difficulties` varchar(3) default NULL,
  `thyroid_problems` varchar(3) default NULL,
  `diabetes` varchar(3) default NULL,
  `abnormal_blood` varchar(3) default NULL,
  `anemia` varchar(3) default NULL,
  `fh_blood_problems` varchar(3) default NULL,
  `bleeding_problems` varchar(3) default NULL,
  `allergies` varchar(3) default NULL,
  `frequent_illness` varchar(3) default NULL,
  `hiv` varchar(3) default NULL,
  `hai_status` varchar(3) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_soap`
-- 

DROP TABLE IF EXISTS `form_soap`;
CREATE TABLE `form_soap` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `pid` bigint(20) default '0',
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `authorized` tinyint(4) default '0',
  `activity` tinyint(4) default '0',
  `subjective` text,
  `objective` text,
  `assessment` text,
  `plan` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `form_vitals`
-- 

DROP TABLE IF EXISTS `form_vitals`;
CREATE TABLE `form_vitals` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `pid` bigint(20) default '0',
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `authorized` tinyint(4) default '0',
  `activity` tinyint(4) default '0',
  `bps` varchar(40) default NULL,
  `bpd` varchar(40) default NULL,
  `weight` float(5,2) default '0.00',
  `height` float(5,2) default '0.00',
  `temperature` float(5,2) default '0.00',
  `temp_method` varchar(255) default NULL,
  `pulse` float(5,2) default '0.00',
  `respiration` float(5,2) default '0.00',
  `note` varchar(255) default NULL,
  `BMI` float(4,1) default '0.0',
  `BMI_status` varchar(255) default NULL,
  `waist_circ` float(5,2) default '0.00',
  `head_circ` float(4,2) default '0.00',
  `oxygen_saturation` float(5,2) default '0.00',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `forms`
-- 

DROP TABLE IF EXISTS `forms`;
CREATE TABLE `forms` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `encounter` bigint(20) default NULL,
  `form_name` longtext,
  `form_id` bigint(20) default NULL,
  `pid` bigint(20) default NULL,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `authorized` tinyint(4) default NULL,
  `deleted` tinyint(4) DEFAULT '0' NOT NULL COMMENT 'flag indicates form has been deleted',
  `formdir` longtext,
  `issue_id` bigint(20) NOT NULL default 0 COMMENT 'references lists.id to identify a case',
  `provider_id` bigint(20) NOT NULL default 0 COMMENT 'references users.id to identify a provider',
  PRIMARY KEY  (`id`),
  KEY `pid_encounter` (`pid`, `encounter`),
  KEY `form_id` (`form_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `geo_country_reference`
-- 

DROP TABLE IF EXISTS `geo_country_reference`;
CREATE TABLE `geo_country_reference` (
  `countries_id` int(5) NOT NULL auto_increment,
  `countries_name` varchar(64) default NULL,
  `countries_iso_code_2` char(2) NOT NULL default '',
  `countries_iso_code_3` char(3) NOT NULL default '',
  PRIMARY KEY  (`countries_id`),
  KEY `IDX_COUNTRIES_NAME` (`countries_name`)
) ENGINE=MyISAM AUTO_INCREMENT=240 ;

-- 
-- Dumping data for table `geo_country_reference`
-- 

INSERT INTO `geo_country_reference` VALUES (1, 'Afghanistan', 'AF', 'AFG');
INSERT INTO `geo_country_reference` VALUES (2, 'Albania', 'AL', 'ALB');
INSERT INTO `geo_country_reference` VALUES (3, 'Algeria', 'DZ', 'DZA');
INSERT INTO `geo_country_reference` VALUES (4, 'American Samoa', 'AS', 'ASM');
INSERT INTO `geo_country_reference` VALUES (5, 'Andorra', 'AD', 'AND');
INSERT INTO `geo_country_reference` VALUES (6, 'Angola', 'AO', 'AGO');
INSERT INTO `geo_country_reference` VALUES (7, 'Anguilla', 'AI', 'AIA');
INSERT INTO `geo_country_reference` VALUES (8, 'Antarctica', 'AQ', 'ATA');
INSERT INTO `geo_country_reference` VALUES (9, 'Antigua and Barbuda', 'AG', 'ATG');
INSERT INTO `geo_country_reference` VALUES (10, 'Argentina', 'AR', 'ARG');
INSERT INTO `geo_country_reference` VALUES (11, 'Armenia', 'AM', 'ARM');
INSERT INTO `geo_country_reference` VALUES (12, 'Aruba', 'AW', 'ABW');
INSERT INTO `geo_country_reference` VALUES (13, 'Australia', 'AU', 'AUS');
INSERT INTO `geo_country_reference` VALUES (14, 'Austria', 'AT', 'AUT');
INSERT INTO `geo_country_reference` VALUES (15, 'Azerbaijan', 'AZ', 'AZE');
INSERT INTO `geo_country_reference` VALUES (16, 'Bahamas', 'BS', 'BHS');
INSERT INTO `geo_country_reference` VALUES (17, 'Bahrain', 'BH', 'BHR');
INSERT INTO `geo_country_reference` VALUES (18, 'Bangladesh', 'BD', 'BGD');
INSERT INTO `geo_country_reference` VALUES (19, 'Barbados', 'BB', 'BRB');
INSERT INTO `geo_country_reference` VALUES (20, 'Belarus', 'BY', 'BLR');
INSERT INTO `geo_country_reference` VALUES (21, 'Belgium', 'BE', 'BEL');
INSERT INTO `geo_country_reference` VALUES (22, 'Belize', 'BZ', 'BLZ');
INSERT INTO `geo_country_reference` VALUES (23, 'Benin', 'BJ', 'BEN');
INSERT INTO `geo_country_reference` VALUES (24, 'Bermuda', 'BM', 'BMU');
INSERT INTO `geo_country_reference` VALUES (25, 'Bhutan', 'BT', 'BTN');
INSERT INTO `geo_country_reference` VALUES (26, 'Bolivia', 'BO', 'BOL');
INSERT INTO `geo_country_reference` VALUES (27, 'Bosnia and Herzegowina', 'BA', 'BIH');
INSERT INTO `geo_country_reference` VALUES (28, 'Botswana', 'BW', 'BWA');
INSERT INTO `geo_country_reference` VALUES (29, 'Bouvet Island', 'BV', 'BVT');
INSERT INTO `geo_country_reference` VALUES (30, 'Brazil', 'BR', 'BRA');
INSERT INTO `geo_country_reference` VALUES (31, 'British Indian Ocean Territory', 'IO', 'IOT');
INSERT INTO `geo_country_reference` VALUES (32, 'Brunei Darussalam', 'BN', 'BRN');
INSERT INTO `geo_country_reference` VALUES (33, 'Bulgaria', 'BG', 'BGR');
INSERT INTO `geo_country_reference` VALUES (34, 'Burkina Faso', 'BF', 'BFA');
INSERT INTO `geo_country_reference` VALUES (35, 'Burundi', 'BI', 'BDI');
INSERT INTO `geo_country_reference` VALUES (36, 'Cambodia', 'KH', 'KHM');
INSERT INTO `geo_country_reference` VALUES (37, 'Cameroon', 'CM', 'CMR');
INSERT INTO `geo_country_reference` VALUES (38, 'Canada', 'CA', 'CAN');
INSERT INTO `geo_country_reference` VALUES (39, 'Cape Verde', 'CV', 'CPV');
INSERT INTO `geo_country_reference` VALUES (40, 'Cayman Islands', 'KY', 'CYM');
INSERT INTO `geo_country_reference` VALUES (41, 'Central African Republic', 'CF', 'CAF');
INSERT INTO `geo_country_reference` VALUES (42, 'Chad', 'TD', 'TCD');
INSERT INTO `geo_country_reference` VALUES (43, 'Chile', 'CL', 'CHL');
INSERT INTO `geo_country_reference` VALUES (44, 'China', 'CN', 'CHN');
INSERT INTO `geo_country_reference` VALUES (45, 'Christmas Island', 'CX', 'CXR');
INSERT INTO `geo_country_reference` VALUES (46, 'Cocos (Keeling) Islands', 'CC', 'CCK');
INSERT INTO `geo_country_reference` VALUES (47, 'Colombia', 'CO', 'COL');
INSERT INTO `geo_country_reference` VALUES (48, 'Comoros', 'KM', 'COM');
INSERT INTO `geo_country_reference` VALUES (49, 'Congo', 'CG', 'COG');
INSERT INTO `geo_country_reference` VALUES (50, 'Cook Islands', 'CK', 'COK');
INSERT INTO `geo_country_reference` VALUES (51, 'Costa Rica', 'CR', 'CRI');
INSERT INTO `geo_country_reference` VALUES (52, 'Cote D Ivoire', 'CI', 'CIV');
INSERT INTO `geo_country_reference` VALUES (53, 'Croatia', 'HR', 'HRV');
INSERT INTO `geo_country_reference` VALUES (54, 'Cuba', 'CU', 'CUB');
INSERT INTO `geo_country_reference` VALUES (55, 'Cyprus', 'CY', 'CYP');
INSERT INTO `geo_country_reference` VALUES (56, 'Czech Republic', 'CZ', 'CZE');
INSERT INTO `geo_country_reference` VALUES (57, 'Denmark', 'DK', 'DNK');
INSERT INTO `geo_country_reference` VALUES (58, 'Djibouti', 'DJ', 'DJI');
INSERT INTO `geo_country_reference` VALUES (59, 'Dominica', 'DM', 'DMA');
INSERT INTO `geo_country_reference` VALUES (60, 'Dominican Republic', 'DO', 'DOM');
INSERT INTO `geo_country_reference` VALUES (61, 'East Timor', 'TP', 'TMP');
INSERT INTO `geo_country_reference` VALUES (62, 'Ecuador', 'EC', 'ECU');
INSERT INTO `geo_country_reference` VALUES (63, 'Egypt', 'EG', 'EGY');
INSERT INTO `geo_country_reference` VALUES (64, 'El Salvador', 'SV', 'SLV');
INSERT INTO `geo_country_reference` VALUES (65, 'Equatorial Guinea', 'GQ', 'GNQ');
INSERT INTO `geo_country_reference` VALUES (66, 'Eritrea', 'ER', 'ERI');
INSERT INTO `geo_country_reference` VALUES (67, 'Estonia', 'EE', 'EST');
INSERT INTO `geo_country_reference` VALUES (68, 'Ethiopia', 'ET', 'ETH');
INSERT INTO `geo_country_reference` VALUES (69, 'Falkland Islands (Malvinas)', 'FK', 'FLK');
INSERT INTO `geo_country_reference` VALUES (70, 'Faroe Islands', 'FO', 'FRO');
INSERT INTO `geo_country_reference` VALUES (71, 'Fiji', 'FJ', 'FJI');
INSERT INTO `geo_country_reference` VALUES (72, 'Finland', 'FI', 'FIN');
INSERT INTO `geo_country_reference` VALUES (73, 'France', 'FR', 'FRA');
INSERT INTO `geo_country_reference` VALUES (74, 'France, MEtropolitan', 'FX', 'FXX');
INSERT INTO `geo_country_reference` VALUES (75, 'French Guiana', 'GF', 'GUF');
INSERT INTO `geo_country_reference` VALUES (76, 'French Polynesia', 'PF', 'PYF');
INSERT INTO `geo_country_reference` VALUES (77, 'French Southern Territories', 'TF', 'ATF');
INSERT INTO `geo_country_reference` VALUES (78, 'Gabon', 'GA', 'GAB');
INSERT INTO `geo_country_reference` VALUES (79, 'Gambia', 'GM', 'GMB');
INSERT INTO `geo_country_reference` VALUES (80, 'Georgia', 'GE', 'GEO');
INSERT INTO `geo_country_reference` VALUES (81, 'Germany', 'DE', 'DEU');
INSERT INTO `geo_country_reference` VALUES (82, 'Ghana', 'GH', 'GHA');
INSERT INTO `geo_country_reference` VALUES (83, 'Gibraltar', 'GI', 'GIB');
INSERT INTO `geo_country_reference` VALUES (84, 'Greece', 'GR', 'GRC');
INSERT INTO `geo_country_reference` VALUES (85, 'Greenland', 'GL', 'GRL');
INSERT INTO `geo_country_reference` VALUES (86, 'Grenada', 'GD', 'GRD');
INSERT INTO `geo_country_reference` VALUES (87, 'Guadeloupe', 'GP', 'GLP');
INSERT INTO `geo_country_reference` VALUES (88, 'Guam', 'GU', 'GUM');
INSERT INTO `geo_country_reference` VALUES (89, 'Guatemala', 'GT', 'GTM');
INSERT INTO `geo_country_reference` VALUES (90, 'Guinea', 'GN', 'GIN');
INSERT INTO `geo_country_reference` VALUES (91, 'Guinea-bissau', 'GW', 'GNB');
INSERT INTO `geo_country_reference` VALUES (92, 'Guyana', 'GY', 'GUY');
INSERT INTO `geo_country_reference` VALUES (93, 'Haiti', 'HT', 'HTI');
INSERT INTO `geo_country_reference` VALUES (94, 'Heard and Mc Donald Islands', 'HM', 'HMD');
INSERT INTO `geo_country_reference` VALUES (95, 'Honduras', 'HN', 'HND');
INSERT INTO `geo_country_reference` VALUES (96, 'Hong Kong', 'HK', 'HKG');
INSERT INTO `geo_country_reference` VALUES (97, 'Hungary', 'HU', 'HUN');
INSERT INTO `geo_country_reference` VALUES (98, 'Iceland', 'IS', 'ISL');
INSERT INTO `geo_country_reference` VALUES (99, 'India', 'IN', 'IND');
INSERT INTO `geo_country_reference` VALUES (100, 'Indonesia', 'ID', 'IDN');
INSERT INTO `geo_country_reference` VALUES (101, 'Iran (Islamic Republic of)', 'IR', 'IRN');
INSERT INTO `geo_country_reference` VALUES (102, 'Iraq', 'IQ', 'IRQ');
INSERT INTO `geo_country_reference` VALUES (103, 'Ireland', 'IE', 'IRL');
INSERT INTO `geo_country_reference` VALUES (104, 'Israel', 'IL', 'ISR');
INSERT INTO `geo_country_reference` VALUES (105, 'Italy', 'IT', 'ITA');
INSERT INTO `geo_country_reference` VALUES (106, 'Jamaica', 'JM', 'JAM');
INSERT INTO `geo_country_reference` VALUES (107, 'Japan', 'JP', 'JPN');
INSERT INTO `geo_country_reference` VALUES (108, 'Jordan', 'JO', 'JOR');
INSERT INTO `geo_country_reference` VALUES (109, 'Kazakhstan', 'KZ', 'KAZ');
INSERT INTO `geo_country_reference` VALUES (110, 'Kenya', 'KE', 'KEN');
INSERT INTO `geo_country_reference` VALUES (111, 'Kiribati', 'KI', 'KIR');
INSERT INTO `geo_country_reference` VALUES (112, 'Korea, Democratic Peoples Republic of', 'KP', 'PRK');
INSERT INTO `geo_country_reference` VALUES (113, 'Korea, Republic of', 'KR', 'KOR');
INSERT INTO `geo_country_reference` VALUES (114, 'Kuwait', 'KW', 'KWT');
INSERT INTO `geo_country_reference` VALUES (115, 'Kyrgyzstan', 'KG', 'KGZ');
INSERT INTO `geo_country_reference` VALUES (116, 'Lao Peoples Democratic Republic', 'LA', 'LAO');
INSERT INTO `geo_country_reference` VALUES (117, 'Latvia', 'LV', 'LVA');
INSERT INTO `geo_country_reference` VALUES (118, 'Lebanon', 'LB', 'LBN');
INSERT INTO `geo_country_reference` VALUES (119, 'Lesotho', 'LS', 'LSO');
INSERT INTO `geo_country_reference` VALUES (120, 'Liberia', 'LR', 'LBR');
INSERT INTO `geo_country_reference` VALUES (121, 'Libyan Arab Jamahiriya', 'LY', 'LBY');
INSERT INTO `geo_country_reference` VALUES (122, 'Liechtenstein', 'LI', 'LIE');
INSERT INTO `geo_country_reference` VALUES (123, 'Lithuania', 'LT', 'LTU');
INSERT INTO `geo_country_reference` VALUES (124, 'Luxembourg', 'LU', 'LUX');
INSERT INTO `geo_country_reference` VALUES (125, 'Macau', 'MO', 'MAC');
INSERT INTO `geo_country_reference` VALUES (126, 'Macedonia, The Former Yugoslav Republic of', 'MK', 'MKD');
INSERT INTO `geo_country_reference` VALUES (127, 'Madagascar', 'MG', 'MDG');
INSERT INTO `geo_country_reference` VALUES (128, 'Malawi', 'MW', 'MWI');
INSERT INTO `geo_country_reference` VALUES (129, 'Malaysia', 'MY', 'MYS');
INSERT INTO `geo_country_reference` VALUES (130, 'Maldives', 'MV', 'MDV');
INSERT INTO `geo_country_reference` VALUES (131, 'Mali', 'ML', 'MLI');
INSERT INTO `geo_country_reference` VALUES (132, 'Malta', 'MT', 'MLT');
INSERT INTO `geo_country_reference` VALUES (133, 'Marshall Islands', 'MH', 'MHL');
INSERT INTO `geo_country_reference` VALUES (134, 'Martinique', 'MQ', 'MTQ');
INSERT INTO `geo_country_reference` VALUES (135, 'Mauritania', 'MR', 'MRT');
INSERT INTO `geo_country_reference` VALUES (136, 'Mauritius', 'MU', 'MUS');
INSERT INTO `geo_country_reference` VALUES (137, 'Mayotte', 'YT', 'MYT');
INSERT INTO `geo_country_reference` VALUES (138, 'Mexico', 'MX', 'MEX');
INSERT INTO `geo_country_reference` VALUES (139, 'Micronesia, Federated States of', 'FM', 'FSM');
INSERT INTO `geo_country_reference` VALUES (140, 'Moldova, Republic of', 'MD', 'MDA');
INSERT INTO `geo_country_reference` VALUES (141, 'Monaco', 'MC', 'MCO');
INSERT INTO `geo_country_reference` VALUES (142, 'Mongolia', 'MN', 'MNG');
INSERT INTO `geo_country_reference` VALUES (143, 'Montserrat', 'MS', 'MSR');
INSERT INTO `geo_country_reference` VALUES (144, 'Morocco', 'MA', 'MAR');
INSERT INTO `geo_country_reference` VALUES (145, 'Mozambique', 'MZ', 'MOZ');
INSERT INTO `geo_country_reference` VALUES (146, 'Myanmar', 'MM', 'MMR');
INSERT INTO `geo_country_reference` VALUES (147, 'Namibia', 'NA', 'NAM');
INSERT INTO `geo_country_reference` VALUES (148, 'Nauru', 'NR', 'NRU');
INSERT INTO `geo_country_reference` VALUES (149, 'Nepal', 'NP', 'NPL');
INSERT INTO `geo_country_reference` VALUES (150, 'Netherlands', 'NL', 'NLD');
INSERT INTO `geo_country_reference` VALUES (151, 'Netherlands Antilles', 'AN', 'ANT');
INSERT INTO `geo_country_reference` VALUES (152, 'New Caledonia', 'NC', 'NCL');
INSERT INTO `geo_country_reference` VALUES (153, 'New Zealand', 'NZ', 'NZL');
INSERT INTO `geo_country_reference` VALUES (154, 'Nicaragua', 'NI', 'NIC');
INSERT INTO `geo_country_reference` VALUES (155, 'Niger', 'NE', 'NER');
INSERT INTO `geo_country_reference` VALUES (156, 'Nigeria', 'NG', 'NGA');
INSERT INTO `geo_country_reference` VALUES (157, 'Niue', 'NU', 'NIU');
INSERT INTO `geo_country_reference` VALUES (158, 'Norfolk Island', 'NF', 'NFK');
INSERT INTO `geo_country_reference` VALUES (159, 'Northern Mariana Islands', 'MP', 'MNP');
INSERT INTO `geo_country_reference` VALUES (160, 'Norway', 'NO', 'NOR');
INSERT INTO `geo_country_reference` VALUES (161, 'Oman', 'OM', 'OMN');
INSERT INTO `geo_country_reference` VALUES (162, 'Pakistan', 'PK', 'PAK');
INSERT INTO `geo_country_reference` VALUES (163, 'Palau', 'PW', 'PLW');
INSERT INTO `geo_country_reference` VALUES (164, 'Panama', 'PA', 'PAN');
INSERT INTO `geo_country_reference` VALUES (165, 'Papua New Guinea', 'PG', 'PNG');
INSERT INTO `geo_country_reference` VALUES (166, 'Paraguay', 'PY', 'PRY');
INSERT INTO `geo_country_reference` VALUES (167, 'Peru', 'PE', 'PER');
INSERT INTO `geo_country_reference` VALUES (168, 'Philippines', 'PH', 'PHL');
INSERT INTO `geo_country_reference` VALUES (169, 'Pitcairn', 'PN', 'PCN');
INSERT INTO `geo_country_reference` VALUES (170, 'Poland', 'PL', 'POL');
INSERT INTO `geo_country_reference` VALUES (171, 'Portugal', 'PT', 'PRT');
INSERT INTO `geo_country_reference` VALUES (172, 'Puerto Rico', 'PR', 'PRI');
INSERT INTO `geo_country_reference` VALUES (173, 'Qatar', 'QA', 'QAT');
INSERT INTO `geo_country_reference` VALUES (174, 'Reunion', 'RE', 'REU');
INSERT INTO `geo_country_reference` VALUES (175, 'Romania', 'RO', 'ROM');
INSERT INTO `geo_country_reference` VALUES (176, 'Russian Federation', 'RU', 'RUS');
INSERT INTO `geo_country_reference` VALUES (177, 'Rwanda', 'RW', 'RWA');
INSERT INTO `geo_country_reference` VALUES (178, 'Saint Kitts and Nevis', 'KN', 'KNA');
INSERT INTO `geo_country_reference` VALUES (179, 'Saint Lucia', 'LC', 'LCA');
INSERT INTO `geo_country_reference` VALUES (180, 'Saint Vincent and the Grenadines', 'VC', 'VCT');
INSERT INTO `geo_country_reference` VALUES (181, 'Samoa', 'WS', 'WSM');
INSERT INTO `geo_country_reference` VALUES (182, 'San Marino', 'SM', 'SMR');
INSERT INTO `geo_country_reference` VALUES (183, 'Sao Tome and Principe', 'ST', 'STP');
INSERT INTO `geo_country_reference` VALUES (184, 'Saudi Arabia', 'SA', 'SAU');
INSERT INTO `geo_country_reference` VALUES (185, 'Senegal', 'SN', 'SEN');
INSERT INTO `geo_country_reference` VALUES (186, 'Seychelles', 'SC', 'SYC');
INSERT INTO `geo_country_reference` VALUES (187, 'Sierra Leone', 'SL', 'SLE');
INSERT INTO `geo_country_reference` VALUES (188, 'Singapore', 'SG', 'SGP');
INSERT INTO `geo_country_reference` VALUES (189, 'Slovakia (Slovak Republic)', 'SK', 'SVK');
INSERT INTO `geo_country_reference` VALUES (190, 'Slovenia', 'SI', 'SVN');
INSERT INTO `geo_country_reference` VALUES (191, 'Solomon Islands', 'SB', 'SLB');
INSERT INTO `geo_country_reference` VALUES (192, 'Somalia', 'SO', 'SOM');
INSERT INTO `geo_country_reference` VALUES (193, 'south Africa', 'ZA', 'ZAF');
INSERT INTO `geo_country_reference` VALUES (194, 'South Georgia and the South Sandwich Islands', 'GS', 'SGS');
INSERT INTO `geo_country_reference` VALUES (195, 'Spain', 'ES', 'ESP');
INSERT INTO `geo_country_reference` VALUES (196, 'Sri Lanka', 'LK', 'LKA');
INSERT INTO `geo_country_reference` VALUES (197, 'St. Helena', 'SH', 'SHN');
INSERT INTO `geo_country_reference` VALUES (198, 'St. Pierre and Miquelon', 'PM', 'SPM');
INSERT INTO `geo_country_reference` VALUES (199, 'Sudan', 'SD', 'SDN');
INSERT INTO `geo_country_reference` VALUES (200, 'Suriname', 'SR', 'SUR');
INSERT INTO `geo_country_reference` VALUES (201, 'Svalbard and Jan Mayen Islands', 'SJ', 'SJM');
INSERT INTO `geo_country_reference` VALUES (202, 'Swaziland', 'SZ', 'SWZ');
INSERT INTO `geo_country_reference` VALUES (203, 'Sweden', 'SE', 'SWE');
INSERT INTO `geo_country_reference` VALUES (204, 'Switzerland', 'CH', 'CHE');
INSERT INTO `geo_country_reference` VALUES (205, 'Syrian Arab Republic', 'SY', 'SYR');
INSERT INTO `geo_country_reference` VALUES (206, 'Taiwan, Province of China', 'TW', 'TWN');
INSERT INTO `geo_country_reference` VALUES (207, 'Tajikistan', 'TJ', 'TJK');
INSERT INTO `geo_country_reference` VALUES (208, 'Tanzania, United Republic of', 'TZ', 'TZA');
INSERT INTO `geo_country_reference` VALUES (209, 'Thailand', 'TH', 'THA');
INSERT INTO `geo_country_reference` VALUES (210, 'Togo', 'TG', 'TGO');
INSERT INTO `geo_country_reference` VALUES (211, 'Tokelau', 'TK', 'TKL');
INSERT INTO `geo_country_reference` VALUES (212, 'Tonga', 'TO', 'TON');
INSERT INTO `geo_country_reference` VALUES (213, 'Trinidad and Tobago', 'TT', 'TTO');
INSERT INTO `geo_country_reference` VALUES (214, 'Tunisia', 'TN', 'TUN');
INSERT INTO `geo_country_reference` VALUES (215, 'Turkey', 'TR', 'TUR');
INSERT INTO `geo_country_reference` VALUES (216, 'Turkmenistan', 'TM', 'TKM');
INSERT INTO `geo_country_reference` VALUES (217, 'Turks and Caicos Islands', 'TC', 'TCA');
INSERT INTO `geo_country_reference` VALUES (218, 'Tuvalu', 'TV', 'TUV');
INSERT INTO `geo_country_reference` VALUES (219, 'Uganda', 'UG', 'UGA');
INSERT INTO `geo_country_reference` VALUES (220, 'Ukraine', 'UA', 'UKR');
INSERT INTO `geo_country_reference` VALUES (221, 'United Arab Emirates', 'AE', 'ARE');
INSERT INTO `geo_country_reference` VALUES (222, 'United Kingdom', 'GB', 'GBR');
INSERT INTO `geo_country_reference` VALUES (223, 'United States', 'US', 'USA');
INSERT INTO `geo_country_reference` VALUES (224, 'United States Minor Outlying Islands', 'UM', 'UMI');
INSERT INTO `geo_country_reference` VALUES (225, 'Uruguay', 'UY', 'URY');
INSERT INTO `geo_country_reference` VALUES (226, 'Uzbekistan', 'UZ', 'UZB');
INSERT INTO `geo_country_reference` VALUES (227, 'Vanuatu', 'VU', 'VUT');
INSERT INTO `geo_country_reference` VALUES (228, 'Vatican City State (Holy See)', 'VA', 'VAT');
INSERT INTO `geo_country_reference` VALUES (229, 'Venezuela', 'VE', 'VEN');
INSERT INTO `geo_country_reference` VALUES (230, 'Viet Nam', 'VN', 'VNM');
INSERT INTO `geo_country_reference` VALUES (231, 'Virgin Islands (British)', 'VG', 'VGB');
INSERT INTO `geo_country_reference` VALUES (232, 'Virgin Islands (U.S.)', 'VI', 'VIR');
INSERT INTO `geo_country_reference` VALUES (233, 'Wallis and Futuna Islands', 'WF', 'WLF');
INSERT INTO `geo_country_reference` VALUES (234, 'Western Sahara', 'EH', 'ESH');
INSERT INTO `geo_country_reference` VALUES (235, 'Yemen', 'YE', 'YEM');
INSERT INTO `geo_country_reference` VALUES (236, 'Yugoslavia', 'YU', 'YUG');
INSERT INTO `geo_country_reference` VALUES (237, 'Zaire', 'ZR', 'ZAR');
INSERT INTO `geo_country_reference` VALUES (238, 'Zambia', 'ZM', 'ZMB');
INSERT INTO `geo_country_reference` VALUES (239, 'Zimbabwe', 'ZW', 'ZWE');

-- --------------------------------------------------------

-- 
-- Table structure for table `geo_zone_reference`
-- 

DROP TABLE IF EXISTS `geo_zone_reference`;
CREATE TABLE `geo_zone_reference` (
  `zone_id` int(5) NOT NULL auto_increment,
  `zone_country_id` int(5) NOT NULL default '0',
  `zone_code` varchar(5) default NULL,
  `zone_name` varchar(32) default NULL,
  PRIMARY KEY  (`zone_id`)
) ENGINE=MyISAM AUTO_INCREMENT=83 ;

-- 
-- Dumping data for table `geo_zone_reference`
-- 

INSERT INTO `geo_zone_reference` VALUES (1, 223, 'AL', 'Alabama');
INSERT INTO `geo_zone_reference` VALUES (2, 223, 'AK', 'Alaska');
INSERT INTO `geo_zone_reference` VALUES (3, 223, 'AS', 'American Samoa');
INSERT INTO `geo_zone_reference` VALUES (4, 223, 'AZ', 'Arizona');
INSERT INTO `geo_zone_reference` VALUES (5, 223, 'AR', 'Arkansas');
INSERT INTO `geo_zone_reference` VALUES (6, 223, 'AF', 'Armed Forces Africa');
INSERT INTO `geo_zone_reference` VALUES (7, 223, 'AA', 'Armed Forces Americas');
INSERT INTO `geo_zone_reference` VALUES (8, 223, 'AC', 'Armed Forces Canada');
INSERT INTO `geo_zone_reference` VALUES (9, 223, 'AE', 'Armed Forces Europe');
INSERT INTO `geo_zone_reference` VALUES (10, 223, 'AM', 'Armed Forces Middle East');
INSERT INTO `geo_zone_reference` VALUES (11, 223, 'AP', 'Armed Forces Pacific');
INSERT INTO `geo_zone_reference` VALUES (12, 223, 'CA', 'California');
INSERT INTO `geo_zone_reference` VALUES (13, 223, 'CO', 'Colorado');
INSERT INTO `geo_zone_reference` VALUES (14, 223, 'CT', 'Connecticut');
INSERT INTO `geo_zone_reference` VALUES (15, 223, 'DE', 'Delaware');
INSERT INTO `geo_zone_reference` VALUES (16, 223, 'DC', 'District of Columbia');
INSERT INTO `geo_zone_reference` VALUES (17, 223, 'FM', 'Federated States Of Micronesia');
INSERT INTO `geo_zone_reference` VALUES (18, 223, 'FL', 'Florida');
INSERT INTO `geo_zone_reference` VALUES (19, 223, 'GA', 'Georgia');
INSERT INTO `geo_zone_reference` VALUES (20, 223, 'GU', 'Guam');
INSERT INTO `geo_zone_reference` VALUES (21, 223, 'HI', 'Hawaii');
INSERT INTO `geo_zone_reference` VALUES (22, 223, 'ID', 'Idaho');
INSERT INTO `geo_zone_reference` VALUES (23, 223, 'IL', 'Illinois');
INSERT INTO `geo_zone_reference` VALUES (24, 223, 'IN', 'Indiana');
INSERT INTO `geo_zone_reference` VALUES (25, 223, 'IA', 'Iowa');
INSERT INTO `geo_zone_reference` VALUES (26, 223, 'KS', 'Kansas');
INSERT INTO `geo_zone_reference` VALUES (27, 223, 'KY', 'Kentucky');
INSERT INTO `geo_zone_reference` VALUES (28, 223, 'LA', 'Louisiana');
INSERT INTO `geo_zone_reference` VALUES (29, 223, 'ME', 'Maine');
INSERT INTO `geo_zone_reference` VALUES (30, 223, 'MH', 'Marshall Islands');
INSERT INTO `geo_zone_reference` VALUES (31, 223, 'MD', 'Maryland');
INSERT INTO `geo_zone_reference` VALUES (32, 223, 'MA', 'Massachusetts');
INSERT INTO `geo_zone_reference` VALUES (33, 223, 'MI', 'Michigan');
INSERT INTO `geo_zone_reference` VALUES (34, 223, 'MN', 'Minnesota');
INSERT INTO `geo_zone_reference` VALUES (35, 223, 'MS', 'Mississippi');
INSERT INTO `geo_zone_reference` VALUES (36, 223, 'MO', 'Missouri');
INSERT INTO `geo_zone_reference` VALUES (37, 223, 'MT', 'Montana');
INSERT INTO `geo_zone_reference` VALUES (38, 223, 'NE', 'Nebraska');
INSERT INTO `geo_zone_reference` VALUES (39, 223, 'NV', 'Nevada');
INSERT INTO `geo_zone_reference` VALUES (40, 223, 'NH', 'New Hampshire');
INSERT INTO `geo_zone_reference` VALUES (41, 223, 'NJ', 'New Jersey');
INSERT INTO `geo_zone_reference` VALUES (42, 223, 'NM', 'New Mexico');
INSERT INTO `geo_zone_reference` VALUES (43, 223, 'NY', 'New York');
INSERT INTO `geo_zone_reference` VALUES (44, 223, 'NC', 'North Carolina');
INSERT INTO `geo_zone_reference` VALUES (45, 223, 'ND', 'North Dakota');
INSERT INTO `geo_zone_reference` VALUES (46, 223, 'MP', 'Northern Mariana Islands');
INSERT INTO `geo_zone_reference` VALUES (47, 223, 'OH', 'Ohio');
INSERT INTO `geo_zone_reference` VALUES (48, 223, 'OK', 'Oklahoma');
INSERT INTO `geo_zone_reference` VALUES (49, 223, 'OR', 'Oregon');
INSERT INTO `geo_zone_reference` VALUES (50, 223, 'PW', 'Palau');
INSERT INTO `geo_zone_reference` VALUES (51, 223, 'PA', 'Pennsylvania');
INSERT INTO `geo_zone_reference` VALUES (52, 223, 'PR', 'Puerto Rico');
INSERT INTO `geo_zone_reference` VALUES (53, 223, 'RI', 'Rhode Island');
INSERT INTO `geo_zone_reference` VALUES (54, 223, 'SC', 'South Carolina');
INSERT INTO `geo_zone_reference` VALUES (55, 223, 'SD', 'South Dakota');
INSERT INTO `geo_zone_reference` VALUES (56, 223, 'TN', 'Tenessee');
INSERT INTO `geo_zone_reference` VALUES (57, 223, 'TX', 'Texas');
INSERT INTO `geo_zone_reference` VALUES (58, 223, 'UT', 'Utah');
INSERT INTO `geo_zone_reference` VALUES (59, 223, 'VT', 'Vermont');
INSERT INTO `geo_zone_reference` VALUES (60, 223, 'VI', 'Virgin Islands');
INSERT INTO `geo_zone_reference` VALUES (61, 223, 'VA', 'Virginia');
INSERT INTO `geo_zone_reference` VALUES (62, 223, 'WA', 'Washington');
INSERT INTO `geo_zone_reference` VALUES (63, 223, 'WV', 'West Virginia');
INSERT INTO `geo_zone_reference` VALUES (64, 223, 'WI', 'Wisconsin');
INSERT INTO `geo_zone_reference` VALUES (65, 223, 'WY', 'Wyoming');
INSERT INTO `geo_zone_reference` VALUES (66, 38, 'AB', 'Alberta');
INSERT INTO `geo_zone_reference` VALUES (67, 38, 'BC', 'British Columbia');
INSERT INTO `geo_zone_reference` VALUES (68, 38, 'MB', 'Manitoba');
INSERT INTO `geo_zone_reference` VALUES (69, 38, 'NF', 'Newfoundland');
INSERT INTO `geo_zone_reference` VALUES (70, 38, 'NB', 'New Brunswick');
INSERT INTO `geo_zone_reference` VALUES (71, 38, 'NS', 'Nova Scotia');
INSERT INTO `geo_zone_reference` VALUES (72, 38, 'NT', 'Northwest Territories');
INSERT INTO `geo_zone_reference` VALUES (73, 38, 'NU', 'Nunavut');
INSERT INTO `geo_zone_reference` VALUES (74, 38, 'ON', 'Ontario');
INSERT INTO `geo_zone_reference` VALUES (75, 38, 'PE', 'Prince Edward Island');
INSERT INTO `geo_zone_reference` VALUES (76, 38, 'QC', 'Quebec');
INSERT INTO `geo_zone_reference` VALUES (77, 38, 'SK', 'Saskatchewan');
INSERT INTO `geo_zone_reference` VALUES (78, 38, 'YT', 'Yukon Territory');
INSERT INTO `geo_zone_reference` VALUES (79, 61, 'QLD', 'Queensland');
INSERT INTO `geo_zone_reference` VALUES (80, 61, 'SA', 'South Australia');
INSERT INTO `geo_zone_reference` VALUES (81, 61, 'ACT', 'Australian Capital Territory');
INSERT INTO `geo_zone_reference` VALUES (82, 61, 'VIC', 'Victoria');

-- --------------------------------------------------------

-- 
-- Table structure for table `groups`
-- 

DROP TABLE IF EXISTS `groups`;
CREATE TABLE `groups` (
  `id` bigint(20) NOT NULL auto_increment,
  `name` longtext,
  `user` longtext,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `history_data`
-- 

DROP TABLE IF EXISTS `history_data`;
CREATE TABLE `history_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `coffee` longtext,
  `tobacco` longtext,
  `alcohol` longtext,
  `sleep_patterns` longtext,
  `exercise_patterns` longtext,
  `seatbelt_use` longtext,
  `counseling` longtext,
  `hazardous_activities` longtext,
  `recreational_drugs` longtext,
  `last_breast_exam` varchar(255) default NULL,
  `last_mammogram` varchar(255) default NULL,
  `last_gynocological_exam` varchar(255) default NULL,
  `last_rectal_exam` varchar(255) default NULL,
  `last_prostate_exam` varchar(255) default NULL,
  `last_physical_exam` varchar(255) default NULL,
  `last_sigmoidoscopy_colonoscopy` varchar(255) default NULL,
  `last_ecg` varchar(255) default NULL,
  `last_cardiac_echo` varchar(255) default NULL,
  `last_retinal` varchar(255) default NULL,
  `last_fluvax` varchar(255) default NULL,
  `last_pneuvax` varchar(255) default NULL,
  `last_ldl` varchar(255) default NULL,
  `last_hemoglobin` varchar(255) default NULL,
  `last_psa` varchar(255) default NULL,
  `last_exam_results` varchar(255) default NULL,
  `history_mother` longtext,
  `history_father` longtext,
  `history_siblings` longtext,
  `history_offspring` longtext,
  `history_spouse` longtext,
  `relatives_cancer` longtext,
  `relatives_tuberculosis` longtext,
  `relatives_diabetes` longtext,
  `relatives_high_blood_pressure` longtext,
  `relatives_heart_problems` longtext,
  `relatives_stroke` longtext,
  `relatives_epilepsy` longtext,
  `relatives_mental_illness` longtext,
  `relatives_suicide` longtext,
  `cataract_surgery` datetime default NULL,
  `tonsillectomy` datetime default NULL,
  `cholecystestomy` datetime default NULL,
  `heart_surgery` datetime default NULL,
  `hysterectomy` datetime default NULL,
  `hernia_repair` datetime default NULL,
  `hip_replacement` datetime default NULL,
  `knee_replacement` datetime default NULL,
  `appendectomy` datetime default NULL,
  `date` datetime default NULL,
  `pid` bigint(20) NOT NULL default '0',
  `name_1` varchar(255) default NULL,
  `value_1` varchar(255) default NULL,
  `name_2` varchar(255) default NULL,
  `value_2` varchar(255) default NULL,
  `additional_history` text,
  `exams`      text         NOT NULL DEFAULT '',
  `usertext11` TEXT NOT NULL,
  `usertext12` varchar(255) NOT NULL DEFAULT '',
  `usertext13` varchar(255) NOT NULL DEFAULT '',
  `usertext14` varchar(255) NOT NULL DEFAULT '',
  `usertext15` varchar(255) NOT NULL DEFAULT '',
  `usertext16` varchar(255) NOT NULL DEFAULT '',
  `usertext17` varchar(255) NOT NULL DEFAULT '',
  `usertext18` varchar(255) NOT NULL DEFAULT '',
  `usertext19` varchar(255) NOT NULL DEFAULT '',
  `usertext20` varchar(255) NOT NULL DEFAULT '',
  `usertext21` varchar(255) NOT NULL DEFAULT '',
  `usertext22` varchar(255) NOT NULL DEFAULT '',
  `usertext23` varchar(255) NOT NULL DEFAULT '',
  `usertext24` varchar(255) NOT NULL DEFAULT '',
  `usertext25` varchar(255) NOT NULL DEFAULT '',
  `usertext26` varchar(255) NOT NULL DEFAULT '',
  `usertext27` varchar(255) NOT NULL DEFAULT '',
  `usertext28` varchar(255) NOT NULL DEFAULT '',
  `usertext29` varchar(255) NOT NULL DEFAULT '',
  `usertext30` varchar(255) NOT NULL DEFAULT '',
  `userdate11` date DEFAULT NULL,
  `userdate12` date DEFAULT NULL,
  `userdate13` date DEFAULT NULL,
  `userdate14` date DEFAULT NULL,
  `userdate15` date DEFAULT NULL,
  `userarea11` text NOT NULL DEFAULT '',
  `userarea12` text NOT NULL DEFAULT '',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `icd9_dx_code`
--

DROP TABLE IF EXISTS `icd9_dx_code`;
CREATE TABLE `icd9_dx_code` (
  `dx_id` SERIAL,
  `dx_code`             varchar(5),
  `formatted_dx_code`   varchar(6),
  `short_desc`          varchar(60),
  `long_desc`           varchar(300),
  `active` tinyint default 0,
  `revision` int default 0,
  KEY `dx_code` (`dx_code`),
  KEY `formatted_dx_code` (`formatted_dx_code`),
  KEY `active` (`active`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `icd9_sg_code`
--

DROP TABLE IF EXISTS `icd9_sg_code`;
CREATE TABLE `icd9_sg_code` (
  `sg_id` SERIAL,
  `sg_code`             varchar(5),
  `formatted_sg_code`   varchar(6),
  `short_desc`          varchar(60),
  `long_desc`           varchar(300),
  `active` tinyint default 0,
  `revision` int default 0,
  KEY `sg_code` (`sg_code`),
  KEY `formatted_sg_code` (`formatted_sg_code`),
  KEY `active` (`active`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `icd9_dx_long_code`
--

DROP TABLE IF EXISTS `icd9_dx_long_code`;
CREATE TABLE `icd9_dx_long_code` (
  `dx_id` SERIAL,
  `dx_code`             varchar(5),
  `long_desc`           varchar(300),
  `active` tinyint default 0,
  `revision` int default 0
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `icd9_sg_long_code`
--

DROP TABLE IF EXISTS `icd9_sg_long_code`;
CREATE TABLE `icd9_sg_long_code` (
  `sq_id` SERIAL,
  `sg_code`             varchar(5),
  `long_desc`           varchar(300),
  `active` tinyint default 0,
  `revision` int default 0
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `icd10_dx_order_code`
--

DROP TABLE IF EXISTS `icd10_dx_order_code`;
CREATE TABLE `icd10_dx_order_code` (
  `dx_id`               SERIAL,
  `dx_code`             varchar(7),
  `formatted_dx_code`   varchar(10),
  `valid_for_coding`    char,
  `short_desc`          varchar(60),
  `long_desc`           varchar(300),
  `active` tinyint default 0,
  `revision` int default 0,
  KEY `formatted_dx_code` (`formatted_dx_code`),
  KEY `active` (`active`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `icd10_pcs_order_code`
--

DROP TABLE IF EXISTS `icd10_pcs_order_code`;
CREATE TABLE `icd10_pcs_order_code` (
  `pcs_id`              SERIAL,
  `pcs_code`            varchar(7),
  `valid_for_coding`    char,
  `short_desc`          varchar(60),
  `long_desc`           varchar(300),
  `active` tinyint default 0,
  `revision` int default 0,
  KEY `pcs_code` (`pcs_code`),
  KEY `active` (`active`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `icd10_gem_pcs_9_10`
--

DROP TABLE IF EXISTS `icd10_gem_pcs_9_10`;
CREATE TABLE `icd10_gem_pcs_9_10` (
  `map_id` SERIAL,
  `pcs_icd9_source` varchar(5) default NULL,
  `pcs_icd10_target` varchar(7) default NULL,
  `flags` varchar(5) default NULL,
  `active` tinyint default 0,
  `revision` int default 0
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `icd10_gem_pcs_10_9`
--

DROP TABLE IF EXISTS `icd10_gem_pcs_10_9`;
CREATE TABLE `icd10_gem_pcs_10_9` (
  `map_id` SERIAL,
  `pcs_icd10_source` varchar(7) default NULL,
  `pcs_icd9_target` varchar(5) default NULL,
  `flags` varchar(5) default NULL,
  `active` tinyint default 0,
  `revision` int default 0
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `icd10_gem_dx_9_10`
--

DROP TABLE IF EXISTS `icd10_gem_dx_9_10`;
CREATE TABLE `icd10_gem_dx_9_10` (
  `map_id` SERIAL,
  `dx_icd9_source` varchar(5) default NULL,
  `dx_icd10_target` varchar(7) default NULL,
  `flags` varchar(5) default NULL,
  `active` tinyint default 0,
  `revision` int default 0
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `icd10_gem_dx_10_9`
--

DROP TABLE IF EXISTS `icd10_gem_dx_10_9`;
CREATE TABLE `icd10_gem_dx_10_9` (
  `map_id` SERIAL,
  `dx_icd10_source` varchar(7) default NULL,
  `dx_icd9_target` varchar(5) default NULL,
  `flags` varchar(5) default NULL,
  `active` tinyint default 0,
  `revision` int default 0
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `icd10_reimbr_dx_9_10`
--

DROP TABLE IF EXISTS `icd10_reimbr_dx_9_10`;
CREATE TABLE `icd10_reimbr_dx_9_10` (
  `map_id` SERIAL,
  `code`        varchar(8),
  `code_cnt`    tinyint,
  `ICD9_01`     varchar(5),
  `ICD9_02`     varchar(5),
  `ICD9_03`     varchar(5),
  `ICD9_04`     varchar(5),
  `ICD9_05`     varchar(5),
  `ICD9_06`     varchar(5),
  `active` tinyint default 0,
  `revision` int default 0
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `icd10_reimbr_pcs_9_10`
--

DROP TABLE IF EXISTS `icd10_reimbr_pcs_9_10`;
CREATE TABLE `icd10_reimbr_pcs_9_10` (
  `map_id`      SERIAL,
  `code`        varchar(8),
  `code_cnt`    tinyint,
  `ICD9_01`     varchar(5),
  `ICD9_02`     varchar(5),
  `ICD9_03`     varchar(5),
  `ICD9_04`     varchar(5),
  `ICD9_05`     varchar(5),
  `ICD9_06`     varchar(5),
  `active` tinyint default 0,
  `revision` int default 0
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `immunizations`
-- 

DROP TABLE IF EXISTS `immunizations`;
CREATE TABLE `immunizations` (
  `id` bigint(20) NOT NULL auto_increment,
  `patient_id` int(11) default NULL,
  `administered_date` datetime default NULL,
  `immunization_id` int(11) default NULL,
  `cvx_code` int(11) default NULL,
  `manufacturer` varchar(100) default NULL,
  `lot_number` varchar(50) default NULL,
  `administered_by_id` bigint(20) default NULL,
  `administered_by` VARCHAR( 255 ) default NULL COMMENT 'Alternative to administered_by_id',
  `education_date` date default NULL,
  `vis_date` date default NULL COMMENT 'Date of VIS Statement', 
  `note` text,
  `create_date` datetime default NULL,
  `update_date` timestamp NOT NULL,
  `created_by` bigint(20) default NULL,
  `updated_by` bigint(20) default NULL,
  `amount_administered` int(11) DEFAULT NULL,			
  `amount_administered_unit` varchar(50) DEFAULT NULL,			
  `expiration_date` date DEFAULT NULL,			
  `route` varchar(100) DEFAULT NULL,			
  `administration_site` varchar(100) DEFAULT NULL,			
  `added_erroneously` tinyint(1) NOT NULL DEFAULT '0',  
  PRIMARY KEY  (`id`),
  KEY `patient_id` (`patient_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `insurance_companies`
-- 

DROP TABLE IF EXISTS `insurance_companies`;
CREATE TABLE `insurance_companies` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(255) default NULL,
  `attn` varchar(255) default NULL,
  `cms_id` varchar(15) default NULL,
  `freeb_type` tinyint(2) default NULL,
  `x12_receiver_id` varchar(25) default NULL,
  `x12_default_partner_id` int(11) default NULL,
  `alt_cms_id` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `insurance_data`
-- 

DROP TABLE IF EXISTS `insurance_data`;
CREATE TABLE `insurance_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `type` enum('primary','secondary','tertiary') default NULL,
  `provider` varchar(255) default NULL,
  `plan_name` varchar(255) default NULL,
  `policy_number` varchar(255) default NULL,
  `group_number` varchar(255) default NULL,
  `subscriber_lname` varchar(255) default NULL,
  `subscriber_mname` varchar(255) default NULL,
  `subscriber_fname` varchar(255) default NULL,
  `subscriber_relationship` varchar(255) default NULL,
  `subscriber_ss` varchar(255) default NULL,
  `subscriber_DOB` date default NULL,
  `subscriber_street` varchar(255) default NULL,
  `subscriber_postal_code` varchar(255) default NULL,
  `subscriber_city` varchar(255) default NULL,
  `subscriber_state` varchar(255) default NULL,
  `subscriber_country` varchar(255) default NULL,
  `subscriber_phone` varchar(255) default NULL,
  `subscriber_employer` varchar(255) default NULL,
  `subscriber_employer_street` varchar(255) default NULL,
  `subscriber_employer_postal_code` varchar(255) default NULL,
  `subscriber_employer_state` varchar(255) default NULL,
  `subscriber_employer_country` varchar(255) default NULL,
  `subscriber_employer_city` varchar(255) default NULL,
  `copay` varchar(255) default NULL,
  `date` date default NULL,
  `pid` bigint(20) NOT NULL default '0',
  `subscriber_sex` varchar(25) default NULL,
  `accept_assignment` varchar(5) NOT NULL DEFAULT 'TRUE',
  `policy_type` varchar(25) NOT NULL default '',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `pid_type_date` (`pid`,`type`,`date`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `insurance_numbers`
-- 

DROP TABLE IF EXISTS `insurance_numbers`;
CREATE TABLE `insurance_numbers` (
  `id` int(11) NOT NULL default '0',
  `provider_id` int(11) NOT NULL default '0',
  `insurance_company_id` int(11) default NULL,
  `provider_number` varchar(20) default NULL,
  `rendering_provider_number` varchar(20) default NULL,
  `group_number` varchar(20) default NULL,
  `provider_number_type` varchar(4) default NULL,
  `rendering_provider_number_type` varchar(4) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `integration_mapping`
-- 

DROP TABLE IF EXISTS `integration_mapping`;
CREATE TABLE `integration_mapping` (
  `id` int(11) NOT NULL default '0',
  `foreign_id` int(11) NOT NULL default '0',
  `foreign_table` varchar(125) default NULL,
  `local_id` int(11) NOT NULL default '0',
  `local_table` varchar(125) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `foreign_id` (`foreign_id`,`foreign_table`,`local_id`,`local_table`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `issue_encounter`
-- 

DROP TABLE IF EXISTS `issue_encounter`;
CREATE TABLE `issue_encounter` (
  `pid` int(11) NOT NULL,
  `list_id` int(11) NOT NULL,
  `encounter` int(11) NOT NULL,
  `resolved` tinyint(1) NOT NULL,
  PRIMARY KEY  (`pid`,`list_id`,`encounter`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `issue_types`
--

DROP TABLE IF EXISTS `issue_types`;
CREATE TABLE `issue_types` (
    `active` tinyint(1) NOT NULL DEFAULT '1',
    `category` varchar(75) NOT NULL DEFAULT '',
    `type` varchar(75) NOT NULL DEFAULT '',
    `plural` varchar(75) NOT NULL DEFAULT '',
    `singular` varchar(75) NOT NULL DEFAULT '',
    `abbreviation` varchar(75) NOT NULL DEFAULT '',
    `style` smallint(6) NOT NULL DEFAULT '0',
    `force_show` smallint(6) NOT NULL DEFAULT '0',
    `ordering` int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`category`,`type`)
) ENGINE=MyISAM;

--
-- Dumping data for table `issue_types`
--

INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('10','default','medical_problem','Medical Problems','Problem','P','0','1');
INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('30','default','medication','Medications','Medication','M','0','1');
INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('20','default','allergy','Allergies','Allergy','A','0','1');
INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('40','default','surgery','Surgeries','Surgery','S','0','0');
INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('50','default','dental','Dental Issues','Dental','D','0','0');
INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('10','athletic_team','football_injury','Football Injuries','Injury','I','2','1');
INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('20','athletic_team','medical_problem','Medical Problems','Medical','P','0','0');
INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('30','athletic_team','allergy','Allergies','Allergy','A','1','0');
INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('40','athletic_team','general','General','General','G','1','0');
INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('10','ippf_specific','medical_problem','Medical Problems','Problem','P','0','1');
INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('30','ippf_specific','medication','Medications','Medication','M','0','1');
INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('20','ippf_specific','allergy','Allergies','Allergy','Y','0','1');
INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('40','ippf_specific','surgery','Surgeries','Surgery','S','0','0');
INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('50','ippf_specific','ippf_gcac','Abortions','Abortion','A','3','0');
INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('60','ippf_specific','contraceptive','Contraception','Contraception','C','4','0');
INSERT INTO issue_types(`ordering`,`category`,`type`,`plural`,`singular`,`abbreviation`,`style`,`force_show`) VALUES ('65','ippf_specific','cervical_cancer','Cervical Cancer','Cervical Cancer','CC','0','0');
-- --------------------------------------------------------

-- 
-- Table structure for table `lang_constants`
-- 

DROP TABLE IF EXISTS `lang_constants`;
CREATE TABLE `lang_constants` (
  `cons_id` int(11) NOT NULL auto_increment,
  `constant_name` mediumtext BINARY NOT NULL DEFAULT '',
  UNIQUE KEY `cons_id` (`cons_id`),
  KEY `constant_name` (`constant_name`(100))
) ENGINE=MyISAM ;

-- 
-- Table structure for table `lang_definitions`
-- 

DROP TABLE IF EXISTS `lang_definitions`;
CREATE TABLE `lang_definitions` (
  `def_id` int(11) NOT NULL auto_increment,
  `cons_id` int(11) NOT NULL default '0',
  `lang_id` int(11) NOT NULL default '0',
  `definition` mediumtext,
  UNIQUE KEY `def_id` (`def_id`),
  KEY `cons_lang` (`cons_id`, `lang_id`)
) ENGINE=MyISAM ;

-- 
-- Table structure for table `lang_languages`
-- 

DROP TABLE IF EXISTS `lang_languages`;
CREATE TABLE `lang_languages` (
  `lang_id` int(11) NOT NULL auto_increment,
  `lang_code` char(2) NOT NULL default '',
  `lang_description` varchar(100) default NULL,
  `lang_is_rtl` TINYINT DEFAULT 0 COMMENT 'Set this to 1 for RTL languages Arabic, Farsi, Hebrew, Urdu etc.',
  UNIQUE KEY `lang_id` (`lang_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 ;

-- 
-- Dumping data for table `lang_languages`
-- 

INSERT INTO `lang_languages` VALUES (1, 'en', 'English', 0);

-- --------------------------------------------------------

--
-- Table structure for table `lang_custom`
--

DROP TABLE IF EXISTS `lang_custom`;
CREATE TABLE `lang_custom` (
  `lang_description` varchar(100) NOT NULL default '',
  `lang_code` char(2) NOT NULL default '',
  `constant_name` mediumtext BINARY NOT NULL default '',
  `definition` mediumtext NOT NULL default ''
) ENGINE=MyISAM ;

-- --------------------------------------------------------

CREATE TABLE `layout_group_properties` (
  grp_form_id     varchar(31)    not null,
  grp_group_id    varchar(31)    not null default '' comment 'empty when representing the whole form',
  grp_title       varchar(63)    not null default '' comment 'descriptive name of the form or group',
  grp_subtitle    varchar(63)    not null default '' comment 'for display under the title',
  grp_mapping     varchar(31)    not null default '' comment 'the form category',
  grp_seq         int(11)        not null default 0  comment 'optional order within mapping',
  grp_activity    tinyint(1)     not null default 1,
  grp_repeats     int(11)        not null default 0,
  grp_columns     int(11)        not null default 0,
  grp_size        int(11)        not null default 0,
  grp_issue_type  varchar(75)    not null default '',
  grp_aco_spec    varchar(63)    not null default '',
  grp_save_close  tinyint(1)     not null default 0,
  grp_init_open   tinyint(1)     not null default 0,
  grp_services    varchar(4095)  not null default '',
  grp_products    varchar(4095)  not null default '',
  grp_diags       varchar(4095)  not null default '',
  PRIMARY KEY (grp_form_id, grp_group_id)
) ENGINE=MyISAM;

-- 
-- Table structure for table `layout_options`
-- 

DROP TABLE IF EXISTS `layout_options`;
CREATE TABLE `layout_options` (
  `form_id` varchar(31) NOT NULL default '',
  `field_id` varchar(31) NOT NULL default '',
  `group_id` varchar(31) NOT NULL default '',
  `title` varchar(63) NOT NULL default '',
  `seq` int(11) NOT NULL default '0',
  `data_type` tinyint(3) NOT NULL default '0',
  `uor` tinyint(1) NOT NULL default '1',
  `fld_length` int(11) NOT NULL default '15',
  `max_length` int(11) NOT NULL default '0',
  `list_id` varchar(31) NOT NULL default '',
  `titlecols` tinyint(3) NOT NULL default '1',
  `datacols` tinyint(3) NOT NULL default '1',
  `default_value` varchar(255) NOT NULL default '',
  `edit_options` varchar(36) NOT NULL default '',
  `description` text,
  `fld_rows` int(11) NOT NULL default '0',
  `source` char(1) NOT NULL default 'F' COMMENT 'F=Form, D=Demographics, H=History, E=Encounter',
  `conditions` text NOT NULL DEFAULT '' COMMENT 'serialized array of skip conditions',
  PRIMARY KEY  (`form_id`,`field_id`,`seq`)
) ENGINE=MyISAM;

INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('DEM', '' , 'Demographics', 'Core');
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('DEM', '1', 'Who'         , ''    );
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('DEM', '2', 'Contact'     , ''    );
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('DEM', '3', 'Choices'     , ''    );
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('DEM', '4', 'Employer'    , ''    );
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('DEM', '5', 'Stats'       , ''    );
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('DEM', '6', 'Misc'        , ''    );
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'home_facility', '1', 'Home Facility', 0, 35, 2, 0, 0, '', 1, 1, '0', '', 'Default facility', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'title', '1', 'Name', 1, 1, 1, 0, 0, 'titles', 1, 1, '', 'N', 'Title', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'fname', '1', '', 2, 2, 2, 10, 63, '', 0, 0, '', 'CD', 'First Name', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'mname', '1', '', 3, 2, 1, 2, 63, '', 0, 0, '', 'C', 'Middle Name', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'lname', '1', '', 4, 2, 2, 10, 63, '', 0, 0, '', 'CD', 'Last Name', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'prefname', '1', '', 4, 2, 0, 15, 50, '', 1, 1, '', '', '', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'pubpid', '1', 'External ID', 5, 2, 1, 10, 15, '', 1, 1, '', 'ND', 'External identifier', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'DOB', '1', 'DOB', 6, 4, 2, 10, 10, '', 1, 1, '', 'D', 'Date of Birth', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'sex', '1', 'Sex', 7, 1, 2, 0, 0, 'sex', 1, 1, '', 'N', 'Sex', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'gender', '1', 'Gender', 8, 1, 1, 0, 0, 'Gender', 1, 1, '', 'N', '', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'sexual_orientation', '1', 'Sexual Orientation', 8, 1, 1, 0, 0, 'Sexual_Orientation', 1, 1, '', 'N', '', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'ss', '1', 'S.S.', 8, 2, 1, 11, 11, '', 1, 1, '', '', 'Social Security Number', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'drivers_license', '1', 'License/ID', 9, 2, 1, 15, 63, '', 1, 1, '', '', 'Drivers License or State ID', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'status', '1', 'Marital Status', 10, 1, 1, 0, 0, 'marital', 1, 3, '', '', 'Marital Status', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'genericname1', '1', 'User Defined', 11, 2, 1, 15, 63, '', 1, 3, '', '', 'User Defined Field', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'genericval1', '1', '', 12, 2, 1, 15, 63, '', 0, 0, '', '', 'User Defined Field', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'genericname2', '1', '', 13, 2, 1, 15, 63, '', 0, 0, '', '', 'User Defined Field', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'genericval2', '1', '', 14, 2, 1, 15, 63, '', 0, 0, '', '', 'User Defined Field', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'squad', '1', 'Squad', 15, 13, 0, 0, 0, '', 1, 3, '', '', 'Squad Membership', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'pricelevel', '1', 'Price Level', 16, 1, 0, 0, 0, 'pricelevel', 1, 1, '', '', 'Discount Level', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'street', '2', 'Address', 1, 2, 1, 25, 63, '', 1, 1, '', 'C', 'Street and Number', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'city', '2', 'City', 2, 2, 1, 15, 63, '', 1, 1, '', 'C', 'City Name', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'state', '2', 'State', 3, 26, 1, 0, 0, 'state', 1, 1, '', '', 'State/Locality', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'postal_code', '2', 'Postal Code', 4, 2, 1, 6, 63, '', 1, 1, '', '', 'Postal Code', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'country_code', '2', 'Country', 5, 26, 1, 0, 0, 'country', 1, 1, '', '', 'Country', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'mothersname', '2', 'Mother''s Name', 6, 2, 1, 20, 63, '', 1, 1, '', '', '', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'guardiansname', '2', 'Guardian''s Name', 7, 2, 1, 20, 63, '', 1, 1, '', '', '', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'contact_relationship', '2', 'Emergency Contact', 8, 2, 1, 10, 63, '', 1, 1, '', 'C', 'Emergency Contact Person', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'phone_contact', '2', 'Emergency Phone', 9, 2, 1, 20, 63, '', 1, 1, '', 'P', 'Emergency Contact Phone Number', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'phone_home', '2', 'Home Phone', 10, 2, 1, 20, 63, '', 1, 1, '', 'P', 'Home Phone Number', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'phone_biz', '2', 'Work Phone', 11, 2, 1, 20, 63, '', 1, 1, '', 'P', 'Work Phone Number', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'phone_cell', '2', 'Mobile Phone', 12, 2, 1, 20, 63, '', 1, 1, '', 'P', 'Cell Phone Number', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'email', '2', 'Contact Email', 13, 2, 1, 30, 95, '', 1, 1, '', '', 'Contact Email Address', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'email_direct', '2', 'Trusted Email', 14, 2, 1, 30, 95, '', 1, 1, '', '', 'Trusted Direct Email Address', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'providerID', '3', 'Provider', 1, 11, 1, 0, 0, '', 1, 3, '', '', 'Provider', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'ref_providerID', '3', 'Referring Provider', 2, 11, 1, 0, 0, '', 1, 3, '', '', 'Referring Provider', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'pharmacy_id', '3', 'Pharmacy', 3, 12, 1, 0, 0, '', 1, 3, '', '', 'Preferred Pharmacy', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'hipaa_notice', '3', 'HIPAA Notice Received', 4, 1, 1, 0, 0, 'yesno', 1, 1, '', '', 'Did you receive a copy of the HIPAA Notice?', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'hipaa_voice', '3', 'Allow Voice Message', 5, 1, 1, 0, 0, 'yesno', 1, 1, '', '', 'Allow telephone messages?', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'hipaa_message', '3', 'Leave Message With', 6, 2, 1, 20, 63, '', 1, 1, '', '', 'With whom may we leave a message?', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'hipaa_mail', '3', 'Allow Mail Message', 7, 1, 1, 0, 0, 'yesno', 1, 1, '', '', 'Allow email messages?', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'hipaa_allowsms'  , '3', 'Allow SMS'  , 8, 1, 1, 0, 0, 'yesno', 1, 1, '', '', 'Allow SMS (text messages)?', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'hipaa_allowemail', '3', 'Allow Email', 9, 1, 1, 0, 0, 'yesno', 1, 1, '', '', 'Allow Email?', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'allow_imm_reg_use', '3', 'Allow Immunization Registry Use', 10, 1, 1, 0, 0, 'yesno', 1, 1, '', '', '', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'allow_imm_info_share', '3', 'Allow Immunization Info Sharing', 11, 1, 1, 0, 0, 'yesno', 1, 1, '', '', '', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'allow_health_info_ex', '3', 'Allow Health Information Exchange', 12, 1, 1, 0, 0, 'yesno', 1, 1, '', '', '', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'allow_patient_portal', '3', 'Allow Patient Portal', 13, 1, 1, 0, 0, 'yesno', 1, 1, '', '', '', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'occupation', '4', 'Occupation', 1, 2, 1, 20, 63, '', 1, 1, '', 'C', 'Occupation', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'em_name', '4', 'Employer Name', 2, 2, 1, 20, 63, '', 1, 1, '', 'C', 'Employer Name', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'em_street', '4', 'Employer Address', 3, 2, 1, 25, 63, '', 1, 1, '', 'C', 'Street and Number', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'em_city', '4', 'City', 4, 2, 1, 15, 63, '', 1, 1, '', 'C', 'City Name', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'em_state', '4', 'State', 5, 26, 1, 0, 0, 'state', 1, 1, '', '', 'State/Locality', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'em_postal_code', '4', 'Postal Code', 6, 2, 1, 6, 63, '', 1, 1, '', '', 'Postal Code', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'em_country', '4', 'Country', 7, 26, 1, 0, 0, 'country', 1, 1, '', '', 'Country', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'language', '5', 'Language', 1, 26, 1, 0, 0, 'language', 1, 1, '', '', 'Preferred Language', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'ethnicity', '5', 'Ethnicity', 2, 33, 1, 0, 0, 'ethnicity', 1, 1, '', '', 'Ethnicity', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'race', '5', 'Race', 3, 33, 1, 0, 0, 'race', 1, 1, '', '', 'Race', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'financial_review', '5', 'Financial Review Date', 4, 2, 1, 10, 20, '', 1, 1, '', 'D', 'Financial Review Date', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'family_size', '5', 'Family Size', 4, 2, 1, 20, 63, '', 1, 1, '', '', 'Family Size', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'monthly_income', '5', 'Monthly Income', 5, 2, 1, 20, 63, '', 1, 1, '', '', 'Monthly Income', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'homeless', '5', 'Homeless, etc.', 6, 2, 1, 20, 63, '', 1, 1, '', '', 'Homeless or similar?', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'interpretter', '5', 'Interpreter', 7, 2, 1, 20, 63, '', 1, 1, '', '', 'Interpreter needed?', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'migrantseasonal', '5', 'Migrant/Seasonal', 8, 2, 1, 20, 63, '', 1, 1, '', '', 'Migrant or seasonal worker?', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'contrastart', '5', 'Contraceptives Start',9,4,0,10,10,'',1,1,'','','Date contraceptive services initially provided', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'referral_source', '5', 'Referral Source',10, 26, 1, 0, 0, 'refsource', 1, 1, '', '', 'How did they hear about us', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'vfc', '5', 'VFC', 12, 1, 1, 20, 0, 'eligibility', 1, 1, '', '', 'Eligibility status for Vaccine for Children supplied vaccine', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'deceased_date', '6', 'Date Deceased', 1, 4, 1, 20, 20, '', 1, 3, '', 'D', 'If person is deceased, then enter date of death.', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'deceased_reason', '6', 'Reason Deceased', 2, 2, 1, 30, 255, '', 1, 3, '', '', 'Reason for Death', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'usertext1', '6', 'User Defined Text 1', 3, 2, 0, 10, 63, '', 1, 1, '', '', 'User Defined', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'usertext2', '6', 'User Defined Text 2', 4, 2, 0, 10, 63, '', 1, 1, '', '', 'User Defined', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'usertext3', '6', 'User Defined Text 3', 5,2,0,10,63,'',1,1,'','','User Defined', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'usertext4', '6', 'User Defined Text 4', 6,2,0,10,63,'',1,1,'','','User Defined', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'usertext5', '6', 'User Defined Text 5', 7,2,0,10,63,'',1,1,'','','User Defined', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'usertext6', '6', 'User Defined Text 6', 8,2,0,10,63,'',1,1,'','','User Defined', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'usertext7', '6', 'User Defined Text 7', 9,2,0,10,63,'',1,1,'','','User Defined', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'usertext8', '6', 'User Defined Text 8',10,2,0,10,63,'',1,1,'','','User Defined', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'userlist1', '6', 'User Defined List 1',11, 1, 0, 0, 0, 'userlist1', 1, 1, '', '', 'User Defined', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'userlist2', '6', 'User Defined List 2',12, 1, 0, 0, 0, 'userlist2', 1, 1, '', '', 'User Defined', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'userlist3', '6', 'User Defined List 3',13, 1, 0, 0, 0, 'userlist3', 1, 1, '', '' , 'User Defined', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'userlist4', '6', 'User Defined List 4',14, 1, 0, 0, 0, 'userlist4', 1, 1, '', '' , 'User Defined', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'userlist5', '6', 'User Defined List 5',15, 1, 0, 0, 0, 'userlist5', 1, 1, '', '' , 'User Defined', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'userlist6', '6', 'User Defined List 6',16, 1, 0, 0, 0, 'userlist6', 1, 1, '', '' , 'User Defined', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'userlist7', '6', 'User Defined List 7',17, 1, 0, 0, 0, 'userlist7', 1, 1, '', '' , 'User Defined', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('DEM', 'regdate'  , '6', 'Registration Date'  ,18, 4, 0,10,10, ''         , 1, 1, '', 'D', 'Start Date at This Clinic', 0);

INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('LBTptreq', '' , 'Patient Request', 'Transactions');
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('LBTptreq', '1', ''               , ''    );
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('LBTptreq','body','1','Details',10,3,2,30,0,'',1,3,'','','Content',5);

INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('LBTphreq', '' , 'Physician Request', 'Transactions');
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('LBTphreq', '1', ''                 , ''    );
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('LBTphreq','body','1','Details',10,3,2,30,0,'',1,3,'','','Content',5);

INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('LBTlegal', '' , 'Legal', 'Transactions');
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('LBTlegal', '1', ''     , ''    );
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('LBTlegal','body','1','Details',10,3,2,30,0,'',1,3,'','','Content',5);

INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('LBTbill', '' , 'Billing', 'Transactions');
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('LBTbill', '1', ''       , ''    );
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('LBTbill' ,'body','1','Details',10,3,2,30,0,'',1,3,'','','Content',5);

INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('HIS', '' , 'History'       , 'Core');
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('HIS', '1', 'General'       , ''    );
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('HIS', '2', 'Family History', ''    );
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('HIS', '3', 'Relatives'     , ''    );
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('HIS', '4', 'Lifestyle'     , ''    );
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('HIS', '5', 'Other'         , ''    );
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','usertext11','1','Risk Factors',1,21,1,0,0,'riskfactors',1,1,'','' ,'Risk Factors', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','exams'     ,'1','Exams/Tests' ,2,23,1,0,0,'exams'      ,1,1,'','' ,'Exam and test results', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','history_father'   ,'2','Father'   ,1, 2,1,20,0,'',1,1,'','' ,'', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','history_mother'   ,'2','Mother'   ,2, 2,1,20,0,'',1,1,'','' ,'', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','history_siblings' ,'2','Siblings' ,3, 2,1,20,0,'',1,1,'','' ,'', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','history_spouse'   ,'2','Spouse'   ,4, 2,1,20,0,'',1,1,'','' ,'', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','history_offspring','2','Offspring',5, 2,1,20,0,'',1,3,'','' ,'', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','relatives_cancer'             ,'3','Cancer'             ,1, 2,1,20,0,'',1,1,'','' ,'', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','relatives_tuberculosis'       ,'3','Tuberculosis'       ,2, 2,1,20,0,'',1,1,'','' ,'', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','relatives_diabetes'           ,'3','Diabetes'           ,3, 2,1,20,0,'',1,1,'','' ,'', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','relatives_high_blood_pressure','3','High Blood Pressure',4, 2,1,20,0,'',1,1,'','' ,'', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','relatives_heart_problems'     ,'3','Heart Problems'     ,5, 2,1,20,0,'',1,1,'','' ,'', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','relatives_stroke'             ,'3','Stroke'             ,6, 2,1,20,0,'',1,1,'','' ,'', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','relatives_epilepsy'           ,'3','Epilepsy'           ,7, 2,1,20,0,'',1,1,'','' ,'', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','relatives_mental_illness'     ,'3','Mental Illness'     ,8, 2,1,20,0,'',1,1,'','' ,'', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','relatives_suicide'            ,'3','Suicide'            ,9, 2,1,20,0,'',1,3,'','' ,'', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','coffee'              ,'4','Coffee'              ,2,28,1,20,0,'',1,3,'','' ,'Caffeine consumption', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','tobacco'             ,'4','Tobacco'             ,1,32,1,0,0,'smoking_status',1,3,'','' ,'Tobacco use', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','alcohol'             ,'4','Alcohol'             ,3,28,1,20,0,'',1,3,'','' ,'Alcohol consumption', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','recreational_drugs'  ,'4','Recreational Drugs'  ,4,28,1,20,0,'',1,3,'','' ,'Recreational drug use', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','counseling'          ,'4','Counseling'          ,5,28,1,20,0,'',1,3,'','' ,'Counseling activities', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','exercise_patterns'   ,'4','Exercise Patterns'   ,6,28,1,20,0,'',1,3,'','' ,'Exercise patterns', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','hazardous_activities','4','Hazardous Activities',7,28,1,20,0,'',1,3,'','' ,'Hazardous activities', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','sleep_patterns'      ,'4','Sleep Patterns'      ,8, 2,1,20,0,'',1,3,'','' ,'Sleep patterns', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','seatbelt_use'        ,'4','Seatbelt Use'        ,9, 2,1,20,0,'',1,3,'','' ,'Seatbelt use', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','name_1'            ,'5','Name/Value'        ,1, 2,1,10,255,'',1,1,'','' ,'Name 1', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','value_1'           ,'5',''                  ,2, 2,1,10,255,'',0,0,'','' ,'Value 1', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','name_2'            ,'5','Name/Value'        ,3, 2,1,10,255,'',1,1,'','' ,'Name 2', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','value_2'           ,'5',''                  ,4, 2,1,10,255,'',0,0,'','' ,'Value 2', 0);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','additional_history','5','Additional History',5, 3,1,30,  0,'',1,3,'' ,'' ,'Additional history notes', 3);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','userarea11'        ,'5','User Defined Area 11',6,3,0,30,0,'',1,3,'','','User Defined', 3);
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('HIS','userarea12'        ,'5','User Defined Area 12',7,3,0,30,0,'',1,3,'','','User Defined', 3);

INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('FACUSR', '' , 'Facility Specific User Information', 'Core');
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('FACUSR', '1', 'General'                           , ''    );
INSERT INTO `layout_options` (`form_id`,`field_id`,`group_id`,`title`,`seq`,`data_type`,`uor`,`fld_length`,`max_length`,`list_id`,`titlecols`,`datacols`,`default_value`,`edit_options`,`description`,`fld_rows`) VALUES ('FACUSR', 'provider_id', '1', 'Provider ID', 1, 2, 1, 15, 63, '', 1, 1, '', '', 'Provider ID at Specified Facility', 0);

-- --------------------------------------------------------

-- 
-- Table structure for table `list_options`
-- 

DROP TABLE IF EXISTS `list_options`;
CREATE TABLE `list_options` (
  `list_id` varchar(31) NOT NULL default '',
  `option_id` varchar(31) NOT NULL default '',
  `title` varchar(255) NOT NULL default '',
  `seq` int(11) NOT NULL default '0',
  `is_default` tinyint(1) NOT NULL default '0',
  `option_value` float NOT NULL default '0',
  `mapping` varchar(31) NOT NULL DEFAULT '',
  `notes` varchar(4095) NOT NULL DEFAULT '',
  `codes` varchar(255) NOT NULL DEFAULT '',
  `activity` TINYINT DEFAULT 1 NOT NULL,
  `toggle_setting_1` tinyint(1) NOT NULL default '0',
  `toggle_setting_2` tinyint(1) NOT NULL default '0',  
  PRIMARY KEY  (`list_id`,`option_id`)
) ENGINE=MyISAM;

-- 
-- Dumping data for table `list_options`
-- 

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('yesno', 'NO', 'NO', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('yesno', 'YES', 'YES', 2, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('titles', 'Mr.', 'Mr.', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('titles', 'Mrs.', 'Mrs.', 2, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('titles', 'Ms.', 'Ms.', 3, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('titles', 'Dr.', 'Dr.', 4, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('sex', 'Female', 'Female', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('sex', 'Male', 'Male', 2, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('marital', 'married', 'Married', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('marital', 'single', 'Single', 2, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('marital', 'divorced', 'Divorced', 3, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('marital', 'widowed', 'Widowed', 4, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('marital', 'separated', 'Separated', 5, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('marital', 'domestic partner', 'Domestic Partner', 6, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'armenian', 'Armenian', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'chinese', 'Chinese', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'danish', 'Danish', 30, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'deaf', 'Deaf', 40, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'English', 'English', 50, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'farsi', 'Farsi', 60, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'french', 'French', 70, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'german', 'German', 80, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'greek', 'Greek', 90, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'hmong', 'Hmong', 100, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'italian', 'Italian', 110, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'japanese', 'Japanese', 120, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'korean', 'Korean', 130, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'laotian', 'Laotian', 140, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'mien', 'Mien', 150, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'norwegian', 'Norwegian', 160, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'othrs', 'Others', 170, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'portuguese', 'Portuguese', 180, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'punjabi', 'Punjabi', 190, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'russian', 'Russian', 200, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'Spanish', 'Spanish', 210, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'tagalog', 'Tagalog', 220, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'turkish', 'Turkish', 230, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'vietnamese', 'Vietnamese', 240, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'yiddish', 'Yiddish', 250, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('language', 'zulu', 'Zulu', 260, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'aleut', 'ALEUT', 10,  0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'amer_indian', 'American Indian', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'Asian', 'Asian', 30, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'Black', 'Black', 40, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'cambodian', 'Cambodian', 50, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'Caucasian', 'Caucasian', 60, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'cs_american', 'Central/South American', 70, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'chinese', 'Chinese', 80, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'cuban', 'Cuban', 90, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'eskimo', 'Eskimo', 100, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'filipino', 'Filipino', 110, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'guamanian', 'Guamanian', 120, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'hawaiian', 'Hawaiian', 130, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'Hispanic', 'Hispanic', 140, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'othr_us', 'Hispanic - Other (Born in US)', 150, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'othr_non_us', 'Hispanic - Other (Born outside US)', 160, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'hmong', 'Hmong', 170, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'indian', 'Indian', 180, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'japanese', 'Japanese', 190, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'korean', 'Korean', 200, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'laotian', 'Laotian', 210, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'mexican', 'Mexican/MexAmer/Chicano', 220, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'mlt-race', 'Multiracial', 230, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'othr', 'Other', 240, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'othr_spec', 'Other - Specified', 250, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'pac_island', 'Pacific Islander', 260, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'puerto_rican', 'Puerto Rican', 270, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'refused', 'Refused To State', 280, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'samoan', 'Samoan', 290, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'spec', 'Specified', 300, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'thai', 'Thai', 310, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'unknown', 'Unknown', 320, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'unspec', 'Unspecified', 330, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'vietnamese', 'Vietnamese', 340, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'white', 'White', 350, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethrace', 'withheld', 'Withheld', 360, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('userlist1', 'sample', 'Sample', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('userlist2', 'sample', 'Sample', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('userlist3','sample','Sample',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('userlist4','sample','Sample',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('userlist5','sample','Sample',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('userlist6','sample','Sample',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('userlist7','sample','Sample',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('pricelevel', 'standard', 'Standard', 1, 1);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('risklevel', 'low', 'Low', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('risklevel', 'medium', 'Medium', 2, 1);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('risklevel', 'high', 'High', 3, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('boolean', '0', 'No', 1, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('boolean', '1', 'Yes', 2, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('country', 'USA', 'USA', 1, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','AL','Alabama'             , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','AK','Alaska'              , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','AZ','Arizona'             , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','AR','Arkansas'            , 4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','CA','California'          , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','CO','Colorado'            , 6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','CT','Connecticut'         , 7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','DE','Delaware'            , 8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','DC','District of Columbia', 9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','FL','Florida'             ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','GA','Georgia'             ,11,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','HI','Hawaii'              ,12,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','ID','Idaho'               ,13,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','IL','Illinois'            ,14,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','IN','Indiana'             ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','IA','Iowa'                ,16,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','KS','Kansas'              ,17,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','KY','Kentucky'            ,18,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','LA','Louisiana'           ,19,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','ME','Maine'               ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','MD','Maryland'            ,21,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','MA','Massachusetts'       ,22,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','MI','Michigan'            ,23,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','MN','Minnesota'           ,24,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','MS','Mississippi'         ,25,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','MO','Missouri'            ,26,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','MT','Montana'             ,27,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','NE','Nebraska'            ,28,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','NV','Nevada'              ,29,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','NH','New Hampshire'       ,30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','NJ','New Jersey'          ,31,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','NM','New Mexico'          ,32,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','NY','New York'            ,33,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','NC','North Carolina'      ,34,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','ND','North Dakota'        ,35,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','OH','Ohio'                ,36,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','OK','Oklahoma'            ,37,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','OR','Oregon'              ,38,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','PA','Pennsylvania'        ,39,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','RI','Rhode Island'        ,40,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','SC','South Carolina'      ,41,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','SD','South Dakota'        ,42,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','TN','Tennessee'           ,43,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','TX','Texas'               ,44,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','UT','Utah'                ,45,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','VT','Vermont'             ,46,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','VA','Virginia'            ,47,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','WA','Washington'          ,48,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','WV','West Virginia'       ,49,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','WI','Wisconsin'           ,50,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('state','WY','Wyoming'             ,51,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Patient'      ,'Patient'      , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Employee'     ,'Employee'     , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Walk-In'      ,'Walk-In'      , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Newspaper'    ,'Newspaper'    , 4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Radio'        ,'Radio'        , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','T.V.'         ,'T.V.'         , 6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Direct Mail'  ,'Direct Mail'  , 7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Coupon'       ,'Coupon'       , 8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Referral Card','Referral Card', 9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('refsource','Other'        ,'Other'        ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','vv' ,'Varicose Veins'                      , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','ht' ,'Hypertension'                        , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','db' ,'Diabetes'                            , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','sc' ,'Sickle Cell'                         , 4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','fib','Fibroids'                            , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','pid','PID (Pelvic Inflammatory Disease)'   , 6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','mig','Severe Migraine'                     , 7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','hd' ,'Heart Disease'                       , 8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','str','Thrombosis/Stroke'                   , 9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','hep','Hepatitis'                           ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','gb' ,'Gall Bladder Condition'              ,11,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','br' ,'Breast Disease'                      ,12,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','dpr','Depression'                          ,13,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','all','Allergies'                           ,14,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','inf','Infertility'                         ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','ast','Asthma'                              ,16,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','ep' ,'Epilepsy'                            ,17,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','cl' ,'Contact Lenses'                      ,18,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','coc','Contraceptive Complication (specify)',19,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('riskfactors','oth','Other (specify)'                     ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'brs','Breast Exam'          , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'cec','Cardiac Echo'         , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'ecg','ECG'                  , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'gyn','Gynecological Exam'   , 4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'mam','Mammogram'            , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'phy','Physical Exam'        , 6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'pro','Prostate Exam'        , 7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'rec','Rectal Exam'          , 8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'sic','Sigmoid/Colonoscopy'  , 9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'ret','Retinal Exam'         ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'flu','Flu Vaccination'      ,11,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'pne','Pneumonia Vaccination',12,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'ldl','LDL'                  ,13,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'hem','Hemoglobin'           ,14,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('exams' ,'psa','PSA'                  ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','0',''           ,0,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','1','suspension' ,1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','2','tablet'     ,2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','3','capsule'    ,3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','4','solution'   ,4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','5','tsp'        ,5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','6','ml'         ,6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','7','units'      ,7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','8','inhalations',8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','9','gtts(drops)',9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','10','cream'   ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_form','11','ointment',11,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','0',''          ,0,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','1','mg'    ,1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','2','mg/1cc',2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','3','mg/2cc',3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','4','mg/3cc',4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','5','mg/4cc',5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','6','mg/5cc',6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','7','mcg'   ,7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_units','8','grams' ,8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '0',''                 , 0,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '1','Per Oris'         , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '2','Per Rectum'       , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '3','To Skin'          , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '4','To Affected Area' , 4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '5','Sublingual'       , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '6','OS'               , 6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '7','OD'               , 7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '8','OU'               , 8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route', '9','SQ'               , 9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route','10','IM'               ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route','11','IV'               ,11,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route','12','Per Nostril'      ,12,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route','13','Both Ears',13,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route','14','Left Ear' ,14,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_route','15','Right Ear',15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','0',''      ,0,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','1','b.i.d.',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','2','t.i.d.',2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','3','q.i.d.',3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','4','q.3h'  ,4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','5','q.4h'  ,5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','6','q.5h'  ,6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','7','q.6h'  ,7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','8','q.8h'  ,8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','9','q.d.'  ,9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','10','a.c.'  ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','11','p.c.'  ,11,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','12','a.m.'  ,12,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','13','p.m.'  ,13,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','14','ante'  ,14,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','15','h'     ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','16','h.s.'  ,16,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','17','p.r.n.',17,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('drug_interval','18','stat'  ,18,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('chartloc','fileroom','File Room'              ,1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'boolean'      ,'Boolean'            , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'chartloc'     ,'Chart Storage Locations',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'country'      ,'Country'            , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'drug_form'    ,'Drug Forms'         , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'drug_units'   ,'Drug Units'         , 4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'drug_route'   ,'Drug Routes'        , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'drug_interval','Drug Intervals'     , 6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'exams'        ,'Exams/Tests'        , 7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'feesheet'     ,'Fee Sheet'          , 8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'language'     ,'Language'           , 9,0);
-- INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'lbfnames'     ,'Layout-Based Visit Forms',9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'marital'      ,'Marital Status'     ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'pricelevel'   ,'Price Level'        ,11,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'ethrace'      ,'Race/Ethnicity'     ,12,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'refsource'    ,'Referral Source'    ,13,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'riskfactors'  ,'Risk Factors'       ,14,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'risklevel'    ,'Risk Level'         ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'superbill'    ,'Service Category'   ,16,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'sex'          ,'Sex'                ,17,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'state'        ,'State'              ,18,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'taxrate'      ,'Tax Rate'           ,19,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'titles'       ,'Titles'             ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'yesno'        ,'Yes/No'             ,21,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'userlist1'    ,'User Defined List 1',22,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'userlist2'    ,'User Defined List 2',23,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'userlist3'    ,'User Defined List 3',24,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'userlist4'    ,'User Defined List 4',25,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'userlist5'    ,'User Defined List 5',26,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'userlist6'    ,'User Defined List 6',27,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists' ,'userlist7'    ,'User Defined List 7',28,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'    ,'adjreason'      ,'Adjustment Reasons',1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','Adm adjust'     ,'Adm adjust'     , 5,1);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','After hrs calls','After hrs calls',10,1);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','Bad check'      ,'Bad check'      ,15,1);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','Bad debt'       ,'Bad debt'       ,20,1);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','Coll w/o'       ,'Coll w/o'       ,25,1);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','Discount'       ,'Discount'       ,30,1);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','Hardship w/o'   ,'Hardship w/o'   ,35,1);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','Ins adjust'     ,'Ins adjust'     ,40,1);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','Ins bundling'   ,'Ins bundling'   ,45,1);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','Ins overpaid'   ,'Ins overpaid'   ,50,5);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','Ins refund'     ,'Ins refund'     ,55,5);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','Pt overpaid'    ,'Pt overpaid'    ,60,5);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','Pt refund'      ,'Pt refund'      ,65,5);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','Pt released'    ,'Pt released'    ,70,1);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','Sm debt w/o'    ,'Sm debt w/o'    ,75,1);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','To copay'       ,'To copay'       ,80,2);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','To ded\'ble'    ,'To ded\'ble'    ,85,3);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('adjreason','Untimely filing','Untimely filing',90,1);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'       ,'sub_relation','Subscriber Relationship',18,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('sub_relation','self'        ,'Self'                   , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('sub_relation','spouse'      ,'Spouse'                 , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('sub_relation','child'       ,'Child'                  , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('sub_relation','other'       ,'Other'                  , 4,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'     ,'occurrence','Occurrence'                  ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('occurrence','0'         ,'Unknown or N/A'              , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('occurrence','1'         ,'First'                       ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('occurrence','6'         ,'Early Recurrence (<2 Mo)'    ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('occurrence','7'         ,'Late Recurrence (2-12 Mo)'   ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('occurrence','8'         ,'Delayed Recurrence (> 12 Mo)',25,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('occurrence','4'         ,'Chronic/Recurrent'           ,30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('occurrence','5'         ,'Acute on Chronic'            ,35,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'  ,'outcome','Outcome'         ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('outcome','0'      ,'Unassigned'      , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('outcome','1'      ,'Resolved'        , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('outcome','2'      ,'Improved'        ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('outcome','3'      ,'Status quo'      ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('outcome','4'      ,'Worse'           ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('outcome','5'      ,'Pending followup',25,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'    ,'note_type'      ,'Patient Note Types',10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Unassigned'     ,'Unassigned'        , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Chart Note'     ,'Chart Note'        , 2,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Insurance'      ,'Insurance'         , 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','New Document'   ,'New Document'      , 4,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Pharmacy'       ,'Pharmacy'          , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Prior Auth'     ,'Prior Auth'        , 6,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Referral'       ,'Referral'          , 7,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Test Scheduling','Test Scheduling'   , 8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Bill/Collect'   ,'Bill/Collect'      , 9,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Other'          ,'Other'             ,10,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'        ,'immunizations','Immunizations'           ,  8,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','1'            ,'DTaP 1'                  , 30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','2'            ,'DTaP 2'                  , 35,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','3'            ,'DTaP 3'                  , 40,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','4'            ,'DTaP 4'                  , 45,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','5'            ,'DTaP 5'                  , 50,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','6'            ,'DT 1'                    ,  5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','7'            ,'DT 2'                    , 10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','8'            ,'DT 3'                    , 15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','9'            ,'DT 4'                    , 20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','10'           ,'DT 5'                    , 25,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','11'           ,'IPV 1'                   ,110,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','12'           ,'IPV 2'                   ,115,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','13'           ,'IPV 3'                   ,120,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','14'           ,'IPV 4'                   ,125,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','15'           ,'Hib 1'                   , 80,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','16'           ,'Hib 2'                   , 85,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','17'           ,'Hib 3'                   , 90,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','18'           ,'Hib 4'                   , 95,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','19'           ,'Pneumococcal Conjugate 1',140,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','20'           ,'Pneumococcal Conjugate 2',145,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','21'           ,'Pneumococcal Conjugate 3',150,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','22'           ,'Pneumococcal Conjugate 4',155,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','23'           ,'MMR 1'                   ,130,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','24'           ,'MMR 2'                   ,135,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','25'           ,'Varicella 1'             ,165,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','26'           ,'Varicella 2'             ,170,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','27'           ,'Hepatitis B 1'           , 65,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','28'           ,'Hepatitis B 2'           , 70,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','29'           ,'Hepatitis B 3'           , 75,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','30'           ,'Influenza 1'             ,100,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','31'           ,'Influenza 2'             ,105,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','32'           ,'Td'                      ,160,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','33'           ,'Hepatitis A 1'           , 55,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','34'           ,'Hepatitis A 2'           , 60,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('immunizations','35'           ,'Other'                   ,175,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'apptstat','Appointment Statuses', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes ) VALUES ('apptstat','-'       ,'- None'              , 5,0,'FEFDCF|0');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes ) VALUES ('apptstat','*'       ,'* Reminder done'     ,10,0,'FFC9F8|0');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes ) VALUES ('apptstat','+'       ,'+ Chart pulled'      ,15,0,'87FF1F|0');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes ) VALUES ('apptstat','x'       ,'x Canceled'          ,20,0,'BFBFBF|0');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes ) VALUES ('apptstat','?'       ,'? No show'           ,25,0,'BFBFBF|0');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes, toggle_setting_1 ) VALUES ('apptstat','@'       ,'@ Arrived'           ,30,0,'FF2414|10','1');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes, toggle_setting_1 ) VALUES ('apptstat','~'       ,'~ Arrived late'      ,35,0,'FF6619|10','1');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes, toggle_setting_2 ) VALUES ('apptstat','!'       ,'! Left w/o visit'    ,40,0,'0BBA34|0','1');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes ) VALUES ('apptstat','#'       ,'# Ins/fin issue'     ,45,0,'FFFF2B|0');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes ) VALUES ('apptstat','<'       ,'< In exam room'      ,50,0,'52D9DE|10');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes, toggle_setting_2 ) VALUES ('apptstat','>'       ,'> Checked out'       ,55,0,'FEFDCF|0','1');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes ) VALUES ('apptstat','$'       ,'$ Coding done'       ,60,0,'C0FF96|0');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes ) VALUES ('apptstat','%'       ,'% Canceled < 24h'    ,65,0,'BFBFBF|0');

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'    ,'warehouse','Warehouses',21,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('warehouse','onsite'   ,'On Site'   , 5,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','abook_type'  ,'Address Book Types'  , 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('abook_type','ord_img','Imaging Service'     , 5,3);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('abook_type','ord_imm','Immunization Service',10,3);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('abook_type','ord_lab','Lab Service'         ,15,3);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('abook_type','spe'    ,'Specialist'          ,20,2);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('abook_type','vendor' ,'Vendor'              ,25,3);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('abook_type','dist'   ,'Distributor'         ,30,3);
INSERT INTO list_options ( list_id, option_id, title, seq, option_value ) VALUES ('abook_type','oth'    ,'Other'               ,95,1);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_type','Procedure Types', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_type','grp','Group'          ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_type','ord','Procedure Order',20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_type','res','Discrete Result',30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_type','rec','Recommendation' ,40,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_body_site','Procedure Body Sites', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_body_site','arm'    ,'Arm'    ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_body_site','buttock','Buttock',20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_body_site','oth'    ,'Other'  ,90,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_specimen','Procedure Specimen Types', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_specimen','blood' ,'Blood' ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_specimen','saliva','Saliva',20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_specimen','urine' ,'Urine' ,30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_specimen','oth'   ,'Other' ,90,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_route','Procedure Routes', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_route','inj' ,'Injection',10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_route','oral','Oral'     ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_route','oth' ,'Other'    ,90,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_lat','Procedure Lateralities', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_lat','left' ,'Left'     ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_lat','right','Right'    ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_lat','bilat','Bilateral',30,0);

INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('lists','proc_unit','Procedure Units', 1);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','bool'       ,'Boolean'    ,  5);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','cu_mm'      ,'CU.MM'      , 10);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','fl'         ,'FL'         , 20);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','g_dl'       ,'G/DL'       , 30);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','gm_dl'      ,'GM/DL'      , 40);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','hmol_l'     ,'HMOL/L'     , 50);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','iu_l'       ,'IU/L'       , 60);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','mg_dl'      ,'MG/DL'      , 70);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','mil_cu_mm'  ,'Mil/CU.MM'  , 80);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','percent'    ,'Percent'    , 90);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','percentile' ,'Percentile' ,100);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','pg'         ,'PG'         ,110);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','ratio'      ,'Ratio'      ,120);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','thous_cu_mm','Thous/CU.MM',130);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','units'      ,'Units'      ,140);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','units_l'    ,'Units/L'    ,150);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','days'       ,'Days'       ,600);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','weeks'      ,'Weeks'      ,610);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','months'     ,'Months'     ,620);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('proc_unit','oth'        ,'Other'      ,990);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','ord_priority','Order Priorities', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_priority','high'  ,'High'  ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_priority','normal','Normal',20,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','ord_status','Order Statuses', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_status','pending' ,'Pending' ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_status','routed'  ,'Routed'  ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_status','complete','Complete',30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ord_status','canceled','Canceled',40,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_rep_status','Procedure Report Statuses', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','final'  ,'Final'      ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','review' ,'Reviewed'   ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','prelim' ,'Preliminary',30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','cancel' ,'Canceled'   ,40,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','error'  ,'Error'      ,50,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_rep_status','correct','Corrected'  ,60,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_res_abnormal','Procedure Result Abnormal', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_abnormal','no'  ,'No'  ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_abnormal','yes' ,'Yes' ,20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_abnormal','high','High',30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_abnormal','low' ,'Low' ,40,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_res_status','Procedure Result Statuses', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','final'     ,'Final'      ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','prelim'    ,'Preliminary',20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','cancel'    ,'Canceled'   ,30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','error'     ,'Error'      ,40,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','correct'   ,'Corrected'  ,50,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_status','incomplete','Incomplete' ,60,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists','proc_res_bool','Procedure Boolean Results', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_bool','neg' ,'Negative',10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('proc_res_bool','pos' ,'Positive',20,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'         ,'message_status','Message Status',45,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('message_status','Done'           ,'Done'         , 5,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('message_status','Forwarded'      ,'Forwarded'    ,10,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('message_status','New'            ,'New'          ,15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('message_status','Read'           ,'Read'         ,20,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Lab Results' ,'Lab Results', 15,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','New Orders' ,'New Orders', 20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('note_type','Patient Reminders' ,'Patient Reminders', 25,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'irnpool','Invoice Reference Number Pools', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, notes ) VALUES ('irnpool','main','Main',1,1,'000001');

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists', 'eligibility', 'Eligibility', 60, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('eligibility', 'eligible', 'Eligible', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('eligibility', 'ineligible', 'Ineligible', 20, 0);

-- INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists', 'transactions', 'Layout-Based Transaction Forms', 9, 0);
-- INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('transactions', 'LBTptreq', 'Patient Request'  , 20, 0);
-- INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('transactions', 'LBTphreq', 'Physician Request', 30, 0);
-- INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('transactions', 'LBTlegal', 'Legal'            , 40, 0);
-- INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('transactions', 'LBTbill' , 'Billing'          , 50, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'payment_adjustment_code','Payment Adjustment Code', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_adjustment_code', 'family_payment', 'Family Payment', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_adjustment_code', 'group_payment', 'Group Payment', 30, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_adjustment_code', 'insurance_payment', 'Insurance Payment', 40, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_adjustment_code', 'patient_payment', 'Patient Payment', 50, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_adjustment_code', 'pre_payment', 'Pre Payment', 60, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'payment_ins','Payment Ins', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_ins', '0', 'Pat', 40, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_ins', '1', 'Ins1', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_ins', '2', 'Ins2', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_ins', '3', 'Ins3', 30, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'payment_method','Payment Method', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_method', 'bank_draft', 'Bank Draft', 50, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_method', 'cash', 'Cash', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_method', 'check_payment', 'Check Payment', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_method', 'credit_card', 'Credit Card', 30, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_method', 'electronic', 'Electronic', 40, 0);
insert into `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) values('payment_method','authorize_net','Authorize.net','60','0','0','','');

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'payment_sort_by','Payment Sort By', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_sort_by', 'check_date', 'Check Date', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_sort_by', 'payer_id', 'Ins Code', 40, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_sort_by', 'payment_method', 'Payment Method', 50, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_sort_by', 'payment_type', 'Paying Entity', 30, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_sort_by', 'pay_total', 'Amount', 70, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_sort_by', 'reference', 'Check Number', 60, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_sort_by', 'session_id', 'Id', 10, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'payment_status','Payment Status', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_status', 'fully_paid', 'Fully Paid', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_status', 'unapplied', 'Unapplied', 20, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'payment_type','Payment Type', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_type', 'insurance', 'Insurance', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_type', 'patient', 'Patient', 20, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists', 'date_master_criteria', 'Date Master Criteria', 33, 1);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('date_master_criteria', 'all', 'All', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('date_master_criteria', 'today', 'Today', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('date_master_criteria', 'this_month_to_date', 'This Month to Date', 30, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('date_master_criteria', 'last_month', 'Last Month', 40, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('date_master_criteria', 'this_week_to_date', 'This Week to Date', 50, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('date_master_criteria', 'this_calendar_year', 'This Calendar Year', 60, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('date_master_criteria', 'last_calendar_year', 'Last Calendar Year', 70, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('date_master_criteria', 'custom', 'Custom', 80, 0);

-- Clinical Plan Titles
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists' ,'clinical_plans','Clinical Plans', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_plans', 'dm_plan_cqm', 'Diabetes Mellitus', 5, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_plans', 'ckd_plan_cqm', 'Chronic Kidney Disease (CKD)', 10, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_plans', 'prevent_plan_cqm', 'Preventative Care', 15, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_plans', 'periop_plan_cqm', 'Perioperative Care', 20, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_plans', 'rheum_arth_plan_cqm', 'Rheumatoid Arthritis', 25, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_plans', 'back_pain_plan_cqm', 'Back Pain', 30, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_plans', 'cabg_plan_cqm', 'Coronary Artery Bypass Graft (CABG)', 35, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_plans', 'dm_plan', 'Diabetes Mellitus', 500, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_plans', 'prevent_plan', 'Preventative Care', 510, 0);

-- Clinical Rule Titles
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists' ,'clinical_rules','Clinical Rules', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'problem_list_amc', 'Maintain an up-to-date problem list of current and active diagnoses.', 5, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'med_list_amc', 'Maintain active medication list.', 10, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'med_allergy_list_amc', 'Maintain active medication allergy list.', 15, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'record_vitals_amc', 'Record and chart changes in vital signs.', 20, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'record_smoke_amc', 'Record smoking status for patients 13 years old or older.', 25, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'lab_result_amc', 'Incorporate clinical lab-test results into certified EHR technology as structured data.', 30, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'med_reconc_amc', 'The EP, eligible hospital or CAH who receives a patient from another setting of care or provider of care or believes an encounter is relevant should perform medication reconciliation.', 35, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'patient_edu_amc', 'Use certified EHR technology to identify patient-specific education resources and provide those resources to the patient if appropriate.', 40, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'cpoe_med_amc', 'Use CPOE for medication orders directly entered by any licensed healthcare professional who can enter orders into the medical record per state, local and professional guidelines.', 45, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'e_prescribe_amc', 'Generate and transmit permissible prescriptions electronically.', 50, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'record_dem_amc', 'Record demographics.', 55, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'send_reminder_amc', 'Send reminders to patients per patient preference for preventive/follow up care.', 60, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'provide_rec_pat_amc', 'Provide patients with an electronic copy of their health information (including diagnostic test results, problem list, medication lists, medication allergies), upon request.', 65, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'timely_access_amc', 'Provide patients with timely electronic access to their health information (including lab results, problem list, medication lists, medication allergies) within four business days of the information being available to the EP.', 70, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'provide_sum_pat_amc', 'Provide clinical summaries for patients for each office visit.', 75, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'send_sum_amc', 'The EP, eligible hospital or CAH who transitions their patient to another setting of care or provider of care or refers their patient to another provider of care should provide summary of care record for each transition of care or referral.', 80, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_htn_bp_measure_cqm', 'Hypertension: Blood Pressure Measurement (CQM)', 200, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_tob_use_assess_cqm', 'Tobacco Use Assessment (CQM)', 205, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_tob_cess_inter_cqm', 'Tobacco Cessation Intervention (CQM)', 210, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_adult_wt_screen_fu_cqm', 'Adult Weight Screening and Follow-Up (CQM)', 220, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_wt_assess_couns_child_cqm', 'Weight Assessment and Counseling for Children and Adolescents (CQM)', 230, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_influenza_ge_50_cqm', 'Influenza Immunization for Patients >= 50 Years Old (CQM)', 240, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_child_immun_stat_cqm', 'Childhood immunization Status (CQM)', 250, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_pneumovacc_ge_65_cqm', 'Pneumonia Vaccination Status for Older Adults (CQM)', 260, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_dm_eye_cqm', 'Diabetes: Eye Exam (CQM)', 270, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_dm_foot_cqm', 'Diabetes: Foot Exam (CQM)', 280, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_dm_a1c_cqm', 'Diabetes: HbA1c Poor Control (CQM)', 285, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_dm_bp_control_cqm', 'Diabetes: Blood Pressure Management (CQM)', 290, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_dm_ldl_cqm', 'Diabetes: LDL Management & Control (CQM)', 300, 0);

INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_htn_bp_measure', 'Hypertension: Blood Pressure Measurement', 500, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_tob_use_assess', 'Tobacco Use Assessment', 510, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_tob_cess_inter', 'Tobacco Cessation Intervention', 520, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_adult_wt_screen_fu', 'Adult Weight Screening and Follow-Up', 530, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_wt_assess_couns_child', 'Weight Assessment and Counseling for Children and Adolescents', 540, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_influenza_ge_50', 'Influenza Immunization for Patients >= 50 Years Old', 550, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_pneumovacc_ge_65', 'Pneumonia Vaccination Status for Older Adults', 570, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_dm_hemo_a1c', 'Diabetes: Hemoglobin A1C', 570, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_dm_urine_alb', 'Diabetes: Urine Microalbumin', 590, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_dm_eye', 'Diabetes: Eye Exam', 600, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_dm_foot', 'Diabetes: Foot Exam', 610, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_cs_mammo', 'Cancer Screening: Mammogram', 620, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_cs_pap', 'Cancer Screening: Pap Smear', 630, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_cs_colon', 'Cancer Screening: Colon Cancer Screening', 640, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_cs_prostate', 'Cancer Screening: Prostate Cancer Screening', 650, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_inr_monitor', 'Coumadin Management - INR Monitoring', 1000, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('clinical_rules', 'rule_appt_reminder', 'Appointment Reminder Rule', 2000, 0);

-- Clinical Rule Target Methods
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists' ,'rule_targets', 'Clinical Rule Target Methods', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_targets' ,'target_database', 'Database', 10, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_targets' ,'target_interval', 'Interval', 20, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_targets' ,'target_proc', 'Procedure', 20, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_targets' ,'target_appt', 'Appointment', 30, 0);

-- Clinical Rule Target Intervals
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists' ,'rule_target_intervals', 'Clinical Rules Target Intervals', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_target_intervals' ,'year', 'Year', 10, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_target_intervals' ,'month', 'Month', 20, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_target_intervals' ,'week', 'Week', 30, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_target_intervals' ,'day', 'Day', 40, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_target_intervals' ,'hour', 'Hour', 50, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_target_intervals' ,'minute', 'Minute', 60, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_target_intervals' ,'second', 'Second', 70, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_target_intervals' ,'flu_season', 'Flu Season', 80, 0);

-- Clinical Rule Comparisons
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists' ,'rule_comparisons', 'Clinical Rules Comparisons', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_comparisons' ,'EXIST', 'Exist', 10, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_comparisons' ,'lt', 'Less Than', 20, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_comparisons' ,'le', 'Less Than or Equal To', 30, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_comparisons' ,'gt', 'Greater Than', 40, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_comparisons' ,'ge', 'Greater Than or Equal To', 50, 0);

-- Clinical Rule Filter Methods
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists' ,'rule_filters','Clinical Rule Filter Methods', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_filters', 'filt_database', 'Database', 10, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_filters', 'filt_diagnosis', 'Diagnosis', 20, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_filters', 'filt_sex', 'Gender', 30, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_filters', 'filt_age_max', 'Maximum Age', 40, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_filters', 'filt_age_min', 'Minimum Age', 50, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_filters', 'filt_proc', 'Procedure', 60, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_filters', 'filt_lists', 'Lists', 70, 0);

-- Clinical Rule Age Intervals
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists' ,'rule_age_intervals', 'Clinical Rules Age Intervals', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_age_intervals' ,'year', 'Year', 10, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_age_intervals' ,'month', 'Month', 20, 0);

-- Encounter Types (needed for mapping encounters for CQM rules)
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists' ,'rule_enc_types', 'Clinical Rules Encounter Types', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_outpatient', 'encounter outpatient', 10, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_nurs_fac', 'encounter nursing facility', 20, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_off_vis', 'encounter office visit', 30, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_hea_and_beh', 'encounter health and behavior assessment', 40, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_occ_ther', 'encounter occupational therapy', 50, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_psych_and_psych', 'encounter psychiatric & psychologic', 60, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_pre_med_ser_18_older', 'encounter preventive medicine services 18 and older', 70, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_pre_med_ser_40_older', 'encounter preventive medicine 40 and older', 75, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_pre_ind_counsel', 'encounter preventive medicine - individual counseling', 80, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_pre_med_group_counsel', 'encounter preventive medicine group counseling', 90, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_pre_med_other_serv', 'encounter preventive medicine other services', 100, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_out_pcp_obgyn', 'encounter outpatient w/PCP & obgyn', 110, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_pregnancy', 'encounter pregnancy', 120, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_nurs_discharge', 'encounter nursing discharge', 130, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_acute_inp_or_ed', 'encounter acute inpatient or ED', 130, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_nonac_inp_out_or_opth', 'Encounter: encounter non-acute inpt, outpatient, or ophthalmology', 140, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_enc_types' ,'enc_influenza', 'encounter influenza', 150, 0);

-- Clinical Rule Action Categories
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists' ,'rule_action_category', 'Clinical Rule Action Category', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action_category' ,'act_cat_assess', 'Assessment', 10, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action_category' ,'act_cat_edu', 'Education', 20, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action_category' ,'act_cat_exam', 'Examination', 30, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action_category' ,'act_cat_inter', 'Intervention', 40, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action_category' ,'act_cat_measure', 'Measurement', 50, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action_category' ,'act_cat_treat', 'Treatment', 60, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action_category' ,'act_cat_remind', 'Reminder', 70, 0);

-- Clinical Rule Action Items
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists' ,'rule_action', 'Clinical Rule Action Item', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_bp', 'Blood Pressure', 10, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_influvacc', 'Influenza Vaccine', 20, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_tobacco', 'Tobacco', 30, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_wt', 'Weight', 40, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_bmi', 'BMI', 43, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_nutrition', 'Nutrition', 45, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_exercise', 'Exercise', 47, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_pneumovacc', 'Pneumococcal Vaccine', 60, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_hemo_a1c', 'Hemoglobin A1C', 70, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_urine_alb', 'Urine Microalbumin', 80, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_eye', 'Opthalmic', 90, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_foot', 'Podiatric', 100, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_mammo', 'Mammogram', 110, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_pap', 'Pap Smear', 120, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_colon_cancer_screen', 'Colon Cancer Screening', 130, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_prostate_cancer_screen', 'Prostate Cancer Screening', 140, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_lab_inr', 'INR', 150, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_action' ,'act_appointment', 'Appointment', 160, 0);

-- Clinical Rule Reminder Intervals
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists' ,'rule_reminder_intervals', 'Clinical Rules Reminder Intervals', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_reminder_intervals' ,'month', 'Month', 10, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_reminder_intervals' ,'week', 'Week', 20, 0);

-- Clinical Rule Reminder Methods
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists' ,'rule_reminder_methods', 'Clinical Rules Reminder Methods', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_reminder_methods' ,'clinical_reminder_pre', 'Past Due Interval (Clinical Reminders)', 10, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_reminder_methods' ,'patient_reminder_pre', 'Past Due Interval (Patient Reminders)', 20, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_reminder_methods' ,'clinical_reminder_post', 'Soon Due Interval (Clinical Reminders)', 30, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_reminder_methods' ,'patient_reminder_post', 'Soon Due Interval (Patient Reminders)', 40, 0);

-- Clinical Rule Reminder Due Options
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists' ,'rule_reminder_due_opt', 'Clinical Rules Reminder Due Options', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_reminder_due_opt' ,'due', 'Due', 10, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_reminder_due_opt' ,'soon_due', 'Due Soon', 20, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_reminder_due_opt' ,'past_due', 'Past Due', 30, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_reminder_due_opt' ,'not_due', 'Not Due', 30, 0);

-- Clinical Rule Reminder Inactivate Options
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists' ,'rule_reminder_inactive_opt', 'Clinical Rules Reminder Inactivation Options', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_reminder_inactive_opt' ,'auto', 'Automatic', 10, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_reminder_inactive_opt' ,'due_status_update', 'Due Status Update', 20, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('rule_reminder_inactive_opt' ,'manual', 'Manual', 20, 0);

-- eRx User Roles
INSERT INTO list_options (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('newcrop_erx_role','erxadmin','NewCrop Admin','5','0','0','','');
INSERT INTO list_options (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('newcrop_erx_role','erxdoctor','NewCrop Doctor','20','0','0','','');
INSERT INTO list_options (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('newcrop_erx_role','erxmanager','NewCrop Manager','15','0','0','','');
INSERT INTO list_options (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('newcrop_erx_role','erxmidlevelPrescriber','NewCrop Midlevel Prescriber','25','0','0','','');
INSERT INTO list_options (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('newcrop_erx_role','erxnurse','NewCrop Nurse','10','0','0','','');
INSERT INTO list_options (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('newcrop_erx_role','erxsupervisingDoctor','NewCrop Supervising Doctor','30','0','0','','');
INSERT INTO list_options (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('lists','newcrop_erx_role','NewCrop eRx Role','221','0','0','','');

-- MSP remit codes
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('lists','msp_remit_codes','MSP Remit Codes','221','0','0','','');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '1', '1', 1, 0, 0, '', 'Deductible Amount');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '2', '2', 2, 0, 0, '', 'Coinsurance Amount');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '3', '3', 3, 0, 0, '', 'Co-payment Amount');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '4', '4', 4, 0, 0, '', 'The procedure code is inconsistent with the modifier used or a required modifier is missing. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '9', '9', 9, 0, 0, '', 'The diagnosis is inconsistent with the patient''s age. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '10', '10', 10, 0, 0, '', 'The diagnosis is inconsistent with the patient''s gender. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '11', '11', 11, 0, 0, '', 'The diagnosis is inconsistent with the procedure. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '12', '12', 12, 0, 0, '', 'The diagnosis is inconsistent with the provider type. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '13', '13', 13, 0, 0, '', 'The date of death precedes the date of service.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '14', '14', 14, 0, 0, '', 'The date of birth follows the date of service.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '15', '15', 15, 0, 0, '', 'The authorization number is missing, invalid, or does not apply to the billed services or provider.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '16', '16', 16, 0, 0, '', 'Claim/service lacks information which is needed for adjudication. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '18', '18', 17, 0, 0, '', 'Duplicate claim/service.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '19', '19', 18, 0, 0, '', 'This is a work-related injury/illness and thus the liability of the Worker''s Compensation Carrier.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '20', '20', 19, 0, 0, '', 'This injury/illness is covered by the liability carrier.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '21', '21', 20, 0, 0, '', 'This injury/illness is the liability of the no-fault carrier.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '22', '22', 21, 0, 0, '', 'This care may be covered by another payer per coordination of benefits.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '23', '23', 22, 0, 0, '', 'The impact of prior payer(s) adjudication including payments and/or adjustments.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '24', '24', 23, 0, 0, '', 'Charges are covered under a capitation agreement/managed care plan.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '26', '26', 24, 0, 0, '', 'Expenses incurred prior to coverage.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '27', '27', 25, 0, 0, '', 'Expenses incurred after coverage terminated.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '29', '29', 26, 0, 0, '', 'The time limit for filing has expired.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '31', '31', 27, 0, 0, '', 'Patient cannot be identified as our insured.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '32', '32', 28, 0, 0, '', 'Our records indicate that this dependent is not an eligible dependent as defined.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '33', '33', 29, 0, 0, '', 'Insured has no dependent coverage.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '34', '34', 30, 0, 0, '', 'Insured has no coverage for newborns.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '35', '35', 31, 0, 0, '', 'Lifetime benefit maximum has been reached.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '38', '38', 32, 0, 0, '', 'Services not provided or authorized by designated (network/primary care) providers.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '39', '39', 33, 0, 0, '', 'Services denied at the time authorization/pre-certification was requested.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '40', '40', 34, 0, 0, '', 'Charges do not meet qualifications for emergent/urgent care. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '44', '44', 35, 0, 0, '', 'Prompt-pay discount.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '45', '45', 36, 0, 0, '', 'Charge exceeds fee schedule/maximum allowable or contracted/legislated fee arrangement. (Use Group Codes PR or CO depending upon liability).');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '49', '49', 37, 0, 0, '', 'These are non-covered services because this is a routine exam or screening procedure done in conjunction with a routine exam. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '50', '50', 38, 0, 0, '', 'These are non-covered services because this is not deemed a ''medical necessity'' by the payer. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '51', '51', 39, 0, 0, '', 'These are non-covered services because this is a pre-existing condition. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '53', '53', 40, 0, 0, '', 'Services by an immediate relative or a member of the same household are not covered.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '54', '54', 41, 0, 0, '', 'Multiple physicians/assistants are not covered in this case. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '55', '55', 42, 0, 0, '', 'Procedure/treatment is deemed experimental/investigational by the payer. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '56', '56', 43, 0, 0, '', 'Procedure/treatment has not been deemed ''proven to be effective'' by the payer. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '58', '58', 44, 0, 0, '', 'Treatment was deemed by the payer to have been rendered in an inappropriate or invalid place of service. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '59', '59', 45, 0, 0, '', 'Processed based on multiple or concurrent procedure rules. (For example multiple surgery or diagnostic imaging, concurrent anesthesia.) Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '60', '60', 46, 0, 0, '', 'Charges for outpatient services are not covered when performed within a period of time prior to or after inpatient services.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '61', '61', 47, 0, 0, '', 'Penalty for failure to obtain second surgical opinion. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '66', '66', 48, 0, 0, '', 'Blood Deductible.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '69', '69', 49, 0, 0, '', 'Day outlier amount.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '70', '70', 50, 0, 0, '', 'Cost outlier - Adjustment to compensate for additional costs.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '74', '74', 51, 0, 0, '', 'Indirect Medical Education Adjustment.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '75', '75', 52, 0, 0, '', 'Direct Medical Education Adjustment.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '76', '76', 53, 0, 0, '', 'Disproportionate Share Adjustment.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '78', '78', 54, 0, 0, '', 'Non-Covered days/Room charge adjustment.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '85', '85', 55, 0, 0, '', 'Patient Interest Adjustment (Use Only Group code PR)');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '87', '87', 56, 0, 0, '', 'Transfer amount.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '89', '89', 57, 0, 0, '', 'Professional fees removed from charges.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '90', '90', 58, 0, 0, '', 'Ingredient cost adjustment. Note: To be used for pharmaceuticals only.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '91', '91', 59, 0, 0, '', 'Dispensing fee adjustment.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '94', '94', 60, 0, 0, '', 'Processed in Excess of charges.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '95', '95', 61, 0, 0, '', 'Plan procedures not followed.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '96', '96', 62, 0, 0, '', 'Non-covered charge(s). At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.) Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 S');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '97', '97', 63, 0, 0, '', 'The benefit for this service is included in the payment/allowance for another service/procedure that has already been adjudicated. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '100', '100', 64, 0, 0, '', 'Payment made to patient/insured/responsible party/employer.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '101', '101', 65, 0, 0, '', 'Predetermination: anticipated payment upon completion of services or claim adjudication.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '102', '102', 66, 0, 0, '', 'Major Medical Adjustment.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '103', '103', 67, 0, 0, '', 'Provider promotional discount (e.g., Senior citizen discount).');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '104', '104', 68, 0, 0, '', 'Managed care withholding.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '105', '105', 69, 0, 0, '', 'Tax withholding.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '106', '106', 70, 0, 0, '', 'Patient payment option/election not in effect.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '107', '107', 71, 0, 0, '', 'The related or qualifying claim/service was not identified on this claim. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '108', '108', 72, 0, 0, '', 'Rent/purchase guidelines were not met. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '109', '109', 73, 0, 0, '', 'Claim not covered by this payer/contractor. You must send the claim to the correct payer/contractor.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '110', '110', 74, 0, 0, '', 'Billing date predates service date.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '111', '111', 75, 0, 0, '', 'Not covered unless the provider accepts assignment.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '112', '112', 76, 0, 0, '', 'Service not furnished directly to the patient and/or not documented.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '114', '114', 77, 0, 0, '', 'Procedure/product not approved by the Food and Drug Administration.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '115', '115', 78, 0, 0, '', 'Procedure postponed, canceled, or delayed.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '116', '116', 79, 0, 0, '', 'The advance indemnification notice signed by the patient did not comply with requirements.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '117', '117', 80, 0, 0, '', 'Transportation is only covered to the closest facility that can provide the necessary care.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '118', '118', 81, 0, 0, '', 'ESRD network support adjustment.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '119', '119', 82, 0, 0, '', 'Benefit maximum for this time period or occurrence has been reached.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '121', '121', 83, 0, 0, '', 'Indemnification adjustment - compensation for outstanding member responsibility.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '122', '122', 84, 0, 0, '', 'Psychiatric reduction.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '125', '125', 85, 0, 0, '', 'Submission/billing error(s). At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '128', '128', 86, 0, 0, '', 'Newborn''s services are covered in the mother''s Allowance.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '129', '129', 87, 0, 0, '', 'Prior processing information appears incorrect. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '130', '130', 88, 0, 0, '', 'Claim submission fee.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '131', '131', 89, 0, 0, '', 'Claim specific negotiated discount.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '132', '132', 90, 0, 0, '', 'Prearranged demonstration project adjustment.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '133', '133', 91, 0, 0, '', 'The disposition of this claim/service is pending further review.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '134', '134', 92, 0, 0, '', 'Technical fees removed from charges.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '135', '135', 93, 0, 0, '', 'Interim bills cannot be processed.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '136', '136', 94, 0, 0, '', 'Failure to follow prior payer''s coverage rules. (Use Group Code OA).');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '137', '137', 95, 0, 0, '', 'Regulatory Surcharges, Assessments, Allowances or Health Related Taxes.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '138', '138', 96, 0, 0, '', 'Appeal procedures not followed or time limits not met.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '139', '139', 97, 0, 0, '', 'Contracted funding agreement - Subscriber is employed by the provider of services.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '140', '140', 98, 0, 0, '', 'Patient/Insured health identification number and name do not match.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '141', '141', 99, 0, 0, '', 'Claim spans eligible and ineligible periods of coverage.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '142', '142', 100, 0, 0, '', 'Monthly Medicaid patient liability amount.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '143', '143', 101, 0, 0, '', 'Portion of payment deferred.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '144', '144', 102, 0, 0, '', 'Incentive adjustment, e.g. preferred product/service.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '146', '146', 103, 0, 0, '', 'Diagnosis was invalid for the date(s) of service reported.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '147', '147', 104, 0, 0, '', 'Provider contracted/negotiated rate expired or not on file.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '148', '148', 105, 0, 0, '', 'Information from another provider was not provided or was insufficient/incomplete. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '149', '149', 106, 0, 0, '', 'Lifetime benefit maximum has been reached for this service/benefit category.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '150', '150', 107, 0, 0, '', 'Payer deems the information submitted does not support this level of service.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '151', '151', 108, 0, 0, '', 'Payment adjusted because the payer deems the information submitted does not support this many/frequency of services.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '152', '152', 109, 0, 0, '', 'Payer deems the information submitted does not support this length of service. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '153', '153', 110, 0, 0, '', 'Payer deems the information submitted does not support this dosage.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '154', '154', 111, 0, 0, '', 'Payer deems the information submitted does not support this day''s supply.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '155', '155', 112, 0, 0, '', 'Patient refused the service/procedure.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '157', '157', 113, 0, 0, '', 'Service/procedure was provided as a result of an act of war.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '158', '158', 114, 0, 0, '', 'Service/procedure was provided outside of the United States.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '159', '159', 115, 0, 0, '', 'Service/procedure was provided as a result of terrorism.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '160', '160', 116, 0, 0, '', 'Injury/illness was the result of an activity that is a benefit exclusion.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '161', '161', 117, 0, 0, '', 'Provider performance bonus');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '162', '162', 118, 0, 0, '', 'State-mandated Requirement for Property and Casualty, see Claim Payment Remarks Code for specific explanation.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '163', '163', 119, 0, 0, '', 'Attachment referenced on the claim was not received.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '164', '164', 120, 0, 0, '', 'Attachment referenced on the claim was not received in a timely fashion.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '165', '165', 121, 0, 0, '', 'Referral absent or exceeded.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '166', '166', 122, 0, 0, '', 'These services were submitted after this payers responsibility for processing claims under this plan ended.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '167', '167', 123, 0, 0, '', 'This (these) diagnosis(es) is (are) not covered. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '168', '168', 124, 0, 0, '', 'Service(s) have been considered under the patient''s medical plan. Benefits are not available under this dental plan.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '169', '169', 125, 0, 0, '', 'Alternate benefit has been provided.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '170', '170', 126, 0, 0, '', 'Payment is denied when performed/billed by this type of provider. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '171', '171', 127, 0, 0, '', 'Payment is denied when performed/billed by this type of provider in this type of facility. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '172', '172', 128, 0, 0, '', 'Payment is adjusted when performed/billed by a provider of this specialty. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '173', '173', 129, 0, 0, '', 'Service was not prescribed by a physician.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '174', '174', 130, 0, 0, '', 'Service was not prescribed prior to delivery.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '175', '175', 131, 0, 0, '', 'Prescription is incomplete.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '176', '176', 132, 0, 0, '', 'Prescription is not current.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '177', '177', 133, 0, 0, '', 'Patient has not met the required eligibility requirements.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '178', '178', 134, 0, 0, '', 'Patient has not met the required spend down requirements.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '179', '179', 135, 0, 0, '', 'Patient has not met the required waiting requirements. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '180', '180', 136, 0, 0, '', 'Patient has not met the required residency requirements.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '181', '181', 137, 0, 0, '', 'Procedure code was invalid on the date of service.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '182', '182', 138, 0, 0, '', 'Procedure modifier was invalid on the date of service.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '183', '183', 139, 0, 0, '', 'The referring provider is not eligible to refer the service billed. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '184', '184', 140, 0, 0, '', 'The prescribing/ordering provider is not eligible to prescribe/order the service billed. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '185', '185', 141, 0, 0, '', 'The rendering provider is not eligible to perform the service billed. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '186', '186', 142, 0, 0, '', 'Level of care change adjustment.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '187', '187', 143, 0, 0, '', 'Consumer Spending Account payments (includes but is not limited to Flexible Spending Account, Health Savings Account, Health Reimbursement Account, etc.)');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '188', '188', 144, 0, 0, '', 'This product/procedure is only covered when used according to FDA recommendations.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '189', '189', 145, 0, 0, '', '''''Not otherwise classified'' or ''unlisted'' procedure code (CPT/HCPCS) was billed when there is a specific procedure code for this procedure/service''');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '190', '190', 146, 0, 0, '', 'Payment is included in the allowance for a Skilled Nursing Facility (SNF) qualified stay.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '191', '191', 147, 0, 0, '', 'Not a work related injury/illness and thus not the liability of the workers'' compensation carrier Note: If adjustment is at the Claim Level, the payer must send and the provider should refer to the 835 Insurance Policy Number Segment (Loop 2100 Other Clai');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '192', '192', 148, 0, 0, '', 'Non standard adjustment code from paper remittance. Note: This code is to be used by providers/payers providing Coordination of Benefits information to another payer in the 837 transaction only. This code is only used when the non-standard code cannot be ');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '193', '193', 149, 0, 0, '', 'Original payment decision is being maintained. Upon review, it was determined that this claim was processed properly.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '194', '194', 150, 0, 0, '', 'Anesthesia performed by the operating physician, the assistant surgeon or the attending physician.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '195', '195', 151, 0, 0, '', 'Refund issued to an erroneous priority payer for this claim/service.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '197', '197', 152, 0, 0, '', 'Precertification/authorization/notification absent.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '198', '198', 153, 0, 0, '', 'Precertification/authorization exceeded.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '199', '199', 154, 0, 0, '', 'Revenue code and Procedure code do not match.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '200', '200', 155, 0, 0, '', 'Expenses incurred during lapse in coverage');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '201', '201', 156, 0, 0, '', 'Workers Compensation case settled. Patient is responsible for amount of this claim/service through WC ''Medicare set aside arrangement'' or other agreement. (Use group code PR).');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '202', '202', 157, 0, 0, '', 'Non-covered personal comfort or convenience services.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '203', '203', 158, 0, 0, '', 'Discontinued or reduced service.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '204', '204', 159, 0, 0, '', 'This service/equipment/drug is not covered under the patient?s current benefit plan');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '205', '205', 160, 0, 0, '', 'Pharmacy discount card processing fee');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '206', '206', 161, 0, 0, '', 'National Provider Identifier - missing.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '207', '207', 162, 0, 0, '', 'National Provider identifier - Invalid format');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '208', '208', 163, 0, 0, '', 'National Provider Identifier - Not matched.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '209', '209', 164, 0, 0, '', 'Per regulatory or other agreement. The provider cannot collect this amount from the patient. However, this amount may be billed to subsequent payer. Refund to patient if collected. (Use Group code OA)');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '210', '210', 165, 0, 0, '', 'Payment adjusted because pre-certification/authorization not received in a timely fashion');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '211', '211', 166, 0, 0, '', 'National Drug Codes (NDC) not eligible for rebate, are not covered.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '212', '212', 167, 0, 0, '', 'Administrative surcharges are not covered');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '213', '213', 168, 0, 0, '', 'Non-compliance with the physician self referral prohibition legislation or payer policy.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '214', '214', 169, 0, 0, '', 'Workers'' Compensation claim adjudicated as non-compensable. This Payer not liable for claim or service/treatment. Note: If adjustment is at the Claim Level, the payer must send and the provider should refer to the 835 Insurance Policy Number Segment (Loop');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '215', '215', 170, 0, 0, '', 'Based on subrogation of a third party settlement');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '216', '216', 171, 0, 0, '', 'Based on the findings of a review organization');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '217', '217', 172, 0, 0, '', 'Based on payer reasonable and customary fees. No maximum allowable defined by legislated fee arrangement. (Note: To be used for Workers'' Compensation only)');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '218', '218', 173, 0, 0, '', 'Based on entitlement to benefits. Note: If adjustment is at the Claim Level, the payer must send and the provider should refer to the 835 Insurance Policy Number Segment (Loop 2100 Other Claim Related Information REF qualifier ''IG'') for the jurisdictional');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '219', '219', 174, 0, 0, '', 'Based on extent of injury. Note: If adjustment is at the Claim Level, the payer must send and the provider should refer to the 835 Insurance Policy Number Segment (Loop 2100 Other Claim Related Information REF qualifier ''IG'') for the jurisdictional regula');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '220', '220', 175, 0, 0, '', 'The applicable fee schedule does not contain the billed code. Please resubmit a bill with the appropriate fee schedule code(s) that best describe the service(s) provided and supporting documentation if required. (Note: To be used for Workers'' Compensation');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '221', '221', 176, 0, 0, '', 'Workers'' Compensation claim is under investigation. Note: If adjustment is at the Claim Level, the payer must send and the provider should refer to the 835 Insurance Policy Number Segment (Loop 2100 Other Claim Related Information REF qualifier ''IG'') for ');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '222', '222', 177, 0, 0, '', 'Exceeds the contracted maximum number of hours/days/units by this provider for this period. This is not patient specific. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '223', '223', 178, 0, 0, '', 'Adjustment code for mandated federal, state or local law/regulation that is not already covered by another code and is mandated before a new code can be created.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '224', '224', 179, 0, 0, '', 'Patient identification compromised by identity theft. Identity verification required for processing this and future claims.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '225', '225', 180, 0, 0, '', 'Penalty or Interest Payment by Payer (Only used for plan to plan encounter reporting within the 837)');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '226', '226', 181, 0, 0, '', 'Information requested from the Billing/Rendering Provider was not provided or was insufficient/incomplete. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '227', '227', 182, 0, 0, '', 'Information requested from the patient/insured/responsible party was not provided or was insufficient/incomplete. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is ');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '228', '228', 183, 0, 0, '', 'Denied for failure of this provider, another provider or the subscriber to supply requested information to a previous payer for their adjudication');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '229', '229', 184, 0, 0, '', 'Partial charge amount not considered by Medicare due to the initial claim Type of Bill being 12X. Note: This code can only be used in the 837 transaction to convey Coordination of Benefits information when the secondary payer?s cost avoidance policy allow');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '230', '230', 185, 0, 0, '', 'No available or correlating CPT/HCPCS code to describe this service. Note: Used only by Property and Casualty.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '231', '231', 186, 0, 0, '', 'Mutually exclusive procedures cannot be done in the same day/setting. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '232', '232', 187, 0, 0, '', 'Institutional Transfer Amount. Note - Applies to institutional claims only and explains the DRG amount difference when the patient care crosses multiple institutions.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '233', '233', 188, 0, 0, '', 'Services/charges related to the treatment of a hospital-acquired condition or preventable medical error.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '234', '234', 189, 0, 0, '', 'This procedure is not paid separately. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '235', '235', 190, 0, 0, '', 'Sales Tax');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '236', '236', 191, 0, 0, '', 'This procedure or procedure/modifier combination is not compatible with another procedure or procedure/modifier combination provided on the same day according to the National Correct Coding Initiative.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', '237', '237', 192, 0, 0, '', 'Legislated/Regulatory Penalty. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'A0', 'A0', 193, 0, 0, '', 'Patient refund amount.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'A1', 'A1', 194, 0, 0, '', 'Claim/Service denied. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'A5', 'A5', 195, 0, 0, '', 'Medicare Claim PPS Capital Cost Outlier Amount.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'A6', 'A6', 196, 0, 0, '', 'Prior hospitalization or 30 day transfer requirement not met.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'A7', 'A7', 197, 0, 0, '', 'Presumptive Payment Adjustment');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'A8', 'A8', 198, 0, 0, '', 'Ungroupable DRG.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B1', 'B1', 199, 0, 0, '', 'Non-covered visits.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B10', 'B10', 200, 0, 0, '', 'Allowed amount has been reduced because a component of the basic procedure/test was paid. The beneficiary is not liable for more than the charge limit for the basic procedure/test.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B11', 'B11', 201, 0, 0, '', 'The claim/service has been transferred to the proper payer/processor for processing. Claim/service not covered by this payer/processor.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B12', 'B12', 202, 0, 0, '', 'Services not documented in patients'' medical records.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B13', 'B13', 203, 0, 0, '', 'Previously paid. Payment for this claim/service may have been provided in a previous payment.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B14', 'B14', 204, 0, 0, '', 'Only one visit or consultation per physician per day is covered.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B15', 'B15', 205, 0, 0, '', 'This service/procedure requires that a qualifying service/procedure be received and covered. The qualifying other service/procedure has not been received/adjudicated. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payme');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B16', 'B16', 206, 0, 0, '', '''''New Patient'' qualifications were not met.''');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B20', 'B20', 207, 0, 0, '', 'Procedure/service was partially or fully furnished by another provider.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B22', 'B22', 208, 0, 0, '', 'This payment is adjusted based on the diagnosis.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B23', 'B23', 209, 0, 0, '', 'Procedure billed is not authorized per your Clinical Laboratory Improvement Amendment (CLIA) proficiency test.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B4', 'B4', 210, 0, 0, '', 'Late filing penalty.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B5', 'B5', 211, 0, 0, '', 'Coverage/program guidelines were not met or were exceeded.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B7', 'B7', 212, 0, 0, '', 'This provider was not certified/eligible to be paid for this procedure/service on this date of service. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B8', 'B8', 213, 0, 0, '', 'Alternative services were available, and should have been utilized. Note: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if present.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'B9', 'B9', 214, 0, 0, '', 'Patient is enrolled in a Hospice.');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'D23', 'D23', 215, 0, 0, '', 'This dual eligible patient is covered by Medicare Part D per Medicare Retro-Eligibility. At least one Remark Code must be provided (may be comprised of either the NCPDP Reject Reason Code, or Remittance Advice Remark Code that is not an ALERT.)');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'W1', 'W1', 216, 0, 0, '', 'Workers'' compensation jurisdictional fee schedule adjustment. Note: If adjustment is at the Claim Level, the payer must send and the provider should refer to the 835 Class of Contract Code Identification Segment (Loop 2100 Other Claim Related Information ');
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) VALUES ('msp_remit_codes', 'W2', 'W2', 217, 0, 0, '', 'Payment reduced or denied based on workers'' compensation jurisdictional regulations or payment policies, use only if no other code is applicable. Note: If adjustment is at the Claim Level, the payer must send and the provider should refer to the 835 Insur');

INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`) VALUES ('lists','nation_notes_replace_buttons','Nation Notes Replace Buttons',1);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`) VALUES ('nation_notes_replace_buttons','Yes','Yes',10);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`) VALUES ('nation_notes_replace_buttons','No','No',20);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`) VALUES ('nation_notes_replace_buttons','Normal','Normal',30);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`) VALUES ('nation_notes_replace_buttons','Abnormal','Abnormal',40);
insert into `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) values('lists','payment_gateways','Payment Gateways','297','1','0','','');
insert into `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) values('payment_gateways','authorize_net','Authorize.net','1','0','0','','');

insert into list_options (list_id, option_id, title, seq, option_value, mapping, notes) values('lists','ptlistcols','Patient List Columns','1','0','','');
insert into list_options (list_id, option_id, title, seq, option_value, mapping, notes) values('ptlistcols','name'      ,'Full Name'     ,'10','3','','');
insert into list_options (list_id, option_id, title, seq, option_value, mapping, notes) values('ptlistcols','phone_home','Home Phone'    ,'20','3','','');
insert into list_options (list_id, option_id, title, seq, option_value, mapping, notes) values('ptlistcols','ss'        ,'SSN'           ,'30','3','','');
insert into list_options (list_id, option_id, title, seq, option_value, mapping, notes) values('ptlistcols','DOB'       ,'Date of Birth' ,'40','3','','');
insert into list_options (list_id, option_id, title, seq, option_value, mapping, notes) values('ptlistcols','pubpid'    ,'External ID'   ,'50','3','','');

-- Medical Problem Issue List
INSERT INTO list_options(list_id,option_id,title) VALUES ('lists','medical_problem_issue_list','Medical Problem Issue List');
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('medical_problem_issue_list', 'HTN', 'HTN', 10);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('medical_problem_issue_list', 'asthma', 'asthma', 20);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('medical_problem_issue_list', 'diabetes', 'diabetes', 30);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('medical_problem_issue_list', 'hyperlipidemia', 'hyperlipidemia', 40);

-- Medication Issue List
INSERT INTO list_options(list_id,option_id,title) VALUES ('lists','medication_issue_list','Medication Issue List');
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('medication_issue_list', 'Norvasc', 'Norvasc', 10);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('medication_issue_list', 'Lipitor', 'Lipitor', 20);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('medication_issue_list', 'Metformin', 'Metformin', 30);

-- Allergy Issue List
INSERT INTO list_options(list_id,option_id,title) VALUES ('lists','allergy_issue_list','Allergy Issue List');
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('allergy_issue_list', 'penicillin', 'penicillin', 10);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('allergy_issue_list', 'sulfa', 'sulfa', 20);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('allergy_issue_list', 'iodine', 'iodine', 30);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('allergy_issue_list', 'codeine', 'codeine', 40);

-- Surgery Issue List
INSERT INTO list_options(list_id,option_id,title) VALUES ('lists','surgery_issue_list','Surgery Issue List');
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('surgery_issue_list', 'tonsillectomy', 'tonsillectomy', 10);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('surgery_issue_list', 'appendectomy', 'appendectomy', 20);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('surgery_issue_list', 'cholecystectomy', 'cholecystectomy', 30);

-- Dental Issue List
INSERT INTO list_options(list_id,option_id,title) VALUES ('lists','dental_issue_list','Dental Issue List');

-- General Issue List
INSERT INTO list_options(list_id,option_id,title) VALUES ('lists','general_issue_list','General Issue List');
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('general_issue_list', 'Osteopathy', 'Osteopathy', 10);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('general_issue_list', 'Chiropractic', 'Chiropractic', 20);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('general_issue_list', 'Prevention Rehab', 'Prevention Rehab', 30);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('general_issue_list', 'Podiatry', 'Podiatry', 40);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('general_issue_list', 'Strength and Conditioning', 'Strength and Conditioning', 50);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('general_issue_list', 'Nutritional', 'Nutritional', 60);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('general_issue_list', 'Fitness Testing', 'Fitness Testing', 70);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('general_issue_list', 'Pre Participation Assessment', 'Pre Participation Assessment', 80);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('general_issue_list', 'Screening / Testing', 'Screening / Testing', 90);

-- Issue Types List
INSERT INTO list_options (`list_id`,`option_id`,`title`) VALUES ('lists','issue_types','Issue Types');

-- Gender List
INSERT INTO list_options (list_id, option_id, title, seq, is_default) VALUES ('lists','Gender','Gender', 1,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`) VALUES ('Gender','Fem' ,'Female',10,1);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`) VALUES ('Gender','Male','Male'  ,20,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`) VALUES ('Gender','FTM' ,'FTM'   ,30,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`) VALUES ('Gender','MTF' ,'MTF'   ,40,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`) VALUES ('Gender','Oth' ,'Other' ,50,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`) VALUES ('Gender','NS','Not Specified',60,0);

-- Sexual_Orientation List
INSERT INTO list_options (list_id, option_id, title, seq, is_default) VALUES ('lists','Sexual_Orientation','Sexual Orientation', 1,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`) VALUES ('Sexual_Orientation','Bis','Bisexual'     ,10,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`) VALUES ('Sexual_Orientation','Gay','Gay'          ,20,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`) VALUES ('Sexual_Orientation','Het','Heterosexual' ,30,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`) VALUES ('Sexual_Orientation','Les','Lesbian'      ,40,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`) VALUES ('Sexual_Orientation','Msm','MSM'          ,50,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`) VALUES ('Sexual_Orientation','Oth','Other'        ,60,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`) VALUES ('Sexual_Orientation','NS' ,'Not Specified',70,0);

-- LBF layout for referrals
-- INSERT INTO list_options (list_id, option_id, title, seq, is_default, option_value) VALUES ('lbfnames','LBFref' ,'Referral' ,1,0,0);
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('LBFref', '' , 'Referral'        , 'Clinical');
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('LBFref', '1', 'Referral'        , ''        );
INSERT INTO layout_group_properties (grp_form_id, grp_group_id, grp_title, grp_mapping) VALUES ('LBFref', '2', 'Counter-Referral', ''        );
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','refer_date','1','Referral Date',5,4,2,0,0,'',1,1,'C','D','Date of referral',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','refer_from','1','Referred By',10,14,2,0,0,'',1,1,'','','Referral By',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','refer_external','1','Referral Type',15,1,2,0,0,'reftype',1,1,'','','External referral?',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','refer_to','1','Referred To',20,14,2,0,0,'',1,1,'','','Referral To',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','body','1','Reason',25,3,2,30,0,'',1,1,'','','Reason for referral',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','refer_risk_level','1','Risk Level',30,1,1,0,0,'risklevel',1,1,'','','Level of urgency',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','refer_vitals','1','Include Vital Signs',35,1,1,0,0,'boolean',1,1,'','','Include vitals data?',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','refer_reply_date','1','Expected Reply Date',40,4,2,0,0,'',1,1,'','D','Expected date of reply',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','refer_related_code','1','Requested Service',45,15,2,30,255,'',1,1,'','','Billing Code for Requested Service',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','refer_diag','1','Preliminary Diagnosis',50,2,1,30,255,'',1,1,'','X','Referrer diagnosis',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','reply_date','2','Reply Date',5,4,1,0,0,'',1,1,'','D','Date of reply',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','reply_from','2','Reply From',10,2,1,30,255,'',1,1,'','','Who replied?',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','reply_init_diag','2','Presumed Diagnosis',15,2,0,30,255,'',1,1,'','','Presumed diagnosis by specialist',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','reply_final_diag','2','Final Diagnosis',20,2,1,30,255,'',1,1,'','','Final diagnosis by specialist',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','reply_documents','2','Documents',25,2,1,30,255,'',1,1,'','','Where may related scanned or paper documents be found?',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','reply_findings','2','Findings',30,3,1,30,3,'',1,1,'','','Findings by specialist',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','reply_services','2','Services Provided',35,3,0,30,3,'',1,1,'','','Service provided by specialist',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','reply_related_code','2','Service Provided',40,15,1,30,255,'',1,1,'','','Billing Code for actual services provided',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','reply_recommend','2','Recommendations',45,3,1,30,3,'',1,1,'','','Recommendations by specialist',0,'F','');
INSERT INTO `layout_options` (`form_id`, `field_id`, `group_id`, `title`, `seq`, `data_type`, `uor`, `fld_length`, `max_length`, `list_id`, `titlecols`, `datacols`, `default_value`, `edit_options`, `description`, `fld_rows`, `source`, `conditions`) VALUES ('LBFref','reply_rx_refer','2','Prescriptions/Referrals',50,3,1,30,3,'',1,1,'','','Prescriptions and/or referrals by specialist',0,'F','');

-- Patient Flow Board Rooms
INSERT INTO list_options(list_id,option_id,title) VALUES ('lists','patient_flow_board_rooms','Patient Flow Board Rooms');
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('patient_flow_board_rooms', '1', 'Room 1', 10);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('patient_flow_board_rooms', '2', 'Room 2', 20);
INSERT INTO list_options(list_id,option_id,title,seq) VALUES ('patient_flow_board_rooms', '3', 'Room 3', 30);
-- --------------------------------------------------------

-- 
-- Table structure for table `lists`
-- 

DROP TABLE IF EXISTS `lists`;
CREATE TABLE `lists` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `type` varchar(255) default NULL,
  `title` varchar(255) default NULL,
  `begdate` date default NULL,
  `enddate` date default NULL,
  `returndate` date default NULL,
  `occurrence` int(11) default '0',
  `classification` int(11) default '0',
  `referredby` varchar(255) default NULL,
  `extrainfo` varchar(255) default NULL,
  `diagnosis` varchar(255) default NULL,
  `activity` tinyint(4) default NULL,
  `comments` longtext,
  `pid` bigint(20) default NULL,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `outcome` int(11) NOT NULL default '0',
  `destination` varchar(255) default NULL,
  `reinjury_id` bigint(20)  NOT NULL DEFAULT 0,
  `injury_part` varchar(31) NOT NULL DEFAULT '',
  `injury_type` varchar(31) NOT NULL DEFAULT '',
  `injury_grade` varchar(31) NOT NULL DEFAULT '',
  `reaction` varchar(255) NOT NULL DEFAULT '',
  `external_allergyid` INT(11) DEFAULT NULL,
  `erx_source` ENUM('0','1') DEFAULT '0' NOT NULL  COMMENT '0-OpenEMR 1-External',
  `erx_uploaded` ENUM('0','1') DEFAULT '0' NOT NULL  COMMENT '0-Pending NewCrop upload 1-Uploaded TO NewCrop',
  `modifydate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`),
  KEY `type` (`type`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `lists_touch`
--

DROP TABLE IF EXISTS `lists_touch`;
CREATE TABLE `lists_touch` (
  `pid` bigint(20) NOT NULL default 0,
  `type` varchar(255) NOT NULL default '',
  `date` datetime default NULL,
  PRIMARY KEY  (`pid`,`type`)
) ENGINE=MyISAM ;

-- --------------------------------------------------------

-- 
-- Table structure for table `log`
-- 

DROP TABLE IF EXISTS `log`;
CREATE TABLE `log` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `event` varchar(255) default NULL,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `comments` longtext,
  `user_notes` longtext,
  `patient_id` bigint(20) default NULL,
  `success` tinyint(1) default 1,
  `checksum` longtext default NULL,
  `crt_user` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;


-- --------------------------------------------------------

-- 
-- Table structure for table `notes`
-- 

DROP TABLE IF EXISTS `notes`;
CREATE TABLE `notes` (
  `id` int(11) NOT NULL default '0',
  `foreign_id` int(11) NOT NULL default '0',
  `note` varchar(255) default NULL,
  `owner` int(11) default NULL,
  `date` datetime default NULL,
  `revision` timestamp NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `foreign_id` (`owner`),
  KEY `foreign_id_2` (`foreign_id`),
  KEY `date` (`date`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `onotes`
-- 

DROP TABLE IF EXISTS `onotes`;
CREATE TABLE `onotes` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `body` longtext,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `activity` tinyint(4) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_module_vars`
-- 

DROP TABLE IF EXISTS `openemr_module_vars`;
CREATE TABLE `openemr_module_vars` (
  `pn_id` int(11) unsigned NOT NULL auto_increment,
  `pn_modname` varchar(64) default NULL,
  `pn_name` varchar(64) default NULL,
  `pn_value` longtext,
  PRIMARY KEY  (`pn_id`),
  KEY `pn_modname` (`pn_modname`),
  KEY `pn_name` (`pn_name`)
) ENGINE=MyISAM AUTO_INCREMENT=235 ;

-- 
-- Dumping data for table `openemr_module_vars`
-- 

INSERT INTO `openemr_module_vars` VALUES (234, 'PostCalendar', 'pcNotifyEmail', '');
INSERT INTO `openemr_module_vars` VALUES (233, 'PostCalendar', 'pcNotifyAdmin', '0');
INSERT INTO `openemr_module_vars` VALUES (232, 'PostCalendar', 'pcCacheLifetime', '3600');
INSERT INTO `openemr_module_vars` VALUES (231, 'PostCalendar', 'pcUseCache', '0');
INSERT INTO `openemr_module_vars` VALUES (230, 'PostCalendar', 'pcDefaultView', 'day');
INSERT INTO `openemr_module_vars` VALUES (229, 'PostCalendar', 'pcTimeIncrement', '5');
INSERT INTO `openemr_module_vars` VALUES (228, 'PostCalendar', 'pcAllowUserCalendar', '1');
INSERT INTO `openemr_module_vars` VALUES (227, 'PostCalendar', 'pcAllowSiteWide', '1');
INSERT INTO `openemr_module_vars` VALUES (226, 'PostCalendar', 'pcTemplate', 'default');
INSERT INTO `openemr_module_vars` VALUES (225, 'PostCalendar', 'pcEventDateFormat', '%Y-%m-%d');
INSERT INTO `openemr_module_vars` VALUES (224, 'PostCalendar', 'pcDisplayTopics', '0');
INSERT INTO `openemr_module_vars` VALUES (223, 'PostCalendar', 'pcListHowManyEvents', '15');
INSERT INTO `openemr_module_vars` VALUES (222, 'PostCalendar', 'pcAllowDirectSubmit', '1');
INSERT INTO `openemr_module_vars` VALUES (221, 'PostCalendar', 'pcUsePopups', '0');
INSERT INTO `openemr_module_vars` VALUES (220, 'PostCalendar', 'pcDayHighlightColor', '#EEEEEE');
INSERT INTO `openemr_module_vars` VALUES (219, 'PostCalendar', 'pcFirstDayOfWeek', '1');
INSERT INTO `openemr_module_vars` VALUES (218, 'PostCalendar', 'pcUseInternationalDates', '0');
INSERT INTO `openemr_module_vars` VALUES (217, 'PostCalendar', 'pcEventsOpenInNewWindow', '0');
INSERT INTO `openemr_module_vars` VALUES (216, 'PostCalendar', 'pcTime24Hours', '0');

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_modules`
-- 

DROP TABLE IF EXISTS `openemr_modules`;
CREATE TABLE `openemr_modules` (
  `pn_id` int(11) unsigned NOT NULL auto_increment,
  `pn_name` varchar(64) default NULL,
  `pn_type` int(6) NOT NULL default '0',
  `pn_displayname` varchar(64) default NULL,
  `pn_description` varchar(255) default NULL,
  `pn_regid` int(11) unsigned NOT NULL default '0',
  `pn_directory` varchar(64) default NULL,
  `pn_version` varchar(10) default NULL,
  `pn_admin_capable` tinyint(1) NOT NULL default '0',
  `pn_user_capable` tinyint(1) NOT NULL default '0',
  `pn_state` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`pn_id`)
) ENGINE=MyISAM AUTO_INCREMENT=47 ;

-- 
-- Dumping data for table `openemr_modules`
-- 

INSERT INTO `openemr_modules` VALUES (46, 'PostCalendar', 2, 'PostCalendar', 'PostNuke Calendar Module', 0, 'PostCalendar', '4.0.0', 1, 1, 3);

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_postcalendar_categories`
-- 

DROP TABLE IF EXISTS `openemr_postcalendar_categories`;
CREATE TABLE `openemr_postcalendar_categories` (
  `pc_catid` int(11) unsigned NOT NULL auto_increment,
  `pc_catname` varchar(100) default NULL,
  `pc_catcolor` varchar(50) default NULL,
  `pc_catdesc` text,
  `pc_recurrtype` int(1) NOT NULL default '0',
  `pc_enddate` date default NULL,
  `pc_recurrspec` text,
  `pc_recurrfreq` int(3) NOT NULL default '0',
  `pc_duration` bigint(20) NOT NULL default '0',
  `pc_end_date_flag` tinyint(1) NOT NULL default '0',
  `pc_end_date_type` int(2) default NULL,
  `pc_end_date_freq` int(11) NOT NULL default '0',
  `pc_end_all_day` tinyint(1) NOT NULL default '0',
  `pc_dailylimit` int(2) NOT NULL default '0',
  `pc_cattype` INT( 11 ) NOT NULL COMMENT 'Used in grouping categories',
  PRIMARY KEY  (`pc_catid`),
  KEY `basic_cat` (`pc_catname`,`pc_catcolor`)
) ENGINE=MyISAM AUTO_INCREMENT=11 ;

-- 
-- Dumping data for table `openemr_postcalendar_categories`
-- 

INSERT INTO `openemr_postcalendar_categories` VALUES (5, 'Office Visit', '#FFFFCC', 'Normal Office Visit', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 900, 0, 0, 0, 0, 0,0);
INSERT INTO `openemr_postcalendar_categories` VALUES (4, 'Vacation', '#EFEFEF', 'Reserved for use to define Scheduled Vacation Time', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 0, 0, 0, 0, 1, 0, 1);
INSERT INTO `openemr_postcalendar_categories` VALUES (1, 'No Show', '#DDDDDD', 'Reserved to define when an event did not occur as specified.', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 0, 0, 0, 0, 0, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (2, 'In Office', '#99CCFF', 'Reserved todefine when a provider may haveavailable appointments after.', 1, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 0, 1, 3, 2, 0, 0, 1);
INSERT INTO `openemr_postcalendar_categories` VALUES (3, 'Out Of Office', '#99FFFF', 'Reserved to define when a provider may not have available appointments after.', 1, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 0, 1, 3, 2, 0, 0, 1);
INSERT INTO `openemr_postcalendar_categories` VALUES (8, 'Lunch', '#FFFF33', 'Lunch', 1, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 3600, 0, 3, 2, 0, 0, 1);
INSERT INTO `openemr_postcalendar_categories` VALUES (9, 'Established Patient', '#CCFF33', '', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 900, 0, 0, 0, 0, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (10,'New Patient', '#CCFFFF', '', 0, NULL, 'a:5:{s:17:"event_repeat_freq";s:1:"0";s:22:"event_repeat_freq_type";s:1:"0";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, 1800, 0, 0, 0, 0, 0, 0);
INSERT INTO `openemr_postcalendar_categories` VALUES (11,'Reserved','#FF7777','Reserved',1,NULL,'a:5:{s:17:\"event_repeat_freq\";s:1:\"1\";s:22:\"event_repeat_freq_type\";s:1:\"4\";s:19:\"event_repeat_on_num\";s:1:\"1\";s:19:\"event_repeat_on_day\";s:1:\"0\";s:20:\"event_repeat_on_freq\";s:1:\"0\";}',0,900,0,3,2,0,0, 1);

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_postcalendar_events`
-- 

DROP TABLE IF EXISTS `openemr_postcalendar_events`;
CREATE TABLE `openemr_postcalendar_events` (
  `pc_eid` int(11) unsigned NOT NULL auto_increment,
  `pc_catid` int(11) NOT NULL default '0',
  `pc_multiple` int(10) unsigned NOT NULL,
  `pc_aid` varchar(30) default NULL,
  `pc_pid` varchar(11) default NULL,
  `pc_title` varchar(150) default NULL,
  `pc_time` datetime default NULL,
  `pc_hometext` text,
  `pc_comments` int(11) default '0',
  `pc_counter` mediumint(8) unsigned default '0',
  `pc_topic` int(3) NOT NULL default '1',
  `pc_informant` varchar(20) default NULL,
  `pc_eventDate` date default NULL,
  `pc_endDate` date default NULL,
  `pc_duration` bigint(20) NOT NULL default '0',
  `pc_recurrtype` int(1) NOT NULL default '0',
  `pc_recurrspec` text,
  `pc_recurrfreq` int(3) NOT NULL default '0',
  `pc_startTime` time default NULL,
  `pc_endTime` time default NULL,
  `pc_alldayevent` int(1) NOT NULL default '0',
  `pc_location` text,
  `pc_conttel` varchar(50) default NULL,
  `pc_contname` varchar(50) default NULL,
  `pc_contemail` varchar(255) default NULL,
  `pc_website` varchar(255) default NULL,
  `pc_fee` varchar(50) default NULL,
  `pc_eventstatus` int(11) NOT NULL default '0',
  `pc_sharing` int(11) NOT NULL default '0',
  `pc_language` varchar(30) default NULL,
  `pc_apptstatus` varchar(15) NOT NULL default '-',
  `pc_prefcatid` int(11) NOT NULL default '0',
  `pc_facility` smallint(6) NOT NULL default '0' COMMENT 'facility id for this event',
  `pc_sendalertsms` VARCHAR(3) NOT NULL DEFAULT 'NO',
  `pc_sendalertemail` VARCHAR( 3 ) NOT NULL DEFAULT 'NO',
  `pc_billing_location` SMALLINT (6) NOT NULL DEFAULT '0',
  `pc_room` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY  (`pc_eid`),
  KEY `basic_event` (`pc_catid`,`pc_aid`,`pc_eventDate`,`pc_endDate`,`pc_eventstatus`,`pc_sharing`,`pc_topic`),
  KEY `pc_eventDate` (`pc_eventDate`)
) ENGINE=MyISAM AUTO_INCREMENT=7 ;

-- 
-- Dumping data for table `openemr_postcalendar_events`
-- 

INSERT INTO `openemr_postcalendar_events` VALUES (3, 2, 0, '1', '', 'In Office', '2005-03-03 12:22:31', ':text:', 0, 0, 0, '1', '2005-03-03', '2007-03-03', 0, 1, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, '09:00:00', '09:00:00', 0, 'a:6:{s:14:"event_location";N;s:13:"event_street1";N;s:13:"event_street2";N;s:10:"event_city";N;s:11:"event_state";N;s:12:"event_postal";N;}', '', '', '', '', '', 1, 1, '', '-', 0, 0, 'NO', 'NO');
INSERT INTO `openemr_postcalendar_events` VALUES (5, 3, 0, '1', '', 'Out Of Office', '2005-03-03 12:22:52', ':text:', 0, 0, 0, '1', '2005-03-03', '2007-03-03', 0, 1, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, '17:00:00', '17:00:00', 0, 'a:6:{s:14:"event_location";N;s:13:"event_street1";N;s:13:"event_street2";N;s:10:"event_city";N;s:11:"event_state";N;s:12:"event_postal";N;}', '', '', '', '', '', 1, 1, '', '-', 0, 0, 'NO', 'NO');
INSERT INTO `openemr_postcalendar_events` VALUES (6, 8, 0, '1', '', 'Lunch', '2005-03-03 12:23:31', ':text:', 0, 0, 0, '1', '2005-03-03', '2007-03-03', 3600, 1, 'a:5:{s:17:"event_repeat_freq";s:1:"1";s:22:"event_repeat_freq_type";s:1:"4";s:19:"event_repeat_on_num";s:1:"1";s:19:"event_repeat_on_day";s:1:"0";s:20:"event_repeat_on_freq";s:1:"0";}', 0, '12:00:00', '13:00:00', 0, 'a:6:{s:14:"event_location";N;s:13:"event_street1";N;s:13:"event_street2";N;s:10:"event_city";N;s:11:"event_state";N;s:12:"event_postal";N;}', '', '', '', '', '', 1, 1, '', '-', 0, 0, 'NO', 'NO');

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_postcalendar_limits`
-- 

DROP TABLE IF EXISTS `openemr_postcalendar_limits`;
CREATE TABLE `openemr_postcalendar_limits` (
  `pc_limitid` int(11) NOT NULL auto_increment,
  `pc_catid` int(11) NOT NULL default '0',
  `pc_starttime` time NOT NULL default '00:00:00',
  `pc_endtime` time NOT NULL default '00:00:00',
  `pc_limit` int(11) NOT NULL default '1',
  PRIMARY KEY  (`pc_limitid`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_postcalendar_topics`
-- 

DROP TABLE IF EXISTS `openemr_postcalendar_topics`;
CREATE TABLE `openemr_postcalendar_topics` (
  `pc_catid` int(11) unsigned NOT NULL auto_increment,
  `pc_catname` varchar(100) default NULL,
  `pc_catcolor` varchar(50) default NULL,
  `pc_catdesc` text,
  PRIMARY KEY  (`pc_catid`),
  KEY `basic_cat` (`pc_catname`,`pc_catcolor`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `openemr_session_info`
-- 

DROP TABLE IF EXISTS `openemr_session_info`;
CREATE TABLE `openemr_session_info` (
  `pn_sessid` varchar(32) NOT NULL default '',
  `pn_ipaddr` varchar(20) default NULL,
  `pn_firstused` int(11) NOT NULL default '0',
  `pn_lastused` int(11) NOT NULL default '0',
  `pn_uid` int(11) NOT NULL default '0',
  `pn_vars` blob,
  PRIMARY KEY  (`pn_sessid`)
) ENGINE=MyISAM;

-- 
-- Dumping data for table `openemr_session_info`
-- 

INSERT INTO `openemr_session_info` VALUES ('978d31441dccd350d406bfab98978f20', '127.0.0.1', 1109233952, 1109234177, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `patient_access_onsite`
--

DROP TABLE IF EXISTS `patient_access_onsite`;
CREATE TABLE `patient_access_onsite`(
  `id` INT NOT NULL AUTO_INCREMENT ,
  `pid` INT(11),
  `portal_username` VARCHAR(100) ,
  `portal_pwd` VARCHAR(100) ,
  `portal_pwd_status` TINYINT DEFAULT '1' COMMENT '0=>Password Created Through Demographics by The provider or staff. Patient Should Change it at first time it.1=>Pwd updated or created by patient itself',
  `portal_salt` VARCHAR(100) ,
  PRIMARY KEY (`id`)
)ENGINE=MyISAM AUTO_INCREMENT=1;

-- --------------------------------------------------------

-- 
-- Table structure for table `patient_data`
-- 

DROP TABLE IF EXISTS `patient_data`;
CREATE TABLE `patient_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `title` varchar(255) NOT NULL default '',
  `language` varchar(255) NOT NULL default '',
  `financial` varchar(255) NOT NULL default '',
  `fname` varchar(255) NOT NULL default '',
  `lname` varchar(255) NOT NULL default '',
  `mname` varchar(255) NOT NULL default '',
  `prefname` text NOT NULL,
  `DOB` date default NULL,
  `street` varchar(255) NOT NULL default '',
  `postal_code` varchar(255) NOT NULL default '',
  `city` varchar(255) NOT NULL default '',
  `state` varchar(255) NOT NULL default '',
  `country_code` varchar(255) NOT NULL default '',
  `drivers_license` varchar(255) NOT NULL default '',
  `ss` varchar(255) NOT NULL default '',
  `occupation` longtext,
  `phone_home` varchar(255) NOT NULL default '',
  `phone_biz` varchar(255) NOT NULL default '',
  `phone_contact` varchar(255) NOT NULL default '',
  `phone_cell` varchar(255) NOT NULL default '',
  `pharmacy_id` int(11) NOT NULL default '0',
  `status` varchar(255) NOT NULL default '',
  `contact_relationship` varchar(255) NOT NULL default '',
  `date` datetime default NULL,
  `sex` varchar(255) NOT NULL default '',
  `referrer` varchar(255) NOT NULL default '',
  `referrerID` varchar(255) NOT NULL default '',
  `providerID` int(11) default NULL,
  `ref_providerID` int(11) default NULL,
  `email` varchar(255) NOT NULL default '',
  `email_direct` varchar(255) NOT NULL default '',
  `ethnoracial` varchar(255) NOT NULL default '',
  `race` varchar(255) NOT NULL default '',
  `ethnicity` varchar(255) NOT NULL default '',
  `interpretter` varchar(255) NOT NULL default '',
  `migrantseasonal` varchar(255) NOT NULL default '',
  `family_size` varchar(255) NOT NULL default '',
  `monthly_income` varchar(255) NOT NULL default '',
  `homeless` varchar(255) NOT NULL default '',
  `financial_review` datetime default NULL,
  `pubpid` varchar(255) NOT NULL default '',
  `pid` bigint(20) NOT NULL default '0',
  `genericname1` varchar(255) NOT NULL default '',
  `genericval1` varchar(255) NOT NULL default '',
  `genericname2` varchar(255) NOT NULL default '',
  `genericval2` varchar(255) NOT NULL default '',
  `hipaa_mail` varchar(3) NOT NULL default '',
  `hipaa_voice` varchar(3) NOT NULL default '',
  `hipaa_notice` varchar(3) NOT NULL default '',
  `hipaa_message` varchar(20) NOT NULL default '',
  `hipaa_allowsms` VARCHAR(3) NOT NULL DEFAULT 'NO',
  `hipaa_allowemail` VARCHAR(3) NOT NULL DEFAULT 'NO',
  `squad` varchar(32) NOT NULL default '',
  `fitness` int(11) NOT NULL default '0',
  `referral_source` varchar(30) NOT NULL default '',
  `usertext1` varchar(255) NOT NULL DEFAULT '',
  `usertext2` varchar(255) NOT NULL DEFAULT '',
  `usertext3` varchar(255) NOT NULL DEFAULT '',
  `usertext4` varchar(255) NOT NULL DEFAULT '',
  `usertext5` varchar(255) NOT NULL DEFAULT '',
  `usertext6` varchar(255) NOT NULL DEFAULT '',
  `usertext7` varchar(255) NOT NULL DEFAULT '',
  `usertext8` varchar(255) NOT NULL DEFAULT '',
  `userlist1` varchar(255) NOT NULL DEFAULT '',
  `userlist2` varchar(255) NOT NULL DEFAULT '',
  `userlist3` varchar(255) NOT NULL DEFAULT '',
  `userlist4` varchar(255) NOT NULL DEFAULT '',
  `userlist5` varchar(255) NOT NULL DEFAULT '',
  `userlist6` varchar(255) NOT NULL DEFAULT '',
  `userlist7` varchar(255) NOT NULL DEFAULT '',
  `pricelevel` varchar(255) NOT NULL default 'standard',
  `regdate`     date DEFAULT NULL COMMENT 'Registration Date',
  `contrastart` date DEFAULT NULL COMMENT 'Date contraceptives initially used',
  `completed_ad` VARCHAR(3) NOT NULL DEFAULT 'NO',
  `ad_reviewed` date DEFAULT NULL,
  `vfc` varchar(255) NOT NULL DEFAULT '',
  `mothersname` varchar(255) NOT NULL DEFAULT '',
  `guardiansname` varchar(255) NOT NULL DEFAULT '',
  `allow_imm_reg_use` varchar(255) NOT NULL DEFAULT '',
  `allow_imm_info_share` varchar(255) NOT NULL DEFAULT '',
  `allow_health_info_ex` varchar(255) NOT NULL DEFAULT '',
  `allow_patient_portal` varchar(31) NOT NULL DEFAULT '',
  `deceased_date` datetime default NULL,
  `deceased_reason` varchar(255) NOT NULL default '',
  `soap_import_status` TINYINT(4) DEFAULT NULL COMMENT '1-Prescription Press 2-Prescription Import 3-Allergy Press 4-Allergy Import',
  `gender` varchar(31) NOT NULL default '',
  `sexual_orientation` varchar(31) NOT NULL default '',
  `dupscore` INT NOT NULL default -9,
  `home_facility` int(11) NOT NULL DEFAULT 0,
  UNIQUE KEY `pid` (`pid`),
  KEY `id` (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `patient_reminders`
--

DROP TABLE IF EXISTS `patient_reminders`;
CREATE TABLE `patient_reminders` (
  `id` bigint(20) NOT NULL auto_increment,
  `active` tinyint(1) NOT NULL default 1 COMMENT '1 if active and 0 if not active',
  `date_inactivated` datetime DEFAULT NULL,
  `reason_inactivated` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to list_options list rule_reminder_inactive_opt',
  `due_status` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to list_options list rule_reminder_due_opt',
  `pid` bigint(20) NOT NULL COMMENT 'id from patient_data table',
  `category` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to the category item in the rule_action_item table',
  `item` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to the item column in the rule_action_item table',
  `date_created` datetime DEFAULT NULL,
  `date_sent` datetime DEFAULT NULL,
  `voice_status` tinyint(1) NOT NULL default 0 COMMENT '0 if not sent and 1 if sent',
  `sms_status` tinyint(1) NOT NULL default 0 COMMENT '0 if not sent and 1 if sent',
  `email_status` tinyint(1) NOT NULL default 0 COMMENT '0 if not sent and 1 if sent',
  `mail_status` tinyint(1) NOT NULL default 0 COMMENT '0 if not sent and 1 if sent',
  PRIMARY KEY (`id`),
  KEY `pid` (`pid`),
  KEY (`category`,`item`)
) ENGINE=MyISAM AUTO_INCREMENT=1;

-- --------------------------------------------------------

--
-- Table structure for table `patient_access_offsite`
--

DROP TABLE IF EXISTS `patient_access_offsite`;
CREATE TABLE  `patient_access_offsite` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL,
  `portal_username` varchar(100) NOT NULL,
  `portal_pwd` varchar(100) NOT NULL,
  `portal_pwd_status` tinyint(4) DEFAULT '1' COMMENT '0=>Password Created Through Demographics by The provider or staff. Patient Should Change it at first time it.1=>Pwd updated or created by patient itself',
  `authorize_net_id` VARCHAR(20) COMMENT 'authorize.net profile id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `pid` (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=1;

-- 
-- Table structure for table `patient_tracker`
-- 

DROP TABLE IF EXISTS `patient_tracker`;
CREATE TABLE IF NOT EXISTS `patient_tracker` (
  `id`                     bigint(20)   NOT NULL auto_increment,
  `date`                   datetime     DEFAULT NULL,
  `apptdate`               date         DEFAULT NULL,
  `appttime`               time         DEFAULT NULL,
  `eid`                    bigint(20)   NOT NULL default '0',
  `pid`                    bigint(20)   NOT NULL default '0',
  `original_user`          varchar(255) NOT NULL default '' COMMENT 'This is the user that created the original record',
  `encounter`              bigint(20)   NOT NULL default '0',
  `lastseq`                varchar(4)   NOT NULL default '' COMMENT 'The element file should contain this number of elements',
  `random_drug_test`       TINYINT(1)   DEFAULT NULL COMMENT 'NULL if not randomized. If randomized, 0 is no, 1 is yes',
  `drug_screen_completed`  TINYINT(1)   NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY (`eid`),
  KEY (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=1;

-- 
-- Table structure for table `patient_tracker_element`
-- 

DROP TABLE IF EXISTS `patient_tracker_element`;
CREATE TABLE IF NOT EXISTS `patient_tracker_element` (
  `pt_tracker_id`      bigint(20)   NOT NULL default '0' COMMENT 'maps to id column in patient_tracker table',
  `start_datetime`     datetime     DEFAULT NULL,
  `room`               varchar(20)  NOT NULL default '',
  `status`             varchar(31)  NOT NULL default '',
  `seq`                varchar(4)   NOT NULL default '' COMMENT 'This is a numerical sequence for this pt_tracker_id events',
  `user`               varchar(255) NOT NULL default '' COMMENT 'This is the user that created this element',
  KEY  (`pt_tracker_id`,`seq`)
) ENGINE=MyISAM;

-- 
-- Table structure for table `payments`
-- 

DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments` (
  `id` bigint(20) NOT NULL auto_increment,
  `pid` bigint(20) NOT NULL default '0',
  `dtime` datetime NOT NULL,
  `encounter` bigint(20) NOT NULL default '0',
  `user` varchar(255) default NULL,
  `method` varchar(255) default NULL,
  `source` varchar(255) default NULL,
  `amount1` decimal(12,2) NOT NULL default '0.00',
  `amount2` decimal(12,2) NOT NULL default '0.00',
  `posted1` decimal(12,2) NOT NULL default '0.00',
  `posted2` decimal(12,2) NOT NULL default '0.00',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `payment_gateway_details`
--
CREATE TABLE `payment_gateway_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `service_name` varchar(100) DEFAULT NULL,
  `login_id` varchar(255) DEFAULT NULL,
  `transaction_key` varchar(255) DEFAULT NULL,
  `md5` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- --------------------------------------------------------

-- 
-- Table structure for table `pharmacies`
-- 

DROP TABLE IF EXISTS `pharmacies`;
CREATE TABLE `pharmacies` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(255) default NULL,
  `transmit_method` int(11) NOT NULL default '1',
  `email` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `phone_numbers`
-- 

DROP TABLE IF EXISTS `phone_numbers`;
CREATE TABLE `phone_numbers` (
  `id` int(11) NOT NULL default '0',
  `country_code` varchar(5) default NULL,
  `area_code` char(3) default NULL,
  `prefix` char(3) default NULL,
  `number` varchar(4) default NULL,
  `type` int(11) default NULL,
  `foreign_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `foreign_id` (`foreign_id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_bookmark`
-- 

DROP TABLE IF EXISTS `pma_bookmark`;
CREATE TABLE `pma_bookmark` (
  `id` int(11) NOT NULL auto_increment,
  `dbase` varchar(255) default NULL,
  `user` varchar(255) default NULL,
  `label` varchar(255) default NULL,
  `query` text,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM COMMENT='Bookmarks' AUTO_INCREMENT=10 ;

-- 
-- Dumping data for table `pma_bookmark`
-- 

INSERT INTO `pma_bookmark` VALUES (2, 'openemr', 'openemr', 'Aggregate Race Statistics', 'SELECT ethnoracial as "Race/Ethnicity", count(*) as Count FROM  `patient_data` WHERE 1 group by ethnoracial');
INSERT INTO `pma_bookmark` VALUES (9, 'openemr', 'openemr', 'Search by Code', 'SELECT  b.code, concat(pd.fname," ", pd.lname) as "Patient Name", concat(u.fname," ", u.lname) as "Provider Name", en.reason as "Encounter Desc.", en.date\r\nFROM billing as b\r\nLEFT JOIN users AS u ON b.user = u.id\r\nLEFT JOIN patient_data as pd on b.pid = pd.pid\r\nLEFT JOIN form_encounter as en on b.encounter = en.encounter and b.pid = en.pid\r\nWHERE 1 /* and b.code like ''%[VARIABLE]%'' */ ORDER BY b.code');
INSERT INTO `pma_bookmark` VALUES (8, 'openemr', 'openemr', 'Count No Shows By Provider since Interval ago', 'SELECT concat( u.fname,  " ", u.lname )  AS  "Provider Name", u.id AS  "Provider ID", count(  DISTINCT ev.pc_eid )  AS  "Number of No Shows"/* , concat(DATE_FORMAT(NOW(),''%Y-%m-%d''), '' and '',DATE_FORMAT(DATE_ADD(now(), INTERVAL [VARIABLE]),''%Y-%m-%d'') ) as "Between Dates" */ FROM  `openemr_postcalendar_events`  AS ev LEFT  JOIN users AS u ON ev.pc_aid = u.id WHERE ev.pc_catid =1/* and ( ev.pc_eventDate >= DATE_SUB(now(), INTERVAL [VARIABLE]) )  */\r\nGROUP  BY u.id;');
INSERT INTO `pma_bookmark` VALUES (6, 'openemr', 'openemr', 'Appointments By Race/Ethnicity from today plus interval', 'SELECT  count(pd.ethnoracial) as "Number of Appointments", pd.ethnoracial AS  "Race/Ethnicity" /* , concat(DATE_FORMAT(NOW(),''%Y-%m-%d''), '' and '',DATE_FORMAT(DATE_ADD(now(), INTERVAL [VARIABLE]),''%Y-%m-%d'') ) as "Between Dates" */ FROM openemr_postcalendar_events AS ev LEFT  JOIN   `patient_data`  AS pd ON  pd.pid = ev.pc_pid where ev.pc_eventstatus=1 and ev.pc_catid = 5 and ev.pc_eventDate >= now()  /* and ( ev.pc_eventDate <= DATE_ADD(now(), INTERVAL [VARIABLE]) )  */ group by pd.ethnoracial');

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_column_info`
-- 

DROP TABLE IF EXISTS `pma_column_info`;
CREATE TABLE `pma_column_info` (
  `id` int(5) unsigned NOT NULL auto_increment,
  `db_name` varchar(64) default NULL,
  `table_name` varchar(64) default NULL,
  `column_name` varchar(64) default NULL,
  `comment` varchar(255) default NULL,
  `mimetype` varchar(255) default NULL,
  `transformation` varchar(255) default NULL,
  `transformation_options` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`)
) ENGINE=MyISAM COMMENT='Column Information for phpMyAdmin' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_history`
-- 

DROP TABLE IF EXISTS `pma_history`;
CREATE TABLE `pma_history` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `username` varchar(64) default NULL,
  `db` varchar(64) default NULL,
  `table` varchar(64) default NULL,
  `timevalue` timestamp NOT NULL,
  `sqlquery` text,
  PRIMARY KEY  (`id`),
  KEY `username` (`username`,`db`,`table`,`timevalue`)
) ENGINE=MyISAM COMMENT='SQL history' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_pdf_pages`
-- 

DROP TABLE IF EXISTS `pma_pdf_pages`;
CREATE TABLE `pma_pdf_pages` (
  `db_name` varchar(64) default NULL,
  `page_nr` int(10) unsigned NOT NULL auto_increment,
  `page_descr` varchar(50) default NULL,
  PRIMARY KEY  (`page_nr`),
  KEY `db_name` (`db_name`)
) ENGINE=MyISAM COMMENT='PDF Relationpages for PMA' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_relation`
-- 

DROP TABLE IF EXISTS `pma_relation`;
CREATE TABLE `pma_relation` (
  `master_db` varchar(64) NOT NULL default '',
  `master_table` varchar(64) NOT NULL default '',
  `master_field` varchar(64) NOT NULL default '',
  `foreign_db` varchar(64) default NULL,
  `foreign_table` varchar(64) default NULL,
  `foreign_field` varchar(64) default NULL,
  PRIMARY KEY  (`master_db`,`master_table`,`master_field`),
  KEY `foreign_field` (`foreign_db`,`foreign_table`)
) ENGINE=MyISAM COMMENT='Relation table';

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_table_coords`
-- 

DROP TABLE IF EXISTS `pma_table_coords`;
CREATE TABLE `pma_table_coords` (
  `db_name` varchar(64) NOT NULL default '',
  `table_name` varchar(64) NOT NULL default '',
  `pdf_page_number` int(11) NOT NULL default '0',
  `x` float unsigned NOT NULL default '0',
  `y` float unsigned NOT NULL default '0',
  PRIMARY KEY  (`db_name`,`table_name`,`pdf_page_number`)
) ENGINE=MyISAM COMMENT='Table coordinates for phpMyAdmin PDF output';

-- --------------------------------------------------------

-- 
-- Table structure for table `pma_table_info`
-- 

DROP TABLE IF EXISTS `pma_table_info`;
CREATE TABLE `pma_table_info` (
  `db_name` varchar(64) NOT NULL default '',
  `table_name` varchar(64) NOT NULL default '',
  `display_field` varchar(64) default NULL,
  PRIMARY KEY  (`db_name`,`table_name`)
) ENGINE=MyISAM COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

-- 
-- Table structure for table `pnotes`
-- 

DROP TABLE IF EXISTS `pnotes`;
CREATE TABLE `pnotes` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `body` longtext,
  `pid` bigint(20) default NULL,
  `user` varchar(255) default NULL,
  `groupname` varchar(255) default NULL,
  `activity` tinyint(4) default NULL,
  `authorized` tinyint(4) default NULL,
  `title` varchar(255) default NULL,
  `assigned_to` varchar(255) default NULL,
  `deleted` tinyint(4) default 0 COMMENT 'flag indicates note is deleted',
  `message_status` VARCHAR(20) NOT NULL DEFAULT 'New',
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `prescriptions`
-- 

DROP TABLE IF EXISTS `prescriptions`;
CREATE TABLE `prescriptions` (
  `id` int(11) NOT NULL auto_increment,
  `patient_id` int(11) default NULL,
  `filled_by_id` int(11) default NULL,
  `pharmacy_id` int(11) default NULL,
  `date_added` date default NULL,
  `date_modified` date default NULL,
  `provider_id` int(11) default NULL,
  `encounter` int(11) default NULL,
  `start_date` date default NULL,
  `drug` varchar(150) default NULL,
  `drug_id` int(11) NOT NULL default '0',
  `rxnorm_drugcode` INT(11) DEFAULT NULL,
  `form` int(3) default NULL,
  `dosage` varchar(100) default NULL,
  `quantity` varchar(31) default NULL,
  `size` float unsigned default NULL,
  `unit` int(11) default NULL,
  `route` int(11) default NULL,
  `interval` int(11) default NULL,
  `substitute` int(11) default NULL,
  `refills` int(11) default NULL,
  `per_refill` int(11) default NULL,
  `filled_date` date default NULL,
  `medication` int(11) default NULL,
  `note` text,
  `active` int(11) NOT NULL default '1',
  `datetime` DATETIME DEFAULT NULL,
  `user` VARCHAR(50) DEFAULT NULL,
  `site` VARCHAR(50) DEFAULT NULL,
  `prescriptionguid` VARCHAR(50) DEFAULT NULL,
  `erx_source` TINYINT(4) NOT NULL DEFAULT '0' COMMENT '0-OpenEMR 1-External',
  `erx_uploaded` TINYINT(4) NOT NULL DEFAULT '0' COMMENT '0-Pending NewCrop upload 1-Uploaded to NewCrop',
  `drug_info_erx` TEXT DEFAULT NULL,
  PRIMARY KEY  (`id`),
  KEY `patient_id` (`patient_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `prices`
-- 

DROP TABLE IF EXISTS `prices`;
CREATE TABLE `prices` (
  `pr_id` varchar(11) NOT NULL default '',
  `pr_selector` varchar(255) NOT NULL default '' COMMENT 'template selector for drugs, empty for codes',
  `pr_level` varchar(31) NOT NULL default '',
  `pr_price` decimal(12,2) NOT NULL default '0.00' COMMENT 'price in local currency',
  PRIMARY KEY  (`pr_id`,`pr_selector`,`pr_level`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

-- 
-- Table structure for table `registry`
-- 

DROP TABLE IF EXISTS `registry`;
CREATE TABLE `registry` (
  `name` varchar(255) default NULL,
  `state` tinyint(4) default NULL,
  `directory` varchar(255) default NULL,
  `id` bigint(20) NOT NULL auto_increment,
  `sql_run` tinyint(4) default NULL,
  `unpackaged` tinyint(4) default NULL,
  `date` datetime default NULL,
  `priority` int(11) default '0',
  `category` varchar(255) default NULL,
  `nickname` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 ;

-- 
-- Dumping data for table `registry`
-- 

INSERT INTO `registry` VALUES ('New Encounter Form', 1, 'newpatient', 1, 1, 1, '2003-09-14 15:16:45', 0, 'Administrative', '');
INSERT INTO `registry` VALUES ('Review of Systems Checks', 1, 'reviewofs', 9, 1, 1, '2003-09-14 15:16:45', 0, 'Clinical', '');
INSERT INTO `registry` VALUES ('Speech Dictation', 1, 'dictation', 10, 1, 1, '2003-09-14 15:16:45', 0, 'Clinical', '');
INSERT INTO `registry` VALUES ('SOAP', 1, 'soap', 11, 1, 1, '2005-03-03 00:16:35', 0, 'Clinical', '');
INSERT INTO `registry` VALUES ('Vitals', 1, 'vitals', 12, 1, 1, '2005-03-03 00:16:34', 0, 'Clinical', '');
INSERT INTO `registry` VALUES ('Review Of Systems', 1, 'ros', 13, 1, 1, '2005-03-03 00:16:30', 0, 'Clinical', '');
INSERT INTO `registry` VALUES ('Fee Sheet', 1, 'fee_sheet', 14, 1, 1, '2007-07-28 00:00:00', 0, 'Administrative', '');
INSERT INTO `registry` VALUES ('Misc Billing Options HCFA', 1, 'misc_billing_options', 15, 1, 1, '2007-07-28 00:00:00', 0, 'Administrative', '');
INSERT INTO `registry` VALUES ('Procedure Order', 1, 'procedure_order', 16, 1, 1, '2010-02-25 00:00:00', 0, 'Administrative', '');

-- --------------------------------------------------------

--
-- Table structure for table `report_results`
--

DROP TABLE IF EXISTS `report_results`;
CREATE TABLE `report_results` (
  `report_id` bigint(20) NOT NULL,
  `field_id` varchar(31) NOT NULL default '',
  `field_value` text,
  PRIMARY KEY (`report_id`,`field_id`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `rule_action`
--

DROP TABLE IF EXISTS `rule_action`;
CREATE TABLE `rule_action` (
  `id` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to the id column in the clinical_rules table',
  `group_id` bigint(20) NOT NULL DEFAULT 1 COMMENT 'Contains group id to identify collection of targets in a rule',
  `category` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to the category item in the rule_action_item table',
  `item` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to the item column in the rule_action_item table',
  KEY  (`id`)
) ENGINE=MyISAM ;

--
-- Standard clinical rule actions
--
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_htn_bp_measure', 1, 'act_cat_measure', 'act_bp');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_tob_use_assess', 1, 'act_cat_assess', 'act_tobacco');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_tob_cess_inter', 1, 'act_cat_inter', 'act_tobacco');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_adult_wt_screen_fu', 1, 'act_cat_measure', 'act_wt');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_wt_assess_couns_child', 1, 'act_cat_measure', 'act_wt');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_wt_assess_couns_child', 2, 'act_cat_edu', 'act_wt');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_wt_assess_couns_child', 3, 'act_cat_edu', 'act_nutrition');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_wt_assess_couns_child', 4, 'act_cat_edu', 'act_exercise');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_wt_assess_couns_child', 5, 'act_cat_measure', 'act_bmi');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_influenza_ge_50', 1, 'act_cat_treat', 'act_influvacc');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_pneumovacc_ge_65', 1, 'act_cat_treat', 'act_pneumovacc');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_dm_hemo_a1c', 1, 'act_cat_measure', 'act_hemo_a1c');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_dm_urine_alb', 1, 'act_cat_measure', 'act_urine_alb');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_dm_eye', 1, 'act_cat_exam', 'act_eye');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_dm_foot', 1, 'act_cat_exam', 'act_foot');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_cs_mammo', 1, 'act_cat_measure', 'act_mammo');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_cs_pap', 1, 'act_cat_exam', 'act_pap');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_cs_colon', 1, 'act_cat_assess', 'act_colon_cancer_screen');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_cs_prostate', 1, 'act_cat_assess', 'act_prostate_cancer_screen');
INSERT INTO `rule_action` ( `id`, `group_id`, `category`, `item` ) VALUES ('rule_inr_monitor', 1, 'act_cat_measure', 'act_lab_inr');

-- --------------------------------------------------------

--
-- Table structure for table `rule_action_item`
--

DROP TABLE IF EXISTS `rule_action_item`;
CREATE TABLE `rule_action_item` (
  `category` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to list_options list rule_action_category',
  `item` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to list_options list rule_action',
  `clin_rem_link` varchar(255) NOT NULL DEFAULT '' COMMENT 'Custom html link in clinical reminder widget',
  `reminder_message` text  NOT NULL DEFAULT '' COMMENT 'Custom message in patient reminder',
  `custom_flag` tinyint(1) NOT NULL default 0 COMMENT '1 indexed to rule_patient_data, 0 indexed within main schema',
  PRIMARY KEY  (`category`,`item`)
) ENGINE=MyISAM ;

INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_measure', 'act_bp', '', '', 0);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_assess', 'act_tobacco', '', '', 0);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_inter', 'act_tobacco', '', '', 1);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_measure', 'act_wt', '', '', 0);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_edu', 'act_wt', '', '', 1);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_measure', 'act_bmi', '', '', 0);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_edu', 'act_nutrition', '', '', 1);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_edu', 'act_exercise', '', '', 1);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_treat', 'act_influvacc', '', '', 0);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_treat', 'act_pneumovacc', '', '', 0);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_measure', 'act_hemo_a1c', '', '', 1);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_measure', 'act_urine_alb', '', '', 1);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_exam', 'act_eye', '', '', 1);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_exam', 'act_foot', '', '', 1);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_measure', 'act_mammo', '', '', 1);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_exam', 'act_pap', '', '', 1);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_assess', 'act_colon_cancer_screen', '', '', 1);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_assess', 'act_prostate_cancer_screen', '', '', 1);
INSERT INTO `rule_action_item` ( `category`, `item`, `clin_rem_link`, `reminder_message`, `custom_flag` ) VALUES ('act_cat_measure', 'act_lab_inr', '', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `rule_filter`
--

DROP TABLE IF EXISTS `rule_filter`;
CREATE TABLE `rule_filter` (
  `id` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to the id column in the clinical_rules table',
  `include_flag` tinyint(1) NOT NULL default 0 COMMENT '0 is exclude and 1 is include',
  `required_flag` tinyint(1) NOT NULL default 0 COMMENT '0 is required and 1 is optional',
  `method` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to list_options list rule_filters',
  `method_detail` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to list_options lists rule__intervals',
  `value` varchar(255) NOT NULL DEFAULT '',
  KEY  (`id`)
) ENGINE=MyISAM ;

--
-- Standard clinical rule filters
--
-- Hypertension: Blood Pressure Measurement
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'CUSTOM::HTN');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::401.0');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::401.1');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::401.9');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::402.00');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::402.01');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::402.10');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::402.11');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::402.90');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::402.91');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::403.00');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::403.01');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::403.10');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::403.11');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::403.90');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::403.91');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::404.00');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::404.01');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::404.02');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::404.03');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::404.10');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::404.11');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::404.12');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::404.13');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::404.90');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::404.91');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::404.92');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::404.93');
-- Tobacco Use Assessment
-- no filters
-- Tobacco Cessation Intervention
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_tob_cess_inter', 1, 1, 'filt_database', '', 'LIFESTYLE::tobacco::current');
-- Adult Weight Screening and Follow-Up
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_adult_wt_screen_fu', 1, 1, 'filt_age_min', 'year', '18');
-- Weight Assessment and Counseling for Children and Adolescents
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_wt_assess_couns_child', 1, 1, 'filt_age_max', 'year', '18');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_wt_assess_couns_child', 1, 1, 'filt_age_min', 'year', '2');
-- Influenza Immunization for Patients >= 50 Years Old
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_influenza_ge_50', 1, 1, 'filt_age_min', 'year', '50');
-- Pneumonia Vaccination Status for Older Adults
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_pneumovacc_ge_65', 1, 1, 'filt_age_min', 'year', '65');
-- Diabetes: Hemoglobin A1C
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'CUSTOM::diabetes');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.0');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.00');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.01');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.02');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.03');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.10');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.11');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.12');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.13');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.20');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.21');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.22');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.23');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.30');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.31');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.32');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.33');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.4');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.40');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.41');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.42');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.43');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.50');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.51');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.52');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.53');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.60');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.61');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.62');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.63');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.7');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.70');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.71');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.72');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.73');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.80');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.81');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.82');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.83');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.9');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.90');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.91');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.92');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.93');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::357.2');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.0');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.01');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.02');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.03');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.04');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.05');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.06');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::366.41');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.0');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.00');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.01');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.02');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.03');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.04');
-- Diabetes: Urine Microalbumin
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'CUSTOM::diabetes');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.0');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.00');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.01');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.02');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.03');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.10');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.11');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.12');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.13');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.20');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.21');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.22');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.23');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.30');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.31');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.32');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.33');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.4');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.40');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.41');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.42');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.43');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.50');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.51');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.52');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.53');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.60');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.61');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.62');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.63');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.7');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.70');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.71');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.72');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.73');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.80');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.81');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.82');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.83');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.9');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.90');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.91');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.92');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.93');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::357.2');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.0');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.01');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.02');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.03');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.04');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.05');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.06');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::366.41');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.0');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.00');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.01');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.02');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.03');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.04');
-- Diabetes: Eye Exam
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'CUSTOM::diabetes');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.0');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.00');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.01');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.02');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.03');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.10');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.11');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.12');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.13');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.20');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.21');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.22');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.23');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.30');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.31');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.32');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.33');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.4');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.40');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.41');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.42');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.43');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.50');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.51');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.52');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.53');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.60');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.61');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.62');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.63');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.7');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.70');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.71');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.72');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.73');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.80');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.81');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.82');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.83');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.9');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.90');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.91');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.92');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.93');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::357.2');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.0');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.01');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.02');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.03');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.04');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.05');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.06');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::366.41');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.0');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.00');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.01');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.02');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.03');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.04');
-- Diabetes: Foot Exam
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'CUSTOM::diabetes');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.0');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.00');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.01');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.02');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.03');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.10');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.11');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.12');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.13');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.20');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.21');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.22');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.23');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.30');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.31');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.32');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.33');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.4');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.40');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.41');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.42');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.43');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.50');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.51');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.52');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.53');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.60');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.61');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.62');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.63');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.7');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.70');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.71');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.72');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.73');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.80');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.81');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.82');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.83');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.9');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.90');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.91');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.92');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::250.93');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::357.2');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.0');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.01');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.02');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.03');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.04');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.05');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::362.06');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::366.41');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.0');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.00');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.01');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.02');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.03');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 1, 0, 'filt_lists', 'medical_problem', 'ICD9::648.04');
-- Cancer Screening: Mammogram
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_mammo', 1, 1, 'filt_age_min', 'year', '40');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_mammo', 1, 1, 'filt_sex', '', 'Female');
-- Cancer Screening: Pap Smear
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_pap', 1, 1, 'filt_age_min', 'year', '18');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_pap', 1, 1, 'filt_sex', '', 'Female');
-- Cancer Screening: Colon Cancer Screening
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_colon', 1, 1, 'filt_age_min', 'year', '50');
-- Cancer Screening: Prostate Cancer Screening
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_prostate', 1, 1, 'filt_age_min', 'year', '50');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_prostate', 1, 1, 'filt_sex', '', 'Male');
--
-- Rule filters to specifically demonstrate passing of NIST criteria
--
-- Coumadin Management - INR Monitoring
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_inr_monitor', 1, 0, 'filt_lists', 'medication', 'coumadin');
INSERT INTO `rule_filter` ( `id`, `include_flag`, `required_flag`, `method`, `method_detail`, `value` ) VALUES ('rule_inr_monitor', 1, 0, 'filt_lists', 'medication', 'warfarin');

-- --------------------------------------------------------

--
-- Table structure for table `rule_patient_data`
--

DROP TABLE IF EXISTS `rule_patient_data`;
CREATE TABLE `rule_patient_data` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime DEFAULT NULL,
  `pid` bigint(20) NOT NULL,
  `category` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to the category item in the rule_action_item table',
  `item` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to the item column in the rule_action_item table',
  `complete` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to list_options list yesno',
  `result` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY  (`id`),
  KEY (`pid`),
  KEY (`category`,`item`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `rule_reminder`
--

DROP TABLE IF EXISTS `rule_reminder`;
CREATE TABLE `rule_reminder` (
  `id` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to the id column in the clinical_rules table',
  `method` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to list_options list rule_reminder_methods',
  `method_detail` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to list_options list rule_reminder_intervals',
  `value` varchar(255) NOT NULL DEFAULT '',
  KEY  (`id`)
) ENGINE=MyISAM ;

-- Hypertension: Blood Pressure Measurement
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_htn_bp_measure', 'patient_reminder_post', 'month', '1');
-- Tobacco Use Assessment
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_tob_use_assess', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_tob_use_assess', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_tob_use_assess', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_tob_use_assess', 'patient_reminder_post', 'month', '1');
-- Tobacco Cessation Intervention
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_tob_cess_inter', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_tob_cess_inter', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_tob_cess_inter', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_tob_cess_inter', 'patient_reminder_post', 'month', '1');
-- Adult Weight Screening and Follow-Up
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_adult_wt_screen_fu', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_adult_wt_screen_fu', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_adult_wt_screen_fu', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_adult_wt_screen_fu', 'patient_reminder_post', 'month', '1');
-- Weight Assessment and Counseling for Children and Adolescents
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_wt_assess_couns_child', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_wt_assess_couns_child', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_wt_assess_couns_child', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_wt_assess_couns_child', 'patient_reminder_post', 'month', '1');
-- Influenza Immunization for Patients >= 50 Years Old
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_influenza_ge_50', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_influenza_ge_50', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_influenza_ge_50', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_influenza_ge_50', 'patient_reminder_post', 'month', '1');
-- Pneumonia Vaccination Status for Older Adults
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_pneumovacc_ge_65', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_pneumovacc_ge_65', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_pneumovacc_ge_65', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_pneumovacc_ge_65', 'patient_reminder_post', 'month', '1');
-- Diabetes: Hemoglobin A1C
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_hemo_a1c', 'patient_reminder_post', 'month', '1');
-- Diabetes: Urine Microalbumin
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_urine_alb', 'patient_reminder_post', 'month', '1');
-- Diabetes: Eye Exam
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_eye', 'patient_reminder_post', 'month', '1');
-- Diabetes: Foot Exam
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_dm_foot', 'patient_reminder_post', 'month', '1');
-- Cancer Screening: Mammogram
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_mammo', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_mammo', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_mammo', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_mammo', 'patient_reminder_post', 'month', '1');
-- Cancer Screening: Pap Smear
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_pap', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_pap', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_pap', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_pap', 'patient_reminder_post', 'month', '1');
-- Cancer Screening: Colon Cancer Screening
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_colon', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_colon', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_colon', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_colon', 'patient_reminder_post', 'month', '1');
-- Cancer Screening: Prostate Cancer Screening
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_prostate', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_prostate', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_prostate', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_cs_prostate', 'patient_reminder_post', 'month', '1');
-- Coumadin Management - INR Monitoring
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_inr_monitor', 'clinical_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_inr_monitor', 'clinical_reminder_post', 'month', '1');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_inr_monitor', 'patient_reminder_pre', 'week', '2');
INSERT INTO `rule_reminder` ( `id`, `method`, `method_detail`, `value` ) VALUES ('rule_inr_monitor', 'patient_reminder_post', 'month', '1');

-- --------------------------------------------------------

--
-- Table structure for table `rule_target`
--

DROP TABLE IF EXISTS `rule_target`;
CREATE TABLE `rule_target` (
  `id` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to the id column in the clinical_rules table',
  `group_id` bigint(20) NOT NULL DEFAULT 1 COMMENT 'Contains group id to identify collection of targets in a rule',
  `include_flag` tinyint(1) NOT NULL default 0 COMMENT '0 is exclude and 1 is include',
  `required_flag` tinyint(1) NOT NULL default 0 COMMENT '0 is required and 1 is optional',
  `method` varchar(31) NOT NULL DEFAULT '' COMMENT 'Maps to list_options list rule_targets', 
  `value` varchar(255) NOT NULL DEFAULT '' COMMENT 'Data is dependent on the method',
  `interval` bigint(20) NOT NULL DEFAULT 0 COMMENT 'Only used in interval entries', 
  KEY  (`id`)
) ENGINE=MyISAM ;

--
-- Standard clinical rule targets
--
-- Hypertension: Blood Pressure Measurement
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_htn_bp_measure', 1, 1, 1, 'target_interval', 'year', 1);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_htn_bp_measure', 1, 1, 1, 'target_database', '::form_vitals::bps::::::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_htn_bp_measure', 1, 1, 1, 'target_database', '::form_vitals::bpd::::::ge::1', 0);
-- Tobacco Use Assessment
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_tob_use_assess', 1, 1, 1, 'target_database', 'LIFESTYLE::tobacco::', 0);
-- Tobacco Cessation Intervention
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_tob_cess_inter', 1, 1, 1, 'target_interval', 'year', 1);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_tob_cess_inter', 1, 1, 1, 'target_database', 'CUSTOM::act_cat_inter::act_tobacco::YES::ge::1', 0);
-- Adult Weight Screening and Follow-Up
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_adult_wt_screen_fu', 1, 1, 1, 'target_database', '::form_vitals::weight::::::ge::1', 0);
-- Weight Assessment and Counseling for Children and Adolescents
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_wt_assess_couns_child', 1, 1, 1, 'target_database', '::form_vitals::weight::::::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_wt_assess_couns_child', 1, 1, 1, 'target_interval', 'year', 3);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_wt_assess_couns_child', 2, 1, 1, 'target_database', 'CUSTOM::act_cat_edu::act_wt::YES::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_wt_assess_couns_child', 2, 1, 1, 'target_interval', 'year', 3);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_wt_assess_couns_child', 3, 1, 1, 'target_database', 'CUSTOM::act_cat_edu::act_nutrition::YES::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_wt_assess_couns_child', 3, 1, 1, 'target_interval', 'year', 3);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_wt_assess_couns_child', 4, 1, 1, 'target_database', 'CUSTOM::act_cat_edu::act_exercise::YES::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_wt_assess_couns_child', 4, 1, 1, 'target_interval', 'year', 3);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_wt_assess_couns_child', 5, 1, 1, 'target_database', '::form_vitals::BMI::::::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_wt_assess_couns_child', 5, 1, 1, 'target_interval', 'year', 3);
-- Influenza Immunization for Patients >= 50 Years Old
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_influenza_ge_50', 1, 1, 1, 'target_interval', 'flu_season', 1);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_influenza_ge_50', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::15::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_influenza_ge_50', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::16::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_influenza_ge_50', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::88::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_influenza_ge_50', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::111::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_influenza_ge_50', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::125::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_influenza_ge_50', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::126::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_influenza_ge_50', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::127::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_influenza_ge_50', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::128::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_influenza_ge_50', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::135::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_influenza_ge_50', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::140::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_influenza_ge_50', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::141::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_influenza_ge_50', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::144::ge::1', 0);
-- Pneumonia Vaccination Status for Older Adults
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_pneumovacc_ge_65', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::33::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_pneumovacc_ge_65', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::100::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_pneumovacc_ge_65', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::109::ge::1', 0);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_pneumovacc_ge_65', 1, 1, 0, 'target_database', '::immunizations::cvx_code::eq::133::ge::1', 0);
-- Diabetes: Hemoglobin A1C
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_dm_hemo_a1c', 1, 1, 1, 'target_interval', 'month', 3);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_dm_hemo_a1c', 1, 1, 1, 'target_database', 'CUSTOM::act_cat_measure::act_hemo_a1c::YES::ge::1', 0);
-- Diabetes: Urine Microalbumin
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_dm_urine_alb', 1, 1, 1, 'target_interval', 'year', 1);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_dm_urine_alb', 1, 1, 1, 'target_database', 'CUSTOM::act_cat_measure::act_urine_alb::YES::ge::1', 0);
-- Diabetes: Eye Exam
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_dm_eye', 1, 1, 1, 'target_interval', 'year', 1);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_dm_eye', 1, 1, 1, 'target_database', 'CUSTOM::act_cat_exam::act_eye::YES::ge::1', 0);
-- Diabetes: Foot Exam
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_dm_foot', 1, 1, 1, 'target_interval', 'year', 1);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_dm_foot', 1, 1, 1, 'target_database', 'CUSTOM::act_cat_exam::act_foot::YES::ge::1', 0);
-- Cancer Screening: Mammogram
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_cs_mammo', 1, 1, 1, 'target_interval', 'year', 1);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_cs_mammo', 1, 1, 1, 'target_database', 'CUSTOM::act_cat_measure::act_mammo::YES::ge::1', 0);
-- Cancer Screening: Pap Smear
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_cs_pap', 1, 1, 1, 'target_interval', 'year', 1);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_cs_pap', 1, 1, 1, 'target_database', 'CUSTOM::act_cat_exam::act_pap::YES::ge::1', 0);
-- Cancer Screening: Colon Cancer Screening
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_cs_colon', 1, 1, 1, 'target_database', 'CUSTOM::act_cat_assess::act_colon_cancer_screen::YES::ge::1', 0);
-- Cancer Screening: Prostate Cancer Screening
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_cs_prostate', 1, 1, 1, 'target_database', 'CUSTOM::act_cat_assess::act_prostate_cancer_screen::YES::ge::1', 0);
--
-- Rule targets to specifically demonstrate passing of NIST criteria
--
-- Coumadin Management - INR Monitoring
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_inr_monitor', 1, 1, 1, 'target_interval', 'week', 3);
INSERT INTO `rule_target` ( `id`, `group_id`, `include_flag`, `required_flag`, `method`, `value`, `interval` ) VALUES ('rule_inr_monitor', 1, 1, 1, 'target_proc', 'INR::CPT4:85610::::::ge::1', 0);

-- --------------------------------------------------------

-- 
-- Table structure for table `sequences`
-- 

DROP TABLE IF EXISTS `sequences`;
CREATE TABLE `sequences` (
  `id` int(11) unsigned NOT NULL default '0'
) ENGINE=MyISAM;

-- 
-- Dumping data for table `sequences`
-- 

INSERT INTO `sequences` VALUES (1);

-- --------------------------------------------------------

--
-- Table structure for table `supported_external_dataloads`
--

DROP TABLE IF EXISTS `supported_external_dataloads`;
CREATE TABLE `supported_external_dataloads` (
  `load_id` SERIAL,
  `load_type` varchar(24) NOT NULL DEFAULT '',
  `load_source` varchar(24) NOT NULL DEFAULT 'CMS',
  `load_release_date` date NOT NULL,
  `load_filename` varchar(256) NOT NULL DEFAULT '',
  `load_checksum` varchar(32) NOT NULL DEFAULT ''
) ENGINE=MyISAM;

--
-- Dumping data for table `supported_external_dataloads`
--

INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD9', 'CMS', '2011-10-01', 'cmsv29_master_descriptions.zip', 'c360c2b5a29974d6c58617c7378dd7c4');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD9', 'CMS', '2012-10-01', 'cmsv30_master_descriptions.zip', 'eb26446536435f5f5e677090a7976b15');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD9', 'CMS', '2013-10-01', 'cmsv31-master-descriptions.zip', 'fe0d7f9a5338f5ff187683b4737ad2b7');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2011-10-01', '2012_PCS_long_and_abbreviated_titles.zip', '201a732b649d8c7fba807cc4c083a71a');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2011-10-01', 'DiagnosisGEMs_2012.zip', '6758c4a3384c47161ce24f13a2464b53');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2011-10-01', 'ICD10OrderFiles_2012.zip', 'a76601df7a9f5270d8229828a833f6a1');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2011-10-01', 'ProcedureGEMs_2012.zip', 'f37416d8fab6cd2700b634ca5025295d');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2011-10-01', 'ReimbursementMapping_2012.zip', '8b438d1fd1f34a9bb0e423c15e89744b');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2012-10-01', '2013_PCS_long_and_abbreviated_titles.zip', '04458ed0631c2c122624ee0a4ca1c475');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2012-10-01', '2013-DiagnosisGEMs.zip', '773aac2a675d6aefd1d7dd149883be51');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2012-10-01', 'ICD10CMOrderFiles_2013.zip', '1c175a858f833485ef8f9d3e66b4d8bd');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2012-10-01', 'ProcedureGEMs_2013.zip', '92aa7640e5ce29b9629728f7d4fc81db');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2012-10-01', '2013-ReimbursementMapping_dx.zip', '0d5d36e3f4519bbba08a9508576787fb');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2012-10-01', 'ReimbursementMapping_pr_2013.zip', '4c3920fedbcd9f6af54a1dc9069a11ca');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2013-10-01', '2014-Reimbursement-Mappings-PR.zip', 'f306a0e8c9edb34d28fd6ce8af82b646');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2013-10-01', '2014-Reimbursement-Mappings-DX.zip', '614b3957304208e3ef7d3ba8b3618888');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2013-10-01', 'ProcedureGEMs-2014.zip', 'be46de29f4f40f97315d04821273acf9');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2013-10-01', '2014-ICD10-Code-Descriptions.zip', '5458b95f6f37228b5cdfa03aefc6c8bb');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2013-10-01', 'DiagnosisGEMs-2014.zip', '3ed7b7c5a11c766102b12d97d777a11b');
INSERT INTO `supported_external_dataloads` (`load_type`, `load_source`, `load_release_date`, `load_filename`, `load_checksum`) VALUES
('ICD10', 'CMS', '2013-10-01', '2014-PCS-long-and-abbreviated-titles.zip', '2d03514a0c66d92cf022a0bc28c83d38');

-- --------------------------------------------------------

-- 
-- Table structure for table `transactions`
-- 

DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions` (
  `id`                      bigint(20)   NOT NULL auto_increment,
  `date`                    datetime     default NULL,
  `title`                   varchar(255) NOT NULL DEFAULT '',
  `pid`                     bigint(20)   default NULL,
  `user`                    varchar(255) NOT NULL DEFAULT '',
  `groupname`               varchar(255) NOT NULL DEFAULT '',
  `authorized`              tinyint(4)   default NULL,
  PRIMARY KEY  (`id`),
  KEY `pid` (`pid`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `users`
-- 

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL auto_increment,
  `username` varchar(255) default NULL,
  `password` longtext,
  `authorized` tinyint(4) default NULL,
  `info` longtext,
  `source` tinyint(4) default NULL,
  `fname` varchar(255) default NULL,
  `mname` varchar(255) default NULL,
  `lname` varchar(255) default NULL,
  `federaltaxid` varchar(255) default NULL,
  `federaldrugid` varchar(255) default NULL,
  `upin` varchar(255) default NULL,
  `facility` varchar(255) default NULL,
  `facility_id` int(11) NOT NULL default '0',
  `see_auth` int(11) NOT NULL default '1',
  `active` tinyint(1) NOT NULL default '1',
  `npi` varchar(15) default NULL,
  `title` varchar(30) default NULL,
  `specialty` varchar(255) default NULL,
  `billname` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `email_direct` varchar(255) NOT NULL default '',
  `url` varchar(255) default NULL,
  `assistant` varchar(255) default NULL,
  `organization` varchar(255) default NULL,
  `valedictory` varchar(255) default NULL,
  `street` varchar(60) default NULL,
  `streetb` varchar(60) default NULL,
  `city` varchar(30) default NULL,
  `state` varchar(30) default NULL,
  `zip` varchar(20) default NULL,
  `street2` varchar(60) default NULL,
  `streetb2` varchar(60) default NULL,
  `city2` varchar(30) default NULL,
  `state2` varchar(30) default NULL,
  `zip2` varchar(20) default NULL,
  `phone` varchar(30) default NULL,
  `fax` varchar(30) default NULL,
  `phonew1` varchar(30) default NULL,
  `phonew2` varchar(30) default NULL,
  `phonecell` varchar(30) default NULL,
  `notes` text,
  `cal_ui` tinyint(4) NOT NULL default '1',
  `taxonomy` varchar(30) NOT NULL DEFAULT '207Q00000X',
  `ssi_relayhealth` varchar(64) NULL,
  `calendar` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 = appears in calendar',
  `abook_type` varchar(31) NOT NULL DEFAULT '',
  `pwd_expiration_date` date default NULL,
  `pwd_history1` longtext default NULL,
  `pwd_history2` longtext default NULL,
  `default_warehouse` varchar(31) NOT NULL DEFAULT '',
  `irnpool` varchar(31) NOT NULL DEFAULT '',
  `state_license_number` VARCHAR(25) DEFAULT NULL,
  `newcrop_user_role` VARCHAR(30) DEFAULT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `users`
--
-- NOTE THIS IS DONE AFTER INSTALLATION WHERE THE sql/official_additional_users.sql script is called durig setup
--  (so these inserts can be found in the sql/official_additional_users.sql script)


-- --------------------------------------------------------

--
-- Table structure for table `user_secure`
--
CREATE TABLE `users_secure` (
  `id` bigint(20) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255),
  `salt` varchar(255),
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `password_history1` varchar(255),
  `salt_history1` varchar(255),
  `password_history2` varchar(255),
  `salt_history2` varchar(255),
  `last_challenge_response` datetime DEFAULT NULL,
  `num_failed_logins` int(11) NOT NULL DEFAULT 0 COMMENT 'Number of consecutive failed login attempts',
  `login_work_area` varchar(32768) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `USERNAME_ID` (`id`,`username`)
) ENGINE=InnoDb;

-- --------------------------------------------------------

--
-- Table structure for table `user_settings`
--

CREATE TABLE `user_settings` (
  `setting_user`  bigint(20)   NOT NULL DEFAULT 0,
  `setting_label` varchar(100)  NOT NULL,
  `setting_value` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`setting_user`, `setting_label`)
) ENGINE=MyISAM;

--
-- Dumping data for table `user_settings`
--

INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'allergy_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'appointments_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'billing_ps_expand', '0');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'clinical_reminders_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'demographics_ps_expand', '0');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'dental_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'directives_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'disclosures_ps_expand', '0');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'immunizations_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'insurance_ps_expand', '0');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'medical_problem_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'medication_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'patient_reminders_ps_expand', '0');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'pnotes_ps_expand', '0');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'prescriptions_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'surgery_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'vitals_ps_expand', '1');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (0, 'gacl_protect', '0');
INSERT INTO user_settings ( setting_user, setting_label, setting_value ) VALUES (1, 'gacl_protect', '1');

-- --------------------------------------------------------

-- 
-- Table structure for table `x12_partners`
-- 

DROP TABLE IF EXISTS `x12_partners`;
CREATE TABLE `x12_partners` (
  `id` int(11) NOT NULL default '0',
  `name` varchar(255) default NULL,
  `id_number` varchar(255) default NULL,
  `x12_sender_id` varchar(255) default NULL,
  `x12_receiver_id` varchar(255) default NULL,
  `x12_version` varchar(255) default NULL,
  `processing_format` enum('standard','medi-cal','cms','proxymed') default NULL,
  `x12_isa01` VARCHAR( 2 ) NOT NULL DEFAULT '00' COMMENT 'User logon Required Indicator',
  `x12_isa02` VARCHAR( 10 ) NOT NULL DEFAULT '          ' COMMENT 'User Logon',
  `x12_isa03` VARCHAR( 2 ) NOT NULL DEFAULT '00' COMMENT 'User password required Indicator',
  `x12_isa04` VARCHAR( 10 ) NOT NULL DEFAULT '          ' COMMENT 'User Password',
  `x12_isa05` char(2)     NOT NULL DEFAULT 'ZZ',
  `x12_isa07` char(2)     NOT NULL DEFAULT 'ZZ',
  `x12_isa14` char(1)     NOT NULL DEFAULT '0',
  `x12_isa15` char(1)     NOT NULL DEFAULT 'P',
  `x12_gs02`  varchar(15) NOT NULL DEFAULT '',
  `x12_per06` varchar(80) NOT NULL DEFAULT '',
  `x12_gs03`  varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM;

-- -----------------------------------------------------------------------------------
-- Table structure for table `automatic_notification`
-- 

DROP TABLE IF EXISTS `automatic_notification`;
CREATE TABLE `automatic_notification` (
  `notification_id` int(5) NOT NULL auto_increment,
  `sms_gateway_type` varchar(255) NOT NULL,
  `next_app_date` date NOT NULL,
  `next_app_time` varchar(10) NOT NULL,
  `provider_name` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `email_sender` varchar(100) NOT NULL,
  `email_subject` varchar(100) NOT NULL,
  `type` enum('SMS','Email') NOT NULL default 'SMS',
  `notification_sent_date` datetime NOT NULL,
  PRIMARY KEY  (`notification_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 ;

-- 
-- Dumping data for table `automatic_notification`
-- 

INSERT INTO `automatic_notification` (`notification_id`, `sms_gateway_type`, `next_app_date`, `next_app_time`, `provider_name`, `message`, `email_sender`, `email_subject`, `type`, `notification_sent_date`) VALUES (1, 'CLICKATELL', NULL, ':', 'EMR GROUP 1 .. SMS', 'Welcome to EMR GROUP 1.. SMS', '', '', 'SMS', NULL),
(2, '', '2007-10-02', '05:50', 'EMR GROUP', 'Welcome to EMR GROUP . Email', 'EMR Group', 'Welcome to EMR GROUP', 'Email', '2007-09-30 00:00:00');

-- --------------------------------------------------------

-- 
-- Table structure for table `notification_log`
-- 

DROP TABLE IF EXISTS `notification_log`;
CREATE TABLE `notification_log` (
  `iLogId` int(11) NOT NULL auto_increment,
  `pid` int(7) NOT NULL,
  `pc_eid` int(11) unsigned NULL,
  `sms_gateway_type` varchar(50) NOT NULL,
  `smsgateway_info` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `email_sender` varchar(255) NOT NULL,
  `email_subject` varchar(255) NOT NULL,
  `type` enum('SMS','Email') NOT NULL,
  `patient_info` text NOT NULL,
  `pc_eventDate` date NOT NULL,
  `pc_endDate` date NOT NULL,
  `pc_startTime` time NOT NULL,
  `pc_endTime` time NOT NULL,
  `dSentDateTime` datetime NOT NULL,
  PRIMARY KEY  (`iLogId`)
) ENGINE=InnoDB AUTO_INCREMENT=5 ;

-- --------------------------------------------------------

-- 
-- Table structure for table `notification_settings`
-- 

DROP TABLE IF EXISTS `notification_settings`;
CREATE TABLE `notification_settings` (
  `SettingsId` int(3) NOT NULL auto_increment,
  `Send_SMS_Before_Hours` int(3) NOT NULL,
  `Send_Email_Before_Hours` int(3) NOT NULL,
  `SMS_gateway_username` varchar(100) NOT NULL,
  `SMS_gateway_password` varchar(100) NOT NULL,
  `SMS_gateway_apikey` varchar(100) NOT NULL,
  `type` varchar(50) NOT NULL,
  PRIMARY KEY  (`SettingsId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 ;

-- 
-- Dumping data for table `notification_settings`
-- 

INSERT INTO `notification_settings` (`SettingsId`, `Send_SMS_Before_Hours`, `Send_Email_Before_Hours`, `SMS_gateway_username`, `SMS_gateway_password`, `SMS_gateway_apikey`, `type`) VALUES (1, 150, 150, 'sms username', 'sms password', 'sms api key', 'SMS/Email Settings');

-- -------------------------------------------------------------------

CREATE TABLE chart_tracker (
  ct_pid            int(11)       NOT NULL,
  ct_when           datetime      NOT NULL,
  ct_userid         bigint(20)    NOT NULL DEFAULT 0,
  ct_location       varchar(31)   NOT NULL DEFAULT '',
  PRIMARY KEY (ct_pid, ct_when)
) ENGINE=MyISAM;

CREATE TABLE ar_session (
  session_id     int unsigned  NOT NULL AUTO_INCREMENT,
  payer_id       int(11)       NOT NULL            COMMENT '0=pt else references insurance_companies.id',
  user_id        int(11)       NOT NULL            COMMENT 'references users.id for session owner',
  closed         tinyint(1)    NOT NULL DEFAULT 0  COMMENT '0=no, 1=yes',
  reference      varchar(255)  NOT NULL DEFAULT '' COMMENT 'check or EOB number',
  check_date     date          DEFAULT NULL,
  deposit_date   date          DEFAULT NULL,
  pay_total      decimal(12,2) NOT NULL DEFAULT 0,
  created_time timestamp NOT NULL default CURRENT_TIMESTAMP,
  modified_time datetime NOT NULL,
  global_amount decimal( 12, 2 ) NOT NULL ,
  payment_type varchar( 50 ) NOT NULL ,
  description text NOT NULL ,
  adjustment_code varchar( 50 ) NOT NULL ,
  post_to_date date NOT NULL ,
  patient_id int( 11 ) NOT NULL ,
  payment_method varchar( 25 ) NOT NULL,
  PRIMARY KEY (session_id),
  KEY user_closed (user_id, closed),
  KEY deposit_date (deposit_date)
) ENGINE=MyISAM;

CREATE TABLE ar_activity (
  pid            int(11)       NOT NULL,
  encounter      int(11)       NOT NULL,
  sequence_no    int unsigned  NOT NULL AUTO_INCREMENT,
  `code_type`    varchar(12)   NOT NULL DEFAULT '',
  code           varchar(20)   NOT NULL            COMMENT 'empty means claim level',
  modifier       varchar(12)   NOT NULL DEFAULT '',
  payer_type     int           NOT NULL            COMMENT '0=pt, 1=ins1, 2=ins2, etc',
  post_time      datetime      NOT NULL,
  post_user      int(11)       NOT NULL            COMMENT 'references users.id',
  session_id     int unsigned  NOT NULL            COMMENT 'references ar_session.session_id',
  memo           varchar(255)  NOT NULL DEFAULT '' COMMENT 'adjustment reasons go here',
  pay_amount     decimal(12,2) NOT NULL DEFAULT 0  COMMENT 'either pay or adj will always be 0',
  adj_amount     decimal(12,2) NOT NULL DEFAULT 0,
  modified_time datetime NOT NULL,
  follow_up char(1) NOT NULL,
  follow_up_note text NOT NULL,
  account_code varchar(15) NOT NULL,
  reason_code varchar(255) DEFAULT NULL COMMENT 'Use as needed to show the primary payer adjustment reason code',
  deleted        datetime DEFAULT NULL COMMENT 'NULL if active, otherwise when voided',
  post_date      date DEFAULT NULL COMMENT 'Posting date if specified at payment time',
  PRIMARY KEY (pid, encounter, sequence_no),
  KEY session_id (session_id)
) ENGINE=MyISAM;

CREATE TABLE `users_facility` (
  `tablename` varchar(64) NOT NULL,
  `table_id` int(11) NOT NULL,
  `facility_id` int(11) NOT NULL,
  `warehouse_id` varchar(31) NOT NULL DEFAULT '',
  PRIMARY KEY (`tablename`,`table_id`,`facility_id`,`warehouse_id`)
) ENGINE=InnoDB COMMENT='joins users or patient_data to facility table';

CREATE TABLE `lbf_data` (
  `form_id`     int(11)      NOT NULL AUTO_INCREMENT COMMENT 'references forms.form_id',
  `field_id`    varchar(31)  NOT NULL COMMENT 'references layout_options.field_id',
  `field_value` LONGTEXT NOT NULL,
  PRIMARY KEY (`form_id`,`field_id`)
) ENGINE=MyISAM COMMENT='contains all data from layout-based forms';

CREATE TABLE `lbt_data` (
  `form_id`     bigint(20)   NOT NULL COMMENT 'references transactions.id',
  `field_id`    varchar(31)  NOT NULL COMMENT 'references layout_options.field_id',
  `field_value` TEXT         NOT NULL,
  PRIMARY KEY (`form_id`,`field_id`)
) ENGINE=MyISAM COMMENT='contains all data from layout-based transactions';

CREATE TABLE gprelations (
  type1 int(2)     NOT NULL,
  id1   bigint(20) NOT NULL,
  type2 int(2)     NOT NULL,
  id2   bigint(20) NOT NULL,
  PRIMARY KEY (type1,id1,type2,id2),
  KEY key2  (type2,id2)
) ENGINE=MyISAM COMMENT='general purpose relations';

CREATE TABLE `procedure_providers` (
  `ppid`         bigint(20)   NOT NULL auto_increment,
  `name`         varchar(255) NOT NULL DEFAULT '',
  `npi`          varchar(15)  NOT NULL DEFAULT '',
  `send_app_id`  varchar(255) NOT NULL DEFAULT ''  COMMENT 'Sending application ID (MSH-3.1)',
  `send_fac_id`  varchar(255) NOT NULL DEFAULT ''  COMMENT 'Sending facility ID (MSH-4.1)',
  `recv_app_id`  varchar(255) NOT NULL DEFAULT ''  COMMENT 'Receiving application ID (MSH-5.1)',
  `recv_fac_id`  varchar(255) NOT NULL DEFAULT ''  COMMENT 'Receiving facility ID (MSH-6.1)',
  `DorP`         char(1)      NOT NULL DEFAULT 'D' COMMENT 'Debugging or Production (MSH-11)',
  `protocol`     varchar(15)  NOT NULL DEFAULT 'DL',
  `remote_host`  varchar(255) NOT NULL DEFAULT '',
  `login`        varchar(255) NOT NULL DEFAULT '',
  `password`     varchar(255) NOT NULL DEFAULT '',
  `orders_path`  varchar(255) NOT NULL DEFAULT '',
  `results_path` varchar(255) NOT NULL DEFAULT '',
  `notes`        text         NOT NULL DEFAULT '',
  PRIMARY KEY (`ppid`)
) ENGINE=MyISAM;

CREATE TABLE `procedure_type` (
  `procedure_type_id`   bigint(20)   NOT NULL AUTO_INCREMENT,
  `parent`              bigint(20)   NOT NULL DEFAULT 0  COMMENT 'references procedure_type.procedure_type_id',
  `name`                varchar(63)  NOT NULL DEFAULT '' COMMENT 'name for this category, procedure or result type',
  `lab_id`              bigint(20)   NOT NULL DEFAULT 0  COMMENT 'references procedure_providers.ppid, 0 means default to parent',
  `procedure_code`      varchar(31)  NOT NULL DEFAULT '' COMMENT 'code identifying this procedure',
  `procedure_type`      varchar(31)  NOT NULL DEFAULT '' COMMENT 'see list proc_type',
  `body_site`           varchar(31)  NOT NULL DEFAULT '' COMMENT 'where to do injection, e.g. arm, buttok',
  `specimen`            varchar(31)  NOT NULL DEFAULT '' COMMENT 'blood, urine, saliva, etc.',
  `route_admin`         varchar(31)  NOT NULL DEFAULT '' COMMENT 'oral, injection',
  `laterality`          varchar(31)  NOT NULL DEFAULT '' COMMENT 'left, right, ...',
  `description`         varchar(255) NOT NULL DEFAULT '' COMMENT 'descriptive text for procedure_code',
  `standard_code`       varchar(255) NOT NULL DEFAULT '' COMMENT 'industry standard code type and code (e.g. CPT4:12345)',
  `related_code`        varchar(255) NOT NULL DEFAULT '' COMMENT 'suggested code(s) for followup services if result is abnormal',
  `units`               varchar(31)  NOT NULL DEFAULT '' COMMENT 'default for procedure_result.units',
  `range`               varchar(255) NOT NULL DEFAULT '' COMMENT 'default for procedure_result.range',
  `seq`                 int(11)      NOT NULL default 0  COMMENT 'sequence number for ordering',
  `activity`            tinyint(1)   NOT NULL default 1  COMMENT '1=active, 0=inactive',
  `notes`               varchar(255) NOT NULL default '' COMMENT 'additional notes to enhance description',
  PRIMARY KEY (`procedure_type_id`),
  KEY parent (parent)
) ENGINE=MyISAM;

CREATE TABLE `procedure_questions` (
  `lab_id`              bigint(20)   NOT NULL DEFAULT 0   COMMENT 'references procedure_providers.ppid to identify the lab',
  `procedure_code`      varchar(31)  NOT NULL DEFAULT ''  COMMENT 'references procedure_type.procedure_code to identify this order type',
  `question_code`       varchar(31)  NOT NULL DEFAULT ''  COMMENT 'code identifying this question',
  `seq`                 int(11)      NOT NULL default 0   COMMENT 'sequence number for ordering',
  `question_text`       varchar(255) NOT NULL DEFAULT ''  COMMENT 'descriptive text for question_code',
  `required`            tinyint(1)   NOT NULL DEFAULT 0   COMMENT '1 = required, 0 = not',
  `maxsize`             int          NOT NULL DEFAULT 0   COMMENT 'maximum length if text input field',
  `fldtype`             char(1)      NOT NULL DEFAULT 'T' COMMENT 'Text, Number, Select, Multiselect, Date, Gestational-age',
  `options`             text         NOT NULL DEFAULT ''  COMMENT 'choices for fldtype S and T',
  `tips`                varchar(255) NOT NULL DEFAULT ''  COMMENT 'Additional instructions for answering the question',
  `activity`            tinyint(1)   NOT NULL DEFAULT 1   COMMENT '1 = active, 0 = inactive',
  PRIMARY KEY (`lab_id`, `procedure_code`, `question_code`)
) ENGINE=MyISAM;

CREATE TABLE `procedure_order` (
  `procedure_order_id`     bigint(20)   NOT NULL AUTO_INCREMENT,
  `provider_id`            bigint(20)   NOT NULL DEFAULT 0  COMMENT 'references users.id, the ordering provider',
  `patient_id`             bigint(20)   NOT NULL            COMMENT 'references patient_data.pid',
  `encounter_id`           bigint(20)   NOT NULL DEFAULT 0  COMMENT 'references form_encounter.encounter',
  `date_collected`         datetime     DEFAULT NULL        COMMENT 'time specimen collected',
  `date_ordered`           date         DEFAULT NULL,
  `order_priority`         varchar(31)  NOT NULL DEFAULT '',
  `order_status`           varchar(31)  NOT NULL DEFAULT '' COMMENT 'pending,routed,complete,canceled',
  `patient_instructions`   text         NOT NULL DEFAULT '',
  `activity`               tinyint(1)   NOT NULL DEFAULT 1  COMMENT '0 if deleted',
  `control_id`             bigint(20)   NOT NULL            COMMENT 'This is the CONTROL ID that is sent back from lab',
  `lab_id`                 bigint(20)   NOT NULL DEFAULT 0  COMMENT 'references procedure_providers.ppid',
  `specimen_type`          varchar(31)  NOT NULL DEFAULT '' COMMENT 'from the Specimen_Type list',
  `specimen_location`      varchar(31)  NOT NULL DEFAULT '' COMMENT 'from the Specimen_Location list',
  `specimen_volume`        varchar(30)  NOT NULL DEFAULT '' COMMENT 'from a text input field',
  `date_transmitted`       datetime     DEFAULT NULL        COMMENT 'time of order transmission, null if unsent',
  `clinical_hx`            varchar(255) NOT NULL DEFAULT '' COMMENT 'clinical history text that may be relevant to the order',
  PRIMARY KEY (`procedure_order_id`),
  KEY datepid (date_ordered, patient_id),
  KEY `patient_id` (`patient_id`)
) ENGINE=MyISAM;

CREATE TABLE `procedure_order_code` (
  `procedure_order_id`  bigint(20)  NOT NULL                COMMENT 'references procedure_order.procedure_order_id',
  `procedure_order_seq` int(11)     NOT NULL AUTO_INCREMENT COMMENT 'supports multiple tests per order',
  `procedure_code`      varchar(31) NOT NULL DEFAULT ''     COMMENT 'like procedure_type.procedure_code',
  `procedure_name`      varchar(255) NOT NULL DEFAULT ''    COMMENT 'descriptive name of the procedure code',
  `procedure_source`    char(1)     NOT NULL DEFAULT '1'    COMMENT '1=original order, 2=added after order sent',
  `diagnoses`           text        NOT NULL DEFAULT ''     COMMENT 'diagnoses and maybe other coding (e.g. ICD9:111.11)',
  `do_not_send`         tinyint(1)  NOT NULL DEFAULT '0'    COMMENT '0 = normal, 1 = do not transmit to lab',
  PRIMARY KEY (`procedure_order_id`, `procedure_order_seq`)
) ENGINE=MyISAM;

CREATE TABLE `procedure_answers` (
  `procedure_order_id`  bigint(20)   NOT NULL DEFAULT 0  COMMENT 'references procedure_order.procedure_order_id',
  `procedure_order_seq` int(11)      NOT NULL DEFAULT 0  COMMENT 'references procedure_order_code.procedure_order_seq',
  `question_code`       varchar(31)  NOT NULL DEFAULT '' COMMENT 'references procedure_questions.question_code',
  `answer_seq`          int(11)      NOT NULL AUTO_INCREMENT COMMENT 'supports multiple-choice questions',
  `answer`              varchar(255) NOT NULL DEFAULT '' COMMENT 'answer data',
  PRIMARY KEY (`procedure_order_id`, `procedure_order_seq`, `question_code`, `answer_seq`)
) ENGINE=MyISAM;

CREATE TABLE `procedure_report` (
  `procedure_report_id` bigint(20)     NOT NULL AUTO_INCREMENT,
  `procedure_order_id`  bigint(20)     DEFAULT NULL   COMMENT 'references procedure_order.procedure_order_id',
  `procedure_order_seq` int(11)        NOT NULL DEFAULT 1  COMMENT 'references procedure_order_code.procedure_order_seq',
  `date_collected`      datetime       DEFAULT NULL,
  `date_report`         date           DEFAULT NULL,
  `source`              bigint(20)     NOT NULL DEFAULT 0  COMMENT 'references users.id, who entered this data',
  `specimen_num`        varchar(63)    NOT NULL DEFAULT '',
  `report_status`       varchar(31)    NOT NULL DEFAULT '' COMMENT 'received,complete,error',
  `review_status`       varchar(31)    NOT NULL DEFAULT 'received' COMMENT 'pending review status: received,reviewed',  
  `report_notes`        text           NOT NULL DEFAULT '' COMMENT 'notes from the lab',
  PRIMARY KEY (`procedure_report_id`),
  KEY procedure_order_id (procedure_order_id)
) ENGINE=MyISAM; 

CREATE TABLE `procedure_result` (
  `procedure_result_id` bigint(20)   NOT NULL AUTO_INCREMENT,
  `procedure_report_id` bigint(20)   NOT NULL            COMMENT 'references procedure_report.procedure_report_id',
  `result_data_type`    char(1)      NOT NULL DEFAULT 'S' COMMENT 'N=Numeric, S=String, F=Formatted, E=External, L=Long text as first line of comments',
  `result_code`         varchar(31)  NOT NULL DEFAULT '' COMMENT 'LOINC code, might match a procedure_type.procedure_code',
  `result_text`         varchar(255) NOT NULL DEFAULT '' COMMENT 'Description of result_code',
  `date`                datetime     DEFAULT NULL        COMMENT 'lab-provided date specific to this result',
  `facility`            varchar(255) NOT NULL DEFAULT '' COMMENT 'lab-provided testing facility ID',
  `units`               varchar(31)  NOT NULL DEFAULT '',
  `result`              varchar(255) NOT NULL DEFAULT '',
  `range`               varchar(255) NOT NULL DEFAULT '',
  `abnormal`            varchar(31)  NOT NULL DEFAULT '' COMMENT 'no,yes,high,low',
  `comments`            text         NOT NULL DEFAULT '' COMMENT 'comments from the lab',
  `document_id`         bigint(20)   NOT NULL DEFAULT 0  COMMENT 'references documents.id if this result is a document',
  `result_status`       varchar(31)  NOT NULL DEFAULT '' COMMENT 'preliminary, cannot be done, final, corrected, incompete...etc.',
  PRIMARY KEY (`procedure_result_id`),
  KEY procedure_report_id (procedure_report_id)
) ENGINE=MyISAM; 

CREATE TABLE `globals` (
  `gl_name`             varchar(63)    NOT NULL,
  `gl_index`            int(11)        NOT NULL DEFAULT 0,
  `gl_value`            varchar(255)   NOT NULL DEFAULT '',
  PRIMARY KEY (`gl_name`, `gl_index`)
) ENGINE=MyISAM; 

CREATE TABLE code_types (
  ct_key  varchar(15) NOT NULL           COMMENT 'short alphanumeric name',
  ct_id   int(11)     UNIQUE NOT NULL    COMMENT 'numeric identifier',
  ct_seq  int(11)     NOT NULL DEFAULT 0 COMMENT 'sort order',
  ct_mod  int(11)     NOT NULL DEFAULT 0 COMMENT 'length of modifier field',
  ct_just varchar(15) NOT NULL DEFAULT ''COMMENT 'ct_key of justify type, if any',
  ct_mask varchar(9)  NOT NULL DEFAULT ''COMMENT 'formatting mask for code values',
  ct_fee  tinyint(1)  NOT NULL default 0 COMMENT '1 if fees are used',
  ct_rel  tinyint(1)  NOT NULL default 0 COMMENT '1 if can relate to other code types',
  ct_nofs tinyint(1)  NOT NULL default 0 COMMENT '1 if to be hidden in the fee sheet',
  ct_diag tinyint(1)  NOT NULL default 0 COMMENT '1 if this is a diagnosis type',
  ct_active tinyint(1) NOT NULL default 1 COMMENT '1 if this is active',
  ct_label varchar(31) NOT NULL default '' COMMENT 'label of this code type',
  ct_external tinyint(1) NOT NULL default 0 COMMENT '0 if stored codes in codes tables, 1 or greater if codes stored in external tables',
  ct_claim tinyint(1) NOT NULL default 0 COMMENT '1 if this is used in claims',
  ct_proc tinyint(1) NOT NULL default 0 COMMENT '1 if this is a procedure type',
  ct_term tinyint(1) NOT NULL default 0 COMMENT '1 if this is a clinical term',
  ct_problem tinyint(1) NOT NULL default 0 COMMENT '1 if this code type is used as a medical problem',
  PRIMARY KEY (ct_key)
) ENGINE=MyISAM;

INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external, ct_claim, ct_proc, ct_term, ct_problem ) VALUES ('ICD9' , 2, 1, 0, ''    , 0, 0, 0, 1, 1, 'ICD9 Diagnosis', 4, 1, 0, 0, 1);
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external, ct_claim, ct_proc, ct_term, ct_problem ) VALUES ('CPT4' , 1, 2, 12, 'ICD9', 1, 0, 0, 0, 1, 'CPT4 Procedure/Service', 0, 1, 1, 0, 0);
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external, ct_claim, ct_proc, ct_term, ct_problem ) VALUES ('HCPCS', 3, 3, 12, 'ICD9', 1, 0, 0, 0, 1, 'HCPCS Procedure/Service', 0, 1, 1, 0, 0);
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external, ct_claim, ct_proc, ct_term, ct_problem ) VALUES ('CVX'  , 100, 100, 0, '', 0, 0, 1, 0, 1, 'CVX Immunization', 0, 0, 0, 0, 0);
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external, ct_claim, ct_proc, ct_term, ct_problem ) VALUES ('DSMIV' , 101, 101, 0, '', 0, 0, 0, 1, 0, 'DSMIV Diagnosis', 0, 1, 0, 0, 1);
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external, ct_claim, ct_proc, ct_term, ct_problem ) VALUES ('ICD10' , 102, 102, 0, '', 0, 0, 0, 1, 0, 'ICD10 Diagnosis', 1, 1, 0, 0, 1);
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external, ct_claim, ct_proc, ct_term, ct_problem ) VALUES ('SNOMED' , 103, 103, 0, '', 0, 0, 0, 1, 0, 'SNOMED Diagnosis', 2, 1, 0, 0, 1);
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external, ct_claim, ct_proc, ct_term, ct_problem ) VALUES ('CPTII' , 104, 104, 0, 'ICD9', 0, 0, 0, 0, 0, 'CPTII Performance Measures', 0, 1, 0, 0, 0);
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external, ct_claim, ct_proc, ct_term, ct_problem ) VALUES ('ICD9-SG' , 105, 105, 12, 'ICD9', 1, 0, 0, 0, 0, 'ICD9 Procedure/Service', 5, 1, 1, 0, 0);
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external, ct_claim, ct_proc, ct_term, ct_problem ) VALUES ('ICD10-PCS' , 106, 106, 12, 'ICD10', 1, 0, 0, 0, 0, 'ICD10 Procedure/Service', 6, 1, 1, 0, 0);
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external, ct_claim, ct_proc, ct_term, ct_problem ) VALUES ('SNOMED-CT' , 107, 107, 0, '', 0, 0, 1, 0, 0, 'SNOMED Clinical Term', 7, 0, 0, 1, 0);
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external, ct_claim, ct_proc, ct_term, ct_problem ) VALUES ('SNOMED-PR' , 108, 108, 0, 'SNOMED', 1, 0, 0, 0, 0, 'SNOMED Procedure', 9, 1, 1, 0, 0);

INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('lists', 'code_types', 'Code Types', 1);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'disclosure_type','Disclosure Type', 3,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('disclosure_type', 'disclosure-treatment', 'Treatment', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('disclosure_type', 'disclosure-payment', 'Payment', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('disclosure_type', 'disclosure-healthcareoperations', 'Health Care Operations', 30, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'smoking_status','Smoking Status', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, codes ) VALUES ('smoking_status', '1', 'Current every day smoker', 10, 0, 'SNOMED-CT:449868002');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, codes ) VALUES ('smoking_status', '2', 'Current some day smoker', 20, 0, 'SNOMED-CT:428041000124106');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, codes ) VALUES ('smoking_status', '3', 'Former smoker', 30, 0, 'SNOMED-CT:8517006');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, codes ) VALUES ('smoking_status', '4', 'Never smoker', 40, 0, 'SNOMED-CT:266919005');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, codes ) VALUES ('smoking_status', '5', 'Smoker, current status unknown', 50, 0, 'SNOMED-CT:77176002');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, codes ) VALUES ('smoking_status', '9', 'Unknown if ever smoked', 60, 0, 'SNOMED-CT:266927001');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, codes ) VALUES ('smoking_status', '15', 'Heavy tobacco smoker', 70, 0, 'SNOMED-CT:428071000124103');
INSERT INTO list_options ( list_id, option_id, title, seq, is_default, codes ) VALUES ('smoking_status', '16', 'Light tobacco smoker', 80, 0, 'SNOMED-CT:428061000124105');

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'race','Race', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('race', 'amer_ind_or_alaska_native', 'American Indian or Alaska Native', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('race', 'Asian', 'Asian',20,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('race', 'black_or_afri_amer', 'Black or African American',30,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('race', 'native_hawai_or_pac_island', 'Native Hawaiian or Other Pacific Islander',40,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('race', 'white', 'White',50,0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'ethnicity','Ethnicity', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethnicity', 'hisp_or_latin', 'Hispanic or Latino', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('ethnicity', 'not_hisp_or_latin', 'Not Hispanic or Latino', 10, 0);

INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('lists'   ,'payment_date','Payment Date', 1,0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_date', 'date_val', 'Date', 10, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_date', 'post_to_date', 'Post To Date', 20, 0);
INSERT INTO list_options ( list_id, option_id, title, seq, is_default ) VALUES ('payment_date', 'deposit_date', 'Deposit Date', 30, 0);
-- --------------------------------------------------------

-- 
-- Table structure for table `extended_log`
--

DROP TABLE IF EXISTS `extended_log`;
CREATE TABLE `extended_log` (
  `id` bigint(20) NOT NULL auto_increment,
  `date` datetime default NULL,
  `event` varchar(255) default NULL,
  `user` varchar(255) default NULL,
  `recipient` varchar(255) default NULL,
  `description` longtext,
  `patient_id` bigint(20) default NULL,
  PRIMARY KEY  (`id`),
  KEY `patient_id` (`patient_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

CREATE TABLE version (
  v_major    int(11)     NOT NULL DEFAULT 0,
  v_minor    int(11)     NOT NULL DEFAULT 0,
  v_patch    int(11)     NOT NULL DEFAULT 0,
  v_realpatch int(11)    NOT NULL DEFAULT 0,
  v_tag      varchar(31) NOT NULL DEFAULT '',
  v_database int(11)     NOT NULL DEFAULT 0,
  v_acl      int(11)     NOT NULL DEFAULT 0
) ENGINE=MyISAM;
INSERT INTO version (v_major, v_minor, v_patch, v_realpatch, v_tag, v_database, v_acl) VALUES (0, 0, 0, 0, '', 0, 0);
-- --------------------------------------------------------

--
-- Table structure for table `customlists`
--

CREATE TABLE `customlists` (
  `cl_list_slno` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cl_list_id` int(10) unsigned NOT NULL COMMENT 'ID OF THE lIST FOR NEW TAKE SELECT MAX(cl_list_id)+1',
  `cl_list_item_id` int(10) unsigned DEFAULT NULL COMMENT 'ID OF THE lIST FOR NEW TAKE SELECT MAX(cl_list_item_id)+1',
  `cl_list_type` int(10) unsigned NOT NULL COMMENT '0=>List Name 1=>list items 2=>Context 3=>Template 4=>Sentence 5=> SavedTemplate 6=>CustomButton',
  `cl_list_item_short` varchar(10) DEFAULT NULL,
  `cl_list_item_long` text NOT NULL,
  `cl_list_item_level` int(11) DEFAULT NULL COMMENT 'Flow level for List Designation',
  `cl_order` int(11) DEFAULT NULL,
  `cl_deleted` tinyint(1) DEFAULT '0',
  `cl_creator` int(11) DEFAULT NULL,
  PRIMARY KEY (`cl_list_slno`)
) ENGINE=InnoDB AUTO_INCREMENT=1;
INSERT INTO customlists(cl_list_id,cl_list_type,cl_list_item_long) VALUES (1,2,'Subjective');
INSERT INTO customlists(cl_list_id,cl_list_type,cl_list_item_long) VALUES (2,2,'Objective');
INSERT INTO customlists(cl_list_id,cl_list_type,cl_list_item_long) VALUES (3,2,'Assessment');
INSERT INTO customlists(cl_list_id,cl_list_type,cl_list_item_long) VALUES (4,2,'Plan');
-- --------------------------------------------------------

--
-- Table structure for table `template_users`
--

CREATE TABLE `template_users` (
  `tu_id` int(11) NOT NULL AUTO_INCREMENT,
  `tu_user_id` int(11) DEFAULT NULL,
  `tu_facility_id` int(11) DEFAULT NULL,
  `tu_template_id` int(11) DEFAULT NULL,
  `tu_template_order` int(11) DEFAULT NULL,
  PRIMARY KEY (`tu_id`),
  UNIQUE KEY `templateuser` (`tu_user_id`,`tu_template_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1;

CREATE TABLE `product_warehouse` (
  `pw_drug_id`   int(11) NOT NULL,
  `pw_warehouse` varchar(31) NOT NULL,
  `pw_min_level` float       DEFAULT 0,
  `pw_max_level` float       DEFAULT 0,
  PRIMARY KEY  (`pw_drug_id`,`pw_warehouse`)
) ENGINE=MyISAM;

-- --------------------------------------------------------

--
-- Table structure for table `misc_address_book`
--

CREATE TABLE `misc_address_book` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `fname` varchar(255) DEFAULT NULL,
  `mname` varchar(255) DEFAULT NULL,
  `lname` varchar(255) DEFAULT NULL,
  `street` varchar(60) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  `state` varchar(30) DEFAULT NULL,
  `zip` varchar(20) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- --------------------------------------------------------

-- --------------------------------------------------------
--
-- Table structure for table `esign_signatures`
--

CREATE TABLE `esign_signatures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tid` int(11) NOT NULL COMMENT 'Table row ID for signature',
  `table` varchar(255) NOT NULL COMMENT 'table name for the signature',
  `uid` int(11) NOT NULL COMMENT 'user id for the signing user',
  `datetime` datetime NOT NULL COMMENT 'datetime of the signature action',
  `is_lock` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'sig, lock or amendment',
  `amendment` text COMMENT 'amendment text, if any',
  `hash` varchar(255) NOT NULL COMMENT 'hash of signed data',
  `signature_hash` varchar(255) NOT NULL COMMENT 'hash of signature itself',
  PRIMARY KEY (`id`),
  KEY `tid` (`tid`),
  KEY `table` (`table`)
) ENGINE=InnoDB AUTO_INCREMENT=1 ;

CREATE TABLE `shared_attributes` (
  `pid`          bigint(20)   NOT NULL,
  `encounter`    bigint(20)   NOT NULL COMMENT '0 if patient attribute, else encounter attribute',
  `field_id`     varchar(31)  NOT NULL COMMENT 'references layout_options.field_id',
  `last_update`  datetime     NOT NULL COMMENT 'time of last update',
  `user_id`      bigint(20)   NOT NULL COMMENT 'user who last updated',
  `field_value`  TEXT         NOT NULL,
  PRIMARY KEY (`pid`, `encounter`, `field_id`)
);

-- --------------------------------------------------------
--
-- Table structure for table `ippf2_categories`
--

CREATE TABLE `ippf2_categories` (
  `category_header` varchar(3) DEFAULT NULL,
  `category_name` varchar(255) DEFAULT NULL,
  `exclude` BIT NOT NULL DEFAULT b'0'
) ENGINE=MyISAM ;
INSERT INTO `ippf2_categories` VALUES ('1','CONTRACEPTIVE SERVICES',b'0')
                                     ,('211','SRH - ABORTION',b'0')
                                     ,('212','SRH - HIV AND AIDS',b'0')
                                     ,('213','SRH - STI/RTI',b'0')
                                     ,('214','SRH - GYNECOLOGY',b'0')
                                     ,('215','SRH - OBSTETRIC',b'0')
                                     ,('216','SRH - UROLOGY',b'0')
                                     ,('217','SRH - SUBFERTILITY',b'0')
                                     ,('218','SRH - SPECIALISED SRH SERVICES',b'0')
                                     ,('219','SRH - PEDIATRICS',b'0')
                                     ,('220','SRH - OTHER',b'0')
                                     ,('4','NON-CLINICAL - ADMINISTRATION',b'1')
                                     ,('31','NON-SRH - MEDICAL',b'0');

-- --------------------------------------------------------

CREATE TABLE `voids` (
  `void_id`                bigint(20)    NOT NULL AUTO_INCREMENT,
  `patient_id`             bigint(20)    NOT NULL            COMMENT 'references patient_data.pid',
  `encounter_id`           bigint(20)    NOT NULL DEFAULT 0  COMMENT 'references form_encounter.encounter',
  `what_voided`            varchar(31)   NOT NULL            COMMENT 'checkout,receipt and maybe other options later',
  `date_original`          datetime      DEFAULT NULL        COMMENT 'time of original action that is now voided',
  `date_voided`            datetime      NOT NULL            COMMENT 'time of void action',
  `user_id`                bigint(20)    NOT NULL            COMMENT 'references users.id',
  `amount1`                decimal(12,2) NOT NULL DEFAULT 0  COMMENT 'for checkout,receipt total voided adjustments',
  `amount2`                decimal(12,2) NOT NULL DEFAULT 0  COMMENT 'for checkout,receipt total voided payments',
  `other_info`             text          NOT NULL DEFAULT '' COMMENT 'for checkout,receipt the old invoice refno',
  `reason`                 VARCHAR(31)   default '',
  `notes`                  VARCHAR(255)  default '',
  PRIMARY KEY (`void_id`),
  KEY datevoided (date_voided),
  KEY pidenc (patient_id, encounter_id)
) ENGINE=MyISAM;

INSERT INTO list_options (list_id, option_id, title, seq, is_default) VALUES ('lists','void_reasons','Void Reasons', 1,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','ADJ01','Adj - Reason Corrected',50,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','ADJ02','Adj - Amount Corrected',51,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','DEF01','Default Price Level Modified',40,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','DEF02','Default Provider Modified',41,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','OTH','Other',80,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','PAY01','Payment - Amount Modified',60,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','PAY02','Payment - Method Modified',61,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','PAY03','Payment - Posting Date Correction',62,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','PROD01','Product - Added',20,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','PROD02','Product - Deleted and Replaced',21,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','PROD03','Product - Deleted; Not provided',22,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','PROD04','Product - Price Level Modified ',30,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','PROD05','Product - Quantity Modified',31,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','PROD06','Product - Warehouse Modified',32,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','SRV01','Service - Added',1,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','SRV02','Service - Deleted and Replaced',2,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','SRV03','Service - Deleted; Not provided',3,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','SRV04','Service - Provider Modified',4,0,0,'','','',1,0,0);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `activity`, `toggle_setting_1`, `toggle_setting_2`) VALUES ('void_reasons','SRV05','Service - Quanitity Modified',5,0,0,'','','',1,0,0);

INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists','shift','Shifts', 1,0);

INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('lists', 'reftype', 'Referral Types', 1);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('reftype','2' ,'Outbound External',10);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('reftype','3' ,'Outbound Internal',20);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('reftype','4' ,'Inbound External' ,30);
INSERT INTO list_options ( list_id, option_id, title, seq ) VALUES ('reftype','5' ,'Inbound Internal' ,40);

INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`) VALUES ('lists','chargecats','Customers', 1);

CREATE TABLE `login_mfa_registrations` (
  `user_id`         bigint(20)     NOT NULL,
  `name`            varchar(256)   NOT NULL,
  `last_challenge`  datetime       DEFAULT NULL,
  `method`          varchar(31)    NOT NULL COMMENT 'Q&A, U2F, TOTP etc.',
  `var1`            varchar(4096)  NOT NULL DEFAULT '' COMMENT 'Question, key handle and key etc.',
  `var2`            varchar(256)   NOT NULL DEFAULT '' COMMENT 'Answer, last U2F count etc.',
  PRIMARY KEY (`user_id`, `name`)
) ENGINE=MyISAM;

INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`) VALUES ('lists','login_security_questions','Login Security Questions', 1);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`) VALUES ('login_security_questions','mmname'  ,'What is your mother''s maiden name?' ,10);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`) VALUES ('login_security_questions','firstpet','What was the name of your first pet?',20);
