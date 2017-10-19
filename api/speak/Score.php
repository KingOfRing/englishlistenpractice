<?php
	header("Content-Type:text/html;charset=utf-8");
	require_once("SqlUtil.class.php");
	$sqlUtil = new SqlUtil();
	$action = $_GET['action'];
	if($action == "uploadScore"){  //成绩上传
		uploadScore();
	}
	else if($action == "queryScore"){
		queryScore();
	}
	else if($action =="queryAllScore"){
		queryAllScore();
	}
	else{
		//handle other action
	}

	function uploadScore()
	{
		global $sqlUtil;
		$account = $_POST['account'];
		$userId = $sqlUtil->getUserIdByAccount($account);
		$res = array('resCode' =>'E234','resMsg'=>'failed to uploadScore');
		if($userId !=null){
			$data['userId'] = $userId;
			$data['bookId'] = intval($_POST['bookId']);
			$data['articleId'] = intval($_POST['articleId']);
			$data['score'] = intval($_POST['score']);
			if($sqlUtil->uploadSocre($data)){
				$res['resCode'] = 'S456';
				$res['resMsg'] = 'succeed to upload score';
			}
		}
		ob_clean();
		echo json_encode($res);
	}
	function queryScore(){
		global $sqlUtil;
		$account = $_POST['account'];
		//$account = "201407636";
	    $userId = $sqlUtil->getUserIdByAccount($account);
	    if($userId != null){
	    	$scoreList = $sqlUtil->getScoreListByAccount($userId);
	    	if(!empty($scoreList)){
	    		var_dump($scoreList);
	    		$jsonStr = '{';
	    		$jsonStr .= '"account":'.'"'.$account.'"'.',';
	    		$jsonStr .= '"scoreList":'.'[';
	    		$jsonStr .= '{'.'"bookId":'.$scoreList[0]['bookId'].',';
	    		$bookName = $sqlUtil->getBookNameById($scoreList[0]['bookId']);
	    		$jsonStr .= '"bookName":'.'"'.$bookName.'"'.',';
	    		$jsonStr .='"aricleList":'.'[';
	    		$bookId = $scoreList[0]['bookId'];
	    		foreach($scoreList as $key => $value) {
	    			if($value['bookId'] == $bookId){
	    				$jsonStr .= '{';
	    				$jsonStr .= '"articleId":'.$value['articleId'].',';
	    				$articleTitle = $sqlUtil->getArticleTitleById($value['articleId']);
	    				$jsonStr .= '"articleTitle":'.'"'.$articleTitle.'"'.',';
	    				$jsonStr .= '"score":'.$value['score'];
	    				$jsonStr .= '},';
	    			}
	    			else{
	    				$bookId = $value['bookId'];
	    				$jsonStr = substr($jsonStr, 0,-1);
	    				$jsonStr .= ']';
	    				$jsonStr .= '},';
	    				$jsonStr .= '{'.'"bookId":'.$value['bookId'].',';
	    			    $bookName = $sqlUtil->getBookNameById($value['bookId']);
	    		        $jsonStr .= '"bookName":'.'"'.$bookName.'"'.',';
	    				$jsonStr .='"aricleList":'.'[';
	    				$jsonStr .= '{';
	    				$jsonStr .= '"articleId":'.$value['articleId'].',';
	    				$articleTitle = $sqlUtil->getArticleTitleById($value['articleId']);
	    				$jsonStr .= '"articleTitle":'.'"'.$articleTitle.'"'.',';
	    				$jsonStr .= '"score":'.$value['score'];
	    				$jsonStr .= '},';
	    			}
	    		}
	    		$jsonStr = substr($jsonStr, 0,-1);
	    		$jsonStr .= ']';
	    		$jsonStr .= '}';
	    		$jsonStr .= '],';
	    		$jsonStr .= '"resCode":'.'"S456"'.',';
	    		$jsonStr .= '"resMsg":'.'"succeed to query socre"';
	    		$jsonStr .= '}';
	    	}
	    	else{  //没有查到该用户的成绩
	    		$jsonStr = '{';
	    		$jsonStr .= '"account":'.'"'.$account.'"'.',';
	    		$jsonStr .= '"resCode":'.'"E235"'.',';
	    		$jsonStr .= '"resMsg":'.'"user does not exist"';
	    		$jsonStr .= '}';
	    	}
	    }
	    else{  //该用户不存在
	    	$jsonStr = '{';
	    	$jsonStr .= '"account":'.'"'.$account.'"'.',';
	    	$jsonStr .= '"resCode":'.'"E234"'.',';
	    	$jsonStr .= '"resMsg":'.'"failed to query socre"';
	    	$jsonStr .= '}';
	    }
	    ob_clean();
	    echo $jsonStr;
	}
	function queryAllScore(){
		global $sqlUtil;
		$allScoreList = $sqlUtil->getAllSocreList();
		if(!empty($allScoreList)){
		    $resData = "";
	        $res['resCode'] = 'succeed';
	        $res['resMsg'] = "查询成绩列表成功";
	        $resData  .="[";
	        foreach ($allScoreList as $key => $value) { 
	          $resData  .= "{\"id\":"."\"".$value['id']."\"".",";
	          $account = $sqlUtil->getAccountByUserId($value['userId']);
			  $resData  .= "\"account\":"."\"".$account."\"".",";
			  $bookName = $sqlUtil->getBookNameById($value['bookId']);
			  $resData  .= "\"bookName\":"."\"".$bookName."\"".",";
			  $articleTitle = $sqlUtil->getArticleTitleById($value['articleId']);
			  $resData  .= "\"articleTitle\":"."\"".$articleTitle."\"".",";
			  $resData  .= "\"score\":"."\"".$value['score']."\""."},";
		    }
		    $resData = substr($resData ,0,strlen($resData)-1);
		    $resData .="]";
  		    $res['Rows'] = $resData;
		    $resStr = str_replace("\\\"", "\"", json_encode($res));
		    $resStr = str_replace("\"[", "[", $resStr);
		    $resStr = str_replace("]\"", "]", $resStr);
		    ob_clean();
		    echo $resStr;
		}
		else{
			ob_clean();
			echo json_encode($res);
		}
	}
?>
