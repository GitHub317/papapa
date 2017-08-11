//
//  PaPaPaHeader.h
//  papapa
//
//  Created by 二师兄 on 2017/8/11.
//  Copyright © 2017年 Ershixiong. All rights reserved.
//

#ifndef PaPaPaHeader_h
#define PaPaPaHeader_h

//快速定义masory中的部分参数
#define M_LEFT make.left
#define M_RIGHT make.right
#define M_TOP make.top
#define M_BOTTOM make.bottom

#define M_CENTER_X make.centerX
#define M_CENTER_Y make.centerY

#define MAS_TOP(float) make.top.offset(float)
#define MAS_BOTTOM(float) make.bottom.offset(float)
#define MAS_LEFT(float) make.left.offset(float)
#define MAS_RIGHT(float) make.right.offset(float)

#define MAS_HEIGHT(float) make.height.offset(float)
#define MAS_WIDTH(float) make.width.offset(float)
#define MAS_CENTER_Y(float) make.centerY.offset(float)
#define MAS_CENTER_X(float) make.centerX.offset(float)

//判断iphone4/4S
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iphone5/5S
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iphone6
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iphone6+
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//快速注册tableviewcell
#define ESX_RegistCell(tableView,cellName) [tableView registerNib:[UINib nibWithNibName:cellName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellName];
//快速创建cell
#define ESX_InitCell(cellName,cellID) cellName * cell = [tableView dequeueReusableCellWithIdentifier:cellID];if (!cell) {cell = [[cellName alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];}


// .h文件快速  加载nib
#define ESX_LoadNib_H(ClassName)+ (ClassName *)loadNib;
// .m文件快速  加载nib
#define ESX_LoadNib_M(ClassName,NibName)+ (ClassName *)loadNib{NSArray * nibView = [[NSBundle mainBundle] loadNibNamed:NibName owner:nil options:nil];return [nibView objectAtIndex:0];}



#endif /* PaPaPaHeader_h */
