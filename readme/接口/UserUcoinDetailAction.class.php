<?php
/**
 * 功能 用户好评率明细
 * @author siht
 * 时间：2016-05-10
 */
class UserUcoinDetailAction extends BaseAction 
{
	public $q_user_id;	//查询用户id
	public $current_page;   //当前页
	public $page_size;   //每页大小	
	public $user_type;	// 0-发起者 1-参与者
		

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();

		$this->q_user_id = I('q_user_id'); //活动类型
		$this->current_page = I('current_page'); //当前页
		$this->page_size = I('page_size'); //每页大小
		$this->user_type = I('user_type'); //每页大小

	}
	public function run() {		
		$rs = $this->check(); 
		if(!($rs===true)){
			$this->returnError($rs['resp_desc']);
		}
		
		$where = "user_id = ".$this->q_user_id." and user_type = ".$this->user_type;
		
		$perPage = $this->page_size;
		$start = ($this->current_page -1) * $perPage;
		$ucoin_list = M('TuserUcoinDetail')->where($where)->limit("{$start},{$perPage}")->select();

		if(!empty($ucoin_list)){
			$resp_desc = "查询好评明细成功";
						
			$all_count = M('TuserUcoinDetail')->where($where)->count();
			$page_info = array();
			$page_info['page_size'] = $this->page_size;
			$page_info['current_page'] = $this->current_page;
			$page_info['total_num'] = $all_count;		
			$page_info['total_page'] = ceil($all_count/$this->page_size);
								
			$this->returnSuccess($resp_desc, array('ucoin_list' => $ucoin_list, 'page_nav' => $page_info));
		}
		else
		{
			$resp_desc = "无明细";
			$this->returnError($resp_desc, '0000');
		}
	}
	
	private function check(){		
		if($this->current_page == '')
		{
			return array('resp_desc'=>'当前页不能为空！');
			return false;
		}
		if($this->page_size == '')
		{
			return array('resp_desc'=>'单页大小不能为空！');
			return false;
		}
		if($this->page_size <= 0)
		{
			return array('resp_desc'=>'单页大小必须大于0！');
			return false;
		}
		if($this->q_user_id == '')
		{
			return array('resp_desc'=>'查询的用户id不能为空！');
			return false;
		}
		if($this->user_type == '')
		{
			return array('resp_desc'=>'查询的用户type不能为空！');
			return false;
		}
		return true;
	}	
}
?>