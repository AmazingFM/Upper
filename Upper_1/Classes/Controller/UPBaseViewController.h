//
//  UPBaseViewController.h
//  Upper
//
//  Created by freshment on 16/6/5.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWHttpTool.h"
#import "UPDataManager.h"
#import "Info.h"    
#import "UPGlobals.h"


@interface UPBaseViewController : UIViewController

@property (nonatomic, retain) id parentController;
- (void)checkNetStatus;
- (void)refresh;
- (void)willShowSlideView;
@end


@interface UPBaseWebViewController : UPBaseViewController

@property (nonatomic, copy) NSString *urlString;

- (void)loadWithURLString:(NSString *)urlString;

@end

@interface UPBaseTableViewController :UITableViewController
@end
