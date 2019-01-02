//
//  LabelsTableViewCell.m
//  NavigationBar
//
//  Created by Jack on 2018/12/29.
//

#import "LabelsTableViewCell.h"

@interface LabelsTableViewCell ()

@end

@implementation LabelsTableViewCell

- (UILabel *)label {
    UILabel *label = [[UILabel alloc] init];
    // Do not translate autoresizing mask to constraints
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:label];

    return label;
}

- (UIView *)divider {
    UIView *view = [[UIView alloc] init];

    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1.0/[[UIScreen mainScreen] scale]]];
    view.backgroundColor = [UIColor lightGrayColor];

    [self.contentView addSubview:view];

    return view;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = NO;
    
    self.label1 = [self label];
    self.label2 = [self label];
    self.label3 = [self label];
    self.divider1 = [self divider];
    self.divider2 = [self divider];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_label1, _label2, _label3, _divider1, _divider2);

    // Set up spacing between each label
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_label1(22)]-2-[_divider1(1)]-2-[_label2(70)]-5-[_divider2(1)]-2-[_label3]-5-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views];
    [self.contentView addConstraints:constraints];

    NSArray *horizontal1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_divider1]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:horizontal1];

    NSArray *horizontal2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_divider2]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:horizontal2];

    //NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-1-[_label3(310)]" options:0 metrics:nil views:views];

    //[self.contentView addConstraints:vertical];

    return self;
}

@end
