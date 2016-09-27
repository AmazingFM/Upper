<?php
/**
 * 功能 活动列表查询
 * @author siht
 * 时间：2016-03-20
 */
class ActivityListAction extends BaseAction 
{
	public $activity_class;	//活动类型
	public $activity_status;	//活动状态
	public $industry_id;	//行业id
	public $start_begin_time;	//活动发生开始时间
	public $start_end_time;	//活动发生截止时间
	public $province_code;
	public $city_code;
	public $town_code;
	public $current_page;   //当前页
	public $page_size;   //每页大小	
	public $partner_id;	//活动参与者id
		

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();

		$this->activity_class = I('activity_class'); //活动类型
		$this->activity_status = I('activity_status'); //活动状态
		$this->industry_id = I('industry_id'); //活动类型
		$this->start_begin_time = I('start_begin_time');
		$this->start_end_time = I('start_end_time');
		$this->province_code = I('province_code');
		$this->city_code = I('city_code');
		$this->town_code = I('town_code');
		$this->current_page = I('current_page'); //当前页
		$this->page_size = I('page_size'); //每页大小
		$this->creator_id = I('creator_id');	//活动创建者id
	}
	public function run() {		
		$rs = $this->check(); 
		if(!($rs===true)){
			$this->returnError($rs['resp_desc']);
		}
		$todayTime = date('YmdHis');

		//$activity = D("Activity",'Service');
		$where = "(a.industry_id = -1 or a.industry_id = ".$this->industry_id.")";
		
		if(isset($this->activity_class) && $this->activity_class !=''){
			$where .= " and a.activity_class = ".$this->activity_class; 
		}
		if(isset($this->activity_status) && $this->activity_status !=''){	
			$where .= " and a.activity_status = ".$this->activity_status;
		}
		if(isset($this->creator_id) && $this->creator_id !=''){	
			$where .= " and a.user_id = ".$this->creator_id;
		}
		if(isset($this->province_code) && $this->province_code !=''){	
			$where .= " and a.province_code = ".$this->province_code;
		}
		if(isset($this->city_code) && $this->city_code !=''){	
			$where .= " and a.city_code = ".$this->city_code;
		}
		if(isset($this->town_code) && $this->town_code !=''){	
			$where .= " and a.town_code = ".$this->town_code;
		}
		if(isset($this->start_begin_time) && $this->start_begin_time !=''){	
			$where .= " and a.start_time >= ".$this->start_begin_time;
		}
		if(isset($this->start_end_time) && $this->start_end_time !=''){	
			$where .= " a.and start_time <= ".$this->start_end_time;
		}



		$start = ($this->current_page -1) * $this->page_size;	
		$activity_info = M()->table('tactivity a')->join('left join tcity b on (a.province_code = b.province_code and a.city_code = b.city_code and b.level = 2)')->join('left join tuser c on a.user_id = c.id')->field('a.id,a.activity_name, a.activity_desc, a.create_time, a.begin_time, a.end_time, a.start_time,a.province_code,a.city_code,a.town_code,a.activity_place_code, a.activity_place, a.activity_image, a.is_prepaid, a.industry_id,a.activity_status, a.activity_class, a.clothes_need,a.activity_fee,a.part_count,a.limit_count, b.province, b.city, c.nick_name')->where($where)->limit("{$start},{$this->page_size}")->order("activity_status asc, start_time desc")->select();
	
		//$activity_info = $activity->searchActivity($where, 'id,activity_name, activity_desc, create_time, begin_time, end_time, start_time,province_code,city_code,town_code,activity_place_code, activity_place, activity_image, is_prepaid, industry_id,activity_status, clothes_need,activity_fee,part_count,limit_count' ,$this->current_page, $this->page_size);

		//echo D('Tactivity')->getlastSql();
		if(!empty($activity_info)){
			$resp_desc = "获取活动列表成功";
						
			$all_count = M()->table('tactivity a')->where($where)->count();
			$page_info = array();
			$page_info['page_size'] = $this->page_size;
			$page_info['current_page'] = $this->current_page;
			$page_info['total_num'] = $all_count;	
			$page_info['total_page'] = ceil($all_count/$this->page_size);
								
			$this->returnSuccess($resp_desc, array('activity_list' => $activity_info, 'page_nav' => $page_info));
		}
		else
		{
			$resp_desc = "无活动";
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
		if($this->industry_id == '')
		{
			return array('resp_desc'=>'行业[industry_id]不能为空！');
			return false;
		}
		return true;
	}	
}
?>