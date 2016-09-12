<?php
/**
 * 功能 活动评价查询
 * @author siht
 * 时间：2016-05-10
 */
class ActivityEvaluateQueryAction extends BaseAction 
{
	public $activity_id;	//活动id
	public $current_page;   //当前页
	public $page_size;   //每页大小	
		

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();

		$this->activity_id = I('activity_id'); //活动类型
		$this->current_page = I('current_page'); //当前页
		$this->page_size = I('page_size'); //每页大小

	}
	public function run() {		
		$rs = $this->check(); 
		if(!($rs===true)){
			$this->returnError($rs['resp_desc']);
		}
		
		$where = "a.activity_id = ".$this->activity_id;
		$field = array('a.activity_id,a.user_id,a.type,a.evaluate_level_1,a.evaluate_level_2,a.evaluate_level_3,a.evaluate_text','b.nick_name');
		$join= array("tuser b on b.id = a.user_id ");

		$perPage = $this->page_size;
		$start = ($this->current_page -1) * $perPage;
		$evaluate_list = M()->table('TactivityEvaluate a')->join($join)->where($where)->field($field)->limit("{$start},{$perPage}")->select();

		if(!empty($evaluate_list)){
			$resp_desc = "查询评价信息成功";
						
			$all_count = M('TactivityEvaluate')->where($where)->count();
			$page_info = array();
			$page_info['page_size'] = $this->page_size;
			$page_info['current_page'] = $this->current_page;
			$page_info['total_num'] = $all_count;
			$page_info['total_page'] = ceil($all_count/$this->page_size);
								
			$this->returnSuccess($resp_desc, array('evaluate_list' => $evaluate_list, 'page_nav' => $page_info));
		}
		else
		{
			$resp_desc = "无评价";
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
		if($this->activity_id == '')
		{
			return array('resp_desc'=>'活动id不能为空！');
			return false;
		}
		return true;
	}	
}
?>