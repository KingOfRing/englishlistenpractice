<?php
header("Content-Type:text/html;charset=utf-8");
require_once("../../framework/common.inc.php");
$action = $_GET['action'];
$unitModel =  new ListenUnit();
if($action == "insertUnit"){
	$data['bookId'] = $_GET['bookId'];
 	$data['unitNum'] = $_POST['unitNum'];
 	$data['unitName'] = $_POST['unitName'];
 	$data['unitDetail'] = $_POST['unitDetail'];
    if($unitModel->insertUnit($data)){
    	$res['resCode'] = "S456";
		$res['resMsg'] = "succeed to insert the unit";
    }
    else{
    	$res['resCode'] = "E234";
    	$res['resMsg'] = "failed to insert the unit";
	}
	ob_clean();
	echo json_encode($res);
}
else if($action == "updateUnit"){
	$data['unitId'] = $_GET['unitId'];
 	$data['unitNum'] = $_POST['unitNum'];
 	$data['unitName'] = $_POST['unitName'];
 	$data['unitDetail'] = $_POST['unitDetail'];
    if($unitModel->updateUnit($data)){
    	$res['resCode'] = "S456";
		$res['resMsg'] = "succeed to update the unit";
    }
    else{
    	$res['resCode'] = "E234";
    	$res['resMsg'] = "failed to update the unit";
	}
	ob_clean();
	echo json_encode($res);
}
else if($action == "deleteUnit"){
    if($unitModel->deleteUnit($_POST['id'])){
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
	$categoryModel = new ListenCategory();
	$bookModel = new ListenBook();
	$categoryList = $categoryModel->getCategoryList();
	if(!empty($categoryModel)){
		$bookMenu = "[";
		$url = "";
		$pid = 0;
		foreach ($categoryList as $key => $value) {
			$categoryId =  $value['categoryId'];
			$bookMenu   .= "{\"id\":".$value['categoryId'].",";
		  	$bookMenu   .= "\"pid\":".$pid.",";
		  	$bookMenu   .= "\"text\":"."\"".$value['categoryName']."\"".",";
		  	$bookMenu   .= "\"url\":"."\"".$url."\""."},";
			$bookList = $bookModel->getBookList($categoryId);
			if(!empty($bookList)){
				foreach ($bookList as $key => $value) {
					$bookMenu   .= "{\"id\":".$value['bookId'].",";
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
else if ($action == "getUnitList") {
	if(isset($_GET['bookId'])){
		$unitList = $unitModel->getUnitList($_GET['bookId']);
		$res['bookId'] = intval($_GET['bookId']);
	}
	else if(isset($_GET['unitId'])){
		$unitList = $unitModel->getUnitInfoById($_GET['unitId']);
	}
	else{
		//do nothing
	}
	if(!empty($unitList)){
	    $resData = "";
	    $res['articleNum'] = count($unitList);
        $resData  .="[";
        foreach ($unitList as $key => $value) { 
          $resData  .= "{\"unitId\":".$value['unitId'].",";
		  $resData  .= "\"bookId\":".$value['bookId'].",";
		  $resData  .= "\"unitNum\":"."\"".$value['unitNum']."\"".",";
		  $resData  .= "\"unitName\":"."\"".$value['unitName']."\"".",";
		  $resData  .= "\"unitDetail\":"."\"".nl2br2($value['unitDetail'])."\"".",";
		  $resData  .= "\"updateTime\":"."\"".$value['updateTime']."\""."},";
	    }
	    $resData = substr($resData ,0,strlen($resData)-1);
	    $resData .="]";
	    $res['unitList'] = $resData;
	    $res['resCode'] = "S456";
    	$res['resMsg'] = "succeed to get the unit list";
	    $resStr = str_replace("\\\"", "\"", json_encode($res));
	    $resStr = str_replace("\"[", "[", $resStr);
	    $resStr = str_replace("]\"", "]", $resStr);
	    ob_clean();
	    echo $resStr;
	}
	else{
		$res['resCode'] = "E234";
    	$res['resMsg'] = "failed to get the unit list";
		ob_clean();
		echo json_encode($res);
	}
}
?>