<?php
/**
 * 功能：活动创建
 * @author siht
 * 时间：2016-02-10
 */
class ActivityAddTestAction extends BaseAction 
{
	//接口参数
	public $activity_image; //活动图片
	public $app_id;   //应用id
	public $req_seq; //请求流水号
	public $time_stamp; //时间戳
	public $sign;		//签名


	public function _initialize(){
		parent::_initialize();
		//$this->checkSign();

		$this->app_id = I('app_id');			//应用id
		$this->req_seq = I('req_seq');			//请求流水号
		$this->time_stamp = I('time_stamp');	//请求时间戳
		$this->time_stamp = I('time_stamp');	//请求时间戳
		$this->sign = I('sign');				//请求签名

		$this->activity_image = I('activity_image','','',$_FILES);	  //活动图片
	}
		
	public function run() {
		//$rs = $this->check(); 
		/*if($rs!==true){
			$this->returnError($rs['resp_desc']);
		}*/
		//$activity_info = array();

		//echo(print_r($_FILES,true));
		//echo(print_r(I('get.'),true));
		//echo(print_r(I('post.'),true));
		//return;


		/*$str_src = 'upper'.$this->app_id.$this->req_seq.$this->time_stamp.'upper';
		echo('[加密源串src:]'.$str_src.'</br>');
		echo('[计算签名sign]:'.md5($str_src).'</br>');
		echo('[传入签名sign:]'.$this->sign);*/
		//$sensitive_words = C('SENSITIVE_WORDS');
	
		//$src = '测试敏感词法轮功是个三级片组织';
		//$str = strtr($src, $sensitive_words);
		//echo '【和谐前】：'.$src.'<br>';
		//echo '【和谐后】：'.$str;

		//$where = "id = 13"; 
		//$rs = M('Tactivity')->where($where)->setInc('part_count',1);
		//if(!$rs)
		//{
		//	$this->returnError('活动报名人数更新失败！', '1008');
		//}


		$ap_arr=array();
		//$ap_arr['is_resp'] = '1';
		$vcard = 
		  "BEGIN:VCARD".
		  "\nVERSION:3.0".
		  "\nFN:倩格格".
		  "\nTEL;CELL;VOICE:13524222279".
		  "\nTEL;WORK;VOICE:021-88888888".
		  "\nEMAIL:86415375@qq.com".
		  "\nURL:http://www.qianqian.com".
		  "\nADR:上海市浦东新区周星路500弄46#1302".
		  "\nEND:VCARD";
		$data = urlencode($vcard);
		
		$resp = MakeCodeImg($vcard,false,'','','','',$ap_arr);
		
		//$image =array();
		//$image['image']=base64_encode($resp);
		//$image['image1']=base64_encode($resp);
		//$rs=M('Timage')->add($image);
		//echo(base64_encode($resp));
		//echo(base64_encode($resp));
		/*$_FILES["file"]["name"]=date('YmdHis').mt_rand(1000,9999);
		
		$resp = UpLoadfileByOss($_FILES);
		if($resp['sucess']=='1'){
				$resp_desc = "活动创建成功";
				//$activity_id = mysql_insert_id();
				$this->returnSuccess($resp_desc,array("activity_id"=>$activity_id,"imag_url"=>$resp['msg']));
		}
		else
		{
			$this->error($resp['msg']);
		}*/
		

	}
	
	private function check(){
		if($this->user_id == '')
		{
			return array('resp_desc'=>'用户id不能为空！');
			return false;
		}
		
		return true;
	}	
}
?>
