<?php
/**
 * 功能：活动参与
 * @author siht
 * 时间：2016-03-10
 */
class ActivityJoinAction extends BaseAction 
{
	//接口参数
	public $activity_id; //活动id
	public $user_id; //报名用户id
	
	public function _initialize(){
		parent::_initialize();
		$this->checkSign();

		$this->user_id = I('user_id'); //用户id
		$this->activity_id = I('activity_id'); //活动id
	}
		
	public function run() {
		$rs = $this->check(); 
		if($rs!==true){
			$this->returnError($rs['resp_desc']);
		}
		$activity = D("Activity",'Service');
		$where = "id = ".$this->activity_id;
		$activity_info = $activity->getActivityInfo($where);

		if(empty($activity_info)){
			$this->returnError('找不到该活动', '1004');
		}
		if($activity_info['activity_status'] == '2'
			|| $activity_info['activity_status'] == '3'
			|| $activity_info['activity_status'] == '4'
			|| $activity_info['activity_status'] == '9')
		{
			$this->returnError('报名已截止，活动已结束或已取消，不能参与！', '1005');
		}
		if($activity_info['part_count'] >= $activity_info['limit_count'])
		{
			$this->returnError('活动报名人数已达上限！', '1006');
		}
		
		//查用户
		$where_info = "id = ".$this->user_id;
		$user_info = M('Tuser')->where($where_info)->find();
		if(empty($user_info))
		{
			$this->returnError('报名用户不存在！', '1009');
		}

		$fmale_count = 0;
		if($user_info['sexual'] == 2)
		{
			$fmale_count = 1;
		}

		//记录报名信息
		$where_info = "activity_id = ".$this->activity_id." and user_id = ".$this->user_id;
		$activity_user = M('TactivityUser')->where($where_info)->find();
		if(!empty($activity_user) && $activity_user['user_status'] == '0'){
			$this->returnError('已报名，不要重复报名！', '1007');
		}
		$user_join = array();
		$user_join['activity_id'] = $this->activity_id;
		$user_join['user_id'] = $this->user_id;
		$user_join['user_status'] = 0;
		$user_join['user_type'] = 0;
		$user_join['join_time'] = date('YmdHis');

		$rs = M('TactivityUser')->add($user_join);
		if(!$rs)
		{
			$this->returnError('活动报名入库失败！', '1007');
		}

		//更新报名人数
		$rs = M('Tactivity')->where($where)->setInc('part_count',1);
		if(!$rs)
		{
			$this->returnError('活动报名人数更新失败！', '1008');
		}
		if($fmale_count > 0)
		{
			$rs = M('Tactivity')->where($where)->setInc('fmale_part_count',$fmale_count);
			if(!$rs)
			{
				$this->returnError('活动报名女性人数更新失败！', '1008');
			}
		}

		if($activity_info['part_count']+1 >= $activity_info['limit_low'] 
			&& $activity_info['fmale_part_count'] + $fmale_count >= $activity_info['fmale_low'] 
			&& $activity_info['activity_status'] == 0)
		{
			 M('Tactivity')->where($where)->setInc('activity_status',1);//更新募集期到募集成功
		}


		$this->returnSuccess("报名成功");
	}
	
	private function check(){
		if($this->user_id == '')
		{
			return array('resp_desc'=>'用户id不能为空！');
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