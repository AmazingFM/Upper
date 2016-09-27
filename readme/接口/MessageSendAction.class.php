<?php
/**
 * 功能：发送消息
 * @author siht
 * 时间：2016-05-02
 */

class MessageSendAction extends BaseAction
{
	//接口参数
	public $user_id; //登陆的user_id	
	public $from_id; //发起方id
	public $to_id;	//接收方id;
	public $message_type;//消息类型
	public $message_desc;//消息内容
	public $expire_time;//失效日期; 为空则永久，系统消息必须传	

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();
	 
		$this->user_id = I('user_id');
		$this->from_id = I('from_id');
		$this->to_id = I('to_id');
		$this->message_type = I('message_type',0);
		$this->message_desc = I('message_desc');
		$this->expire_time = I('expire_time');
				
	}

	public function run() {
		
		$rs = $this->check();
		if($rs!==true){
			$this->returnError($rs['resp_desc'],'9002');
		}
		
		//1.查发送用户基本信息
		/*$where = "id = ".$this->from_id;
		$user_info = M('Tuser')->field($field)->where($where)->find();
		if(empty($user_info))
		{
			$this->returnError('发送用户不存在','9011');
		}*/
		
		//2.查接收用户信息
		/*$where = "id = ".$this->to_id;
		$user_info = M('Tuser')->field($field)->where($where)->find();
		if(empty($user_info))
		{
			$this->returnError('发送用户不存在','9011');
		}*/


		//3.记录消息
		$message_info = array();
		$message_info['from_id'] = $this->from_id;
		$message_info['to_id'] = $this->to_id;
		$message_info['message_type'] = $this->message_type;		
		$message_info['message_desc'] = $this->message_desc; 
		$message_info['add_time'] = date('YmdHis'); 
		$message_info['expire_time'] = $this->expire_time;
		$message_info['status'] = 0;

		$rs = M('TuserMessage')->add($message_info);
		if($rs === false)
		{
			$this->returnError('消息发送入库失败','9012');
		}
		
		$this->returnSuccess("发送信息成功",array("req_seq"=>$this->req_seq));
	}

	

	private function check(){
		if($this->user_id == '')
		{
			return array('resp_desc'=>'用户id不能为空！');
			return false;
		}
		if($this->from_id == '')
		{
			return array('resp_desc'=>'发送方id不能为空！');
			return false;
		}
		if($this->to_id == '')
		{
			return array('resp_desc'=>'接收方id不能为空！');
			return false;
		}
	
		return true;
	}
}
?>