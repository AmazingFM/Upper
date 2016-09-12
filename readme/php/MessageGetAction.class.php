<?php
/**
 * 功能：消息查询
 * @author siht
 * 时间：2016-05-02
 */

class MessageGetAction extends BaseAction
{
	//接口参数
	public $user_id; //登陆的user_id		

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();
	
		$this->user_id = I('user_id');			
	}

	public function run() {
		
		$rs = $this->check();
		if($rs!==true){
			$this->returnError($rs['resp_desc'],'9002');
		}

		//本人未读信息及系统全员未过期信息
		$join= array("tuser b on b.id = a.from_id ");
		$where = "a.status = 0 and (a.to_id = ".$this->user_id." or (a.from_id = 0 and a.to_id = 0))";
		//$message_list = M('TuserMessage')->where($where)->select();
		$message_list = M()->table('tuser_message a')->join($join)->where($where)->field("a.*,IFNULL(b.nick_name,'system') as nick_name")->select();


		if(!empty($message_list)){
			$resp_desc = "获取消息成功";

			//更新指定接收方的信息为已读
			$where = "status = 0 and to_id = ".$this->user_id;
			$new_message = array();
			$new_message['status'] = 1;
			$rs = M('TuserMessage')->where($where)->save($new_message);
		
		}
		else
		{
			$resp_desc = "无未读消息";
		}

		$this->returnSuccess($resp_desc,array("total_count"=>count($message_list),'message_list'=>$message_list));
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