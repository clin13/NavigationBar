//
//  CollectionView.h
//  NavigationBar
//
//  Created by Jack on 2018/12/29.
//

#import <UIKit/UIKit.h>

@interface CollectionView : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *plantList;

@end
