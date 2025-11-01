//
//  HNNewsDetailViewController.m
//  testioss
//
//  Created by clearzero22 on 2025/11/1.
//

#import "HNNewsDetailViewController.h"
#import <UIKit/UIKit.h>

@interface HNNewsDetailViewController ()

@property (nonatomic, strong) HNStory *story;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *metaLabel;
@property (nonatomic, strong) UILabel *urlLabel;
@property (nonatomic, strong) UIButton *openURLButton;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@end

@implementation HNNewsDetailViewController

- (instancetype)initWithStory:(HNStory *)story {
    self = [super init];
    if (self) {
        _story = story;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self configureWithStory];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    
    // Scroll View
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    // Content View
    self.contentView = [[UIView alloc] init];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.contentView];
    
    // Card View for content
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor systemBackgroundColor];
    cardView.layer.cornerRadius = 16;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 4);
    cardView.layer.shadowRadius = 12;
    cardView.layer.shadowOpacity = 0.15;
    cardView.layer.masksToBounds = NO;
    cardView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:cardView];
    
    // Title Label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    self.titleLabel.textColor = [UIColor labelColor];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cardView addSubview:self.titleLabel];
    
    // URL Label
    self.urlLabel = [[UILabel alloc] init];
    self.urlLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.urlLabel.textColor = [UIColor systemBlueColor];
    self.urlLabel.numberOfLines = 2;
    self.urlLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [cardView addSubview:self.urlLabel];
    
    // Meta Container View
    UIView *metaContainer = [[UIView alloc] init];
    metaContainer.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    metaContainer.layer.cornerRadius = 12;
    metaContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [cardView addSubview:metaContainer];
    
    // Meta Label
    self.metaLabel = [[UILabel alloc] init];
    self.metaLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
    self.metaLabel.textColor = [UIColor labelColor];
    self.metaLabel.numberOfLines = 0;
    self.metaLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [metaContainer addSubview:self.metaLabel];
    
    // Open URL Button
    self.openURLButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.openURLButton setTitle:@"🌐 Open in Safari" forState:UIControlStateNormal];
    self.openURLButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    [self.openURLButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.openURLButton.backgroundColor = [UIColor systemOrangeColor];
    self.openURLButton.layer.cornerRadius = 12;
    self.openURLButton.layer.shadowColor = [UIColor systemOrangeColor].CGColor;
    self.openURLButton.layer.shadowOffset = CGSizeMake(0, 2);
    self.openURLButton.layer.shadowRadius = 4;
    self.openURLButton.layer.shadowOpacity = 0.3;
    [self.openURLButton addTarget:self action:@selector(openURLButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.openURLButton.translatesAutoresizingMaskIntoConstraints = NO;
    [cardView addSubview:self.openURLButton];
    
    // Loading Indicator
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.loadingIndicator.color = [UIColor systemOrangeColor];
    self.loadingIndicator.center = self.view.center;
    self.loadingIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.loadingIndicator];
    
    [self setupConstraintsWithCardView:cardView metaContainer:metaContainer];
}

- (void)setupConstraintsWithCardView:(UIView *)cardView metaContainer:(UIView *)metaContainer {
    [NSLayoutConstraint activateConstraints:@[
        // Scroll View
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
        // Content View
        [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.contentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor],
        
        // Card View
        [cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20],
        [cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-20],
        
        // Title Label
        [self.titleLabel.topAnchor constraintEqualToAnchor:cardView.topAnchor constant:24],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:cardView.leadingAnchor constant:24],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:cardView.trailingAnchor constant:-24],
        
        // URL Label
        [self.urlLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:16],
        [self.urlLabel.leadingAnchor constraintEqualToAnchor:cardView.leadingAnchor constant:24],
        [self.urlLabel.trailingAnchor constraintEqualToAnchor:cardView.trailingAnchor constant:-24],
        
        // Meta Container
        [metaContainer.topAnchor constraintEqualToAnchor:self.urlLabel.bottomAnchor constant:20],
        [metaContainer.leadingAnchor constraintEqualToAnchor:cardView.leadingAnchor constant:24],
        [metaContainer.trailingAnchor constraintEqualToAnchor:cardView.trailingAnchor constant:-24],
        
        // Meta Label
        [self.metaLabel.topAnchor constraintEqualToAnchor:metaContainer.topAnchor constant:16],
        [self.metaLabel.leadingAnchor constraintEqualToAnchor:metaContainer.leadingAnchor constant:16],
        [self.metaLabel.trailingAnchor constraintEqualToAnchor:metaContainer.trailingAnchor constant:-16],
        [self.metaLabel.bottomAnchor constraintEqualToAnchor:metaContainer.bottomAnchor constant:-16],
        
        // Open URL Button
        [self.openURLButton.topAnchor constraintEqualToAnchor:metaContainer.bottomAnchor constant:24],
        [self.openURLButton.centerXAnchor constraintEqualToAnchor:cardView.centerXAnchor],
        [self.openURLButton.bottomAnchor constraintEqualToAnchor:cardView.bottomAnchor constant:-24],
        [self.openURLButton.heightAnchor constraintEqualToConstant:50],
        [self.openURLButton.leadingAnchor constraintEqualToAnchor:cardView.leadingAnchor constant:24],
        [self.openURLButton.trailingAnchor constraintEqualToAnchor:cardView.trailingAnchor constant:-24]
    ]];
}

- (void)configureWithStory {
    self.title = @"📰 Story Details";
    self.titleLabel.text = self.story.title ?: @"No Title";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    NSMutableAttributedString *metaInfo = [[NSMutableAttributedString alloc] init];
    
    // Author
    NSAttributedString *authorText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"👤 Posted by %@", self.story.author ?: @"Anonymous"] 
                                                                      attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15 weight:UIFontWeightMedium]}];
    [metaInfo appendAttributedString:authorText];
    
    // Score and Comments
    NSAttributedString *statsText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n⬆️ %@ points • 💬 %@ comments", self.story.score ?: @"0", self.story.commentCount ?: @"0"] 
                                                                      attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15 weight:UIFontWeightRegular]}];
    [metaInfo appendAttributedString:statsText];
    
    // Date
    NSString *dateString = self.story.createdAt ? [formatter stringFromDate:self.story.createdAt] : @"Unknown date";
    NSAttributedString *dateText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n📅 %@", dateString] 
                                                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15 weight:UIFontWeightRegular]}];
    [metaInfo appendAttributedString:dateText];
    
    self.metaLabel.attributedText = metaInfo;
    
    if (self.story.url) {
        NSURL *url = [NSURL URLWithString:self.story.url];
        NSString *domain = url.host ?: @"External Link";
        if ([domain hasPrefix:@"www."]) {
            domain = [domain substringFromIndex:4];
        }
        self.urlLabel.text = [NSString stringWithFormat:@"🔗 %@", domain];
        self.openURLButton.hidden = NO;
    } else {
        self.urlLabel.text = @"📝 Text Post";
        self.openURLButton.hidden = YES;
    }
}

- (void)openURLButtonTapped {
    if (!self.story.url) return;
    
    NSURL *url = [NSURL URLWithString:self.story.url];
    if (!url) return;
    
    // Add haptic feedback
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [generator impactOccurred];
    
    // Open URL in Safari
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end