<?php
/**
 * 功能：活动编辑（含活动取消、活动回顾、变更发起人）
 * @author siht
 * 时间：2016-02-10
 */
class ActivityModifyAction extends BaseAction 
{
	//接口参数
	public $activity_id; //活动id
	public $activity_status;//活动状态
	public $user_id;//发起人id
	public $new_user_id;//转让人id
	public $evaluate_text;//活动回顾信息


	public function _initialize(){
		parent::_initialize();
		$this->checkSign();

		$this->activity_id = I('activity_id'); //活动id
		$this->activity_status = I('activity_status'); //活动状态，
		$this->user_id = I('user_id'); //发起人id
		$this->new_user_id = I('new_user_id');//转让人id
		$this->evaluate_text = I('evaluate_text');//回顾信息,涉及到中文信息进行urlencoed
		
	}
		
	public function run() {
		$rs = $this->check(); 
		if($rs!==true){
			$this->returnError($rs['resp_desc']);
		}

		//相关变更操作只有发起人可以操作
		$activity = D("Activity",'Service');
		$where = "id = ".$this->activity_id." and user_id = ".$this->user_id;
		$activity_info = $activity->getActivityInfo($where);
		if(empty($activity_info)){
			$this->returnError('找不到本用户创建的该活动', '1004');
		}

		//当活动为完结状态，不可做变更
		if($activity_info['activity_status'] == '4')
		{
			$this->returnError('活动已结束！', '1005');
		}
		else if($activity_info['activity_status'] == '5')
		{
			$this->returnError('活动募集失败！', '1006');
		}
		else if($activity_info['activity_status'] == '9')
		{
			$this->returnError('活动已取消！', '1007');
		}
		

		$activity_new = array();
		//取消活动
		if($this->activity_status == '9')
		{
			if($activity_info['activity_status'] >= '3')
			{
				$this->returnError('活动已发生或已取消，不可取消！', '1006');
			}

			$activity_new['activity_status'] = $this->activity_status;
			$rs = M('Tactivity')->where($where)->save($activity_new);
			if(!$rs)
			{
				$this->returnError('更新活动失败！', '1017');
			}
			$this->returnSuccess('活动取消成功');

		}
		else if($this->activity_status == '4')//发布活动回顾，活动结束
		{
			if($activity_info['activity_status'] != '3')
			{
				$this->returnError('尚未发生的活动，不可回顾！', '1006');
			}
		

			//解析回顾信息	
			$evaluate_array=explode('^',$this->evaluate_text);//评价内容^赞列表^踩列表
			$evaluate_text = urldecode($evaluate_array[0]);//中文url_encode后传入	

			//记录发起者对参与者相关赞和踩评价明细
			$evaluate_detail = array();
			$evaluate_detail['activity_id'] = $this->activity_id;
			$evaluate_detail['add_time'] = date('YmdHis');

			if(!empty($evaluate_array[1]))//赞
			{
				$join_good_array=explode(',',$evaluate_array[1]);
				foreach($join_good_array as $good_user_id)
				{
					$evaluate_detail['user_id'] = $good_user_id;
					$evaluate_detail['activity_id'] = $this->activity_id;
					$evaluate_detail['user_type'] = 1;
					$evaluate_detail['score_type'] = 1003;//发起者赞参与者
					$evaluate_detail['score'] = 1;
					$evaluate_detail['note'] = "[".$activity_info['activity_name']."]发起者赞：+1";
					$rs = M('TuserUcoinDetail')->add($evaluate_detail);
					if(!$rs)
					{
						$this->returnError('添加点赞流水失败！', '2017');
					}

					//参与者好评统计赞+1
					$where = "user_id = ".$good_user_id;
					
					$user_ucoin_stat =array();
					$user_ucoin_stat['user_id'] = $good_user_id;
					
					$rs = M('TuserUcoinStat')->where($where)->find();
					if(empty($rs))
					{
						$user_ucoin_stat['join_good_sum']=1;
						$rs =  M('TuserUcoinStat')->add($user_ucoin_stat);
					}
					else
					{
						$rs = M('TuserUcoinStat')->where($where)->setInc('join_good_sum',1);
						if(!$rs)
						{
							$this->returnError('统计点赞数失败！', '2018');
						}
					}
				}
			}
			if(!empty($evaluate_array[2]))//踩
			{
				$join_bad_array=explode(',',$evaluate_array[2]);
				foreach($join_bad_array as $bad_user_id)
				{	
					$evaluate_detail['user_id'] = $bad_user_id;
					$evaluate_detail['user_type'] = 1;
					$evaluate_detail['score_type'] = 1004;//发起者踩参与者
					$evaluate_detail['score'] = 1;
					$evaluate_detail['note'] = "[".$activity_info['activity_name']."]发起者踩：+1";
					$rs = M('TuserUcoinDetail')->add($evaluate_detail);
					if(!$rs)
					{
						$this->returnError('添加点踩流水失败！', '2017');
					}

					//参与者差评统计踩+1
					$where = "user_id = ".$bad_user_id;

					$user_ucoin_stat =array();
					$user_ucoin_stat['user_id'] = $bad_user_id;
					
					$rs = M('TuserUcoinStat')->where($where)->find();
					if(empty($rs))
					{
						$user_ucoin_stat['join_bad_sum']=1;
						$rs =  M('TuserUcoinStat')->add($user_ucoin_stat);
					}
					else
					{
						$rs = M('TuserUcoinStat')->where($where)->setInc('join_bad_sum',1);
						if(!$rs)
						{
							$this->returnError('统计点踩数失败！', '2018');
						}
					}
				}
			}

			


			//记录发起者回顾流水
			$activity_evaluate = array();
			$activity_evaluate['activity_id'] = $this->activity_id;
			$activity_evaluate['user_id'] = $this->user_id;
			$activity_evaluate['type'] = 0;
			$activity_evaluate['evaluate_text']=$evaluate_text;

			//记录回顾图片
			if(!empty($_FILES['image_1']))//图片1上传
			{
				$ext = $this->get_file_extension($_FILES["image_1"]["name"]);
				$_FILES["image_1"]["name"]=date('YmdHis').mt_rand(1000,9999).".".$ext;
				$resp = UpLoadfileByOss($_FILES["image_1"]);
				if($resp['sucess']=='1')
				{
						$activity_evaluate['image_1'] = $resp['msg'];
				}
				else
				{
					$this->returnError('添加活动回顾图片1失败！', '2028');
				}
			}

			if(!empty($_FILES['image_2']))//图片2上传
			{
				$ext = $this->get_file_extension($_FILES["image_2"]["name"]);
				$_FILES["image_2"]["name"]=date('YmdHis').mt_rand(1000,9999).".".$ext;
				$resp = UpLoadfileByOss($_FILES["image_2"]);
				if($resp['sucess']=='1')
				{
						$activity_evaluate['image_2'] = $resp['msg'];
				}
				else
				{
					$this->returnError('添加活动回顾图片2失败！', '2028');
				}
			}

			if(!empty($_FILES['image_3']))//图片1上传
			{
				$ext = $this->get_file_extension($_FILES["image_3"]["name"]);
				$_FILES["image_3"]["name"]=date('YmdHis').mt_rand(1000,9999).".".$ext;
				$resp = UpLoadfileByOss($_FILES["image_3"]);
				if($resp['sucess']=='1')
				{
						$activity_evaluate['image_3'] = $resp['msg'];
				}
				else
				{
					$this->returnError('添加活动回顾图片3失败！', '2028');
				}
			}

			$rs = M('TactivityEvaluate')->add($activity_evaluate);
			if(!$rs)
			{
				$this->returnError('添加活动回顾信息失败！', '2018');
			}

			//发起者经验积分流水
			$evaluate_detail['user_id'] = $this->user_id;
			$evaluate_detail['user_type'] = 0;
			$evaluate_detail['score_type'] = 2001;//发起者经验
			$evaluate_detail['score'] = 1;
			$evaluate_detail['note'] = "[".$activity_info['activity_name']."]发起者回顾：经验+1";
			$rs = M('TuserUcoinDetail')->add($evaluate_detail);
			if(!$rs)
			{
				$this->returnError('添加发起者流水失败！', '2017');
			}
			
			//发起者经验统计+1
			$where = "user_id = ".$this->user_id;

			$rs = M('TuserUcoinStat')->where($where)->find();
			if(empty($rs))
			{
				$stat_new = array();
				$stat_new['user_id']= $this->user_id;
				$stat_new['creator_coin']=1;
				$rs =  M('TuserUcoinStat')->add($stat_new);
			}
			else
			{
				$rs = M('TuserUcoinStat')->where($where)->setInc('creator_coin',1);
				if(!$rs)
				{
					$this->returnError('统计发起者积分失败！', '2018');
				}
			}

			//更新活动状态为活动结束
			$activity_new['activity_status'] = $this->activity_status;
			$rs = M('Tactivity')->where($where)->save($activity_new);
			if(!$rs)
			{
				$this->returnError('更新活动失败！', '1017');
			}
			$this->returnSuccess('活动回顾成功');
		}
		//转让活动
		else if(isset($this->new_user_id) && $this->new_user_id !='')
		{
			if($activity_info['activity_status'] == '3')
			{
				$this->returnError('活动已发生，不可转让！', '1006');
			}
			$activity_new['user_id'] = $this->new_user_id;
			$rs = M('Tactivity')->where($where)->save($activity_new);
			if(!$rs)
			{
				$this->returnError('更新活动失败！', '1017');
			}

			//被转让者如是参与者，则取消其参与者身份信息
			$where_info = "activity_id = ".$this->activity_id." and user_id = ".$this->new_user_id;
			$user_join = array();
			$user_join['user_status'] = '4';
			$rs = M('TactivityUser')->where($where_info)->save($user_join);

			$this->returnSuccess('活动转让成功');
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
		
		return true;
	}	
}
?>