<?php
class ListenUnit extends model {
	const TABLE_NAME = "listen_unit";
	#####课本数据表操作
	public function insertUnit($data) {
	    return $this->db->insert(self::TABLE_NAME,$data);
	}
	public function updateUnit($data) {
		if(empty($data)){
			return false;
		}
		$condition = " unitId =".$data['unitId'];
		unset($data['unitId']);
		return $this->db->update(self::TABLE_NAME,$data,$condition);
	}
	public function deleteUnit($idList) {
		$condition = " unitId IN (".$idList.")";
		return $this->db->delete(self::TABLE_NAME,$condition);
	}
	public function getUnitList($bookId){
	    $fields = "*";
	    $condition = "bookId = ".$bookId;
	    return $this->db->select(self::TABLE_NAME,$fields,$condition);
	}
	public function getUnitInfoById($id,$fields="*"){
		$condition = " unitId = $id";
		$result = $this->db->select(self::TABLE_NAME,$fields,$condition);
		if($fields == "*"){
			return $result;
		}
		return $result[0][$fields];
	}
} 
 ?>