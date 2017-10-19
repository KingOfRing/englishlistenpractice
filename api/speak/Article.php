<?php
header("Content-Type:text/html;charset=utf-8");
require_once("../../framework/common.inc.php");
$action = $_GET['action'];
$articleModel =  new SpeakArticle();
if($action == "insertArticle"){
	$data['bookId'] = $_GET['bookId'];
 	$data['articleTitle'] = $_POST['articleTitle'];
 	$data['description'] = $_POST['description'];
 	$data['authorName'] = $_POST['authorName'];
    if($articleModel->insertArticle($data)){
    	$res['resCode'] = "S456";
		$res['resMsg'] = "succeed to insert the articel";
    }
    else{
    	$res['resCode'] = "E234";
    	$res['resMsg'] = "failed to insert the article";
	}
	ob_clean();
	echo json_encode($res);
}
else if($action == "updateArticle"){
	$data['articleId'] = $_GET['articleId'];
 	$data['articleTitle'] = $_POST['articleTitle'];
 	$data['description'] = $_POST['description'];
 	$data['authorName'] = $_POST['authorName'];
    if($articleModel->updateArticle($data)){
    	$res['resCode'] = "S456";
		$res['resMsg'] = "succeed to update the article";
    }
    else{
    	$res['resCode'] = "E234";
    	$res['resMsg'] = "failed to update the article";
	}
	ob_clean();
	echo json_encode($res);
}
else if($action == "deleteArticle"){
    if($articleModel->deleteArticle($_POST['id'])){
    	$res['resCode'] = "S456";
    	$res['resMsg'] = "succeed to delete the article";
    }
	else{
    	$res['resCode'] = "E234";
    	$res['resMsg'] = "failed to delete the article";
    }
	ob_clean();
	echo json_encode($res);
}
else if($action == "getBookMenu"){
	$categoryModel = new SpeakCategory();
	$bookModel = new SpeakBook();
	$categoryList = $categoryModel->getCategoryList();
	if(!empty($categoryModel)){
		$bookMenu = "[";
		$url = "";
		$pid = 0;
		foreach ($categoryList as $key => $value) {
			$categoryId =  $value['id'];
			$bookMenu   .= "{\"id\":".$value['id'].",";
		  	$bookMenu   .= "\"pid\":".$pid.",";
		  	$bookMenu   .= "\"text\":"."\"".$value['categoryName']."\"".",";
		  	$bookMenu   .= "\"url\":"."\"".$url."\""."},";
			$bookList = $bookModel->getBookList($categoryId);
			if(!empty($bookList)){
				foreach ($bookList as $key => $value) {
					$bookMenu   .= "{\"id\":".$value['id'].",";
					$bookMenu   .= "\"pid\":".$categoryId.",";
					$bookMenu   .= "\"text\":"."\"".$value['bookName']."\"".",";
					$bookMenu   .= "\"url\":"."\"".$url."\""."},";
				}
			}
		}
		$bookMenu = substr($bookMenu ,0,-1);
	    $bookMenu.= "]";
	    echo $bookMenu;
	}
	else{
		ob_clean();
		echo json_encode($res);
	}
}
else if ($action == "getArticleList") {
	if(isset($_GET['bookId'])){
		$articleList = $articleModel->getArticleList($_GET['bookId']);
		$res['bookId'] = intval($_GET['bookId']);
	}
	else if(isset($_GET['articleId'])){
		$articleList = $articleModel->getArticleInfoById($_GET['articleId']);
	}
	else{
		//do nothing
	}
	if(!empty($articleList)){
	    $resData = "";
	    $res['articleNum'] = count($articleList);
        $resData  .="[";
        foreach ($articleList as $key => $value) { 
          $resData  .= "{\"id\":".$value['id'].",";
		  $resData  .= "\"bookId\":".$value['bookId'].",";
		  $resData  .= "\"articleTitle\":"."\"".$value['articleTitle']."\"".",";
		  $resData  .= "\"authorName\":"."\"".$value['authorName']."\"".",";
		  $resData  .= "\"updateTime\":"."\"".$value['updateTime']."\"".",";
		  $resData  .= "\"description\":"."\"".nl2br2($value['description'])."\""."},";
	    }
	    $resData = substr($resData ,0,strlen($resData)-1);
	    $resData .="]";
	    $res['articleList'] = $resData;
	    $res['resCode'] = "S456";
    	$res['resMsg'] = "succeed to get the article list";
	    $resStr = str_replace("\\\"", "\"", json_encode($res));
	    $resStr = str_replace("\"[", "[", $resStr);
	    $resStr = str_replace("]\"", "]", $resStr);
	    ob_clean();
	    echo $resStr;
	}
	else{
		$res['resCode'] = "E234";
    	$res['resMsg'] = "failed to get the article list";
		ob_clean();
		echo json_encode($res);
	}
}
else if($action == "getArticleListByCategoryId"){
	if(isset($_GET['categoryId'])){
		$categoryId=$_GET['categoryId'];
		$bookModel=new SpeakBook();
		$bookList=$bookModel->getBookList($categoryId);
	}
	if(!empty($bookList)){
		$res["categoryId"]=intval($_GET['categoryId']);	
		$res["bookNum"]=count($bookList,0);
		$res['bookList']="[";
		foreach ($bookList as $key => $value) {
			$articleList=$articleModel->getArticleList($value["id"]);
			$res['bookList'].="{\"bookId\":".$value['id'].",\"bookName\":"."\"".$value['bookName']."\"".",";
			$res['bookList'].="\"authorName\":"."\"".$value['authorName']."\"".",\"description\":"."\"".nl2br2($value['description'])."\"".",";
			$res['bookList'].="\"imageUrl\":"."\"".$value['imageUrl']."\"".",\"articleNum\":".count($articleList,0).",\"articleList\"".":[";
			if(!empty($articleList)){
				foreach ($articleList as $key1 => $value1) {
					$res['bookList'].="{\"articleId\":".$value1['id'].",\"articleTitle\":"."\"".$value1['articleTitle']."\"".",";
					$res['bookList'].="\"authorName\":"."\"".$value1['authorName']."\"".",";
					$res['bookList'].="\"description\":"."\"".nl2br2($value1['description'])."\""."},";
				}
			}
			$res['bookList'] = substr($res['bookList'] ,0,(!empty($articleList)?strlen($res['bookList'])-1:strlen($res['bookList'])))."]},";
		}
		$res['bookList'] = substr($res['bookList'] ,0,(!empty($bookList)?strlen($res['bookList'])-1:strlen($res['bookList'])))."]";
		$res['resCode'] = "S456";
		$res['resMsg'] = "succeed to getArticleList";

	}
	else{
		$res['resCode'] = "E234";
		$res['resMsg'] = "failed to getArticleList";
	}
	$resStr = str_replace("\\\"", "\"", json_encode($res));
	$resStr = str_replace("\"[", "[", $resStr);
	$resStr = str_replace("]\"", "]", $resStr);
	ob_clean();
	echo $resStr;
}
?>