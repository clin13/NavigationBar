//
//  CollectionViewCell.m
//  NavigationBar
//
//  Created by Jack on 2018/12/29.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void) reloadInputViews {
    self.labelText.text = self.text;
}

- (void) drawRect:(CGRect)rect {
    [self reloadInputViews];
}

@end
