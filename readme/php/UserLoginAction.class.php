<?php
/**
 * 功能：用户登陆
 * @author siht
 * 时间：2015-07-31
 */

class UserLoginAction extends BaseAction
{
	//接口参数
	public $user_name;
	public $user_pass;
	public $pass_type;
	

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();
	
		$this->user_name = I('user_name');
		$this->user_pass = I('user_pass');
		$this->pass_type = I('pass_type');		
	}

	public function run() {
		
		$rs = $this->check();
		if($rs!==true){
			$this->returnError($rs['resp_desc'],'9002');
		}
		
		//1.取用户基本信息
		$where = "user_name = '".$this->user_name."' and pass_type = '".$this->pass_type."'";	
		$field = array('id','node_id','industry_id','true_name','sexual','user_icon','user_image','nick_name','user_pass','user_status');
		$user_info = M('Tuser')->where($where)->field($field)->find();
		if(empty($user_info))
		{
			$this->returnError('用户不存在','9011');
		}

		if($user_info['user_pass'] != $this->user_pass)
		{
			$this->returnError('登陆密码错误','9012');
		}
		
		if($user_info['user_status'] == '0')
		{
			$this->returnError('用户未激活，请去邮箱激活','9012');
		}

		//2.查行业
		$where =  "id =". $user_info['industry_id'];
		$industry_info = M('Tindustry')->where($where)->field('industry_name')->find();
		if(!$industry_info)
		{
			$this->returnError('查询行业信息失败','9012');
		}
		else
		{
			$user_info['industry_name'] = $industry_info['industry_name'];
		}
		//3.查公司
		$where =  "id =". $user_info['node_id'];
		$node_info = M('Tnode')->where($where)->field('node_name')->find();
		if(!$node_info)
		{
			$this->returnError('查询公司信息失败','9012');
		}
		else
		{
			$user_info['node_name'] = $node_info['node_name'];
		}
		

		//4.更新登陆信息
		$where =  "id =". $user_info['id'];
		$login_info = array();
		$login_info['last_login_time'] = date('YmdHis');
		$login_info['token'] = md5($this->user_name.$login_info['last_login_time']);
		$rs = M('Tuser')->where($where)->save($login_info);
		if(!$rs)
		{
			$this->returnError('更新登陆信息失败','9017');
		}
		$user_info['token'] = $login_info['token'];
		unset($user_info['user_pass']);
		
		$this->returnSuccess("登陆成功",$user_info);
	}

	

	private function check(){
		if($this->user_name == '')
		{
			return array('resp_desc'=>'用户名[user_name]不能为空！');
			return false;
		}
		if($this->user_pass == '')
		{
			return array('resp_desc'=>'用户密码[user_pass]不能为空！');
			return false;
		}
		if($this->pass_type == '')
		{
			return array('resp_desc'=>'密码类型[pass_type]不能为空！');
			return false;
		}
	
		return true;
	}
}
?>
