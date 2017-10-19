<?php  
	define("ROOT_PATH",dirname(dirname(__FILE__)));
	require_once(ROOT_PATH.'/framework/MySQLPDO.class.php');
	require_once(ROOT_PATH.'/framework/model.class.php');
	require_once(ROOT_PATH.'/framework/global.fun.php');
	function __autoload($className){
		require_once(ROOT_PATH.'/model/'.$className.".class.php");
	}
?>