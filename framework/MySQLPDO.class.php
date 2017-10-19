<?php
/**
 * PDO-MySQL数据库操作类
 */
class MySQLPDO{
	//数据库默认连接信息
	private $dbConfig = array(
		'db'   => 'mysql', //数据库类型
		'host' => 'localhost', //服务器地址
		'port' => '3306', //端口
		'user' => 'root', //用户名
		'pass' => 'Gaoxin2016', //密码
		'charset' => 'utf8', //字符集
		'dbname' => '', //默认数据库
	);
	//单例模式 本类对象引用
	private static $instance;
	//PDO实例
	private $db;
	/**
	 * 私有构造方法
	 * @param $params array 数据库连接信息
	 */
	private function __construct($params){
		//初始化属性
		$this->dbConfig = array_merge($this->dbConfig,$params);
		//连接服务器
		$this->connect();
	}
	/**
	 * 获得单例对象
	 * @param $params array 数据库连接信息
	 * @return object 单例的对象
	 */
	public static function getInstance($params = array()){
		if(!self::$instance instanceof self){
			self::$instance = new self($params);
		}
		return self::$instance; //返回对象
	}
	/**
	 * 私有克隆
	 */
    private function __clone() {}
	/**
	 * 连接目标服务器
	 */
	private function connect(){
		try{
			//连接信息
			$dsn = "{$this->dbConfig['db']}:host={$this->dbConfig['host']};port={$this->dbConfig['host']};dbname={$this->dbConfig['dbname']};charset={$this->dbConfig['charset']}";
			//实例化PDO
			$this->db = new PDO($dsn,$this->dbConfig['user'],$this->dbConfig['pass']);
			//设定字符集
			$this->db->query("set names {$this->dbConfig['charset']}");
			$this->db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
		}catch (PDOException $e){
			//错误提示
			die("数据库操作失败：{$e->getMessage()}");
		}
	}
	/**
	 *插入数据
	 *@param $table 表名
	 *@param $data 插入的数据（$key->$value）
	 *@param $flag 是否插入成功
	*/
	public function insert($table,$data = array()){
		if(empty($data)){
			die("插入的数据不能为空");
		}
		$fields = '';
		$params = '';
		foreach ($data as $key => $value) {
			$fields .= ($key.',');
			$params .= (':'.$key.',');
		}
		$fields = substr($fields, 0,-1);
		$params = substr($params, 0,-1);
		$sql = "INSERT INTO $table ($fields) VALUES ($params)";
		$stmt = $this->db->prepare($sql);
		foreach ($data as $key => &$value) {
			$stmt->bindParam(":$key", $value,is_int($value)?PDO::PARAM_INT:PDO::PARAM_STR);
		}
		$flag = $stmt->execute();
		if($flag===false){
			$error = $this->db->errorInfo();
			die("数据库操作失败：ERROR {$error[1]}({$error[0]}): {$error[2]}");
		}
		return $this->db->lastInsertId();
	}
	/**
	*查询数据
	*@param $table 表名
	*@param $filed 返回字段
	*@param $condition 查询条件
	*@param $order 按某个字段排序
	*@param $limit 限制读取记录条数
	*/
	public function select($table,$fields = "*",$condition ="",$order="",$limit=""){
		$sql = "SELECT $fields FROM $table";
		if(!empty($condition)){  //查询所有数据
			$sql .= " WHERE $condition " .$order." ".$limit;
		}
		else{
			$sql .= " " .$order." ".$limit;
		}
		$stmt = $this->db->prepare($sql);
		$stmt->execute();
		$result = $stmt->fetchAll(PDO::FETCH_ASSOC);
		return $result;
	}
	/**
	*删除数据
	*@param $table 表名
	*@param $condition 删除条件
	*/
	public function delete($table,$condition =""){
		if(empty($condition)){
			die("查询条件不能为空");
		}
		$sql = "DELETE FROM $table WHERE $condition";
		$stmt = $this->db->prepare($sql);
	    $flag = $stmt->execute();
		if($flag===false){
			$error = $this->db->errorInfo();
			die("数据库操作失败：ERROR {$error[1]}({$error[0]}): {$error[2]}");
		}
		return $flag;
	}
	/**
	*
	*
	*
	*/
	public function update($table,$data=array(),$condition){
		if(empty($data)){
			die("数据不能为空");
		}
		if(empty($condition)){
			die("条件不能为空");
		}
		$setValue = "";
		foreach ($data as $key => $value) {
			$setValue .= "$key=".(is_int($value)?$value:"'".$value."'").",";
		}
		$setValue = substr($setValue, 0, -1);
		$sql = "UPDATE $table SET $setValue WHERE $condition";
		$stmt = $this->db->prepare($sql);
		$flag = $stmt->execute();
		if($flag===false){
			$error = $this->db->errorInfo();
			die("数据库操作失败：ERROR {$error[1]}({$error[0]}): {$error[2]}");
		}
		return $flag;
	}
	/**
     * close the database connection
     */
	public function __destruct() {
        // close the database connection
        $this->db = null;
    }
}
