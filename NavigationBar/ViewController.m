//
//  ViewController.m
//  NavigationBar
//
//  Created by Jack on 2018/12/29.
//

#import "ViewController.h"
#import "LabelsTableViewCell.h"
#import "CollectionView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self loadPlantInfo];
}

- (void) initUI {
    Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taipei_zoo.jpg"]];
    Image.frame = CGRectMake(0, -64, screenWidth, 260);
    Image.contentMode = UIViewContentModeScaleAspectFit;
    self.tableView.tableHeaderView = Image;
    //self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    barImage = self.navigationController.navigationBar.subviews.firstObject;

    // Background image of navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];

    // Shadow image of navigation bar
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    // Multiple labels of each TableViewCell
    [self.tableView registerClass:[LabelsTableViewCell class] forCellReuseIdentifier:cellID];

    // Separator style of the table view
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _cellList = [[NSMutableArray alloc] init];  // Array for cells to calculate text length
    _updated = YES;
}

// Get Opendata from URL with JSON format
- (NSDictionary *) getJSONField:(NSInteger) offset {
    NSError *error;

    // Concatenate URL with parameters of limit and offset
    NSString *limitString = [NSString stringWithFormat:@"limit=%ld", (long)limit];
    urlZooPlant = [@[taipeiOpendata, zooPlantRID, limitString, _offset] componentsJoinedByString:@"&"];
    NSString *urlWithOffset = [NSString stringWithFormat:@"%@%ld", urlZooPlant, (long)offset];

    // Retrieve JSON data from URL
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlWithOffset]];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    return json;
}

// Update plant list
- (NSMutableArray *) loadPlantInfo {
    if (!_plants || !_updated) {
        NSMutableArray *onePlant;

        if (!_plants)
            _plants = [[NSMutableArray alloc] init];

        // Get 20 records each time from URL
        NSDictionary *resultJSON = [self getJSONField:_currentOffset];

        // No new record found
        if ([resultJSON[@"result"][@"results"] count] == 0) {
            return _plants;
        }

        // Print specific field
        if (!DEBUG) {
            NSLog(@"Chinese name: %@", [resultJSON[@"result"][@"results"] valueForKeyPath:@"F_Name_Ch"][0]);
            NSLog(@"Location: %@", [resultJSON[@"result"][@"results"] valueForKeyPath:@"F_Location"][0]);
        }

        for (int i = 0; i < limit; i++) {
            onePlant = [[NSMutableArray alloc] init];

            @try {
                [onePlant addObject:[resultJSON[@"result"][@"results"] valueForKeyPath:@"F_Name_Ch"][i]];
                [onePlant addObject:[resultJSON[@"result"][@"results"] valueForKeyPath:@"F_Location"][i]];
                [onePlant addObject:[resultJSON[@"result"][@"results"] valueForKeyPath:@"F_Feature"][i]];

                [_plants addObject:onePlant];
            }
            @catch (NSException * e) {
                NSLog(@"Failed to add new record");
                return _plants;
            }
        }
        _updated = YES;
    }

    return _plants;
}

#pragma mark TableView

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self loadPlantInfo].count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LabelsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LabelsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    cell.label1.text = _plants[indexPath.row][0];
    cell.label2.text = _plants[indexPath.row][1];
    cell.label3.text = _plants[indexPath.row][2];

    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.label1.numberOfLines = 0;      // Allow multiple lines
    cell.label2.numberOfLines = 0;
    cell.label3.numberOfLines = 0;

    [_cellList addObject:cell];
    [cell layoutIfNeeded];

    // CollectionView usage
    //cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;

    /*CollectionView *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

    if (!cell) {
        cell = [[CollectionView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSLog(@"tableView_cellForRow_1");
    cell.plantList = [[self loadPlantInfo] objectAtIndex:indexPath.row];
    NSLog(@"tableView_cellForRow_2");
    cell.collectionView.delegate = cell;
    cell.collectionView.dataSource = cell;
    [cell reloadInputViews];*/

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_cellList.count != 0 && indexPath.row < _cellList.count) {
        LabelsTableViewCell *tmpCell = [_cellList objectAtIndex:indexPath.row];
        UILabel *targetLabel;
        CGFloat height;

        [tmpCell layoutIfNeeded];
        _curCell = tmpCell;

        // Which label text to use
        if (tmpCell.label3.text.length > tmpCell.label2.text.length)
            targetLabel = tmpCell.label3;
        else
            targetLabel = tmpCell.label2;

        int topPadding = targetLabel.frame.origin.x;
        int bottomPadding = tmpCell.frame.size.height - (topPadding + targetLabel.frame.size.height);

        NSString *text = targetLabel.text;
        CGSize maximumSize = CGSizeMake(targetLabel.frame.size.width, MAXFLOAT);
        CGRect rect = [text boundingRectWithSize:maximumSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0]} context:nil];

        height = tmpCell.frame.size.height - (rect.size.height + bottomPadding);

        if (height > 230)
            return height + 240;
        return  height + 90;
    }
    else
        return 550;
}


#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat minOffset = -64;
    CGFloat maxOffset = 200;
    CGFloat offset = scrollView.contentOffset.y;
    barImage.alpha = (offset - minOffset) / (maxOffset - minOffset);
    self.title = barImage.alpha >= 1 ? title : @"";

    [_curCell layoutIfNeeded];
    // Change alpha of navigation bar
    self.navigationController.navigationBar.translucent = barImage.alpha >= 1 ? 0 : 1;
    if (barImage.alpha <= 1) {
        self.navigationController.navigationBar.alpha = barImage.alpha;
    }

    CGFloat scrollViewHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height;

    // If scroll to the bottom of table view
    if (scrollViewHeight + roundf(offset) == roundf(scrollContentSizeHeight)) {
        if (_updated) {
            _updated = NO;
            _currentOffset += limit;
            [self loadPlantInfo];
            [_tableView reloadData];
        }
    }
}

@end
