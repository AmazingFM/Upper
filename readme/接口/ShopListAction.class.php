<?php
/**
 * 功能 商户列表查询
 * @author siht
 * 时间：2016-05-02
 */
class ShopListAction extends BaseAction 
{
	public $province_code;
	public $city_code;
	public $town_code;
	public $industry_id;	//行业id
	public $shop_class;		//商户分类
	public $current_page;   //当前页
	public $page_size;   //每页大小			

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();

		$this->province_code = I('province_code');
		$this->city_code = I('city_code');
		$this->town_code = I('town_code');
		$this->industry_id = I('industry_id');
		$this->shop_class = I('shop_class');
		$this->current_page = I('current_page'); //当前页
		$this->page_size = I('page_size'); //每页大小
	}
	public function run() {		
		$rs = $this->check(); 
		if(!($rs===true)){
			$this->returnError($rs['resp_desc']);
		}

		$where = "status = 1";
		if(isset($this->shop_class) && $this->shop_class !=''){
			$where .= " and shop_class = ".$this->shop_class; 
		}
		if(isset($this->industry_id) && $this->industry_id !=''){
			$where .= " and industry_id = ".$this->industry_id; 
		}
		
		if(isset($this->activity_status) && $this->activity_status !=''){	
			$where .= " and activity_status = ".$this->activity_status;
		}
		
		if(isset($this->province_code) && $this->province_code !=''){	
			$where .= " and province_code = ".$this->province_code;
		}
		if(isset($this->city_code) && $this->city_code !=''){	
			$where .= " and city_code = ".$this->city_code;
		}
		if(isset($this->town_code) && $this->town_code !=''){	
			$where .= " and town_code = ".$this->town_code;
		}

		$perPage = $this->page_size;
		$start = ($this->current_page -1) * $perPage;
		$shop_list = M('Tshop')->where($where)->limit("{$start},{$perPage}")->select();
		
		if(!empty($shop_list)){
			$resp_desc = "获取商户列表成功";
						
			$all_count = M('Tshop')->where($where)->count();
			$page_info = array();
			$page_info['page_size'] = $this->page_size;
			$page_info['current_page'] = $this->current_page;
			$page_info['total_num'] = $all_count;		
			$page_info['total_page'] = ceil($all_count/$this->page_size);
								
			$this->returnSuccess($resp_desc, array('shop_list' => $activity_info, 'page_nav' => $page_info));
		}
		else
		{
			$resp_desc = "无商户";
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

		return true;
	}	
}
?>