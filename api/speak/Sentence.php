<?php
    header("Content-Type:text/html;charset=utf-8");
	require_once('../../framework/common.inc.php');
	$action = $_GET['action'];
	$sentenceModel =  new SpeakSentence();
	if($action == "insertSentence"){
		$data['bookId'] = $_GET['bookId'];
		$data['articleId'] = $_GET['articleId'];
	 	$data['english'] = addslashes($_POST['english']);
	 	$data['chinese'] = addslashes($_POST['chinese']);
	 	$data['voice'] = $_FILES['voiceFile'];
	    if($sentenceModel->insertSentence($data)){
	    	$res['resCode'] = "S456";
			$res['resMsg'] = "succeed to insert the sentence";
	    }
	    else{
	    	$res['resCode'] = "E234";
	    	$res['resMsg'] = "failed to insert the sentence";
		}
		ob_clean();
		echo json_encode($res);
	}
	else if($action == "updateSentence"){
		$data['bookId'] = $_GET['bookId'];
		$data['articleId'] = $_GET['articleId'];
		$data['sentenceId'] = $_GET['sentenceId'];
	 	$data['english'] = addslashes($_POST['english']);
	 	$data['chinese'] = addslashes($_POST['chinese']);
	 	if(isset($_FILES['voiceFile'])){
	 		$data['voice'] = $_FILES['voiceFile'];
	 	}
	    if($sentenceModel->updateSentence($data)){
	    	$res['resCode'] = "S456";
			$res['resMsg'] = "succeed to update the sentence";
	    }
	    else{
	    	$res['resCode'] = "E234";
	    	$res['resMsg'] = "failed to update the sentence";
		}
		ob_clean();
		echo json_encode($res);
	}
	else if($action == "deleteSentence"){
		if($sentenceModel->deleteSentence($_POST['id'])){
	    	$res['resCode'] = "S456";
	    	$res['resMsg'] = "succeed to delete the sentence";
	    }
		else{
	    	$res['resCode'] = "E234";
	    	$res['resMsg'] = "failed to delete the sentence";
	    }
		ob_clean();
		echo json_encode($res);
	}
	else if($action == "getSentenceList"){
		if(isset($_GET['articleId'])){
			$sentenceList = $sentenceModel->getSentenceList($_GET['articleId']);
			$res['articleId'] = intval($_GET['articleId']);
		}
		else if(isset($_GET['sentenceId'])){
			$sentenceList = $sentenceModel->getSentenceInfoById($_GET['sentenceId']);
		}
		else{
			//do nothing
		}
		if(!empty($sentenceList)){
		    $resData = "";
	       	$res['sentenceNum'] = count($sentenceList);
	        $resData  .="[";
	        foreach ($sentenceList as $key => $value) { 
	          $resData  .= "{\"id\":".$value['id'].",";
			  $resData  .= "\"articleId\":".$value['articleId'].",";
			  $resData  .= "\"english\":"."\"".stripslashes($value['english'])."\"".",";
			  $resData  .= "\"chinese\":"."\"".stripslashes($value['chinese'])."\"".",";
			  $resData  .= "\"updateTime\":"."\"".$value['updateTime']."\"".",";
			  $resData  .= "\"voiceUrl\":"."\"".$value['voiceUrl']."\""."},";
		    }
		    $resData = substr($resData ,0,strlen($resData)-1);
		    $resData .="]";
			$res['sentenceList'] = $resData;
			$res['resCode'] = "S456";
	    	$res['resMsg'] = "succeed to get the sentence list";
		    $resStr = str_replace("\\\"", "\"", json_encode($res));
		    $resStr = str_replace("\"[", "[", $resStr);
		    $resStr = str_replace("]\"", "]", $resStr);
		    ob_clean();
		    echo $resStr;
		}
		else{
			$res['resCode'] = "E234";
	    	$res['resMsg'] = "failed to get the sentence list";
			ob_clean();
			echo json_encode($res);
		}
	}
	else if($action == "getArticleMenu"){
		$categoryModel = new SpeakCategory();
		$bookModel = new SpeakBook();
		$articleModel = new SpeakArticle();
		$categoryList = $categoryModel->getCategoryList();
		if(!empty($categoryModel)){
			$articleMenu = "[";
			$url = "";
			$pid = 0;
			foreach ($categoryList as $key => $value) {
				$categoryId =  $value['id'];
				$articleMenu.= "{\"id\":".$value['id'].",";
			  	$articleMenu.= "\"pid\":".$pid.",";
			  	$articleMenu.= "\"text\":"."\"".$value['categoryName']."\"".",";
			  	$articleMenu.= "\"url\":"."\"".$url."\""."},";
				$bookList = $bookModel->getBookList($categoryId);
				if(!empty($bookList)){
					foreach ($bookList as $key => $value) {
						$bookId = $value['id'];
						$articleMenu.= "{\"id\":".$value['id'].",";
						$articleMenu.= "\"pid\":".$categoryId.",";
						$articleMenu.= "\"text\":"."\"".$value['bookName']."\"".",";
						$articleMenu.= "\"url\":"."\"".$url."\""."},";
						$articleList = $articleModel->getArticleList($bookId);
						if(!empty($articleList)){
							foreach ($articleList as $key => $value) {
								$articleMenu .= "{\"id\":".$value['id'].",";
								$articleMenu .= "\"pid\":".$bookId.",";
								$articleMenu .= "\"text\":"."\"".$value['articleTitle']."\"".",";
								$articleMenu .= "\"url\":"."\"".$url."\""."},";
							}
						}
					}
				}
			}
			$articleMenu = substr($articleMenu ,0,-1);
		    $articleMenu.= "]";
		    echo $articleMenu;
		}
		else{
			ob_clean();
			echo json_encode($res);
		}
	}
	// else if($action == "getSentenceInfoById"){
	// 	$sentenceInfo = $sentenceModel->getSentenceInfoById($_POST['sentenceId']);
	// 	if(!empty($sentenceInfo)){
	// 		$resData = "";
	// 		$resData  .= "{\"id\":".$sentenceInfo[0]['id'].",";
	// 		$resData  .= "\"english\":"."\"".$sentenceInfo[0]['english']."\"".",";
	// 		$resData  .= "\"chinese\":"."\"".$sentenceInfo[0]['chinese']."\"".",";
	// 		$resData  .= "\"voiceUrl\":"."\"".$sentenceInfo[0]['voiceUrl']."\""."}";
	// 		$resData  = str_replace('\\', "\\\\", $resData);
	// 		ob_clean();
	// 		echo $resData;
	// 	}else{
	// 		$res['resCode'] = "E234";
	// 	    $res['resMsg'] = "failed to get the sentence info";
	// 		ob_clean();
	// 		echo json_encode($res);
	// 	}
	// }	
 ?>
