<?php
/**
 * 功能：用户查询
 * @author siht
 * 时间：2016-04-17
 */

class UserQueryAction extends BaseAction
{
	//接口参数
	public $user_id;  //用户id
	public $qry_usr_id;//查询的用户id
	
	

	public function _initialize(){
		parent::_initialize();
		$this->checkSign();
		//动态载入 UserLevel 配置文件
		C('UserLevel',require(CONF_PATH.'configUserLevel.php'));

		$this->user_id = I('user_id');
		$this->qry_usr_id = I('qry_usr_id');
				
	}

	public function run() {
		
		$rs = $this->check();
		if($rs!==true){
			$this->returnError($rs['resp_desc'],'9002');
		}
		
		//1.查用户基本信息
		$where = "id = ".$this->qry_usr_id;
		$field = array('id','node_id','industry_id','true_name','sexual','birthday','user_icon','nick_name','user_desc');
		if($this->user_id == $this->qry_usr_id)//自己查自己可返回用户二维码（用户中心可用）
		{
			$field = array('id','node_id','industry_id','true_name','sexual','birthday','user_icon','nick_name','user_desc','user_image');
		}

		$user_info = M('Tuser')->field($field)->where($where)->find();
		if(empty($user_info))
		{
			$this->returnError('用户不存在','9011');
		}

		//2.查用户积分信息
		$where = "user_id = ".$this->qry_usr_id;
		$user_ucoin = M('TuserUcoinStat')->where($where)->field('IFNULL(join_coin,0) AS join_coin,IFNULL(creator_coin,0) AS creator_coin, IFNULL(join_good_sum,0) AS join_good_sum,IFNULL(join_mid_sum,0) AS join_mid_sum, IFNULL(join_bad_sum,0) AS join_bad_sum,IFNULL(creator_good_sum,0) AS creator_good_sum,IFNULL(creator_mid_sum,0) AS creator_mid_sum,IFNULL(creator_bad_sum,0) AS creator_bad_sum')->find(); 

		if(!$user_ucoin)
		{
			$user_ucoin = array(
				'join_coin'=>0,
				'creator_coin'=>0,
				'join_good_sum'=>0,
				'join_mid_sum'=>0,
				'join_bad_sum'=>0,
				'creator_good_sum'=>0,
				'creator_mid_sum'=>0,
				'creator_bad_sum'=>0,
				);
		}
		$join_sum = $user_ucoin['join_good_sum'] + $user_ucoin['join_mid_sum'] + $user_ucoin['join_bad_sum'];
		$creator_sum = $user_ucoin['creator_good_sum'] + $user_ucoin['creator_mid_sum'] + $user_ucoin['creator_bad_sum'];
		
		$user_info['join_good_sum']=$user_ucoin['join_good_sum'];
		$user_info['join_bad_sum']=$user_ucoin['join_bad_sum'];
		//参与者好评率
		if($join_sum > 0)
		{
			$user_info['join_good_rate'] = round(($user_ucoin['join_good_sum']/$join_sum ),4);
		}
		else
		{
			$user_info['join_good_rate'] = 0;
		}
		//发起者好评率
		if($creator_sum > 0)
		{
			$user_info['creator_good_rate'] = round(($user_ucoin['creator_good_sum']/$creator_sum ),4);;
		}
		else
		{
			$user_info['creator_good_rate'] = 0;
		}
		$user_info['join_coin'] = $user_ucoin['join_coin'];
		$user_info['creator_coin'] = $user_ucoin['creator_coin'];

		$user_level_arr = C('UserLevel');
		//发起者级别
		$creator_arr = $user_level_arr['CREATOR_COIN'];
		$creator_group = $user_level_arr['CREATOR_GROUP'];

		$creator_coin = $user_info['creator_coin'];
		$creator_level = 1;
		switch($creator_coin)
		{
			case 0:
			case $creator_coin < $creator_arr[1]:
				$creator_level = 1;
				break;
			case $creator_coin < $creator_arr[2]:
				$creator_level = 2;
				break;
			case $creator_coin < $creator_arr[3]:
				$creator_level = 3;
				break;
			case $creator_coin < $creator_arr[4]:
				$creator_level = 4;
				break;
			default:
				$creator_level = 5;
				break;
		}
		$user_info['creator_level'] = $creator_level;
		$user_info['creator_group'] = $creator_group[$creator_level];
		
		//参与者级别
		$join_arr = $user_level_arr['JOIN_COIN'];
		$join_group = $user_level_arr['JOIN_GROUP'];

		$join_coin = $user_info['join_coin'];
		$join_level = 1;
		switch($join_coin)
		{
			case 0:
			case $join_coin < $join_arr['1']:
				$join_level = 1;
				break;
			case $join_coin < $join_arr['2']:
				$join_level = 2;
				break;
			case $join_coin < $join_arr['3']:
				$join_level = 3;
				break;
			case $join_coin < $join_arr['4']:
				$join_level = 4;
				break;
			default:
				$join_level = 5;
				break;
		}
		$user_info['join_level'] =$join_level;
		$user_info['join_group'] = $join_group[$join_level];

		//3.查行业
		$where =  "id =". $user_info['industry_id'];
		$industry_info = M('Tindustry')->where($where)->field('industry_name')->find();
		if(!$industry_info)
		{
			$this->returnError('查询行业信息失败','9012');
		}
		else
		{
			$user_info['industry_name'] = $industry_info['industry_name'];
		}
		//4.查公司
		$where =  "id =". $user_info['node_id'];
		$node_info = M('Tnode')->where($where)->field('node_name,province_code,city_code')->find();
		if(!$node_info)
		{
			$this->returnError('查询公司信息失败','9012');
		}
		else
		{
			$user_info['node_name'] = $node_info['node_name'];
		}

		//5.查所在地
		$where =  "level =2 and province_code =". $node_info['province_code']." and city_code = ". $node_info['city_code'];
		$city_info = M('Tcity')->where($where)->field('province, city')->find();
		if(!$city_info)
		{
			$this->returnError('查询所在地信息失败','9012');
		}
		else
		{
			$user_info['province'] = $city_info['province'];
			$user_info['city'] = $city_info['city'];
		}

		$this->returnSuccess("查询用户信息成功",$user_info);
	}

	

	private function check(){
		if($this->user_id == '')
		{
			return array('resp_desc'=>'用户id不能为空！');
			return false;
		}
		if($this->qry_usr_id == '')
		{
			return array('resp_desc'=>'所查询的用户id不能为空！');
			return false;
		}
	
		return true;
	}
}
?>
