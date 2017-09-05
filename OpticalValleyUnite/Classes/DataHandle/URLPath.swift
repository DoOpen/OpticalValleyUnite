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
 
 */


struct URLPath {
//    static let basicPath = "http://112.74.80.111:8888/ovu-pcos/api/"
    ///主机地址
//    static let basicPath = "http://portal.ovuems.com/ovu-pcos/api/"
    //服务器的basic 地址:
    static let basicPath = "http://demo.ovuems.com/ovu-pcos/api/"

    static let login = "user/login.do"
    static let systemMessage = "message/importentMsg.do"
    static let getWorkunitList = "workunit/workunitList.do"
    static let getParkList = "user/getParkList.do"
    static let getWorkOrderStatic = "workunit/workunitStaticByMonth.do"
    static let updatepwd = "user/updatepwd.do"
    static let updateLocation = "position/loadPersonPosition.do"
    static let getWorkDetail = "workunit/workunitDetailById.do"
    static let getWorkTypeList = "workunit/getWorkTypeList.do"
    
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
    
    //计划工单的保存
    static let workunitOpera = "workunit/workunitOpera.do"
    
    ///工单退回
    static let workunitReturn = "workunit/WorkunitReturn.do"
    
    ///工单执行列表
    static let getTaskList = "workunit/getTaskListById.do"
    
    ///上传图片
    static let uploadImage = "workunit/imgs.do"
    
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
}
