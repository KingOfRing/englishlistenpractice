<?php
	header("Content-Type:text/html;charset=utf-8");
	require_once("../framework/common.inc.php");
	$action = $_GET['action'];
	$status = 'student';
	$userModel = new User();
	if($action == 'register'){
		if($userModel->hasTheUser($_POST['account'])){
			$res['resCode'] = "E234";
		 	$res['resMsg'] = "The account is already registered";
		}
		else{
			if($userModel->insertUser()){
			 	$res['resCode'] = "S456";
			 	$res['resMsg'] = "succeed to register";
		    }
		}
		ob_clean();
		echo json_encode($res);
	}
	else if($action == 'login'){
		if ($_SERVER['REQUEST_METHOD']=='POST'){
			$data['account'] = $_POST['account'];
			$data['password'] = $_POST['password'];
			if ($userModel->validateUser($data,$status)) {
				$userInfo=$userModel->getUserInfoByAccount($data['account']);
				//var_dump($userInfo);
				$res['userInfo']['account']=$userInfo[0]['account'];
				$res['userInfo']['gender']=$userInfo[0]['gender'];
				$res['userInfo']['email']=$userInfo[0]['email'];
				$res['resCode'] = 'S456';
				$res['resMsg'] = 'login success';

			}
			else{
				$res['resCode'] = 'E234';
				$res['resMsg'] = 'account or password is error';
			}
			ob_clean();  //清空echo输出
			echo  json_encode($res);
		}
		else{
			echo "不是POST请求";
		}
	}
	else if($action == "deleteUser"){
        if($userModel->deleteUser()){
	    	$res['resCode'] = 'S456';
	    	$res['resMsg'] = "succeed to delete the user";
	    }
		ob_clean();
		echo json_encode($res);
	}
	else if($action == "getUserList"){
		$userList = $userModel->getUserList();
		if(!empty($userList)){
			$res['resCode'] = 'S456';
	        $res['resMsg'] = "succeed to get the user list";
		    $resData = "";
	        $resData  .="[";
	        foreach ($userList as $key => $value) { 
	          $resData  .= "{\"id\":"."\"".$value['id']."\"".",";
	          $resData  .= "\"account\":"."\"".$value['account']."\"".",";
			  $resData  .= "\"gender\":"."\"".$value['gender']."\"".",";
			  $resData  .= "\"email\":"."\"".$value['email']."\"".",";
			  $resData  .= "\"updateTime\":"."\"".$value['updateTime']."\""."},";
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
			$res['resCode'] = 'E234';
	        $res['resMsg'] = "failed to get the user list";
			ob_clean();
			echo json_encode($res);
		}
	}
 ?>


