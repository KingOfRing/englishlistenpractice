<?php
class ListenBook extends model {
	const TABLE_NAME = "listen_book";
	#####课本数据表操作
	public function insertImage($imageFile){
		$imagePath = dirname(dirname(__FILE__)).DIRECTORY_SEPARATOR.
					 'upload'.DIRECTORY_SEPARATOR.
					 'listen'.DIRECTORY_SEPARATOR.
					  fileCharset($_POST['bookName']).DIRECTORY_SEPARATOR;
		if(!file_exists($imagePath)){
			mkdir($imagePath,0777,true);
		}
		if($imageFile['error'] == UPLOAD_ERR_OK){ //封面图片上传成功
			if(is_uploaded_file($imageFile['tmp_name'])){
				if(move_uploaded_file($imageFile['tmp_name'],$imagePath.fileCharset($imageFile['name']))){
			        $imageUrl = $_SERVER['HTTP_HOST'].DIRECTORY_SEPARATOR.
			        			'upload'.DIRECTORY_SEPARATOR.
			        			'listen'.DIRECTORY_SEPARATOR.
			        			($_POST['bookName']).DIRECTORY_SEPARATOR.
			        			$imageFile['name'];
				}
			}
		}
		return $imageUrl;
	}
	public function insertBook($data) {
		$imageFile = $data['image'];
		$data['imageUrl'] = $this->insertImage($imageFile);
		unset($data['image']);
	    return $this->db->insert(self::TABLE_NAME,$data);
	}
	public function updateBook($data) {
		if(empty($data)){
			return false;
		}
		if($data['image']['error']!= UPLOAD_ERR_NO_FILE){ //修改了封面图片
			$imageFile = $data['image'];
			$imageUrl = $this->getBookInfoById($data['bookId'],"imageUrl");
			$deleteImagePath = dirname(dirname(__FILE__)).DIRECTORY_SEPARATOR.
			                   'upload'.DIRECTORY_SEPARATOR.
			                   'listen'.fileCharset(explode("listen", $imageUrl)[1]);
			unlink($deleteImagePath);
			$data['imageUrl'] = addcslashes($this->insertImage($imageFile), "\\");
		}
		$condition = " bookId =".$data['bookId'];
		unset($data['image']);
		unset($data['bookId']);
		return $this->db->update(self::TABLE_NAME,$data,$condition);
	}
	public function deleteBook($idList) {
	    $idArray = explode(",", $idList);
		foreach ($idArray as $value) {
			$imageUrl = $this->getBookInfoById(intval($value),"imageUrl");
			$imagePath = dirname(dirname(__FILE__)).DIRECTORY_SEPARATOR.
			             'upload'.DIRECTORY_SEPARATOR.
			             'listen'.fileCharset(explode("listen", $imageUrl)[1]);
			unlink($imagePath);
		}	
		$idList = $_POST['id'];
		$condition = " bookId IN (".$idList.")";
		return $this->db->delete(self::TABLE_NAME,$condition);
	}
	public function getBookList($categoryId){
	    $fields = "*";
	    $condition = "categoryId = ".$categoryId;
	    return $this->db->select(self::TABLE_NAME,$fields,$condition);
	}
	public function getRecommendBook($number=9){
		$fields = "*";
		$condition = "";
		$order="ORDER BY updateTime DESC ";
		$limit="LIMIT $number";
		return $this->db->select(self::TABLE_NAME,$fields,$condition,$order,$limit);
	}
	public function getBookInfoById($id,$fields="*"){
		$condition = " bookId = $id";
		$result = $this->db->select(self::TABLE_NAME,$fields,$condition);
		if($fields == "*"){
			return $result;
		}
		return $result[0][$fields];
	}
} 
 ?>