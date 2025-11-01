//
//  HNStoryTableViewCell.m
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import "HNStoryTableViewCell.h"
#import "HNStory.h"

@implementation HNStoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Card View
    self.cardView = [[UIView alloc] init];
    self.cardView.backgroundColor = [UIColor systemBackgroundColor];
    self.cardView.layer.cornerRadius = 12;
    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowOffset = CGSizeMake(0, 2);
    self.cardView.layer.shadowRadius = 8;
    self.cardView.layer.shadowOpacity = 0.1;
    self.cardView.layer.masksToBounds = NO;
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.cardView];
    
    // Title Label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.titleLabel.textColor = [UIColor labelColor];
    self.titleLabel.numberOfLines = 3;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cardView addSubview:self.titleLabel];
    
    // Subtitle Label (URL)
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    self.subtitleLabel.textColor = [UIColor systemBlueColor];
    self.subtitleLabel.numberOfLines = 1;
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cardView addSubview:self.subtitleLabel];
    
    // Meta Label
    self.metaLabel = [[UILabel alloc] init];
    self.metaLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.metaLabel.textColor = [UIColor secondaryLabelColor];
    self.metaLabel.numberOfLines = 1;
    self.metaLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cardView addSubview:self.metaLabel];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [NSLayoutConstraint activateConstraints:@[
        // Card View
        [self.cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:8],
        [self.cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [self.cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-8],
        
        // Title Label
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:16],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:16],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-16],
        
        // Subtitle Label
        [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:8],
        [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:16],
        [self.subtitleLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-16],
        
        // Meta Label
        [self.metaLabel.topAnchor constraintEqualToAnchor:self.subtitleLabel.bottomAnchor constant:8],
        [self.metaLabel.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:16],
        [self.metaLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-16],
        [self.metaLabel.bottomAnchor constraintEqualToAnchor:self.cardView.bottomAnchor constant:-16]
    ]];
}

- (void)configureWithStory:(HNStory *)story {
    self.titleLabel.text = story.title ?: @"No Title";
    
    // Format URL for subtitle
    if (story.url) {
        NSURL *url = [NSURL URLWithString:story.url];
        NSString *domain = url.host;
        if (domain) {
            // Remove www. prefix
            if ([domain hasPrefix:@"www."]) {
                domain = [domain substringFromIndex:4];
            }
            self.subtitleLabel.text = [NSString stringWithFormat:@"🔗 %@", domain];
        } else {
            self.subtitleLabel.text = @"🔗 External Link";
        }
    } else {
        self.subtitleLabel.text = @"📝 Text Post";
    }
    
    // Format meta information
    NSString *metaInfo = [NSString stringWithFormat:@"⬆️ %@ • 💬 %@ • %@", 
                         story.score ?: @"0",
                         story.commentCount ?: @"0",
                         story.author ?: @"anonymous"];
    
    self.metaLabel.text = metaInfo;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [UIView animateWithDuration:0.1 animations:^{
            self.cardView.transform = CGAffineTransformMakeScale(0.98, 0.98);
            self.cardView.alpha = 0.8;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.cardView.transform = CGAffineTransformIdentity;
            self.cardView.alpha = 1.0;
        }];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.titleLabel.text = nil;
    self.subtitleLabel.text = nil;
    self.metaLabel.text = nil;
}

@end