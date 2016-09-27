<?php
/**
 * 功能：参与活动列表
 * @author siht
 * 时间：2016-02-10
 */
class JoinActivityListAction extends BaseAction 
{
	public $activity_class;	//活动类型
	public $activity_status;	//活动状态
	public $current_page;   //当前页
	public $page_size;   //每页大小	
	public $partner_id;	//活动参与者id
		

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();

		$this->activity_class = I('activity_class'); //活动类型
		$this->activity_status = I('activity_status'); //活动状态
		$this->current_page = I('current_page'); //当前页
		$this->page_size = I('page_size'); //每页大小
		$this->partner_id = I('partner_id');	//活动参与者id
	}
	public function run() {		
		$rs = $this->check(); 
		if(!($rs===true)){
			$this->returnError($rs['resp_desc']);
		}
		$todayTime = date('YmdHis');

		$where = "user_id = ".$this->partner_id." and user_status in (1,2,5) ";

		$activity_user = M('TactivityUser')->where($where)->select();
		if(!empty($activity_user)){
			$activityid_arr = array();
			foreach($activity_user as $v){
				$activityid_arr[]= $v['activity_id'];
			}
			$where = array(
				'id' => array('in',implode(',',$activityid_arr))
			);
			$activity = D("Activity",'Service');
			$activity_info = $activity->searchActivity($where, 'id,activity_name, activity_desc, create_time, begin_time, end_time, activity_place_code, activity_place, activity_image, is_prepaid, industry_id, activity_status, clothes_need,activity_fee,part_count,limit_count' ,$this->current_page, $this->page_size);

			if(!empty($activity_info)){
				$resp_desc = "获取活动列表成功";
							
				$all_count = $activity->countActivity($where);
				$page_info = array();
				$page_info['page_size'] = $this->page_size;
				$page_info['current_page'] = $this->current_page;
				$page_info['total_num'] = $all_count;	
				$page_info['total_page'] = ceil($all_count/$this->page_size);
									
				$this->returnSuccess($resp_desc, array('activity_list' => $activity_info, 'page_nav' => $page_info));
			}
			else
			{
				$resp_desc = "无活动详情";
				$this->returnError($resp_desc, '1005');
			}
		}
		else
		{
			$resp_desc = "未参加任何活动";
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
		if($this->partner_id == '')
		{
			return array('resp_desc'=>'参与者id不能为空');
			return false;
		}
		return true;
	}	
}
?>