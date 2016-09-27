<?php
/**
 * 功能：活动参与详情
 * @author siht
 * 时间：2016-02-10
 */
class ActivityJoinInfoAction extends BaseAction 
{
	public $activity_id;   //活动id

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();

		$this->activity_id = I('activity_id'); //活动id
	}
		
	public function run() {	
		$rs = $this->check(); 
		if(!($rs===true)){
			$this->returnError($rs['resp_desc']);
		}

		$where = "s.activity_id = ".$this->activity_id." and s.user_status != 2";

		$field = array('s.activity_id,s.user_id','i.nick_name','i.sexual','i.user_icon');
		$join= array("tuser i on i.id = s.user_id ");

		$activity_user_list = M()->table('tactivity_user s')->join($join)->where($where)->field($field)->select();

		//echo M()->getlastSql();

		$this->returnSuccess("查询参与人信息成功", array("total_count"=>count($activity_user_list),"user_list"=>$activity_user_list));
		
	}
	
	private function check(){		
		if($this->activity_id == '')
		{
			return array('resp_desc'=>'活动id不能为空！');
			return false;
		}
		return true;
	}	
}
?>