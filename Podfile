inhibit_all_warnings!
use_frameworks!
workspace 'KRLCollectionViewGridLayout.xcworkspace'

podspec :path => './KRLCollectionViewGridLayout.podspec'

def testing_pods
    pod 'OCHamcrest', :git => 'https://github.com/klundberg/OCHamcrest.git', :branch => 'master'
end

target :iOSTests, :exclusive => true do
    platform :ios, '8.0'
    link_with 'KRLCollectionViewGridLayout-iOSTests'
    testing_pods
end

target :tvOSTests, :exclusive => true do
    platform :tvos, '9.0'
    link_with 'KRLCollectionViewGridLayout-tvOSTests'
    testing_pods
end
