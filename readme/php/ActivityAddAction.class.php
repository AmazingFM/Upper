<?php
/**
 * 功能：活动创建
 * @author siht
 * 时间：2016-02-10
 */
class ActivityAddAction extends BaseAction 
{
	//接口参数
	public $activity_name; //活动名称
	public $activity_desc; //活动描述
	public $activity_class;	//活动类型
	public $begin_time;	//活动报名开始时间
	public $end_time;	//活动报名截止时间
	public $start_time;	//活动发生时间	public $province_code;
	public $city_code;
	public $town_code;
	public $activity_place_code; //地点代码
	public $activity_place;		//活动地点
	public $is_prepaid; //是否预付
	public $industry_id;//行业代码（行业限制类活动）
	public $activity_fee; //活动金额
	public $limit_count; //活动参与人数限制
	public $limit_low; //活动参与人数限制
	public $user_id;

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();

		$this->user_id = I('user_id'); //用户id
		$this->activity_name = I('activity_name'); //活动简称
		$this->activity_desc = I('activity_desc');	//活动描述
		$this->begin_time = I('begin_time');	
		$this->end_time = I('end_time');	
		$this->start_time = I('start_time');
		$this->activity_class = I('activity_class'); 
		$this->province_code = I('province_code');
		$this->city_code = I('city_code');
		$this->town_code = I('town_code');
		$this->activity_place_code = I('activity_place_code'); 
		$this->activity_place = I('activity_place');  
		$this->is_prepaid = I('is_prepaid'); 
		$this->industry_id = I('industry_id',-1); 
		$this->clothes_need = I('clothes_need');
		$this->limit_count = I('limit_count');		  //活动参与人数限制
		$this->limit_low = I('limit_low');		  //活动参与人数限制下限
		$this->activity_fee = I('activity_fee');		  //活动金额
	}
		
	public function run() {
		$rs = $this->check(); 
		if($rs!==true){
			$this->returnError($rs['resp_desc']);
		}

		//图片上传
		$image_url="";
		if(!empty($_FILES))
		{
			$ext = $this->get_file_extension($_FILES["file"]["name"]);
			$_FILES["file"]["name"]=date('YmdHis').mt_rand(1000,9999).".".$ext;
			$resp = UpLoadfileByOss($_FILES["file"]);
			if($resp['sucess']=='1')
			{
					$resp_desc = "活动创建成功";
					$image_url = $resp['msg'];
			}
			else
			{
				$resp_desc = "活动创建成功,图片上传失败";//图片上传失败活动可以创建
			}
		}


		//活动入库
		$activity_info = array();
	
		$activity_info['activity_name'] = $this->activity_name;
		$activity_info['activity_desc'] = $this->activity_desc;
		$activity_info['begin_time'] = $this->begin_time;		
		$activity_info['end_time'] = $this->end_time; 
		$activity_info['start_time'] = $this->start_time; 
		$activity_info['activity_class'] = $this->activity_class;
		$activity_info['province_code'] = $this->province_code;
		$activity_info['city_code'] = $this->city_code;
		$activity_info['town_code'] = $this->town_code;
		$activity_info['activity_place_code'] = $this->activity_place_code; 
		$activity_info['activity_place'] = $this->activity_place;
		$activity_info['is_prepaid'] = $this->is_prepaid; 
		$activity_info['industry_id'] = $this->industry_id; 
		$activity_info['clothes_need'] = $this->clothes_need; 
		$activity_info['activity_image'] = $image_url;  //活动图片
		$activity_info['activity_fee'] = $this->activity_fee; //活动金额
		$activity_info['limit_count'] = $this->limit_count; //活动限制
		$activity_info['limit_low'] = $this->limit_low; //活动限制下限
		$activity_info['user_id'] = $this->user_id;
		$activity_info['create_time'] = date('YmdHis');

		$activity = D("Activity",'Service');

		$rs = $activity->writeActivity($activity_info);
		if($rs)
		{
			$activity_id = mysql_insert_id();
			$this->returnSuccess($resp_desc,array("activity_id"=>$activity_id,"imag_url"=>$image_url));
		}
		else
		{
			$resp_desc = "活动新增入库失败";
			$this->returnError($resp_desc, '1003');		
		}

	}
	
	private function check(){
		if($this->user_id == '')
		{
			return array('resp_desc'=>'用户id不能为空！');
			return false;
		}
		if($this->activity_name == '')
		{
			return array('resp_desc'=>'活动简称不能为空！');
			return false;
		}
		if($this->activity_class == '')
		{
			return array('resp_desc'=>'活动类型不能为空！');
			return false;
		}
		if($this->begin_time == '')
		{
			return array('resp_desc'=>'报名开始时间不能为空！');
			return false;
		}
		if($this->end_time == '')
		{
			return array('resp_desc'=>'报名截止时间不能为空！');
			return false;
		}
		if($this->start_time == '')
		{
			return array('resp_desc'=>'活动发生时间不能为空！');
			return false;
		}
		if($this->begin_time >= $this->end_time)
		{
			return array('resp_desc'=>'报名开始时间不能大于报名截止时间');
			return false;
		}
		if(date('YmdHis') >= $this->end_time)
		{
			return array('resp_desc'=>'当前时间不能大于报名截止时间');
			return false;
		}
		if($this->end_time >= $this->start_time)
		{
			return array('resp_desc'=>'报名截止时间不能大于活动开始时间');
			return false;
		}
		return true;
	}
	
	//获取文件后缀
	private function get_file_extension($str = '') 
	{
		$start = strrpos($str, '.');
		$ext = substr($str, $start + 1);
		return $ext;
	}
}
?>