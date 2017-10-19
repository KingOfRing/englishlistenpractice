<?php  
	header("Content-Type:text/html;charset=utf-8");
	require_once("../../framework/common.inc.php");
	$categoryModel = new ListenCategory();
	$action = $_GET['action'];

	if($action == "insertCategory"){
		if($categoryModel->insertCategory()){
			 $res['resCode'] = "S456";
			 $res['resMsg'] = "succeed to insert category";
		}
		else{
			 $res['resCode'] = "E234";
			 $res['resMsg'] = "failed to insert category";
		}
		ob_clean();
		echo json_encode($res);

	}
	else if($action == "updateCategory"){
		if($categoryModel->updateCategory()){
			 $res['resCode'] = "S456";
			 $res['resMsg'] = "succeed to update category";
		}
		else{
			 $res['resCode'] = "E234";
			 $res['resMsg'] = "failed to update category";
		}
		ob_clean();
		echo json_encode($res);
	}
	else if($action == "deleteCategory"){
		if($categoryModel->deleteCategory()){
			 $res['resCode'] = "S456";
			 $res['resMsg'] = "succeed to delete category";
		}
		else{
			 $res['resCode'] = "E234";
			 $res['resMsg'] = "failed to delete category";
		}
		ob_clean();
		echo json_encode($res);
	}
	else if($action == "getCategoryList"){
		if(isset($_GET['categoryId'])){
			$categoryList = $categoryModel->getCategoryInfoById($_GET['categoryId']);
		}
		else{
			$categoryList = $categoryModel->getCategoryList();
		}
		
		if(!empty($categoryList)){
			$res['resCode'] = 'S456';
	        $res['resMsg'] = "succeed to get the category list";
	        $res['categoryNum'] = count($categoryList);
		    $resData = "";
	        $resData  .="[";
	        foreach ($categoryList as $key => $value) { 
	          $resData  .= "{\"categoryId\":"."\"".$value['categoryId']."\"".",";
	          $resData  .= "\"categoryName\":"."\"".$value['categoryName']."\"".",";
			  $resData  .= "\"description\":"."\"".$value['description']."\"".",";
			  $resData  .= "\"updateTime\":"."\"".$value['updateTime']."\""."},";
		    }
		    $resData = substr($resData ,0,strlen($resData)-1);
		    $resData .="]";
  		    $res['categoryList'] = $resData;
		    $resStr = str_replace("\\\"", "\"", json_encode($res));
		    $resStr = str_replace("\"[", "[", $resStr);
		    $resStr = str_replace("]\"", "]", $resStr);
		    ob_clean();
		    echo $resStr;
		}
		else{
			$res['resCode'] = 'E234';
	        $res['resMsg'] = "failed to get the category list";
	        $res['categoryNum'] = 0;
			ob_clean();
			echo json_encode($res);
		}
	}
?>