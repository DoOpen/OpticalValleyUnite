//
//  URLPath.swift
//  Dentist
//
//  Created by 贺思佳 on 2016/12/26.
//  Copyright © 2016年 贺思佳. All rights reserved.
//

import Foundation

// 所有的网络请求的地址的类:
// 项目要求的 整体的测试环境有四种:
/*
 
 1.生产环境: http://portal.ovuems.com/
 
 2.演示环境: http://demo.ovuems.com/
 3.测试环境: http://test.ovuems.com/
 4.开发环境: http://dev.ovuems.com/
 
 5.新版的试点环境: http://beta.ovuems.com/
 
 6.新版的测试库环境: http://172.16.19.98:4399/
 
 */


struct URLPath {
//    static let basicPath = "http://112.74.80.111:8888/ovu-pcos/api/"
    ///主机地址
//    static let basicPath = "http://portal.ovuems.com/ovu-pcos/api/"
    ///新版测试服务器的域名 http://172.16.19.98:8091
    ///新版正式服 : http://116.62.117.82:2018
    ///元元 : http://172.16.11.76
    ///谢俊杰: http://172.16.11.63:8080  xiejunjie
    ///建丰 : "http://172.16.11.62:80"
    
    
    ///正式服的域名链接: http://ovuems.com
    ///测试服的域名链接: http://ovuems.com/ovu-base
    
    //服务器的basicBasicPath
    static let basicBasic = "http://172.16.19.98:8091"
    
    //服务器的basic 地址:
    static let basicPath = basicBasic + "/ovu-pcos/api/"
    static let basicVideoURLPath = basicBasic + "/"
    
    //服务器拆分的接口 newbasicPath
    static let newbasicPath = basicBasic + "/ovu-base/api/"
    
    static let login = "user/login.do"
    static let systemMessage = "message/importentMsg.do"
    static let getWorkunitList = "workunit/workunitList.do"
    
    static let getParkList = "user/getParkList.do"
    static let getWorkOrderStatic = "workunit/workunitStaticByMonth.do"
    static let updatepwd = "user/updatepwd.do"
    static let updateLocation = "position/loadPersonPosition.do"
    
    //工单详情 < <--接口有变动 --> >!!!
    static let getWorkDetail = "workunit/workunitDetailById.do"
    
    static let getWorkTypeList = "workunit/getWorkTypeList.do"
    
    //子系统选择图片服务器的地址(所有的图片)(子系统选择和 图片上传所有的图片URL)
    static let systemSelectionURL = basicBasic + "/ovu-base/"


    //获取配件库主页数据接口
    static let getPartsHome = "parts/list.do"
    
    //获取子系统选择的接口
    static let getSystemSelection = "module/getModuleAndAppRes.do"
    
    //获取督办接口
    static let getSurveillanceWorkOrderList = "workunit/workunitSuperviseList.do"
    //获取房屋空间信息
    static let getParkInfoById = "user/getParkInfoById.do"
    //报事类型判断
    static let typeOfReportMaster = "module/getModules.do"
    //报事提交
    static let reportMaster = "workunit/workunitEmerSave.do"
    
    static let batchsetSupervisestatus = "workunit/batchsetSupervisestatus.do"
    //获取读完工单数量
    static let getStaticWorkunitDB = "workunit/getStaticWorkunitDB.do"
    
    //签到接口
    static let sign = "person/savePersonSign.do"
    
    //获取人员信息
    static let getPersonList = "person/personList.do"
    
    //工单派发
    static let workunitDistribute = "workunit/workunitDistribute.do"
    
    //工单操作
    static let workunitExecuSave = "workunit/workunitExecuSave.do"
    //工单操作
    static let workunitExecuSave2 = "workunit/workunitExecuSave2.do"
    //工单操作的接口
    static let workunitExecu  = "workunit/WorkunitExec.do"
    
    
    //计划工单的保存 (<--接口有变动-->)
    static let workunitOpera = "workunit/workunitOpera.do"
    
    
    ///工单退回
    static let workunitReturn = "workunit/WorkunitReturn.do"
    
    
    ///工单执行列表 (<-- 接口有变动 -->)
    static let getTaskList = "workunit/getTaskListById2.do"
    
    ///上传图片
    static let uploadImage = "uploadImg"
    /// uploadImg  新版上传接口
    /// workunit/imgs.do 旧版上传图片接口
    
    
    ///获取签到记录
    static let getPersonSinList = "person/getPersonSinList.do"
    ///获取定位记录
    static let getPersonPosList = "person/getPersonPosList.do"
    
    ///工单步骤执行
    static let workunitExec = "workunit/WorkunitExec.do"
    
    ///工单评价
    static let evaluateSave = "workunit/evaluateSave.do"
    
    ///退出的接口
    static let logOut = "user/logout.do"
    
    ///多个工单步骤执行
    static let workunitExecMany = "workunit/workunitOpera.do"
    ///获取权限
    static let getModules = "module/getModules.do"
    
    //获取去版本
    static let getVersion = "workunit/getVersion.do"
    
    //获取报事记录
    static let getReportList = "workunit/myworkunitList.do"
    
    
    //获取项目地址
    static let getParkAddress = "position/getParkDescription.do"
    
    //签到次数
    static let getSignCount = "person/getSignCount.do"
    
    //获取设备详情
    static let getEquipmentDetail = "workunit/equipmentDetail.do"
    
    //获取个人详情
    static let getPersonInfo = "person/getPersonInfo.do"
    
    ///保存照片
    static let savePersonIcon = "person/savePersonIcon.do"
    
    ///获取通知列表
    static let getNoticeList = "notice/list.do"
    
    ///获取设备列表
    static let getListEquipment = "workunit/listEquipment.do"
    
    ///获取设备的工单
    static let getEquipmentWorkunit = "workunit/getEquipmentWorkunit.do"
    

    // MARK: - 消防专业化的接口参数
    static let getFireAmount = "fire/workunit/amount.do"
    static let getFireList  = "fire/workunit/list.do"
    static let getFireDetail = "fire/workunit/detail.do"
    static let getFireLocation = "fire/firepoint/list.do"
    //获取火警点执行动态
    static let getFireState = "fire/firepoint/state.do"
    //前往执行、放弃执行
    static let getFireExecute = "fire/firepoint/execute.do"
    //执行反馈接口
    static let getFirefeedback = "fire/workunit/feedback.do"
    
    // MARK: - 日志模块的接口参数
    // list主页接口
    static let getWorklogList = "worklog/list.do"
    // list添加新增接口
    static let getAddWorklog = "worklog/add.do"
    // list显示删除接口
    static let getDeleteWorklog = "worklog/delete.do"
    // list日志查看的接口
    static let getCheckWorklogDetail = "worklog/detail.do"
    
    
    // 待办事项接口
    static let getTodoWorklogList = "worklog/todo/list.do"
    // 待办事项的新增修改 接口
    static let getTodoWorklogEdit = "worklog/todo/edit.do"
    // 待办事项的删除接口
    static let getTodoWorklogDelete = "worklog/todo/delete.do"
    
    
    //筛选界面的接口
    //项目
    static let getFilterParkList = "worklog/park/list.do"
    //部门
    static let getFilterDeptList = "worklog/dept/list.do"
    //对象
    static let getFilterPersonList = "worklog/person/list.do"
    //日志工单
    static let getWorkunitList2 = "workunit/workunitList2.do"
    
    
    // MARK: - 计步器的功能接口
    //保存数据
    static let getSavePedometerData = "pedometer/save"
    //排行榜
    static let getRankPedometer = "pedometer/rank"
    //我的步数
    static let getMinePedometer = "pedometer/mysteps"
    //我的历史步数
    static let getHistorysteps = "pedometer/historysteps"
    //zan(点赞的接口)
    static let getPedometerZan = "pedometer/zan"
    
    
    // MARK: - 视频巡查的功能接口
    //获取楼栋的ID
    static let getVideoPatrolMap = "quality/humanins/getMap"
    //获取室内点楼栋的层数
    static let getVideoPatrolFloorNum = "quality/humanins/getFloorNum"
    //获取室内点的执行点
    static let getVideoPatrolPoint = "quality/humanins/getInnerPointList"
    //获取开始点的判断
    static let getVideoPatrolCheckBegin = "quality/humanins/checkBegin"
    //查询巡查路线名称
    static let getVideoPatrolLoadWayName  = "quality/insway/loadWayName"
    //查询所有巡查项类型
    static let getVideoPatrolAllItemType = "quality/humanins/getAllItemType"
    
    //查询巡查路线条件(点击完成的情况)
    static let getVideoPatrolMapByType = "quality/humanins/loadWayMapByType"
    //获取直播地址的情况
    static let getVideogetLive = "quality/humanins/getLive"
    //获取巡查点获取巡查项整体的内容
    static let getVideoItemFormByPointId = "quality/humanins/getInsItemFormByPointId"
    //保存提交,复合提交选项
    static let getVideoItemSaveResult = "quality/humanins/saveResult"
    
    
    ///巡查结果展示所有的数据接口
    //分页查看巡查结果
    static let getResultList = "quality/insresult/list"
    //巡查结果详情
    static let getResultDetail  = "quality/insresult/detail"
    //巡查轨迹
    static let getResultInsOrbitList  = "quality/humanins/getInsOrbitList"
    
    ///门禁管理的接口
    //蓝牙开门成功之后的,保存的接口
    static let getopenDoorByBlueTooth = "acs/openDoorByBlueTooth"
    //list 通过调用获取相应的 开门的权限的接口
    static let getAuthEquipmentList = "acs/getAuthEquipmentList"
    //动态密码开门的接口
    static let getdynPwdOpenDoor  = "acs/dynPwdOpenDoor"
    ///二维码开门接口调试
    //开门反扫list的接口
    static let getQrAuthEquipmentList = "acs/getQrAuthEquipmentList"
    //二维码开门的接口
    static let getOpenDoorByQrCode = "acs/openDoorByQrCode"
    
    
    ///离线工单的接口
    //下载离线工单
    static let getDownloadOfflineUnits = "workunit/downloadOfflineUnits"
    //上传离线工单
    static let getUploadOfflineUnits = "workunit/uploadOfflineUnits"
    //上传图片的接口
    static let getUploadUnits = "workunit/uploadOfflineImg"
    
    
    ///日报,周报,月报的接口列表
    static let getReportFormList = "report/list"
    //工单统计查询 //员工工单详情查询
    static let getReportWorkUnitQuery = "workUnit/query"
    //获取人员列表
    static let getReportWorkUnitPList = "workUnit/personList"
    //获取月报的工作亮点的情况
    static let getReportWorkHighlights = "report/get"
    //工作计划添加或工作亮点
    static let getReportAdd = "report/add"
    
    ///装修管理的接口列表
    //首页的list列表接口
    static let getDecorationList = "decorationworkunit/list"
    //查询项目期的接口
    static let getDecorationStage = "decorationworkunit/stage"
    //查询获取期下的楼栋信息
    static let getDecorationFloor = "decorationworkunit/floor"
    //获取楼栋下的房屋信息
    static let getDecorationHouse = "decorationworkunit/house"
    //获取单元号的房屋信息
    static let getDecorationUnitNo =  "decorationworkunit/unitNo"
    
    ///房屋查询接口列表
    //首页list列表接口
    static let getHouseList = "owner/list"
    //筛选条件的接口
    //根据项目id 查项目区期数
    static let getParkStage = "owner/park/stage"
    //根据查询期数下的楼栋
    static let getParkFloor = "owner/park/floor"
    //查询楼栋下的单元
    static let getParkUnitNu = "owner/park/unitNu"
    //查询单元下楼层
    static let getParkGroundNo = "owner/park/groundNo"
    //查询楼层下房屋
    static let getParkHouse = "owner/park/house"
    
    //业主信息的查询
    static let getHouseGet = "owner/house/get"
    
    //业主信息的详情查询
    static let getRelativeList  = "owner/relative/list"
    //设备信息的接口的查询
    static let getEquipList = "owner/equip/list"
    //工单的设备的显示
    static let getSourchUnit = "owner/sourchUnit/list"
    
    
}
