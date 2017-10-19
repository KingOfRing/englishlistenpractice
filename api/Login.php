<?php 
	header("Content-Type:text/html;charset=utf8");
	require_once("../framework/common.inc.php");
	session_start();
	$action = $_GET["action"];
	$status='teacher';
	if($action == "login"){
		$userModel = new User();
		if(isset($_POST['login'])){
			$data['account'] = $_POST['account'];
			$data['password'] = $_POST['password'];
			if(($data['account'] =="") || ($data['password']=="")){
				echo '<script type="text/javascript">alert("用户名或者密码不能为空");history.back()</script>';
				exit;
			}
			if($userModel->validateUser($data,$status)){
				$_SESSION['account'] = $data['account'];
				$_SESSION['isLogin'] = "yes";
				header("location:../html/EnglishTrain.html");
			}
			else{
				echo '<script type="text/javascript">alert("用户名或者密码错误");history.back()</script>';
				exit;
			}
		}
	}
	else if($action == "getSession"){
		if(isset($_SESSION['isLogin'])){
			echo $_SESSION['isLogin'];
		}
		else{
			echo "no";
		}
	}
	else if($action == "delSession"){
		$_SESSION = array();
		session_destroy();
		if(!isset($_SESSION['isLogin'])){
			echo 'logout';
		}
	}
	else if($action == "getUserName"){
		if(isset($_SESSION['account'])){
			echo $_SESSION['account'];
		}
		else{
			echo "";
		}
	}
 ?>