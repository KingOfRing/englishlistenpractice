<?php
	function charToUtf8($data){
	  if( !empty($data) ){    
	    $fileType = mb_detect_encoding($data , array('UTF-8','GBK','LATIN1','BIG5')) ;  
	    if( $fileType != 'UTF-8'){   
	      $data = mb_convert_encoding($data ,'utf-8' , $fileType);   
	    }   
	  }   
	  return $data;    
	} 
	function fileCharset($fileName){
		if(PHP_OS == "WINNT"){
			$fileName = iconv("UTF-8", "GBK", $fileName);
		}
		else{
		      //	$fileName = str_replace("\\",DIRECTORY_SEPARATOR,$fileName);
		}	
		return $fileName;
	}
	function nl2br2($string) { 
		$string = str_replace(array("\r\n", "\r", "\n"), "<br />", $string); 
		return $string; 
	} 
 ?>
