<?php
	header("Content-Type:text/html;charset=utf-8");
	require_once("../../framework/common.inc.php");
	$sectionModel = new ListenSection();
	$action = $_GET['action'];
	if($action == "insertSection"){
		echo $_POST['unitId'];
		$data['unitId'] = $_POST['unitId'];
		$data['text'] = $_POST['text'];
	    $data['remark'] = $_POST['remark'];
	    if($_POST['pid'] != "0")
	        $data['pid'] = $_POST['pid'];
	    $id = $sectionModel->insertSection($data);
	    if($id){
	    	$res['id'] = $id;
	    	$res['resCode'] = "S456";
	    	$res['resMsg'] = "succeed to insert the section";
	    }
	    else{
	    	$res['resCode'] = "E234";
	    	$res['resMsg'] = "failed to insert the section";
	    }
		ob_clean();
		echo json_encode($res);
	}
	else if($action == "updateSection"){
		$data['id'] = $_POST['id'];
		$data['text'] = $_POST['text'];
	    $data['remark'] = $_POST['remark'];
	    if($sectionModel->updateSection($data)){
	    	$res['resCode'] = "S456";
	    	$res['resMsg'] = "succeed to update the section";
	    }
		else{
	    	$res['resCode'] = "E234";
	    	$res['resMsg'] = "failed to update the section";
	    }
		ob_clean();
		echo json_encode($res);
	}
	else if($action == "deleteSection"){
		if($sectionModel->deleteSection($_POST['id'])){
	    	$res['resCode'] = "S456";
	    	$res['resMsg'] = "succeed to delete the section";
	    }
		else{
	    	$res['resCode'] = "E234";
	    	$res['resMsg'] = "failed to delete the section";
	    }
		ob_clean();
		echo json_encode($res);
	}
	else if($action == "getSectionList"){
		$sectionList = $sectionModel->getSectionList($_GET['unitId']);
		$json = array();
		if(!empty($sectionList)){
			
			foreach ($sectionList as $key=>$value) {
				$jo = array();
				$jo['text'] = $value['text'];
				$jo['id'] = $value['id'];
				getChildrenNode($jo,$value['id']);
				$json[$key] = $jo;
			}
		}
		ob_clean();
		echo (json_encode($json));
	}
	else if($action == "getSectionListByUnitId"){
		$sectionList = $sectionModel->getSectionList($_GET['unitId']);
		$res['unitId']=intval($_GET['unitId']);
		if(!empty($sectionList)){
			$json = array();
			foreach ($sectionList as $key=>$value) {
				$jo = array();
				$jo['text'] = $value['text'];
				$jo['id'] = $value['id'];
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
		ob_clean();
		echo (json_encode($res));
	}
	function getChildrenNode(&$jo,$pid)
	{
		global $sectionModel;
		$childrenList = $sectionModel->getSectionByPid($_GET['unitId'],$pid);
		$ja1 = array();
		if(!empty($childrenList)){

		foreach ($childrenList as $key=>$value) {
				$jo1['text'] = $value['text'];
				$jo1['id'] = $value['id'];
				getChildrenNode($jo1,$value['id']);
				$ja1[$key] = $jo1;
		}
			$jo["children"]=$ja1;
		}
		else
			unset($jo["children"]);
	}
 ?>
