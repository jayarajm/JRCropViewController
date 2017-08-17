Pod::Spec.new do |s|
  s.name     = 'JRCropViewController'
  s.version  = '2.0.12'
  s.license  =  { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'A view controller that allows users to crop UIImage objects.'
  s.homepage = 'https://github.com/jayarajm/JRCropViewController'
  s.author   = 'Tim Oliver'
  s.source   = { :git => 'https://github.com/jayarajm/JRCropViewController', :tag => s.version }
  s.platform = :ios, '7.0'

  s.source_files = 'JRCropViewController/**/*.{h,m}'
  s.resource_bundles = {
    'JRCropViewControllerBundle' => ['JRCropViewController/**/*.lproj']
  }
  s.requires_arc = true
end
