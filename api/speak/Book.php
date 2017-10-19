<?php
header("Content-Type:text/html;charset=utf-8");
require_once("../../framework/common.inc.php");
$action = $_GET['action'];
$bookModel =  new SpeakBook();
if($action == "insertBook"){
	$data['categoryId'] = $_GET['categoryId'];
    $data['bookName'] = $_POST['bookName'];
    $data['authorName'] = $_POST['authorName'];
    $data['bookIsbn'] = $_POST['bookIsbn'];
    $data['description'] = $_POST['description'];
    $data['image'] = $_FILES['imageFile'];
    if($bookModel->insertBook($data)){
    	$res['resCode'] = "S456";
    	$res['resMsg'] = "succeed to insert the book";
    }
    else{
    	$res['resCode'] = "E234";
    	$res['resMsg'] = "failed to insert the book";
    }
	ob_clean();
	echo json_encode($res);
}
else if($action == "updateBook"){
	$data['bookId'] = $_GET['bookId'];
    $data['bookName'] = $_POST['bookName'];
    $data['authorName'] = $_POST['authorName'];
    $data['bookIsbn'] = $_POST['bookIsbn'];
    $data['description'] = $_POST['description'];
    if(isset($_FILES['imageFile'])){
    	$data['image'] = $_FILES['imageFile'];
    }
    if($bookModel->updateBook($data)){
    	$res['resCode'] = "S456";
    	$res['resMsg'] = "succeed to update the book";
    }
	else{
    	$res['resCode'] = "E234";
    	$res['resMsg'] = "failed to update the book";
    }
	ob_clean();
	echo json_encode($res);
}
else if($action == "deleteBook"){
    if($bookModel->deleteBook($_POST['id'])){
    	$res['resCode'] = "S456";
    	$res['resMsg'] = "succeed to delete the book";
    }
	else{
    	$res['resCode'] = "E234";
    	$res['resMsg'] = "failed to delete the book";
    }
	ob_clean();
	echo json_encode($res);
}
else if($action == "getCategoryMenu"){
	$categoryModel = new SpeakCategory();
	$categoryList = $categoryModel->getCategoryList();
	if(!empty($categoryList)){
		$categoryMenu = "[";
		$pid = 0;
		$url = "";
        foreach ($categoryList as $key => $value) { 
          $categoryMenu  .= "{\"id\":".$value['id'].",";
		  $categoryMenu  .= "\"pid\":".$pid.",";
		  $categoryMenu  .= "\"text\":"."\"".$value['categoryName']."\"".",";
		  $categoryMenu  .= "\"url\":"."\"".$url."\""."},";
	    }
	    $categoryMenu = substr($categoryMenu ,0,-1);
	    $categoryMenu.= "]";
	    echo $categoryMenu;
	}
	else{
		$res['resCode'] = "E234";
    	$res['resMsg'] = "failed to get the category menu";
		ob_clean();
		echo json_encode($res);
	}
}
else if($action == "getBookList"){
	if(isset($_GET['categoryId'])){
		$bookList = $bookModel->getBookList($_GET['categoryId']);
		$res['categoryId'] = intval($_GET['categoryId']);
	}
	else if(isset($_GET['bookId'])){
		$bookList = $bookModel->getBookInfoById($_GET['bookId']);
	}
	else if(isset($_GET['option'])){
		if($_GET['option'] == 'recommend'){
			$bookList = $bookModel->getRecommendBook(15);
		}
	}
	else{
		//do nothing
	}
	if(!empty($bookList)){
	    $resData = "";
        $res['bookNum'] = count($bookList);
        $resData  .="[";
        foreach ($bookList as $key => $value) { 
          $resData  .= "{\"id\":".$value['id'].",";
		  $resData  .= "\"bookName\":"."\"".$value['bookName']."\"".",";
		  $resData  .= "\"authorName\":"."\"".$value['authorName']."\"".",";
		  $resData  .= "\"bookIsbn\":"."\"".$value['bookIsbn']."\"".",";
		  $resData  .= "\"description\":"."\"".nl2br2($value['description'])."\"".",";
		  $resData  .= "\"updateTime\":"."\"".$value['updateTime']."\"".",";
		  $resData  .= "\"imageUrl\":"."\"".$value['imageUrl']."\""."},";
	    }
	    $resData = substr($resData ,0,strlen($resData)-1);
	    $resData .="]";
		$res['bookList'] = $resData;
		$res['resCode'] = "S456";
        $res['resMsg'] = "succeed to get the book list";
	    $resStr = str_replace("\\\"", "\"", json_encode($res));
	    $resStr = str_replace("\"[", "[", $resStr);
	    $resStr = str_replace("]\"", "]", $resStr);
	    ob_clean();
	    echo $resStr;
	}
	else{
		$res['bookNum'] = 0;
		$res['resCode'] = "E234";
        $res['resMsg'] = "failed to get the book list";
		ob_clean();
		echo json_encode($res);
	}
}
?>
