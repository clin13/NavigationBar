//
//  CollectionViewCell.h
//  NavigationBar
//
//  Created by Jack on 2018/12/29.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (strong, nonatomic) NSString *text;

@end
