XPTemplate priority=personal

XPTinclude
      \ _common/common

let s:f = g:XPTfuncs()

XPT proc " procedure definition
DELIMITER $$
DROP PROCEDURE IF EXISTS `proc_name^ $$
CREATE PROCEDURE `proc_name^(`args^)
BEGIN
    `cursor^
END $$
DELIMITER ;
