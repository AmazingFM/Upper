<?php
/**
 * 功能：活动详情
 * @author siht
 * 时间：2016-02-10
 */
class ActivityInfoAction extends BaseAction 
{
	public $user_id;	//用户id
	public $activity_id;   //活动id

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();

		$this->user_id = I('user_id'); //用户id
		$this->activity_id = I('activity_id'); //活动id
	}
		
	public function run() {	
		$rs = $this->check(); 
		if(!($rs===true)){
			$this->returnError($rs['resp_desc']);
		}

		$activity = D("Activity",'Service');
		$where = "id = ".$this->activity_id;
		$activity_info = $activity->getActivityInfo($where);
		if(empty($activity_info))
		{
			$resp_desc = "找不到此活动的详情";
			$this->returnError($resp_desc, '1004');
		}

		$where = "province_code = '".$activity_info['province_code']."' and city_code = '".$activity_info['city_code']."' and town_code = '".$activity_info['city_code']."'";
		$city_info = M('Tcity')->where($where)->find();
		$activity_info['province'] = $city_info['province'];
		$activity_info['city'] = $city_info['city'];
		$activity_info['town'] = $city_info['town'];

		$where = "id = ".$activity_info['user_id'];
		$user_info = M('Tuser')->where($where)->find();
		$activity_info['nick_name'] = $user_info['nick_name'];

		$where = "user_id = ".$this->user_id ."  and activity_id = ".$this->activity_id." and user_status != 2";
		$activity_user = M('TactivityUser')->where($where)->find();
		if(empty($activity_user))
		{
			$activity_info['join_status'] = -1;//未报名或者取消报名，统一为-1
		}
		else
		{
			$activity_info['join_status'] = $activity_user['user_status'];
		}
		
		$resp_desc = "获取活动详情成功";
		$this->returnSuccess($resp_desc, $activity_info);
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