-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.6.10 - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL version:             7.0.0.4053
-- Date/time:                    2013-06-17 04:04:28
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;

-- Dumping structure for procedure test.pCleanup
DELIMITER //
CREATE DEFINER=`dayz`@`localhost` PROCEDURE `pCleanup`()
BEGIN

#starts outofbounds cleanup
	CALL pCleanupOOB();
	
#remove dead players from data table
	DELETE 
		FROM Character_DATA 
		WHERE Alive=0;	
	
#remove vehicles with 100% damage
	DELETE
		FROM Object_DATA 
		WHERE Damage = '1';	

#remove unused vehicles older then 14 days
	DELETE
		FROM Object_DATA
		WHERE DATE(last_updated) < CURDATE() - INTERVAL 14 DAY
			AND Classname != 'dummy'
			AND Classname != 'Hedgehog_DZ'
			AND Classname != 'Wire_cat1'
			AND Classname != 'Sandbag1_DZ'
			AND Classname != 'BearTrap_DZ'
			AND Classname != 'StashSmall'
			AND Classname != 'StashMedium';

#remove tents/stash's whose owner has been dead for four days
	DELETE
		FROM Object_DATA
		USING Object_DATA, character_data
		WHERE Object_DATA.Classname = 'TentStorage' or Object_DATA.Classname = 'StashSmall' or Object_DATA.Classname = 'StashMedium'
			AND Object_DATA.CharacterID = character_data.CharacterID
			AND character_data.Alive = 0
			AND DATE(character_data.last_updated) < CURDATE() - INTERVAL 4 DAY;

#remove empty tents older than seven days
	DELETE
		FROM Object_DATA
		WHERE Classname = 'TentStorage' or Classname = 'StashSmall' or Classname = 'StashMedium'
			AND DATE(last_updated) < CURDATE() - INTERVAL 7 DAY
			AND Inventory = '[[[],[]],[[],[]],[[],[]]]';
	
	DELETE
		FROM Object_DATA
		WHERE Classname = 'TentStorage' or Classname = 'StashSmall' or Classname = 'StashMedium'
			AND DATE(last_updated) < CURDATE() - INTERVAL 7 DAY
			AND Inventory = '[]';		

#remove barbed wire older than two days
	DELETE
		FROM Object_DATA
		WHERE Classname = 'Wire_cat1'
			AND DATE(last_updated) < CURDATE() - INTERVAL 2 DAY;
			
#remove Tank Traps older than fifteen days
	DELETE
		FROM Object_DATA
		WHERE Classname = 'Hedgehog_DZ'
			AND DATE(last_updated) < CURDATE() - INTERVAL 15 DAY;

#remove Sandbags older than twenty days
	DELETE
		FROM Object_DATA
		WHERE Classname = 'Sandbag1_DZ'
			AND DATE(last_updated) < CURDATE() - INTERVAL 20 DAY;

#remove Bear Traps older than five days
	DELETE
		FROM Object_DATA
		WHERE Classname = 'BearTrap_DZ'
			AND DATE(last_updated) < CURDATE() - INTERVAL 5 DAY;

END//
DELIMITER ;
/*!40014 SET FOREIGN_KEY_CHECKS=1 */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
