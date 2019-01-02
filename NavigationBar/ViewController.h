//
//  ViewController.h
//  NavigationBar
//
//  Created by Jack on 2018/12/29.
//

#import <UIKit/UIKit.h>
#import "LabelsTableViewCell.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width

static NSString * const cellID = @"cell";
static NSString * const title = @"台北市立動物園 植物資料";
static NSString *taipeiOpendata = @"https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire";
static NSString *zooPlantRID = @"rid=f18de02f-b6c9-47c0-8cda-50efad621c14";
static NSString *_offset = @"offset=";
NSString *urlZooPlant;
static NSInteger limit = 20;

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UIImageView *Image;
    UIImageView *barImage;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *plants;
@property (strong, nonatomic) NSMutableArray *cellList;
@property (nonatomic) NSInteger currentOffset;
@property (nonatomic) BOOL updated;
@property (strong, nonatomic) LabelsTableViewCell *curCell;

@end

