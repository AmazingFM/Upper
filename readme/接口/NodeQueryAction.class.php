<?php
/**
 * 功能：机构查询
 * @author siht
 * 时间：2015-07-31
 */

class NodeQueryAction extends BaseAction
{
	//接口参数
	public $industry_id;
	public $city_code;
	public $query_count;//查询数

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();
	
		$this->industry_id = I('industry_id');
		$this->city_code = I('city_code');
		$this->query_count = I('query_count',0);
		
	}

	public function run() {
		
		$rs = $this->check();
		if($rs!==true){
			$this->returnError($rs['resp_desc'],'9002');
		}
		
		$where = "2 > 1";

		if(isset($this->industry_id) && $this->industry_id !=''){
			$where .= " and industry_id = ".$this->industry_id; 
		}
		if(isset($this->city_code) && $this->city_code !=''){
			$where .= " and (city_code = '".$this->city_code."' OR city_code = '')"; 
		}
		if($this->query_count > 0)
		{
			$node_list = 
			M('Tnode')->field('id,node_name,node_email_suffix')->where($where)->order("city_code desc")->limit($this->query_count)->select();

		}
		else
		{
			$node_list = //M('Tnode')->field('id,node_name,node_desc,province_code,city_code,town_code,node_address,node_email_suffix,industry_id')->where($where)->order("city_code desc")->select();
			M('Tnode')->field('id,node_name,node_email_suffix')->where($where)->order("city_code desc")->select();
		}
		
		$this->returnSuccess("查询成功",array("total_count"=>count($node_list),"node_list"=>$node_list));
	}

	

	private function check(){
		return true;
	}
}
?>