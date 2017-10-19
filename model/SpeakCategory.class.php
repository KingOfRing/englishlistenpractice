<?php
	class SpeakCategory extends Model{
		const TABLE_NAME = "speak_category";
		public function insertCategory(){
			$data = array();
			$data['categoryName'] = $_POST['categoryName'];
			$data['description'] = $_POST['description'];
			return $this->db->insert(self::TABLE_NAME,$data);
		}
		public function deleteCategory(){
			$idList = $_POST['id'];
			$condition = " id IN (".$idList.")";
			return $this->db->delete(self::TABLE_NAME,$condition);
		}
		public function updateCategory(){
			$data['categoryName'] = $_POST['categoryName'];
			$data['description'] = $_POST['description'];
			$condition = "id =".$_GET['categoryId'];
			return $this->db->update(self::TABLE_NAME,$data,$condition);
		}
		public function getCategoryList(){
			return $this->db->select(self::TABLE_NAME);
		}
		public function getCategoryInfoById($id,$fields="*"){
			$condition = " id = $id";
			$result = $this->db->select(self::TABLE_NAME,$fields,$condition);
			if($fields == "*"){
				return $result;
			}
			return $result[0][$fields];
		}
	} 
 ?>