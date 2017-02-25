inhibit_all_warnings!
use_frameworks!
workspace 'KRLCollectionViewGridLayout.xcworkspace'

podspec :path => './KRLCollectionViewGridLayout.podspec'

def testing_pods
    pod 'OCHamcrest'
end

target 'KRLCollectionViewGridLayout-iOSTests' do
    inherit! :search_paths
    platform :ios, '8.0'

    testing_pods
end

target 'KRLCollectionViewGridLayout-tvOSTests' do
    inherit! :search_paths
    platform :tvos, '9.0'

    testing_pods
end
