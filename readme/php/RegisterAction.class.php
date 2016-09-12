<?php
/**
 * 功能：用户注册
 * @author siht
 * 时间：2015-07-31
 */

class RegisterAction extends BaseAction
{
	//接口参数
	public $node_id;
	public $user_name;
	public $user_pass;
	public $pass_type;
	public $industry_id;
	public $true_name;
	public $employee_id;
	public $identify_id;
	public $identify_type;
	public $mobile;
	public $sexual;
	public $birthday;
	public $user_icon;
	public $nick_name;//昵称
	public $user_desc;//简介

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();

		$this->node_id = I('node_id');
		$this->user_name = I('user_name');
		$this->user_pass = I('user_pass');
		$this->pass_type = I('pass_type');
		$this->industry_id = I('industry_id');
		$this->true_name = I('true_name');
		$this->employee_id = I('employee_id');
		$this->identify_id = I('identify_id');
		$this->identify_type = I('identify_type',0);
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

		if($this->nick_name == '')
		{
			$this->nick_name='用户'.time();
		}
		
		$user_info = array();
		$user_info['node_id'] = $this->node_id;
		$user_info['user_name'] = $this->user_name;
		$user_info['user_pass'] = $this->user_pass;
		$user_info['pass_type'] = $this->pass_type;
		$user_info['industry_id'] = $this->industry_id;
		$user_info['true_name'] = $this->true_name;
		$user_info['employee_id'] = $this->employee_id;
		$user_info['identify_id'] = $this->identify_id;
		$user_info['identify_type'] = $this->identify_type;
		$user_info['mobile'] = $this->mobile;
		$user_info['sexual'] = $this->sexual;
		$user_info['birthday'] = $this->birthday;
		$user_info['user_icon'] = $this->user_icon;
		$user_info['add_time'] = date('YmdHis');
		$user_info['nick_name'] = $this->nick_name;
		$user_info['user_desc'] = $this->user_desc;

		$rs = M('Tuser')->add($user_info);
		if($rs === false)
		{
			$this->returnError('用户新增入库失败','9012');
		}


		if($this->identify_type == '0')//邮件激活模式
		{
			$activit_url = "http://api.qidianzhan.com.cn/AppServ/index.php?a=UserActivition&user_id=".mysql_insert_id();
			$content = "鸵鸟<br/>激活链接：<a href=\"".$activit_url."\">点击激活</a><br/>日期：".date('Y-m-d H:i:s');
			$ps = array(
				"subject"=>"鸵鸟主题",
				"content"=>$content,
				"email"=>"562026737@qq.com",
				//"email"=>"64514222@qq.com",
				//"email"=>$this->identify_id,
			);
			$resp = send_mail($ps);
			if($resp['sucess']=='1'){
				$this->returnSuccess('注册成功，请查收邮箱进行激活!');
			}else{
				$this->returnError('发送邮件失败','9013');
			}
		}
		else//认证方式
		{
			$this->returnSuccess('注册成功，请等待系统认证后激活！');	
		}
	}

	

	private function check(){
		if($this->node_id == '')
		{
			return array('resp_desc'=>'机构号[node_id]不能为空！');
			return false;
		}
		if($this->industry_id == '')
		{
			return array('resp_desc'=>'行业[industry_id]不能为空！');
			return false;
		}
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
		if($this->identify_id == '')
		{
			return array('resp_desc'=>'认证信息[identify_id]不能为空！');
			return false;
		}
	
		return true;
	}
}
?>
