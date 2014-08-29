Pod::Spec.new do |s|
  s.name     = 'EGOTableViewPullRefreshAndLoadMore'
  s.version  = '1.0.1'
  s.author   = { 'JackShi' => 'shiguifei@gmail.com' }
  s.homepage = 'https://github.com/JackShi/EGOTableViewPullRefreshAndLoadMore'
  s.summary  = 'Inspired by EGOTableViewPullRefresh, pull down to refresh, pull up to load more'
  s.license  = { :type => 'MIT', :file => 'License' }
  s.source   = { :git => 'https://github.com/JackShi/EGOTableViewPullRefreshAndLoadMore.git', :tag => '1.0.1' }
  s.source_files = 'EGOTableViewPullRefreshAndLoadMore/EGORefreshClass/*.{h,m}','EGOTableViewPullRefreshAndLoadMore/LoadMoreClass/*.{h,m}'
  s.resources = "EGOTableViewPullRefreshAndLoadMore/Resources/*"
  s.platform = :ios
  s.requires_arc = true
end
