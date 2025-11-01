//
//  HNStoryTableViewCell.m
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import "HNStoryTableViewCell.h"
#import "HNStory.h"
#import "HNThemeManager.h"

@implementation HNStoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    HNThemeManager *themeManager = [HNThemeManager sharedManager];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Card View
    self.cardView = [[UIView alloc] init];
    self.cardView.backgroundColor = themeManager.cardBackgroundColor;
    self.cardView.layer.cornerRadius = 8;
    self.cardView.layer.masksToBounds = NO;
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.cardView];
    
    // Apply hacker theme effects
    [themeManager createHackerEffectsForView:self.cardView];
    
    // Title Label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:16];
    self.titleLabel.textColor = themeManager.primaryTextColor;
    self.titleLabel.numberOfLines = 3;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cardView addSubview:self.titleLabel];
    
    // Subtitle Label (URL)
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.font = [UIFont fontWithName:@"Courier" size:13];
    self.subtitleLabel.textColor = themeManager.accentColor;
    self.subtitleLabel.numberOfLines = 1;
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cardView addSubview:self.subtitleLabel];
    
    // Meta Label
    self.metaLabel = [[UILabel alloc] init];
    self.metaLabel.font = [UIFont fontWithName:@"Courier" size:12];
    self.metaLabel.textColor = themeManager.secondaryTextColor;
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
    HNThemeManager *themeManager = [HNThemeManager sharedManager];
    
    // Format title with hacker style
    NSString *title = story.title ?: @"[NULL_DATA]";
    self.titleLabel.text = [NSString stringWithFormat:@"> %@", title];
    
    // Format URL for subtitle with hacker style
    if (story.url) {
        NSURL *url = [NSURL URLWithString:story.url];
        NSString *domain = url.host;
        if (domain) {
            // Remove www. prefix
            if ([domain hasPrefix:@"www."]) {
                domain = [domain substringFromIndex:4];
            }
            self.subtitleLabel.text = [NSString stringWithFormat:@"[ACCESSING] %@/", domain];
        } else {
            self.subtitleLabel.text = @"[ACCESSING] unknown.host/";
        }
    } else {
        self.subtitleLabel.text = @"[LOCAL] system.log/";
    }
    
    // Format meta information with hacker style
    NSString *author = story.author ?: @"anonymous";
    NSString *metaInfo = [NSString stringWithFormat:@"[USER:%@] [SCORE:%@] [COMMENTS:%@]", 
                         author,
                         story.score ?: @"0",
                         story.commentCount ?: @"0"];
    
    self.metaLabel.text = metaInfo;
    
    // Add random color variation to primary text
    if (arc4random_uniform(4) == 0) {
        self.titleLabel.textColor = [themeManager randomHackerColor];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    HNThemeManager *themeManager = [HNThemeManager sharedManager];
    
    if (highlighted) {
        // Hacker-style highlight effect
        [UIView animateWithDuration:0.15 animations:^{
            self.cardView.transform = CGAffineTransformMakeScale(0.95, 0.95);
            self.cardView.alpha = 0.7;
            self.cardView.backgroundColor = themeManager.highlightColor;
            self.titleLabel.textColor = [UIColor whiteColor];
        }];
        
        // Add glitch effect
        [self addGlitchEffect];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.cardView.transform = CGAffineTransformIdentity;
            self.cardView.alpha = 1.0;
            self.cardView.backgroundColor = themeManager.cardBackgroundColor;
            self.titleLabel.textColor = themeManager.primaryTextColor;
        }];
    }
}

- (void)addGlitchEffect {
    HNThemeManager *themeManager = [HNThemeManager sharedManager];
    
    // Quick color flash glitch
    NSArray *glitchColors = @[
        themeManager.highlightColor,
        themeManager.accentColor,
        [UIColor whiteColor],
        themeManager.primaryTextColor
    ];
    
    for (int i = 0; i < 3; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.titleLabel.textColor = glitchColors[i % glitchColors.count];
        });
    }
    
    // Reset to original color after glitch
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.titleLabel.textColor = themeManager.primaryTextColor;
    });
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.titleLabel.text = nil;
    self.subtitleLabel.text = nil;
    self.metaLabel.text = nil;
}

@end