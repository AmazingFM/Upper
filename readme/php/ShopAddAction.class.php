<?php
/**
 * 功能 商户新增（推荐商户）
 * @author siht
 * 时间：2016-05-10
 */
class ShopAddAction extends BaseAction 
{
	public $shop_name;
	public $shop_desc;
	public $province_code;
	public $city_code;
	public $town_code;
	public $shop_address;
	public $industry_id;	//行业id
	public $shop_class;		//商户分类
	public $contact_no;		//联系电话
	public $avg_cost;		//平均消费			

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();

		$this->shop_name = I('shop_name');
		$this->shop_desc = I('shop_desc');
		$this->province_code = I('province_code');
		$this->city_code = I('city_code');
		$this->town_code = I('town_code');
		$this->shop_address = I('shop_address');
		$this->industry_id = I('industry_id',-1);
		$this->shop_class = I('shop_class');
		$this->contact_no = I('contact_no'); 
		$this->avg_cost = I('avg_cost'); 
	}
	public function run() {		
		$rs = $this->check(); 
		if(!($rs===true)){
			$this->returnError($rs['resp_desc']);
		}

		//商户入库
		$shop_info = array();
	
		$shop_info['shop_name'] = $this->shop_name;
		$shop_info['shop_desc'] = $this->shop_desc;
		$shop_info['province_code'] = $this->province_code;		
		$shop_info['city_code'] = $this->city_code; 
		$shop_info['town_code'] = $this->town_code; 
		$shop_info['shop_address'] = $this->shop_address;
		$shop_info['industry_id'] = $this->industry_id;
		$shop_info['shop_class'] = $this->shop_class; 
		$shop_info['contact_no'] = $this->contact_no;
		$shop_info['avg_cost'] = $this->avg_cost; 
		$shop_info['status'] = $this->industry_id; 
		$shop_info['add_time'] = date('YmdHis'); 


		$file_image = array();
		$ext = "";
		$resp_desc = "商户推荐成功。";
		if(!empty($_FILES['image_1']))//图片1上传
		{
			$ext = $this->get_file_extension($_FILES["image_1"]["name"]);
			$_FILES["image_1"]["name"]=date('YmdHis').mt_rand(1000,9999).".".$ext;
			$resp = UpLoadfileByOss($_FILES["image_1"]);
			if($resp['sucess']=='1')
			{
					$shop_info['image_1'] = $resp['msg'];
			}
			else
			{
				$resp_desc = $resp_desc."图片1上传失败!";//图片上传失败单商户可以创建
			}
		}

		if(!empty($_FILES['image_2']))//图片2上传
		{

			$ext = $this->get_file_extension($_FILES["image_2"]["name"]);
			$_FILES["image_2"]["name"]=date('YmdHis').mt_rand(1000,9999).".".$ext;
			$resp = UpLoadfileByOss($_FILES["image_2"]);
			if($resp['sucess']=='1')
			{
					$shop_info['image_2'] = $resp['msg'];
			}
			else
			{
				$resp_desc = $resp_desc."图片2上传失败!";//图片上传失败单商户可以创建
			}
		}

		if(!empty($_FILES['image_3']))//图片3上传
		{

			$ext = $this->get_file_extension($_FILES["image_3"]["name"]);
			$_FILES["image_3"]["name"]=date('YmdHis').mt_rand(1000,9999).".".$ext;
			$resp = UpLoadfileByOss($_FILES["image_3"]);
			if($resp['sucess']=='1')
			{
					$shop_info['image_3'] = $resp['msg'];
			}
			else
			{
				$resp_desc = $resp_desc."图片3上传失败!";//图片上传失败单商户可以创建
			}
		}

		if(!empty($_FILES['image_4']))//图片4上传
		{

			$ext = $this->get_file_extension($_FILES["image_4"]["name"]);
			$_FILES["image_4"]["name"]=date('YmdHis').mt_rand(1000,9999).".".$ext;
			$resp = UpLoadfileByOss($_FILES["image_4"]);
			if($resp['sucess']=='1')
			{
					$shop_info['image_4'] = $resp['msg'];
			}
			else
			{
				$resp_desc = $resp_desc."图片4上传失败!";//图片上传失败单商户可以创建
			}
		}

		if(!empty($_FILES['image_5']))//图片1上传
		{
			$ext = $this->get_file_extension($_FILES["image_5"]["name"]);
			$_FILES["image_5"]["name"]=date('YmdHis').mt_rand(1000,9999).".".$ext;
			$resp = UpLoadfileByOss($_FILES["image_5"]);
			if($resp['sucess']=='1')
			{
					$shop_info['image_5'] = $resp['msg'];
			}
			else
			{
				$resp_desc = $resp_desc."图片5上传失败!";//图片上传失败单商户可以创建
			}
		}
		
		$rs = M('Tshop')->add($shop_info);
		if(!$rs)
		{
			$this->returnError("商户入库失败", '1001');	
		}

		$this->returnSuccess($resp_desc);
	}
	
	private function check(){		
		if($this->shop_name == '')
		{
			return array('resp_desc'=>'商户名称不能为空！');
			return false;
		}
		if($this->shop_address == '')
		{
			return array('resp_desc'=>'商户地址不能为空！');
			return false;
		}

		return true;
	}	
}
?>