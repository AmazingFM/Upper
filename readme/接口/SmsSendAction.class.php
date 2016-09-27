<?php
/**
 * 功能：短信发送
 * @author siht
 * 时间：2016-05-23
 */

class SmsSendAction extends BaseAction
{
	//接口参数
	public $mobile;
	public $text;
	public $send_type;//0-注册验证码

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();
	
		$this->mobile = I('mobile');
		$this->text = I('text','');
		$this->send_type = I('send_type',0);
		
	}

	public function run() {
		
		$rs = $this->check();
		if($rs!==true){
			$this->returnError($rs['resp_desc'],'9002');
		}
		
		$send_text = '【UPPER】'.$this->text;
		$verify_code = 0;
		$msg_id = '';
		$sms_send = C('SMS_SEND_TIMES');
		
		$where = "mobile = '".$this->mobile."' and send_type = ".$this->send_type." and send_date = '".date('Yhd')."'";
		$sms_info =  M('TsmsSendstat')->where($where)->find();

		if($this->send_type == 0)//发送注册码，服务端组织文本内容并生成验证码
		{
			$verify_code = mt_rand(100000,999999);
			$send_text = '【UPPER】你正在注册upper，验证码:'.$verify_code.'。【请勿向任何人提供你收到的验证码】。';
			$resp = sendSMS($this->mobile,$send_text);
			if($resp['code'] != '0')
			{
				$this->returnError($resp['msg'],'1001');
			}
			if(!$sms_info)
			{
				if($sms_info['send_times'] >= $sms_send['verify_code'])
					$this->returnError('该手机本日发送验证码次数已达上限','1002');
			}
		}

		//记录sms发送日统计
		if(!$sms_info)//不存在新增
		{
			$sms_stat = array();
			$sms_stat['mobile'] = $this->mobile;
			$sms_stat['send_type'] = $this->send_type;
			$sms_stat['send_date'] = date('Yhd');
			$sms_stat['send_times'] = 1;
			$rs =  M('TsmsSendstat')->add($sms_stat);
			if(!$rs)
			{
				$this->returnSuccess("发送成功，新增发送统计数失败",array("verify_code"=>$verify_code,"text"=>$send_text));
			}
		}
		else//发送数+1
		{
			$rs = M('TsmsSendstat')->where($where)->setInc('send_times',1);
			if(!$rs)
			{
				$this->returnSuccess("发送成功，更新发送统计数失败",array("verify_code"=>$verify_code,"text"=>$send_text));
			}
		}

		$this->returnSuccess("发送成功",array("verify_code"=>$verify_code,"text"=>$send_text));
	}

	

	private function check(){
		if($this->mobile == '')
		{
			return array('resp_desc'=>'发送手机号不能为空！');
			return false;
		}
		return true;
	}
}
?>