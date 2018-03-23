Pod::Spec.new do |s|
    s.name         = 'CardBannerView'
    s.version      = '0.0.1'
    s.summary      = 'a cardview on iOS'
    s.homepage     = 'https://github.com/lx213/CardBannerView/'
    s.license      = 'MIT'
    s.authors      = {'lx123' => '381806973@qq.com'}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'https://github.com/lx213/CardBannerView.git', :tag => s.version}
    s.source_files = 'CardBannerView','CardBannerView/**/*.swift'
end