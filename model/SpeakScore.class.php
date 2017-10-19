<?php
	class SpeakScore extends model{
		#####成绩数据表操作
	    public function uploadSocre($data){
	        $sql = "INSERT INTO score (userId,bookId,articleId,score) VALUES  
	                                 (:userId,:bookId,:articleId,:score)";
	        $stmt = $this->db->prepare($sql);
	        $stmt->bindParam(":userId",$data["userId"],db::PARAM_INT);
	        $stmt->bindParam(":bookId",$data["bookId"],db::PARAM_INT);
	        $stmt->bindParam(":articleId",$data["articleId"],db::PARAM_INT);
	        $stmt->bindParam(":score",$data["score"],db::PARAM_INT);  
	        return $stmt->execute();                             
	    }
	    public function getScoreListByAccount($userId){
	        $sql = "SELECT * FROM score WHERE userId =:userId ORDER BY bookId ASC,articleId ASC";
	        $stmt = $this->db->prepare($sql);
	        $stmt->bindParam(":userId",$userId,db::PARAM_INT);
	        $stmt->execute();
	        $stmt->setFetchMode(db::FETCH_ASSOC);
	        $result = $stmt->fetchAll();
	        return $result;
	    }
	    public function getAllSocreList(){
	        $sql = "SELECT * FROM score  ORDER BY userId ASC,bookId ASC,articleId ASC";
	        $stmt = $this->db->prepare($sql);
	        $stmt->execute();
	        $stmt->setFetchMode(db::FETCH_ASSOC);
	        $result = $stmt->fetchAll();
	        return $result;
	    }
	} 
 ?>