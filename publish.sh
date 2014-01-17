XCODE_SHELL="/Users/leshu-2/Documents/repository/xcode_shell"
SHARE_ROOT="/Users/leshu-2/Documents/repository/leshu/sjsg/shared"
PUBLISH_IOS="/Users/leshu-2/Documents/repository/leshu/sjsg/published/IOS"

cd ${XCODE_SHELL}/

# get publish date
DATE=$(date +%Y%m%d%H%M)
echo $DATE

cat << EOF >version.json
{
    "version":$DATE,
	"resource":$DATE
}
EOF

# git reset remove pull
echo start pull resources and codes......................
cd ../leshu/sjsg/
git clean -d -f
git reset --hard HEAD
git pull
git submodule init
git submodule update
cd libs/cocos2d-x/
git submodule init
git submodule update

# excel to json
echo start convert excel to json.....................
cd ${SHARE_ROOT}/
python excel2json.py batch
cd ${XCODE_SHELL}/

# copy json to publish directory
echo start copy json file ...........................
if [ -d "$PUBLISH_IOS"/data ]; then
    rm -rf "$PUBLISH_IOS"/data
fi

mkdir "$PUBLISH_IOS"/data

for file in "$SHARE_ROOT"/res/data/*
    do
    if [ -d "$file" ]; then
        cp -rf "$file" "$PUBLISH_IOS"/data
    fi
    
    if [ -f "$file" ]; then
        cp "$file" "$PUBLISH_IOS"/data
    fi
done

# copy configlist file to publish dir
for file in "$SHARE_ROOT"/res/config.plist
    do
    if [ -d "$file" ]; then
        cp -rf "$file" "$PUBLISH_IOS"/config.plist
    fi
    
    if [ -f "$file" ]; then
        cp "$file" "$PUBLISH_IOS"/config.plist
    fi
done

for file in "$XCODE_SHELL"/version.json
    do
    if [ -d "$file" ]; then
        cp -rf "$file" "$PUBLISH_IOS"/version.json
    fi
    
    if [ -f "$file" ]; then
        cp "$file" "$PUBLISH_IOS"/version.json
    fi
done

#start publish ipa to php 
echo start publish ipa...................................
./ipa-build /Users/leshu-2/Documents/repository/leshu/sjsg/proj.ios -c Debug -o ~/Desktop/ -t MyGame  -p 拳皇世界 -n
./ipa-publish /Users/leshu-2/Documents/repository/leshu/sjsg/proj.ios

#./ipa-build /Users/leshu-2/Documents/repository/leshu/sjsg/proj.ios -c share -o ~/#Desktop/ -t AnimationPro91  -p 烽火战神91
#./ipa-publish /Users/leshu-2/Documents/repository/leshu/sjsg/proj.ios

#./ipa-build /Users/leshu-2/Documents/repository/leshu/sjsg/proj.ios -c share -o ~/#Desktop/ -t DramaPlayer  -p 剧本播放器
#./ipa-publish /Users/leshu-2/Documents/repository/leshu/sjsg/proj.ios
