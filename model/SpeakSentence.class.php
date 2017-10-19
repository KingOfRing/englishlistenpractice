<?php
class SpeakSentence extends model {
	const TABLE_NAME = "speak_sentence";
	#####课本数据表操作
	public function insertVoice($data){

		$bookModel = new SpeakBook();
		$articleModel = new SpeakArticle();
		$bookName = $bookModel->getBookInfoById($data['bookId'],"bookName");
		$articleTitle = $articleModel->getArticleInfoById($data['articleId'],"articleTitle"); 
		$voiceFile = $data['voice'];
		$voicePath = dirname(dirname(__FILE__)).DIRECTORY_SEPARATOR.
					 'upload'.DIRECTORY_SEPARATOR.
					 'speak'.DIRECTORY_SEPARATOR.
					 fileCharset($bookName).DIRECTORY_SEPARATOR.
					 fileCharset($articleTitle).DIRECTORY_SEPARATOR;
		if(!file_exists($voicePath)){
			mkdir($voicePath,0777,true);
		}
		if($voiceFile['error'] == UPLOAD_ERR_OK){ //封面图片上传成功
			if(is_uploaded_file($voiceFile['tmp_name'])){
				if(move_uploaded_file($voiceFile['tmp_name'], $voicePath.fileCharset($voiceFile['name']))){
			        $voiceUrl = $_SERVER['HTTP_HOST'].DIRECTORY_SEPARATOR.
			        			'upload'.DIRECTORY_SEPARATOR.
			        			'speak'.DIRECTORY_SEPARATOR.
			        			$bookName.DIRECTORY_SEPARATOR.
			        			$articleTitle.DIRECTORY_SEPARATOR.
			        			$voiceFile['name'];
				}
			}
		}
		return $voiceUrl;
	}
	public function insertSentence($data) {
		if($data['voice']['error'] > 0){
			$res['resCode'] = "E234";
			switch ($data['voice']['error']) {
				case '1':
					$res['resMsg'] = "文件大小不能超过10M"; 
					break;
				case '2':
					$res['resMsg'] = "文件大小不能超过10M"; 
					break;
				case '3':
					$res['resMsg'] = "文件部分上传"; 
					break;
				case '4':
					$res['resMsg'] = "没有文件上传";
					break;
				default:
					$res['resMsg'] = "文件上传失败";
					break;
			}
			ob_clean();
			echo json_encode($res);
			exit;
		}
		$data['voiceUrl'] = $this->insertVoice($data);
		unset($data['voice']);
		unset($data['bookId']);
	    return $this->db->insert(self::TABLE_NAME,$data);
	}
	public function updateSentence($data) {
		if(empty($data)){
			return false;
		}
		if(isset($data['voice']) && $data['voice']['error']!= UPLOAD_ERR_NO_FILE){ //修改了封面图片
			if($data['voice']['error']!= UPLOAD_ERR_OK){
				$res['resCode'] = "E234";
				switch ($data['voice']['error']) {
				case '1':
					$res['resMsg'] = "文件大小不能超过10M"; 
					break;
				case '2':
					$res['resMsg'] = "文件大小不能超过10M"; 
					break;
				case '3':
					$res['resMsg'] = "文件部分上传"; 
					break;
				default:
					$res['resMsg'] = "文件上传失败";
					break;
				}
				ob_clean();
				echo json_encode($res);
				exit;
			}
			$voiceFile = $data['voice'];
			$voiceUrl = $this->getSentenceInfoById($data['sentenceId'],"voiceUrl");
			$deleteImagePath= dirname(dirname(__FILE__)).DIRECTORY_SEPARATOR.
							  'upload'.DIRECTORY_SEPARATOR.
			                  'speak'.fileCharset(explode("speak", $voiceUrl)[1]);
			unlink($deleteImagePath);
			$data['voiceUrl'] = addcslashes($this->insertVoice($data), "\\");
		}
		$condition = " id =".$data['sentenceId'];
		unset($data['voice']);
		unset($data['bookId']);
		unset($data['sentenceId']);
		return $this->db->update(self::TABLE_NAME,$data,$condition);
	}
	public function deleteSentence($idList) {
	    $idArray = explode(",", $idList);
		foreach ($idArray as $value) {
			$voiceUrl = $this->getSentenceInfoById(intval($value),"voiceUrl");
			$voicePath = dirname(dirname(__FILE__)).DIRECTORY_SEPARATOR.
			             'upload'.DIRECTORY_SEPARATOR.
			             'speak'.fileCharset(explode("speak", $voiceUrl)[1]);
			unlink($voicePath);
		}	
		$idList = $_POST['id'];
		$condition = " id IN (".$idList.")";
		return $this->db->delete(self::TABLE_NAME,$condition);
	}
	public function getSentenceList($articleId){
	    $fields = "*";
	    $condition = "articleId = ".$articleId;
	    return $this->db->select(self::TABLE_NAME,$fields,$condition);
	}
	public function getSentenceInfoById($id,$fields="*"){
		$condition = " id = $id";
		$result = $this->db->select(self::TABLE_NAME,$fields,$condition);
		if($fields == "*"){
			return $result;
		}
		return $result[0][$fields];
	}
} 
?>