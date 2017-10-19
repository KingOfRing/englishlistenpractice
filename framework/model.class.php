<?php
/**
 * 基础模型类
 */
class model {
	protected $db; //保存数据库对象
	public function __construct(){
		$this->initDB(); // 初始化数据库
	}
	private function initDB(){
		//配置数据库连接信息
		$dbConfig = array('dbname'=>'oral');
		//实例化数据库操作类
		$this->db = MySQLPDO::getInstance($dbConfig);
	}
}
