<?php
/**
 * 功能：参与者活动签到、取消、评价
 * @author siht
 * 时间：2016-04-10
 */
class ActivityJoinModifyAction extends BaseAction 
{
	//接口参数
	public $activity_id; //活动id
	public $user_id; //报名用户id
	public $user_status;//参与状态 1-签到 2-退出 5-评价
	public $evaluate_level_1;//评价1 1-好评 2-中评 3-差评 0-未评 针对活动发起人
	public $evaluate_level_2;//评价2 1-好评 2-中评 3-差评 0-未评 预留
	public $evaluate_level_3;//评价3 1-好评 2-中评 3-差评 0-未评 预留
	public $evaluate_text;//活动评价信息
	
	public function _initialize(){
		parent::_initialize();
		$this->checkSign();

		$this->user_id = I('user_id'); //用户id
		$this->activity_id = I('activity_id'); //活动id
		$this->user_status = I('user_status');//参与状态 1-签到 2-退出 5-评价
		$this->evaluate_level_1 = I('evaluate_level_1',0); 
		$this->evaluate_level_2 = I('evaluate_level_2',0); 
		$this->evaluate_level_3 = I('evaluate_level_3',0);  
		$this->evaluate_text = I('evaluate_text',0); 
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
		if($activity_info['activity_status'] == '4'
			|| $activity_info['activity_status'] == '9')
		{
			$this->returnError('活动已结束或已取消！', '1005');
		}
		
		

		//查询报名
		$where_info = "activity_id = ".$this->activity_id." and user_id = ".$this->user_id;
		$activity_user = M('TactivityUser')->where($where_info)->find();
		if(!empty($activity_user)){
			if($this->user_status == '1')//签到
			{
				if($activity_user['user_status'] == '2')
				{
					$this->returnError('已退出用户不能签到！', '1007');
				}
				else if($activity_user['user_status'] == '1')
				{
					$this->returnError('用户已签到！', '1008');
				}
				$msg = "签到成功";
			}
			else if($this->user_status == '2')//退出
			{
				if($activity_user['user_status'] == '2'
				 || $activity_user['user_status'] == '4')
				{
					$this->returnError('该参与者已退出！', '1007');
				}
				else if($activity_user['user_status'] == '3')
				{
					$this->returnError('未出席开始活动用户不能退出！', '1008');
				}
				else if($activity_user['user_status'] == '1')
				{
					$this->returnError('已签到用户不能退出！', '1009');
				}

				//活动的报名数-1
				$where = 'id = '.$this->activity_id;
				$rs = M('Tactivity')->setDec('part_count',$where,1);

				if($activity_info['part_count']-1 < $activity_info['limit_low'] && $activity_info['activity_status'] == 0)
				{
					 M('Tactivity')->setDec('activity_status',$where,1);//更新募集成功到募集期
				}

				$msg = "退出成功";
			}
			else if($this->user_status == '5')//评价
			{
				if($activity_user['user_status'] != '1')
				{
					$this->returnError('非签到用户不可评价！', '1010');
				}

				//记录活动评价信息
				$activity_evaluate = array();
				$activity_evaluate['activity_id'] = $this->activity_id;
				$activity_evaluate['user_id'] = $this->user_id;
				$activity_evaluate['type'] = 1;
				$activity_evaluate['evaluate_level_1']=$this->evaluate_level_1;
				$activity_evaluate['evaluate_level_2']=$this->evaluate_level_2;
				$activity_evaluate['evaluate_level_3']=$this->evaluate_level_3;
				$activity_evaluate['evaluate_text']=urldecode($this->evaluate_text);
				$rs = M('TactivityEvaluate')->add($activity_evaluate);
				if(!$rs)
				{
					$this->returnError('添加活动评价信息失败！', '2018');
				}

				//记录参与者评价流水
				$evaluate_detail = array();
				$evaluate_detail['user_id'] = $this->user_id;
				$evaluate_detail['activity_id'] = $this->activity_id;
				$evaluate_detail['user_type'] = 1;
				$evaluate_detail['score_type'] = 2002;//参与者评价
				$evaluate_detail['score'] = 1;
				$evaluate_detail['note'] = "[".$activity_info['activity_name']."]活动评价：经验+1";
				$rs = M('TuserUcoinDetail')->add($evaluate_detail);
				if(!$rs)
				{
					$this->returnError('添加参与者评价流水失败！', '2017');
				}

				//记录发起人被评价流水
				if($this->evaluate_level_1 == 1)
				{
					$evaluate_detail['score_type'] = 1001;//参与者好评发起人
					$evaluate_detail['note'] = "[".$activity_info['activity_name']."]活动好评：赞+1";
				}
				else if($this->evaluate_level_1 == 2)
				{
					$evaluate_detail['score_type'] = 1011;//参与者中评发起人
					$evaluate_detail['note'] = "[".$activity_info['activity_name']."]活动中评：+1";
				}
				else if($this->evaluate_level_1 == 3)
				{
					$evaluate_detail['score_type'] = 1002;//参与者差评发起人
					$evaluate_detail['note'] = "[".$activity_info['activity_name']."]活动差评：踩+1";
				}
				
				$evaluate_detail['user_id'] = $activity_info['user_id'];
				$evaluate_detail['activity_id'] = $this->activity_id;
				$evaluate_detail['user_type'] = 0;
				$evaluate_detail['score'] = 1;
				$rs = M('TuserUcoinDetail')->add($evaluate_detail);
				if(!$rs)
				{
					$this->returnError('添加参与者评价流水失败！', '2017');
				}
				
				//发起人评价统计+1
				$where = "user_id = ".$activity_info['user_id'];

				$user_ucoin_stat =array();
				$user_ucoin_stat['user_id'] = $activity_info['user_id'];
				
				if($this->evaluate_level_1 == 1)//发起者好评数+1
				{
					$rs = M('TuserUcoinStat')->where($where)->find();
					if(empty($rs))
					{
						$user_ucoin_stat['creator_good_sum']=1;
						$rs =  M('TuserUcoinStat')->add($user_ucoin_stat);
					}
					else
					{
						$rs = M('TuserUcoinStat')->where($where)->setInc('creator_good_sum',1);
						if(!$rs)
						{
							$this->returnError('统计评价数失败！', '2018');
						}
					}
				}
				else if($this->evaluate_level_1 == 2)//发起者中评数+1
				{
					$rs = M('TuserUcoinStat')->where($where)->find();
					if(empty($rs))
					{
						$user_ucoin_stat['creator_mid_sum']=1;
						$rs =  M('TuserUcoinStat')->add($user_ucoin_stat);
					}
					else
					{
						$rs = M('TuserUcoinStat')->where($where)->setInc('creator_mid_sum',1);
						if(!$rs)
						{
							$this->returnError('统计评价数失败！', '2018');
						}
					}
				}
				else if($this->evaluate_level_1 == 3)//发起者差评数+1
				{
					$rs = M('TuserUcoinStat')->where($where)->find();
					if(empty($rs))
					{
						$user_ucoin_stat['creator_bad_sum']=1;
						$rs =  M('TuserUcoinStat')->add($user_ucoin_stat);
					}
					else
					{
						$rs = M('TuserUcoinStat')->where($where)->setInc('creator_bad_sum',1);
						if(!$rs)
						{
							$this->returnError('统计评价数失败！', '2018');
						}
					}
				}

				//参与者参与者经验+1
				$where = "user_id = ".$this->user_id;
				$rs = M('TuserUcoinStat')->where($where)->find();
				if(empty($rs))
				{
					$stat_new = array();
					$stat_new['user_id']= $this->user_id;
					$stat_new['join_coin']=1;
					$rs =  M('TuserUcoinStat')->add($stat_new);
				}
				else
				{
					$rs = M('TuserUcoinStat')->where($where)->setInc('join_coin',1);
					if(!$rs)
					{
						$this->returnError('统计参与者积分失败！', '2018');
					}
				}

				$msg = "评价成功";
			}

			//参与者变更状态
			$user_join = array();
			$user_join['user_status'] = $this->user_status;
			$user_join['sign_time'] = date('YmdHis');

			$rs = M('TactivityUser')->where($where_info)->save($user_join);
			if(!$rs)
			{
				$this->returnError('更新失败！', '1017');
			}
			$this->returnSuccess($msg);
		}
		else
		{
			$this->returnError('未找到该报名人，不能签到！', '1009');
		}
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
		if($this->user_status == '')
		{
			return array('resp_desc'=>'用户状态不能为空！');
			return false;
		}
		return true;
	}	
}
?>