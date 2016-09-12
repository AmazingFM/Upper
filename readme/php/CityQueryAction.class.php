<?php
/**
 * 功能：省市区查询
 * @author siht
 * 时间：2015-07-31
 */

class CityQueryAction extends BaseAction
{
	//接口参数
	public $level;	//省市区级别
	public $province_code;//省编码
	public $city_code;//市编码
	public $town_code;//区编码
	public $query_count;//查询数

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();
	
		$this->level = I('level',2); 
		$this->province_code = I('province_code');
		$this->city_code = I('city_code');
		$this->town_code = I('town_code');
		$this->$query_count = 0;
		
	}

	public function run() {
		
		$rs = $this->check();
		if($rs!==true){
			$this->returnError($rs['resp_desc'],'9002');
		}
		
		$where = "level = ".$this->level;

		if(isset($this->province_code) && $this->province_code !=''){
			$where .= " and province_code = '".$this->province_code."'"; 
		}
		if(isset($this->city_code) && $this->city_code !=''){	
			$where .= " and city_code = '".$this->city_code."'"; 
		}
		if(isset($this->town_code) && $this->town_code !=''){
			$where .= " and town_code = '".$this->town_code."'"; 
		}
	
		$city_list = M('Tcity')->field('province_code,city_code,town_code,province,city,town,level,first_letter,note')->where($where)->order("first_letter asc")->select();
		
		$this->returnSuccess("查询成功",array("total_count"=>count($city_list),"city_list"=>$city_list));
	}

	

	private function check(){
		
		return true;
	}
}
?>