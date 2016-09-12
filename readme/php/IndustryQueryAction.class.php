<?php
/**
 * 功能：行业查询
 * @author siht
 * 时间：2015-07-31
 */

class IndustryQueryAction extends BaseAction
{
	//接口参数
	public $query_count;//查询数

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();
	
		$this->$query_count = 0;
		
	}

	public function run() {
		
		$rs = $this->check();
		if($rs!==true){
			$this->returnError($rs['resp_desc'],'9002');
		}
		
		$where = "2 > 1";
		$industry_list = M('Tindustry')->field('id,industry_code,industry_name,note')->where($where)->select();
		
		$this->returnSuccess("查询成功",array("total_count"=>count($industry_list),"industry_list"=>$industry_list));
	}

	

	private function check(){
		return true;
	}
}
?>