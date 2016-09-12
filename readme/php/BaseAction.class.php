<?php
//判断是否有 定义 _APP_PID_
if(!defined('_APP_PID_')) exit('_APP_PID_未定义，非法进入');
//接口基类，只能继承
abstract class BaseAction extends Action{
	public $app_id;   //应用id
	public $req_seq; //请求流水号
	public $time_stamp; //时间戳
	public $token;		//登陆token
	public $sign;		//签名
	public $session_id;		//session_id
	public $session;	//用户SESSION（类）

	const SESSIONTIMEOUT_RESPONSE_ID = '5555';	//登录超时响应码
	const ERROR_RESPONSE_ID = '9999';			//一般错误响应码
	const ERROR_NET_CODE = '-1';				//网络超时响应码
	const ERROR_DB_CODE = '-2';					//数据库异常响应码
	const ERROR_EXPTION_CODE = '-1';			//其它异常响应码

	public function _initialize(){
		//记录日志开始
		Log::$format = '[Y-m-d H:i:s]';
		$this->log('ip:['.$_SERVER['REMOTE_ADDR'].']:'.$_SERVER['QUERY_STRING'],'REQUEST');

		$this->app_id = I('app_id');			//应用id
		$this->req_seq = I('req_seq');			//请求流水号
		$this->time_stamp = I('time_stamp');	//请求时间戳
		$this->token = I('token');				//登陆token
		$this->sign = I('sign');				//请求签名
		/*$this->session_id = I('session_id',session_id());   //session_id
		//重新设置 session 开始
		session_write_close();
		session_id($this->session_id);
		session_start();*/
		//重新设置 session结束
	}
	//返回AJAX信息
	protected function returnAjax($arr){
		//$this->log(print_r($arr,true),'INFO');
		array_walk_recursive($arr,'BaseAction::Utf8');
		$return = json_encode($arr);
		$this->log($return,'RESPONSE_INFO');
		if($this->_get('debug')){
			tag('view_end');
		}
		G('BeginTime',$GLOBALS['_beginTime']);//设置项目开始时间
		G('EndTime');
		echo $return;
		$this->log('RUNTIME:'.G('BeginTime','EndTime').' s');
		exit;
	}

	protected function returnError($message,$respId = self::ERROR_RESPONSE_ID){
		if(!is_array($message)){
			$message = array('resp_id'=>$respId,'resp_desc'=>$message);
		}
		$this->returnAjax($message);
	}
	protected function returnSuccess($respStr,$respData = null){
		$respId = '0000';
		if(!is_array($message)){
			$message = array('resp_id'=>$respId,'resp_desc'=>$respStr);
			//响应信息
			$message['resp_data'] = $respData;
		}
		$this->returnAjax($message);
	}
	

	//创建post请求参数
	protected function httpPost($url,$data='',&$error='',$opt = array()){
		import('@.ORG.Net.FineCurl') or die('导入包失败');
		$socket = new FineCurl;
		$socket->setopt('URL',$url);
		if(is_array($data)){
			$data = http_build_query($data);
		}
		$this->log('请求：'.$url.'参数：'.$data);

		$result = $socket->send($data);
		$error = $socket->error();
		//记录日志
		if($error){
			$this->log($error,'ERROR');
		}
		$this->log('响应：'.(function_exists('mb_convert_encoding') ? mb_convert_encoding($result,'utf-8','gbk,utf-8'):$result));
		return $result;
	}

	//记录日志
	protected function log($msg,$level = Log::INFO){
		//trace('Log.'.$level.':'.$msg);
		Log::write($msg, '['._APP_PID_.']'.$level);
	}

	//获取最后错误
	protected function lastError($err = null){
		static $__lastError;
		$__lastError = $err;
		if($__lastError){
			$this->log($err,LOG::ERR);
		}
		if($err == null) return $__lastError;
	}

	//自动转换为utf-8
	static function Utf8(&$str){
		$str = mb_convert_encoding($str,'utf-8','utf-8,GBK');
	}

	//校验签名
	protected function checkSign(){
		if($this->app_id == '')
		{
			$this->returnError('应用id不能为空','1002');
		}
		if($this->req_seq == '')
		{
			$this->returnError('请求流水号不能为空','1003');
		}
		if($this->time_stamp == '')
		{
			$this->returnError('请求时间戳不能为空','1004');
		}
		if($this->sign == '')
		{
			$this->returnError('请求签名不能为空','1005');
		}
		

		$str_src = 'upper'.$this->app_id.$this->req_seq.$this->time_stamp.'upper';
		$sgin_value = md5($str_src);
		
		$pre_time = date('YmdHis',strtotime("-10 minutes"));
		$next_time = date('YmdHis',strtotime("+10 minutes"));
		if($this->time_stamp < $pre_time || $this->time_stamp > $next_time)
		{
			$this->returnError('请求已超期','1001');
		}
		/*if($sgin_value != $this->sign)
		{
			$this->returnError('签名校验失败，无效的请求','1000');
		}*/
		
	}

	protected function checkLogin($user_id = ''){
		if($this->token == '' || $user_id == '')
		{
			$this->returnError('未登陆','0010');
		}
		$where = "id = ".$user_id;
		$cur_token = M('Tuser')->where($where)->getField('token');
		if($this->token != $cur_token)
		{
			$this->returnError('当前登陆已失效','0010');
		}	
	}
}

