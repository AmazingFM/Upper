<?php
/**
 * 功能：用户激活
 * @author siht
 * 时间：2015-07-31
 */

class UserActivitionAction extends BaseAction
{
	//接口参数
	public $user_id;

	public function _initialize(){
		parent::_initialize();
		//$this->checkSign();

		$this->user_id = I('user_id');
	}

	public function run() {		
		$rs = $this->check();
		if($rs!==true){
			$this->returnError($rs['resp_desc'],'9002');
		}
		
		//查用户信息
		$where = "id = ".$this->user_id;
		$user_info = M('Tuser')->where($where)->find();
		if(empty($user_info))
		{
			echo "激活失败，用户不存在";
			exit;
		}
		
		//校验状态
		if($user_info['user_status'] > 1)
		{
			echo "用户状态异常，不能激活";
			exit;
		}
		else if($user_info['user_status'] == 1)
		{
			echo "该用户已激活";
			exit;
		}
		

		//给用户制个人信息名片
		$text = "user_id=".$this->user_id;
		$ap_arr=array();//预留
		$user_image = MakeCodeImg(base64_encode($text),true,'','','','',$ap_arr);

		//激活用户
		$new_user = array();
		$new_user['user_status'] = 1;
		$new_user['user_image'] = base64_encode($user_image);

		$rs = M('Tuser')->where($where)->save($new_user);
		if($rs === false)
		{
			echo "激活失败,更新用户信息失败";
			exit;
		}
	
		echo "激活成功";
		exit;
	}

	

	private function check(){
		if($this->user_id == '')
		{
			return array('resp_desc'=>'user_id不能为空！');
			return false;
		}

		return true;
	}
}
?>
