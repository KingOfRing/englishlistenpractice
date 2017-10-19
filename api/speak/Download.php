<?php
	header("Content-Type:text/html;charset=utf-8");
	require_once('../../framework/common.inc.php');
	$action = $_GET['action'];
	if($action =="getSentenceListByCategoryId") {
		$bookModel  = new SpeakBook();
		$articleModel = new SpeakArticle();
		$sentenceModel = new SpeakSentence();
		$bookList = $bookModel->getBookList($_GET["categoryId"]);
		if(!empty($bookList)){
			$jsonStr = '{';
			$jsonStr .= '"categoryId":'.$_GET['categoryId'].',';
			$jsonStr .= '"bookNum":'.count($bookList).',';
			$jsonStr .= '"bookList":[';
			foreach ($bookList as $key => $value) {
				$jsonStr .='{';
				$jsonStr .= '"bookId":'.$value['id'].',';
				$jsonStr .= '"bookName":'.'"'.$value['bookName'].'"'.',';
				$jsonStr .= '"authorName":'.'"'.$value['authorName'].'"'.',';
				$jsonStr .= '"description":'.'"'.$value['description'].'"'.',';
				$jsonStr .= '"imageUrl":'.'"'.addcslashes($value['imageUrl'],'\\').'"'.',';
				$bookId = $value['id'];
				$aritcleList = $articleModel->getArticleList($bookId);
				$jsonStr .= '"articleNum":'.count($aritcleList).",";
				if(!empty($aritcleList)){
					$jsonStr .= '"articleList":';
					$jsonStr .= '[';
					foreach ($aritcleList as $key => $value) {
						$jsonStr .= '{';
						$jsonStr .= '"articleId":'.$value['id'].',';
						$jsonStr .= '"articleTitle":'.'"'.$value['articleTitle'].'"'.',';
						$jsonStr .= '"authorName":'.'"'.$value['authorName'].'"'.",";
						$jsonStr .= '"description":'.'"'.$value['description'].'"'.",";
						$articleId = $value['id'];
						$sentenceList = $sentenceModel->getSentenceList($articleId);
						$jsonStr .= '"sentenceNum":'.count($sentenceList).',';
						if(!empty($sentenceList)){
							$jsonStr .= '"sentenceList":';
							$jsonStr .= '[';
							foreach ($sentenceList as $key => $value) {
								$jsonStr .= '{';
								$jsonStr .= '"sentenceId":'.$value['id'].',';
								$jsonStr .= '"english":'.'"'.$value['english'].'"'.',';
								$jsonStr .= '"chinese":'.'"'.$value['chinese'].'"'.',';
								$jsonStr .= '"voiceUrl":'.'"'.addcslashes($value['voiceUrl'],'\\').'"'.'},';
							}
							$jsonStr = substr($jsonStr, 0,-1);
							$jsonStr .= ']';
						}
						else{
							$jsonStr = substr($jsonStr, 0,-1);
						}
						$jsonStr .= '},';
					}
					$jsonStr = substr($jsonStr, 0,-1);
					$jsonStr .= ']';
				}
				else{
					$jsonStr = substr($jsonStr, 0,-1);
				}
				$jsonStr .='},';
			}
			$jsonStr = substr($jsonStr,0,-1);
			$jsonStr .= '],';
			$jsonStr .= '"resCode":'.'"S456"'.',';
			$jsonStr .= '"resMsg":'.'"succeed to getSentenceList"';
			$jsonStr .= '}';
		}
		else{
			$jsonStr = '{';
			$jsonStr .= '"resCode":'.'"E234"'.',';
			$jsonStr .= '"resMsg":'.'"failed to getSentenceList"'.',';
			$jsonStr .= '"bookNum":0';
			$jsonStr .= '}';
		}
		$jsonStr = str_replace("\\\"","\"", $jsonStr);
		ob_clean();
		echo $jsonStr;
	}
 ?>