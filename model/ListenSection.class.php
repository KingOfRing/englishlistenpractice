<?php
class ListenSection extends model {
	const TABLE_NAME = "listen_section";
	#####课本数据表操作
	public function insertSection($data) {
	    return $this->db->insert(self::TABLE_NAME,$data);
	}
	public function updateSection($data) {
		if(empty($data)){
			return false;
		}
		$condition = " id =".$data['id'];
		unset($data['id']);
		return $this->db->update(self::TABLE_NAME,$data,$condition);
	}
	public function deleteSection($idList) {
		$condition = " id IN (".$idList.")";
		return $this->db->delete(self::TABLE_NAME,$condition);
	}
	public function getSectionList($unitId){
	    $fields = "*";
	    $condition = "unitId = $unitId and pid is NULL";
	    return $this->db->select(self::TABLE_NAME,$fields,$condition);
	}
	public function getSectionByPid($unitId,$pid){
		$fields="*";
		$condition = " unitId = $unitId and pid = $pid";
		$result = $this->db->select(self::TABLE_NAME,$fields,$condition);
		return $result;
		// if($fields == "*"){
		// 	return $result;
		// }
		// return $result[0][$fields];
	}
} 
 ?>