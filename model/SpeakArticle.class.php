<?php
class SpeakArticle extends model {
	const TABLE_NAME = "speak_article";
	#####课本数据表操作
	public function insertArticle($data) {
	    return $this->db->insert(self::TABLE_NAME,$data);
	}
	public function updateArticle($data) {
		if(empty($data)){
			return false;
		}
		$condition = " id =".$data['articleId'];
		unset($data['articleId']);
		return $this->db->update(self::TABLE_NAME,$data,$condition);
	}
	public function deleteArticle($idList) {
		$condition = " id IN (".$idList.")";
		return $this->db->delete(self::TABLE_NAME,$condition);
	}
	public function getArticleList($bookId){
	    $fields = "*";
	    $condition = "bookId = ".$bookId;
	    return $this->db->select(self::TABLE_NAME,$fields,$condition);
	}
	public function getArticleInfoById($id,$fields="*"){
		$condition = " id = $id";
		$result = $this->db->select(self::TABLE_NAME,$fields,$condition);
		if($fields == "*"){
			return $result;
		}
		return $result[0][$fields];
	}
} 
 ?>