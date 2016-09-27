<?php
/**
 * 功能：用户修改
 * @author siht
 * 时间：2015-07-31
 */

class UserModifyAction extends BaseAction
{
	//接口参数
	public $user_id;
	public $user_pass;
	public $new_pass;
	public $true_name;
	public $employee_id;
	public $node_email;
	public $mobile;
	public $sexual;
	public $birthday;
	public $user_icon;
	public $nick_name;//昵称
	public $user_desc;//简介

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();
	
		$this->user_id = I('user_id');
		$this->user_pass = I('user_pass');
		$this->new_pass = I('new_pass');
		$this->true_name = I('true_name');
		$this->employee_id = I('employee_id');
		$this->node_email = I('node_email');
		$this->mobile = I('mobile');
		$this->sexual = I('sexual');
		$this->birthday = I('birthday');
		$this->user_icon = I('user_icon');
		$this->nick_name = I('nick_name');
		$this->user_desc = I('user_desc');
		
	}

	public function run() {
		
		$rs = $this->check();
		if($rs!==true){
			$this->returnError($rs['resp_desc'],'9002');
		}
		
		$where = "id = ".$this->user_id;

		$user_info = M('Tuser')->where($where)->find();

		if(empty($user_info))
		{
			$this->returnError('用户不存在','9011');
		}

		$new_user = array();
		if($this->new_pass != '')
		{
			//echo print_r($user_info,true);
			if(trim($this->user_pass) != trim($user_info['user_pass']))
			{
				$this->returnError('原密码不正确','9013');
			}
			$new_user['user_pass'] = $this->new_pass;
		}

		if($this->true_name != '')
		{
			$new_user['true_name'] = $this->true_name;
		}
		if($this->employee_id != '')
		{
			$new_user['employee_id'] = $this->employee_id;
		}
		if($this->node_email != '')
		{
			$new_user['node_email'] = $this->node_email;
		}
		if($this->mobile != '')
		{
			$new_user['mobile'] = $this->mobile;
		}
		if($this->sexual != '')
		{
			$new_user['sexual'] = $this->sexual;
		}
		if($this->birthday != '')
		{
			$new_user['birthday'] = $this->birthday;
		}
		if($this->user_icon != '')
		{
			$new_user['user_icon'] = $this->user_icon;
		}
		if($this->nick_name != '')
		{
			$new_user['nick_name'] = $this->nick_name;
		}
		if($this->user_desc != '')
		{
			$new_user['user_desc'] = $this->user_desc;
		}

		$rs = M('Tuser')->where($where)->save($new_user);
		if($rs === false)
		{
			$this->returnError('修改失败','9012');
		}

		
		$this->returnSuccess("修改成功",array("user_id"=>$this->user_id));
	}

	

	private function check(){
		if($this->user_id == '')
		{
			return array('resp_desc'=>'用户名[user_id]不能为空！');
			return false;
		}

		if($this->new_pass != '')
		{
			if($this->user_pass == '')
			{
				return array('resp_desc'=>'原密码[user_pass]不能为空！');
				return false;
			}
		}
		return true;
	}
}
?>