<?php
    header("Content-Type:text/html;charset=utf-8");
	require_once('../../framework/common.inc.php');
	$action = $_GET['action'];
	$sentenceModel =  new ListenSentence();
	$sectionModel = new ListenSection();
	if($action == "insertSentence"){
		$data['bookId'] = $_GET['bookId'];
		$data['unitId'] = $_GET['unitId'];
		$data['sectionId'] = $_GET['sectionId'];
		$data['orderId']=$_GET['orderId'];
	 	$data['english'] = addslashes($_POST['english']);
	 	$data['chinese'] = addslashes($_POST['chinese']);
	 	$data['voice'] = $_FILES['voiceFile'];
	 	//var_dump($data['voice']);
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
		$data['unitId'] = $_GET['unitId'];
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
		$orderIdList=$sentenceModel->selectOrderId($_POST['id']);
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
		//排序
		    $data=array();
		 	foreach($orderIdList as $key=>$value)
		 	{$data[$key]=$value['orderId'];
		 	}
		$sentenceList=$sentenceModel->getSentenceList($_GET['unitId'],$_GET['sectionId'],min($data));
		foreach ($sentenceList as $key => $value) {
			$sentenceModel->updateOrderId($value['sentenceId'],min($data)+$key);
		}
	}
	else if($action=="updateOrderId"){
		$index=0;
		$data=json_decode(file_get_contents( 'php://input' ));
		foreach ($data as $key => $value) {
			if($sentenceModel->updateOrderId($value->sentenceId,$value->orderId)){
				$index++;
			}
		}
		if($index==count($data,0)){
			$res['resCode']="S456";
			$res['resMsg']="succeed to update the orderId";
		}
		else{
			$res['resCode']="E234";
			$res['resMsg']="failed to update the orderId";
		}
		ob_clean();
		echo json_encode($res);
	}
	else if($action =="getSentenceListByUnitId"){
		// $sentenceList = $sentenceModel->getSentenceList($_GET['unitId'],$_GET['sectionId']);
		$sectionList = $sectionModel->getSectionList($_GET['unitId']);
		$res['unitId']=intval($_GET['unitId']);
		if(!empty($sectionList)){
			$json = array();
			foreach ($sectionList as $key=>$value) {
				$jo = array();
				$jo['text'] = $value['text'];
				$jo['id'] = $value['id'];
				$sentenceList = $sentenceModel->getSentenceList($_GET['unitId'],$value['id']);
				if(!empty($sentenceList))
				{
					$resData = "";
					$jo['sentenceNum'] = count($sentenceList);
					$resData  .="[";
					foreach ($sentenceList as $key1 => $value1) { 
						$resData  .= "{\"sentenceId\":".$value1['sentenceId'].",";
						$resData  .= "\"unitId\":".$value1['unitId'].",";
						$resData  .= "\"sectionId\":".$value1['sectionId'].",";
						$resData  .= "\"english\":"."\"".addslashes($value1['english'])."\"".",";
						$resData  .= "\"chinese\":"."\"".addslashes($value1['chinese'])."\"".",";
						$resData  .= "\"updateTime\":"."\"".$value1['updateTime']."\"".",";
						$resData  .= "\"voiceUrl\":"."\"".$value1['voiceUrl']."\""."},";
					}
					$resData = substr($resData ,0,strlen($resData)-1);
					$resData .="]";
					$jo['sentenceList']=$resData;
				}
				getChildrenNode($jo,$value['id']);
				$json[$key] = $jo;
			}
			$res['sectionList']=$json;
			$res['resCode'] = "S456";
			$res['resMsg'] = "succeed to get the section";
		}
		else{
			$res['resCode'] = "E234";
			$res['resMsg'] = "failed to get the section";

		}
		$resStr = str_replace("\\\"", "\"", json_encode($res));
		$resStr = str_replace("\\\\\"", "\\\"", $resStr);
		$resStr = str_replace("\\\\\\\\\\\\'", "'", $resStr);
		$resStr = str_replace("\\\\'", "'", $resStr);
		$resStr = str_replace("\"[", "[", $resStr);
		$resStr = str_replace("]\"", "]", $resStr);
		ob_clean();
		echo ($resStr);
	}
	else if($action == "getSentenceList"){
		if(isset($_GET['sentenceId'])){
			$sentenceList = $sentenceModel->getSentenceInfoById($_GET['sentenceId']);
		}
		else{
			$sentenceList = $sentenceModel->getSentenceList($_GET['unitId'],$_GET['sectionId']);
			$res['unitId'] = intval($_GET['unitId']);
			$res['sectionId'] = intval($_GET['sectionId']);
		}
		if(!empty($sentenceList)){
		    $resData = "";
	       	$res['sentenceNum'] = count($sentenceList);
	        $resData  .="[";
	        foreach ($sentenceList as $key => $value) { 
	          $resData  .= "{\"sentenceId\":".$value['sentenceId'].",";
	          $resData  .= "\"unitId\":".$value['unitId'].",";
			  $resData  .= "\"sectionId\":".$value['sectionId'].",";
			  $resData  .= "\"english\":"."\"".addslashes($value['english'])."\"".",";
			  $resData  .= "\"chinese\":"."\"".addslashes($value['chinese'])."\"".",";
			  $resData  .= "\"updateTime\":"."\"".$value['updateTime']."\"".",";
			  $resData  .= "\"voiceUrl\":"."\"".$value['voiceUrl']."\""."},";
		    }
		    $resData = substr($resData ,0,strlen($resData)-1);
		    $resData .="]";
			$res['sentenceList'] = $resData;
			$res['resCode'] = "S456";
	    	$res['resMsg'] = "succeed to get the sentence list";
		    $resStr = str_replace("\\\"", "\"", json_encode($res));
		    $resStr = str_replace("\\\\\"", "\\\"", $resStr);
		    $resStr = str_replace("\\\\\\\\\\\\'", "'", $resStr);
		    $resStr = str_replace("\\\\'", "'", $resStr);
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

	else if($action == "getUnitMenu"){
		$categoryModel = new ListenCategory();
		$bookModel = new ListenBook();
		$unitModel = new ListenUnit();
		$categoryList = $categoryModel->getCategoryList();
		if(!empty($categoryModel)){
			$unitMenu = "[";
			$url = "";
			$pid = 0;
			foreach ($categoryList as $key => $value) {
				$categoryId =  $value['categoryId'];
				$unitMenu.= "{\"id\":".$value['categoryId'].",";
			  	$unitMenu.= "\"pid\":".$pid.",";
			  	$unitMenu.= "\"grade\":0,";
			  	$unitMenu.= "\"text\":"."\"".$value['categoryName']."\"".",";
			  	$unitMenu.= "\"url\":"."\"".$url."\""."},";
				$bookList = $bookModel->getBookList($categoryId);
				if(!empty($bookList)){
					foreach ($bookList as $key => $value) {
						$bookId = $value['bookId'];
						$unitMenu.= "{\"id\":".$value['bookId'].",";
						$unitMenu.= "\"pid\":".$categoryId.",";
						$unitMenu.= "\"grade\":1,";
						$unitMenu.= "\"text\":"."\"".$value['bookName']."\"".",";
						$unitMenu.= "\"url\":"."\"".$url."\""."},";
						$unitList = $unitModel->getunitList($bookId);
						if(!empty($unitList)){
							foreach ($unitList as $key => $value) {
								$unitMenu .= "{\"id\":".$value['unitId'].",";
								$unitMenu .= "\"pid\":".$bookId.",";
								$unitMenu.= "\"grade\":2,";
								$unitMenu .= "\"text\":"."\"".$value['unitName']."\"".",";
								$unitMenu .= "\"url\":"."\"".$url."\""."},";
							}
						}
					}
				}
			}
			$unitMenu = substr($unitMenu ,0,-1);
		    $unitMenu.= "]";
		    echo $unitMenu;
		}
		else{
			ob_clean();
			echo json_encode($res);
		}
	}
	function getChildrenNode(&$jo,$pid)
	{
		global $sectionModel,$sentenceModel;
		$childrenList = $sectionModel->getSectionByPid($_GET['unitId'],$pid);
		$ja1 = array();
		if(!empty($childrenList))
		{
			foreach ($childrenList as $key=>$value) {
				$jo1['text'] = $value['text'];
				$jo1['id'] = $value['id'];
				$sentenceList = $sentenceModel->getSentenceList($_GET['unitId'],$value['id']);
				if(!empty($sentenceList)){
					$resData = "";
					$jo1['sentenceNum'] = count($sentenceList);
					$resData  .="[";
					foreach ($sentenceList as $key1 => $value1) { 
						$resData  .= "{\"sentenceId\":".$value1['sentenceId'].",";
						$resData  .= "\"unitId\":".$value1['unitId'].",";
						$resData  .= "\"sectionId\":".$value1['sectionId'].",";
						$resData  .= "\"english\":"."\"".addslashes($value1['english'])."\"".",";
						$resData  .= "\"chinese\":"."\"".addslashes($value1['chinese'])."\"".",";
						$resData  .= "\"updateTime\":"."\"".$value1['updateTime']."\"".",";
						$resData  .= "\"voiceUrl\":"."\"".$value1['voiceUrl']."\""."},";
					}
					$resData = substr($resData ,0,strlen($resData)-1);
					$resData .="]";
					$jo1['sentenceList']=$resData;
				}
				else
					unset($jo1['sentenceList']);
				getChildrenNode($jo1,$value['id']);
				$ja1[$key] = $jo1;
			}

			$jo["children"]=$ja1;
		}
		else
			unset($jo['children']);
	}
 ?>
