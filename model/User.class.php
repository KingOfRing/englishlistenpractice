<?php
	class User extends model{
		const TABLE_NAME = "user";
		######用户数据表操作
	    public function insertUser(){
	    	$data = array();
	    	$data['account'] = $_POST['account'];
	        $data['password'] = md5($_POST['password']);
	        $data['gender'] = $_POST['gender'];
	        $data['email'] = $_POST['email'];
	        $data['status']='student';
	        return $this->db->insert(self::TABLE_NAME,$data);
	    }
	    public function deleteUser(){
	    	$idList = $_POST['id'];
	    	$condition = " id IN (".$idList.")";
	        return $this->db->delete(self::TABLE_NAME,$condition);
	    }
	    public function validateUser($data,$status){
	    	$fields = "*";
	    	$account = $data['account'];
	    	$password = md5($data['password']);
	    	$condition = "account = '$account' and password = '$password' and status = '$status'";
	    	$result = $this->db->select(self::TABLE_NAME,$fields,$condition);
	        return (!empty($result));
	    }
	    public function hasTheUser($account){
	    	$fields = "*";
	    	$condition = "account = '$account'";
	        $result = $this->db->select(self::TABLE_NAME,$fields,$condition);
	        return (!empty($result));
	    }
	    public function getUserIdByAccount($account){
	    	$fields = "id";
	    	$condition = "account = '$account'";
	        $result = $this->db->select(self::TABLE_NAME,$fields,$condition);
	        return $result[0]["id"];
	    }
	    public function getAccountByUserId($id){
	    	$fields = "account";
	    	$condition = "id = $id";
	        $result = $this->db->select(self::TABLE_NAME,$fields,$condition);
	        return $result[0]["account"];
	    }
	    public function getUserList(){
	        return  $this->db->select(self::TABLE_NAME);
	    }
	    public function getUserInfoByAccount($account){
	    	$fields="*";
	    	$condition = "account = '$account'";
	        $result = $this->db->select(self::TABLE_NAME,$fields,$condition);
	        return $result;
	    }
	} 
 ?>